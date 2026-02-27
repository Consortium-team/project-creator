# Capability: Claude Code Configuration

The infrastructure layer for all companion projects. Determines how reliably Claude Code follows instructions by matching enforcement mechanism to instruction criticality across five configuration surfaces — hooks, skills, agents, rules, and CLAUDE.md.

---

## What It Is

Claude Code has five configuration mechanisms. Most projects put everything in CLAUDE.md and wonder why instructions get ignored. The problem isn't emphasis or length — it's structural. Each mechanism has a fundamentally different trust level, and instructions placed in the wrong mechanism fail predictably.

This capability provides the framework for distributing guidance across all five surfaces based on how critical each instruction is.

**Standard approach**: Write comprehensive CLAUDE.md, add emphasis markers when things get ignored, make it longer when behavior drifts.

**This approach**: Short CLAUDE.md for identity. Skills for workflows. Hooks for enforcement. Rules for domain patterns. Agents for isolation. Each mechanism does what it's structurally good at.

---

## When to Use

| Companion Type | Usage | Notes |
|---------------|-------|-------|
| All companions | **Mandatory** | This is the infrastructure that makes every other capability work |
| PM companions | Heavy skill/agent usage | Generative tasks need maximum enforcement |
| SE companions | Moderate | Lighter during implementation, heavier during planning |
| Game designer companions | Heavy skill usage | Emphasis on preloading pattern for framework-heavy analysis |

---

## The Reliability Hierarchy

The core organizing principle. Five mechanisms, ranked by how reliably Claude follows instructions placed in them:

| Tier | Mechanism | Trust Level | Why |
|------|-----------|-------------|-----|
| 1 | **Hooks** | Deterministic | Shell scripts that always fire. Bypass the "may or may not be relevant" disclaimer. Survive compaction automatically. |
| 2 | **Skills** (preloaded in agents) | High | Full text injection at agent startup. High attention — it's the primary context the agent sees. |
| 3 | **Skills** (in main conversation) | Medium | Metadata loaded at startup, full content on invocation. On-demand loading means less attention competition. |
| 4 | **Rules** (`.claude/rules/`) | Medium | Same priority as CLAUDE.md but path-scoped and focused. Less noise means more signal per instruction. |
| 5 | **CLAUDE.md** | Advisory | Wrapped in a system disclaimer ("this may or may not be relevant"). Attention degrades with length. Training data patterns compete with context-window instructions. |

**The principle**: Match enforcement mechanism to instruction criticality. If you keep writing "ALWAYS do X" in CLAUDE.md and Claude doesn't comply, the instruction belongs in a higher tier — not in bolder text.

---

## The Three-Layer Architecture

The reliability hierarchy tells you *where* to put instructions. The three-layer architecture tells you *how commands, agents, and skills compose* into reliable workflows. This is the most important architectural pattern in any companion project.

### The Pattern

```
USER → ORCHESTRATOR (skill) → AGENT (subagent) ← REFERENCE SKILL (preloaded)
```

Each layer has a distinct responsibility:

**Orchestrator** (skill with `disable-model-invocation: true`):
Thin wrapper that handles user-facing concerns. Validates inputs, sequences phases, dispatches to agents, presents output, gates on human approval. Does NOT do heavy analytical or generative work itself.

**Agent** (`.claude/agents/`):
Specialized executor with narrow scope. Handles the heavy work: reading many files, synthesizing content, generating drafts. Has reference skills preloaded for standards it must follow. Returns output to the orchestrator.

