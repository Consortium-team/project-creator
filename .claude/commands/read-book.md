# /read-book — Read and Annotate a Book via Kindle Cloud Reader

Read a book through the browser, taking structured notes to a reference file in batches of 10 page-flips. Produces a chapter-by-chapter annotated reference document with project-specific applicability notes.

## Usage

```
/read-book [kindle-url]                    # Read for current project
/read-book [kindle-url] [client/project]   # Override for specific project
```

**Example:**
```
/read-book https://read.amazon.com/?asin=B00RLQXBYS
```

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Determine the Project

1. If `$ARGUMENTS` contains a project path, use that
2. Otherwise, read `tracking/current-project.md` for the current project
3. If no project is set:
   ```
   No project set. Use /project to set or create one first.
   ```

Store the project path and full directory path (`projects/[client]/[project]/`).

---

### Step 2: Extract the URL and Determine Book Identity

1. Parse the Kindle URL from `$ARGUMENTS` (the `asin=XXXXXXXXXX` parameter identifies the book)
2. Extract the ASIN from the URL

---

### Step 3: Check for Existing Reference File

1. Search `[project]/reference/` for any file containing the ASIN or that matches the book
2. **If a reference file exists:**
   - Read it to find the "Reading paused at page X of Y" marker at the bottom
   - Report to the user: "Picking up from page X (Y% complete). Currently in [chapter name]."
   - This is a **resume** — skip to Step 5
3. **If no reference file exists:**
   - This is a **new read** — continue to Step 4

---

### Step 4: Create the Reference File (New Read Only)

1. Navigate to the Kindle URL (Step 5 handles browser connection)
2. Once on the book, open the Table of Contents to get the book's structure
3. Identify the book title and author from the page
4. Ask the user to confirm the reference filename (suggest: `[author-lastname]-[short-title]-notes.md`)
5. Create the reference file with this header:

```markdown
# [Book Title] — Key Insights

**Source:** [Author], *[Book Title]* (Kindle Edition, ASIN: [ASIN])
**Purpose:** [Extract from project requirements — what is this book being read for?]
**Method:** Page-by-page reading with synthesis at chapter boundaries

---
```

6. Close the Table of Contents and navigate to page 1 (or the Preface/Introduction)

---

### Step 5: Connect to the Browser

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

### Step 6: Read in Batches of 10 Flips

**This is the core reading loop. Repeat this step until the book is complete.**

**For each flip (repeat 10 times per batch):**

1. **Read the current two-page spread** — Take a screenshot and carefully read both visible pages
2. **Write notes to the reference file** — Append notes for the pages just read, following the note format (see Step 7). If a chapter has ended on this spread, write the **Chapter Synthesis** before continuing.
3. **Flip to the next spread** — Click the right-side arrow (typically around coordinate [1425, 405] but verify with screenshot)

Repeat steps 1–3 until you've done 10 flips.

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

---

### Step 7: Note Format

Follow this structure for each batch of notes appended to the reference file:

```markdown
## Chapter [N] | [Chapter Title] (pp. [start]–[end])

### Pages [X]–[Y]

**Key concepts:**

1. **[Concept name]** — [Description of the concept in your own words, capturing the essential insight]

2. **[Concept name]** — [Description]

**Applicable to [project context]:**
- [How this concept applies to the specific project]
- [Specific editorial/design/build implications]

### Pages [X]–[Y]

[Continue for each spread in the batch...]

### Chapter [N] Synthesis

**Chapter thesis:** [One-paragraph summary of the chapter's core argument]

**Key frameworks for [project]:**

1. **[Framework name]** — [Description and how it applies]
2. **[Framework name]** — [Description and how it applies]

---
```

**Note-taking principles:**

- Capture concepts in your own words — do not copy large passages verbatim
- Every few spreads, include an "Applicable to [project]" section connecting insights to the specific project
- Be specific about applicability — "this is relevant" is useless; "this means the companion should X when Y" is useful
- At chapter boundaries, synthesize into named frameworks that can be referenced later
- Use the project's requirements.md and decisions.md to inform applicability notes

---

### Step 8: Update Reading Position

After each batch of notes, update the footer of the reference file:

```markdown
*Reading paused at page [X] of [total] ([Y]% complete). Currently in Chapter [N]: [Chapter Title].*
```

This marker is how the command knows where to resume on the next invocation.

---

### Step 9: Book Completion

When you reach the end of the book:

1. Write final chapter notes and synthesis
2. Replace the "Reading paused" marker with:
   ```
   *Reading complete. [Total pages] pages, [N] chapters.*
   ```
3. Tell the user the reading is complete
4. **Do not create the master synthesis yet** — that's a separate step the user may want to direct

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
- Ask the user to reconnect (click extension icon → Connect). Then take a screenshot to verify the reader is still on the right page.

---

## Design Rationale

- **10 flips per batch** balances reading depth with note-writing frequency. More flips risks losing detail; fewer flips creates excessive overhead.
- **Notes before flipping** ensures nothing is lost if the session is interrupted.
- **User says "next"** gives the user control over pacing and lets them step away between batches.
- **Chapter synthesis at boundaries** creates named frameworks that the rest of the project can reference.
- **Applicability notes throughout** ensure the reading is always connected to the project's needs, not just abstract note-taking.
