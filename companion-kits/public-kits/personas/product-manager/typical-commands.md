# Product Manager: Typical Commands

Commands that product manager projects typically have.

---

## Seeding Commands (Extract Product Thinking)

### `/explore "[topic]"`
**Purpose:** Open-ended PM ideation on a topic or question through reverse prompting.

**What it does:**
1. Reads current hypothesis from `tracking/hypothesis.md` (if one exists)
2. Reads relevant product context (vision, user-segments, feature-concepts)
3. Asks the founder to describe the topic or question
4. Uses one-question-at-a-time reverse prompting to go deeper
5. Pushes for specificity and testability throughout
6. Captures insights to appropriate `product/` files
7. Updates `tracking/session-log.md`

**PM voice behaviors:**
- "Who is the user here? Be specific."
- "What's the job to be done?"
- "How would we test this with $10K and 2 weeks?"
- "That sounds like a feature. What's the problem it solves?"

**Key requirement:** Never accept vague answers. Always push toward testable, specific thinking.

---

### `/process`
**Purpose:** Ingest external input (transcripts, documents, conversations) and extract product insights.

**What it does:**
1. Accepts pasted text, file reference, or transcript reference
2. Reads material and identifies product-relevant insights
3. Uses reverse prompting to clarify: "What's the product takeaway here?"
4. Connects new insights to prior context (references existing product/ files)
5. Flags contradictions with previous thinking
6. Writes structured insights to appropriate `product/` files
7. Updates `tracking/insights-log.md`

**Variants:**
- `/process transcript` — Optimize for conversation transcripts (Granola, meeting notes)
- `/process document` — Optimize for documents, articles, research
- `/process feedback` — Optimize for user feedback, support tickets

**Key insight:** The value isn't summarizing — it's connecting new information to existing product context and surfacing what changed.

---

### `/research "[product or domain]"`
**Purpose:** Analyze comparable products or market areas.

**What it does:**
1. Accepts a product name, URL, or domain area
2. Uses web search/fetch to gather information
3. Analyzes through PM lens: positioning, features, pricing, gaps
4. Produces structured comparison: what to borrow, what to avoid, relationship to our hypothesis
5. Uses reverse prompting: "What resonates for you? What's missing from their approach?"
6. Writes to `product/competitive-landscape.md`

**Key principle:** Research is mixed mode — web research (direct) followed by "what does this mean for us?" (reverse).

---

## Cultivation Command (Challenge + Connect)

### `/synthesize`
**Purpose:** Step back from accumulated context and find patterns.

**What it does:**
1. Reads ALL context files: `context/`, `product/`, `tracking/`
2. Identifies emerging themes across sessions
3. Surfaces contradictions and tensions
4. Notes what's crystallizing (ready for shaping) vs. what's still fuzzy
5. Uses mixed mode: analytical report + reverse prompting ("Does this match your intuition?")
6. Writes findings to `tracking/insights-log.md`

**When to use:** After several `/explore` or `/process` sessions, when there's enough material to find patterns.

**Key requirement:** Should work gracefully when context is sparse — "Not enough sessions yet to see patterns. Here's what I have so far..." rather than generating patterns from noise.

---

## Strategy Command (The Anchor)

### `/hypothesis`
**Purpose:** View, propose, or refine the product hypothesis — the central strategic artifact.

**Three modes:**
1. **View** — Show current hypothesis and test metrics (reads `tracking/hypothesis.md`)
2. **Propose** — Founder presents a hypothesis, PM pressure-tests it through reverse prompting
3. **Refine** — Revisit existing hypothesis in light of new information

**PM voice behaviors:**
- "Can you test that? What would prove it wrong?"
- "That's three hypotheses. Which one is the bet?"
- "Your hypothesis says X but your feature list says Y. Reconcile."
- "What's the cheapest way to validate this?"

**Key principle:** The hypothesis is the strategy anchor. Every `/spec`, `/plan`, and `/explore` session should reference it. If the hypothesis is unclear, the PM should push to clarify it before speccing anything.

**Output:** Updates `tracking/hypothesis.md` with current hypothesis, confidence level, test plan, and evidence.

---

## Shaping Commands (Generate Artifacts)

### `/spec "[feature or concept]"`
**Purpose:** Write formal feature specs or PRDs from cultivated thinking.

**What it does:**
1. Accepts a feature concept (must have been explored in prior sessions)
2. Reads product context and hypothesis
3. Enforces "only write what we know" — refuses to spec undiscovered things
4. Challenges during generation: "You're speccing X but haven't addressed Y"
5. Generates spec document in `docs/specs/`
6. References hypothesis as the decision lens for scope and priority

