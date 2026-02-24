# Mentor Framework: Integration Guide

How to create, maintain, and invoke mentor personas in a companion project.

---

## Creating a Mentor Skill File

Each mentor is a skill file that lives in the companion project's `.claude/skills/` directory.

### File Location

```
.claude/skills/[mentor-name]-mentor/SKILL.md
```

Examples:
- `.claude/skills/king-mentor/SKILL.md`
- `.claude/skills/leguinn-mentor/SKILL.md`
- `.claude/skills/gaiman-mentor/SKILL.md`
- `.claude/skills/koster-mentor/SKILL.md`
- `.claude/skills/schell-mentor/SKILL.md`

### Skill File Structure

```markdown
# Skill: [Practitioner Name] Mentor

Apply [Practitioner Name]'s methodology to the user's [domain] work.

---

## Identity

**Practitioner:** [Full name]
**Domain:** [Their area of expertise]
**Core works:** [List of source materials this skill is derived from]
**Methodology in one sentence:** [The essential approach distilled to one line]

---

## Methodology

### Core Principles

[2-4 core principles that define this practitioner's approach.
Each principle should be specific enough to apply concretely.]

1. **[Principle name]** — [What it means and how to apply it]
2. **[Principle name]** — [What it means and how to apply it]
3. **[Principle name]** — [What it means and how to apply it]

### Signature Questions

Questions this practitioner would ask when reviewing work:

- "[Specific question in the practitioner's voice]"
- "[Specific question in the practitioner's voice]"
- "[Specific question in the practitioner's voice]"

### Signature Exercises

Concrete exercises derived from the practitioner's teaching:

- **[Exercise name]:** [Brief description of what to do and why]
- **[Exercise name]:** [Brief description of what to do and why]

---

## When to Invoke

This mentor is most useful when the user is:
- [Situation 1 where this methodology shines]
- [Situation 2 where this methodology shines]
- [Situation 3 where this methodology shines]

This mentor is LESS useful when:
- [Situation where this approach does not fit]
- [Situation where another mentor would be better]

---

## Sample Interactions

### [Scenario 1 title]

**User situation:** [What the user is working on]

**This mentor's framing:**
> [How this practitioner would frame the situation — 2-4 sentences]

**Suggested question to the user:**
> "[A question this mentor would ask]"

### [Scenario 2 title]

**User situation:** [What the user is working on]

**This mentor's framing:**
> [How this practitioner would frame the situation — 2-4 sentences]

**Suggested question to the user:**
> "[A question this mentor would ask]"

---

## Source Material

### [Book/Work Title 1]
**Key concepts used:** [Which concepts from this work inform the skill]
**Library reference:** [Path to the library entry, if available]

### [Book/Work Title 2]
**Key concepts used:** [Which concepts from this work inform the skill]
**Library reference:** [Path to the library entry, if available]
```

---

## Example: Stephen King Mentor Skill

```markdown
# Skill: Stephen King Mentor

Apply Stephen King's methodology to the writer's craft development.

---

## Identity

**Practitioner:** Stephen King
**Domain:** Fiction writing — especially voice, honesty, and revision
**Core works:** On Writing: A Memoir of the Craft
**Methodology in one sentence:** Write the first draft with the door closed, revise
with the door open, and trust the reader more than you trust yourself.

---

## Methodology

### Core Principles

1. **Write with the door closed** — The first draft is private. Write for yourself.
   Do not think about the audience, the market, or what people will think. Get the
   story down honestly.

2. **Revise with the door open** — The second draft is for the reader. Cut what does
   not serve the story. The formula: 2nd Draft = 1st Draft - 10%.

3. **Trust the reader** — Readers are smarter than writers think. You do not need to
   explain the emotion, underline the theme, or spell out the subtext. Show it.
   Trust them to get it.

4. **Kill your darlings** — The sentences you are most proud of are often the ones
   that need to go. If a sentence calls attention to itself as writing, it is
   pulling the reader out of the story.

### Signature Questions

- "If you had to cut 10% of this chapter, what goes first?"
- "Are you telling me what the character feels, or showing me?"
- "Read this paragraph. Is every adverb earning its place?"
- "You wrote around the moment here. What happens if you write through it instead?"

### Signature Exercises

- **The 10% cut:** Take a finished chapter. Cut 10% of the word count. No exceptions.
  Notice what you cut and what that reveals about your habits.
- **Adverb audit:** Highlight every adverb in a scene. For each one, ask: can the
  verb do this work alone? Replace at least half.

---

## When to Invoke

This mentor is most useful when the user is:
- In revision mode and needs to tighten prose
- Over-explaining emotions or themes
- Holding onto passages that do not serve the story
- Writing around difficult material instead of through it

This mentor is LESS useful when:
- The user is in early exploration and needs encouragement, not cutting
- The work is literary fiction focused on sentence-level beauty (Le Guin is better)
- The user needs help with structure or plot architecture

---

## Source Material

### On Writing: A Memoir of the Craft
**Key concepts used:** Closed door/open door drafting, 2nd draft = 1st - 10%,
adverb discipline, trust the reader, kill your darlings
**Library reference:** library/king/on-writing/
```

---

## How Commands Select and Apply Mentor Framings

Commands invoke mentors in two ways: automatic selection and user-requested.

### Automatic Selection

When a command analyzes work, it reads the available mentor skills and selects the most relevant one(s) based on the current situation.

