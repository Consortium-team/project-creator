# Context Ecosystem: Integration Guide

How to set up and maintain the context ecosystem in a companion project.

---

## Setting Up the context/ Directory

Every companion project gets a `context/` directory with the four core files created at project initialization.

### Initialization Script

When a new companion project is created, generate these files:

```
context/
├── requirements.md
├── constraints.md
├── decisions.md
└── questions.md
```

Each file should start with its header and an empty structure — not placeholder content. An empty structure signals "nothing captured yet" which is honest. Placeholder content like "TBD" or "Add requirements here" is noise.

**requirements.md initial content:**
```markdown
# Requirements

<!-- Captured through reverse prompting. Each entry includes date, source, and rationale. -->
```

**constraints.md initial content:**
```markdown
# Constraints

## Technical

## Resource

## Organizational

## Non-Negotiable
```

**decisions.md initial content:**
```markdown
# Decisions

<!-- Each decision captures: what was decided, why, what alternatives were considered. -->
```

**questions.md initial content:**
```markdown
# Open Questions

## High Priority

## Medium Priority

## Low Priority

## Resolved
```

---

## Extending with Persona-Specific Context Files

The four core files are universal. Each persona extends them with domain-specific context files that live in subdirectories.

### Product Manager Extensions

```
context/
├── requirements.md
├── constraints.md
├── decisions.md
├── questions.md
└── product/
    ├── hypothesis.md            # The strategy anchor (living)
    ├── vision.md                # Product vision statement (living)
    ├── user-segments.md         # Identified user segments (living)
    ├── competitive-landscape.md # Competitor analysis (living)
    └── feature-concepts.md      # Feature ideas with status (living)
```

**hypothesis.md** is the most important extension — it serves as the strategy anchor that filters all decisions (see Strategic Planning capability).

### Writing Mentor Extensions

```
context/
├── requirements.md
├── constraints.md
├── decisions.md
├── questions.md
└── author/
    ├── profile.md              # Author voice, strengths, goals (living)
    ├── voice-analysis.md       # Analysis of writing samples (living)
    ├── curriculum.md           # Craft development plan (living)
    └── craft-insights.md       # Accumulated craft observations (living)
```

Additional directories for anchors, writing output, and mentor skills live outside `context/` since they are operational rather than contextual.

### Game Designer Extensions

```
context/
├── requirements.md
├── constraints.md
├── decisions.md
├── questions.md
└── design/
    ├── pillars.md              # Core design pillars (living)
    ├── mechanics-catalog.md    # Documented mechanics (living)
    ├── player-personas.md      # Target player types (living)
    ├── balance-parameters.md   # Tuning values and rationale (living)
    └── frameworks.md           # Which frameworks are in use (permanent)
```

### Software Developer Extensions

```
context/
├── requirements.md
├── constraints.md
├── decisions.md
├── questions.md
└── docs/
    ├── current-architecture.md        # System architecture (living)
    ├── current-features.md            # Feature inventory (living)
    ├── current-security-assessment.md # Security posture (living)
    ├── current-test-strategy.md       # Test approach (living)
    └── adrs/                          # Architecture decision records (permanent)
```

### Strategic Companion Extensions

```
context/
├── requirements.md
├── constraints.md
├── decisions.md
├── questions.md
└── strategic/
    ├── themes.md               # Recurring strategic themes (living)
    ├── relationships.md        # Key relationship dynamics (living)
    ├── opportunities.md        # Identified opportunities (living)
    └── risks.md                # Identified risks (living)
```

---

## How Commands Should Read Context Files

Every command that needs context should follow a consistent reading pattern.

### The Standard Context Read

Place this at the beginning of any command that needs project context:

```markdown
## Step 1: Read Context

Read the following files (in this order):
1. `context/decisions.md` — What has been decided
2. `context/constraints.md` — Hard boundaries
3. `context/requirements.md` — What needs to be accomplished
4. `context/questions.md` — What is still open
5. [persona-specific files relevant to this command]

If any file is empty or missing critical information, note the gap.
Do NOT guess to fill gaps — flag them.
```

### Selective Reading

Not every command needs every file. Be explicit about which files a command reads:

```markdown
## Step 1: Read Context

Read:
- `context/decisions.md` — for decisions affecting this command
- `context/product/hypothesis.md` — for the current strategy anchor
```

### The Gap Check

After reading, the command should assess whether it has enough context to proceed:

