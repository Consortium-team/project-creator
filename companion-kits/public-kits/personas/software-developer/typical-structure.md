# Software Development: Typical Structure

The directory layout that works for software development projects.

---

## Core Structure

```
[project-name]/
├── CLAUDE.md                           # Project context, coding standards, command reference
├── README.md                           # Human-facing workflow guide
│
├── context/                            # Project context (from intake, living)
│   ├── requirements.md                 # Purpose, users, success criteria
│   ├── decisions.md                    # Key decisions with rationale
│   ├── constraints.md                  # Technical, timeline, organizational limits
│   └── questions.md                    # Open questions backlog
│
├── docs/                               # The context ecosystem
│   ├── development/                    # Technical documentation
│   │   ├── current-architecture.md     # LIVING — system architecture (updated by /capture-learnings)
│   │   ├── current-security-assessment.md  # LIVING — security posture
│   │   ├── current-test-strategy.md    # LIVING — test philosophy, coverage, invariants
│   │   ├── adr/                        # Architecture Decision Records (permanent)
│   │   │   ├── ADR-001-*.md
│   │   │   └── ...
│   │   ├── guides/                     # Repeatable procedures (permanent)
│   │   │   └── *.md
│   │   ├── sdd-[TICKET]-[PR#].md      # ACTIVE — Software Design Doc (current work)
│   │   └── archive/                    # Completed SDDs, target docs
│   │
│   ├── planning/                       # Implementation tracking
│   │   ├── plan-[TICKET]-[PR#].md      # ACTIVE — Implementation plan (current work)
│   │   ├── pr-tracking-[TICKET].md     # ACTIVE — PR breakdown for multi-PR issues
│   │   └── archive/                    # Completed plans, tracking docs
│   │
│   ├── requirements/                   # What to build
│   │   ├── current-features.md         # LIVING — feature inventory
│   │   ├── target-features-[TICKET].md # ACTIVE — desired feature state for issue
│   │   └── archive/                    # Completed target docs
│   │
│   ├── design/                         # Visual and UX references (optional)
│   │   ├── visual-guide.md             # Extracted design specs
│   │   └── screenshots/               # Reference images
│   │
│   └── evolution/                      # Process improvement (fed by /record, analyzed by /evolve)
│       ├── session-records.md          # Accumulated retrospective entries
│       └── evolution-proposal-*.md     # Maturation proposals from /evolve
│
├── .claude/
│   ├── commands/                       # Developer-facing workflow commands
│   │   ├── start-issue.md
│   │   ├── setup-issue-docs.md         # Level 2 only
│   │   ├── plan-pr.md
│   │   ├── implement.md
│   │   ├── capture-learnings.md        # Level 2 only
│   │   ├── close-issue.md
│   │   ├── record.md                   # Post-session retrospective
│   │   └── evolve.md                   # Process maturation proposals
│   ├── agents/                         # Subagents for heavy context work
│   │   ├── sdd-generator.md            # Generates Software Design Documents
│   │   ├── plan-generator.md           # Generates implementation plans
│   │   └── test-validator.md           # Adversarial test review
│   └── skills/                         # Domain knowledge for agents
│       ├── linear-workflow/SKILL.md    # Linear interaction patterns
│       └── [project-specific]/         # Tech stack, coding standards, etc.
│
└── [source code]                       # The actual codebase
    ├── src/                            # Or whatever the project structure is
    ├── tests/
    ├── package.json                    # Or equivalent
    └── ...
```

---

## Document Categories

### Living Documents (Updated by `/capture-learnings`)

These files reflect the current truth about the project. They are updated after each completed issue and should always be accurate.

| File | Purpose | Created By | Updated By |
|------|---------|------------|------------|
| `current-architecture.md` | System architecture, components, data models, API endpoints | Intake or onboard | `/capture-learnings` merges target architecture |
| `current-features.md` | Feature inventory with issue numbers and dates | Intake or onboard | `/capture-learnings` adds completed features |
| `current-security-assessment.md` | Security posture, findings, threat model, compliance | Intake or onboard | `/capture-learnings` adds security updates |
| `current-test-strategy.md` | Test philosophy, coverage targets, invariants, threat models | Intake | `/capture-learnings` updates with test learnings |

**Key principle:** Living documents are the developer's primary reference. They should be readable without context about specific issues or PRs.

---

### Active Documents (Per Issue/PR)

These files exist for the duration of a single issue or PR. They are the working context during implementation.

| File | Purpose | Created By | Archived By |
|------|---------|------------|-------------|
| `sdd-[TICKET]-[PR#].md` | Software Design Document — architecture, components, test design | `/plan-pr` (via SDD agent) | `/capture-learnings` |
| `plan-[TICKET]-[PR#].md` | Implementation plan — subtasks with checkboxes, success criteria | `/plan-pr` (via planning agent) | `/capture-learnings` |
| `pr-tracking-[TICKET].md` | PR breakdown table for multi-PR issues | `/setup-issue-docs` | `/capture-learnings` |
| `target-features-[TICKET].md` | Desired feature state after this issue | `/setup-issue-docs` | `/capture-learnings` |
| `target-architecture-[TICKET].md` | Proposed architecture changes | `/setup-issue-docs` | `/capture-learnings` |
| `target-security-assessment-[TICKET].md` | Security implications of this issue | `/setup-issue-docs` | `/capture-learnings` |

