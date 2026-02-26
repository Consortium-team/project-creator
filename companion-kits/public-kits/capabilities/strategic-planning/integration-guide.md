# Strategic Planning: Integration Guide

How to wire hypothesis-driven strategic thinking into a companion project.

---

## Setting Up hypothesis.md

The strategy anchor lives in a hypothesis file within the context ecosystem. The exact location depends on the persona.

### Product Manager

```
context/product/hypothesis.md
```

### Game Designer

```
context/design/pillars.md
```

### Strategic Companion

```
context/strategic/hypothesis.md
```

### Initial Structure

```markdown
# Product Hypothesis

## Current Version

**Version:** 1
**Status:** Speculative
**Last updated:** [date]

**We believe:** [specific user segment]
**Will:** [specific behavior]
**Because:** [specific reason]
**We can test this by:** [specific, cheap test]
**We would abandon this if:** [falsification criteria]

## Evidence

### Supporting
<!-- Evidence that supports the hypothesis -->

### Contradicting
<!-- Evidence that challenges the hypothesis -->

### Absent
<!-- Expected evidence that hasn't appeared -->

## History

### Version 1 — [date]
[The original hypothesis and why it was proposed]
```

For game design pillars, adapt the structure:

```markdown
# Design Pillars

## Current Pillars

**Version:** 1
**Last updated:** [date]

### Pillar 1: [Name]
**Statement:** [What this pillar means]
**Test:** Every mechanic must demonstrably serve this pillar.
**Examples of serving:** [Specific mechanics that serve it]
**Examples of violating:** [What would NOT serve this pillar]

### Pillar 2: [Name]
...

## Evidence

### Supporting
### Contradicting

## History
```

---

## Wiring Hypothesis Awareness into Commands

Every command should read the hypothesis file and use it as a lens. Here is how to add hypothesis awareness to existing command patterns.

### Pattern: Hypothesis Check at Command Start

Add this to any command that produces output or makes decisions:

```markdown
## Step 1: Read Strategy Anchor

Read `context/product/hypothesis.md` (or equivalent).
Note:
- Current hypothesis version and status
- Key supporting and contradicting evidence
- Any recent changes

Use this as the decision lens for all subsequent steps.
```

### Pattern: Hypothesis Filter on Output

Add this before any command writes output:

```markdown
## Step N: Hypothesis Filter

Before finalizing output, check:
- Does this output serve the current hypothesis? If yes, proceed.
- Does this output contradict the hypothesis? If yes, flag it explicitly.
- Is this output orthogonal to the hypothesis? If yes, note that it's a nice-to-have
  but not strategically aligned.
```

### Pattern: Evidence Capture from Any Command

Add this to any command that processes new information:

```markdown
## Step N: Evidence Check

Does this session's information affect the hypothesis?
- New supporting evidence? Append to hypothesis.md under "Supporting."
- New contradicting evidence? Append to hypothesis.md under "Contradicting"
  and FLAG IT prominently to the user.
- Expected evidence absent? Note in hypothesis.md under "Absent."
```

---

## The /hypothesis Command Pattern

A dedicated command for managing the strategy anchor.

### View Mode

```markdown
# /hypothesis

Show the current hypothesis, its status, and evidence summary.

## Steps

1. Read `context/product/hypothesis.md`

2. Display:
   - Current version and status (Speculative / Proposed / Tested / Validated)
   - The hypothesis statement
   - Evidence summary:
     - [N] supporting items
     - [N] contradicting items
     - [N] absent items
   - Last updated date

3. If contradicting evidence exists, surface it prominently:
   "There are [N] pieces of contradicting evidence. Consider running
   /hypothesis refine to address them."
```

### Propose Mode

```markdown
# /hypothesis propose

Draft or replace the hypothesis through reverse prompting.

## Steps

1. Read current context files (requirements, constraints, decisions).

2. If a hypothesis exists:
   - Show it and ask: "What about this feels wrong or incomplete?"
   - Use the answer to guide refinement questions.

3. If no hypothesis exists:
   - Ask: "What is the central bet this [product/game/business] is making?"
   - Push for specificity through reverse prompting:
     - "Who exactly is the user?"
     - "What specific behavior will they exhibit?"
     - "Why will they choose this over their current alternative?"
     - "How would we test this cheaply?"
     - "What would prove this wrong?"

4. Draft the hypothesis and show it to the user.

5. On confirmation, write to hypothesis.md with:
   - New version number
   - Status: Speculative (always starts here)
   - Date
   - Append previous version to History section
```

### Refine Mode

