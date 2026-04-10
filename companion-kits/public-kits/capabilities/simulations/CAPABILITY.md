# Capability: Simulations

Trace horizontal user journeys against context documents to catch integration gaps invisible in vertical feature deep-dives.

**Status**: EMERGING (validated in 2 companion projects)
**Created**: 2026-03-27
**Validation target**: Apply in 1-2 more companions at pre-plan or pre-build boundary to promote to ESTABLISHED

---

## What It Is

Vertical deep-dives capture feature requirements thoroughly — what each module does, what data it handles, what rules it follows. But they miss the handoffs: what happens when one module hands off to another? When a user action in one surface triggers a response in a different surface? When a state change in one system cascades through dependent systems? These integration gaps are invisible when looking at features in isolation.

Simulations solve this by tracing complete user journeys end-to-end against the existing context documents, checking at each step: "Do we know what happens here? Do we know how this step connects to the next?" The mechanism is deliberate horizontal traversal — crossing feature boundaries that vertical deep-dives stay within.

The standard approach is to finish deep-dives, declare seeding "complete," and let `/plan` generate tickets. Simulations insert a validation layer between seeding and planning (or between planning and building) that catches gaps at the cheapest possible moment — before tickets exist, not during build when rework is expensive.

---

## When to Use

| Companion Type | Usage | Weight |
|---------------|-------|--------|
| Product/PM | Pre-plan: simulate client, user, and operator journeys against requirements before generating tickets | Mandatory |
| Software Engineering | Pre-build: walk full request flows through specs/tickets before executing, catch architecture gaps at integration boundaries | Mandatory |
| Strategic/Financial | Pre-plan: trace decision flows through frameworks to check for missing inputs or circular dependencies | Strong |
| Game/Creative | Pre-build: simulate player experience flows through designed systems to find UX gaps between mechanics | Strong |
| Content/Writing | Pre-plan: trace reader/audience journey through content structure to verify narrative coherence | Moderate |
| Coaching/Mentor | Light — less spec-driven, but useful for tracing learner progression through curriculum | Light |

---

## How It Works

### 1. Identify Key Journeys

Read the companion's context files (requirements, constraints, decisions, questions) and identify the primary actor types and their end-to-end paths through the system. For each actor, map the complete lifecycle journey — from first contact to final outcome.

**Selecting journeys:**
- Prioritize journeys that cross the most feature boundaries
- Cover different actor types (end-user, operator, admin, external party)
- Include the full lifecycle (start to finish, not just the happy path)
- Aim for 2-4 journeys — fewer misses gaps, more has diminishing returns

**Bad journeys:** ones that stay within a single feature area (these are just re-reading the deep-dive).

Present the identified journeys to the user:

```
Based on the context, these are the key journeys to simulate:

1. **[Journey Name]** — [Actor]: [start] → [end] (crosses [N] feature boundaries)
2. **[Journey Name]** — [Actor]: [start] → [end] (crosses [N] feature boundaries)
3. **[Journey Name]** — [Actor]: [start] → [end] (crosses [N] feature boundaries)

Previously simulated journeys (if any):
- [Journey] — last run [date], found [N] gaps

Options:
(a) Run all proposed journeys
(b) Re-run previous journeys (verify if gaps have been addressed)
(c) Select specific journeys
(d) Suggest different journeys
```

If previous simulation data exists in `docs/simulations/journeys.md`, load journey definitions and simulation history. Offer to re-run previous journeys to verify whether identified gaps have been resolved, or to explore new journeys that cover different integration seams.

### 2. Trace Each Journey Step-by-Step

For each step in the journey, answer three questions against the context documents:
- **What do we know?** Cite specific file and section.
- **What's missing or ambiguous?** The gap.
- **What handoff to the next step is undocumented?** The integration seam.

### 3. Run Journeys in Parallel

Each journey is independent — run them as parallel agents. Each agent reads the same context files but traces a different path through them. This maximizes coverage while minimizing wall-clock time.

