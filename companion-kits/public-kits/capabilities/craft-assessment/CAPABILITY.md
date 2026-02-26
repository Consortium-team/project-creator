# Capability: Craft Assessment

Multi-dimensional maturity tracking for creative or professional skill development, grounded in evidence from actual work.

---

## What It Is

Craft assessment tracks the user's development across multiple skill dimensions over time. Rather than a single "how good am I?" question, it breaks skill into named dimensions and tracks progress on each independently.

The key distinction from self-assessment: craft assessment is evidence-based. It draws on the user's actual work — reviewed drafts, completed designs, session artifacts — not on how the user feels about their skills. Feelings are valuable context but unreliable metrics.

The pattern:
1. **Define dimensions** — What are the component skills of this craft?
2. **Assess current level** — Where is the user on each dimension, based on evidence?
3. **Track progress** — How has each dimension changed over time?
4. **Recalibrate periodically** — Does the assessment still reflect reality?

---

## The Assessment Pattern

### Dimensions Are Domain-Specific

Each craft has its own dimensions. They cannot be generic — "communication skills" is not a dimension; "dialogue that reveals character without exposition" is.

**Writing dimensions (example):**
- Voice and style consistency
- Showing vs. telling
- Dialogue naturalism
- Narrative structure and pacing
- Character interiority
- Thematic integration
- Sensory detail and specificity
- Revision discipline

**Game design dimensions (example):**
- Core loop clarity
- Economy balance
- Player psychology modeling
- Mechanic interaction analysis
- Framework application depth
- Documentation quality
- Playtesting discipline

**Product strategy dimensions (example):**
- Hypothesis specificity and testability
- User segment definition
- Evidence-based decision-making
- Scope discipline
- Competitive positioning clarity
- Stakeholder communication

### Levels Within Dimensions

Each dimension has levels that describe progression. Levels should be concrete and observable, not abstract.

**Example: Showing vs. Telling (Writing)**

| Level | Description | Evidence |
|-------|-------------|----------|
| 1. Telling dominant | Emotions and motivations are stated directly ("She was angry") | Consistent pattern across multiple scenes |
| 2. Aware of the distinction | Attempts to show but defaults to telling under pressure | Some scenes show, high-stakes scenes revert to telling |
| 3. Mixed with intentionality | Chooses to tell or show based on narrative purpose | Can articulate why they chose telling in specific cases |
| 4. Showing dominant | Default is to show; telling is used sparingly and purposefully | Manuscript-level consistency with deliberate exceptions |
| 5. Mastery | Blurs the line — telling becomes a form of showing through voice | The narration itself reveals character through how it tells |

---

## When to Use

| Companion Type | Craft Assessment Role | Weight |
|----------------|----------------------|--------|
| Writing Mentor | Primary — tracks craft development across writing dimensions | Core |
| Game Designer | Supporting — tracks design skill maturity | Common |
| Product Manager | Optional — can track strategic thinking maturity | Light |
| Software Developer | Rare — code review serves a similar function in engineering | Minimal |

### Primary Use: Writing Companions

Writing is the natural home for craft assessment. Writers develop across multiple dimensions simultaneously, and the dimensions interact (improving "showing" affects "voice" which affects "character"). A writing mentor that tracks these dimensions can adapt its curriculum and feedback to focus where it matters most.

### Supporting Use: Game Design Companions

Game designers develop design skills that can be tracked — from basic mechanic creation to sophisticated system interaction analysis. Craft assessment helps a game design companion evolve its feedback from beginner-level ("define your core loop") to advanced ("analyze the second-order dynamics of this mechanic interaction").

---

## Key Principle: Evidence-Based, Not Self-Reported

The assessment must be grounded in evidence from the user's actual work.

**Evidence sources:**
- Reviewed drafts and revisions (writing)
- Design documents and their evolution (game design)
- Decisions made and their outcomes (product strategy)
- Session artifacts and their quality (any domain)

**What counts as evidence:**
- A specific passage in a draft that demonstrates showing vs. telling at level 3
- A design document where economy interactions were analyzed systematically (framework application at level 3)
- Three consecutive sessions where the founder tested assumptions before committing (evidence-based decision-making at level 3)

**What does NOT count as evidence:**
- "I feel like my dialogue is getting better" (feeling, not evidence)
- "I read a book about game balance" (input, not demonstrated skill)
- "I think I understand hypothesis testing now" (self-assessment, not evidence)

The companion should note self-reported confidence alongside evidence-based assessment. When they diverge, that divergence itself is an insight worth capturing.

---

## Dimension Interactions

Dimensions are not independent. Improving one often affects others.

