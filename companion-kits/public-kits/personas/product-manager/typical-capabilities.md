# Product Manager: Typical Capabilities

Which capabilities from `companion-kits/public-kits/capabilities/` this persona typically uses, and how.

---

## Core Capabilities (Always Include)

### Reverse Prompting
**Role:** The foundational interaction pattern for PM companions.
**How it's used:** Seeding commands (explore, process) are predominantly reverse prompting — Claude asks, founder answers. The PM extracts and structures what the founder knows but hasn't articulated.
**Customization:** PM voice behaviors shape the reverse prompting style (Skeptic, Connector, Narrower, Tester, Shaper).

### Context Ecosystem
**Role:** The standard context capture and persistence layer.
**How it's used:** requirements.md, constraints.md, decisions.md, questions.md — plus PM-specific product context files (vision.md, user-segments.md, competitive-landscape.md, feature-concepts.md).
**Customization:** Product context files extend the base ecosystem with PM-specific artifacts.

### Strategic Planning
**Role:** Hypothesis-driven decision making as the central methodology.
**How it's used:** The product hypothesis serves as the strategy anchor. Every command references it. `/hypothesis` manages it. `/spec` and `/plan` use it as the decision lens for scope and priority.
**Customization:** The hypothesis format, confidence levels, and test plan structure are PM-specific.

---

## Common Capabilities (Include When Relevant)

### Meeting Processing
**When to include:** When the founder has regular meetings, customer conversations, or stakeholder discussions that produce insights.
**How it's used:** `/process transcript` ingests meeting transcripts (Granola, etc.) and extracts product insights, connecting new information to existing product context and hypothesis.

### Insight Feedback Loop
**When to include:** When the PM project runs for more than a few sessions and insights need to compound.
**How it's used:** Observations from each session feed into insights-log.md. `/synthesize` finds patterns across sessions. The PM voice references accumulated insights when challenging new ideas.

### Session Hygiene
**When to include:** When session continuity matters and the working rhythm is established.
**How it's used:** `/status` at session start (orientation), `/checkpoint` at session end (capture). Ensures nothing important stays only in conversation context.

### Knowledge Zones
**When to include:** When the PM project accumulates enough material that navigation becomes important.
**How it's used:** Organized reference (product/), field knowledge (tracking/), insights (tracking/insights-log.md), session history (tracking/session-log.md), decisions (context/decisions.md).

---

## Rarely Used Capabilities

### Mentor Framework
**When to include:** Only if the PM project involves a specific domain where named mentor personas add value (rare for pure PM work).

### Craft Assessment
**When to include:** Not typically used for PM projects.

### Process Evolution
**When to include:** When the PM project has been running long enough that commands need tuning. Uses the `/record` + `/evolve` pattern.
