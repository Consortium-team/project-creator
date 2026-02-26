# Capability: Session Hygiene

Mandatory start and finish protocols that ensure continuity across sessions and prevent context loss.

---

## What It Is

Session hygiene is the discipline of bookending every working session with structured start and finish protocols. The start protocol orients the companion in the current state. The finish protocol captures what happened and prepares for the next session.

Without session hygiene, every session starts from scratch and ends with knowledge trapped in conversation that will be lost to context compaction or session boundaries. With it, sessions form a chain — each one picking up where the last left off, each one leaving the project in a known state.

This is not overhead. This is the mechanism that makes multi-session companions work. A companion that cannot remember what happened last session is not a companion — it is a new conversation every time.

---

## The Two Protocols

### Session Start Protocol

The goal is orientation: where are we, what happened recently, what should we work on.

**Steps:**

1. **Read current state** — Read context files, tracking files, insights log, and any session-specific state (session log, next-actions, progress trackers).
2. **Orient** — Summarize the current state in 3-5 sentences. What phase is the project in? What was accomplished last session? What is pending?
3. **Surface relevant context** — Highlight anything that needs attention: unresolved questions, accumulating contradictions, stale context, upcoming deadlines.
4. **Recommend** — Based on the current state, suggest what to work on this session. The user always has the final say.

**Output:** A brief status report that grounds the session in reality, not assumptions.

### Session Finish Protocol

The goal is capture: what happened, what changed, what comes next.

**Steps:**

1. **Review session activity** — What was discussed, created, modified, decided.
2. **Capture insights** — Any observations worth adding to the insights log (see Insight Feedback Loop capability).
3. **Update tracking** — Session log, next-actions, progress files.
4. **Commit changes** — If the companion project is version-controlled, stage and commit changes made during the session.
5. **Declare next steps** — What should the next session start with? Write this to a file so the next session-start can read it.

**Output:** A clean project state with all changes captured, committed, and documented.

---

## When to Use

Any companion that runs across multiple sessions — which is most of them.

| Companion Type | Session Hygiene | Weight |
|----------------|----------------|--------|
| Game Designer | Mandatory — design insights and decisions are too valuable to lose between sessions | Required |
| Writing Mentor | Mandatory — craft progress, insights, and writing state must persist | Required |
| Product Manager | Strongly recommended — strategy evolves across sessions | Strong |
| Strategic Companion | Strongly recommended — operational continuity depends on session handoff | Strong |
| Software Developer | Recommended — especially during planning phases; lighter during implementation | Moderate |

---

## Mandatory vs. Recommended

### Mandatory Session Hygiene

When session hygiene is mandatory, the companion should:
- Automatically run the start protocol when a session begins (or when a `/status` command is invoked)
- Refuse to end a session without running the finish protocol
- Flag if the user tries to close without capturing changes

This is appropriate when:
- The companion produces insights or knowledge that cannot be reconstructed
- Decisions made during sessions affect future sessions
- The user works on the project sporadically (days or weeks between sessions)

### Recommended Session Hygiene

When session hygiene is recommended, the companion should:
- Offer to run the start protocol but not block if the user wants to jump in
- Remind the user to run the finish protocol at session end
- Not force capture if the session was trivial

This is appropriate when:
- Sessions are frequent (daily) and context loss between them is minimal
- The domain is more operational than creative (less insight-dependent)
- The user has their own habits for tracking state

---

## Key Principle: Context Loss Is the Biggest Risk

Context compaction, session boundaries, and model limitations all conspire to erase knowledge between sessions. Session hygiene is the defense against this.

What gets lost without session hygiene:
- Nuanced decisions made during conversation that never reached a file
- The reasoning behind a choice (the decision is visible in the output, but the "why" lived only in dialogue)
- Insights about the user's patterns, preferences, and working style
- Open threads that were meant to be continued next time
- The emotional or creative state of the work (where the user's energy was, what felt promising)

What survives with session hygiene:
- Every decision captured with rationale
- Insights logged and connected
- Open threads recorded as next-actions
- The state of the work documented clearly enough that a new session (even with a different model or after weeks away) can pick up cleanly

---

## The Minimum Viable Protocol

For companions that do not need full session hygiene, the minimum viable version is:

**Start:** Read tracking/next-actions.md. Report what is pending. Ask what to work on.

**Finish:** Write to tracking/next-actions.md. List what to do next session. Commit.

This takes 30 seconds at each end and prevents the worst failures. Companions can elaborate from here as needed.

---

## Relationship to Other Capabilities

### Context Ecosystem
Session hygiene reads and writes context files. The start protocol reads them for orientation. The finish protocol updates them with session captures. Session hygiene is the engine that keeps the context ecosystem current.

### Insight Feedback Loop
The finish protocol includes insight capture as a step. Without session hygiene, insight capture is ad-hoc and often forgotten.

### Knowledge Zones
The session start protocol reads from the Sessions zone (session log, recent activity) and the Decisions zone (what has been decided). The finish protocol writes to the Sessions zone and may update the Insights zone.

### Process Evolution
Session records (captured by the finish protocol) are the raw material for process evolution. Without session hygiene capturing what happened and what could be better, process evolution has nothing to analyze.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Skipping session start | Companion operates on stale or assumed context | Always read current state before acting |
| Skipping session finish | Knowledge trapped in conversation, lost at session end | Always capture before closing |
| Overly long start protocol | 500-word status report when the user wants to work | Keep it to 3-5 sentences with key highlights |
| Finish protocol as formality | Going through the motions without capturing anything real | Each finish should produce at least one meaningful update |
| No next-actions | Sessions end without clear guidance for what comes next | Always write what the next session should start with |
| Git commit without session capture | Changes committed but no record of what they mean | Capture first, commit second |
