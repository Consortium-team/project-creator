---
name: read-book
description: >
  Use when the user wants to read and annotate a book via Kindle Cloud Reader. Supports two modes:
  project mode (companion-specific notes in reference/) and library mode (companion-neutral notes
  in org library). Reads in batches of 10 page-flips with resilient note-writing after each flip.
disable-model-invocation: true
argument-hint: "[kindle-url] or [--library org kindle-url]"
---

# /read-book — Read and Annotate a Book via Kindle Cloud Reader

Read a book through the browser, taking structured notes in batches of 10 page-flips. Supports two modes:

1. **Project mode** (default) — Produces project-specific applicability notes stored in the companion's `reference/` directory
2. **Library mode** (`--library [org]`) — Produces comprehensive, companion-neutral notes stored in the organization's library at `companion-kits/private-kits/[org]-companion-kit/library/`

**Usage:**
- `/read-book [kindle-url]` — Read for current companion (project mode)
- `/read-book [kindle-url] [client/companion]` — Override for specific companion
- `/read-book --library [org] [kindle-url]` — Read to org library (library mode)
- `/read-book --library [org] [subject] [kindle-url]` — Library mode with subject category

**Examples:**
```
/read-book https://read.amazon.com/?asin=B00RLQXBYS
/read-book --library consortium.team https://read.amazon.com/?asin=B00RLQXBYS
/read-book --library consortium.team creative-writing https://read.amazon.com/?asin=B00RLQXBYS
```

---

## Step 0: Determine Reading Mode

Parse `$ARGUMENTS` for the `--library` flag:

**If `--library [org]` is present:**
- **Library mode** — Notes are companion-neutral, stored in `companion-kits/private-kits/[org]-companion-kit/library/`
- Extract the organization name (e.g., `consortium.team`)
- If a subject category is provided (e.g., `creative-writing`), use it for directory placement
- Skip Step 1 (no project needed)
- In Steps 6-7, use library note format instead of project note format (see Step 7b)

**If `--library` is NOT present:**
- **Project mode** — Notes are companion-specific, stored in the project's `reference/` directory
- Proceed to Step 1

---

## Step 1: Determine the Companion (Project Mode Only)

1. If `$ARGUMENTS` contains a companion path, use that
2. Otherwise, read `tracking/current-companion.md` for the current companion
3. If no companion is set:
   ```
   No companion set. Use /companion to set or create one first.
   Or use --library [org] to read to the organization's library.
   ```

Store the companion path and full directory path (`companions/[client]/[companion]/`).

---

## Step 2: Extract the URL and Determine Book Identity

1. Parse the Kindle URL from `$ARGUMENTS` (the `asin=XXXXXXXXXX` parameter identifies the book)
2. Extract the ASIN from the URL

---

## Step 3: Check for Existing Reference File

**In project mode:**
1. Search `[companion]/reference/` for any file containing the ASIN or that matches the book

**In library mode:**
1. Search `companion-kits/private-kits/[org]-companion-kit/library/` recursively for any file containing the ASIN or that matches the book
2. Also check if a `metadata.yaml` already exists with a matching ASIN

**In either mode:**
2. **If a reference file exists:**
   - Read it to find the "Reading paused at page X of Y" marker at the bottom
   - Report to the user: "Picking up from page X (Y% complete). Currently in [chapter name]."
   - This is a **resume** — skip to Step 5
3. **If no reference file exists:**
   - This is a **new read** — continue to Step 4

---

### Compliance Checkpoint 1

**For new reads, confirm book identity and destination before proceeding:**
```
New read detected.

Book ASIN: [ASIN]
Mode: [Project / Library]
Destination: [path where notes will be stored]

Proceeding to connect to the browser and identify the book. Ready?
```

**For resumes, confirm the pickup point:**
```
Resuming read.

Book: [title if known]
Paused at: page [X] of [Y] ([Z]%)
Chapter: [chapter name]

Ready to continue?
```

**STOP and wait for user confirmation.**

---

## Step 4: Create the Reference File (New Read Only)

1. Navigate to the Kindle URL (Step 5 handles browser connection)
2. Once on the book, open the Table of Contents to get the book's structure
3. Identify the book title and author from the page

**In project mode:**
4. Ask the user to confirm the reference filename (suggest: `[author-lastname]-[short-title]-notes.md`)
5. Create the reference file in `[companion]/reference/` with this header:

