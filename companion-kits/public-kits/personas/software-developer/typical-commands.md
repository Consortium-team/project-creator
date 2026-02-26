# Software Development: Typical Commands

Commands that software development projects typically have.

---

## The Core Workflow

Commands form a linear workflow. Each step depends on artifacts from previous steps.

```
/start-issue [TICKET]
    ↓
/setup-issue-docs                    (Level 2 only)
    ↓
/plan-pr [PR#]
    ↓
/implement [TICKET]                  (repeat per subtask)
    ↓
/capture-learnings                   (Level 2 only)
    ↓
/close-issue
```

**Level 1 (simplified):**
```
/start-ticket [TICKET] → /plan-ticket → /implement (repeat) → /complete-ticket
```

**Cross-cutting (any time):**
```
/status        — session start orientation
/checkpoint    — session end state preservation
/record        — session retrospective (what went well, what didn't)
/evolve        — process maturation (patterns → improvements)
```

---

## Issue Lifecycle Commands

### `/start-issue [TICKET]`
**Purpose:** Begin work on a Linear issue. Creates the branch and updates Linear status.

**What it does:**
1. Validates the Linear issue exists and reads its details
2. Creates a feature branch: `feat/[PREFIX]-[N]-description`
3. Updates Linear issue status to "In Progress"
4. Displays the issue title, description, and acceptance criteria
5. Advises next step: `/setup-issue-docs` (Level 2) or `/plan-pr` (Level 1)

**Developer action:** Select the ticket to work on.

**Key requirement:** Must have Linear MCP configured. Branch naming follows project conventions.

---

### `/setup-issue-docs` (Level 2 only)
**Purpose:** Generate the target documents that define what this issue should achieve.

**What it does:**
1. Reads the Linear issue details and acceptance criteria
2. Reads living documents (`current-architecture.md`, `current-features.md`, `current-security-assessment.md`)
3. Generates target documents:
   - `pr-tracking-[TICKET].md` — PR breakdown table (how many PRs, scope of each)
   - `target-features-[TICKET].md` — What features look like after this issue
   - `target-architecture-[TICKET].md` — Proposed architectural changes
   - `target-security-assessment-[TICKET].md` — Security implications
4. Presents targets for developer review

**Developer action:** Review target documents. Challenge proposed architecture. Adjust scope. This is the first major review checkpoint — get the targets right before planning.

**Key principle:** Target documents describe the destination. They are compared against living documents to show the delta this issue introduces.

---

### `/close-issue`
**Purpose:** Finalize the issue after all PRs are complete.

**What it does:**
1. Verifies all PRs in `pr-tracking-[TICKET].md` are complete
2. Verifies all tests pass on the main branch
3. Updates Linear issue status to "Done"
4. Adds a completion comment to the Linear issue summarizing what was built

**Developer action:** Confirm the issue is complete. Verify final state.

---

## Planning Commands

### `/plan-pr [PR#]`
**Purpose:** Generate the Software Design Document and implementation plan for a PR.

**What it does:**
1. Reads the Linear issue and PR scope (from `pr-tracking-[TICKET].md` or issue directly)
2. Reads all relevant context:
   - Living docs: `current-architecture.md`, `current-features.md`, `current-test-strategy.md`
   - Target docs: `target-architecture-[TICKET].md`, `target-features-[TICKET].md` (Level 2)
   - Guides: relevant `docs/development/guides/*.md`
   - Skills: project-specific skills
3. **Spawns SDD generator agent** — produces `sdd-[TICKET]-[PR#].md`:
   - Architecture and component design (with mermaid diagrams)
   - Data model changes
   - API changes
   - Test design section (invariants, expected behaviors, failure modes)
   - Risks and mitigations
4. **Spawns plan generator agent** — produces `plan-[TICKET]-[PR#].md`:
   - Ordered subtask list with checkboxes
   - Each subtask has success criteria and files to create/modify
   - Each subtask is sized for one `/implement` call
   - Test generation subtasks derived from SDD test design
5. Presents SDD and plan for developer review

**Developer action:** This is the most important review. Deep-read the SDD. Challenge the architecture. Verify the test design catches the right things. Confirm the plan ordering makes sense. Adjust via reprompting if needed — don't edit directly.

**Key principle:** The quality of `/implement` output is a direct function of the quality of the SDD and plan. Time spent here saves time everywhere else.