**Example interaction map (writing):**
```
Showing vs. telling ← → Sensory detail (showing requires specific details)
Voice consistency ← → Character interiority (voice reveals character thinking)
Dialogue naturalism ← → Showing vs. telling (dialogue is a form of showing)
Structure and pacing ← → Thematic integration (themes emerge through structure)
```

The companion should be aware of these interactions. When a writer improves on "showing vs. telling," the companion should check whether "sensory detail" also improved (they often move together) and whether "voice consistency" was affected (sometimes showing disrupts voice in early attempts).

---

## Assessment Lifecycle

### Initial Assessment

The first assessment happens after enough work has been reviewed to have evidence — not at project start. An assessment without evidence is a guess.

**Timing:** After 2-3 sessions of reviewing actual work (for writing), or after 2-3 design iterations (for game design).

**Process:**
1. Review all work produced so far
2. For each dimension, identify the level that best matches the evidence
3. Record specific evidence for each rating
4. Present to the user for discussion (not for override — the evidence speaks)
5. Write the assessment to a file

### Ongoing Tracking

After the initial assessment, the companion tracks evidence of change during regular sessions. Not every session requires an assessment update — only sessions where evidence of progression (or regression) appears.

**Pattern:**
- During session work (review, feedback, design analysis), note evidence relevant to dimensions
- At session end, check: did any dimension's evidence change?
- If yes, note the new evidence in the assessment file
- Do not change the level rating until evidence accumulates (one good scene does not mean a level-up)

### Recalibration

Periodically, the full assessment should be recalibrated against accumulated evidence.

**Triggers:**
- After N sessions (typically 8-12)
- When a milestone is reached (completed manuscript, shipped game feature, launched product)
- When the user requests it
- When the insights log suggests the assessment is stale

**Process:**
1. Review all evidence since the last calibration
2. For each dimension, assess whether the accumulated evidence supports a level change
3. Update levels where warranted, with specific evidence
4. Note dimensions that have not changed — are they stuck, or is the user not working on them?
5. Present the updated assessment to the user

---

## Connecting Assessment to Development Planning

Craft assessment is not just measurement — it feeds into what the companion should focus on.

### Curriculum Integration

For writing mentors, the assessment informs the curriculum:
- **Weakest dimensions** suggest skill areas to develop next
- **Strongest dimensions** suggest where the writer can take on more ambitious challenges
- **Stagnant dimensions** suggest a need for different approaches (new exercises, different mentor framings)

### Session Planning

The assessment informs the session start protocol:
- "Your showing-vs-telling has improved to level 3 based on the last two chapters. Your dialogue naturalism is still at level 2. This session, let's focus on a scene with heavy dialogue to work that dimension."

### Mentor Selection

For companions with the mentor framework, the assessment informs which mentors to invoke:
- A writer at level 2 on "voice consistency" might benefit most from Le Guin (rhythm and music of language)
- A writer at level 2 on "showing vs. telling" might benefit most from King (trust the reader)
- A designer at level 2 on "framework application" might benefit most from Schell (lenses as analytical tools)

---

## Relationship to Other Capabilities

### Insight Feedback Loop
Insights often contain evidence relevant to craft dimensions. The insight "Writer defaults to internal monologue for emotional beats" is evidence for the "showing vs. telling" dimension. Insights and assessment should cross-reference.

### Session Hygiene
The session finish protocol should check for assessment-relevant evidence. If a session reviewed work, the companion should note any evidence that affects the assessment.

### Mentor Framework
Assessment dimensions map to mentor methodologies. The assessment helps the companion choose which mentor to invoke for maximum developmental impact.

### Reverse Prompting
Assessment-informed reverse prompting is more precise. Instead of generic "How do you feel about this scene?" the companion can ask dimension-specific questions: "The last scene used physical action for emotion — your showing-vs-telling is developing. This scene reverts. Was that intentional?"

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Assessment without evidence | Ratings based on guesses or self-report | Wait until enough work has been reviewed to have evidence |
| Too many dimensions | 15 dimensions means none get attention | Start with 4-6 core dimensions; extend only when needed |
| Level inflation | Upgrading levels too quickly on thin evidence | Require multiple pieces of evidence across sessions |
| Assessment as judgment | "You're at level 2, which is bad" | "Your showing-vs-telling is at level 2, which means [concrete description]. Here's what level 3 looks like." |
| Static assessment | Rating once and never updating | Recalibrate periodically with accumulated evidence |
| Ignoring dimension interactions | Treating dimensions as independent silos | Track and note when improvement in one dimension affects others |
| Assessment-driven sessions only | Every session forced to address the weakest dimension | Assessment informs but does not dictate — the user's creative energy matters more |