```markdown
# [Book Title] — Key Insights

**Source:** [Author], *[Book Title]* (Kindle Edition, ASIN: [ASIN])
**Purpose:** [Extract from project requirements — what is this book being read for?]
**Method:** Page-by-page reading with synthesis at chapter boundaries

---
```

**In library mode:**
4. Determine the library directory:
   - If subject was provided: `companion-kits/private-kits/[org]-companion-kit/library/[subject]/[author-short-title]/`
   - If no subject: ask the user which subject category to use (e.g., `creative-writing`, `game-design`, `product-management`)
5. Create the directory if it doesn't exist
6. Create `notes.md` in the library directory with this header:

```markdown
# [Book Title] — Comprehensive Notes

**Source:** [Author], *[Book Title]* (Kindle Edition, ASIN: [ASIN])
**Purpose:** Companion-neutral comprehensive notes for the [org] library
**Method:** Page-by-page reading with synthesis at chapter boundaries

---
```

7. Create or update `metadata.yaml` in the same directory:

```yaml
title: "[Book Title]"
author: "[Author]"
asin: "[ASIN]"
subjects: [suggested subject tags]
related_personas: [suggested based on subject]
source_projects: []
status: "in-progress"
```

8. Close the Table of Contents and navigate to page 1 (or the Preface/Introduction)

---

## Step 5: Connect to the Browser

**Try Claude in Chrome extension first:**

1. Call `tabs_context_mcp` with `createIfEmpty: true`
2. **If connected:** Create a new tab, navigate to the Kindle URL
3. **If "No Chrome extension connected" error:**
   - Tell the user: "The Claude in Chrome extension isn't connected. Please:
     1. Open Chrome (if not running)
     2. Click the Claude in Chrome extension icon in the toolbar
     3. Click 'Connect' if prompted
     4. Let me know when it's ready"
   - Wait for user confirmation, then retry

**If Chrome extension doesn't work, try Playwright:**

1. Call `browser_navigate` with the Kindle URL
2. **If "Failed to launch" error (Chrome already running):**
   - Tell the user: "Playwright can't launch because Chrome is already running. Please quit Chrome completely (Cmd+Q), then let me know."
   - Wait for user confirmation, then retry

**Once connected and navigated:**

3. Take a screenshot to confirm the book is loaded
4. If a "Most Recent Page Read" dialog appears:
   - **If resuming:** Click "Yes" to go to the last page, then navigate to the page noted in the reference file
   - **If new read:** Click "No" to stay at the beginning
5. If the reader is at the wrong page, tell the user which page you need and ask for help navigating there

---

## Step 6: Read in Batches of 10 Flips

**This is the core reading loop. Repeat this step until the book is complete.**

**For each flip (repeat 10 times per batch):**

1. **Read the current two-page spread** — Take a screenshot and carefully read both visible pages
2. **Write notes to the reference file** — Append notes for the pages just read, following the note format (see Step 7). If a chapter has ended on this spread, write the **Chapter Synthesis** before continuing.
3. **Flip to the next spread** — Click the right-side arrow (typically around coordinate [1425, 405] but verify with screenshot)

Repeat steps 1-3 until you've done 10 flips.

**Why write after every flip, not after the batch:** Context compaction can hit at any time. If notes are written after every 2 pages, a compaction only loses the current spread. If notes are batched to the end, a compaction on flip 8 loses everything. This is the critical resilience mechanism.

**Chapter boundary handling:**

- When you reach the end of a chapter on a spread, write the chapter's **Chapter Synthesis** to the reference file as part of step 2 for that flip
- The synthesis should capture: chapter thesis, key frameworks applicable to the project
- Then continue reading into the next chapter on the next flip

**After completing 10 flips:**

4. **Update the reading position marker** at the bottom of the reference file (see Step 8)
5. **Report to the user:**
   ```
   Notes written through page [X] of [total] ([Y]%), in [Chapter Name].

   Say **next** when you're ready for the next batch.
   ```
6. **STOP and wait for the user to say "next"** — Do not continue reading without user confirmation

### Compliance Checkpoint 2

**After every batch of 10 flips, this is a mandatory pause point.** Do not proceed to the next batch until the user explicitly says "next" or equivalent. This gives the user pacing control and a natural breakpoint.

---

## Step 7: Note Format (Project Mode)

Follow this structure for each batch of notes appended to the reference file:

