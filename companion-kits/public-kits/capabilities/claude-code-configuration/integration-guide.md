# Claude Code Configuration: Integration Guide

How to wire the reliability hierarchy into a companion project. Each layer builds on the previous — start with Layer 1 and add layers as the companion matures.

---

## Quick Start: Minimum Viable Configuration

For lightweight companions or early-stage projects, this is the minimum that makes a difference:

1. **One SessionStart hook** with 3-5 critical rules
2. **CLAUDE.md under 100 lines** focused on identity and cross-cutting constraints
3. **One skill** for any multi-step workflow the companion will use repeatedly
4. **One orchestrator skill** for your most common workflow (if it dispatches to an agent)

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

## The Orchestration Pattern

Before defining individual layers, understand how they compose. The three-layer architecture is the most important design pattern for reliable companion workflows.

### Architecture

```
USER → ORCHESTRATOR (skill) → AGENT (subagent) ← REFERENCE SKILL (preloaded)
       validates inputs         does heavy work     defines standards
       sequences phases         reads many files     tone, format, conventions
       dispatches to agent      synthesizes content  sole authority on its domain
       presents output          self-critiques       DRY across agents
       gates on human approval  returns to caller    injected at startup
```

### Decision Framework: Where Does This Logic Belong?

| Question | Answer | Put It In |
|----------|--------|-----------|
| Does it validate user input or present output? | Yes | Orchestrator |
| Does it require human approval before proceeding? | Yes | Orchestrator |
| Does it read many files and synthesize content? | Yes | Agent |
| Does it generate substantial text (emails, reports)? | Yes | Agent |
| Does it define standards that multiple agents share? | Yes | Reference skill |
| Is it primarily dialogue with the user? | Yes | Single skill (no agent needed) |

### Reference Implementation: write-followup → email-writer + client-communication

This walkthrough shows exactly what each layer does and why.

**Orchestrator: `write-followup`** (skill, `disable-model-invocation: true`)
```
Phase 1: Validate Inputs
  → Resolve client name (check clients/ActiveClients/ directory)
  → Resolve meeting date (find matching activity log)
  → Verify prerequisites (living profile exists, activity log exists)
  → OUTPUT: collected values (client, date, paths)

Phase 2: Dispatch to Agent
  → Read email-writer agent definition
  → Note: model=opus, skills=client-communication
  → Build complete prompt with all validated paths
  → Call Task tool with model=opus

Phase 3: Present Draft
  → Display email draft from agent
  → Show agent's quality self-assessment
  → Present options: Send / Edit / Regenerate / Skip

Phase 4: Human Gate
  → Wait for user decision
  → Never send automatically
```

**Why this is an orchestrator, not a single skill**: It dispatches to an agent that reads 15-35K tokens of context. That synthesis work belongs in an isolated agent context, not in the main conversation.

**Agent: `email-writer`** (model: opus, skills: client-communication)
```
Phase 1: Load Context
  → Read living profile (8 pages, ~20K tokens)
  → Read current activity log (2-3 pages, ~5K tokens)
  → Read prior activity logs if thread continuity detected

Phase 2: Strategy
  → Determine meeting weight (strategic / progress / standup)
  → Plan thread continuity approach
  → Identify possibilities to surface

Phase 3: Draft Email
  → Defer to client-communication skill for structure and tone
  → Apply content selection, thread weaving, calibration

Phase 4: Self-Critique
  → Score against strong/weak indicators
  → Revise if <3 strong indicators present
  → Return draft + meta-commentary
```

**Why this is an agent, not part of the orchestrator**: It reads many files, performs heavy synthesis, and benefits from context isolation. The detail stays in the agent; only the draft returns.

**Reference Skill: `client-communication`** (preloaded into email-writer)
```
Core Principle: "Lead with What Matters"
  → Defines what good email structure looks like
  → Anti-patterns: backward-looking, self-promotion, delivery confirmation

Standards:
  → Email structure (Key Takeaway → Analysis → Next Steps → Context)
  → Language to avoid (praising, vague qualifiers, empty compliments)
  → Language to use (specific facts, measurable outcomes, direct timelines)

Examples:
  → Good/bad contrasts for thread weaving
  → Good/bad contrasts for subject lines
  → Good/bad contrasts for key takeaways
```

**Why this is a reference skill, not an agent instruction**: Multiple agents may need the same communication standards. Define once, preload everywhere. The agent defers to it; the skill is the sole authority on structure and tone.

---

## Layer 3: Skill Templates

Skills live in `.claude/skills/<name>/SKILL.md` (recommended) or `.claude/commands/` (backward compatible). Use the skills path for new work — it provides directories for supporting files, richer frontmatter, and `context: fork` for isolated execution.

### Directory Structure

```
.claude/
├── skills/
│   ├── write-followup/          # Orchestrator skill (dispatches to agent)
│   │   └── SKILL.md
│   ├── record/                  # Single skill (interactive dialogue, no agent)
│   │   └── SKILL.md
│   ├── client-communication/    # Reference skill (preloaded into agents)
│   │   └── SKILL.md
│   └── start-day/               # Orchestrator skill
│       ├── SKILL.md
│       └── briefing-template.md # Supporting file (one level deep)
├── agents/
│   ├── email-writer.md          # Agent (model: opus, skills: client-communication)
│   └── meeting-processor.md     # Agent (model: opus, skills: client-communication)
```

