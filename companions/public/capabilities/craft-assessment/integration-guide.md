# Craft Assessment: Integration Guide

How to set up and maintain multi-dimensional skill tracking in a companion project.

---

## Setting Up the Craft Assessment Framework

### File Location

The assessment lives in the persona-specific context directory:

| Persona | Location |
|---------|----------|
| Writing Mentor | `context/author/craft-assessment.md` |
| Game Designer | `context/design/skill-assessment.md` |
| Product Manager | `context/product/strategic-maturity.md` |

### Initial Structure

```markdown
# Craft Assessment

<!-- Evidence-based skill tracking across dimensions.
     Updated when evidence warrants, not on a schedule.
     Recalibrated every 8-12 sessions or at milestones. -->

## Assessment Summary

**Last calibrated:** [date]
**Sessions since calibration:** [count]
**Next calibration trigger:** [session count or milestone]

| Dimension | Current Level | Trend | Last Evidence |
|-----------|--------------|-------|---------------|
| [Dim 1]   | [level]      | [steady/improving/regressing] | [date] |
| [Dim 2]   | [level]      | [steady/improving/regressing] | [date] |
| [Dim 3]   | [level]      | [steady/improving/regressing] | [date] |
| [Dim 4]   | [level]      | [steady/improving/regressing] | [date] |

## Dimension Details

### [Dimension 1 Name]

**Current level:** [N] — [Level description]
**Trend:** [steady/improving/regressing]

**Level definitions:**
1. [Description of level 1 — concrete, observable]
2. [Description of level 2 — concrete, observable]
3. [Description of level 3 — concrete, observable]
4. [Description of level 4 — concrete, observable]
5. [Description of level 5 — concrete, observable]

**Evidence log:**
- [Date] — [Specific evidence from actual work, with file/chapter reference]
- [Date] — [Specific evidence from actual work, with file/chapter reference]

**Interacts with:** [Other dimensions affected by this one]

### [Dimension 2 Name]
...

## Calibration History

### Calibration [date]
**Trigger:** [What triggered this calibration]
**Changes:**
- [Dimension]: [old level] -> [new level] (evidence: [summary])
- [Dimension]: No change (evidence: [why not])
**Notes:** [Any broader observations about development]
```

---

## Defining Dimensions and Levels

### Step 1: Identify Core Dimensions

Start with the 4-6 most important skill dimensions for the domain. Do not try to be exhaustive — start focused and extend later.

**Process:**
1. What are the component skills of this craft?
2. Which of those skills are independently observable? (If two skills always appear together, they might be one dimension.)
3. Which of those skills are developable? (If a skill is innate or binary, it is not a useful dimension.)
4. Prioritize: which dimensions will most improve the user's work if developed?

**Writing example:**
```markdown
### Core Dimensions (start with these)
1. Showing vs. Telling
2. Voice Consistency
3. Dialogue Naturalism
4. Narrative Structure

### Extended Dimensions (add when core is established)
5. Character Interiority
6. Thematic Integration
7. Sensory Specificity
8. Revision Discipline
```

### Step 2: Define Levels

Each dimension needs 4-5 levels. Levels must be:
- **Observable** — Based on what can be seen in the work, not inferred about the mind
- **Progressive** — Each level clearly builds on the previous
- **Evidence-friendly** — It must be possible to point to specific examples that demonstrate the level

**Template for level definitions:**
```markdown
1. **[Beginner label]** — [What the work looks like at this level]
   Evidence: [What you'd see in a draft/design/decision]

2. **[Developing label]** — [What the work looks like at this level]
   Evidence: [What you'd see in a draft/design/decision]

3. **[Competent label]** — [What the work looks like at this level]
   Evidence: [What you'd see in a draft/design/decision]

4. **[Proficient label]** — [What the work looks like at this level]
   Evidence: [What you'd see in a draft/design/decision]

5. **[Masterful label]** — [What the work looks like at this level]
   Evidence: [What you'd see in a draft/design/decision]
```

### Step 3: Map Interactions

Document which dimensions affect each other. This informs how the companion interprets changes.

```markdown
## Dimension Interaction Map

Showing vs. Telling <-> Sensory Specificity
  When showing improves, sensory detail often improves (showing requires specific details).
  Work on sensory specificity may improve showing as a side effect.

Voice Consistency <-> Character Interiority
  A consistent voice affects how internal thoughts read.
  Developing character interiority may initially disrupt voice consistency.

Dialogue Naturalism <-> Showing vs. Telling
  Natural dialogue IS showing. Improving dialogue often improves showing metrics.
  But stilted dialogue used for exposition is a "telling" pattern that shows up here.
```

---

## Integrating Assessment into Review Commands

Commands that review the user's work should reference the craft assessment to focus feedback.

### Pattern: Assessment-Informed Review

```markdown
## Step 1: Read Craft Assessment

Read `context/author/craft-assessment.md`.
Note:
- Current level on each dimension
- Dimensions with recent improvement (acknowledge growth)
- Dimensions the user is actively developing (focus feedback here)
- Stagnant dimensions (note but do not force — energy matters)

## Step 2: Review the Work

Review the submitted work (chapter, design doc, strategy memo).
For each dimension:
- Is there evidence relevant to the dimension?
- Does the evidence suggest the same level, improvement, or regression?
- Note specific passages/sections as evidence.

## Step 3: Provide Feedback

Structure feedback around the assessment:
- Lead with growth: "Your dialogue in this chapter is noticeably more natural
  than in Chapter 2 — you're letting the characters interrupt each other and
  leave things unsaid."
- Focus on the development edge: "Your showing-vs-telling is still at level 2
  in the climactic scene. You wrote 'She felt devastated.' What does devastation
  look like in her body, her actions, the way she holds the phone?"
- Note dimension interactions: "Improving your sensory detail here would help
  the showing — if you describe what she sees and hears, you won't need to
  tell us she's devastated."

## Step 4: Update Assessment Evidence

If this review revealed assessment-relevant evidence:
1. Draft the evidence entry for the relevant dimension(s).
2. Show the user.
3. On confirmation, append to the evidence log in the assessment file.
4. Do NOT change the level rating on a single piece of evidence.
```

