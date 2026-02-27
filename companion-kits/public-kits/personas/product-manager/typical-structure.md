# Product Manager: Typical Structure

The directory layout that works for product manager projects.

---

## Core Structure

```
[project-name]/
├── CLAUDE.md                    # PM personality, methodology, context hierarchy
├── README.md                    # Workflow guide for the human
│
├── context/                     # Project context (from intake, living)
│   ├── requirements.md          # Purpose, users, success criteria, PM voice
│   ├── decisions.md             # Strategic decisions with rationale
│   ├── constraints.md           # Technical, timeline, organizational limits
│   ├── questions.md             # Open questions backlog (formalized)
│   └── domain.md                # Deep product domain context (optional)
│
├── product/                     # Product knowledge (built over time)
│   ├── vision.md                # Product vision and strategy
│   ├── user-segments.md         # User segments with validation state
│   ├── feature-concepts.md      # Feature ideas (explored vs. raw)
│   └── competitive-landscape.md # Competitive analysis
│
├── tracking/                    # Session continuity (living documents)
│   ├── hypothesis.md            # The strategy anchor (central artifact)
│   ├── insights-log.md          # Accumulated product insights
│   ├── session-log.md           # What happened each session
│   ├── next-actions.md          # Prioritized queue for next session
│   └── patterns-discovered.md   # Command evolution learnings
│
├── docs/
│   ├── specs/                   # PRDs and feature specs (shaped artifacts)
│   ├── mockups/                 # UI mockups when ready
│   ├── research/                # Competitive analysis, user research
│   └── plans/                   # Implementation specs, tickets.yaml, build-progress.md
│
└── .claude/
    └── commands/
        ├── explore.md           # Open-ended PM ideation (reverse prompting)
        ├── process.md           # Ingest transcripts/documents
        ├── research.md          # Analyze comparable products
        ├── synthesize.md        # Find patterns across context
        ├── hypothesis.md        # Manage the strategy anchor
        ├── spec.md              # Write feature specs/PRDs
        ├── plan.md              # Break specs into tickets
        ├── status.md            # Quick session-start orientation
        ├── gaps.md              # Assess what's captured vs. needed
        └── checkpoint.md        # End-of-session capture
```

---

## Required Files

These files must exist for the core commands to work:

| File | Purpose | Created By |
|------|---------|------------|
| `CLAUDE.md` | PM personality, methodology, context hierarchy | Foundation ticket |
| `README.md` | Human-facing project guide | Foundation ticket |
| `tracking/hypothesis.md` | Strategy anchor (may start empty) | Foundation ticket, populated via `/hypothesis` |
| `tracking/insights-log.md` | Accumulated insights | Foundation ticket, updated by commands |
| `tracking/session-log.md` | Session history | Foundation ticket, updated by `/checkpoint` |
| `tracking/next-actions.md` | What to do next | Foundation ticket, updated by `/checkpoint` |
| `product/vision.md` | Product vision | Foundation ticket, populated via `/explore` |
| `product/user-segments.md` | User segments | Foundation ticket, populated via `/explore` |
| `product/feature-concepts.md` | Feature ideas | Foundation ticket, populated via `/explore` |
| `product/competitive-landscape.md` | Competition | Foundation ticket, populated via `/research` |
| `.claude/skills/*/SKILL.md` | All skills | Skill tickets |

---

## Context Files (From Intake)

Context files are created during intake and serve as the project's foundation. They should be treated as living documents that get updated as understanding deepens.

| File | What It Captures |
|------|------------------|
| `context/requirements.md` | Purpose, users, success criteria, PM voice definition, core functionality |
| `context/decisions.md` | Strategic decisions with rationale (numbered, with status) |
| `context/constraints.md` | Technical constraints, SDLC model, team limits, cross-project architecture |
| `context/questions.md` | Formalized open questions with "what we know / don't know / how to explore" |
| `context/domain.md` | Deep domain context — reference implementations, prior art, conversation insights (optional) |

---

## Product Files (Built Over Time)

Product files accumulate product thinking across sessions. They start as templates and fill in through `/explore`, `/process`, and `/research`.

**vision.md** — Product vision and strategy
- What the product is and why it exists
- The hypothesis (references tracking/hypothesis.md)
- Go-to-market phases
- What's in scope, what's explicitly not

**user-segments.md** — User segment definitions
- Each segment with description, key pain, and Phase 1 fit assessment
- Validation state (assumed → talked to → validated)
- Prioritization rationale

**feature-concepts.md** — Feature ideas at various stages
- Raw ideas (brainstormed, not yet explored)
- Explored ideas (discussed in sessions, with insights)
- Spec-ready ideas (ready for `/spec`)

**competitive-landscape.md** — Competitive understanding
- Direct competitors with positioning
- Adjacent products
- What to borrow, what to avoid
- Where our hypothesis creates differentiation

---

## Tracking Files (Living Documents)

Tracking files maintain continuity across sessions. They should always reflect current state.

**hypothesis.md** — The strategy anchor
- Current hypothesis statement
- Confidence level (speculative → proposed → tested → validated)
- Test plan with stacked metrics
- Evidence for/against
- History of revisions

**insights-log.md** — Accumulated product insights
- Dated entries from `/process`, `/synthesize`, `/explore`
- Tagged by source (conversation, research, exploration)
- Connected to hypothesis and feature concepts

**session-log.md** — Session history
- Dated entries from `/checkpoint`
- What was discussed, decided, and what's next
- Which commands were used

**next-actions.md** — Prioritized queue
- What to do in the next session
- Ranked by impact on hypothesis validation
- Updated by `/checkpoint`

**patterns-discovered.md** — Command evolution
- What's working and what's not
- Ideas for new commands or command modifications
- "Start wrong, iterate to right" learnings

---

## Cross-Project References (If Applicable)

When a sibling dev project exists:

```
companions/[client]/
├── [product]-pm/           # This PM companion
│   └── docs/specs/         # PM writes specs here
│       └── feature-a.md    # Dev companion reads these
│
└── [product]-dev/           # Sibling dev companion
    └── docs/specs/          # May reference PM specs
```

**CLAUDE.md should document:**
- Path to sibling project: `../[product]-dev/`
- What the PM project produces that the dev project consumes
- Linear as the bridge for tickets and status
- Document ownership: each project owns its files, references the other's

---

## Git Configuration

The project should have its own git repository. Suggested `.gitignore`:

```
.DS_Store
*.swp
*.swo
.claude/settings.local.json
```

---

## CLAUDE.md Sections

The CLAUDE.md for a product manager project typically includes:

1. **Project identity** — What this is, what product it manages
2. **PM personality** — Named behaviors (Skeptic, Connector, Narrower, Tester, Shaper)
3. **Methodology** — Three-phase approach (Seeding, Cultivation, Shaping) applied to PM
4. **Strategy anchor** — How the hypothesis works as the decision lens
5. **Commands** — Overview of all commands and when to use each
6. **Context hierarchy** — Which files to read first and in what order
7. **Cross-project references** — Sibling dev project paths and handoff model
8. **Key principles** — "Only write what we know", testability, focus
9. **Session checklist** — What to do at start/end of session
