# Claude Code Configuration: Integration Guide

How to wire the reliability hierarchy into a companion project. Each layer builds on the previous — start with Layer 1 and add layers as the companion matures.

---

## Quick Start: Minimum Viable Configuration

For lightweight companions or early-stage projects, this is the minimum that makes a difference:

1. **One SessionStart hook** with 3-5 critical rules
2. **CLAUDE.md under 100 lines** focused on identity and cross-cutting constraints
3. **One skill** for any multi-step workflow the companion will use repeatedly

This alone eliminates the most common failure modes: instructions lost to compaction, CLAUDE.md attention degradation, and procedural non-compliance.

---

## Layer 1: Hook Setup

Hooks go in `.claude/settings.json` at the companion root. They fire deterministically — no interpretation, no "may or may not be relevant."

### SessionStart Hook (Most Important)

Fires at startup AND after every context compaction. This is the only mechanism that automatically re-injects context when compaction drops it.

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "cat .claude/hooks/session-start.md"
      }
    ]
  }
}
```

Create `.claude/hooks/session-start.md`:

```markdown
# Session Rules (Injected Every Session + Post-Compaction)

1. Check for applicable skills BEFORE responding to any task.
2. Execute commands step by step as written. Follow the specification exactly.
3. Declare collected values between phases before proceeding.
4. [Your critical rule here]
5. [Your critical rule here]
```

**What to customize per companion:**
- Replace rules 4-5 with the companion's most-violated instructions
- If the companion has skills, rule 1 ensures they get checked
- If the companion has multi-phase commands, rules 2-3 prevent the "reasoning vs executing" failure

### UserPromptSubmit Hook (Per-Turn Reinforcement)

Fires before every response. Use sparingly — this adds tokens to every turn.

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "cat .claude/hooks/per-turn.md"
      }
    ]
  }
}
```

Create `.claude/hooks/per-turn.md`:

```markdown
# Per-Turn Check
- If this task involves a skill, invoke it before responding.
- If this task involves client communication, follow communication standards exactly.
```

**When to use**: Only when a specific behavior is failing on individual turns despite SessionStart reinforcement. Most companions don't need this.

### PreCompact Hook (State Preservation)

Fires before context compaction. Use to preserve state that would otherwise be lost.

```json
{
  "hooks": {
    "PreCompact": [
      {
        "type": "command",
        "command": "cat .claude/hooks/pre-compact.md"
      }
    ]
  }
}
```

Create `.claude/hooks/pre-compact.md`:

```markdown
# Before Compaction
Save current task state to a checkpoint file if mid-workflow.
```

**When to use**: Only for companions with long-running sessions that frequently hit compaction. Most companions can skip this initially.

### Complete settings.json Template

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "cat .claude/hooks/session-start.md"
      }
    ]
  },
  "permissions": {
    "allow": [],
    "deny": []
  }
}
```

Start with SessionStart only. Add other hooks when specific failure patterns emerge.

---

## Layer 2: CLAUDE.md Template

A lean project identity file. Everything that isn't identity, cross-cutting constraints, or critical context belongs elsewhere.

### Recommended Structure

```markdown
# [Companion Name]

[One sentence: what this companion is and why it exists.]

---

## Your Role

[2-3 sentences: how the companion behaves, its interaction model, its core value.]

## Key Constraints

[3-5 bullet points: things that would cause mistakes if unknown.]

- [Constraint 1]
- [Constraint 2]
- [Constraint 3]

## Project Structure

[Brief directory overview — just enough to orient.]

## [Domain-Specific Section]

[One section for the most important domain context. Keep it focused.]

---

**Last Updated**: [Date]
```

### What Stays in CLAUDE.md

- Project identity (what, why, for whom)
- Interaction model (thinking partner, automation tool, etc.)
- Cross-cutting constraints (confidentiality, review requirements)
- Directory structure orientation
- Critical domain context that applies to all tasks

### What Moves Out

| Content | Moves To | Why |
|---------|----------|-----|
| Workflow procedures ("Step 1, Step 2...") | Skills | On-demand loading; better attention when invoked |
| "ALWAYS do X" rules that keep failing | Hooks | Deterministic enforcement; survives compaction |
| File-specific conventions | Rules (`.claude/rules/`) | Path-scoped; doesn't clutter identity |
| Communication templates | Skills | Loaded only when drafting communications |
| Agent invocation procedures | Skills | Complex procedures need low-freedom skills, not CLAUDE.md guidance |

### Compliance Checkpoint Pattern

For the few procedural rules that do belong in CLAUDE.md (too simple for a skill, too important to omit), use the checkpoint pattern:

```markdown
## Command Execution

