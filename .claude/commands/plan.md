# /plan — Consolidate Requirements into Implementation Plan

Transform captured requirements into a structured specification and actionable Linear tickets.

## Usage

```
/plan                     # Use current companion
/plan [client/companion]  # Override for specific companion
```

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Determine the Companion

1. If `$ARGUMENTS` contains a companion path, use that
2. Otherwise, read `tracking/current-companion.md` for the current companion
3. If no companion is set:
   ```
   No companion set. Use /companion to set or create one first.
   ```

**Resolve the absolute companion path from the filesystem — do NOT guess or construct it:**

```bash
realpath companions/[client]/[companion]/
```

Store this as the canonical `project_path`. This is the value that goes into the implementation spec frontmatter and tickets.yaml. The path MUST match where the companion actually lives on disk within the project-creator directory structure.

---

### Step 2: Gather All Context

Read everything available for the companion:

**Required files (in `companions/[client]/[companion]/`):**
- `context/requirements.md`
- `context/constraints.md`
- `context/decisions.md`

**Additional context (if present):**
- `context/questions.md` — Open questions
- `CLAUDE.md` — Existing companion configuration
- `README.md` — Human documentation
- `HANDOFF.md` — Previous session notes
- `docs/` — Any additional documentation

**Report what was found:**
```
## Context Gathered for [companion]

**Found:**
- requirements.md — [summary of what's there]
- constraints.md — [summary]
- decisions.md — [N decisions documented]

**Also found:**
- [list any additional files]

**Missing or empty:**
- [list anything expected but not found]
```

---

### Step 3: Assess Readiness for Planning

Before creating a plan, verify sufficient context exists for the companion.

**Minimum requirements for planning:**
- [ ] Purpose/problem statement is clear
- [ ] Core functionality is defined
- [ ] Key constraints are documented
- [ ] Success criteria exist

If critical gaps exist:

```
## Not Ready for Planning

Missing critical context:
- [list what's missing]

Before creating a plan, we need to capture:
1. [specific gap]
2. [specific gap]

Run `/gaps` for a full assessment, or continue with `/intake` to fill these gaps.
```

**Stop here if not ready.** Do not proceed with an incomplete plan.

---

### Step 4: Ask Clarifying Questions

Before creating the specification, ask questions about anything unclear or ambiguous:

**Technical decisions not yet made:**
- Architecture approach?
- Technology choices?
- Integration patterns?

**Scope boundaries:**
- What's in v1 vs. later?
- What's explicitly out of scope?

**Dependencies:**
- External tools, APIs, or services needed?
- Skills or MCPs required?

Ask questions **one at a time** until you have enough clarity to write a solid spec. Don't proceed with ambiguity — resolve it first.

```
Before I create the implementation spec, I have a few questions:

1. [First question]

(I'll ask follow-ups based on your answer)
```

---

### Step 5: Create the Implementation Specification

Once context is complete, create the spec document.

**Create directory if needed:**
```bash
mkdir -p companions/[client]/[companion]/docs/plans
```

**Write to:** `companions/[client]/[companion]/docs/plans/YYYY-MM-DD-implementation-spec.md`

**Specification Template:**

```markdown
---
project: [client]/[companion]
project_path: /absolute/path/to/companions/[client]/[companion]
created: YYYY-MM-DD
status: planned
---

# Implementation Spec: [Project Name]

**Created:** [Date]
**Status:** Draft — Awaiting Review

---

## Overview

### Problem Statement
[What problem does this solve? Why does it matter?]

### Solution Approach
[High-level approach to solving the problem]

### Success Criteria
[How we'll know it's working]
- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]
- [ ] [Measurable criterion 3]

---

## Architecture

### Structure

**IMPORTANT: Follow Claude Code project conventions:**
- `.claude/commands/` — Slash commands (e.g., /start-day, /process-meeting)
- `.claude/agents/` — Agent definitions
- `.claude/skills/` — Reusable skills
- `.claude/shortcuts/` — Scheduled shortcuts
- `templates/`, `context/`, `docs/` — Project-specific content (not in .claude/)

[Directory structure, key files, overall organization]

### Components
[Major components and their responsibilities]

| Component | Purpose | Notes |
|-----------|---------|-------|
| [Name] | [What it does] | [Key details] |

### Data Flow
[How data moves through the system]

---

## Dependencies

### External Tools
- [Tool 1] — [what it's used for]

### Skills / MCPs
- [Skill 1] — [purpose]

### Integrations
- [Integration 1] — [details]

---

## Constraints

### Technical
- [Constraint 1]

### Timeline
- [Constraint 1]

### Scope Boundaries
**In scope for v1:**
- [Item]

**Explicitly out of scope:**
- [Item]

---

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| [What was decided] | [Why] |

---

## Implementation Sequence

[High-level order of work]

1. **Foundation:** [What needs to be built first]
2. **Core functionality:** [Main features]
3. **Integration:** [How pieces connect]
4. **Polish:** [Final touches]

---

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk] | [What happens if it occurs] | [How to prevent/handle] |

---

## Open Questions

- [Any remaining questions to resolve during implementation]
```

