# /contextualize — Generate Companion-Specific Reference from Library Notes

Take existing companion-neutral library notes and generate a reference file tailored to a specific companion — without re-reading the book.

## Usage

```
/contextualize [book-search-term]                    # Search org library, use current companion
/contextualize [book-search-term] [client/companion]  # Override companion
```

**Examples:**
```
/contextualize king                                   # Finds king-on-writing in library
/contextualize story-structure                        # Matches by subject tag
/contextualize king consortium.team/writing-companion # Override companion
```

## Argument: $ARGUMENTS

---

## Instructions

### Step 0: Determine Companion and Organization

1. Parse `$ARGUMENTS`:
   - Last argument may be a companion path (contains `/`) — if so, use it as the companion
   - Remaining arguments are the book search term
2. If no companion path in arguments, read `tracking/current-companion.md` for the current companion
3. If no companion is set:
   ```
   No companion set. Use /companion to set or create one first.
   ```
4. Derive the organization from the client portion of the companion path (e.g., `consortium.team` from `consortium.team/writing-companion`)
5. Set `library_dir` = `companion-kits/private-kits/[org]-companion-kit/library/`
6. Set `companion_dir` = `companions/[client]/[companion]/`

**Declare collected values:**
```
Step 0 Complete. Collected values:
- Companion: [client/companion]
- Companion dir: [absolute path]
- Organization: [org]
- Library dir: [absolute path]
- Search term: [book-search-term]
```

---

### Step 1: Find the Library Book

1. Scan all `metadata.yaml` files in `[library_dir]/**/metadata.yaml`
2. For each metadata file, match the search term against:
   - Directory name (e.g., `king-on-writing`)
   - `title` field
   - `author` field
   - `subjects` array entries
3. Matching is case-insensitive and partial (e.g., "king" matches "Stephen King")

**Handle results:**

- **No matches:**
  ```
  No books matching "[search-term]" found in the [org] library.

  Available books:
  - [title] by [author] ([directory-name]) — [status]
  - ...

  Try a different search term.
  ```

- **Multiple matches:**
  ```
  Multiple books match "[search-term]":

  1. [title] by [author] — [status]
  2. [title] by [author] — [status]

  Which one?
  ```
  Wait for user to choose.

- **Single match:** Proceed to Step 2.

**Declare collected values:**
```
Step 1 Complete. Found book:
- Title: [title]
- Author: [author]
- Directory: [path]
- Status: [status]
- Subjects: [subjects]
```

---

### Step 2: Validate Book Status

Read the `metadata.yaml` for the matched book and check the `status` field:

- **`complete`** — Proceed to Step 3
- **`in-progress`** — Warn the user, then proceed:
  ```
  Note: This book's library notes are still in progress. Contextualizing what's available so far.
  ```
- **`needs-decontextualization`** — Block:
  ```
  This book's notes.md needs to be populated first. The library entry exists but
  the notes haven't been written yet.

  Use /read-book --library [org] to read and annotate this book first.
  ```
- **`not-yet-read`** — Block:
  ```
  This book hasn't been read yet.

  Use /read-book --library [org] [kindle-url] to read it first.
  ```

Also verify `notes.md` exists in the book's library directory and has substantive content (more than just a header/placeholder). If notes.md is missing or empty:
```
The library entry for this book exists but notes.md is missing or empty.
Use /read-book --library [org] to populate it first.
```

---

### Step 3: Load Companion Context

Read the following files from the companion directory:

1. `[companion_dir]/context/requirements.md`
2. `[companion_dir]/context/decisions.md`
3. `[companion_dir]/context/constraints.md`
4. `[companion_dir]/CLAUDE.md`

Extract and summarize:
- **Companion purpose** — What is this companion for?
- **Persona** — What persona does it use? What's its voice?
- **User profile** — Who uses this companion?
- **Key themes** — What topics/frameworks matter most?

Report what was loaded:
```
Step 3 Complete. Companion context loaded:
- Purpose: [brief summary]
- Persona: [persona name and key traits]
- User: [who the companion serves]
- Key themes: [list of themes/frameworks]
- Files read: [list of files successfully read]
- Files missing: [any context files not found]
```

---

### Step 4: Check for Existing Reference File

1. Search `[companion_dir]/reference/` for any file that appears to be a contextualization of this book
   - Match by author name, book title, or presence of the book's metadata in the file header
2. **If found with progress marker** (contains "Contextualization paused"):
   - Read the file to find where it left off
   - Report: "Found existing contextualization, paused at [chapter]. Resuming from there."
   - Skip to Step 6, starting from the next unprocessed chapter
3. **If found with completion marker** (contains "Contextualization complete"):
   ```
   A contextualized reference for this book already exists:
   [file path]

   Options:
   1. View the existing file
   2. Re-contextualize (overwrite)
   3. Cancel

   What would you like to do?
   ```
   Wait for user response.
