# /process — Handle External Inputs

Extract structured information from transcripts, documents, or notes.

## Usage

```
/process                     # Prompts for input, uses current companion
/process [client/companion]    # Override companion, then prompts for input
```

After invoking, paste text or provide a file path when prompted.

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Determine the Companion

1. If `$ARGUMENTS` contains a project path, use that
2. Otherwise, read `tracking/current-companion.md` for the current companion
3. If no companion is set:
   ```
   No companion set. Use /companion to set or create one first.
   ```

---

### Step 2: Get the Input

If no content was provided with the command:

```
Ready to process input for [companion].

You can:
1. Paste text directly (transcript, notes, etc.)
2. Provide a file path to read

What would you like me to process?
```

**If file path provided:** Read the file and use its contents
**If text pasted:** Use the pasted text directly

---

### Step 3: Analyze the Input

Read through the input and extract:

**Requirements** — Things the companion must do
- Explicit statements: "it needs to...", "we want...", "must have..."
- Implicit needs revealed by problems described
- User stories or use cases mentioned

**Constraints** — Boundaries and limitations
- Technical: "we're using...", "has to integrate with..."
- Timeline: "by Q2", "before launch"
- Resources: "small team", "limited budget"
- Organizational: "needs approval from...", "compliance requires..."

**Decisions** — Choices that were made or implied
- "We decided to...", "we're going with..."
- Trade-offs discussed and resolved
- Approaches rejected and why

**Questions** — Things that need clarification
- Ambiguous statements
- Conflicting requirements
- Missing information
- Assumptions that should be validated

**Context** — Background that helps understand the companion
- Domain knowledge
- Related systems
- User personas
- Historical context

---

### Step 4: Present Extraction

Show what was extracted before writing:

```
## Extracted from Input

### Requirements Found
- [requirement 1]
- [requirement 2]
- ...

### Constraints Identified
- [constraint 1]
- [constraint 2]
- ...

### Decisions Captured
- [decision 1] — [rationale if stated]
- [decision 2]
- ...

### Questions Raised
- [question 1] — needs clarification
- [question 2] — conflicting with [what]
- ...

### Context Notes
- [context 1]
- [context 2]
- ...

---

Does this capture what's important? Anything I missed or misinterpreted?
```

---

### Step 5: Clarify Questions (Optional)

If there are questions or ambiguities:

```
I flagged [N] items that need clarification. Would you like to address them now?

1. [Question 1]
2. [Question 2]
...

We can clarify now, or save them as open questions for later.
```

If user wants to clarify, ask **one question at a time** and capture the answers.

---

### Step 6: Update Context Files

After confirmation, update the companion's context files:

**`context/requirements.md`**
- Append new requirements under a dated section:
  ```markdown
  ## From [input source] — [date]

  - [new requirement]
  - [new requirement]
  ```

**`context/constraints.md`**
- Append new constraints similarly

**`context/decisions.md`**
- Add rows to the decisions table:
  ```markdown
  | [decision] | [rationale] | [date] |
  ```

**`context/questions.md`** (create if needed)
- Open questions that need answers:
  ```markdown
  # Open Questions

  | Question | Source | Status |
  |----------|--------|--------|
  | [question] | [where it came from] | open |
  ```

---

### Step 7: Summarize

```
## Processed: [brief description of input]

**Added to [companion]:**
- [N] requirements
- [N] constraints
- [N] decisions
- [N] open questions

**Files updated:**
- context/requirements.md
- context/constraints.md
- context/decisions.md
- context/questions.md

**Next steps:**
  /process   — Feed in more documents
  /gaps      — See what's still missing
  /intake    — Fill gaps through conversation
  /checkpoint — Save session state
```

---

## Extraction Guidelines

### Be Conservative
- Only extract what's clearly stated or strongly implied
- Don't invent requirements that weren't mentioned
- Flag ambiguity rather than guessing

### Preserve Source
- Note where each item came from
- Keep original language when it's precise
- Paraphrase only for clarity

### Identify Conflicts
- If new input conflicts with existing context, flag it
- Don't silently override previous decisions
- Present conflicts for user resolution

### Questions Are Valuable
- Unclear input is a signal, not a failure
- Capturing questions prevents false assumptions
- Open questions guide future `/intake` sessions
