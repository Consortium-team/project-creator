# Process Evolution: Integration Guide

How to implement continuous process improvement in a companion project.

---

## Implementing /record

The `/record` command captures a session-level observation about what could be improved. It should be fast and low-friction.

### Command Definition

```markdown
# /record

Capture an observation about what could be improved in the companion's process.

## Steps

1. Ask the user: "What happened that could have gone better?"
   - Listen to the full description.
   - If the user is vague ("the session felt slow"), push for specificity:
     "Which part felt slow? Was it a specific command, a waiting period,
     or something about the flow?"

2. Structure the observation:

   **What happened:** [The specific situation]
   **What was expected:** [What should have happened]
   **What actually happened:** [The gap]
   **Affected component:** [Command name, skill name, protocol name, or "workflow"]
   **Suggested fix:** [Optional — the user may not know the fix]

3. Show the structured observation to the user for confirmation.

4. On confirmation, append to `tracking/session-records.md`.

5. Check record count:
   - If 5+ unprocessed records exist:
     "There are [N] unprocessed session records. Consider running /evolve
     to analyze patterns and propose improvements."

## Rules
- This should take under 2 minutes. Do not turn it into a deep analysis.
- Capture the observation as the user describes it — do not reframe or minimize.
- If the user names a fix, record it as a suggestion, not a decision.
  /evolve will evaluate suggestions alongside other records.
```

### Multiple Records Per Session

Sometimes a session surfaces multiple observations. The `/record` command should handle this:

```markdown
## Variant: Multiple Records

If the user has several observations:
1. Capture each one with the standard structure.
2. Write all to session-records.md in a single batch.
3. Do NOT combine them into one record — each observation is distinct.
```

---

## Structuring Evolution Records

### File Location

```
tracking/session-records.md
```

### File Structure

```markdown
# Session Records

<!-- Observations about what could be improved in the companion's process.
     Analyzed periodically by /evolve. Processed records are moved to the
     "Processed" section with a reference to the evolution that addressed them. -->

## Unprocessed

### [Date] — [Brief title]
**What happened:** [The specific situation]
**What was expected:** [What should have happened]
**What actually happened:** [The gap]
**Affected component:** [Command/skill/protocol name]
**Suggested fix:** [Optional user suggestion]

### [Date] — [Brief title]
...

## Processed

### [Date] — [Brief title]
[Original record]
**Processed by:** /evolve on [date]
**Outcome:** [What change was made, or "Deferred — waiting for pattern confirmation"]
```

### Example Records

```markdown
### 2026-02-15 — /status reads stale insights
**What happened:** /status reported the project state but did not mention recent insights.
**What was expected:** The status report should surface relevant insights from the last 2-3 sessions.
**What actually happened:** Had to manually open the insights log to find what was captured last time.
**Affected component:** /status command
**Suggested fix:** Add a step to /status that reads the insights log and surfaces recent entries.

### 2026-02-18 — /seed prompts too generic
**What happened:** /seed generated a writing prompt that could apply to any writer.
**What was expected:** The prompt should incorporate the writer's specific development focus from the craft assessment.
**What actually happened:** Prompt said "Write a scene with dialogue." No mention of the writer's dialogue naturalism work.
**Affected component:** /seed command
**Suggested fix:** /seed should read the craft assessment and weight the prompt toward the current development focus.

### 2026-02-20 — /seed prompts still generic
**What happened:** Second time /seed produced a prompt without referencing the writer's specific situation.
**What was expected:** After last record, expected this would be addressed.
**What actually happened:** Same issue as 2/18.
**Affected component:** /seed command
**Suggested fix:** Same as before — this is now a pattern.
```

---

## Implementing /evolve

The `/evolve` command analyzes accumulated records and proposes concrete changes.

### Command Definition

```markdown
# /evolve

Analyze session records and propose improvements to the companion's process.

## Steps

1. Read all records:
   - `tracking/session-records.md` (unprocessed section)
   - If fewer than 3 unprocessed records, inform the user:
     "Only [N] unprocessed records. /evolve works best with 5+ records
     so patterns can emerge. Continue recording, or proceed anyway?"

2. Identify patterns:
   - Group records by affected component.
   - Look for recurring themes (same component, similar complaint).
   - Apply the three-occurrence rule: single occurrences are noted but
     not acted on. Three or more occurrences are actionable patterns.
   - Note any suggested fixes that appear across multiple records.

3. For each actionable pattern, draft a proposal:

   **Pattern:** [Description of the recurring issue]
   **Records:** [References to the specific records that form this pattern]
   **Affected component:** [What needs to change]
   **Proposed change:**
   - **Before:** [Current behavior — show the relevant section of the command/skill]
   - **After:** [Proposed behavior — show the modified section]
   - **Rationale:** [Why this change addresses the pattern]
   - **Risk:** [What could go wrong, if anything]

4. For single-occurrence records:
   - Note them as "Monitoring — waiting for pattern confirmation"
   - Do NOT propose changes based on single occurrences (unless critical)

5. Present all proposals to the user:
   - Actionable patterns with specific proposed changes
   - Monitoring items (acknowledged but not acted on yet)
   - Ask: "Which proposals should I implement?"

6. For approved proposals:
   a. Read the current version of the affected file.
   b. Make the specific change described in the proposal.
   c. Show the user the diff (before/after).
   d. On confirmation, write the change.
   e. Commit with a clear message:
      "Evolve [component]: [brief description of change]

      Pattern: [what was recurring]
      Records: [dates of records that informed this]"

7. Move processed records to the "Processed" section of session-records.md
   with a reference to the outcome.

## Rules
- Never implement a change without showing the before/after.
- Never implement a change the user has not approved.
- Make the SMALLEST change that addresses the pattern. Do not rewrite
  entire commands when a single step needs modification.
- If a pattern suggests a new command or skill is needed, propose it
  but do not create it in /evolve. Create it as a separate task.
```

