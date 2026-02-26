# Capability: Insight Feedback Loop

A pattern where observations from each session compound across sessions, building a growing body of knowledge that informs future interactions.

---

## What It Is

Most AI interactions are stateless — each session starts with the same context and produces isolated outputs. The insight feedback loop breaks this pattern by creating a compounding knowledge layer. Every session reads accumulated insights, generates new observations, and writes them back so the next session starts smarter.

The loop has four steps:

1. **Observe** — During a session, notice something worth capturing: a pattern, a connection, a surprise, a recurring theme, a design principle that emerges from the work.
2. **Capture** — Write the observation to a persistent insights log with enough context that a future session can understand and use it.
3. **Connect** — Link the new insight to existing insights, context files, or project themes. Isolated observations are less valuable than connected ones.
4. **Reference** — In future sessions, read accumulated insights and use them to inform questions, proposals, and analysis.

The result is a companion that gets better over time — not because the model improves, but because the context it reads is richer with each session.

---

## When to Use

Any companion that runs for multiple sessions and benefits from compounding observations.

| Companion Type | Insight Feedback Loop Role | Weight |
|----------------|---------------------------|--------|
| Game Designer | Non-optional — design insights are too valuable to lose | Mandatory |
| Writing Mentor | Non-optional — craft observations compound into curriculum | Mandatory |
| Product Manager | Recommended — strategic observations compound into pattern recognition | Strong |
| Strategic Companion | Recommended — business observations reveal themes over time | Strong |
| Software Developer | Optional — useful for architecture patterns, less critical for implementation | Light |

---

## Non-Optional vs. Optional

Some personas make insight capture mandatory. Others make it recommended.

### Mandatory Insight Capture

When insight capture is mandatory, every session must produce at least one insight entry. The session-end protocol should refuse to close without it. This is appropriate when:

- The domain produces observations that compound (design, craft, strategy)
- Context compaction would destroy knowledge that took effort to produce
- The companion's value proposition depends on getting smarter over time
- The user invests significant creative or analytical effort per session

Personas with mandatory capture: game designer, writing mentor.

### Recommended Insight Capture

When insight capture is recommended, the companion should prompt for insights at session end but not block on it. This is appropriate when:

- Most sessions produce useful observations, but some are purely operational
- The value of compounding is significant but not the primary value proposition
- Forcing capture on every session would feel like busywork

Personas with recommended capture: product manager, strategic companion.

---

## What Makes a Good Insight

Not every observation is an insight. Good insights are:

### Portable

They apply beyond the specific session that produced them. "The dialogue in chapter 4 felt stilted" is a session note. "This writer defaults to telling emotions through internal monologue instead of showing them through action" is a portable insight.

### Connected

They link to something already known. "The player economy breaks at 100 gold" is isolated. "The player economy breaks at 100 gold, which confirms the insight from session 3 that exponential reward curves outpace the sink mechanisms" is connected.

### Actionable

They suggest something concrete for future sessions. "The founder is unclear about their user segment" is vague. "The founder consistently describes two different user segments (solo founders and small teams) as if they were one. The next session should force a choice between them." is actionable.

### Dated and Sourced

Every insight should record when it was captured and what triggered it. This makes insights traceable and helps with periodic synthesis.

---

## Key Principle: Living Insights

Insights should be living — updated when understanding deepens, not just appended. An insight log that only grows becomes a graveyard of observations. A living insight log evolves.

When a new observation deepens an existing insight, the existing insight should be updated with:
- The new evidence or observation
- The date of the update
- How the understanding changed

When an insight is superseded (understanding changed completely), the old insight should be marked superseded with a pointer to the new one. Do not delete — the history of understanding has value.

When insights cluster around a theme, they should be periodically synthesized into a higher-level pattern. Three related insights about dialogue might synthesize into a single insight about the writer's relationship to spoken language in fiction.

---

## The Compounding Effect

The real power of the insight feedback loop is not any individual insight — it is the compounding. A companion with 50 connected, living insights behaves fundamentally differently from one with zero:

- Its questions are more targeted (it knows what to push on)
- Its framings are more relevant (it has seen what resonates with this user)
- Its proposals are more grounded (it can reference specific patterns from past sessions)
- Its contradictions are more valuable (it can spot when the user contradicts their own established patterns)

This is what makes a companion feel like it "knows" the user. It does not know them — it reads a well-maintained insight log that encodes what previous sessions learned.

---

## Relationship to Other Capabilities

### Context Ecosystem
The insights log is a context file — part of the broader ecosystem. It follows the same lifecycle patterns (living document, date-stamped entries, read at session start). But insights are distinct from requirements, decisions, and constraints. They are observations about patterns, not statements about what must be done.

### Session Hygiene
Session hygiene (the start/finish protocol) is the mechanism that ensures insights are captured and read. Without session hygiene, the feedback loop is aspirational. With it, the loop is enforced.

### Knowledge Zones
Insights are one of the five knowledge zones. The insights zone has its own access pattern — read at session start, written at session end, synthesized periodically.

### Reverse Prompting
Insights inform reverse prompting. A companion that has accumulated insights about a writer's tendency to avoid conflict in fiction will ask different questions than one starting from scratch. The insight loop makes reverse prompting progressively more precise.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Append-only log | Grows without synthesis; old insights get buried | Periodically synthesize clusters into higher-level patterns |
| Session notes masquerading as insights | "We talked about dialogue today" is not an insight | Push for portable, connected, actionable observations |
| Insight capture as afterthought | Rushed entries at session end with no depth | Capture insights as they emerge during the session |
| Never referencing accumulated insights | Writing insights but not reading them | Session start must read and surface relevant insights |
| Insights without connections | Isolated observations that do not link to anything | Every insight should reference what it connects to |
| Over-capturing | Every minor observation becomes an insight entry | Quality over quantity — one good insight per session beats five shallow ones |
