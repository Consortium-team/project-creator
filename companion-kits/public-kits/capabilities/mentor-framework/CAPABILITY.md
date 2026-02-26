# Capability: Mentor Framework

Named mentor personas based on real authors, teachers, and practitioners that provide different analytical framings for the same question.

---

## What It Is

The mentor framework creates named personas — each encoding a specific teaching methodology derived from real-world practitioners — that the companion can invoke to provide different perspectives on the user's work.

The key insight: the same question asked through different lenses produces different answers, and those differences are where learning happens. A writing mentor might frame a dialogue problem through Stephen King's methodology (write it honest, close the door, trust the reader) or through Ursula K. Le Guin's (find the music in the sentence, rhythm reveals character). Neither is "right" — each reveals something different about the work.

This is not role-playing. Each mentor is a structured skill file that encodes:
- A specific methodology distilled from the practitioner's body of work
- When that methodology is most useful
- How to apply it concretely
- What questions the practitioner would ask

---

## The Pattern

Each mentor is a skill file that lives in the companion project. The companion reads the relevant mentor skill when a particular framing is needed, then applies that methodology to the user's current situation.

### How It Works

1. **Source material** is read and contextualized (books, lectures, interviews, exercises) — typically through a `/read-book` command that captures key concepts into an organization's library.
2. **Mentor skills** are created from the source material — distilling a practitioner's methodology into a structured format that Claude can apply.
3. **Commands invoke mentors** when different framings would be valuable — either automatically (the command selects the most relevant mentor) or by user request.
4. **Multiple framings** for the same situation let the user see their work from different angles and choose what resonates.

### Example: Writing Mentor

A writing mentor companion might have three mentor skills:

**Stephen King mentor** (from "On Writing"):
> "Close the door and write the first draft for yourself. Open the door and rewrite for everyone else. The first draft is about getting it down. The second draft is about making it clear. Trust the reader — they're smarter than you think."

**Ursula K. Le Guin mentor** (from "Steering the Craft"):
> "Find the music in the sentence. Read it aloud. Does it have rhythm? Rhythm is not decoration — it is meaning. A sentence with the wrong rhythm says the wrong thing even if the words are right."

**Neil Gaiman mentor** (from lectures and "The View from the Cheap Seats"):
> "Write toward the thing that scares you. If a scene is easy to write, it might be because you're avoiding the real version. The uncomfortable version is usually the true version."

When the writer shares a draft scene, the companion might offer:
> "Let me give you three framings on this scene:
> - **King** would say: You're overwriting. Cut the adverbs and trust the reader to feel what the character feels.
> - **Le Guin** would say: Read the last paragraph aloud. The rhythm is wrong — the long sentence in the middle breaks the tension you built.
> - **Gaiman** would say: You wrote around the moment. The character reaches the door but you cut away. What happens when they open it? Write that scene — the one you're avoiding."

---

## When to Use

| Companion Type | Mentor Framework Role | Weight |
|----------------|----------------------|--------|
| Writing Mentor | Primary — multiple author mentors for craft development | Core |
| Game Designer | Supporting — design authors (Koster, Schell, Fullerton) as design lenses | Common |
| Product Manager | Occasional — business thinkers as strategy lenses | Light |
| Software Developer | Rare — unless the team values specific engineering methodologies | Minimal |

### Primary Use: Writing Companions

Writing is the natural home for the mentor framework. Every notable author has a distinct methodology that can be distilled into a skill file. Writers benefit enormously from seeing their work through multiple craft lenses.

### Supporting Use: Game Design Companions

Game design has its own canon of practitioners — Raph Koster (Theory of Fun), Jesse Schell (The Art of Game Design), Tracy Fullerton (Game Design Workshop). Each provides a different analytical framework for the same design problem.

### Potential Use: Any Domain with Notable Teachers

Any domain where practitioners have articulated teachable methodologies is a candidate: business strategy (Christensen, Ries, Rumelt), product management (Cagan, Torres), architecture (Alexander, Brand). The framework is domain-agnostic — only the mentor skills are domain-specific.

---

## Mentor Sources

Mentors are derived from real practitioners through their published work.

### Source Types

| Source | Quality | Example |
|--------|---------|---------|
| Books | Highest — sustained, structured thinking | King's "On Writing," Le Guin's "Steering the Craft" |
| Lectures and talks | High — distilled principles, often more accessible | Gaiman's "Make Good Art" commencement speech |
| Interviews | Medium — reveals process and thinking, but fragmented | Paris Review interviews with authors |
| Writing exercises | High — methodology made concrete | Le Guin's exercises in "Steering the Craft" |
| Collected essays | Medium-high — principles articulated across multiple pieces | Gaiman's "The View from the Cheap Seats" |

### The Library Pipeline

Source materials are read and captured into the organization's library, then distilled into mentor skills:

```
Source material (book, lecture)
    |
    v
/read-book command → Library entry (contextualized notes)
    |
    v
Mentor skill creation → .claude/skills/[mentor]-mentor/SKILL.md
    |
    v
Companion commands invoke mentor skills as needed
```

---

## Key Principle: Perspective, Not Prescription

Mentors provide perspective, not prescription. The user is always the decision-maker.

**Wrong approach:**
> "King says you should cut this paragraph. Remove it."

**Right approach:**
> "King would challenge this paragraph — he'd say the adverbs are doing work the verbs should do. Le Guin would keep it but rewrite it for rhythm — the long clause breaks the sentence music. Which framing resonates with what you're trying to do here?"

Multiple framings give the user agency. They choose which lens reveals something useful for their current state. A writer in early draft mode might respond to Gaiman ("write toward the discomfort"). The same writer in revision mode might respond to King ("kill your darlings") or Le Guin ("find the music").

The companion should never dictate which mentor is "right." The companion presents, the user decides.

---

## Relationship to Other Capabilities

### Reverse Prompting
Mentors enhance reverse prompting by providing specific lenses for questions. Instead of generic "What do you think about this scene?" the companion can ask mentor-specific questions: "King would ask: If you had to cut 10% of this scene, what goes first and why?"

### Insight Feedback Loop
Over time, the insights log will reveal which mentors resonate most with the user and in which contexts. This is meta-insight: "The writer consistently responds to Le Guin framings for dialogue but King framings for pacing." This informs which mentors to invoke by default.

### Craft Assessment
Mentors connect to craft dimensions. A writer developing their voice might benefit most from Le Guin. A writer working on emotional honesty might benefit most from Gaiman. The craft assessment (which tracks development across dimensions) can inform which mentors to emphasize.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Mentor as impersonation | Claude "becomes" the author — weird and inaccurate | Claude applies the methodology, does not pretend to be the person |
| Single mentor only | Only one perspective offered — no choice, no tension | Always offer at least two framings when the situation warrants |
| Prescriptive mentoring | "King says do X, so do X" | Present perspectives, let the user choose |
| Unsourced mentor methodology | Making up what an author would say | Every mentor skill must be grounded in actual source material |
| Mentor for everything | Applying mentor framings to operational questions | Mentors are for craft and design questions, not file management |
| Static mentors | Mentor skills never updated as more source material is read | Update mentor skills when new source material deepens understanding |