```markdown
## Chapter [N] | [Chapter Title] (pp. [start]-[end])

### Pages [X]-[Y]

**Key concepts:**

1. **[Concept name]** — [Description of the concept in your own words, capturing the essential insight]

2. **[Concept name]** — [Description]

**Applicable to [project context]:**
- [How this concept applies to the specific project]
- [Specific editorial/design/build implications]

### Pages [X]-[Y]

[Continue for each spread in the batch...]

### Chapter [N] Synthesis

**Chapter thesis:** [One-paragraph summary of the chapter's core argument]

**Key frameworks for [project]:**

1. **[Framework name]** — [Description and how it applies]
2. **[Framework name]** — [Description and how it applies]

---
```

**Note-taking principles (project mode):**

- Capture concepts in your own words — do not copy large passages verbatim
- Every few spreads, include an "Applicable to [project]" section connecting insights to the specific project
- Be specific about applicability — "this is relevant" is useless; "this means the companion should X when Y" is useful
- At chapter boundaries, synthesize into named frameworks that can be referenced later
- Use the project's requirements.md and decisions.md to inform applicability notes

---

## Step 7b: Library Note Format (Library Mode Only)

In library mode, notes are **comprehensive and companion-neutral**. Instead of "Applicable to [project]" sections, use broader tagging.

```markdown
## Chapter [N] | [Chapter Title] (pp. [start]-[end])

### Pages [X]-[Y]

**Key concepts:**

1. **[Concept name]** — [Description of the concept in your own words, capturing the essential insight]

2. **[Concept name]** — [Description]

**Subject tags:** [craft-technique, character-development, pacing, etc.]

### Pages [X]-[Y]

[Continue for each spread in the batch...]

### Chapter [N] Synthesis

**Chapter thesis:** [One-paragraph summary of the chapter's core argument]

**Key frameworks:**

1. **[Framework name]** — [Description — what it is, when it applies, how to use it]
2. **[Framework name]** — [Description]

**Potential applicability:**
- Personas: [which persona types might use this — e.g., writing-mentor, game-designer]
- Capabilities: [which capabilities this relates to — e.g., mentor-framework, craft-assessment]

---
```

**Library note-taking principles:**

- Capture EVERYTHING notable — err on the side of more, not less
- Do NOT filter for any specific companion's needs — capture comprehensively
- Tag with broad subject categories rather than companion-specific applicability
- At chapter boundaries, note which persona types and capabilities the material relates to
- The goal is raw material that any companion can later contextualize from

---

## Step 8: Update Reading Position

After each batch of notes, update the footer of the reference file:

```markdown
*Reading paused at page [X] of [total] ([Y]% complete). Currently in Chapter [N]: [Chapter Title].*
```

This marker is how the command knows where to resume on the next invocation.

---

## Step 9: Book Completion

When you reach the end of the book:

1. Write final chapter notes and synthesis
2. Replace the "Reading paused" marker with:
   ```
   *Reading complete. [Total pages] pages, [N] chapters.*
   ```
3. Tell the user the reading is complete

**In project mode:**
4. **Do not create the master synthesis yet** — that's a separate step the user may want to direct

**In library mode:**
4. Update `metadata.yaml` to set `status: "complete"`
5. Create `synthesis.md` in the same library directory with a master synthesis:
   - Key frameworks distilled from the notes
   - Major themes and their subject tags
   - Potential applicability to different persona types
6. Tell the user the library entry is complete and ready for contextualization by any companion

---

## Troubleshooting

**Kindle reader won't load:**
- The reader requires an active Amazon login. Ask the user to sign into Amazon in the browser first.

**Page won't flip:**
- The click target may have shifted. Take a screenshot and look for the right-arrow navigation element. Try clicking directly on it.

**Reader shows wrong page after resume:**
- Tell the user which page you need (from the reference file's "Reading paused" marker) and ask them to navigate there manually.

**Context buffer hits 20MB cap:**
- The user will start a new Cowork session. On resume, they'll invoke `/read-book` again with the same URL. Step 3 will find the existing reference file and pick up where it left off.

**Chrome extension disconnects mid-read:**
- Ask the user to reconnect (click extension icon then Connect). Then take a screenshot to verify the reader is still on the right page.

---

## Design Rationale

- **10 flips per batch** balances reading depth with note-writing frequency. More flips risks losing detail; fewer flips creates excessive overhead.
- **Notes before flipping** ensures nothing is lost if the session is interrupted.
- **User says "next"** gives the user control over pacing and lets them step away between batches.
- **Chapter synthesis at boundaries** creates named frameworks that the rest of the project can reference.
- **Applicability notes throughout** ensure the reading is always connected to the project's needs, not just abstract note-taking.
