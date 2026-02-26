# Session Hygiene: Integration Guide

How to implement session start and finish protocols in a companion project.

---

## Implementing Session Start Commands

The session start protocol surfaces current state and recommends what to work on. It is typically implemented as `/status` or `/start-session` (some personas use domain-specific names like `/start-issue` for software development).

### The /status Command Pattern

```markdown
# /status

Orient to the current project state and recommend what to work on.

## Steps

1. Read current state:
   - `context/decisions.md` — Recent decisions
   - `context/requirements.md` — Current requirements
   - `context/questions.md` — Open questions
   - `tracking/session-log.md` — What happened recently
   - `tracking/next-actions.md` — What was queued for this session
   - [persona-specific files: insights log, hypothesis, craft assessment, etc.]

2. Summarize in 3-5 sentences:
   - Current phase (Seeding / Cultivation / Shaping)
   - What was accomplished in the last session
   - What is pending or needs attention
   - Any flags (stale context, accumulating contradictions, overdue synthesis)

3. Surface next-actions:
   - Read `tracking/next-actions.md`
   - Present queued items for this session
   - Recommend what to tackle first (with brief rationale)

4. Ask: "What would you like to work on?"
   - If the user agrees with the recommendation, proceed.
   - If the user has a different priority, follow their lead.

## Rules
- Keep the status report concise. The user wants orientation, not a lecture.
- Always surface open questions and contradictions — these are the highest-value items.
- Do NOT start generating artifacts or answering questions during /status.
  Orientation first, work second.
```

### Persona-Specific Variations

**Game Designer:**
```markdown
# /status

[Standard orientation steps, plus:]

5. Read `context/design/insights-log.md`
   - Surface any insights from the last 3 sessions that connect to today's topic
   - Note if synthesis is overdue (15+ active insights without synthesis)

6. Read `context/design/pillars.md`
   - Confirm design pillars are current
   - Note any recent evidence for or against pillars
```

**Writing Mentor:**
```markdown
# /status

[Standard orientation steps, plus:]

5. Read `context/author/craft-insights.md`
   - Surface recent craft observations
   - Note the current focus area in the curriculum

6. Read `context/author/profile.md`
   - Note the writer's current goals and working state
   - Reference any ongoing writing projects and their status
```

**Product Manager:**
```markdown
# /status

[Standard orientation steps, plus:]

5. Read `context/product/hypothesis.md`
   - Current hypothesis version and status
   - Recent evidence (especially contradicting evidence)
   - Note if hypothesis refinement is overdue
```

---

## Implementing Session End Commands

The session end protocol captures what happened and prepares for the next session. It is typically implemented as `/checkpoint` or `/harvest` (some personas use both for different purposes).

### The /checkpoint Command Pattern

```markdown
# /checkpoint

Capture session state before ending.

## Steps

1. Review what happened this session:
   - What topics were discussed
   - What files were created or modified
   - What decisions were made
   - What questions were raised

2. Capture insights (see Insight Feedback Loop integration):
   - Did any patterns emerge from this session's work?
   - Did understanding of existing insights deepen?
   - If mandatory persona: at least one insight must be captured.
   - If recommended persona: prompt but do not block.

3. Update tracking files:

   a. Update `tracking/session-log.md`:
      ```markdown
      ## Session [date]
      **Duration:** [approximate]
      **Topics:** [what was worked on]
      **Outcomes:** [what was accomplished]
      **Decisions made:** [list, with pointers to decisions.md entries]
      **Insights captured:** [list, with pointers to insights log entries]
      ```

   b. Update `tracking/next-actions.md`:
      ```markdown
      # Next Actions

      **Updated:** [date]
      **Priority for next session:**
      1. [Most important thing to do next]
      2. [Second priority]
      3. [Third priority]

      **Open threads:**
      - [Topic that needs continuation but is not urgent]
      - [Topic that needs continuation but is not urgent]

      **Deferred:**
      - [Item that was considered but pushed to later]
      ```

4. Commit changes:
   - Stage all modified files
   - Commit with a message summarizing the session:
     "[date] session: [brief summary of what was accomplished]"

5. Report to the user:
   "Session captured. [N] files updated, [M] insights logged.
   Next session should start with: [top priority from next-actions]."

## Rules
- Do NOT skip the commit step. Uncommitted changes are at risk.
- Do NOT summarize so aggressively that detail is lost.
  The session log should contain enough that a future session can understand
  what happened without re-reading the entire conversation.
- Always write next-actions. A session without next-actions leaves the
  next session directionless.
```

### The /harvest Command Pattern

Some personas use `/harvest` instead of or in addition to `/checkpoint`. The distinction:

- **`/checkpoint`** — Lightweight session state capture. Quick, focused on continuity.
- **`/harvest`** — Deeper review that synthesizes session work into structured artifacts. Takes longer, produces more.

```markdown
# /harvest

Deep review and synthesis of session work.

## Steps

1. Review all work produced this session:
   - Read files created or modified
   - Read conversation for context that did not make it to files

2. Extract and structure:
   - Insights for the insights log
   - Decisions for decisions.md (if any were made but not yet recorded)
   - Questions for questions.md (if any were raised but not yet recorded)
   - Updates to persona-specific context files

3. Synthesize:
   - How does this session's work connect to the broader project?
   - Did this session change the direction of the project?
   - Are there implications for the hypothesis, pillars, or curriculum?

4. Update all relevant files with confirmed extractions.

5. Update tracking files (session-log.md, next-actions.md).

6. Commit all changes.

7. Report summary to the user.
```

