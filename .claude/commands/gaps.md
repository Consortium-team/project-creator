# /gaps — Assessment Checkpoint

Assess what's captured vs. what's needed for a complete project definition.

## Usage

```
/gaps                     # Use current companion
/gaps [client/companion]    # Override for specific companion
```

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Determine the Project

1. If `$ARGUMENTS` contains a project path, use that
2. Otherwise, read `tracking/current-companion.md` for the current project
3. If no project is set:
   ```
   No companion set. Use /companion to set or create one first.
   ```

---

### Step 2: Read All Context

Read everything in the project's `context/` directory:
- `requirements.md`
- `constraints.md`
- `decisions.md`
- `questions.md`
- Any other context files

Also check for:
- `CLAUDE.md` — Project configuration
- `README.md` — Human documentation
- `.claude/commands/` — Any commands defined
- `docs/` — Additional documentation

---

### Step 3: Assess Against Checklist

Evaluate each area on a scale: **Complete | Partial | Missing | N/A**

**Purpose & Vision**
| Item | Status | Evidence |
|------|--------|----------|
| Problem statement | | What file/section documents this |
| Why it matters | | |
| What success looks like | | |
| What makes it distinct | | |

**Users & Needs**
| Item | Status | Evidence |
|------|--------|----------|
| Primary users identified | | |
| User needs documented | | |
| Current pain points | | |
| Different user types (if applicable) | | |

**Requirements**
| Item | Status | Evidence |
|------|--------|----------|
| Core functionality defined | | |
| Must-haves vs nice-to-haves | | |
| Scope boundaries clear | | |
| Non-functional requirements | | |

**Constraints**
| Item | Status | Evidence |
|------|--------|----------|
| Technical constraints | | |
| Timeline/deadlines | | |
| Resource limitations | | |
| Organizational constraints | | |
| Integration requirements | | |

**Decisions**
| Item | Status | Evidence |
|------|--------|----------|
| Key decisions documented | | |
| Rationale captured | | |
| Alternatives considered | | |
| Open questions tracked | | |

**Context**
| Item | Status | Evidence |
|------|--------|----------|
| Related systems | | |
| Prior art / inspiration | | |
| Domain knowledge | | |
| Dependencies | | |

---

### Step 4: Calculate Readiness

Based on the assessment, determine readiness for next phase:

**Seeding Phase Completion:**
- Essential: Purpose, Users, Core Requirements, Key Constraints
- Important: Success Criteria, Decisions, Context
- Nice-to-have: Full constraint documentation, all edge cases

```
## Seeding Readiness: [X]%

**Essential items:** [N]/[M] complete
**Important items:** [N]/[M] complete
**Overall:** [Ready for cultivation / Needs more seeding]
```

---

### Step 5: Prioritize Gaps

List gaps in priority order:

```
## Gaps (Prioritized)

### High Priority
These block progress to the next phase:
1. [Gap] — Why it matters
2. [Gap] — Why it matters

### Medium Priority
Important but not blocking:
1. [Gap] — Why it matters
2. [Gap] — Why it matters

### Low Priority
Nice to have, can fill later:
1. [Gap] — Why it matters

### Open Questions
Need answers before finalizing:
1. [Question from context/questions.md]
2. [Question identified during analysis]
```

---

### Step 6: Suggest Next Actions

Based on gaps, recommend specific actions:

```
## Recommended Next Steps

**To fill high-priority gaps:**
1. `/intake` — [specific topic to cover]
2. `/process` — [specific document to feed in, if known]

**Questions to answer:**
- [Question that would unlock multiple gaps]

**Ready to do now:**
- [Action that doesn't require more context]
```

---

### Step 7: Present the Full Report

Format the complete assessment:

```
# Gap Analysis: [project]

## Summary
- **Seeding readiness:** [X]%
- **High-priority gaps:** [N]
- **Open questions:** [N]

## Assessment Details

[Tables from Step 3]

## Gaps (Prioritized)

[Lists from Step 5]

## Recommended Next Steps

[Suggestions from Step 6]

---

Would you like to start addressing the highest-priority gap now?
```

---

## Assessment Guidelines

### Be Honest
- Partial is better than claiming Complete
- Missing is fine — that's what seeding is for
- N/A is valid for items that don't apply

### Look for Implicit Coverage
- Information might be in unexpected places
- README might contain requirements
- Code structure might imply constraints
- Don't mark Missing if it's documented somewhere

### Quality Over Quantity
- A clear one-sentence purpose beats a vague paragraph
- Three solid requirements beat ten fuzzy ones
- "We decided X because Y" is more valuable than just "We're doing X"

### Connect to Next Phase
- Gaps should map to specific actions
- Priorities should reflect what unblocks progress
- The goal is "ready for cultivation," not "perfectly documented"