---

### Step 6: Break Down into Tickets

Create tickets for each discrete piece of work.

**Ticket Requirements:**
1. **Single session scope** — Each ticket must be completable in one context session
2. **Size limit** — Only S (small) or M (medium) allowed. No L tickets.
3. **Self-contained** — A fresh agent should be able to execute it with just the ticket + project context
4. **Clear outputs** — Every ticket specifies what files to create/modify

**Ticket Template:**

```markdown
### [Ticket Number]: [Imperative title — "Build X", "Create Y"]

**Size:** S | M
**Blocked by:** [List ticket numbers, or "None"]

**Implementation Spec:** `docs/plans/YYYY-MM-DD-implementation-spec.md`

**Description:**
[What needs to be done and why]

**Acceptance Criteria:**
- [ ] [Specific, verifiable criterion]
- [ ] [Another criterion]
- [ ] [Another criterion]

**Input Files:**
- [Files to read for context]

**Output Files:**
- [Files to create or modify]

**Notes:**
[Any additional context or gotchas]
```

**Size Guidelines:**
| Size | Typical Scope | Examples |
|------|---------------|----------|
| S | Single file, straightforward logic | Create a command, write a config file |
| M | Multiple files, some complexity | Implement a feature, set up integration |

**If a ticket feels like L:**
- Split it into multiple M or S tickets
- Create a parent ticket that tracks the sub-tickets
- Each sub-ticket should be independently valuable

---

### Step 7: Validate All Tickets

Before writing to Linear, verify each ticket:

**Checklist for each ticket:**
- [ ] Title is imperative ("Build X", not "Building X" or "X")
- [ ] Description has enough context
- [ ] Acceptance criteria are specific and checkable
- [ ] Input files exist or will be created by a blocking ticket
- [ ] Output files are clearly specified
- [ ] Size is S or M (not L)
- [ ] Dependencies are correctly mapped

**Flag problems:**
```
## Validation Issues

**Ticket [N]: [Title]**
- Issue: [What's wrong]
- Recommendation: [How to fix]

Would you like me to revise these tickets before creating them in Linear?
```

---

### Step 8: Present Plan for Review

Before writing to Linear, present the complete plan:

```
## Implementation Plan: [companion]

**Spec:** docs/plans/YYYY-MM-DD-implementation-spec.md

### Tickets Overview

| # | Title | Size | Blocked By | Parallel? |
|---|-------|------|------------|-----------|
| 1 | [Title] | S | - | - |
| 2 | [Title] | M | 1 | - |
| 3 | [Title] | S | 1 | Yes (with 2) |
| 4 | [Title] | M | 2, 3 | - |

### Execution Sequence

**Phase 1: Foundation**
- Ticket 1: [Title]

**Phase 2: Core (can parallelize)**
- Ticket 2: [Title]
- Ticket 3: [Title] (parallel)

**Phase 3: Integration**
- Ticket 4: [Title]

### Total Estimate
- [N] tickets
- [X] S-sized, [Y] M-sized
- Critical path: Tickets [list]

---

**Review this plan before I create Linear tickets.**

Questions:
1. Does the scope look right?
2. Any missing pieces?
3. Should any tickets be combined or split further?
4. Which Linear project should I use? (Or should I create a new one?)
```

**Wait for user approval before proceeding to Step 9.**

---

### Step 9: Write to Linear

After user approves:

1. **Get/create Linear project:**
   - Ask user which Linear project to use
   - Or create a new project if requested

2. **Create parent issue:**
   - Title: `[Project Name] Implementation`
   - Description: Summary from spec (Overview section)
   - Link to the spec file in the description

3. **Create child issues for each ticket:**
   - Use the ticket title
   - Include full description, acceptance criteria, input/output files
   - Set estimate based on size (S=1, M=2)
   - Set up `blocks` relationships (use `type: "blocks"` with parent as issueId)

4. **Set priorities:**
   - Tickets with no dependencies get higher priority
   - Follow the execution sequence