When a command is invoked:
1. Read the command definition completely
2. Execute steps IN ORDER
3. **Declare collected values before proceeding to next phase**
4. Build complete prompts with actual values (no placeholders)
```

The checkpoint in step 3 forces the model to demonstrate compliance at generation time.

### Positive Framing Examples

| Instead of | Write |
|-----------|-------|
| "NEVER skip steps" | "Execute steps in order as written" |
| "Do NOT improvise alternatives" | "Follow the specification exactly" |
| "NEVER use wrong model" | "Check agent frontmatter for the correct model" |
| "Do NOT reason about commands" | "Execute commands step by step" |

---

## Layer 3: Skill Definition Template

Skills live in `.claude/skills/` (or `.claude/commands/` — both work, skills are recommended).

### Directory Structure

```
.claude/
├── skills/
│   ├── process-meeting.md       # Multi-step workflow
│   ├── write-followup.md        # Generative task (low freedom)
│   ├── start-day.md             # Daily routine
│   └── communication-standards/ # Supporting files
│       └── email-template.md
```

### Frontmatter Template

```yaml
---
name: process-meeting
description: >
  Transform a meeting transcript into a structured activity log with
  insights, action items, and profile update flags. Use after any
  client meeting.
model: opus
allowed_tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
skills:
  - communication-standards
---
```

**Critical field**: `description` is the primary dispatch mechanism. Write it as if answering "When should this skill activate?" A good description improves activation by 20-50%.

### Freedom Level Examples

**High Freedom** (guidance, principles):

```markdown
## Approach

Consider these factors when analyzing the transcript:
- What decisions were made vs deferred?
- What assumptions surfaced?
- What questions remain open?

Organize findings into the most natural structure for this conversation.
```

**Medium Freedom** (structured workflow):

```markdown
## Process

1. Read the transcript
2. Extract decisions, action items, and open questions
3. Categorize findings by topic area
4. Write activity log following the template in `templates/activity-log.md`
5. Flag any items that suggest profile updates
```

**Low Freedom** (critical procedures — use for generative tasks and multi-phase workflows):

```markdown
## Process

### Phase 1: Validate Inputs

Step 1: Resolve client name
- Search `clients/ActiveClients/` for matching directory
- If not found, list available clients and ask

Step 2: Locate meeting transcript
- Check Granola for most recent meeting with this client
- If multiple found, list them and ask which to process

Step 3: Verify prerequisites
- Living profile must exist at `clients/ActiveClients/[Client]/living-profile.md`
- If not found, STOP and inform user

**Output collected values before proceeding:**
```
Phase 1 Complete:
- Client: [name]
- Meeting: [date and title]
- Profile path: [full path]
```

### Phase 2: Extract and Analyze
[Exact steps continue...]
```

### Checklist Pattern for Multi-Phase Workflows

For workflows with 3+ phases, use explicit phase gates:

```markdown
## Phases

- [ ] Phase 1: Validate inputs → output collected values
- [ ] Phase 2: Extract content → output key findings
- [ ] Phase 3: Generate artifact → output file path
- [ ] Phase 4: Verify output → confirm acceptance criteria met
```

Each checkbox becomes a compliance checkpoint — the model must explicitly mark it before proceeding.

### Agent Skill Preloading

When a skill is listed in an agent's `skills:` frontmatter, it is injected as full text at agent startup. The invoking code should:

1. Read the agent definition and note the `skills:` list
2. Understand that those skills are preloaded — the agent already has them
3. NOT tell the agent to "read the skill" or "use the skill"
4. Build the agent prompt assuming the skill context is available

```yaml
# Agent definition
---
name: email-writer
model: opus
skills:
  - communication-standards  # ← Preloaded. Agent sees full text.
---
```

```
# When invoking this agent:
# CORRECT: Just invoke with the task prompt
# WRONG: "First, read the communication-standards skill..."
```

---

## Layer 4: Agent Definition Template

Agents live in `.claude/agents/`.

### Frontmatter Template

```yaml
---
name: ticket-executor
description: Implements a single ticket from the build plan
model: opus
allowed_tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
skills:
  - code-standards
---
```

### Prompt Building Guidance

Because agents have no conversation context, build complete prompts with this structure:

```
[DEFINITION OF DONE — what success looks like]
[Appears first for primacy effect]

[CONTEXT — files to read, current state, background]
[Middle section — important but not critical positioning]

[CONSTRAINTS — what must NOT happen, format requirements]
[Appears last for recency effect]
```

**Example:**

```
You are implementing ticket #3: Add authentication middleware.

DEFINITION OF DONE:
- File `src/middleware/auth.ts` exists with JWT validation
- Tests pass in `tests/middleware/auth.test.ts`
- No other files modified

CONTEXT:
- Project uses Express.js with TypeScript
- Existing middleware pattern: [paste from src/middleware/logging.ts]
- Auth requirements: [paste from context/requirements.md section on auth]

