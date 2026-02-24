# Capability: Knowledge Zones

Organizing project knowledge into named zones with distinct purposes, lifecycles, and access patterns.

---

## What It Is

As a companion project accumulates material — context files, insights, session logs, design documents, decisions, reference material — navigation becomes a problem. Without organization, commands read everything or guess which files matter. Both waste tokens and produce inconsistent results.

Knowledge zones solve this by dividing the project's accumulated knowledge into named zones, each with a distinct purpose, update cadence, and access pattern. Commands target the right zone for their needs instead of reading everything.

---

## The Five Zones

### 1. Reference Zone

Static knowledge that provides background and grounding. This zone is written once (or updated rarely) and read often.

**Contents:**
- Domain reference material (framework summaries, methodology notes)
- Library entries (contextualized book notes)
- Competitive analysis
- Style guides, standards, conventions
- Persona and identity definitions

**Update cadence:** Rarely. When new reference material is added (a new book is read, a new framework is adopted).

**Access pattern:** Read at project start, read when a command needs background knowledge, rarely written during regular sessions.

### 2. Field Zone

Active work in progress. This zone contains the current focus — drafts, designs, active documents, work products.

**Contents:**
- Current drafts (chapters, scenes, design documents)
- Active design iterations
- Work in progress that will eventually become finished artifacts
- Scratch files and exploratory work

**Update cadence:** Every session. This is where the work happens.

**Access pattern:** Read and written during every working session. The primary zone for production commands.

### 3. Insights Zone

Accumulated observations that compound over time. This zone grows through the insight feedback loop and periodic synthesis.

**Contents:**
- Insights log (dated, categorized, connected observations)
- Synthesized patterns (higher-level patterns from insight clusters)
- Craft assessment (evidence-based skill tracking)
- Process observations (for process evolution)

**Update cadence:** Every session (new insights), periodically (synthesis), occasionally (craft recalibration).

**Access pattern:** Read at session start (orientation), written at session end (capture), read during analysis commands (context for feedback).

### 4. Sessions Zone

History of what happened across sessions. This zone provides continuity — what was done, what was decided, what comes next.

**Contents:**
- Session log (per-session summaries)
- Next-actions (what to do in the next session)
- Progress tracking (build progress, milestone tracking)
- Session records (process evolution observations)

**Update cadence:** Every session end (session log, next-actions). Session records as needed.

**Access pattern:** Read at session start (what happened last time, what to do now), written at session end (capture what happened).

### 5. Decisions Zone

Choices that have been made, with rationale. This zone is the authority on "what was decided and why."

**Contents:**
- decisions.md (the core decisions log)
- Hypothesis or design pillars (the strategic anchor)
- Constraints (hard boundaries)
- Architecture decision records (for software projects)

**Update cadence:** When decisions are made. Not every session, but whenever a meaningful choice is committed to.

**Access pattern:** Read by every command that needs to respect past decisions. Written when new decisions are made. The highest-authority zone — decisions override other zones when there is a conflict.

---

## When to Use

| Companion Type | Knowledge Zones | Weight |
|----------------|----------------|--------|
| Game Designer | Core — the volume and variety of design knowledge demands organized zones | Required |
| Writing Mentor | Core — craft insights, author profile, session history, and writing output need distinct zones | Required |
| Product Manager | Recommended — strategy, evidence, and operational content benefit from zoning | Strong |
| Strategic Companion | Recommended — client context, themes, and operational history benefit from zoning | Strong |
| Software Developer | Moderate — architecture docs, ADRs, and code context have natural zones | Moderate |

---

## Key Principle: Each Zone Has Its Own Cadence

The five zones are not interchangeable folders — they have fundamentally different lifecycles.

| Zone | Write Frequency | Read Frequency | Staleness Risk |
|------|----------------|----------------|----------------|
| Reference | Rarely | Often | Low (static by nature) |
| Field | Every session | Every session | Low (actively maintained) |
| Insights | Most sessions | Most sessions | Medium (needs synthesis) |
| Sessions | Every session | Session start | Low (automatically maintained) |
| Decisions | Occasionally | Every command | Medium (decisions can be superseded) |

Understanding these cadences prevents two common failures:
1. **Reading stale content as if it were current** — Reference zone content from 3 months ago is fine. Decisions zone content from 3 months ago may be superseded.
2. **Writing to the wrong zone** — A craft observation belongs in Insights, not Sessions. A decision belongs in Decisions, not Insights.

---

## Why Zones Matter for Commands

Commands that target the right zone are faster, cheaper, and more accurate.

### Without zones:
```
/seed command reads:
- Every file in context/ (40+ files)
- Every file in tracking/ (10+ files)
- Recent session history
Total: 50+ file reads, many irrelevant
```

### With zones:
```
/seed command reads:
- Field zone: Current writing project, active chapter
- Insights zone: Craft assessment, relevant craft insights
- Decisions zone: Curriculum decisions
Total: 5-8 targeted file reads
```

The zone structure tells each command exactly where to look. This is especially important as projects mature and accumulate hundreds of files.

---

## Zone Boundaries

Zones are not rigid containers — some information naturally touches multiple zones. The principle is: **each piece of information has a primary zone where it lives, and other zones reference it.**

**Example:** A design decision (Decisions zone) that emerged from a playtest insight (Insights zone) during a specific session (Sessions zone):
- The decision lives in Decisions with full rationale
- The insight lives in Insights with a reference to the decision it informed
- The session log in Sessions notes the decision was made, with a pointer

Cross-references prevent duplication while maintaining zone integrity.

---

## Relationship to Other Capabilities

### Context Ecosystem
Knowledge zones are an evolution of the context ecosystem. The four core files (requirements, constraints, decisions, questions) map to the Decisions zone. Persona-specific extensions map to Reference and Insights zones. Zones add the Field and Sessions layers that the basic context ecosystem does not address.

### Session Hygiene
Session hygiene reads from the Sessions zone (session log, next-actions) and writes to it at session end. It reads from the Insights zone (for insight capture) and the Decisions zone (for orientation). Zone awareness makes session hygiene more efficient.

### Insight Feedback Loop
The Insights zone is where the feedback loop lives. Insights are captured, connected, and synthesized within this zone.

### Process Evolution
Session records (the input for /record and /evolve) live in the Sessions zone. Evolved commands change how other zones are read and written.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Flat file dump | All files in one directory with no organization | Organize by zone from the start (or when material accumulates) |
| Too many zones | Seven or eight zones dilute the organizational value | Five zones. If a sixth is needed, consider whether it is really a sub-zone. |
| Zone as filing cabinet | Putting files in zones and never reading them | Commands must target zones; zones without readers are dead weight |
| Cross-zone duplication | Same content in multiple zones | One primary zone, cross-references from others |
| Premature zoning | Elaborate zone structure on day 1 with nothing in it | Introduce zones when material accumulates enough that navigation matters |
| Rigid zone assignment | Agonizing over which zone a file belongs to | Use the primary purpose test: what is this file's main job? That determines its zone. |