**Level 1 variant (`/plan-ticket`):** Simplified — one SDD + one plan per ticket. No target docs, no multi-PR breakdown.

---

## Implementation Commands

### `/implement [TICKET]`
**Purpose:** Execute the next incomplete subtask from the implementation plan.

**What it does:**
1. Reads the implementation plan (`plan-[TICKET]-[PR#].md`)
2. Identifies the next unchecked subtask
3. Reads all relevant context for that subtask:
   - The SDD (`sdd-[TICKET]-[PR#].md`)
   - Living docs (for current patterns and conventions)
   - Project skills (coding standards, framework patterns)
4. Implements the subtask:
   - Writes/modifies source code
   - Generates tests from the SDD test design (specification-based, not implementation-based)
   - Runs tests to verify
   - Creates git commit(s)
5. Updates the plan with completion checkmark and timestamp
6. Reports what was done and what's next

**Developer action:** Review the output. Check that the code matches the SDD. Check that tests actually validate behavior. If quality is off, **fix the SDD or plan** via reprompting — not the code.

**Critical rules:**
- Run `/clear` before each `/implement` call to start with fresh context
- One subtask per call — don't try to do multiple at once
- If a subtask fails or produces poor output, that's a signal the SDD needs adjustment

**What "fix the plan, not the code" means in practice:**
```
1. /implement → code doesn't match expectations
2. Review the SDD — is the design clear enough?
3. If not: reprompt to update the SDD section
4. Re-run /implement for that subtask
5. Repeat until the SDD produces the right code
```

---

## Learning Commands (Level 2)

### `/capture-learnings`
**Purpose:** After an issue is complete, update living documents with what was built and learned.

**What it does:**
1. Reads all completed plans and SDDs for this issue
2. **Updates living documents:**
   - `current-features.md` — adds new feature descriptions with issue number and date
   - `current-architecture.md` — merges target architecture into the living doc
   - `current-security-assessment.md` — adds security findings and remediations
   - `current-test-strategy.md` — updates with test learnings (new invariants, coverage changes)
3. **Creates permanent records:**
   - ADRs for major architectural decisions (`adr/ADR-NNN-*.md`)
   - Guides for repeatable procedures (`guides/*.md`)
4. **Archives completed documents:**
   - Moves SDDs to `docs/development/archive/`
   - Moves plans to `docs/planning/archive/`
   - Moves target docs to their respective `archive/` directories
5. Updates `pr-tracking-[TICKET].md` status to complete
6. Creates a summary commit

**Developer action:** Review the updated living documents. Verify the architecture description is accurate. Check that ADRs capture the right rationale.

**Why this matters:** This is the learning loop. Without it, each issue starts from scratch. With it, each issue starts with richer context, which means better SDDs, which means better code.

---

## Operations Commands

### `/status`
**Purpose:** Quick orientation at session start.

**What it does:**
1. Shows current branch and Linear issue
2. Reads implementation plan — shows progress (X of Y subtasks complete)
3. Shows recent commits
4. Recommends next action

**Developer action:** Glance and continue. This is a 30-second orientation.

---

### `/checkpoint`
**Purpose:** End-of-session capture before context is lost.

**What it does:**
1. Summarizes what was accomplished this session
2. Notes any issues, blockers, or design questions that emerged
3. Updates tracking files
4. Identifies concrete next steps
5. Prepares handoff notes for the next session

**Developer action:** Run before ending a session. Ensures continuity.

---

## Evolution Commands

### `/record`
**Purpose:** Developer feedback on the project configuration itself — not the artifact being built, but how the commands, agents, skills, and workflow are performing.

**When to use:** After a session where things could have gone better. The developer feels friction — excessive reprompting, repeated mistakes from the LLM, plans that miss the mark, design approaches that don't fit. This is the developer's channel for saying "the project configuration needs to improve."

**What it does:**
1. The developer typically initiates with what went wrong. If they don't provide enough detail, uses focused reverse prompting (2-3 questions, not a survey):
   - "What were you having to reprompt, and what was the gap between what you expected and what you got?"
   - "Are you seeing the same kinds of mistakes across sessions? What pattern?"
   - "Was this a plan/design quality issue, a code generation issue, or a workflow friction issue?"