```markdown
## Step 2: Assess Readiness

Based on the context read in Step 1:
- Is there enough information to proceed? If yes, continue.
- If not, report what is missing and suggest which command to run first
  (e.g., "Run /explore to capture [specific gap] before running /spec").
```

---

## How Commands Should Write Context Files

Writing to context files follows the "ask, confirm, file" pattern.

### The Standard Context Write

```markdown
## Step N: Update Context

Summarize what was captured in this session:
- [List the specific items to be written]

Show the user the proposed updates.
On confirmation, append to the relevant context files with:
- Date of capture
- Source (which conversation, meeting, or input)
- The captured content
```

### Append, Don't Replace

Living documents grow by appending new entries, not by rewriting the whole file. Each entry is timestamped so the reader can see the progression of understanding.

```markdown
## Captured 2026-02-23
**Source:** Intake session
- The primary user is a small-team founder (2-5 people) who needs...
- Success means the founder can articulate a testable hypothesis within 3 sessions...

## Captured 2026-02-25
**Source:** Follow-up after competitor analysis
- Added constraint: Must differentiate from [competitor X] on [dimension Y]...
```

### Cross-File Updates

When writing to one file affects another, handle both:

```markdown
## Step N: Update Context

1. Add the new decision to `context/decisions.md`
2. Move the resolved question from "Open" to "Resolved" in `context/questions.md`
3. Check if this decision invalidates any requirement in `context/requirements.md`
   - If yes, flag it for the user's review
```

---

## Maintaining Context Files Over Time

### Session Start: Orientation Read

Every session should start by reading the current state of context files. This is not optional — it prevents the companion from contradicting previously captured context.

```markdown
# /status (or session start protocol)

## Step 1: Read All Context
Read every file in `context/` and subdirectories.

## Step 2: Report Current State
Summarize:
- Key decisions in effect
- Active constraints
- Open questions needing attention
- What was captured most recently
```

### Periodic Review: The /gaps Command

The `/gaps` command audits the context ecosystem:

```markdown
# /gaps

## Step 1: Read All Context Files

## Step 2: Assess Completeness
For each core area, rate:
- Purpose: [Clear | Vague | Missing]
- Users: [Identified | Partial | Missing]
- Success criteria: [Defined | Partial | Missing]
- Constraints: [Captured | Partial | Missing]
- Key decisions: [Documented | Partial | Missing]

## Step 3: Check Consistency
- Do any decisions contradict requirements?
- Do any requirements violate constraints?
- Are there requirements without corresponding decisions?
- Are there decisions without rationale?

## Step 4: Report and Recommend
Present gaps with priority and suggested next command to fill each gap.
```

### Context Staleness

Living documents can become stale if not updated. Signs of staleness:
- A requirement that has been superseded by a decision but not annotated
- A constraint that no longer applies but was not removed
- A question that was resolved in conversation but not moved to "Resolved"

The `/gaps` command should check for staleness as part of its consistency audit.

---

## The Capture-as-You-Go Pattern

The most important maintenance pattern: capture context as it emerges, not in a batch at the end.

### During Reverse Prompting

Every exchange that surfaces new information should end with a context write:

```
User: "The main users are warehouse managers who are frustrated with..."
Claude: [Acknowledges, asks follow-up]
...
Claude: "Let me capture what we've covered. For requirements.md: [draft]. Does this look right?"
User: "Yes"
Claude: [Writes to requirements.md]
```

### During Meeting Processing

Every meeting transcript processed should update context files inline:

```
Claude: "From this transcript I extracted three items:
1. New requirement: [X] — goes to requirements.md
2. Decision made: [Y] — goes to decisions.md
3. Open question: [Z] — goes to questions.md

Does this capture look right?"
```

### During Synthesis

Every synthesis session should update or refine existing context:

```
Claude: "Looking across your context files, I notice [pattern].
This suggests we should update hypothesis.md to reflect [refined understanding].
Here's the proposed update: [draft]. Does this resonate?"
```

---

## Common Pitfalls

### Orphaned Context
Context that exists in conversation but never made it to a file. Prevention: every command that captures information must have an explicit "write to context file" step.

### Context Drift
Files that were written early and never updated to reflect evolved understanding. Prevention: periodic `/gaps` audits and session-start orientation reads.

### Over-Engineering
Creating too many context files too early. Start with the four core files. Add persona-specific extensions only when the project actually needs them. An empty file with a fancy name is worse than no file.

### Under-Attribution
Context entries without dates or sources. When you read "the user needs X" six months later, you need to know when that was captured and from what conversation. Always include date and source.
