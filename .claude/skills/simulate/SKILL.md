---
name: simulate
description: >
  Use when the user wants to trace user journeys through a companion's context to catch integration gaps.
  Triggers on requests to simulate journeys, run simulations, trace user flows, find handoff gaps,
  or validate readiness before /plan or /build. Works best after vertical deep-dives are substantially
  complete (~80%+ seeding or post-/plan).
disable-model-invocation: true
argument-hint: "[client/companion]"
---

# /simulate — Journey Simulation

Trace horizontal user journeys against context documents to catch integration gaps that feature-by-feature deep-dives miss.

**Usage:**
- `/simulate` — Use current companion
- `/simulate [client/companion]` — Override for specific companion

---

## Step 1: Determine the Companion

1. If `$ARGUMENTS` contains a companion path, use that
2. Otherwise, read `tracking/current-companion.md` for the current companion
3. If no companion is set:
   ```
   No companion set. Use /companion to set or create one first.
   ```

Store the companion path and resolve the absolute directory path.

---

## Step 2: Read Context

Read the companion's context files:
- `context/requirements.md`
- `context/constraints.md`
- `context/decisions.md`
- `context/questions.md`

Also check for:
- `docs/plans/` — implementation specs and tickets (if post-/plan)
- `CLAUDE.md` — project configuration and phase

Determine the companion's current phase (seeding, cultivation, shaping) and build a 2-3 sentence domain summary from what you read.

---

## Step 3: Check for Previous Simulations

Check if `docs/simulations/journeys.md` exists in the companion directory.

**If it exists:** Read it. Extract:
- Previous journey definitions (names, actors, steps, boundaries)
- Simulation history (dates, gap counts, findings file links)
- Last simulation date

**If it does not exist:** Note that this is a first simulation — no prior journeys to compare against.

---

## Step 4: Identify Key Journeys

Read the context files and identify the primary actor types and their end-to-end paths through the system.

**Journey selection criteria:**
- Must cross 3+ feature boundaries (not a single-feature walkthrough)
- Cover different actor types (end-user, operator, admin, external party)
- Include the full lifecycle (start to finish, not just the happy path)
- Aim for 2-4 journeys

For each journey, define:
- **Name** — descriptive label
- **Actor** — who is performing the journey
- **Lifecycle** — start state → end state
- **Steps** — numbered sequence of actions/transitions (aim for 10-20 steps)
- **Feature boundaries crossed** — which modules/systems the journey traverses

**Present to the user:**

```
## Journeys to Simulate

Based on the context, these are the key journeys:

1. **[Journey Name]** — [Actor]: [start] → [end] (crosses [N] feature boundaries)
   Steps: [brief list of key steps]

2. **[Journey Name]** — [Actor]: [start] → [end] (crosses [N] feature boundaries)
   Steps: [brief list of key steps]

3. **[Journey Name]** — [Actor]: [start] → [end] (crosses [N] feature boundaries)
   Steps: [brief list of key steps]
```

**If previous simulations exist, also show:**

```
Previously simulated journeys:
- [Journey] — last run [date], found [N] gaps ([M] resolved since)

Options:
(a) Run all proposed journeys
(b) Re-run previous journeys (verify if gaps have been addressed)
(c) Select specific journeys
(d) Suggest different journeys
```

**Wait for user selection before proceeding.**

---

## Step 5: Dispatch Journey Agents

For each selected journey, dispatch a parallel agent. Build the complete prompt with actual values — no placeholders.

Each agent receives the same context files but traces a different journey.

```
Agent tool call (one per journey, all in parallel):
  subagent_type: general-purpose
  description: "[Journey name] simulation"
  prompt: |
    You are simulating a **[Journey Name]** for [companion domain summary] to catch integration gaps that feature-by-feature deep-dives miss.

    ## Your Task
    Walk through every step of this journey and at each handoff point, check if the current context documents answer: "Do we know what happens here?" Flag gaps, ambiguities, contradictions, and undocumented handoffs.

    ## Journey to Simulate
    **[Journey Name]:** [Actor]: [start] → [end]

    Detailed steps to trace:
    [numbered list of all steps with specific questions to check at each]

    At EACH step, answer:
    - What do we know? (cite specific file + detail)
    - What's missing or ambiguous?
    - What handoff to the next step is undocumented?

    ## Files to Read
    Read these files to inform your simulation (read in parts if needed — they're large):
    - [ACTUAL absolute path to requirements.md]
    - [ACTUAL absolute path to constraints.md]
    - [ACTUAL absolute path to decisions.md]
    - [ACTUAL absolute path to questions.md]
    [If post-/plan, also include:]
    - [ACTUAL absolute path to implementation spec]
    - [ACTUAL absolute path to tickets.yaml]

    ## Output Format
    Return EXACTLY this format:

    # Journey [N]: [Journey Name] ([start] → [end])

    ## Step-by-Step Trace

    ### Step N: [Step Name]
    **Known:** [what's documented, with file reference]
    **Gap:** [what's missing or ambiguous]
    **Handoff issue:** [how transition to next step is unclear]

    [repeat for each step]

    ## Integration Gaps Found
    [numbered list of gaps only visible when tracing the full flow]

    ## Contradictions Found
    [any conflicts between documents or decisions]

    ## Undocumented Handoffs
    [transitions between features/systems that no document describes]

    Do NOT suggest solutions. Just identify the gaps. Be thorough and specific.
```

