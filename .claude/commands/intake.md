# /intake — New Project Reverse Prompting

Draw out project requirements through guided conversation. Discovers which persona and capabilities fit through conversation.

## Usage

```
/intake                           # Use current project — discover persona through conversation
/intake [client/project]          # Override for specific project
/intake [persona]                 # Start with a known persona for current project
/intake [persona] [client/project]   # Both persona and project
```

**Personas** accelerate intake with persona-specific questions. Available personas are in `companions/public/personas/` and `companions/private/[org]/personas/`.

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Determine the Project

1. If `$ARGUMENTS` contains a project path, use that
2. Otherwise, read `tracking/current-project.md` for the current project
3. If no project is set and no argument given, ask the user to set one first:
   ```
   No project set. Use /project to set or create one first:
     /project new [client/project]
   ```

4. Verify the project directory exists at `projects/[client]/[project]/`

**Determine the organization** from the client portion of the path (e.g., `consortium.team` from `consortium.team/my-project`). This is used to search for org-specific personas, capabilities, and library materials.

---

### Step 2: Check Existing Context

Read any existing context files in `projects/[client]/[project]/context/`:
- `requirements.md`
- `constraints.md`
- `decisions.md`

If context already exists, acknowledge it:
```
I see some context has already been captured for [project]:
- [summary of what exists]

We can continue from here, or start fresh. What would you prefer?
```

---

### Step 2b: Load Persona (if specified)

If `$ARGUMENTS` contains a persona name, search for it:

1. **Search for the persona** in both public and org-private directories:
   - `companions/public/personas/[persona]/PERSONA.md`
   - `companions/private/[org]/personas/[persona]/PERSONA.md`

2. **Read the persona's files:**
   - `PERSONA.md` — Identity, voice, key concepts
   - `intake-guide.md` — Persona-specific questions
   - `typical-capabilities.md` — Which capabilities this persona typically uses
   - `reference-projects.md` — What worked before (if exists)

3. **Note the persona in `context/decisions.md`:**
   ```markdown
   | Persona: [persona] | Loaded from companions/{public,private}/[org]/personas/[persona] | [date] |
   ```

4. Use the persona's intake questions **in addition to** the core questions below. Persona questions help reach known-good configurations faster.

**If no persona was specified,** proceed to Step 3 — the conversation will discover which persona fits (see Step 4b).

**Important:** Personas are accelerators, not constraints. They get you to a good starting point. The methodology ("start wrong, iterate to right") handles adaptation through usage.

---

### Step 3: Begin Reverse Prompting

**Your role:** Draw out what the user knows. Don't assume or generate requirements — extract them.

**Core principle:** Ask ONE question at a time. Let the answer inform the next question.

Start with:
```
Let's capture what this project is about. I'll ask questions one at a time.

What problem does [project] solve? Or put another way — why does this project need to exist?
```

---

### Step 4: The Question Sequence

Work through these areas, but **adapt based on answers**. Don't mechanically go through a checklist — let the conversation flow naturally while ensuring coverage.

**If a persona is loaded:** Weave the persona-specific questions from `intake-guide.md` into the flow below. Persona questions often provide better specificity for their domain. For example, a "writing-mentor" persona would ask about anchor types, mentors, and transformation levels — questions that the generic intake wouldn't know to ask.

**1. Purpose (start here)**
- What problem does this solve?
- Why does it matter? What happens if it doesn't get built?
- What's the "one thing" this project must do well?

**2. Users**
- Who will use this?
- What do they need that they don't have today?
- What's their current workaround?
- Are there different types of users with different needs?

**3. Success Criteria**
- How will you know it's working?
- What does "done" look like?
- What would make this a failure even if it "works"?

**4. Constraints**
- Technical constraints (language, platform, integrations)?
- Time constraints?
- Resource constraints?
- Organizational constraints (approvals, dependencies)?

**5. Context**
- Related systems or prior art?
- Existing patterns to follow or avoid?
- Domain knowledge needed?

**6. The Quality**
- What makes this project distinct from similar ones?
- What's the "feel" you're going for?
- If you had to explain this to someone in one sentence, what would you say?

---

### Step 4b: Suggest Persona Match (if no persona was specified)

After covering the core questions (especially Purpose, Users, and The Quality), suggest which persona fits best.

**Scan available personas:**

1. Read all PERSONA.md files from:
   - `companions/public/personas/*/PERSONA.md`
   - `companions/private/[org]/personas/*/PERSONA.md` (if org is known)

2. Compare the captured requirements against each persona's "When to Use" criteria.

3. Present the best match(es):
   ```
   Based on what you've described, this sounds like a **[persona name]** companion:
   [1-2 sentence summary of why this persona fits]

   This persona typically includes these capabilities:
   - [capability 1] — [brief description]
   - [capability 2] — [brief description]

   Does this feel right, or is this something different?
   ```