5. **Create local tickets file:**

   Write to `companions/[client]/[companion]/docs/plans/tickets.yaml`

   **CRITICAL: Follow this schema EXACTLY. Do not rename fields, change casing, or omit fields. The `/build` command parses this file and will fail if the schema doesn't match.**

   ```yaml
   # Ticket manifest for [companion]
   # Generated by /plan on YYYY-MM-DD
   # SCHEMA VERSION: 1.0 — Do not modify field names

   project_name: "[human-readable project name]"
   project_path: "/absolute/path/to/companions/[client]/[companion]"
   spec_file: "docs/plans/YYYY-MM-DD-implementation-spec.md"
   linear_parent_issue: "CON-XX"

   tickets:
     - id: 1
       linear_id: "CON-XX"
       title: "Ticket title"
       size: "S"
       status: "pending"
       blocked_by: []
       description: |
         What needs to be done and why. Include enough context
         that a fresh agent with no prior knowledge can execute this.
       input_files:
         - "relative/path/to/input.md"
       output_files:
         - "relative/path/to/output.md"
       acceptance_criteria:
         - "First criterion — specific and verifiable"
         - "Second criterion — specific and verifiable"

     - id: 2
       linear_id: "CON-XX"
       title: "Second ticket"
       size: "M"
       status: "pending"
       blocked_by: [1]
       description: |
         Full description for a fresh agent.
       input_files:
         - "relative/path/to/input.md"
       output_files:
         - "relative/path/to/output.md"
       acceptance_criteria:
         - "Criterion"
   ```

   **Schema field reference (non-negotiable):**

   | Field | Type | Required | Notes |
   |-------|------|----------|-------|
   | `project_name` | string | yes | Top-level metadata |
   | `project_path` | string | yes | Absolute path to companion directory |
   | `spec_file` | string | yes | Relative path to implementation spec |
   | `linear_parent_issue` | string | yes | Parent Linear issue identifier |
   | `tickets[].id` | integer | yes | Sequential: 1, 2, 3... (NOT Linear IDs) |
   | `tickets[].linear_id` | string | yes | Linear identifier: "CON-XX" |
   | `tickets[].title` | string | yes | Imperative title |
   | `tickets[].size` | string | yes | "S" or "M" |
   | `tickets[].status` | string | yes | "pending" at creation |
   | `tickets[].blocked_by` | list[int] | yes | List of ticket `id`s, or empty `[]` |
   | `tickets[].description` | string | yes | Full description for agent execution |
   | `tickets[].input_files` | list[string] | yes | Relative paths from project root |
   | `tickets[].output_files` | list[string] | yes | Relative paths from project root |
   | `tickets[].acceptance_criteria` | list[string] | yes | Specific, verifiable criteria |

6. **Create build progress tracking file:**

   Write to `companions/[client]/[companion]/docs/plans/build-progress.md`:

   ```markdown
   # Build Progress

   **Spec:** docs/plans/YYYY-MM-DD-implementation-spec.md
   **Started:** (not started)
   **Last Updated:** (not started)

   ## Ticket Status

   | # | Ticket | Status | Completed |
   |---|--------|--------|-----------|
   | 1 | [Title] | pending | - |
   | 2 | [Title] | pending | - |

   ## Execution Log

   (Updated by /build as tickets complete)
   ```

---

### Step 10: Final Report

After tickets are created:

```
## Plan Complete: [companion]

**Spec:** docs/plans/YYYY-MM-DD-implementation-spec.md

**Linear Project:** [Project name with link]

**Tickets created:** [N] tickets

| # | Ticket | Size | Status | Linear |
|---|--------|------|--------|--------|
| 1 | [Title] | S | Ready | [ABC-123](url) |
| 2 | [Title] | M | Blocked by 1 | [ABC-124](url) |
...

**Execution order:**
1. Start with: [Ticket(s) with no blockers]
2. Then: [Next tickets]
3. Finally: [Last tickets]

**Parallel opportunities:**
- After ticket [N] completes, tickets [X, Y] can run in parallel

**Local files created:**
- `docs/plans/YYYY-MM-DD-implementation-spec.md` — Full specification
- `docs/plans/tickets.yaml` — Structured ticket data for /build
- `docs/plans/build-progress.md` — Progress tracking

---

**Ready for `/build` when you want to start implementation.**

Next steps:
- Review tickets in Linear
- Adjust priorities if needed
- Run `/build` to start executing tickets
```

---

### Step 11: Update Tracking

Update `tracking/projects-log.md`:
- Change status from `seeding` to `cultivation`
- Add session entry noting the plan was created
- Record the spec file location

---

## Principles

### This is a Gate
The plan must be approved before `/build` can run. Don't rush through planning to get to building.

### Resolve Ambiguity First
If requirements are unclear, ask questions BEFORE creating tickets. A vague ticket becomes a failed implementation.

### Smaller is Better
Prefer more smaller tickets over fewer larger ones. Small tickets:
- Are easier to verify
- Fail faster if something's wrong
- Allow parallel work
- Maintain context better

### Sequential by Default
Only mark tickets as parallelizable when they're truly independent. Dependencies are the norm.

### Self-Contained Tickets
Each ticket must be executable by a fresh agent with no prior context. Include:
- Enough description to understand the task
- Specific files to read for context
- Clear outputs to produce
- Verifiable acceptance criteria

### Plans Evolve
The initial plan isn't final. It will change during implementation. That's okay — the goal is a good starting point, not a perfect prediction.
