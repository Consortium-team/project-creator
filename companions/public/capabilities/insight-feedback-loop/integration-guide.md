# Insight Feedback Loop: Integration Guide

How to wire compounding insight capture into a companion project.

---

## Setting Up the Insights Log

The insights log is a living document that accumulates observations across sessions. It lives in the context ecosystem, typically at a persona-specific location.

### File Location by Persona

| Persona | Location |
|---------|----------|
| Game Designer | `context/design/insights-log.md` |
| Writing Mentor | `context/author/craft-insights.md` |
| Product Manager | `context/product/insights-log.md` |
| Strategic Companion | `context/strategic/insights-log.md` |

### Initial Structure

```markdown
# Insights Log

<!-- Living document. Observations compound across sessions.
     Each insight is dated, sourced, categorized, and connected. -->

## Active Insights

<!-- Current observations organized by category.
     Update existing insights when understanding deepens.
     Mark superseded insights instead of deleting them. -->

## Synthesized Patterns

<!-- Higher-level patterns discovered by reviewing clusters of insights.
     Each pattern references the individual insights that compose it. -->

## Superseded

<!-- Insights that were replaced by deeper understanding.
     Kept for history. Each entry links to its replacement. -->
```

---

## Structuring Insight Entries

Every insight entry follows a consistent structure that makes it readable by future sessions.

### Entry Format

```markdown
### [Short descriptive title]
**Date:** YYYY-MM-DD
**Source:** [What triggered this observation — session topic, specific exercise, conversation moment]
**Category:** [Domain-specific category — see below]

[The insight itself — 2-4 sentences. Portable, connected, actionable.]

**Connects to:** [References to other insights, context files, or project themes]

**Updated YYYY-MM-DD:** [If the insight has been deepened or refined, note what changed]
```

### Example: Writing Mentor

```markdown
### Defaults to internal monologue for emotional beats
**Date:** 2026-02-15
**Source:** Review of Chapter 3 draft — every emotional moment was narrated internally
**Category:** Craft / Voice

Gabriel consistently reaches for internal monologue when a character feels something
strongly. The narration tells the reader the emotion rather than showing it through
action, dialogue, or physical sensation. This is not a weakness in every case — internal
monologue is a valid tool — but the default to it suggests the writer has not yet
developed confidence in indirect emotional conveyance.

**Connects to:** Author profile (voice analysis section), Craft assessment (showing vs telling dimension)

**Updated 2026-02-20:** Chapter 5 showed improvement — two scenes used physical action
for emotion. The pattern is weakening but still present in high-stakes moments.
```

### Example: Game Designer

```markdown
### Exponential reward curves outpace sink mechanisms
**Date:** 2026-03-01
**Source:** Balance review session — player economy simulation at 100-turn mark
**Category:** Systems / Economy

The current reward curve (1.05x per level) compounds faster than the gold sinks can
absorb. By turn 100, players accumulate 3x the gold the economy is designed to handle.
This is a systemic issue, not a tuning issue — adding more sinks does not fix the
exponential/linear mismatch. The curve itself needs to flatten or the sinks need to
scale with accumulation.

**Connects to:** Design pillar 2 (meaningful progression), Balance parameters doc (economy section)
```

### Example: Product Manager

```markdown
### Founders describe two user segments as one
**Date:** 2026-01-28
**Source:** Intake session — founder used "small teams" to mean both solo founders and 5-person teams
**Category:** Strategy / User Segments

The founder consistently conflates solo founders (who need a thinking partner) with
small teams (who need coordination tools). These have fundamentally different needs,
willingness to pay, and activation patterns. The hypothesis cannot target both without
becoming vague. Next session should force a choice or articulate how the product serves
each segment differently.

**Connects to:** Hypothesis v2 (user segment definition), Requirements (conflicting feature requests)
```

---

## Categories

Categories are domain-specific. Define them at project setup and extend as needed.

### Writing Mentor Categories

- **Craft / Voice** — Observations about the writer's voice and style
- **Craft / Structure** — Observations about narrative structure and pacing
- **Craft / Character** — Observations about character development
- **Craft / Theme** — Observations about thematic handling
- **Process** — Observations about the writer's working process
- **Growth** — Evidence of skill development over time

### Game Designer Categories

- **Systems / Economy** — Economy, resource, and progression observations
- **Systems / Balance** — Balance and tuning observations
- **Player Experience** — Observations about what players feel and do
- **Design Patterns** — Reusable design patterns noticed
- **Framework Applications** — Insights from applying specific frameworks

### Product Manager Categories

- **Strategy / User Segments** — User segment observations
- **Strategy / Positioning** — Market positioning observations
- **Strategy / Evidence** — Hypothesis evidence patterns
- **Process / Decision-Making** — How the founder makes decisions
- **Product / Patterns** — Recurring product patterns

---

## How Commands Should Reference Accumulated Insights

Every command that benefits from historical context should read the insights log as part of its orientation step.

### Pattern: Insight-Aware Command Start

Add this to any command that produces analysis, proposals, or questions:

```markdown
## Step 1: Read Accumulated Insights

Read `context/[persona]/insights-log.md`.
Note:
- Insights relevant to the current topic
- Patterns that have been synthesized
- Recent updates to existing insights

Use relevant insights to inform your questions, analysis, and proposals.
Reference specific insights when they apply: "Based on the pattern we identified
on [date] about [topic]..."
```

