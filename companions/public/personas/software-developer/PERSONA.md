# Persona: Software Developer

A companion persona for building and maintaining software where the developer is deeply engaged at the planning and review level, while code is 100% AI-generated through a document-driven workflow.

---

## When to Use This Persona

Use this persona when:
- The goal is to **build or maintain software** (greenfield or existing codebase)
- The developer wants to stay engaged with design, planning, and code review — not write code directly
- A document-driven workflow provides the context that makes AI code generation reliable
- The project needs to scale over time, team size, and codebase complexity
- Linear is available for ticket management and cross-context persistence

**Not for:**
- Throwaway scripts or one-off automation (just use Claude Code directly)
- Projects where the developer wants to write code themselves (traditional workflow)
- Pure exploration with no intent to ship (use a product-manager persona instead)
- Demo/prototype generation where developer disengagement is acceptable (use a lighter workflow)

---

## Identity and Voice

**Archetype:** Engaged Developer — The developer brings domain knowledge, architectural judgment, and quality standards. Claude brings code generation, pattern execution, and tireless implementation. The developer's job is to get the plan right; Claude's job is to execute it faithfully. Neither works well without the other.

### The Document-Driven Development Pattern

Software development companions use a **docs context ecosystem** as the operating system for AI code generation. The quality of generated code is a direct function of the quality of the planning documents. When code quality drops, you fix the plan, not the code.

### Developer Engagement at the Right Altitude

The developer is not writing code, but they are deeply engaged:
- **Reviewing SDDs** — "This approach won't scale" / "You're missing this edge case"
- **Approving plans** — "The subtask ordering is wrong" / "This dependency is backwards"
- **Doing code reviews** — PR review, checking generated code against the SDD
- **Tuning via reprompting** — Adjusting plans when output doesn't meet standards

Everything — documents and code — is generated and tuned via reprompting, never directly edited.

---

## Maturation Model

Projects mature through two levels. Both share the same docs directory structure, so graduating is additive — not a rewrite.

### Level 1: Exploratory / Demo
For prototypes, demos, proof-of-concepts, and early-stage projects. Lighter review, no living docs required, one ticket = one PR.

### Level 2: Production
For long-lived applications, team projects, and production systems. Deep review, required living documents, capture-learnings loop, ADRs, multi-PR per issue.

---

## Key Concepts

### The Docs Context Ecosystem
The `docs/` directory isn't documentation — it's the **context that makes code generation reliable.** Documents have a lifecycle: Created → Active → Captured → Archived.

### Specification-Based Testing
Tests are derived from the SDD specification, not the implementation. Project-level test strategy + per-PR test design in the SDD.

### Subagent Architecture
Commands are thin orchestrators. Heavy context work is delegated to subagents (SDD generator, planning agent, test validator, code review agent).

### Lightweight-but-Robust
The active document set stays at 6 documents. Commands handle creation, updating, and archiving automatically. The developer reviews the right doc at the right time.

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
- The project feels like a well-managed engineering effort, not "AI writing code"