**Reference Skill** (listed in agent's `skills:` frontmatter):
Authoritative standards document. NOT a procedure — a reference. The agent defers to it for cross-cutting concerns (tone, format, domain conventions). Update the skill once, all agents that use it get the update.

### The Clean Separation

| Layer | Owns | Example |
|-------|------|---------|
| Orchestrator | The "what" and "when" | Validate client exists, choose meeting, present draft, get approval |
| Agent | The "how" | Read living profile, synthesize meeting insights, draft email, self-critique |
| Reference Skill | The "to what standard" | Communication tone, email structure, language to avoid |

**Reference implementation**: `write-followup` (orchestrator) → `email-writer` (agent, model: opus, skills: client-communication) → `client-communication` (reference skill, sole authority on structure/tone).

In this example:
- `write-followup` validates the client name, resolves the meeting date, checks prerequisites, invokes the agent, presents the draft, and waits for the user's decision (send/edit/regenerate/skip). It never writes the email itself.
- `email-writer` reads the living profile and activity logs, determines meeting weight, weaves conversation threads, drafts the email, and self-critiques against quality indicators. It defers to `client-communication` for all structure and tone decisions.
- `client-communication` defines the email format, the "lead with what matters" principle, language to avoid, and concrete good/bad examples. It's injected at agent startup — the agent doesn't need to read it.

### When You Don't Need All Three Layers

Not every workflow needs an agent. The test: **does this workflow need to read many files and produce substantial output?**

- **Yes** → Use the three-layer pattern. The orchestrator handles user interaction; the agent handles synthesis.
- **No, it's primarily dialogue with the user** → A single skill suffices. No agent needed.

Example: The `record` command is a single skill. It scans recent messages, asks reverse-prompting questions, presents a recording plan, and writes to files. There's no heavy synthesis step — it's interactive dialogue with the user. No agent dispatch needed.

Example: The `write-followup` command needs all three layers. The email-writer agent reads 15-35K tokens of living profile and activity logs, synthesizes thread continuity, drafts strategic content, and self-critiques. That work belongs in an isolated agent context, not in the main conversation.

---

## Configuration Surfaces

### 1. Hooks — The Enforcement Layer

Hooks are shell scripts that fire deterministically on specific events. They bypass the system disclaimer that undermines CLAUDE.md authority. They are the only mechanism that survives context compaction automatically.

**17 events available. Three key ones:**

- **SessionStart** — Fires at startup AND after every context compaction. Use for rules that must persist across the entire session regardless of compaction. This is the most important hook.
- **UserPromptSubmit** — Fires on every user turn. Use for per-turn reinforcement of critical constraints.
- **PreCompact** — Fires before context compaction. Use for preserving state that would otherwise be lost.

**Complete event reference:**

| Group | Events |
|-------|--------|
| Session | SessionStart, SessionEnd |
| User | UserPromptSubmit |
| Tool | PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest |
| Compaction | PreCompact |
| Subagent | SubagentStart, SubagentStop |
| Completion | Stop, TaskCompleted, Notification |
| Teamwork | TeammateIdle |
| Config | ConfigChange |
| Worktree | WorktreeCreate, WorktreeRemove |

**Matchers:** Hook events support regex matchers to fire only for specific tools or patterns (e.g., a PreToolUse hook that only fires for `Write` or `Bash`). Hooks can also be defined in skill or agent frontmatter — not just in `settings.json`.

**Three hook types:**

- **Command hooks** — Run a shell command, output injected as context. Fast, simple, deterministic.
- **Prompt hooks** — Send output to a model for processing. More flexible but slower.
- **Agent hooks** — Spawn a subagent. Most powerful but highest latency.

**What belongs in hooks:**

- Rules that MUST be followed with zero exceptions
- Format constraints that keep getting violated
- Skill invocation reminders ("check for applicable skills before responding")
- Session state that must survive compaction
- Any instruction you've tried putting in CLAUDE.md three times without success

**What does NOT belong in hooks:**

- Workflow procedures (too complex for a hook — use skills)
- Context that changes per task (hooks fire the same way every time)
- Guidance that benefits from judgment (hooks are binary: fire or don't)

### 2. Skills — The Workflow Layer

Skills are the recommended mechanism for workflows, commands, and authoritative standards. They replaced the older `.claude/commands/` pattern (Jan 2026, v2.1.1) and offer better loading behavior, richer frontmatter, and supporting file directories. Commands still work (backward compatible), but `.claude/skills/<name>/SKILL.md` is recommended for new work.

**Shared properties across all skill types:**

- **Description is the dispatch mechanism.** A good description (clear about when the skill applies) improves activation by 20-50%. Be specific and slightly "pushy" — under-triggering is more common than over-triggering. This is the single highest-leverage field in the frontmatter.
- **Supporting files.** Skills can reference files one directory level deep. Keep skills under 500 lines.
- **Three freedom levels:** High (guidance), Medium (structured workflows), Low (critical procedures with compliance checkpoints).

**Skill frontmatter fields:**

| Field | Purpose |
|-------|---------|
| `name` | Skill identifier |
| `description` | When this skill applies — the dispatch mechanism |
| `disable-model-invocation` | `true` = only user can trigger (via `/name`); Claude cannot invoke autonomously |
| `user-invocable` | `false` = reference skill only (cannot be triggered by user or Claude directly) |
| `argument-hint` | Parameter description shown in UI (e.g., `"client-name"`) |
| `allowed-tools` | Restrict which tools are available when skill is active |
| `model` | Override model for this skill's execution |
| `context` | Execution context — `fork` runs skill in isolated agent context |
| `agent` | Agent to delegate to when skill is invoked |
| `hooks` | Hooks that fire during this skill's execution |

**String substitutions in skills:** `$ARGUMENTS` (full argument string), `$ARGUMENTS[0]` / `$ARGUMENTS[1]` (positional args), `$1` / `$2` (shorthand positional), `${CLAUDE_SESSION_ID}` (current session ID).

**Dynamic context injection:** Use `` !`command` `` syntax to inject the output of a shell command into the skill content at load time.

Skills serve two fundamentally different roles — and conflating them is a common architectural mistake:

#### Orchestrator Skills (User-Invoked Workflows)

Orchestrators are the user-facing entry points. They are thin wrappers that validate, dispatch, present, and gate — never doing the heavy analytical or generative work themselves.

**Key properties:**

- **`disable-model-invocation: true`** — Only user triggers these (via `/skill-name`). Claude cannot invoke them autonomously.
- **Thin wrappers.** Validate → orchestrate → present → gate. The orchestrator is a procedure, not guidance. Use LOW freedom.
- **Compliance checkpoints between phases.** Require the model to output collected values before proceeding:

```
Phase 1 Complete. Collected values:
- Client: [actual value]
- Date: [actual value]
- Path: [actual value]

Proceeding to Phase 2.
```

- **Human gates.** After agent returns output, present to user and wait for approval before any action (send, write, modify).
- **Agent dispatch pattern.** Read agent definition → note model and skills → build complete prompt with actual values → call Task tool.

**Frontmatter additions (beyond commands):** `argument-hint` (parameter description shown in UI), `allowed-tools` (tool restrictions), `context: fork` (isolated execution — skill content becomes the agent's task).

**Example**: `write-followup` — validates client, resolves meeting date, checks prerequisites, invokes `email-writer` agent, presents draft, waits for user decision. Never writes the email itself.

#### Reference Skills (Preloaded Into Agents)

Reference skills are authoritative standards documents. They define *what good looks like* — not procedures to follow. The agent defers to the skill; the skill is the sole authority on its domain.

**Key properties:**

- **Listed in agent `skills:` frontmatter.** Full text is injected at agent startup. The agent sees the skill as primary context. Never tell an agent to "read" a preloaded skill — it's already loaded.
- **NOT procedures — reference documents.** Standards, concrete examples (good/bad contrasts), anti-patterns, domain conventions.
- **DRY for standards.** Update once → all agents that use the skill get the update. Multiple agents can share the same reference skill.
- **Can be longer than orchestrators.** These are injected as primary context into agents, so length serves the agent's needs, not the user's attention span.
- **`user-invocable: false`** (or simply never invoked by users — just listed in agent frontmatter).

**Example**: `client-communication` — defines email structure, the "lead with what matters" principle, language to avoid, good/bad examples. Preloaded into `email-writer` agent. The agent defers to it for all tone and format decisions.

**The freedom level rule**: Use LOW freedom for orchestrator skills (procedures that must execute exactly). Use HIGH or MEDIUM freedom for reference skills (guidance the agent applies with judgment to varied situations).

#### Developing Skills

Anthropic provides a **skill-creator** tool (in the `anthropics/skills` repo, Apache 2.0) that handles the mechanics of building and testing individual skills: intent capture, writing, eval, and description optimization.

**Relationship to this capability:** skill-creator is a craftsman's tool for building individual skills. This capability is an architect's framework for deciding *what* to build and *where it fits*. Use them together:

1. **Architectural decisions first** (this capability) — Is this an orchestrator, reference skill, or single skill? Which reliability tier? Does it need an agent?
2. **Skill writing mechanics second** (skill-creator) — Write the skill content, test it, optimize the description.

**Caution:** skill-creator doesn't know about the three-layer architecture. Don't let it guide you into a monolithic skill where an orchestrator + agent + reference skill would be more reliable.

### 3. Agents — The Isolation Layer

Agents (subagents) provide context isolation. A subagent gets ONLY its prompt plus CLAUDE.md — no conversation history, no parent skills, no accumulated context. This isolation is both the strength and the constraint.

**Key properties:**

- **Build complete prompts.** Because subagents have no conversation context, every value they need must be in the prompt. Never pass placeholder values like `[PATH_FROM_STEP_1]`.
- **Scope tools deliberately.** Agents inherit all tools from the main conversation by default. Use `tools:` to restrict to a whitelist, or `disallowedTools:` to exclude specific tools. Either way, be intentional — don't leave tool access to the default when narrower scope would prevent mistakes.
- **Prompt structure matters.** Definition-of-done goes FIRST (primacy effect). Critical constraints go LAST (recency effect). Supporting context goes in the middle.
- **Model selection**: Haiku for search/retrieval, Sonnet for structured analysis, Opus for complex reasoning and generative tasks.
- **Up to 7 parallel agents.** Cannot spawn sub-subagents (one level deep only).

**Agent frontmatter fields:**

| Field | Purpose | Reliability Hierarchy Note |
|-------|---------|--------------------------|
| `name` | Agent identifier | — |
| `description` | What the agent does | — |
| `model` | Model to use (haiku/sonnet/opus) | Match model to task complexity |
| `tools` | Whitelist of allowed tools | Enforcement: restricts to only these tools |
| `disallowedTools` | Blacklist of denied tools | Enforcement: excludes specific tools from inherited set |
| `skills` | Reference skills preloaded at startup | Tier 2 reliability — high attention context |
| `permissionMode` | `default`, `acceptEdits`, `bypassPermissions` | Enforcement: controls tool approval behavior |
| `maxTurns` | Maximum agentic turns before stopping | Enforcement: prevents runaway execution |
| `mcpServers` | MCP servers available to this agent | — |
| `memory` | Whether agent has access to auto-memory | — |
| `background` | `true` for background execution (agent teams) | Practical note: parallel background agents may hit permission contention |
| `isolation` | `worktree` for git worktree isolation | — |
| `hooks` | Hooks scoped to this agent's execution | Tier 1 reliability — deterministic enforcement within agent |

**Scaffolding:** Use `/agents` and `/hooks` interactive commands to scaffold agent and hook files. These commands create the file structure; this capability guides what goes in them.

**CLI-defined agents:** Agents can also be defined via the `--agents` JSON flag for ad-hoc or CI use cases. Agents support resume capability — a stopped agent can be continued with its full context preserved.

**When to use agents:**

- Verbose operations where detail should stay isolated and only a summary returns
- Tasks requiring a different model than the main conversation
- Parallel independent work streams
- Verification of other agents' work (separation of concerns)

### 4. Rules — The Domain Layer

Rules live in `.claude/rules/` and support path-scoping via YAML frontmatter. They have the same priority as CLAUDE.md but are focused on specific file types or directories, giving them better signal-to-noise.

**Path-scoping example:**

```yaml
---
globs: ["*.py", "tests/**"]
---
Use pytest for all test files. Follow AAA pattern (Arrange, Act, Assert).
```

**When to use rules vs CLAUDE.md:**

- Rules: Domain-specific patterns that apply to certain files (code style, test patterns, file format conventions)
- CLAUDE.md: Cross-cutting concerns that apply to the whole project (project identity, team conventions, critical constraints)

Rules are best for instructions that would clutter CLAUDE.md but are important when working in specific parts of the codebase.

### 5. CLAUDE.md — The Identity Layer

CLAUDE.md is the most familiar configuration surface and the most overused. It's wrapped in a system disclaimer ("this context may or may not be relevant") that structurally undermines its authority for critical instructions.

**What CLAUDE.md is good at:**

- Project identity — what this project is, why it exists, who it's for
- Cross-cutting constraints — conventions that apply everywhere
- Critical context — things that would cause mistakes if unknown
- Orientation — helping Claude understand the codebase structure

**What CLAUDE.md is bad at:**

- Workflow procedures (move to skills — on-demand loading, better attention)
- Domain patterns for specific files (move to rules — path-scoped, focused)
- Enforcement of critical rules (move to hooks — deterministic, survives compaction)

**Best practices:**

- **Keep under 100-150 lines.** Attention degrades uniformly with length. Every line competes with every other line.
- **The deletion test.** For each line, ask: "Would removing this cause mistakes?" If not, cut it.
- **Use emphasis for atomic rules only.** "IMPORTANT: use 2-space indentation" works. "IMPORTANT: follow all 8 phases in order" does not. Emphasis helps simple instructions; structural enforcement (hooks + skills) helps complex procedures.
- **Positive framing.** "Execute commands step by step" instead of "NEVER skip steps." Negative framing activates the prohibited behavior — the model must represent what it's told not to do, increasing the probability of doing it.

---

## The Task-Type Dimension

Not all tasks need the same enforcement level. The type of task determines how much structure is required:

**Structured extraction** (clear input → structured output): Works reliably with medium enforcement. Examples: transcript → activity log, requirements → ticket YAML, meeting notes → action items. The input constrains the output, leaving less room for the model to substitute its own patterns.

**Generative synthesis** (judgment, prioritization, original composition): Needs maximum enforcement. Examples: writing follow-up emails, generating prep reports, drafting strategic recommendations. Training data patterns compete directly with context-window instructions. Use low-freedom skills, explicit output schemas, and hooks reinforcing format compliance.

**Understanding which type a command is helps calibrate enforcement level.** Over-enforcing structured extraction wastes rigidity. Under-enforcing generative synthesis produces inconsistent output.

---

## Token Efficiency

Token efficiency is a cross-cutting concern that affects all configuration surfaces:

- **Performance degrades ~25% beyond 70% context usage.** This is measurable and consistent.
- **`/clear` between unrelated tasks.** Single most impactful habit for maintaining output quality.
- **Subagents for verbose operations.** Detail stays in the subagent's context; only the summary returns to the main conversation.
- **Skills load on-demand; CLAUDE.md loads every session.** Moving workflow procedures from CLAUDE.md to skills reduces per-session token overhead.
- **Specific prompts over vague ones.** "Find the authentication middleware in src/middleware/" is cheaper and more accurate than "look at the auth code."

---

## External Resources

**Official Anthropic documentation:**
- Skills: https://docs.anthropic.com/en/docs/claude-code/skills
- Subagents: https://docs.anthropic.com/en/docs/claude-code/sub-agents
- Hooks: https://docs.anthropic.com/en/docs/claude-code/hooks

**Tooling:**
- **skill-creator** (`anthropics/skills` repo) — Handles skill writing, testing, and description optimization. See "Developing Skills" above.
- `/agents` command — Interactive scaffolding for agent definition files.
- `/hooks` command — Interactive scaffolding for hook configuration.

**Relationship:** The interactive commands (`/agents`, `/hooks`) scaffold file structure. skill-creator handles writing and testing mechanics. This capability guides architectural decisions — what to build, where it fits in the reliability hierarchy, and how layers compose.

---

## Anti-Patterns

| Anti-Pattern | Why It Fails | What to Do Instead |
|-------------|-------------|-------------------|
| Everything in CLAUDE.md | Wrong mechanism for most things; attention degrades with length | Distribute across the reliability hierarchy |
| Adding emphasis for procedural compliance | Emphasis helps atomic rules, not multi-step procedures | Use low-freedom skills with compliance checkpoints |
| Negative framing ("NEVER do X") | Activates the prohibited behavior by requiring the model to represent it | Positive framing ("do Y instead") |
| Leaving agent tool scope as default without consideration | Agent has access to tools it shouldn't (e.g., Write on a verifier) | Use `tools:` to whitelist or `disallowedTools:` to exclude deliberately |
| Telling agents to read preloaded skills | Skill is already injected; reading it wastes tokens and confuses context | Trust that `skills:` frontmatter means preloaded |
| Long CLAUDE.md with workflow details | Workflows compete with identity for attention; both lose | Move workflows to skills |
| Repeating instructions that keep failing | Repetition doesn't fix structural misplacement | Move the instruction to a higher-reliability tier |
| Same enforcement for all task types | Structured extraction needs less; generative synthesis needs more | Match enforcement to task type |
| Fat orchestrators that do heavy work | Orchestrator context fills with synthesis work; output presentation suffers; no isolation benefit | Delegate heavy work to agents; orchestrator only validates, dispatches, presents, gates |
| Agents without preloaded reference skills | Agent improvises standards (tone, format, structure) instead of deferring to authoritative source | Add reference skills to agent `skills:` frontmatter for cross-cutting standards |
| Skipping validation before agent dispatch | Agent receives bad inputs (wrong paths, missing files); wastes tokens discovering errors | Orchestrator validates all inputs and confirms prerequisites before invoking agent |
| Missing the human gate | Orchestrator presents agent output but acts on it without waiting for user approval | Always gate: present output → wait for explicit user decision → then act |
| Using `bypassPermissions` without testing | Security risk; hard to debug when agent takes unexpected actions | Start with `default` or `acceptEdits`; escalate only after thorough testing |

---

## Migration from Commands to Skills

**For new companions**: Always use `.claude/skills/<name>/SKILL.md` directory structure. Do not create `.claude/commands/` files. The skills path provides: directory for supporting files, frontmatter control over invocation (`disable-model-invocation`, `user-invocable`), `context: fork` for isolated execution, and future-proofing.

**For existing companions with `.claude/commands/` files**: When working on an existing companion and modifying its configuration, **propose a migration** from `.claude/commands/` to `.claude/skills/`. The migration for each command:

1. **Determine the skill type:**
   - If the command orchestrates agents → **Orchestrator skill** (`disable-model-invocation: true`)
   - If the command is pure interactive dialogue → **Single skill** (may keep `disable-model-invocation: true` or allow Claude invocation depending on use case)
   - If the command defines standards/references → **Reference skill** (`user-invocable: false`)

2. **Migration steps per command:**
   - Create `.claude/skills/<name>/SKILL.md` with the command content
   - Add appropriate frontmatter (`disable-model-invocation`, `argument-hint`, etc.)
   - Move any referenced templates or supporting files into the skill directory
   - Verify the `/name` invocation still works
   - Remove the old `.claude/commands/<name>.md` file

3. **Migration is proposed, not automatic** — the user approves each migration. Batch proposals are fine ("I recommend migrating these 5 commands to skills — here's the plan").

**Note**: `.claude/commands/` files are backward compatible and will continue to work. Migration is recommended for new frontmatter features and consistency, not urgency. No companion will break if migration is deferred.

---

## Relationship to Other Capabilities

- **Session Hygiene** — Complements. Session hygiene handles cross-session continuity (checkpoints, handoffs). Claude Code configuration handles within-session compliance (hooks, skills, enforcement tiers).
- **Context Ecosystem** — Enables. Context files only get written correctly if commands execute correctly. Configuration reliability is the prerequisite for context ecosystem integrity.
- **Reverse Prompting** — Supports. Reverse prompting workflows implemented as skills benefit from the freedom-level framework (intake = medium freedom, synthesis = low freedom).
- **All other capabilities** — Foundation. Every capability that uses skills, agents, or commands depends on this infrastructure layer working correctly.