### Orchestrator Skill Template

Copy-paste ready template for a user-invoked workflow that dispatches to an agent.

```yaml
---
name: [workflow-name]
description: >
  [When should this activate? Write as if answering that question.
  A good description improves activation by 20-50%.]
disable-model-invocation: true
argument-hint: "[parameter-name]"
---
```

```markdown
# [Workflow Name]

**Purpose**: [One sentence]
**Usage**: `/[workflow-name] [parameters]`

---

## Phase 1: Validate Inputs

Step 1: [Resolve primary parameter]
- [Check: does the resource exist?]
- [If not found: list options and ask]

Step 2: [Resolve secondary parameter]
- [Default behavior if not provided]
- [Confirm with user if ambiguous]

Step 3: Verify prerequisites
- [Required file/resource 1 must exist]
- [Required file/resource 2 must exist]
- If not found, STOP and inform user

**Output collected values before proceeding:**

Phase 1 Complete:
- [Parameter 1]: [actual value]
- [Parameter 2]: [actual value]
- [Path 1]: [actual value]

## Phase 2: Invoke [Agent Name]

1. Read agent definition at `.claude/agents/[agent-name].md`
2. Note: model=[model], skills=[skill-list]
3. Build complete prompt with validated values from Phase 1
4. Call Task tool with model=[model]

## Phase 3: Present Output

Display agent output to user with:
- The primary artifact (email draft, report, etc.)
- Agent's self-assessment (if applicable)
- Action options (Send / Edit / Regenerate / Skip)

## Phase 4: Human Gate

Wait for user decision. Do NOT act without explicit approval.
- Send: [action]
- Edit: [action]
- Regenerate: re-invoke agent with feedback
- Skip: acknowledge and exit
```

**Key properties**: LOW freedom. Exact steps, exact phase structure. Compliance checkpoints between phases. The orchestrator is a procedure, not guidance.

### Reference Skill Template

Copy-paste ready template for an authoritative standards document preloaded into agents.

```yaml
---
name: [standard-name]
description: >
  [What domain does this skill govern? When should an agent defer to it?]
---
```

```markdown
# [Standard Name]

---

## Core Principle

[One paragraph: The foundational principle that governs all decisions
in this domain. Every standard below derives from this principle.]

## Standards

### [Standard Area 1]
- [Specific standard]
- [Specific standard]

### [Standard Area 2]
- [Specific standard]
- [Specific standard]

## Examples

### Good
> [Concrete example that follows the standards. Quote format.]
> *Why this works*: [Brief explanation]

### Bad
> [Concrete example that violates the standards. Quote format.]
> *Why this fails*: [Brief explanation]

## Anti-Patterns

| Pattern | Why It Fails | Do This Instead |
|---------|-------------|-----------------|
| [Common mistake 1] | [Explanation] | [Correct approach] |
| [Common mistake 2] | [Explanation] | [Correct approach] |
```

**Key properties**: MEDIUM to HIGH freedom. The agent applies these standards with judgment to varied situations. Include concrete good/bad contrasts — they're more effective than abstract rules. These can be longer than orchestrators since they're injected as primary context.

### Freedom Level Reference

| Level | When to Use | Pattern | Typical Skill Type |
|-------|-------------|---------|-------------------|
| **Low** | Critical procedures, orchestrators | Exact steps, exact output, compliance checkpoints | Orchestrator skill |
| **Medium** | Structured standards, workflows | Standards with examples, decision points | Reference skill, single skill |
| **High** | Guidance, principles | "Consider these factors when..." | Reference skill |

### Agent Skill Preloading

When a skill is listed in an agent's `skills:` frontmatter, it is injected as full text at agent startup. The invoking orchestrator should:

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
  - client-communication  # ← Preloaded. Agent sees full text.
---
```

```
# When invoking this agent:
# CORRECT: Just invoke with the task prompt
# WRONG: "First, read the communication-standards skill..."
```

### Migration Checklist: Commands to Skills

For existing companions with `.claude/commands/` files, use this checklist to migrate:

- [ ] **Inventory**: List all `.claude/commands/*.md` files
- [ ] **Classify** each command:
  - Orchestrator (dispatches to agents) → orchestrator skill template
  - Interactive dialogue (no agent) → single skill
  - Standards/reference → reference skill template
- [ ] **Create** `.claude/skills/<name>/SKILL.md` for each command
- [ ] **Add frontmatter**: `disable-model-invocation: true` for orchestrators, `argument-hint` where applicable
- [ ] **Move supporting files** (templates, examples) into the skill directory
- [ ] **Test** `/name` invocation still works
- [ ] **Remove** old `.claude/commands/<name>.md` files
- [ ] **Update** any CLAUDE.md references from "commands" to "skills"
- [ ] **Update** any documentation that references command file paths

**Migration is recommended, not urgent.** Commands still work. Migrate when modifying a companion's configuration — don't create a separate migration project.

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
