# Project Type: Software Development

A Claude Code project for building and maintaining software where the developer is deeply engaged at the planning and review level, while code is 100% AI-generated through a document-driven workflow.

---

## When to Use This Type

Use this type when:
- The goal is to **build or maintain software** (greenfield or existing codebase)
- The developer wants to stay engaged with design, planning, and code review — not write code directly
- A document-driven workflow provides the context that makes AI code generation reliable
- The project needs to scale over time, team size, and codebase complexity
- Linear is available for ticket management and cross-context persistence

**Not for:**
- Throwaway scripts or one-off automation (just use Claude Code directly)
- Projects where the developer wants to write code themselves (traditional workflow)
- Pure exploration with no intent to ship (use a product-manager type instead)
- Demo/prototype generation where developer disengagement is acceptable (use a lighter workflow like sdd-gen)

---

## Archetype

**Engaged Developer** — The developer brings domain knowledge, architectural judgment, and quality standards. Claude brings code generation, pattern execution, and tireless implementation. The developer's job is to get the plan right; Claude's job is to execute it faithfully. Neither works well without the other.

---

## The Document-Driven Development Pattern

Software development projects use a **docs context ecosystem** as the operating system for AI code generation. The quality of generated code is a direct function of the quality of the planning documents. When code quality drops, you fix the plan, not the code.

### Core Principle: Developer Engagement at the Right Altitude

The developer is not writing code, but they are deeply engaged:
- **Reviewing SDDs** — "This approach won't scale" / "You're missing this edge case"
- **Approving plans** — "The subtask ordering is wrong" / "This dependency is backwards"
- **Doing code reviews** — PR review, checking generated code against the SDD
- **Tuning via reprompting** — Adjusting plans when output doesn't meet standards

Everything — documents and code — is generated and tuned via reprompting, never directly edited.

### The Workflow

| Phase | What Happens | Developer Role |
|-------|--------------|----------------|
| **Start** | Pick a ticket from Linear, create branch | Select what to work on |
| **Setup** | Generate target docs (architecture, features, security) | Review targets against current state |
| **Plan** | Generate SDD + implementation plan (via subagents) | Deep review of design and plan |
| **Implement** | Execute plan subtask by subtask (`/implement` per subtask) | Monitor output, review code |
| **Capture** | Update living docs, create ADRs, archive completed docs | Review what was learned |
| **Close** | PR, code review, merge | Verify PR comments, approve |

### Why This Beats Autonomous Loops

Autonomous approaches (like Ralph Wiggum) trade developer engagement for iteration speed. They work when success is objectively measurable (all tests pass), but fail when the domain requires human judgment about what "right" means.

This workflow keeps the developer engaged where it matters most — the planning layer — while still getting 100% generated code. The result scales better over project size, team size, and time because:
- Living documents accumulate project knowledge across sessions
- The capture-learnings loop feeds implementation insights back into context
- New team members read current-architecture.md instead of reverse-engineering the codebase
- Every architectural decision is preserved in ADRs

---

## Maturation Model

Projects mature through two levels. Both share the same docs directory structure, so graduating is additive — not a rewrite.

### Level 1: Exploratory / Demo

For prototypes, demos, proof-of-concepts, and early-stage projects.

| Aspect | Level 1 |
|--------|---------|
| **Workflow** | Ticket → SDD + Plan → Implement → Archive |
| **Living docs** | Optional (project may not live long enough) |
| **Review depth** | Lighter — scan SDDs, spot-check code |
| **Capture-learnings** | Skip or minimal |
| **ADRs** | Not needed |
| **Multi-PR per issue** | No — one ticket = one PR |
| **Test strategy** | Basic — test design in SDD, standard coverage |

### Level 2: Production

For long-lived applications, team projects, and production systems.

| Aspect | Level 2 |
|--------|---------|
| **Workflow** | Start issue → Setup target docs → Plan PR (per PR) → Implement → Capture learnings → Close issue |
| **Living docs** | Required — `current-architecture.md`, `current-features.md`, `current-security-assessment.md`, `current-test-strategy.md` |
| **Review depth** | Deep — scrutinize SDDs, review all plans, thorough code review |
| **Capture-learnings** | Required — updates living docs, creates ADRs and guides |
| **ADRs** | Yes — major architectural decisions preserved |
| **Multi-PR per issue** | Yes — complex issues decompose into multiple PRs |
| **Test strategy** | Specification-based — test design in SDD, project-level test strategy, adversarial review |

### Graduating from Level 1 to Level 2

When a prototype becomes a real product:
1. Create the living documents (generate `current-architecture.md` from codebase analysis)
2. Add the capture-learnings command
3. Start writing ADRs for significant decisions
4. Adopt multi-PR per issue for complex work
5. Establish the test strategy document

The docs directory structure is the same at both levels — Level 2 adds files and commands, never reorganizes.

---

## Lightweight-but-Robust: The First Principle

This type deliberately keeps process lightweight. The developer's cognitive load at any point in the workflow is limited to a small, predictable set of documents:

**Active document set (at any time during implementation):**

| # | Document | Purpose |
|---|----------|---------|
| 1 | `current-architecture.md` | Living technical reference |
| 2 | `current-features.md` | Feature inventory |
| 3 | `current-security-assessment.md` | Security posture |
| 4 | `current-test-strategy.md` | Test philosophy, coverage targets, invariants |
| 5 | `sdd-[ticket]-[pr].md` | Design doc for the current work (includes test design) |
| 6 | `plan-[ticket]-[pr].md` | Implementation plan with subtask checkboxes |