2. Writes a dated entry to `docs/evolution/session-records.md`
3. Categorizes observations by configuration surface area: command behavior, SDD template quality, plan structure, agent output quality, missing skills, test design gaps, workflow friction
4. Flags recurring patterns (same observation 2+ times across entries)

**Developer action:** Run when frustrated or when output quality drops. Not mandatory, not routine. The trigger is "things could have gone better" — the developer explains why and the record captures what needs to change in the configuration.

**What `/record` captures that `/checkpoint` and `/capture-learnings` don't:**
- `/checkpoint` captures *session state* (what happened, next steps)
- `/capture-learnings` captures *what was built* (architecture, features, security knowledge)
- `/record` captures *how the project configuration performed* — reprompting patterns, repeated LLM mistakes, plan/design quality gaps, command behavior issues

**Output:** Accumulated entries in `docs/evolution/session-records.md`. These feed `/evolve`.

---

### `/evolve`
**Purpose:** Analyze accumulated session records and suggest concrete maturation steps for the project.

**What it does:**
1. Reads all entries from `docs/evolution/session-records.md`
2. Identifies recurring patterns and themes across sessions
3. References [everything-claude-code](https://github.com/affaan-m/everything-claude-code) as a **critical thinking lens** — not a prescription. For each identified pattern:
   - Does the community have a proven approach for this?
   - Would it fit this project's lightweight-but-robust principle?
   - Is the project ready for it, or is it premature?
4. Produces a maturation proposal in `docs/evolution/evolution-proposal-[DATE].md`:
   - **Command changes** — update SDD template, adjust plan structure, modify workflow steps
   - **Agent additions** — add test-validator, code-review, or other agents
   - **Skill additions** — language-specific patterns, domain rules, framework conventions
   - **Maturity graduation** — suggest moving from Level 1 to Level 2 (or specific Level 2 features)
   - **Process changes** — adjust review depth, change the workflow cadence
5. Each recommendation includes: the pattern it addresses, the proposed change, the evidence from session records, and a critical assessment of trade-offs

**Developer action:** Review the proposal. Approve, reject, or modify recommendations. `/evolve` proposes; the developer decides. Same engagement-at-the-right-altitude principle — don't auto-apply changes.

**When to run:** Not every session. Periodically — after every 5-10 sessions, or when you sense the workflow isn't working as well as it could. Monthly cadence is a reasonable default.

**Key principle:** `/evolve` treats everything-claude-code as input to critical evaluation, not as authority. Community patterns are considered alongside this project's specific experience. Some community practices may be too heavy, some may not fit, some may be exactly right. The recommendation should articulate WHY, not just WHAT.

**The record-evolve relationship:**
- `/record` is **seeding** — capturing raw observations while they're fresh
- `/evolve` is **cultivation** — finding patterns across observations and shaping them into actionable improvements
- The developer approving changes is **shaping** — deciding what actually gets implemented

This applies the three-phase methodology to the process itself.

---

## Agents

Commands delegate heavy context work to specialized agents.

### SDD Generator Agent
**Purpose:** Produces Software Design Documents from project context.

**Invoked by:** `/plan-pr`

**What it reads:**
- Linear issue details and acceptance criteria
- `current-architecture.md` — current system state
- `current-features.md` — what's already built
- `current-test-strategy.md` — how we test
- `current-security-assessment.md` — security posture
- Target documents (Level 2) — where we're heading
- Relevant skills — tech stack patterns, coding standards
- Relevant guides — established procedures

**What it produces:** A complete SDD including architecture, components, data models, API changes, test design, and risks.

**Why a subagent:** SDD generation consumes a lot of context (all living docs, target docs, skills). Running it as a subagent keeps the primary context window focused on orchestration and developer interaction.

---

### Plan Generator Agent
**Purpose:** Produces implementation plans from SDDs.

**Invoked by:** `/plan-pr`

**What it reads:**
- The SDD just generated
- `current-architecture.md` — for implementation patterns
- Relevant guides — for established procedures

**What it produces:** An ordered implementation plan with subtasks, success criteria per subtask, and a definition of done.

**Key constraint:** Each subtask must be completable in a single `/implement` call.

---

### Test Validator Agent
**Purpose:** Adversarial review of generated tests.

**Invoked by:** `/implement` (after test generation) or on-demand

**What it checks:**
- Would this test pass even with a broken implementation?
- Are assertions specific enough to catch regressions?
- Do tests validate behavior from the SDD specification, not just implementation details?
- Are edge cases from the SDD test design section covered?
- Would these tests survive reasonable refactoring?

**What it produces:** A review report with flagged issues and recommendations.

**Why this matters:** LLMs exhibit a "bias to please" — they write tests that pass, not tests that catch bugs. The test validator counters this by reviewing adversarially.

---

## Skills

Skills provide domain knowledge that agents and commands reference. The base set is minimal — enhance during intake from everything-claude-code.

### Linear Workflow Skill
**Always included.** Patterns for interacting with Linear: fetching tickets, updating status, creating issues, managing dependencies. Ensures consistent Linear usage across all commands.

### Project-Specific Skills (Added During Intake)
Examples of skills that might be added based on the project:
- **Coding standards skill** — Language/framework conventions (TypeScript strict mode, React patterns, Go idioms)
- **Design system skill** — Brand colors, component patterns, typography
- **Domain rules skill** — Business logic invariants, validation rules, calculation patterns
- **Infrastructure skill** — Deployment patterns, environment configuration

**Principle:** Skills reduce hallucination by giving agents explicit knowledge instead of hoping they infer it. But each skill is cognitive load. Only add what demonstrably improves output.

---

## Command Principles

### Fix the Plan, Not the Code
When `/implement` output doesn't meet expectations, the solution is upstream:
1. Identify what's wrong with the code
2. Trace it to the SDD or plan
3. Reprompt to adjust the SDD or plan
4. Re-run `/implement`

Never directly edit generated code. If you need to edit code, that's a signal the plan needs to be better.

### Clear Context Between Implements
Run `/clear` before each `/implement` call. This ensures fresh context and prevents prior implementation details from polluting the next subtask.

### One Subtask Per Implement
Each `/implement` call does exactly one subtask. This keeps context focused and makes failures easy to diagnose.

### Developer Reviews, Not Developer Edits
The developer's job is to review SDDs, plans, and code — and to reprompt when things aren't right. They don't edit files directly. Everything is generated.

### Lightweight-but-Robust
Every command and agent must serve the principle that the developer's cognitive load stays at 6 documents. If a new command or agent doesn't reduce cognitive load or improve code quality, it doesn't belong.

---

## Command Dependencies

```
                    ┌───────────────────────────────────────────┐
                    │           Issue Setup                       │
                    │                                            │
                    │  /start-issue ──► /setup-issue-docs         │
                    │       │               │                    │
                    │       ▼               ▼                    │
                    │  branch created   target docs created      │
                    │  Linear updated   (Level 2)                │
                    └───────────────────────────────────────────┘
                                        │
                                        ▼
                    ┌───────────────────────────────────────────┐
                    │           Planning (per PR)                 │
                    │                                            │
                    │  /plan-pr                                   │
                    │       │                                    │
                    │       ├──► SDD generator agent              │
                    │       │       └──► sdd-[TICKET]-[PR#].md   │
                    │       │                                    │
                    │       └──► Plan generator agent             │
                    │               └──► plan-[TICKET]-[PR#].md  │
                    └───────────────────────────────────────────┘
                                        │
                                        ▼
                    ┌───────────────────────────────────────────┐
                    │           Implementation                    │
                    │                                            │
                    │  /implement (repeat per subtask)            │
                    │       │                                    │
                    │       ├──► reads SDD + plan                 │
                    │       ├──► implements subtask               │
                    │       ├──► generates tests (spec-based)     │
                    │       ├──► test-validator agent reviews     │
                    │       └──► updates plan checkboxes          │
                    └───────────────────────────────────────────┘
                                        │
                                        ▼
                    ┌───────────────────────────────────────────┐
                    │           Completion                        │
                    │                                            │
                    │  /capture-learnings (Level 2)               │
                    │       │                                    │
                    │       ├──► updates living docs              │
                    │       ├──► creates ADRs                    │
                    │       ├──► archives completed docs          │
                    │       └──► creates guides                  │
                    │                                            │
                    │  /close-issue                               │
                    │       │                                    │
                    │       └──► Linear updated to Done           │
                    └───────────────────────────────────────────┘

Cross-cutting: /status (session start), /checkpoint (session end)
```