```markdown
# /hypothesis refine

Refine the hypothesis based on accumulated evidence.

## Steps

1. Read `context/product/hypothesis.md`
2. Read all evidence (supporting, contradicting, absent).

3. Present the evidence summary and ask:
   "Given this evidence, what aspects of the hypothesis hold up and which
   need adjustment?"

4. Guide refinement through targeted questions:
   - If contradicting evidence is strong: "This evidence suggests [X].
     Should we narrow the user segment, change the behavior prediction,
     or rethink the reason?"
   - If supporting evidence is strong: "This evidence validates [part].
     Should we move this aspect from Speculative to Proposed?"
   - If absent evidence is notable: "We expected [X] but haven't seen it.
     What does that tell us?"

5. Draft refined hypothesis and show to user.

6. On confirmation, write new version to hypothesis.md.
   Move previous version to History.
   Update status if appropriate.
```

---

## Adapting for Non-PM Contexts

### Game Design: Pillars as Strategy Anchor

Game designers do not typically work with product hypotheses. Instead, they use **design pillars** — a small set of principles that filter every mechanic, system, and feature decision.

**Differences from PM hypothesis:**
- Pillars are a set (usually 2-4), not a single statement
- Pillars are less about user behavior prediction and more about experience goals
- Testing is through playtesting, not market validation
- Falsification means a pillar doesn't actually contribute to the intended experience

**Adaptation:**
```markdown
# /pillars

View, propose, or refine design pillars.

## Propose Mode

1. Ask: "Describe the core experience you want the player to have."
2. Push for specificity: "When the player puts down the controller and tells
   a friend about the game, what do they say?"
3. From the core experience, extract candidate pillars:
   - Each pillar must be specific enough to filter mechanics
   - Each pillar must be distinguishable from the others
   - 2-4 pillars total (more than 4 means nothing is prioritized)
4. For each pillar, define:
   - What it means (in one sentence)
   - Example mechanics that serve it
   - Example mechanics that would violate it
```

### Business Strategy: Strategic Hypothesis

Strategic companions use business-level hypotheses that are broader than product hypotheses but follow the same discipline.

**Differences from PM hypothesis:**
- Scope is business-level (market positioning, competitive advantage) not product-level
- Evidence comes from financial data, market signals, client conversations
- Tests are more expensive and longer-running
- The hypothesis may have sub-hypotheses for different business areas

**Adaptation:**
```markdown
# context/strategic/hypothesis.md

## Current Version

**We believe:** [market positioning]
**Will create:** [competitive advantage]
**Because:** [differentiated insight]
**Measured by:** [specific metrics]

## Sub-Hypotheses
### [Business Area 1]
**We believe:** [specific sub-hypothesis]
...

### [Business Area 2]
...
```

### Software Development: ADRs as Lightweight Strategy

Software projects rarely need full hypothesis-driven strategy. Instead, Architecture Decision Records (ADRs) serve a similar function: they document what was decided, why, and what alternatives were considered.

**When to use strategic planning in software projects:**
- Choosing between fundamentally different architectures
- Deciding build-vs-buy
- Selecting technology stacks with long-term commitment
- Making decisions that are expensive to reverse

**Adaptation:**
Use the ADR pattern instead of hypothesis.md. The strategic planning capability provides the discipline of tracking evidence and challenging assumptions, applied to architectural decisions.

---

## Evidence Tracking in Practice

### Where Evidence Lives

Evidence is tracked directly in the hypothesis file, not in a separate file. This ensures that anyone reading the hypothesis immediately sees the evidence landscape.

### Capturing Evidence

Every command that processes external information (meetings, research, user conversations) should include an evidence check step:

```markdown
## Evidence Check

Does any information from this [meeting/transcript/conversation]
affect the current hypothesis?

If yes:
- Classify as Supporting, Contradicting, or Absent
- Add to hypothesis.md with:
  - Date
  - Source (which meeting, conversation, or document)
  - Specific observation
  - How it relates to the hypothesis
```

### Evidence Review Cadence

Evidence should be reviewed periodically, not just when it is captured.

**Per session:** The `/status` or session-start command should note any recent evidence additions and flag accumulating contradictions.

**Periodic:** Every 3-5 sessions (or when contradicting evidence reaches 3+ items), the companion should proactively suggest `/hypothesis refine`.

---

## Common Pitfalls

### Hypothesis as Decoration
Writing a hypothesis and then never referencing it. If commands do not read and filter against the hypothesis, it is decoration. Wire it into every relevant command.

### Premature Validation
Moving to "Validated" status because the user likes the hypothesis, not because evidence supports it. Validation requires external evidence, not internal conviction.

### Pillar Inflation
Game designers adding pillars until every mechanic is justified. Four pillars is the maximum. If a fifth is needed, one of the existing four must be removed or merged.

### Evidence Hoarding Without Action
Accumulating evidence without periodically reviewing and acting on it. Evidence that sits unreviewed is not evidence — it is data. Schedule regular review through session protocols.

### Strategy Paralysis
Spending too long refining the hypothesis before doing anything. The hypothesis is a living document. Version 1 is allowed to be speculative. Ship it, test it, refine it.