That's 6 documents. The commands handle creation, updating, and archiving automatically. The developer never manages documents — they review the right doc at the right time.

This also optimizes token usage for the LLM — it reads a focused context window, not everything.

---

## Key Concepts

### The Docs Context Ecosystem

The `docs/` directory isn't documentation — it's the **context that makes code generation reliable.** Documents have a lifecycle:

1. **Created** — by commands during setup and planning
2. **Active** — read by agents during implementation, reviewed by developer
3. **Captured** — learnings merged into living documents after completion
4. **Archived** — completed docs moved to `archive/` subdirectories

Living documents (`current-*.md`) accumulate project knowledge. They are the "as-is" truth. Target documents and plans are temporary — they exist for a single issue/PR and are archived when complete.

### Specification-Based Testing

Testing is a known LLM weakness. LLMs exhibit a "bias to please" — they write tests that confirm the implementation works rather than tests that would catch if it didn't. TDD has the same problem when the LLM writes both tests and code.

This type addresses testing through specification-based design:
- **Project-level test strategy** (`current-test-strategy.md`) — overall approach, coverage targets, invariants, threat models
- **Per-PR test design** (section in the SDD) — specific test expectations, invariants, and failure modes
- Tests are derived from the SDD specification, not the implementation
- When tests don't catch issues, fix the test design in the SDD, not the tests directly

### Subagent Architecture

Commands are thin orchestrators. Heavy context work is delegated to subagents:
- **SDD agent** — pulls in all context, produces the software design document
- **Planning agent** — takes the SDD, produces the implementation plan
- **Test validator agent** — adversarially reviews generated tests
- **Code review agent** — reviews generated code against the SDD

Subagents conserve the primary context window. The developer sees the command and reviews the output — they don't need the generation details.

Subagents can leverage skills internally — the SDD agent might pull in a React Flow skill when designing a visualization, or a security skill when working on auth. The agent decides what's relevant.

### Everything-Claude-Code as Critical Thinking Reference

The [everything-claude-code](https://github.com/affaan-m/everything-claude-code) repository represents community consensus on Claude Code project configuration. It is NOT a catalog to copy from — it's a **critical thinking reference** used throughout the project lifecycle:

- **During intake** — evaluate which community patterns fit this project's specific needs
- **During `/evolve`** — when session records reveal process gaps, reference community patterns as potential solutions
- **During planning** — when designing SDDs for unfamiliar domains, check what community patterns exist

The relationship is critical and creative: community patterns are considered alongside this project's specific experience. Some may be too heavy, some may not fit, some may be exactly right. The evaluation should articulate WHY, not just WHAT.

### Process Evolution

Projects improve through developer feedback on the configuration itself:
- **`/record`** — Developer feedback on how the project configuration is performing. Triggered when things could have gone better — excessive reprompting, repeated LLM mistakes, plans that miss the mark. The developer explains what went wrong; the record captures what needs to change in commands, agents, skills, or workflow.
- **`/evolve`** — Periodic analysis of accumulated records. Identifies patterns across developer feedback and proposes concrete maturation steps: command changes, agent additions, skill additions, maturity graduation, process adjustments. References everything-claude-code as a critical thinking lens, not a prescription.

This applies the three-phase methodology to the process itself: `/record` is seeding (capturing developer observations about configuration quality), `/evolve` is cultivation (finding patterns and shaping improvements), and the developer approving changes is shaping (deciding what gets implemented).

### Git-Based CI/CD

Keep it simple. Git is the pipeline:
- Feature branches per ticket/PR
- Commits during implementation
- Pull requests for review
- PR comments as the code review interface
- Merge to main on approval

No heavyweight CI/CD tooling prescribed. Projects add what they need.

---

## What Varies

| Dimension | Options |
|-----------|---------|
| **Tech stack** | Any — React, Python, Go, monorepo, microservices, etc. |
| **Project maturity** | Greenfield, existing codebase, migration |
| **Team size** | Solo developer, small team, large team |
| **Maturation level** | Level 1 (exploratory) or Level 2 (production) |
| **Testing depth** | Basic coverage → specification-based → adversarial/mutation |
| **Domain complexity** | Simple CRUD → complex business logic → distributed systems |
| **Companion projects** | Standalone, sibling PM project, multiple related services |

---

## What's Universal

- Document-driven development (docs as context for code generation)
- Developer engagement at the planning/review altitude
- The 6-document active set pattern
- Core workflow commands: `/start-issue`, `/plan-pr`, `/implement`, `/capture-learnings`, `/close-issue`
- Evolution commands: `/record` (retrospective), `/evolve` (maturation proposals)
- Living documents: `current-architecture.md`, `current-features.md`, `current-security-assessment.md`, `current-test-strategy.md`
- SDD + implementation plan per PR
- Archive lifecycle for completed docs
- Specification-based testing (test design in SDD)
- Git-based workflow (branches, PRs, code review)
- Linear for ticket management
- Everything-claude-code as critical thinking reference (not prescription)
- Everything generated via reprompting, never directly edited
- Lightweight-but-robust as the governing principle

---

## Success Indicators

- Code is generated with minimal reprompting between `/implement` calls
- When code quality drops, the developer identifies the upstream plan issue (not a code issue)
- Living documents stay current and accurate across issues
- New team members can onboard by reading `current-architecture.md` and `CLAUDE.md`
- The active document set stays at 6 — process doesn't bloat over time
- SDDs are reviewed and challenged before implementation begins
- Test design catches issues that implementation-derived tests would miss
- Architectural decisions are preserved and searchable in ADRs
- The project feels like a well-managed engineering effort, not "AI writing code"