### Pattern: Insight-Informed Questioning

When reverse prompting, reference accumulated insights to sharpen questions:

```markdown
Instead of: "Tell me about your character's emotional journey."

With insights: "In previous sessions we noticed you default to internal monologue
for emotional beats [insight from 2026-02-15]. In this chapter, how do you want
to handle the climactic moment — through the character's thoughts, or through
what they do?"
```

### Pattern: Insight Capture During Session

Do not wait until session end to capture insights. When an observation surfaces mid-session, capture it immediately:

```markdown
## During Session: Capture Insights as They Emerge

When you notice a pattern, connection, or observation worth capturing:
1. Name it to the user: "I'm noticing something — [observation]. Does that resonate?"
2. If confirmed, draft the insight entry.
3. Write it to the insights log immediately (do not defer to session end).
4. Continue the session with the insight now captured.
```

---

## The Synthesis Step

Periodically (every 5-10 sessions, or when the insights log grows past 15-20 entries), review accumulated insights and find patterns.

### Triggering Synthesis

Synthesis can be triggered:
- **By count:** When active insights exceed a threshold (15-20 entries)
- **By time:** Every N sessions (varies by persona)
- **By the user:** When they request a review of accumulated insights
- **By a command:** Integrated into `/harvest`, `/checkpoint`, or a dedicated `/synthesize` command

### The Synthesis Process

```markdown
# /synthesize-insights (or integrated into /harvest)

## Step 1: Read All Active Insights

Read the full insights log. Group insights by category.

## Step 2: Identify Clusters

Look for insights that:
- Address the same theme from different angles
- Form a progression (early observation → deeper understanding → pattern)
- Contradict each other (understanding changed over time)
- Suggest a higher-level principle

## Step 3: Propose Synthesized Patterns

For each cluster, propose a synthesized pattern:
- Name the pattern
- Reference the individual insights that compose it
- State the higher-level principle
- Note implications for future sessions

## Step 4: Confirm and Update

Show the user the proposed patterns.
On confirmation:
- Add synthesized patterns to the "Synthesized Patterns" section
- Keep individual insights in "Active" (they still have value for specifics)
- Update individual insights with a reference to the pattern they belong to
```

### Example Synthesis

```markdown
## Synthesized Patterns

### Emotional conveyance defaults to telling
**Synthesized:** 2026-03-15
**Composed from:** "Defaults to internal monologue" (2/15), "Adverb-heavy dialogue
tags" (2/22), "Narrator explains character motivations" (3/08)

Three separate observations across four weeks point to the same pattern: the writer
trusts explicit statement over implicit demonstration for emotional content. This
spans internal monologue, dialogue attribution, and narrative commentary. The
underlying skill to develop is confidence in the reader's ability to infer emotion
from action, dialogue, and detail without being told.

**Implications:** Craft exercises should focus on "delete the explanation" — write
the scene, then remove every sentence that tells the reader what to feel. See if
the emotion survives.
```

---

## Integration with /harvest and /checkpoint

The insight feedback loop plugs into session-end commands naturally.

### /harvest Integration

If the persona uses `/harvest` as the session-end command:

```markdown
## Step N: Capture Session Insights

Review this session for observations worth capturing:
- Did a pattern emerge from the work done today?
- Did understanding of an existing insight deepen?
- Did something surprise you or the user?

If an insight emerged:
1. Draft the insight entry (title, date, source, category, content, connections).
2. Show the user for confirmation.
3. Write to the insights log.

If understanding of an existing insight deepened:
1. Read the existing insight.
2. Draft an update entry.
3. Show the user for confirmation.
4. Update the insight in place (append the update, do not replace).

If the session was purely operational and no new insights emerged:
- [For mandatory personas]: "Before we close, let me review what we covered.
  Is there any observation from today worth capturing?" (push gently but do not block)
- [For recommended personas]: Note "No new insights this session" and proceed.
```

### /checkpoint Integration

If the persona uses `/checkpoint` as the session-end command:

```markdown
## Step N: Insight Check

Before closing:
1. Review session activity for insight-worthy observations.
2. If insights were captured mid-session, verify they were written to the log.
3. If no insights were captured, prompt: "Anything from today's session worth
   adding to the insights log?"
4. Include insight count in the checkpoint summary:
   "Insights log: [N] active insights, [M] synthesized patterns.
   [Added/Updated] this session: [list]"
```

---

## Common Pitfalls

### Insight Fatigue

If every session forces insight capture, the user may start phoning it in. Prevent this by making the capture feel valuable: reference past insights in the current session so the user sees the compounding effect.

### Stale Insights

Insights captured early may no longer reflect reality. The synthesis step helps — it forces a review of old insights against current understanding. Any insight that has not been referenced or updated in 10+ sessions should be reviewed during synthesis.

### Category Proliferation

Starting with too many categories makes classification feel like overhead. Start with 3-5 broad categories. Let new categories emerge from usage, not from planning.

### Disconnected Insights

Insights without connections to other insights or context files are isolated observations. The "Connects to" field in every entry prevents this. If an insight connects to nothing, it may not be an insight — it may be a session note.
