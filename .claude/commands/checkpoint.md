# /checkpoint — Session Capture

Capture session state before ending. Preserves progress across context boundaries.

## Usage

```
/checkpoint                       # Use current companion
/checkpoint [client/companion]   # Override for specific companion
```

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Determine the Companion

1. If `$ARGUMENTS` contains a companion path, use that
2. Otherwise, read `tracking/current-companion.md` for the current companion
3. If no companion is set:
   ```
   No active companion to checkpoint. What were you working on?
   ```
   (Can still capture general session notes to patterns-discovered.md)

---

### Step 2: Review the Session

Look back at what happened in this conversation:

**Context Captured:**
- What requirements were documented?
- What constraints were identified?
- What decisions were made?
- What questions were raised?

**Actions Taken:**
- Commands run (`/intake`, `/process`, `/onboard`, etc.)
- Files created or updated
- Directories created

**Insights Gained:**
- Understanding that emerged
- Connections made
- Patterns noticed

---

### Step 3: Summarize for the User

Present a session summary:

```
## Session Summary: [project]

### What Was Captured
- [Bullet points of key context captured]
- [Requirements, constraints, decisions]

### Files Updated
- `context/requirements.md` — [what was added]
- `context/constraints.md` — [what was added]
- [other files]

### Progress
- Started: [where we were]
- Now: [where we are]
- Seeding readiness: ~[X]% (rough estimate)

### Open Threads
- [Things left incomplete]
- [Questions raised but not answered]

---

Does this capture the session accurately? Anything to add?
```

---

### Step 4: Update Tracking Files

After user confirms (or immediately if summary is accurate):

**Update `tracking/projects-log.md`:**

Add a session entry:
```markdown
### [Today's Date] — [client/companion]

**What was captured:**
- [Summary of requirements/constraints/decisions captured]

**Commands used:**
- [Commands run this session]

**Gaps remaining:**
- [High-priority gaps still to fill]

**Next steps:**
- [Specific actions for next session]
```

Also update the Active Projects table if status changed.

**Update `tracking/patterns-discovered.md`** (if applicable):

If any patterns, friction, or learnings emerged:
- Add to Command Improvements table (if command friction observed)
- Add to Recurring Questions (if a question keeps coming up)
- Add to Project Archetypes (if this project type has patterns)

---

### Step 5: Prepare Handoff Notes

Create notes that would help resume work, even with complete context loss:

```
## Handoff Notes: [project]

### Where We Are
[One paragraph describing current state]

### What's Been Captured
[Bullet list of key context that exists]

### What's Still Needed
[Prioritized list of gaps]

### Recommended Next Session
1. [First action to take]
2. [Second action]
3. [Third action]

### Key Files to Read
- `context/requirements.md` — [what's there]
- `context/constraints.md` — [what's there]
- `context/decisions.md` — [what's there]
```

Save these notes to `companions/[client]/[companion]/HANDOFF.md`

---

### Step 6: Offer to Commit

If the project has a git repo:

```
Would you like me to commit these changes?

Files to commit:
- context/requirements.md
- context/constraints.md
- [other changed files]
- HANDOFF.md

Suggested commit message:
"Checkpoint: [brief summary of session]"
```

If user agrees, stage and commit the changes.

---

### Step 7: Final Confirmation

```
## Checkpoint Complete

**Session captured in:**
- tracking/projects-log.md (session entry)
- [project]/HANDOFF.md (resume notes)
- [if patterns] tracking/patterns-discovered.md

**Next time, start with:**
  /companion [client/companion]    # Set context
  /gaps                        # See where you left off

Or read HANDOFF.md in the project directory for a quick summary.
```

---

## What Makes a Good Checkpoint

### Captures State, Not Just Actions
- "We decided X because Y" not just "ran /intake"
- "Requirements are 70% captured, missing timeline" not just "updated files"

### Enables Cold Resume
- Someone (or Claude) with no context should be able to pick up
- HANDOFF.md should be self-contained
- Key files clearly listed

### Notes Patterns
- If something was hard, note it
- If a question kept coming up, note it
- If a structure worked well, note it

### Sets Up Next Session
- Specific next actions, not vague "continue work"
- Priority order matters
- Blockers or questions flagged
