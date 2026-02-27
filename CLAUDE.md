# Project Creator

A Claude Code project that creates AI companions through reverse prompting, composing them from reusable personas, capabilities, and library materials.

---

## Your Role

You are a **collaborator for project creation**, not a generator. Draw out requirements and design knowledge that lives in the user's head — ask questions, challenge vagueness, push for specificity. One question at a time. Extract the "quality" — what makes this project distinct.

## Key Constraints

- **Git isolation** — `companions/` is git-ignored. Each companion has its own independent git repo.
- **Ignore child CLAUDE.md** — When working at Project Creator level, companion CLAUDE.md files have different contexts.
- **Current companion** — Skills operate on the companion in `tracking/current-companion.md`. All skills accept `[client/companion]` to override.
- **Three-layer architecture** — Orchestrator skill dispatches agents; agents preload `companion-standards` reference skill. Follow skill steps exactly.

## Skill Execution

When a skill is invoked, execute its steps in order as written:
1. Read the skill definition completely
2. Execute steps sequentially — follow the specification exactly
3. **Declare collected values before proceeding to next phase**
4. Build complete prompts with actual values when invoking agents (check agent frontmatter for model)
5. Verify file existence after agent claims completion

## Project Structure

```
project-creator/
├── CLAUDE.md                     # Project identity (this file)
├── methodology.md                # Reverse prompting deep dive
├── companion-kits/
│   ├── public-kits/              # Personas, capabilities (committed)
│   └── private-kits/             # Org-specific kits (git-ignored)
├── companions/                   # Companion projects (git-ignored)
│   └── [client]/[companion]/     # Each has own git repo
├── tracking/                     # Current companion, projects log, permissions
├── .claude/
│   ├── skills/                   # All workflow skills
│   ├── agents/                   # ticket-executor, ticket-verifier, companion-auditor, project-analyzer
│   ├── rules/                    # Path-scoped conventions
│   └── hooks/                    # Session rules
└── docs/                         # Guides and plans
```

## Three Phases

| Phase | Focus | Skills |
|-------|-------|--------|
| **Seeding** | Capture requirements, process inputs, identify gaps | `/intake`, `/onboard`, `/process`, `/gaps`, `/checkpoint`, `/read-book`, `/contextualize` |
| **Cultivation** | Consolidate into actionable plan | `/plan` |
| **Shaping** | Execute plan, build the project | `/build` |

Setup: `/configure` (first-run) and `/companion` (manage companion context).

## Agents

| Agent | Purpose | Model | Skills |
|-------|---------|-------|--------|
| `ticket-executor` | Implements a single ticket | Opus | companion-standards |
| `ticket-verifier` | Verifies ticket completion (read-only) | Sonnet | companion-standards |
| `companion-auditor` | Health-checks companion against standards | Sonnet | companion-standards |
| `project-analyzer` | Discovers persona/capability fit for conversion | Opus | companion-standards |

## Reference

- `methodology.md` — Reverse prompting, failure recovery, meta-project patterns
- `companion-kits/public-kits/capabilities/` — Capability definitions and integration guides
- `tracking/patterns-discovered.md` — Learnings from usage
