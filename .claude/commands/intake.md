# /intake — New Project Reverse Prompting

Draw out project requirements through guided conversation.

## Usage

```
/intake                     # Use current project
/intake [client/project]    # Override for specific project
```

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
| [what was decided] | [why] | [when] |
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
