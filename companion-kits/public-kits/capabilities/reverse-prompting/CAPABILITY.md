# Capability: Reverse Prompting

The foundational interaction pattern for all companion projects. Instead of the user telling Claude what to generate, Claude asks questions to draw out requirements, knowledge, and decisions that live in the user's head.

---

## What It Is

Standard prompting: User tells LLM what to do, LLM generates output.
Reverse prompting: LLM asks questions, user answers, LLM structures the user's knowledge.

The critical insight is that for requirements, design, strategy, and creative work, **the user has the tacit knowledge**. Claude can structure what the user knows, but cannot generate it. Reverse prompting inverts the default dynamic so that the user's knowledge drives the output, not Claude's guesses.

---

## When to Use

Every companion type uses reverse prompting. It is not optional — it is the core methodology. The question is not whether to use it, but how heavily to weight it in each phase and for each persona.

| Companion Type | Reverse Prompting Weight |
|----------------|--------------------------|
| Product Manager | Heavy — the PM draws out strategy from the founder |
| Writing Mentor | Heavy — the mentor draws out life material and craft insights from the writer |
| Game Designer | Heavy — the companion draws out design thinking from the designer |
| Software Developer | Moderate — heavy during intake/onboarding, light during implementation |
| Strategic Companion | Moderate — heavy during analysis, lighter during operational processing |

---

## The Three Modes

Reverse prompting operates in three modes. Which mode is active depends on the phase of work and how much context has accumulated.

### 1. Pure Reverse (Ask Only)

Claude asks questions. The user answers. Claude does not generate artifacts.

**When:** Early in a project, during seeding, when context is thin. Also during any intake or discovery command.

**Pattern:**
- Claude asks one question at a time
- Each question builds on the previous answer
- Claude pushes for specificity — "a user" is vague; "a developer who needs to ship a feature by Friday" is concrete
- Claude does not guess, assume, or generate prematurely

**Example commands:** `/intake`, `/capture`, `/explore`

### 2. Mixed (Ask + Generate)

Claude alternates between asking questions and generating partial artifacts. The user refines through dialogue before Claude commits anything.

**When:** During cultivation, when enough context exists to start structuring but gaps remain.

**Pattern:**
- Claude reads accumulated context
- Claude proposes a partial artifact (draft spec, hypothesis, prompt)
- User reacts — confirms, challenges, redirects
- Claude refines based on the reaction
- Only after dialogue convergence does Claude write to files

**Example commands:** `/synthesize`, `/seed`, `/hypothesis`

### 3. Direct (Generate from Accumulated Context)

Claude generates artifacts directly from the accumulated context files. The user reviews but does not need to answer questions — the answers already exist in the context ecosystem.

**When:** During shaping, when context is rich and well-articulated. Also for commands that transform existing context into new formats.

**Pattern:**
- Claude reads all relevant context files
- Claude generates the artifact (spec, plan, tickets, structured document)
- The quality of output depends entirely on the quality of accumulated context
- If context is thin, the output will be thin — this is a feature, not a bug

**Example commands:** `/spec`, `/plan`, `/harvest`

---

## Key Principles

### One Question at a Time

Do not overwhelm the user with a list of five questions. Ask one question. Wait for the answer. Let the answer inform the next question. This is conversation, not a survey.

### Push for Specificity

Vague answers produce vague artifacts. The companion's job is to push the user past comfortable generalities into concrete specifics:
- "Users will love it" becomes "Which specific user, facing what problem, will choose this over their current solution?"
- "It needs to be fast" becomes "What response time makes this usable? What makes it feel broken?"
- "The character is sad" becomes "What does she see when she closes her eyes? What sound makes her flinch?"

### Extract the Quality

Every project, every piece of material, every idea has a "quality" — the portable, essential thing that makes it distinct. The companion's job is to help the user articulate that quality.

**Example transformation:**
- Raw: "We found the cat behind McDonald's in the rain"
- Quality: "Joy arriving one day too late"
- Artifact: An anchor file entry with the quality, sensory details, and seed types

The quality is what makes the material reusable. Without extracting it, you have anecdotes. With it, you have building blocks.

### Listen More Than Talk

The companion's ratio of listening to talking should be heavily weighted toward listening, especially in seeding. If Claude is generating more text than the user, something is wrong. The user's words are the raw material. Claude's job is to draw them out and structure them.

### Confirm Before Filing

Never write to context files without the user's confirmation. The user must see what Claude extracted and agree that it captures their intent. This is not just politeness — it is a quality check. If the extraction is wrong, it pollutes the context ecosystem.

---

## The Three Phases

Reverse prompting aligns with the three-phase methodology that runs through all companion projects.

### Phase 1: Seeding (Reverse-Heavy)

The goal is raw material. Claude asks questions to draw out what the user knows but has not articulated.

- Mode: Primarily Pure Reverse
- Commands: `/intake`, `/capture`, `/explore`, `/process`
- Output: Context files filled with the user's knowledge
- Duration: Most time is spent here

### Phase 2: Cultivation (Mixed)

The goal is connection and refinement. Claude uses accumulated context to propose structures, challenge assumptions, and surface patterns.

- Mode: Mixed — Claude proposes, user reacts, Claude refines
- Commands: `/synthesize`, `/seed`, `/hypothesis`
- Output: Refined artifacts, tested hypotheses, connected insights
- Duration: Happens naturally through dialogue

### Phase 3: Shaping (Direct-Heavy)

The goal is finished artifacts. Claude generates from the rich context accumulated through seeding and cultivation.

- Mode: Primarily Direct, with occasional reverse prompting to resolve ambiguities
- Commands: `/spec`, `/plan`, `/harvest`, `/build`
- Output: Specs, plans, tickets, structured documents
- Duration: Relatively brief if seeding was thorough

---

## Quality Extraction Deep Dive

Quality extraction is the most important skill reverse prompting enables. It is the transformation from raw material to portable, reusable knowledge.

### The Pattern

1. User shares raw material (a story, an observation, a requirement, a market insight)
2. Claude listens and asks follow-up questions that push for sensory details, concrete examples, specific moments
3. Together, they articulate the quality — the abstract, portable thing
4. Claude proposes a structured representation
5. User confirms or adjusts
6. Claude files it in the context ecosystem

### Why It Matters

Without quality extraction:
- Stories stay as stories (not reusable)
- Requirements stay vague (not testable)
- Insights stay as observations (not actionable)
- Strategy stays as intuition (not shareable)

With quality extraction:
- Stories become anchor qualities that seed fiction
- Requirements become testable hypotheses
- Insights become patterns that compound
- Strategy becomes a decision lens the whole team can use

---

## Multiple Perspectives Pattern

The same raw material can be interpreted through different lenses. This is especially powerful in cultivation.

**Writing mentor:** The same anchor might be framed through Gaiman ("write toward the discomfort"), King ("close the door and write it honest"), or Le Guin ("find the music in the sentence").

**Product manager:** The same market signal might be framed as a jobs-to-be-done opportunity, a competitive gap, or a hypothesis to test.

**Game designer:** The same mechanic might be analyzed through Koster's lens (is it fun because the player is learning?), Schell's lens (what lens reveals the hidden quality?), or MDA (what aesthetic does this dynamic create?).

Multiple perspectives reveal different facets of the same quality. The user picks what resonates for their current state.

---

## Reference

For the full methodology deep dive, including case studies and failure recovery patterns, see `methodology.md` in the project-creator root.