**Spec structure:**
- Problem statement
- User stories
- Requirements (must-have, should-have, won't-have)
- Success metrics
- Dependencies and constraints
- Open questions

**Key principle:** Specs are for ideas that have been explored and cultivated enough to articulate clearly. If the PM has to make up too many details, the idea isn't ready.

---

### `/plan "[spec or feature set]"`
**Purpose:** Break specs into epics, stories, and tickets for implementation.

**What it does:**
1. Accepts a spec or set of specs
2. Breaks features into epics → stories → tickets
3. Establishes dependencies and execution order
4. Creates Linear tickets (S and M sizing, each completable in a single session)
5. Creates local tracking files (`tickets.yaml`, `build-progress.md`)
6. Sets up `blockedBy` relationships in Linear

**Key principle:** Tickets should be self-contained and executable by a fresh dev agent. Include enough context, specific acceptance criteria, and clear input/output files.

---

## Operations Commands (Session Management)

### `/status`
**Purpose:** Quick orientation at session start.

**What it does:**
1. Reads `tracking/hypothesis.md` — current hypothesis state
2. Reads `tracking/session-log.md` — what happened in recent sessions
3. Reads `tracking/insights-log.md` — accumulated insights
4. Shows state of open questions from `context/questions.md`
5. Recommends what to work on next

**Key principle:** Fast and focused. The founder should know where they are in 30 seconds.

---

### `/gaps`
**Purpose:** Assess what's been captured vs. what's needed.

**What it does:**
1. Reads all context files and product files
2. Assesses completeness across dimensions: hypothesis clarity, user understanding, competitive awareness, feature definition, spec readiness
3. Produces prioritized gap list with recommended next steps
4. Suggests specific commands to run

**Assessment dimensions (adapt per project):**
- Hypothesis maturity (none → proposed → tested → validated)
- User segment clarity (vague → described → validated)
- Competitive understanding (unknown → researched → positioned)
- Feature concepts (brainstormed → explored → spec-ready)
- Specs produced (none → in progress → ready for dev)

---

### `/checkpoint`
**Purpose:** End-of-session capture — externalize important thinking before context is lost.

**What it does:**
1. Reviews what was discussed/decided this session
2. Captures decisions made, open questions surfaced, next steps identified
3. Writes dated entry to `tracking/session-log.md`
4. Updates any tracking files that changed during the session
5. Updates `tracking/next-actions.md` with prioritized queue

**Key principle:** Err on the side of capturing too much. Session context disappears; files persist.

---

## Command Principles

### Hypothesis Is the Lens
Every command should be aware of the current hypothesis. `/explore` references it. `/spec` uses it for scope decisions. `/gaps` measures against it.

### Reverse Prompting for Discovery
Seeding commands (explore, process) are predominantly reverse prompting — Claude asks, founder answers. The PM extracts and structures what the founder knows but hasn't articulated.

### Direct Prompting for Generation
Shaping commands (spec, plan) are predominantly direct prompting — the PM generates artifacts from accumulated context. The founder reviews and refines.

### "Only Write What We Know"
Don't generate from thin air. If context is insufficient, say so and recommend more seeding. A bad spec is worse than no spec.

### Testability
Everything should be testable. Hypotheses need test plans. Features need success metrics. User segments need validation methods.

### One Question at a Time
Commands that use reverse prompting ask one question, wait for the answer, then follow up. Don't overwhelm.

### Living Documents
Tracking files (hypothesis, insights, session-log) should reflect current state. Update to stay true, not just append.

---

## Command Dependencies

```
                    ┌──────────────────────────────────────────┐
                    │           Discovery Flow                  │
                    │                                           │
                    │  /explore ──► /process ──► /research      │
                    │     │            │             │          │
                    │     ▼            ▼             ▼          │
                    │  product/    product/     competitive-    │
                    │  files       files        landscape.md    │
                    └──────────────────────────────────────────┘
                                      │
                                      ▼
                    ┌──────────────────────────────────────────┐
                    │          Strategy Flow                     │
                    │                                           │
                    │  /synthesize ──► /hypothesis               │
                    │     │               │                     │
                    │     ▼               ▼                     │
                    │  insights-       hypothesis.md            │
                    │  log.md          (the anchor)             │
                    └──────────────────────────────────────────┘
                                      │
                                      ▼
                    ┌──────────────────────────────────────────┐
                    │           Shaping Flow                     │
                    │                                           │
                    │  /spec ──► /plan ──► Linear tickets       │
                    │     │         │                           │
                    │     ▼         ▼                           │
                    │  docs/     tickets.yaml                   │
                    │  specs/    → dev project                  │
                    └──────────────────────────────────────────┘

Cross-cutting: /status (session start), /gaps (assessment), /checkpoint (session end)
```
