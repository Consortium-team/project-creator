# Capability: Context Ecosystem

The standard pattern for capturing and persisting project context in files that survive context compaction, session boundaries, and model limitations.

---

## What It Is

Context compaction is the fundamental constraint of long-running AI companion projects. When the conversation grows too long, older context is lost. The context ecosystem solves this by externalizing everything important into structured files that persist on disk.

The principle is simple: **Everything important goes in files, not conversation.** If something matters, it must be written to a file. If it only exists in conversation, it will eventually be lost.

This is not just a backup strategy — it is the foundation that makes every other capability work. Reverse prompting produces context files. Strategic planning reads and writes context files. Meeting processing connects new information to existing context files. Without the context ecosystem, every session starts from scratch.

---

## When to Use

Every companion project. This capability is universal and non-optional. The question is not whether to use it but how to extend it for the specific persona.

---

## Core Files

Every companion project starts with four core context files.

### requirements.md

What the project needs to accomplish. Written incrementally through reverse prompting — not as a monolithic document, but as an accumulating record of captured requirements.

**Lifecycle:** Living (updated continuously as understanding deepens)

**Structure:**
```markdown
# Requirements

## Captured [date]
- [Requirement with source: who said it, when, why it matters]

## Captured [date]
- [More requirements as they emerge]
```

### constraints.md

Hard boundaries the project must operate within. Technical limits, time constraints, resource constraints, organizational constraints, non-negotiable rules.

**Lifecycle:** Living (updated as new constraints are discovered)

**Structure:**
```markdown
# Constraints

## Technical
- [Constraint with rationale]

## Resource
- [Constraint with rationale]

## Organizational
- [Constraint with rationale]

## Non-Negotiable
- [Constraint that cannot be traded off]
```

### decisions.md

Decisions that have been made, with rationale and alternatives considered. This is the record of "why we chose this" — critical for future sessions that may not remember the reasoning.

**Lifecycle:** Living (new decisions appended, old decisions rarely changed)

**Structure:**
```markdown
# Decisions

## [Date] — [Decision Title]
**Decision:** [What was decided]
**Rationale:** [Why this was chosen]
**Alternatives considered:** [What was rejected and why]
**Status:** [Active | Superseded by [other decision]]
```

### questions.md

Open questions that need answers. Items that came up during reverse prompting, meeting processing, or synthesis that could not be resolved in the moment.

**Lifecycle:** Active (questions are added and resolved; resolved questions move to decisions.md)

**Structure:**
```markdown
# Open Questions

## [Priority: High | Medium | Low]
- [Question with context about why it matters]
- [Question with context about why it matters]

## Resolved
- [Question] — Resolved [date]: [answer, pointer to decision]
```

---

## Document Lifecycles

Context files are not all the same. They have different lifecycles that determine how they are maintained.

### Living Documents

Updated continuously over time. They represent the current understanding and grow richer with each session.

**Examples:** requirements.md, constraints.md, decisions.md, author-profile.md, hypothesis.md, current-architecture.md

**Maintenance:** Read at session start, updated during session, the most recent content is always the most relevant.

### Active Documents

Created for a specific task or period and archived when the task is complete. They serve a temporary purpose.

**Examples:** questions.md, session-notes.md, sprint-plan.md, current-exploration.md

**Maintenance:** Created when needed, resolved items move to permanent documents, archived when the task completes.

### Permanent Documents

Written once and rarely modified. They capture decisions, completed artifacts, or reference material that does not change.

**Examples:** ADRs (architecture decision records), completed specs, reference guides, completed assessments

**Maintenance:** Created once, occasionally annotated with "superseded by" notes, never deleted.

---

## The Capture Principle

Context should be captured **as it emerges**, not after. When a reverse prompting session surfaces a new requirement, it goes into requirements.md immediately (after user confirmation) — not at the end of the session, not in a summary step, not "later."

Why this matters:
- If captured immediately, it is precise (the exact words are fresh)
- If captured later, it is summarized (details are lost)
- If the session is interrupted, immediate captures survive; deferred captures do not

The pattern: **Ask, confirm, file.** Every reverse prompting exchange should end with the companion writing the captured insight to the appropriate context file.

---

## Context File Reading Order

When a command needs to orient itself, it should read context files in a specific order:

1. **decisions.md** — What has been decided (highest authority)
2. **constraints.md** — What cannot be changed
3. **requirements.md** — What needs to be accomplished
4. **questions.md** — What is still open
5. **Persona-specific files** — Domain context that shapes interpretation

Decisions override requirements. Constraints override everything. Open questions signal where context is incomplete.

---

## File Organization

Context files live in a `context/` directory at the project root. Persona-specific extensions live in subdirectories.

```
project-root/
├── context/
│   ├── requirements.md        # Core
│   ├── constraints.md         # Core
│   ├── decisions.md           # Core
│   ├── questions.md           # Core
│   └── [persona-specific]/    # Extensions (see integration guide)
├── tracking/                  # Session and progress tracking
└── docs/                      # Permanent artifacts
```

---

## The Ecosystem Metaphor

This is called an "ecosystem" because the files are interconnected. A decision in decisions.md may resolve a question in questions.md. A constraint in constraints.md may invalidate a requirement in requirements.md. A new requirement may create new open questions.

Commands that modify one file should check whether the change affects other files. The `/gaps` command exists specifically to audit the ecosystem for inconsistencies, missing information, and stale content.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Context only in conversation | Lost at compaction | Externalize to files immediately |
| Monolithic context file | Hard to navigate, hard to update | Separate files by concern |
| Summary-only capture | Loses detail and nuance | Capture specifics with source attribution |
| Deferred capture | Risk of loss, summarization | Capture as it emerges (ask, confirm, file) |
| No lifecycle distinction | Living docs get stale, active docs clutter | Label and maintain by lifecycle type |
| No reading order | Commands interpret context inconsistently | Establish and document reading order |

---

## Reference

For the full context ecosystem theory, including session access models and shared context groups, see `methodology.md` in the project-creator root (section: "Context Ecosystem").