---

## What to Capture at Session End

The session end protocol should capture five categories.

### 1. Decisions

Any decision made during the session, whether explicit ("Let's go with approach A") or implicit (choosing to work on X instead of Y).

**Format in session-log.md:**
```markdown
**Decisions:**
- Chose to focus on economy balancing over combat design (rationale: economy is blocking)
- Decided to use exponential scaling for XP curve (see decisions.md entry)
```

### 2. Insights

Observations about patterns, the user's process, the work itself, or the domain. See Insight Feedback Loop capability for entry format.

### 3. Next Steps

Concrete actions for the next session. Not vague ("continue working on the game") but specific ("playtest the economy with 100-turn simulation, focusing on gold accumulation rate after turn 50").

### 4. Open Questions

Questions that surfaced during the session but were not resolved. These go to both `questions.md` (for the project) and `next-actions.md` (for the next session).

### 5. Session Context

The non-structural context that helps the next session understand the tone and state of the work. "The writer was energized about the new character direction." "The designer is frustrated with the economy and may need a different approach next session." This goes in the session log, not in formal context files.

---

## Integrating with Git

Session hygiene and git workflows reinforce each other. Every session end should produce a clean commit.

### The Git Commit Pattern

```markdown
## Step N: Commit Session Changes

1. Run `git status` to see all changes.

2. Stage all relevant files:
   - Context files that were updated
   - Tracking files (session-log.md, next-actions.md)
   - Any artifacts created during the session
   - Insights log updates

3. Do NOT stage:
   - Files with sensitive information (credentials, API keys)
   - Temporary or scratch files
   - Large binary files unless intentional

4. Commit with a descriptive message:
   "[YYYY-MM-DD] [brief session summary]"

   Examples:
   - "2026-02-23 Economy balancing session: identified exponential/linear mismatch"
   - "2026-02-23 Intake session: captured user segments and initial hypothesis"
   - "2026-02-23 Chapter 3 review: dialogue revision with King framing"
```

### Branch Strategy

Most companion projects work on a single branch (main). The git history serves as a session-by-session record of project evolution. For companions with more complex workflows (software development), branching may be appropriate per feature or sprint.

---

## Templates

### tracking/session-log.md

```markdown
# Session Log

<!-- Append new sessions at the top. Most recent first. -->

## Session YYYY-MM-DD
**Focus:** [What this session was about]
**Outcomes:**
- [What was accomplished]
- [What was accomplished]

**Decisions:**
- [Decision made, with pointer to decisions.md if applicable]

**Insights captured:**
- [Insight title, with pointer to insights log]

**Open questions raised:**
- [Question, with pointer to questions.md if applicable]

**Session context:**
[Brief note about the state of the work — energy level, direction, mood]

**Next session should:**
[Pointer to next-actions.md, or inline if brief]
```

### tracking/next-actions.md

```markdown
# Next Actions

**Updated:** YYYY-MM-DD

## Priority for Next Session

1. [Most important — be specific]
2. [Second priority — be specific]
3. [Third priority — be specific]

## Open Threads

- [Topic needing continuation, with brief context]
- [Topic needing continuation, with brief context]

## Deferred

- [Item pushed to later, with reason]
- [Item pushed to later, with reason]
```

---

## Calibrating Protocol Weight

Different project phases need different levels of session hygiene.

### Early Seeding Phase

**Start:** Lightweight — there is not much state to read yet. Focus on what was captured last session and what to explore next.

**Finish:** Full — every seeding session produces raw material that must be captured. Do not lose it.

### Active Cultivation Phase

**Start:** Full — there is significant state to orient on. Insights, decisions, and open questions all matter.

**Finish:** Full — cultivation produces connections and refinements that must be tracked.

### Shaping Phase

**Start:** Full — orientation is critical when generating artifacts from context.

**Finish:** Moderate — the outputs are the artifacts themselves (specs, plans, tickets). Session logging can be lighter since the work is visible in the files.

### Maintenance Phase

**Start:** Lightweight — quick check on state and pending items.

**Finish:** Lightweight — update next-actions and commit. Full capture only if significant decisions or insights emerged.

---

## Common Pitfalls

### Protocol Creep

Session hygiene should not take more than 2-3 minutes at each end. If it is taking longer, the protocol is too heavy. Cut it back to essentials: read state, orient, recommend (start); capture, commit, next-actions (finish).

### Stale next-actions.md

If next-actions.md is not updated at session end, the next session reads stale recommendations. This is worse than having no next-actions file — it misleads. If you cannot update it properly, at least clear it with "Next actions not captured this session — start with /status."

### Session Log as Diary

The session log should be scannable, not narrative. Future sessions need to quickly find what happened and what was decided. Keep entries structured. Save narrative for the "Session context" field if needed.

### Skipping Git Commits

Uncommitted changes are invisible to future sessions that start by reading files from disk. If changes exist only in the working tree (unstaged), they survive — but the git history loses the session boundary. Commit at every session end for a clean audit trail.
