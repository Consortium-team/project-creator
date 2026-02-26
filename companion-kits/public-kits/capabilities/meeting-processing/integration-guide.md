# Meeting Processing: Integration Guide

How to set up meeting processing in a companion project.

---

## The /process Command

Meeting processing is typically wired into a `/process` command that handles transcript ingestion, extraction, and context integration.

### Basic /process Command

```markdown
# /process

Process a meeting transcript or notes and extract structured insights.

## Input

Accepts one of:
- Pasted text (user pastes transcript directly)
- File path (user provides path to a transcript file)
- Granola meeting reference (user identifies a meeting to pull via MCP)

## Steps

### Step 1: Read Current Context

Read the following context files to understand what is already known:
- `context/decisions.md`
- `context/constraints.md`
- `context/requirements.md`
- `context/questions.md`
- [persona-specific context files, especially hypothesis.md if present]

### Step 2: Read and Parse the Transcript

Read the provided transcript or notes. Identify:
- Participants
- Topics covered
- Key statements (quotes with speaker attribution where possible)
- Tone and dynamics (disagreements, enthusiasm, hesitation)

### Step 3: Extract and Classify

For each extracted item, classify as:
- **Requirement** — Something the project must do
- **Constraint** — A new boundary or limitation
- **Decision** — Something decided in the meeting
- **Question** — Something raised but unresolved
- **Evidence** — Supports or challenges the hypothesis
- **Action item** — A commitment someone made
- **Insight** — A pattern or observation worth tracking

### Step 4: Connect to Existing Context

For each extracted item, check against current context:
- Does it confirm existing context? Note the confirmation.
- Does it contradict existing context? FLAG IT prominently.
- Does it extend existing understanding? Note what is new.
- Does it resolve an open question? Identify which one.
- Does it create a new question? Draft the question.

### Step 5: Present Extraction

Show the user ALL extracted items, organized by type, with connections:

```
From [meeting/transcript]:

REQUIREMENTS:
- [Item] — NEW / extends [existing requirement]

DECISIONS:
- [Item] — NEW

CONTRADICTIONS:
- [New information] contradicts [existing context item].
  Options: (1) update existing, (2) dismiss new, (3) refine both

EVIDENCE:
- [Item] — [supports/challenges] hypothesis v[N]: [specific claim]

QUESTIONS RESOLVED:
- [Question] resolved by [statement]

NEW QUESTIONS:
- [Question with context]

ACTION ITEMS:
- [Who] will [what] by [when]
```

### Step 6: Update Context Files

On user confirmation:
1. Append new requirements to `context/requirements.md`
2. Append new constraints to `context/constraints.md`
3. Append new decisions to `context/decisions.md`
4. Add new questions to `context/questions.md`
5. Move resolved questions to the Resolved section
6. Update `hypothesis.md` with new evidence
7. Handle contradictions per user's direction

Each entry includes:
- Date
- Source: "[Meeting name/description] on [date]"
- The extracted content

## Rules
- NEVER silently resolve contradictions — always surface them.
- NEVER skip the connection step — extraction without connection is just summarization.
- ALWAYS show the user the full extraction before writing to files.
- Process ONE meeting at a time. Do not batch.
```

---

## Granola MCP Integration

For companions that use Granola for meeting capture, wire in the MCP tools.

### Available MCP Tools

| Tool | Purpose | Parameters |
|------|---------|------------|
| `query_granola_meetings` | Search meetings by keyword or topic | query string |
| `get_meetings` | List recent meetings | count (optional), date range (optional) |
| `get_meeting_transcript` | Get full transcript for a specific meeting | meeting ID |

### /process with Granola

Extend the `/process` command to support Granola as a source:

```markdown
## Input: Granola Meeting

If the user says "process my meeting about [topic]" or "process the meeting with [person]":

1. Use `query_granola_meetings` to find matching meetings.
2. If multiple matches, present them and ask the user to select one.
3. Use `get_meeting_transcript` to retrieve the full transcript.
4. Proceed with the standard extraction steps.

If the user says "process my last meeting" or "process today's meetings":

1. Use `get_meetings` to list recent meetings.
2. Present the list and ask the user to confirm which one(s) to process.
3. Process ONE at a time (do not batch).
```

### /meetings Command (Optional)

For companions where meeting processing is central, add a `/meetings` command that provides quick access to recent meetings:

```markdown
# /meetings

List recent meetings and optionally process one.

## Steps

1. Use `get_meetings` to retrieve the last 10 meetings.
2. Display them with:
   - Date and time
   - Title or topic
   - Participants (if available)
   - Whether already processed (check tracking file)

3. Ask: "Which meeting would you like to process? Or say 'none' to return."

4. If the user selects one, hand off to `/process` with the meeting transcript.
```

### Tracking Processed Meetings

Maintain a tracking file so the companion knows which meetings have been processed:

```
tracking/meetings-processed.md
```

```markdown
# Processed Meetings

| Date | Meeting | Source | Items Extracted |
|------|---------|--------|-----------------|
| 2026-02-23 | Customer call with Acme | Granola | 3 requirements, 1 contradiction, 2 action items |
| 2026-02-22 | Team standup | Pasted notes | 1 decision, 1 question resolved |
```

---

