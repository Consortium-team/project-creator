# Capability: Meeting Processing

Transform meeting transcripts and notes into structured, actionable insights that connect to existing project context.

---

## What It Is

Meeting processing takes raw conversational input — transcripts from meetings, pasted notes, recorded conversations — and extracts structured information that integrates with the project's context ecosystem.

The key distinction: meeting processing is not summarization. Summarization compresses a meeting into a shorter version of itself. Meeting processing **connects new information to existing context** — updating requirements, challenging hypotheses, resolving questions, surfacing contradictions.

A meeting summary answers "What happened in this meeting?" Meeting processing answers "What did this meeting change about what we know?"

---

## Sources

Meeting content arrives through several channels.

### Granola Meeting Notes

Granola captures meeting transcripts automatically with AI-enhanced note-taking. It provides structured meeting data through its MCP integration:
- `query_granola_meetings` — Search across meetings
- `get_meetings` — List recent meetings
- `get_meeting_transcript` — Get full transcript content

### Manual Transcripts

Users paste or provide transcript files from other sources — Otter, Rev, manual notes, voice memos.

### Pasted Meeting Notes

Users paste meeting notes directly into the conversation. These are typically less structured than transcripts but may contain the user's own annotations and highlights.

---

## The Insight Extraction Pattern

Meeting processing follows a consistent extraction pattern regardless of the source.

### Step 1: Read and Parse

Read the raw transcript or notes. Identify:
- **Participants** — Who was in the meeting
- **Topics covered** — Major subjects discussed
- **Key statements** — Specific things said that carry weight (quotes, decisions, commitments)
- **Tone and dynamics** — Was there disagreement? Enthusiasm? Hesitation?

### Step 2: Classify Extracted Items

Every extracted item is classified by type:

| Type | Description | Destination |
|------|-------------|-------------|
| **Requirement** | Something the project must do or support | context/requirements.md |
| **Constraint** | A new limitation or boundary | context/constraints.md |
| **Decision** | Something that was decided in the meeting | context/decisions.md |
| **Question** | Something raised but not resolved | context/questions.md |
| **Evidence** | Information that supports or challenges a hypothesis | hypothesis.md |
| **Action item** | Something someone committed to doing | tracking file or task system |
| **Insight** | A pattern, observation, or connection worth capturing | persona-specific tracking |

### Step 3: Connect to Existing Context

This is the step that distinguishes meeting processing from summarization. For each extracted item:
- Does it **confirm** something already in the context files?
- Does it **contradict** something already captured?
- Does it **extend** existing understanding with new detail?
- Does it **resolve** an open question?
- Does it **create** a new question?

### Step 4: Present and Confirm

Show the user the extracted items with their classifications and connections. The user confirms before anything is written to context files.

```
From this meeting I extracted:

REQUIREMENTS (2 new):
- [Requirement A] — extends existing requirement in requirements.md about [topic]
- [Requirement B] — NEW, not previously captured

CONTRADICTIONS (1):
- [Item] contradicts the decision on [date] in decisions.md that said [X].
  The meeting participant said [Y] instead. Which is correct?

EVIDENCE (1):
- [Observation] — supports hypothesis version 3, specifically the claim about [Z]

QUESTIONS RESOLVED (1):
- [Question from questions.md] — resolved by [participant]'s statement that [answer]

Does this capture look right?
```

---

## When to Use

Any companion that processes meeting content or conversational input.

| Companion Type | Meeting Processing Role |
|----------------|------------------------|
| Product Manager | Core — customer conversations, stakeholder meetings, user research sessions |
| Strategic Companion | Core — client meetings, operational discussions, strategic reviews |
| Game Designer | Occasional — playtesting sessions, design reviews |
| Software Developer | Occasional — sprint planning, architecture discussions |
| Writing Mentor | Rare — only if writing workshops or feedback sessions produce transcripts |

---

## Key Principle: Value Is Connection, Not Compression

The value of meeting processing is not making a long meeting shorter. It is making new information actionable by connecting it to what is already known.

A standalone meeting summary:
> "Met with the customer. They want faster onboarding and better reporting. Action items: John will prototype the dashboard."

A connected meeting extraction:
> "The customer's request for faster onboarding **supports** our hypothesis that activation speed is the primary driver of retention (hypothesis v2). Their reporting request **contradicts** our decision on 2026-02-01 to defer reporting to v2 — they described it as blocking a renewal. This **resolves** the open question about whether reporting is a retention factor (it is, at least for this customer segment)."

The second version changes what the team knows and believes. The first version is just a record.

---

## The Contradiction-Flagging Pattern

The most valuable thing meeting processing can do is surface contradictions between new information and existing context. Contradictions are where learning happens.

### Types of Contradictions

**Hypothesis contradictions:** New information challenges the current strategic hypothesis.
> "Your hypothesis says users prioritize speed. This customer explicitly said they prioritize accuracy, even at the cost of speed."

**Decision contradictions:** New information suggests a previous decision was wrong.
> "You decided to target enterprise customers. This meeting with three enterprise prospects revealed none of them see the value proposition. The small team customers in your pipeline are all enthusiastic."

**Requirement contradictions:** New information conflicts with a captured requirement.
> "Requirements say the system must support offline mode. This stakeholder said 100% of their target users are always connected and offline support would add complexity they can't afford."

**Internal contradictions:** The same person said contradictory things in different meetings.
> "In the January meeting you said [X]. In this February meeting you said [Y]. These can't both be true. Which reflects your current thinking?"

### Handling Contradictions

Contradictions are never silently resolved. They are always surfaced to the user with:
1. What the existing context says
2. What the new information says
3. A clear statement that these conflict
4. Options for resolution (update the old, dismiss the new, refine to reconcile)

---

## Processing Quality

The quality of meeting processing depends on the quality of the input.

| Input Quality | Extraction Quality | Notes |
|---------------|-------------------|-------|
| Full transcript (Granola, Otter) | High — specific quotes, speaker attribution | Best source for evidence and contradictions |
| Detailed notes with context | Medium-high — good for items, less for nuance | Works well when the note-taker captured key moments |
| Brief meeting summary | Low — mostly surface-level items | Only useful for action items; suggest fuller capture next time |
| Memory-based recap | Low — subject to recall bias | Flag that this is the user's memory, not a record |

The companion should gently encourage higher-quality inputs when low-quality inputs produce thin extractions: "I can only extract what's in the notes. For future meetings, a full transcript (Granola or similar) would let me catch the connections and contradictions that brief notes miss."

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Summarization only | Compresses but does not connect | Always connect to existing context |
| Silent contradiction handling | Resolves conflicts without user input | Surface every contradiction explicitly |
| Over-extraction | Pulling every sentence as an "insight" | Focus on items that change what is known |
| Ignoring tone and dynamics | Missing the subtext of meetings | Note disagreements, hesitations, and enthusiasm |
| Batch processing without review | Processing 10 meetings at once | Process one meeting at a time with user confirmation |
| Action items only | Treating meetings as just task generators | Action items are the least valuable extraction — insights and evidence matter more |