4. **If not found** — Proceed to Step 5

---

### Step 5: Create the Reference File

1. Suggest filename: `[author-lastname]-[short-title]-companion-notes.md`
   - Confirm with user or let them override
2. Create the file in `[companion_dir]/reference/` with this header:

```markdown
# [Book Title] — Companion Reference

**Source:** [Author], *[Book Title]* (from [org] library)
**Library location:** [relative path to library book directory]
**Companion:** [companion name/purpose from Step 3]
**Purpose:** Concepts from this book filtered and reframed for this companion's specific needs
**Method:** Chapter-by-chapter contextualization from library notes.md

---
```

3. Create the `[companion_dir]/reference/` directory if it doesn't exist

---

### Step 6: Contextualize Chapter by Chapter

**This is the core loop. Process one chapter at a time.**

Read the library `notes.md` and identify all chapters.

**For each chapter:**

1. **Read the chapter's notes** from the library `notes.md`
2. **Filter:** For each concept/framework in the chapter, evaluate:
   - Is this relevant to this companion's purpose?
   - Is this relevant to this companion's users?
   - Does this connect to any of the companion's key themes?
3. **Rewrite relevant concepts** with companion-specific applicability:
   - How does this concept apply to what this companion does?
   - When would this companion invoke this concept?
   - What specific guidance does this give?
4. **Write the chapter section** to the reference file in this format:

```markdown
## Chapter [N] | [Chapter Title]

### Key Insights for [Companion Name]

1. **[Concept/Framework name]** — [Rewritten description focused on this companion's needs]

   **Application:** [Specific guidance for how/when this companion should use this concept]

2. **[Concept/Framework name]** — [Description]

   **Application:** [Guidance]

### Not Applicable from This Chapter

- **[Concept name]** — [Brief note on why it was filtered out for this companion]
- **[Concept name]** — [Why not applicable]

---
```

5. **Update progress marker** at the bottom of the reference file:
   ```
   *Contextualization paused after Chapter [N]: [Chapter Title]. [M] of [total] chapters complete.*
   ```
6. **Report to user:**
   ```
   Chapter [N]: [Title] — contextualized.
   - [X] concepts applied, [Y] filtered out

   Say **next** when ready for the next chapter.
   ```
7. **STOP and wait for the user to say "next"** — Do not continue without user confirmation

---

### Step 7: Companion Synthesis

After all chapters are processed, write a master synthesis section at the end of the reference file:

```markdown
## Companion Synthesis

### Priority Frameworks

*Ranked by relevance to this companion's core purpose.*

1. **[Framework name]** (from Chapter [N])
   - **When to invoke:** [Specific trigger/situation]
   - **How to apply:** [Concrete guidance]

2. **[Framework name]** (from Chapter [N])
   - **When to invoke:** [Trigger]
   - **How to apply:** [Guidance]

3. **[Framework name]** (from Chapter [N])
   - **When to invoke:** [Trigger]
   - **How to apply:** [Guidance]

[3-5 frameworks total]

### What This Book Doesn't Cover

- [Gap 1 relative to this companion's needs]
- [Gap 2]

### Integration Notes

- [How these frameworks connect to other reference material in the companion]
- [Potential tensions or complementary relationships with existing guidance]
```

Replace the progress marker with a completion marker:
```
*Contextualization complete. [N] chapters processed, [X] concepts applied, [Y] filtered.*
```

---

### Step 8: Record the Contextualization

1. Add a row to `[companion_dir]/context/decisions.md`:
   ```
   | Contextualized [Book Title] for companion | [Top 3 frameworks extracted]; [N] concepts filtered as not applicable | [date] |
   ```
   Create the decisions table if it doesn't exist.

2. Report to user:
   ```
   ## Contextualization Complete

   **File:** [relative path to reference file]
   **Chapters processed:** [N]
   **Concepts applied:** [X]
   **Concepts filtered:** [Y]

   **Top frameworks:**
   1. [Framework 1]
   2. [Framework 2]
   3. [Framework 3]

   The reference file is ready for use by the companion.
   ```

---

## Design Rationale

- **notes.md, not synthesis.md** — Full signal, not lossy summary. synthesis.md is for `/intake` discovery; notes.md has the detail needed for companion-specific filtering.
- **Chapter-by-chapter with writes** — Same resilience pattern as `/read-book`. If context compaction hits, at most one chapter's work is lost.
- **User says "next"** — Pacing control and natural breakpoints. User can review each chapter's contextualization.
- **Filter, don't copy** — The value is in deciding what matters for THIS companion, not in reproducing the library notes.
- **Record skipped content** — "Not Applicable" sections enable reviewability and future re-contextualization with different criteria.
- **Status gating** — Only `complete` or `in-progress` books are eligible, preventing contextualization of empty stubs.
- **Progress markers** — Enable resume after interruption, matching the `/read-book` resilience pattern.
