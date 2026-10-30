---
name: retro
description: >
  Use when the user wants a retro of a Project Creator session (intake, gaps, plan, build, or any mix). Writes a
  retro log to tracking/retros/: every user prompt verbatim, response summaries, every question asked quoted exactly,
  and an analysis of what worked, what didn't, and insights.
disable-model-invocation: true
argument-hint: "[client/companion] [--since YYYY-MM-DDTHH:MM] [--session uuid]"
---

# /retro — Session Retro Log

Write a retro log of a Project Creator session: what the user asked, what was answered, what was asked back, and what
the session teaches. The log is read later to improve the skills, the methodology and future intakes.

**Usage:**
- `/retro` — the current session, for the current companion
- `/retro [client/companion]` — name the companion the session was about
- `/retro --since 2026-10-28T14:00 [--until ...]` — a time window, spanning several sessions
- `/retro --session <uuid>` — a specific earlier session

---

## Step 1: Determine Scope

1. **Companion:** from `$ARGUMENTS` if it contains a `client/companion` path; otherwise `tracking/current-companion.md`.
   If the session touched several companions, name the main one and list the others in the header.
2. **Session:** `--session` or `--since`/`--until` from `$ARGUMENTS`; otherwise the current session.

Declare the values before continuing:
```
Retro scope:
- Companion: [client/companion]
- Session: current | <uuid> | <since> to <until>
```

---

## Step 2: Extract the Transcript

Run the condenser from the project root:

```bash
python3 .claude/skills/retro/scripts/session_transcript.py --out [scratchpad]/retro-condensed.md [--session <uuid> | --since <t> --until <t>]
```

Use the scratchpad directory for the output. The script prints the prompt count and the time span: note both.

Then **read the whole condensed file yourself**. Do not delegate the reading to an agent; the retro's value is in
details a summary flattens. If it's long, read it in parts until you've seen all of it.

The condensed file marks:
- `######## PROMPT n (time)` — a user prompt, verbatim, between `~~~~text` fences. Slash commands are shown as typed.
- `[pasted text — N chars, SUMMARIZE]` and `[attachment: ... — SUMMARIZE]` — material to summarize, not quote.
- `[same text as the previous prompt]` — a repeated prompt (often a re-send after an interruption, or the same answer twice).
- `[INTERRUPTED by the user]` — the user stopped a response.
- `[REPLY hh:mm]` — the assistant's text, in full.
- `[ASKED]` — an AskUserQuestion question with its options.
- `[WRITE]`, `[AGENT]`, `[SKILL]` — files written, agents dispatched and skills invoked.

Questions asked in plain reply text (not through AskUserQuestion) appear inside `[REPLY]` blocks. Find them there:
they are usually bolded, end in `?`, or offer lettered options.

---

## Step 3: Gather the Outputs

List what the session produced, from the `[WRITE]` lines and from the companion's directory:
- files created or changed in the companion (`context/`, `docs/plans/`, `HANDOFF.md`, and so on);
- Project Creator files (`tracking/`, memory, patterns);
- commits made (check `git log` in the companion), or note that nothing was committed.

Check what happened after the session if it's visible (for example, `build-progress.md` showing a later `/build`), and
say so in one line.

---

## Step 4: Write the Retro Log

**File:** `tracking/retros/YYYY-MM-DD-[companion]-[phase-label]-retro.md`. Use the session's start date. The phase
label names the span, for example `intake-to-plan`, `intake`, `build`. Create `tracking/retros/` if needed.

### Structure

```markdown
# Retro log: [companion], [phase span] (YYYY-MM-DD)

[One paragraph: what the session was for, when it ran (local time, with time zone), how many conversations and
compactions, the command sequence, how it ended, and how many prompts the user gave.]

**Outputs:**
- [each file or group of files, with one line on what it holds]

[Commit status.]

**What happened next:** [only if visible]

**How to read the log:** each prompt is quoted exactly, typos and all, in a block quote. A slash command is shown as
typed, with its arguments. Attachments and long pasted text are summarized in brackets. Under each prompt is a summary
of the response. Every question asked back is quoted exactly, with its options, under **Asked:**. System messages are
left out. Prompts are numbered in order.

---

## Analysis

### What worked
1. **[Short bold claim (prompt numbers).]** Evidence from the session, quoting the user where it helps.

### What didn't
1. **[Short bold claim (prompt numbers).]** What happened, the cost, and a **Lesson:** where there is one.

### Insights
1. **[A lesson that generalizes beyond this session]:** for the skills, the methodology, a persona or
   capability, or future intakes.

---

## Session

### `/command` (start time to end time)

**1.**
> [the prompt, exactly as written]

[Summary of the response: what was read, decided, written, recommended. Past tense, plain, 1–5 lines or a short list.]

**Asked:**
> [the question, exactly as asked, with its options and recommendation]
```

### Rules

- **Prompts are verbatim.** Copy them from the condensed file character for character, including typos, doubled
  spaces and run-ons. Never fix or trim them. Strip only the harness wrappers, which the script already removes.
- **Attachments and long pastes are summarized**, not quoted: `[Pasted: the GM's 3-page house-rules doc, covering
  initiative, crits and downtime]`. A short paste (under about 1,500 characters) can be quoted if it matters.
- **Responses are summarized.** Say what was done and found, not how. Name files by path. Don't quote the response,
  except for a line the analysis relies on.
- **Questions are quoted exactly**, with their options and the recommendation. Copy the whole question block from the
  reply, including the question's bold markup. If a reply asked nothing, there is no **Asked:** line.
  Large drafted tables inside a question can be shortened to `[a 9-row table: ...]`, keeping the question text itself
  exact.
- **Mark interruptions and re-sends** in parentheses under the prompt: `(Interrupted by the user before a response.)`
- **Group prompts under a heading per command or phase**, with local start and end times.
- **Use local time** and name the time zone. Check it with `date +%Z`; never assume it.
- **The analysis is honest.** What didn't work includes the assistant's own mistakes: questions built on evidence that
  hadn't been read, recommendations that were reversed, prompts the user had to repeat, slips caught late. Cite prompt
  numbers for every point. Quote the user when they named the problem.
- **Insights generalize.** Each one should change something next time: a skill step, an intake question, a pattern for
  `tracking/patterns-discovered.md`, or a memory.
- **Use they/them** for the user unless their pronouns are stated.

---

## Step 5: Verify

Before reporting:
- the prompt count in the log matches the script's count (apart from the `/retro` prompt itself, which goes last under
  "After the session" when the retro is written in the same conversation);
- spot-check three prompts against the condensed file, character for character;
- every reply that asked something has an **Asked:** block;
- the times are local, with the zone named.

---

## Step 6: Report and Follow Up

Report in a few lines: the file path, the prompt count, and the two or three main points from the analysis.

Then offer, don't do:
- adding any insight to `tracking/patterns-discovered.md`, or as a memory;
- skill changes the retro points to.

`tracking/` is git-ignored, so the retro stays local. Say so if the user may expect it to be committed.