## Structuring Extracted Insights

### The Extraction Record

For each processed meeting, create a structured extraction that lives in the tracking directory:

```
tracking/meetings/
├── meetings-processed.md    # Index of all processed meetings
├── 2026-02-23-acme-call.md  # Individual extraction record
└── 2026-02-22-standup.md    # Individual extraction record
```

Individual extraction records provide a detailed audit trail:

```markdown
# Meeting: Customer Call with Acme
**Date:** 2026-02-23
**Source:** Granola transcript
**Participants:** [list]

## Extracted Items

### Requirements
- [R1] Acme needs bulk import for their existing data (NEW)
  - Written to: context/requirements.md

### Evidence
- [E1] Acme's primary concern is time-to-value, not feature completeness (SUPPORTS hypothesis v3)
  - Written to: context/product/hypothesis.md

### Contradictions
- [C1] Acme said they need SSO. Previous decision (2026-02-15) deferred SSO to v2.
  - Resolution: User decided to move SSO to v1 scope.
  - Written to: context/decisions.md (updated), context/requirements.md (updated)

### Action Items
- [A1] John will send Acme's data format specs by 2026-02-28
```

---

## Connecting Meeting Insights to Existing Context

### The Connection Matrix

For each extracted item, evaluate it against every relevant context file:

| Extracted Item | requirements.md | constraints.md | decisions.md | questions.md | hypothesis.md |
|----------------|----------------|----------------|--------------|--------------|---------------|
| "Acme needs bulk import" | NEW requirement | No impact | No impact | No impact | Supports (time-to-value) |
| "SSO is blocking renewal" | Extends scope | No impact | CONTRADICTS v2 deferral | No impact | Challenges (feature priority) |
| "Budget is $50K max" | No impact | NEW constraint | No impact | Resolves Q7 | No impact |

The companion does not need to present this as a literal matrix, but it should perform this analysis mentally for every extracted item and surface the connections in its extraction summary.

### Cumulative Pattern Recognition

After processing multiple meetings, the companion should start recognizing patterns across meetings:

- "Three of the last four customer calls mentioned onboarding speed. This is becoming a pattern."
- "Every meeting with enterprise prospects surfaces SSO as a blocker. Your hypothesis says SMBs are the target — but your meetings are with enterprises. Is there a mismatch?"
- "You keep deferring the reporting question. It has come up in 5 meetings. This might need a decision."

Pattern recognition across meetings is one of the highest-value contributions of meeting processing.

---

## The Contradiction-Flagging Pattern in Practice

### Immediate Flagging

When a contradiction is detected during extraction, it must be flagged immediately — not at the end of the extraction, not in a summary section, not as a footnote.

```
CONTRADICTION DETECTED:

This meeting: [Participant] said "[exact quote or paraphrase]"

Existing context: `context/decisions.md` (2026-02-15) says:
"[The existing decision text]"

These conflict. Options:
1. The meeting information is correct — update the decision.
2. The existing decision is correct — the meeting statement was incorrect or context-dependent.
3. Both are partially correct — refine to reconcile.

Which is it?
```

### Contradiction Tracking

For companions where contradictions are frequent (e.g., product manager processing many customer conversations), maintain a contradiction log:

```markdown
# Contradiction Log

## Active (Unresolved)
- [Date] [Meeting] vs. [Context item]: [Brief description]

## Resolved
- [Date] Resolved: [How it was resolved]
```

---

## Persona-Specific Adaptations

### Product Manager

Focus extraction on:
- User needs and pain points (requirements)
- Market signals and competitor mentions (evidence)
- Feature requests with the "why" behind them (requirements + evidence)
- Pricing and willingness-to-pay signals (constraints + evidence)

Always evaluate against the product hypothesis.

### Strategic Companion

Focus extraction on:
- Relationship dynamics (who said what to whom, power dynamics)
- Strategic signals (market shifts, competitive moves, opportunity windows)
- Client health indicators (satisfaction, risk signals, expansion potential)
- Cross-client patterns (are multiple clients saying the same thing?)

### Game Designer

Focus extraction on:
- Player feedback patterns (what did playtesters enjoy, struggle with, ignore?)
- Design insight moments (unexpected emergent behaviors)
- Balance observations (what felt too easy, too hard, or just right?)
- Framework connections (which lens explains what was observed?)

---

## Common Pitfalls

### Processing Without Reading Context First
If the companion does not read existing context before processing a meeting, it cannot make connections or detect contradictions. The context read step is not optional.

### Over-Processing
Not every sentence in a transcript is an insight. Focus on items that change, confirm, or contradict what is already known. A 60-minute meeting might yield 3-5 meaningful extractions.

### Under-Attribution
Every extracted item should trace back to a specific statement or moment in the meeting. "The customer wants better reporting" is weak. "Sarah from Acme said 'We can't renew without proper reporting — our board requires quarterly metrics'" is strong.

### Batch Processing
Processing multiple meetings in a single session degrades quality. The connection step requires careful comparison with context files, and doing this for multiple meetings at once leads to shallow extraction. One meeting at a time.

### Action Items as Primary Output
Action items are the least valuable extraction. They are operational (who does what by when) rather than strategic (what did we learn). Prioritize insights, evidence, and contradictions over action items.