CONSTRAINTS:
- Do not modify any existing middleware files
- Use the jsonwebtoken package (already in package.json)
- Follow the test pattern in tests/middleware/logging.test.ts
```

### Model Selection Guide

| Model | Cost | Use For |
|-------|------|---------|
| Haiku | Low | File search, pattern matching, simple extraction |
| Sonnet | Medium | Structured analysis, verification, code review |
| Opus | High | Complex reasoning, generative tasks, multi-step implementation |

**Rule of thumb**: If the agent needs to make judgment calls or produce original content, use Opus. If it's transforming structured input to structured output, Sonnet suffices. If it's just finding files or extracting data, Haiku works.

### Tool Scoping

Always whitelist tools explicitly. An agent with no tools can only think — it can't read files, write code, or search. Common tool sets:

- **Read-only agent** (verifier): Read, Glob, Grep
- **Implementation agent** (executor): Read, Write, Edit, Glob, Grep, Bash
- **Research agent** (explorer): Read, Glob, Grep, WebSearch, WebFetch

---

## Layer 5: Rules Setup

Rules live in `.claude/rules/` and apply to specific file types or directories.

### Path-Scoping Examples

**For test files:**
```yaml
---
globs: ["tests/**", "**/*.test.*"]
---
Follow AAA pattern (Arrange, Act, Assert). Each test tests one behavior.
Never mock the module under test.
```

**For client-facing documents:**
```yaml
---
globs: ["templates/**", "**/emails/**", "**/communications/**"]
---
Follow communication standards: lead with core insight, eliminate fluff,
use specific facts over vague qualifiers. No praising language.
```

**For activity logs:**
```yaml
---
globs: ["**/Activity Logs/**"]
---
Use the standard activity log format. Include time estimates.
Flag profile updates with [PROFILE UPDATE] prefix.
```

### When Rules vs CLAUDE.md

| Situation | Use |
|-----------|-----|
| Applies to all files and tasks | CLAUDE.md |
| Applies to specific file types | Rules with glob pattern |
| Applies to specific directories | Rules with directory glob |
| Is a coding convention | Rules scoped to code files |
| Is a project identity statement | CLAUDE.md |

---

## Layer 6: Token Efficiency Checklist

### Pre-Session
- [ ] Is the task clear enough to start? (Vague tasks burn tokens on exploration)
- [ ] Is the context from previous sessions captured in files? (Don't rely on conversation memory)
- [ ] Would `/clear` help? (If switching to an unrelated task, always clear)

### Mid-Session
- [ ] Is context usage approaching 70%? (Performance degrades ~25% beyond this)
- [ ] Are verbose operations delegated to subagents? (Detail stays isolated; summary returns)
- [ ] Are prompts specific? ("Find auth middleware in src/middleware/" not "look at auth code")

### Post-Session
- [ ] Is session state captured in files? (Checkpoints, progress tracking)
- [ ] Are any insights worth encoding in configuration? (New rule, updated skill, new hook)

---

## Persona-Specific Application

### Product Manager Companions

PM companions are the heaviest users of this capability:
- **Skills**: Every workflow is a skill (intake, process, gaps, plan, build). Use LOW freedom for generative tasks (email drafting, report generation). Medium freedom for structured extraction (transcript processing).
- **Agents**: Multiple agent types (executor, verifier, writer). Always specify model in frontmatter. Preload communication skills.
- **Hooks**: SessionStart with skill-checking reminder. Consider UserPromptSubmit for communication standards enforcement.
- **CLAUDE.md**: Project identity, client constraints, billing model. Move all workflow details to skills.

### Software Developer Companions

SE companions are lighter on enforcement during implementation but heavier during planning:
- **Skills**: Plan and build commands need LOW freedom. Implementation commands can be MEDIUM.
- **Agents**: Executor/verifier pattern for build. Haiku for code search, Opus for implementation.
- **Hooks**: SessionStart with code conventions. Rules for file-specific patterns.
- **CLAUDE.md**: Tech stack, architecture decisions, testing requirements. Short and focused.

### Game Designer Companions

Game design companions emphasize the preloading pattern for framework-heavy analysis:
- **Skills**: Framework analysis skills preloaded into agents. Insight capture skills at LOW freedom.
- **Agents**: Heavy use of preloaded skills — agents need full framework context to do useful analysis.
- **Hooks**: SessionStart with insight capture reminder (non-optional in game design persona).
- **CLAUDE.md**: Design philosophy, framework references, two-layer doc structure.

---

## Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| No hooks at all | Instructions forgotten after compaction | Add SessionStart hook with critical rules |
| Workflow procedures in CLAUDE.md | Steps get skipped or reordered | Move to skills with compliance checkpoints |
| High-freedom skills for generative tasks | Output varies wildly between invocations | Lower the freedom level; add output schemas |
| Agents without tool whitelists | Agent says it completed work but no files created | Always specify `allowed_tools` |
| Telling agents to read preloaded skills | Wasted tokens, confused context | Trust `skills:` frontmatter means preloaded |
| CLAUDE.md over 200 lines | Later sections get less attention | Apply deletion test; distribute to skills/rules/hooks |
| Same enforcement for all tasks | Structured extraction over-constrained; generative tasks under-constrained | Match enforcement to task type |