---

## Evaluating Proposed Changes

### The Before/After Test

Every proposed change should pass the before/after test: can you show the user exactly what changes and why?

**Good proposal:**
```
Before: /status reads context files and reports state.
After: /status reads context files AND insights log, reports state
       with recent insights highlighted.

Why: Three records (2/15, 2/18, 2/22) report that /status does not
surface insights, requiring manual log reading.
```

**Bad proposal:**
```
We should make /status better at surfacing context.

Why: It doesn't feel comprehensive enough.
```

### Risk Assessment

Consider what could go wrong:
- **Performance:** Does the change make the command slower? (Adding more file reads)
- **Scope creep:** Does the change make the command try to do too much?
- **Dependency:** Does the change create a new dependency that might break?
- **Regression:** Could this change break something that currently works?

Low-risk changes (adding a file read, reordering steps) can be approved quickly. High-risk changes (new commands, structural changes) deserve more discussion.

### Testing the Change

After implementing a change, the next session that uses the affected command is the test. The session should verify:
- Did the change address the pattern?
- Did the change introduce new problems?
- Does the command still feel right to use?

If the change does not help or causes new issues, record that observation and consider reverting.

---

## The Three-Phase Methodology Applied to Process

Process evolution follows the same three-phase pattern as the companion's primary work.

### Seeding: Accumulate Records

The first 5-10 sessions with any companion are seeding for process evolution. Commands are used as-is, and observations are recorded. The goal is raw material — enough records to see patterns.

**Do not** run /evolve during the first 3-5 sessions. Let patterns emerge naturally.

### Cultivation: Identify Patterns

Once 5+ records have accumulated, /evolve can identify patterns. This is the cultivation phase — connecting observations, finding recurring themes, proposing changes.

**Run /evolve** every 5-10 sessions or when records hit 5+ entries.

### Shaping: Implement Changes

Approved proposals are implemented — commands are updated, skills are refined, protocols are adjusted. The companion's configuration becomes better adapted to the actual work.

**After changes**, return to seeding: use the evolved commands and record new observations.

---

## Integrating /record with Session End

The most natural time to run `/record` is at the end of a session, as part of the finish protocol.

### Pattern: Record Prompt in /checkpoint or /harvest

```markdown
## Step N: Process Observation

Before closing, ask:
"Was there anything about today's session that could have gone better?
A command that felt awkward, a step that was missing, something that
took too long?"

If the user has an observation:
- Capture it with the /record structure.
- Append to tracking/session-records.md.

If the user says "nothing" or "it was fine":
- Move on. Do not force it.

If unprocessed record count >= 5:
- Note: "There are [N] unprocessed session records. Consider running
  /evolve next session."
```

### Pattern: Mid-Session Record

Sometimes the user notices an issue mid-session. The companion should offer to capture it immediately:

```markdown
User: "This is annoying — the /seed command doesn't use my craft assessment."

Companion: "Want me to record that as a process observation?
It'll go into the session records for the next /evolve run."

User: "Yes."

[Capture the record immediately, then continue the session.]
```

---

## When to Run /evolve

### By Record Count

The simplest trigger: run /evolve when 5 or more unprocessed records exist. The /status or /checkpoint command should surface this count.

### By Session Count

If sessions are frequent and records accumulate slowly, run /evolve every 10 sessions regardless of record count. Even 2-3 records after 10 sessions may contain patterns.

### By User Request

The user can always invoke /evolve directly. They may notice a pattern before the companion does.

### Avoid

- Running /evolve every session (too frequent, not enough data)
- Running /evolve with only 1 record (not enough for patterns)
- Never running /evolve (records accumulate but nothing changes)

---

## Common Pitfalls

### Record Fatigue

If the user feels like /record is a chore, the friction is too high. Reduce it: offer a one-sentence capture option instead of the full structure. A brief note is better than no note.

### Over-Evolution

Changing too many things at once makes it impossible to know what helped. Implement 1-3 changes per /evolve cycle, then observe. If everything changes at once, the next round of records cannot attribute problems to specific changes.

### Under-Evolution

Accumulating records but never acting on them. The records become a complaint box that nobody empties. Set a hard trigger: when records hit 5, run /evolve. No exceptions.

### Evolving Without Evidence

Changing a command because it "could be better" without any session records supporting the change. If it is not producing records, it is working well enough. Focus evolution where the evidence points.

### Losing the Git Trail

Every evolution should be a clear git commit with rationale. If evolved commands are modified casually without commits, the history is lost and rollback becomes impossible.