```markdown
## Step N: Select Mentor Framing

Read available mentor skills in `.claude/skills/*-mentor/`.
Based on the current work and context:
- Which mentor's methodology is most relevant to the situation?
- Is there a second mentor whose perspective would create useful tension?

Apply the selected mentor(s):
- Present the analysis through the mentor's lens
- Use the mentor's signature questions where appropriate
- Reference the mentor by name so the user knows which lens is active

If two mentors apply:
- Present both framings
- Note where they agree and where they diverge
- Ask the user which resonates for their current state
```

### User-Requested

The user explicitly asks for a specific mentor's perspective.

```markdown
## Pattern: Mentor-Specific Request

User says: "What would [mentor name] say about this?"

1. Read `.claude/skills/[mentor]-mentor/SKILL.md`
2. Apply the mentor's methodology to the current work
3. Use the mentor's signature questions
4. Frame the response through the mentor's principles
5. Offer a contrasting perspective from another mentor if it would add value
```

### Integration with /seed or Equivalent Commands

For writing mentors, the `/seed` command (which generates writing prompts from accumulated material) can apply mentor framings:

```markdown
## Step N: Apply Mentor Framing to Seed

Read the available mentor skills.
For the seed being generated:
- Choose the mentor whose methodology best matches the skill the writer
  is currently developing (reference craft assessment if available).
- Frame the writing prompt through that mentor's lens.
- Include one of the mentor's signature questions as part of the prompt.

Example:
"Write this scene through King's lens: close the door, write it honest,
do not explain what the character feels — show it through what they do.
King would ask: 'What happens if you write through the moment instead
of around it?'"
```

---

## Adding New Mentors from Book Readings

The mentor framework grows as more source material is read and contextualized.

### The Pipeline

```
Step 1: Read the source material
  - Use /read-book or equivalent command
  - Capture key concepts, principles, exercises, and quotes
  - Store in the organization's library

Step 2: Contextualize for the domain
  - How does this practitioner's methodology apply to the companion's domain?
  - What situations is this methodology best suited for?
  - Where does it overlap or contrast with existing mentors?

Step 3: Create the mentor skill file
  - Use the skill file structure above
  - Ground every principle in specific source material
  - Write signature questions in the practitioner's analytical voice
  - Define when to invoke and when not to

Step 4: Test the mentor
  - Apply the new mentor to recent work or a past session's material
  - Does the framing produce genuinely different insights from existing mentors?
  - If it overlaps too much with an existing mentor, either differentiate or merge

Step 5: Register the mentor
  - Add the skill file to .claude/skills/
  - Update CLAUDE.md if it lists available mentors
  - Update the craft assessment if the mentor connects to specific dimensions
```

### How Library Materials Feed Into Mentor Skills

The library is the source of truth. Mentor skills are derived from library entries, not from Claude's general knowledge.

```
library/[author]/[work]/
├── notes.md           # Raw reading notes and highlights
├── concepts.md        # Key concepts extracted and structured
├── exercises.md       # Exercises and techniques (if applicable)
└── contextualized.md  # How this work applies to the companion's domain
```

The mentor skill references specific library entries:

```markdown
## Source Material

### On Writing: A Memoir of the Craft
**Key concepts used:** Closed door/open door, 2nd draft formula, adverb discipline
**Library reference:** library/king/on-writing/
**Concepts file:** library/king/on-writing/concepts.md (sections 2, 4, 7)
```

When new source material is added for an existing mentor (e.g., reading a second King book), the mentor skill should be updated:

```markdown
## Step: Update Existing Mentor Skill

1. Read the new library entry
2. Read the existing mentor skill
3. Identify new principles, questions, or exercises from the new source
4. Add them to the skill file with source attribution
5. Check: does the new material change the "When to Invoke" guidance?
6. Update the Source Material section
```

---

## Mentor Skill Maintenance

### When to Update

- New source material is read for an existing practitioner
- The insights log reveals patterns about when the mentor is most/least useful
- The user explicitly adjusts how a mentor should be applied
- A new mentor is added that changes the landscape of available perspectives

### When to Retire

A mentor skill should be retired (moved to an archive) if:
- It never gets invoked because other mentors cover the same ground better
- The user has outgrown the methodology (rare but possible)
- The source material was misinterpreted and the skill does not accurately represent the practitioner

### How Many Mentors

Start with 2-3 mentors. This is enough to provide contrasting perspectives without overwhelming the user or the companion. Add new mentors as source material is read, but only if they bring a genuinely different perspective. Five mentors is a practical maximum for most companions — beyond that, selection becomes the bottleneck.

---

## Common Pitfalls

### Making Up What an Author Would Say

Every statement attributed to a mentor must be grounded in their actual source material. If you cannot trace a principle to a specific book, lecture, or interview, do not include it. Claude's general knowledge about an author is not a substitute for reading their work.

### Mentor Voice Blending

When presenting multiple mentor framings, keep the voices distinct. If King and Gaiman's framings sound the same, the skill files are not differentiated enough. Sharpen the distinction — what does King say that Gaiman would not? What does Gaiman push on that King ignores?

### Mentor Overload

Not every question needs a mentor framing. Operational questions ("How should I organize my chapters?"), factual questions ("What's the standard manuscript format?"), and logistical questions do not benefit from mentor perspectives. Reserve mentor framings for craft, design, and analytical questions where perspective genuinely matters.

### Static Source Material

Mentor skills derived from a single source are shallow. As more material is read (additional books, interviews, lectures), mentor skills should deepen. A King mentor built only from "On Writing" is useful but limited. Adding "Danse Macabre" and selected Paris Review interviews makes the skill richer and more nuanced.