Wait for all agents to return.

---

## Step 6: Compile Cross-Journey Findings

After all agents return, compile a cumulative findings report:

1. **Deduplicate** — gaps found by multiple journeys are noted once with all journey references
2. **Categorize** into:
   - Integration gaps
   - Contradictions
   - Undocumented handoffs
   - State machine gaps (lifecycle transitions with no defined trigger)
3. **Rank** — gaps that surface across multiple journeys rank higher than single-journey gaps
4. **Classify for action:**

| Category | Action |
|----------|--------|
| Must resolve before proceeding | Design decisions needed — do them now |
| Should become architectural spikes | Early tickets in the plan with cross-cutting scope |
| Can be explicit assumptions | Document in plan preamble, revisit if wrong |

**If re-running previous journeys**, diff against prior findings:
- **Resolved** — gaps from previous run now addressed
- **Persistent** — gaps that remain
- **New** — gaps not seen before

---

## Step 7: Generate Top N Cross-Journey Gaps

From the deduplicated findings, identify the **Top N** gaps (typically 5-10) that represent the highest-risk integration points. For each:

- **Title** — descriptive name
- **Description** — what's missing and why it matters
- **Surfaces in** — which journeys and steps
- **Impact** — what goes wrong if not addressed before proceeding

---

## Step 8: Present Cumulative Report

Format and present the full report:

```
# Journey Simulation Findings — [client/companion]

**Date:** [today's date]
**Phase:** [current phase]

## Executive Summary

[N] journeys simulated:
1. **[Journey Name]** ([Actor]: [start] → [end]) — [N] steps
[repeat]

**Result:** [N] integration gaps, [N] contradictions, [N] undocumented handoffs.

## Top [N] Cross-Journey Gaps

[From Step 7 — ranked, with descriptions and impact]

## All Contradictions Found

[Table: #, Contradiction, Sources, Severity]

## All Undocumented Handoffs (Consolidated)

[Tables grouped by actor-facing vs operator-facing]

## Recommendations

### Must Resolve Before Proceeding
[numbered list]

### Should Become Architectural Spikes
[numbered list]

### Can Be Explicit Assumptions
[numbered list]

## Per-Journey Detail

[Include full step-by-step traces from each agent]
```

---

## Step 9: Persist Results

### 9a: Ensure Directory Structure

Create if not exists:
```
docs/simulations/
├── journeys.md
└── findings/
```

### 9b: Save Findings

Write the cumulative report to `docs/simulations/findings/[YYYY-MM-DD].md`.

### 9c: Update Journey Definitions

**If `journeys.md` exists:** Update `Last simulated` dates for re-run journeys. Append any new journey definitions. Add a row to the Simulation History table.

**If `journeys.md` does not exist:** Create it with all journey definitions and the first simulation history entry.

`journeys.md` format:

```markdown
# Journey Definitions — [client/companion]

Persistent record of all journeys identified and simulated.

---

## Journeys

### [N]. [Journey Name]

| Field | Value |
|-------|-------|
| Actor | [who] |
| Lifecycle | [start] → [end] |
| Feature boundaries crossed | [list] |
| Steps | [count] |
| First simulated | [date] |
| Last simulated | [date] |

**Steps traced:**
[numbered list]

---

[repeat for each journey]

## Simulation History

| Date | Journeys Run | Phase | Gaps | Contradictions | Handoffs | Findings |
|------|-------------|-------|------|----------------|----------|----------|
| [date] | [journey numbers] | [phase] | [N] | [N] | [N] | [link] |
```

---

## Step 10: Summary and Next Steps

```
## Simulation Complete

**Saved to:**
- docs/simulations/journeys.md (journey definitions)
- docs/simulations/findings/[date].md (findings report)

**Key numbers:** [N] gaps, [N] contradictions, [N] undocumented handoffs

**Top blockers:**
1. [gap] — [one-line impact]
2. [gap] — [one-line impact]
3. [gap] — [one-line impact]

[If pre-/plan:] Address blockers before running `/plan`, or carry as explicit assumptions.
[If post-/plan:] Review blockers against existing tickets — some may require new tickets or ticket revisions.
[If re-run:] [N] gaps resolved since last run, [N] persistent, [N] new.
```

---

## Guidelines

### Timing
- **Pre-/plan:** Run after vertical deep-dives are ~80%+ complete. Catches integration gaps before tickets are generated.
- **Post-/plan:** Run against specs and tickets to catch gaps between ticket boundaries.
- **Re-run:** After addressing gaps, re-run to verify resolution and catch new gaps.

### Journey Quality
- Journeys must cross feature boundaries — single-feature walkthroughs are just re-reading deep-dives
- Cover different actor types — gaps often appear when multiple actors interact with the same system
- Include the full lifecycle — truncated journeys miss state transition gaps

### Agent Discipline
- Agents identify gaps only — they do NOT propose solutions
- Agents cite specific files and sections for "Known" items
- Agents flag handoffs explicitly — the transition between steps is where gaps hide

### Persistence
- Always save findings — even partial simulations have value for future sessions
- Update journey definitions — last-simulated dates enable re-run tracking
- Findings are dated snapshots — never overwrite previous findings
