# Simulations: Integration Guide

How to wire journey simulation into a companion project.

---

## Quick Start: Minimum Viable Simulation

1. **Ensure context files exist** — `context/requirements.md`, `context/constraints.md`, `context/decisions.md`, `context/questions.md`. These are what agents trace against.
2. **Run `/simulate`** — identifies key journeys, dispatches parallel agents, compiles findings.
3. **Review findings** — saved to `docs/simulations/findings/YYYY-MM-DD.md`.
4. **Address blockers** — resolve must-fix gaps before `/plan` or `/build`.
5. **Re-run after fixes** — verify resolved gaps and catch new ones.

---

## Directory Structure

The simulation capability persists data per-companion:

```
companions/[client]/[companion]/
└── docs/
    └── simulations/
        ├── journeys.md              # Journey definitions (persistent)
        └── findings/
            ├── 2026-03-27.md         # First simulation run
            ├── 2026-04-02.md         # Re-run after gap resolution
            └── ...                   # Each run is a dated snapshot
```

### journeys.md

Persistent record of all journey definitions. Accumulates over time as new journeys are added. Each journey tracks:

```markdown
### 1. [Journey Name]

| Field | Value |
|-------|-------|
| Actor | [who performs this journey] |
| Lifecycle | [start state] → [end state] |
| Feature boundaries crossed | [list of modules/systems traversed] |
| Steps | [count] |
| First simulated | [date] |
| Last simulated | [date] |

**Steps traced:**
1. [Step with specific check questions]
2. [Step with specific check questions]
...
```

The file also contains a **Simulation History** table linking each run to its findings file:

```markdown
## Simulation History

| Date | Journeys Run | Phase | Gaps | Contradictions | Handoffs | Findings |
|------|-------------|-------|------|----------------|----------|----------|
| 2026-03-27 | 1, 2, 3 | seeding | 30 | 10 | 32 | [2026-03-27](findings/2026-03-27.md) |
```

### findings/YYYY-MM-DD.md

Dated snapshot per simulation run. Contains:
- Executive summary (journeys run, total gap counts)
- Top N cross-journey gaps (ranked by severity and cross-journey frequency)
- All contradictions (table with sources and severity)
- All undocumented handoffs (grouped by actor type)
- Action classification (must-resolve, spike, assumption)
- Full per-journey step-by-step traces

Findings files are never overwritten — each run creates a new dated file. Comparing across dates shows gap resolution progress.

---

## When to Simulate

### Pre-/plan (Seeding → Cultivation Boundary)

**Trigger:** Vertical deep-dives are ~80%+ complete. Feature requirements are well-documented but integration hasn't been validated.

**What to look for:**
- Missing state machines (lifecycle transitions with no trigger)
- Identity/auth gaps across surfaces
- Undocumented handoffs between modules
- Contradictions between decisions made in different deep-dives

**Outcome:** Findings feed into `/plan` as explicit assumptions, blockers, or architectural spike tickets.

### Post-/plan (Cultivation → Shaping Boundary)

**Trigger:** Tickets are generated. Before `/build` starts.