### 4. Compile Cross-Journey Findings

After all journeys complete, deduplicate and categorize:
- **Integration gaps** — missing connections between features
- **Contradictions** — decisions in one context that conflict with another
- **Undocumented handoffs** — transitions no document describes
- **State machine gaps** — lifecycle transitions with no defined trigger

If re-running previous journeys, diff against prior findings to highlight:
- **Resolved** — gaps from previous run that are now addressed
- **Persistent** — gaps that remain unresolved
- **New** — gaps not seen in previous runs

### 5. Classify Findings for Action

| Category | Action |
|----------|--------|
| Must resolve before proceeding | Design decisions needed — do them now |
| Should become architectural spikes | Early tickets in the plan with cross-cutting scope |
| Can be explicit assumptions | Document in plan preamble, revisit if wrong |

---

## Persistence

Simulation data is stored per-companion:

```
docs/simulations/
├── journeys.md              # Journey definitions — actors, steps, boundaries crossed
└── findings/
    ├── YYYY-MM-DD.md         # Findings per simulation run (dated snapshots)
    └── ...
```

- **`journeys.md`** — Persistent record of all journey definitions. New journeys are appended. Each journey tracks: actor, lifecycle, steps, feature boundaries crossed, first/last simulated dates. Includes a simulation history table linking runs to findings files.
- **`findings/YYYY-MM-DD.md`** — Dated snapshot per simulation run. Includes which journeys were run, all gaps/contradictions/handoffs found, and classification of findings. Comparing across dates shows which gaps were resolved vs persistent.

This structure enables:
- Cold-start: new session reads `journeys.md` to see what's been simulated before
- Re-runs: compare new findings against previous to track gap resolution
- Accumulation: new journeys are added as the companion evolves (e.g., post-build operational journeys)

---

## Key Principle: Horizontal Traversal Reveals Vertical Blind Spots

Deep-dives are vertical — they go deep into one feature area. Journeys are horizontal — they go wide across feature boundaries. The gaps live at the boundaries, not within the features. A feature can be perfectly specified in isolation and still fail at integration because nobody traced what happens when it hands off to the next feature. Simulations are the cheapest way to find these gaps: cheaper than discovering them during ticket generation, far cheaper than discovering them during build.

---

## Relationship to Other Capabilities

- **Context Ecosystem** — Simulations read the context files that Context Ecosystem maintains. Richer context = more effective simulation. Simulation findings flow back into context (new decisions, updated requirements).
- **Strategic Planning** — Simulations validate readiness for `/plan`. The findings directly shape plan structure (architectural spikes, assumption documentation, ticket sequencing).
- **Reverse Prompting** — Both extract implicit knowledge. Reverse prompting extracts from stakeholders; simulations extract from documents by stress-testing them against real usage paths.
- **Session Hygiene** — Simulation findings should be checkpointed. Patterns discovered during simulations feed back into the pattern registry.
- **Process Evolution** — Each simulation generates transferable patterns. The simulation technique itself evolves through use — from single-journey validation to multi-journey parallel simulation.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Simulating within a single feature | Stays vertical — just re-reads the deep-dive, finds nothing new | Choose journeys that cross 3+ feature boundaries |
| Running simulations too early | Not enough context captured — every step shows "missing" and findings aren't actionable | Run after vertical deep-dives are substantially complete (~80%+ seeding) |
| Proposing solutions during simulation | Mixes diagnosis with treatment — biases the gap list toward easy fixes, not important gaps | Identify gaps only. Solutions come after the full picture is visible |
| Single-journey simulation | Misses gaps that only appear when multiple actors interact with the same system | Run at least 2-3 journeys covering different actor types |
| Treating all gaps as blockers | Paralyzes progress — most gaps can be assumptions or spikes | Classify each gap: must-resolve, spike, or assumption |
| Never re-running simulations | Gaps identified but never verified as resolved — false confidence | Re-run previous journeys after addressing gaps to confirm resolution |