4. If the user confirms, load the persona's `intake-guide.md` and `typical-capabilities.md`, then ask the persona-specific questions that weren't already covered.

5. If the user says it's different, continue with generic intake and note that this may be a new persona pattern.

---

### Step 4c: Suggest Capabilities

After the persona is identified (or if no persona fits):

1. **Read the persona's `typical-capabilities.md`** for recommended capabilities.

2. **Scan available capabilities:**
   - `companions/public/capabilities/*/CAPABILITY.md`
   - `companions/private/[org]/capabilities/*/CAPABILITY.md` (if any exist)

3. **Suggest capabilities based on conversation:**
   ```
   For this companion, I'd recommend these capabilities:

   **Core (always included):**
   - Reverse Prompting — [why it fits]
   - Context Ecosystem — [why it fits]

   **Recommended based on what you've described:**
   - [Capability] — [why it fits, based on specific things the user said]

   **Available but probably not needed yet:**
   - [Capability] — [what it does, why it's not urgent]

   Which of these resonate? Anything you'd add or remove?
   ```

4. Record selected capabilities in `context/decisions.md`.

---

### Step 4d: Suggest Library Materials

If the organization has a library (`companions/private/[org]/library/`):

1. **Scan library entries:**
   - Read `metadata.yaml` files in `companions/private/[org]/library/**/metadata.yaml`

2. **Match by subject tags and persona relevance:**
   - Compare library entry `subjects` and `related_personas` against the companion being created

3. **Suggest relevant materials:**
   ```
   Your organization's library has materials that could be useful for this companion:

   - [Book Title] by [Author] — [how it's relevant to this companion]
   - [Book Title] by [Author] — [how it's relevant]

   Want to pull any of these into this companion's reference?
   ```

4. Record library selections in `context/decisions.md`.

**Note:** Library materials are contextualized for each companion during the build phase, not during intake. The selection here determines which materials to contextualize.

---

### Step 5: Push for Specificity

When answers are vague, push deeper:

| Vague | Push for |
|-------|----------|
| "Users need it to be fast" | "What's fast? Sub-second? What operations?" |
| "It should be easy to use" | "Easy for whom? What's hard about current options?" |
| "Various stakeholders" | "Name one. What do they specifically need?" |
| "Standard security" | "What data is sensitive? What's the threat model?" |

**Good answers are concrete.** "A developer who needs to..." beats "users." "Under 200ms response time" beats "fast."

---

### Step 6: Capture as You Go

After each major area is covered, write to the appropriate context file:

**`context/requirements.md`** — What the project must do
```markdown
# Requirements

## Purpose
[Why this exists, the problem it solves]

## Users
[Who uses it, what they need]

## Success Criteria
[How we know it's working]

## Core Functionality
[The must-haves]
```

**`context/constraints.md`** — Boundaries and limitations
```markdown
# Constraints

## Technical
[Platform, language, integration requirements]

## Timeline
[Deadlines, phases]

## Resources
[Team, budget, dependencies]

## Organizational
[Approvals, policies, external dependencies]
```

**`context/decisions.md`** — Choices made during intake
```markdown
# Decisions

Decisions made during project intake.

| Decision | Rationale | Date |
|----------|-----------|------|
| Persona: [name] | [why this persona fits] | [date] |
| Capabilities: [list] | [why these were selected] | [date] |
| Library materials: [list] | [why these are relevant] | [date] |
| [other decisions] | [why] | [when] |
```

---

### Step 7: Summarize and Confirm

After covering the key areas:

1. **Summarize** what was captured (brief bullet points)
2. **Identify gaps** — what's still unclear or missing?
3. **Confirm** with the user:
   ```
   Here's what I've captured:

   **Purpose:** [one sentence]
   **Users:** [who]
   **Success looks like:** [criteria]
   **Key constraints:** [list]
   **What makes it distinct:** [the quality]

   **Companion composition:**
   - Persona: [name or "custom"]
   - Capabilities: [list]
   - Library materials: [list or "none"]

   Gaps remaining:
   - [what's still unclear]

   Does this capture it accurately? Anything to add or correct?
   ```

4. **Write final versions** of context files after confirmation

---

### Step 8: Suggest Next Steps

```
Context captured for [project].

Next steps:
  /process   — Feed in any existing documents or transcripts
  /gaps      — See full assessment of what's captured vs. needed
  /checkpoint — Save session state before ending
```

---

## Principles

- **One question at a time** — Don't overwhelm
- **Listen more than talk** — Your job is to extract, not generate
- **Push for concrete** — Vague requirements become vague projects
- **It's okay to not know** — "Not sure yet" is valuable information
- **Capture decisions** — Why something was decided matters as much as what
- **The quality matters** — What makes this distinct is often the key insight
- **Discover, don't prescribe** — Let the conversation reveal which persona and capabilities fit, rather than forcing a pre-selected type
