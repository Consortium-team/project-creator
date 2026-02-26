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

## Configuration Surfaces

### 1. Hooks — The Enforcement Layer

Hooks are shell scripts that fire deterministically on specific events. They bypass the system disclaimer that undermines CLAUDE.md authority. They are the only mechanism that survives context compaction automatically.

**16 events available. Three key ones:**

- **SessionStart** — Fires at startup AND after every context compaction. Use for rules that must persist across the entire session regardless of compaction. This is the most important hook.
- **UserPromptSubmit** — Fires on every user turn. Use for per-turn reinforcement of critical constraints.
- **PreCompact** — Fires before context compaction. Use for preserving state that would otherwise be lost.

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

Skills are the recommended mechanism for multi-step procedures, workflows, and commands. They replaced the older `/commands` pattern and offer better loading behavior and richer frontmatter.

**Key properties:**

- **Description is the dispatch mechanism.** A good description (clear about when the skill applies) improves activation by 20-50%. This is the single highest-leverage field in the frontmatter.
- **On-demand loading.** Metadata loads at session start; full content loads when invoked. This means skills don't compete for attention until they're needed.
- **Supporting files.** Skills can reference files one directory level deep. Keep skills under 500 lines.
- **In agents via `skills:` frontmatter** — Full text is injected at agent startup. The agent sees the skill as primary context. Never tell an agent to "read" a preloaded skill — it's already loaded.

**Three freedom levels:**

| Level | When to Use | Pattern |
|-------|-------------|---------|
| **High** | Guidance, principles | "Consider these factors when..." |
| **Medium** | Structured workflows | Pseudocode with decision points |
| **Low** | Critical procedures | Exact steps, exact output format, compliance checkpoints |

**The freedom level rule**: Use LOW freedom for any multi-step procedure that has failed when written as guidance. The "reasoning vs executing" anti-pattern — where Claude interprets a specification instead of following it — is solved by low-freedom skills with explicit checkpoints, not by adding emphasis to high-freedom guidance.

**Compliance checkpoints**: For multi-phase workflows, require the model to output collected values between phases. This forces demonstration of compliance at generation time rather than hoping for it.

```
Phase 1 Complete. Collected values:
- Client: [actual value]
- Date: [actual value]
- Path: [actual value]

Proceeding to Phase 2.
```

### 3. Agents — The Isolation Layer

Agents (subagents) provide context isolation. A subagent gets ONLY its prompt plus CLAUDE.md — no conversation history, no parent skills, no accumulated context. This isolation is both the strength and the constraint.

**Key properties:**

- **Build complete prompts.** Because subagents have no conversation context, every value they need must be in the prompt. Never pass placeholder values like `[PATH_FROM_STEP_1]`.
- **Whitelist tools explicitly.** Agents get no tools by default. Omitting the tool list means the agent can't do its job.
- **Prompt structure matters.** Definition-of-done goes FIRST (primacy effect). Critical constraints go LAST (recency effect). Supporting context goes in the middle.
- **Model selection**: Haiku for search/retrieval, Sonnet for structured analysis, Opus for complex reasoning and generative tasks.
- **Up to 7 parallel agents.** Cannot spawn sub-subagents (one level deep only).

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

## Anti-Patterns

| Anti-Pattern | Why It Fails | What to Do Instead |
|-------------|-------------|-------------------|
| Everything in CLAUDE.md | Wrong mechanism for most things; attention degrades with length | Distribute across the reliability hierarchy |
| Adding emphasis for procedural compliance | Emphasis helps atomic rules, not multi-step procedures | Use low-freedom skills with compliance checkpoints |
| Negative framing ("NEVER do X") | Activates the prohibited behavior by requiring the model to represent it | Positive framing ("do Y instead") |
| Omitting tool whitelists on agents | Agent can't perform its task; fails silently or improvises | Always whitelist tools explicitly |
| Telling agents to read preloaded skills | Skill is already injected; reading it wastes tokens and confuses context | Trust that `skills:` frontmatter means preloaded |
| Long CLAUDE.md with workflow details | Workflows compete with identity for attention; both lose | Move workflows to skills |
| Repeating instructions that keep failing | Repetition doesn't fix structural misplacement | Move the instruction to a higher-reliability tier |
| Same enforcement for all task types | Structured extraction needs less; generative synthesis needs more | Match enforcement to task type |

---

## Relationship to Other Capabilities

- **Session Hygiene** — Complements. Session hygiene handles cross-session continuity (checkpoints, handoffs). Claude Code configuration handles within-session compliance (hooks, skills, enforcement tiers).
- **Context Ecosystem** — Enables. Context files only get written correctly if commands execute correctly. Configuration reliability is the prerequisite for context ecosystem integrity.
- **Reverse Prompting** — Supports. Reverse prompting workflows implemented as skills benefit from the freedom-level framework (intake = medium freedom, synthesis = low freedom).
- **All other capabilities** — Foundation. Every capability that uses skills, agents, or commands depends on this infrastructure layer working correctly.