**Key principle:** Active documents are temporary. They provide focused context for the current work and are archived when the issue completes. This keeps the docs/ directory clean and the active set small.

---

### Permanent Documents

These files are created once and never archived. They accumulate project knowledge permanently.

| File | Purpose | Created By |
|------|---------|------------|
| `adr/ADR-NNN-*.md` | Architecture Decision Records — major decisions with rationale | `/capture-learnings` |
| `guides/*.md` | Repeatable procedures — how to do specific things | `/capture-learnings` |

---

## The 6-Document Active Set

At any point during implementation, the developer's mental model is limited to:

```
┌─────────────────────────────────────────────────────────┐
│  THE DEVELOPER'S WORLD DURING IMPLEMENTATION            │
│                                                          │
│  Living (background reference):                          │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ 1. current-architecture.md    — how things work     │ │
│  │ 2. current-features.md        — what's built        │ │
│  │ 3. current-security-assessment.md — security state  │ │
│  │ 4. current-test-strategy.md   — how we test         │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                          │
│  Active (current focus):                                 │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ 5. sdd-[TICKET]-[PR#].md     — design for this PR  │ │
│  │ 6. plan-[TICKET]-[PR#].md    — steps for this PR   │ │
│  └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

Everything else is consumed by commands and agents — the developer doesn't need to know about it.

---

## Level 1 vs Level 2 Structure

### Level 1 (Exploratory/Demo)

A simpler structure for prototypes and demos:

```
[project-name]/
├── CLAUDE.md
├── README.md
├── context/                        # From intake
│   ├── requirements.md
│   ├── decisions.md
│   └── constraints.md
├── docs/
│   ├── development/
│   │   ├── sdd-[TICKET].md        # One SDD per ticket (no PR# needed)
│   │   └── archive/
│   ├── planning/
│   │   ├── plan-[TICKET].md       # One plan per ticket
│   │   ├── project-checklist.md   # Simple ticket tracking
│   │   └── archive/
│   └── requirements/
│       └── prd-*.md               # If PRD exists from PM project
├── .claude/
│   ├── commands/
│   │   ├── start-ticket.md
│   │   ├── plan-ticket.md
│   │   ├── implement.md
│   │   └── complete-ticket.md
│   ├── agents/
│   │   └── sdd-generator.md
│   └── skills/
│       └── [project-specific]/
└── [source code]
```

**What's missing vs Level 2:** No living documents, no target docs, no capture-learnings, no ADRs, no multi-PR tracking. These are added when the project graduates.

---

## Context Files (From Intake)

Context files are created during intake and serve as the project's foundation. They inform the generation of living documents and command configurations.

| File | What It Captures |
|------|------------------|
| `context/requirements.md` | Purpose, users, success criteria, development approach |
| `context/decisions.md` | Key decisions with rationale (numbered, with status) |
| `context/constraints.md` | Technical constraints, team limits, timeline, infrastructure |
| `context/questions.md` | Open questions with "what we know / don't know / how to explore" |

---

## SDD Structure

The Software Design Document is the most important active document. It feeds directly into implementation.

**Typical SDD sections:**

1. **Overview** — What this PR implements, why, relationship to the issue
2. **Architecture** — Component design, data models, API changes (with mermaid diagrams)
3. **Implementation approach** — Key technical decisions, patterns to follow
4. **Test design** — Specification-based test expectations:
   - Invariants that must hold
   - Expected behaviors to verify
   - Failure modes to catch
   - Edge cases to cover
5. **Dependencies** — What this PR depends on, what depends on it
6. **Risks and mitigations** — What could go wrong, how we handle it

---

## Plan Structure

The implementation plan is the execution roadmap. `/implement` reads this file and works through subtasks sequentially.

**Typical plan sections:**

1. **Overview** — Branch, issue reference, effort estimate
2. **Subtasks** — Ordered list with checkboxes:
   ```
   - [ ] Subtask 1: Description
     - Success criteria: ...
     - Files to create/modify: ...
   - [ ] Subtask 2: Description
     ...
   ```
3. **Definition of done** — What "complete" means for this PR
4. **Notes** — Context the implementer needs

**Key principle:** Each subtask corresponds to one `/implement` call. Subtasks should be sized for a single focused implementation pass.

---

## Git Configuration

The project should have its own git repository. Suggested `.gitignore`:

```
.DS_Store
*.swp
*.swo
.claude/settings.local.json
node_modules/
dist/
.env
.env.local
```

---

## CLAUDE.md Sections

The CLAUDE.md for a software development project typically includes:

1. **Project identity** — What this is, tech stack, architecture overview
2. **Development workflow** — Command reference with the workflow sequence
3. **Coding standards** — Style, patterns, anti-patterns specific to this project
4. **Context hierarchy** — Which docs to read first (living docs → active docs → guides)
5. **Architecture patterns** — Key patterns in the codebase (component structure, data flow, state management)
6. **Testing conventions** — Framework, coverage targets, how tests relate to SDDs
7. **Git conventions** — Branch naming, commit format, PR process
8. **MCP servers** — What's required (Linear) and what's optional
9. **Cross-project references** — Sibling projects, shared libraries, external dependencies
10. **Key constraints** — Non-negotiables, anti-patterns to avoid
