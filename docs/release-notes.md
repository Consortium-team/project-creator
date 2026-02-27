# Release Notes

## v2.0 — Three-Layer Architecture (February 2026)

**The short version:** Companions built with Project Creator are now smarter about how they use their context window — the right information shows up at the right time instead of everything being loaded at once. This makes companions both more reliable (they follow their rules more consistently) and more efficient (they use fewer tokens doing it).

**How to get these benefits:**

- **New companions** created with `/intake` get this automatically.
- **Existing companions** can be re-onboarded with `/onboard` to get a health check and upgrade path.
- **Native Claude Code projects** (not built with Project Creator) can be converted into companions with `/onboard`, gaining the same benefits.

---

### What Changed

The core innovation is a **reliability hierarchy** — matching how instructions are delivered to how important they are.

Previously, companions put most of their instructions in `CLAUDE.md`. As that file grew, Claude's attention to individual instructions degraded. Critical rules got the same treatment as nice-to-have conventions. When conversations got long and context was compacted, important guidance could be lost entirely.

Now, companions distribute instructions across five layers, each with different reliability characteristics:

| Layer | Mechanism | What It Does | Reliability |
|-------|-----------|-------------|-------------|
| 1 | **Hooks** | Critical rules that must always be followed | Highest — fires at session start and survives compaction |
| 2 | **Skills preloaded in agents** | Standards that agents must follow during heavy work | High — injected as primary context |
| 3 | **Skills** | Workflow procedures invoked on demand | High — full attention when active |
| 4 | **Rules** | Conventions for specific file types or directories | Medium — activates based on what you're editing |
| 5 | **CLAUDE.md** | Project identity and cross-cutting constraints | Advisory — kept under 100 lines |

The result: companions that follow their critical rules even in long conversations, use their workflow procedures more consistently, and spend fewer tokens loading context they don't need at that moment.

---

### Detailed Changes

#### Three-Layer Skill Architecture

Workflows migrated from flat command files to a structured skill architecture:

- **Orchestrator skills** validate inputs, dispatch work to agents, and present results for human approval
- **Agents** handle heavy work (reading many files, generating content) in isolated context
- **Reference skills** define standards that get preloaded into agents — a single source of truth shared across all agents

This means an agent building a companion follows the exact same structural standards as an agent verifying one, because they both preload the same `companion-standards` reference skill.

#### Companion Standards

A new reference skill (`companion-standards`) codifies the structural conventions for companion projects:

- Directory layout and file placement rules
- Configuration surface decisions (what goes where in the reliability hierarchy)
- Ticket schema (field names, sizing, status values)
- Anti-patterns to avoid

This skill is preloaded into every agent that creates or modifies companion artifacts, ensuring consistency regardless of which agent does the work.

#### New Agents

Two new agents support the `/onboard` workflow:

- **companion-auditor** (Sonnet) — Health-checks an existing companion against current standards. Reports what's FOUND, PARTIAL, MISSING, or in the WRONG_LOCATION.
- **project-analyzer** (Opus) — Analyzes a native Claude Code project for conversion into a companion. Recommends persona, capabilities, and migration plan.

#### Session Hooks

A new `SessionStart` hook delivers critical rules at the start of every session and after every context compaction. These are the 5-7 rules that must always be followed — they no longer depend on `CLAUDE.md` staying in the active context.

#### Path-Scoped Rules

Rules now activate based on which files are being edited:

- `claude-config.md` — Conventions for skills, agents, hooks
- `companion-directory.md` — Companion file placement rules
- `ticket-schema.md` — Ticket field naming and sizing

#### Component Architecture

The companion-building pipeline now uses composable components:

- **Personas** define the "who" (identity, voice, intake guide, reference projects)
- **Capabilities** define the "what" (behaviors like reverse-prompting, context-ecosystem, session-hygiene)
- **Library materials** provide domain knowledge from books, contextualized per companion

#### Commands to Skills Migration

All workflow commands migrated from `.claude/commands/` to `.claude/skills/`:

| Old | New |
|-----|-----|
| `.claude/commands/intake.md` | `.claude/skills/intake/SKILL.md` |
| `.claude/commands/build.md` | `.claude/skills/build/SKILL.md` |
| `.claude/commands/plan.md` | `.claude/skills/plan/SKILL.md` |
| (all others) | (same pattern) |

Skills receive higher attention from Claude than commands, and their directory structure supports multi-file skill packages (a skill can include sub-agents, scripts, and assets).

#### New Capabilities

- **Claude Code Configuration** — A capability for companions that need to modify their own Claude Code configuration surface (skills, hooks, rules, agents). Includes the three-layer architecture as an integration guide.

#### CLAUDE.md Reduction

Project Creator's own `CLAUDE.md` went from ~500 lines to under 50 lines. The removed content was distributed to hooks (critical rules), skills (workflow procedures), and rules (file conventions) — a demonstration of the reliability hierarchy in practice.

---

### Migration Guide

**For existing companions:**

1. Clone or navigate to the companion
2. Set it as current: `/companion client/companion-name`
3. Run `/onboard` — the companion-auditor agent will analyze what exists and recommend changes
4. Follow the interactive gap-filling to upgrade

**For native Claude Code projects:**

1. Copy or clone the project into `companions/client/project-name/`
2. Set it as current: `/companion client/project-name`
3. Run `/onboard` — the project-analyzer agent will recommend a persona and capabilities
4. Follow the interactive conversion process

No migration is needed for new companions — `/intake` produces the new architecture by default.