### Pattern: Assessment-Informed /harvest

```markdown
## Step N: Assessment Check

During harvest, review session work for assessment evidence:
- Did any work produced this session provide evidence for a dimension?
- Did the user demonstrate a skill at a different level than currently assessed?
- Note evidence but do not recalibrate mid-harvest — only during formal recalibration.

Update the evidence log for any relevant dimensions.
Update "Last Evidence" date in the assessment summary.
```

---

## Triggering Recalibration

### By Session Count

Track sessions since last calibration in the assessment summary. When the count reaches the threshold (typically 8-12), trigger recalibration.

```markdown
## In /status (session start):

Read craft assessment.
If sessions since calibration >= [threshold]:
  "It's been [N] sessions since the last craft assessment calibration.
  Would you like to recalibrate this session, or defer?"
```

### By Milestone

Define milestones in the assessment file that trigger recalibration:

```markdown
## Calibration Triggers

- [8-12] sessions since last calibration
- Completion of a major work (manuscript, design document, product launch)
- User request
- Insights log suggests assessment is stale
```

### The Recalibration Process

```markdown
# /recalibrate (or integrated into a broader command)

## Step 1: Read Full Assessment

Read the current assessment, including all evidence logs.

## Step 2: Read Recent Work

Read or reference all work produced since the last calibration.

## Step 3: Evaluate Each Dimension

For each dimension:
1. Review accumulated evidence since last calibration.
2. Does the evidence support a level change?
   - Multiple pieces of evidence at a higher level -> upgrade
   - Mixed evidence -> hold at current level, note the mix
   - Evidence of regression -> downgrade (rare but honest)
   - No new evidence -> hold, note stagnation
3. Draft the updated level with rationale.

## Step 4: Present to User

Show the updated assessment:
- Dimensions that changed (with evidence)
- Dimensions that didn't change (with reason)
- Overall trend narrative

This is a discussion, not a verdict. The user may provide context
that changes the interpretation: "I was deliberately experimenting
with telling in that chapter — it was intentional." Note this as
context without changing the evidence.

## Step 5: Update Assessment File

On confirmation:
- Update the summary table
- Update dimension details with new levels and evidence
- Add a calibration history entry
- Reset the session counter
- Set the next calibration trigger
```

---

## Connecting Assessment to Curriculum and Development Planning

### Writing Mentor: Curriculum Integration

```markdown
## In craft assessment file:

## Development Focus

**Current priority dimensions:**
1. [Dimension] — at level [N], targeting level [N+1]
   **Development approach:** [Specific exercises, mentor framings, types of work]
   **Evidence needed for level-up:** [What would demonstrate the next level]

2. [Dimension] — at level [N], targeting level [N+1]
   **Development approach:** [Specific exercises, mentor framings, types of work]
   **Evidence needed for level-up:** [What would demonstrate the next level]

**Maintenance dimensions** (at a good level, keep practicing):
- [Dimension] at level [N]

**Deferred dimensions** (not currently focusing on):
- [Dimension] at level [N] — will address after [condition]
```

### Game Designer: Skill Development

```markdown
## Development Focus

**Current priority skills:**
1. Economy Balance — at level 2, targeting level 3
   **Approach:** Apply Koster's "Theory of Fun" principles to economy simulation.
   Run 100-turn simulations before finalizing parameters.
   **Evidence for level 3:** Economy simulation shows no exponential divergence
   at 100 turns across 3 different player strategy profiles.

2. Framework Application — at level 2, targeting level 3
   **Approach:** Apply at least two frameworks to every major design decision.
   Document framework analysis in design docs.
   **Evidence for level 3:** Design docs consistently show multi-framework analysis
   with conflicting insights resolved through design pillars.
```

### Session Planning from Assessment

The session start protocol can use the assessment to suggest focus areas:

```markdown
## In /status:

Read craft assessment.
If development focus dimensions are defined:
  "Based on your craft assessment, your current development priorities are:
  1. [Dimension] — [brief status]
  2. [Dimension] — [brief status]

  Today's session could focus on [suggestion based on the work available
  and the development priority]."
```

---

## Common Pitfalls

### Assessment as Report Card

The assessment should feel like a development tool, not a grade. The companion should never say "You got a 2 out of 5." Instead: "Your showing-vs-telling is at level 2, which means you're aware of the distinction and working to shift your default. Here's what level 3 looks like and how to get there."

### Premature Assessment

Assessing before enough evidence exists produces inaccurate baselines. Wait for 2-3 sessions of actual work review before the initial assessment. A wrong initial assessment is worse than no assessment.

### Level Obsession

Users may fixate on leveling up rather than developing their craft. The companion should redirect: "The levels are a map, not a destination. The goal is not to reach level 5 on everything — it's to develop the skills that serve your creative goals."

### Dimension Proliferation

Starting with too many dimensions dilutes focus. Begin with 4-6 core dimensions. Add new dimensions only when the core is well-established and a genuine gap appears.

### Ignoring Regression

Skills can regress, especially when a writer or designer is experimenting or under pressure. The assessment should honestly track regression with context: "Level dropped from 3 to 2 during the experimental chapter — this may be a temporary effect of trying a new approach."