**What to look for:**
- Gaps between ticket boundaries (feature A ticket doesn't account for handoff to feature B)
- Missing integration tickets (no ticket owns the seam between two features)
- Acceptance criteria that don't cover cross-ticket dependencies

**Outcome:** New tickets added, existing tickets revised, or integration acceptance criteria appended.

### Re-run (After Gap Resolution)

**Trigger:** Gaps from a previous simulation have been addressed. Need to verify resolution and check for new gaps.

**What to look for:**
- Previously identified gaps that are now documented/decided
- New gaps introduced by the decisions that resolved old ones
- Persistent gaps that were deferred but are now blocking

**Outcome:** Diff report showing resolved, persistent, and new gaps.

---

## Journey Design Patterns

### Good Journeys

A good simulation journey:

- **Crosses 3+ feature boundaries** — portal → registration → payment → auth → player
- **Covers the full lifecycle** — from first contact to final outcome, not just the happy path
- **Represents a real actor** — end-user, operator, admin, external party
- **Includes failure/edge paths** — what happens when payment fails, when a stream drops, when a trial expires

### Common Journey Archetypes

| Archetype | Actor | Typical Boundaries Crossed |
|-----------|-------|---------------------------|
| End-user lifecycle | Customer/user | Discovery → onboarding → core usage → edge cases → churn/renewal |
| Operator workflow | Internal staff | Lead → setup → support → monitor → report → handoff |
| Admin oversight | Platform admin | Config → monitoring → intervention → reporting → maintenance |
| External integration | Third party | Auth → API → data exchange → webhook → error handling |
| Billing lifecycle | Payer | Trial → conversion → payment → renewal → cancellation |

### Bad Journeys (Avoid)

- **Single-feature walkthrough** — "trace through the registration form" stays vertical, just re-reads the deep-dive
- **Happy path only** — misses error handling, edge cases, and failure recovery handoffs
- **Too granular** — 50+ steps per journey produces noise; aim for 10-20 meaningful steps
- **Too abstract** — "user uses the platform" doesn't cross specific boundaries

---

## Agent Prompt Template

Each journey is traced by a parallel agent. The agent prompt follows this structure:

```
You are simulating a **[Journey Name]** for [domain summary] to catch
integration gaps that feature-by-feature deep-dives miss.

## Your Task
Walk through every step of this journey and at each handoff point, check
if the current context documents answer: "Do we know what happens here?"

## Journey to Simulate
**[Journey Name]:** [Actor]: [start] → [end]

Detailed steps to trace:
1. [Step] — [specific questions to check]
2. [Step] — [specific questions to check]
...

At EACH step, answer:
- What do we know? (cite specific file + detail)
- What's missing or ambiguous?
- What handoff to the next step is undocumented?

## Files to Read
- [absolute path to requirements.md]
- [absolute path to constraints.md]
- [absolute path to decisions.md]
- [absolute path to questions.md]

## Output Format
[structured format with step-by-step trace, integration gaps,
contradictions, undocumented handoffs]

Do NOT suggest solutions. Just identify the gaps.
```

Key principles for agent prompts:
- **All actual values** — absolute paths, real domain summary, specific step questions. No placeholders.
- **Diagnosis only** — agents identify gaps, they do not propose solutions. Solutions come after the full picture is visible.
- **Cite sources** — agents must reference specific files and sections for every "Known" item.
- **Structured output** — consistent format enables cross-journey deduplication.

---

## Connecting Findings to Other Capabilities

### → Context Ecosystem
Simulation findings often reveal missing context. After a simulation:
- New decisions go into `context/decisions.md`
- New constraints go into `context/constraints.md`
- New questions go into `context/questions.md`

### → Strategic Planning
Contradictions found during simulation may challenge or refine the product hypothesis. Review findings against `context/strategic/hypothesis.md` if it exists.

### → Session Hygiene
Simulation runs should be checkpointed. Patterns discovered during simulations (e.g., "state machine gaps are common at this phase") feed into `tracking/patterns-discovered.md` via `/checkpoint`.

---

## Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| Running too early | Every step shows "missing" — findings aren't actionable | Wait until deep-dives are ~80%+ complete |
| Not persisting results | Next session can't re-run or compare | Always save to `docs/simulations/` |
| Mixing diagnosis and prescription | Gap list biased toward easy fixes, not important gaps | Agents identify gaps only; solutions are a separate step |
| Skipping re-runs | Gaps "addressed" but never verified | Re-run after resolving gaps to confirm and catch new ones |
| Same actor types | Multiple journeys trace the same perspective | Cover different actors — gaps appear at actor-boundary intersections |
| Ignoring simulation history | Previous insights lost across sessions | Always read `journeys.md` before proposing new journeys |
