# /build — Execute Implementation Plan

Orchestrate sub-agents to execute tickets and build the project.

## Usage

```
/build                     # Use current project
/build [client/project]    # Override for specific project
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

Store the project path (e.g., `acme-corp/api-service`) and the full directory path (`projects/[client]/[project]/`).

---

### Step 2: Load Ticket Data and Validate Schema

**Load tickets.yaml:**

1. Check for `projects/[client]/[project]/docs/plans/tickets.yaml`
2. If not exists, STOP:
   ```
   No tickets.yaml found for [project].
   Run /plan first to create tickets.
   ```
3. Parse the file and extract:
   - `project_path` — absolute path to project directory
   - `spec_file` — relative path to implementation spec
   - `linear_parent_issue` — parent Linear issue
   - `tickets` — list of ticket objects

**Validate schema (MANDATORY — do not skip):**

Check that tickets.yaml has the required structure. For each ticket, verify these fields exist:

| Field | Check |
|-------|-------|
| `id` | integer (1, 2, 3...) |
| `title` | non-empty string |
| `status` | one of: pending, in_progress, completed, skipped |
| `blocked_by` | list (may be empty) |
| `description` | non-empty string |
| `input_files` | list (may be empty) |
| `output_files` | list with at least one entry |
| `acceptance_criteria` | list with at least one entry |

Also verify top-level fields exist:
- `project_path` — must be an absolute path that exists on disk
- `spec_file` — must point to a file that exists

**If validation fails, STOP:**
```
## tickets.yaml Schema Validation Failed

Missing or malformed fields:
- [list each problem]

Fix tickets.yaml or re-run /plan to regenerate it.
```

**Do NOT proceed with a malformed tickets.yaml.** This is the #1 cause of silent build failures.

**Declare collected values:**
```
Step 2 Complete. Loaded ticket data:
- Project path: [project_path value]
- Spec file: [spec_file value]
- Linear parent: [linear_parent_issue value]
- Total tickets: [N]
- Schema validation: PASSED
```

**Check for prior progress:**

Check `projects/[client]/[project]/docs/plans/build-progress.md` for prior progress:
- If some tickets show `completed`, verify those output files still exist on disk
- If output files exist, skip those tickets
- If output files are missing despite "completed" status, reset those tickets to `pending`
- Resume from first `pending` ticket
- Report: "Resuming build from ticket #N (tickets 1-M already complete and verified)"

---

### Step 3: Build Execution Order

From the tickets (yaml or Linear):

1. **Identify all tickets** — These are the actual work items to execute
2. **Parse dependencies** — Check `dependencies` field (yaml) or `blockedBy` relationships (Linear)
3. **Build execution order** using topological sort:
   - Tickets with no dependencies come first
   - Tickets are ordered so dependencies are completed before dependents
   - Identify tickets at the same "depth" that could theoretically run in parallel

Create an ordered list of tickets to execute.

---

### Step 4: Present Execution Plan and Confirm

Display the plan for user review:

```
## Build Plan: [project]

**Source:** [tickets.yaml | Linear]
**Tickets to execute:** [N]
**Previously completed:** [N] (if resuming)

### Execution Order

| # | Ticket | Dependencies | Status |
|---|--------|--------------|--------|
| 1 | [Title] | None | pending |
| 2 | [Title] | After #1 | pending |
| 3 | [Title] | After #1 | pending |
| 4 | [Title] | After #2, #3 | pending |
...

**Estimated context sessions:** [N] (one per ticket)

---

Proceed with build? (yes/no)
```

**Wait for explicit user confirmation before proceeding.**

If user says no, ask what they'd like to adjust.

**After user confirms, set parent ticket to In Progress:**

If `linear_parent_issue` exists in tickets.yaml, update it to "In Progress":

1. Get the "In Progress" state ID from workflow states (using `mcp__linear__linear_getWorkflowStates`)
2. Update the parent issue: `mcp__linear__linear_updateIssue` with `id: [linear_parent_issue]` and `stateId: [in_progress_state_id]`

```
Build started — [linear_parent_issue] → In Progress
```

---

### Step 5: Execute Tickets Sequentially

For each ticket in the execution order:

#### 5a. Announce the Ticket

```
---
## Executing Ticket [#]/[total]: [Title]
---
```

#### 5b. Read Full Ticket Details

**From tickets.yaml:**
- Title, description, acceptance criteria
- Input files and output files
- Any additional context

**From Linear (fallback):**
Use `mcp__linear__linear_getIssueById` with the ticket ID to get:
- Full title
- Complete description
- Acceptance criteria
- Any comments with additional context

#### 5b-ii. Update Linear Status to In Progress

If the ticket has a `linear_id`, update its status to "In Progress":

1. Get the team's workflow states using `mcp__linear__linear_getWorkflowStates` (team ID from prior lookup)
2. Find the state ID for "In Progress"
3. Update the issue: `mcp__linear__linear_updateIssue` with `id: [linear_id]` and `stateId: [in_progress_state_id]`

```
Ticket [#]: [Title] — Linear status → In Progress
```

#### 5c. Invoke Ticket Executor Agent

**This step uses the Task tool to spawn a real subagent. Do NOT simulate or reason about what the agent would do.**

**Step 5c-i: Read the agent definition**

Read `.claude/agents/ticket-executor.md`. Extract from frontmatter:
- `model:` — the model to use (e.g., opus)
- `tools:` — available tools (for reference)

**Step 5c-ii: Build the complete prompt**

Construct the full prompt with ALL actual values filled in. No placeholders.

```
You are the ticket-executor agent. Your job is to implement a single ticket.

## Project Context

**Project Directory:** [ACTUAL absolute path from project_path]
**Implementation Spec:** [ACTUAL absolute path: project_path + "/" + spec_file]

## Ticket: [ACTUAL title from tickets.yaml]

**Description:**
[ACTUAL description from tickets.yaml — full text, not a reference]

## Acceptance Criteria

[ACTUAL acceptance_criteria list from tickets.yaml, numbered]
1. [criterion 1]
2. [criterion 2]
...

## Input Files (read these for context)

[ACTUAL input_files from tickets.yaml, as absolute paths: project_path + "/" + each path]
- [absolute path 1]
- [absolute path 2]
...

## Output Files (create or modify these)

[ACTUAL output_files from tickets.yaml, as absolute paths: project_path + "/" + each path]
- [absolute path 1]
...

## Instructions

1. Read the implementation spec for architecture context
2. Read all input files
3. Implement the changes — create/modify the output files
4. Self-check against each acceptance criterion
5. Return your execution report in the format below

## Report Format

Return EXACTLY this format:

**Status:** COMPLETED | PARTIAL | BLOCKED

**Files Created:**
- [absolute path]

**Files Modified:**
- [absolute path]

**Acceptance Criteria Status:**
- [x] [Criterion] — [how it was met]
- [ ] [Criterion] — [why not met]

**Issues Encountered:**
- [any problems]
```

**Step 5c-iii: Show the prompt to the user**

Display the constructed prompt so the user can verify all values are correct.

**Step 5c-iv: Dispatch via Task tool**

```
Task tool call:
  subagent_type: general-purpose
  model: [from agent frontmatter, e.g., "opus"]
  description: "Execute ticket [#]: [short title]"
  prompt: [the complete prompt from step 5c-ii]
```

Wait for the Task tool to return the executor's report.

#### 5d. Invoke Ticket Verifier Agent

**Same pattern: real Task tool dispatch, not simulation.**

**Step 5d-i: Read the agent definition**

Read `.claude/agents/ticket-verifier.md`. Extract `model:` from frontmatter (e.g., sonnet).

**Step 5d-ii: Build the verifier prompt**

```
You are the ticket-verifier agent. You verify that a ticket was correctly implemented. You do NOT make changes — only observe and report.

## Project Directory

[ACTUAL absolute path from project_path]

## Expected Output Files

[ACTUAL output_files as absolute paths]
- [absolute path 1]
...

## Acceptance Criteria

[ACTUAL acceptance_criteria, numbered]
1. [criterion 1]
2. [criterion 2]
...

## Executor's Report

[PASTE the executor's actual report from Step 5c]

## Instructions

1. Check that each expected output file EXISTS on disk (use Glob or Read)
2. Read each file and verify it meets the acceptance criteria
3. Cross-reference the executor's claims against actual file contents
4. Return your verification report

## Report Format

**Status:** PASS | FAIL | PARTIAL

**Files Verified:**
- [path] — EXISTS | MISSING — [notes]

**Acceptance Criteria:**
- [x] [Criterion] — VERIFIED — [evidence]
- [ ] [Criterion] — FAILED — [what's wrong]

**Recommendation:** PROCEED | RETRY | ESCALATE

**Issues Found:**
- [specific problems]
```

**Step 5d-iii: Dispatch via Task tool**

```
Task tool call:
  subagent_type: general-purpose
  model: [from agent frontmatter, e.g., "sonnet"]
  description: "Verify ticket [#]: [short title]"
  prompt: [the complete verifier prompt]
```

#### 5e. Orchestrator File-Existence Check (MANDATORY)

**After the verifier returns, the orchestrator MUST independently verify that output files exist.**

This is a hard guardrail. Even if the verifier says "PASS", check yourself:

```bash
ls -la [project_path]/[output_file_1]
ls -la [project_path]/[output_file_2]
...
```

For EACH output file in the ticket's `output_files` list:
- If file exists and is non-empty → CONFIRMED
- If file is missing or empty → FAIL (regardless of what executor/verifier claimed)

**If any output file is missing:**
```
## Orchestrator Check FAILED

Ticket [#]: [Title]
Executor claimed: COMPLETED
Verifier claimed: PASS
But these files do not exist:
- [missing file 1]
- [missing file 2]

This means the executor simulated the work instead of executing it.
Retrying with explicit instructions...
```

Then retry (see 5f).

#### 5f. Handle Results

Based on verifier recommendation AND orchestrator file check:

- **PROCEED (verifier PASS + all files confirmed):** Continue to next ticket
- **RETRY:**
  1. Pass verifier's issues AND orchestrator's missing files to executor
  2. Re-run executor with: "Previous attempt failed. These specific problems must be fixed: [list]. These files MUST exist on disk after you finish: [list]."
  3. Re-run verifier
  4. Re-run orchestrator file check
  5. Max 2 retries, then escalate
- **ESCALATE:** Stop and present issues to user

#### 5g. Update Local Progress (ONLY after file-existence confirmed)

**NEVER update build-progress.md until Step 5e confirms files exist.**

After each ticket completes AND files are confirmed:

Update `projects/[client]/[project]/docs/plans/build-progress.md`:
- Change ticket status from `pending` to `completed`
- Add timestamp
- Log any issues that were resolved

Update `tickets.yaml`:
- Change the ticket's `status` from `pending` to `completed`

This enables recovery if context is lost mid-build.

Also report progress:
```
Ticket [#]/[total] complete: [Title]
- Files confirmed on disk: [list]
- Issues resolved: [list, if any]
```

**Update Linear status to Done:**

If the ticket has a `linear_id`, update its status to "Done":

1. Get the "Done" state ID from workflow states (cached from earlier lookup)
2. Update the issue: `mcp__linear__linear_updateIssue` with `id: [linear_id]` and `stateId: [done_state_id]`

```
Ticket [#]: [Title] — Linear status → Done
```

---

### Step 6: Handle Failures

If executor or verifier fails:

#### Executor Failure

The implementation agent couldn't complete the ticket.
- Check if ticket is under-specified
- Check if dependencies are actually complete
- Review executor's error output

#### Verifier Failure

Implementation was attempted but doesn't pass verification.
- Review verifier's specific issues
- May need to clarify acceptance criteria
- Check if acceptance criteria are testable

#### Escalation Flow

After max retries, pause and escalate:

```
## Build Paused

**Failed ticket:** [Title] (#[N])

**Failure type:** [Executor | Verifier]

**What happened:**
[Description of the failure - specific issues from executor/verifier]

**Attempts:** [N]/2

---

**Options:**
1. **Provide additional guidance** — I'll pass your instructions to the agent and retry
2. **Skip this ticket** — Mark as blocked, continue (may break dependent tickets)
3. **Abort build** — Stop here and revise the plan

Choose an option (1/2/3):
```

Handle each option:
- **Option 1:** Ask user for guidance, re-run executor with that context, re-run verifier
- **Option 2:** Mark ticket as skipped in build-progress.md, warn about dependent tickets, continue
- **Option 3:** Stop execution, summarize what was completed

---

### Step 7: Complete Build

After all tickets complete (or are skipped):

```
## Build Complete: [project]

**Tickets completed:** [N]/[total]
**Tickets skipped:** [N] (if any)

### Files Created
- [full path to each new file]

### Files Modified
- [full path to each modified file]

### Skipped Tickets (if any)
- [Ticket title] (#N) — [reason]

---

## Next Steps

1. **Review the project** at `projects/[client]/[project]/`
2. **Test the implementation** — Run any commands or workflows
3. **Run /checkpoint** to capture session state

The project is ready for review.
```

**Set parent ticket to Done:**

If `linear_parent_issue` exists, update it to "Done":

1. Get the "Done" state ID from workflow states (cached from earlier lookup)
2. Update the parent issue: `mcp__linear__linear_updateIssue` with `id: [linear_parent_issue]` and `stateId: [done_state_id]`

```
Build complete — [linear_parent_issue] → Done
```

---

### Step 8: Update Reference Projects (if project type was used)

After the build completes, check whether this project was created from a project type:

1. **Check for project type** — Read `context/decisions.md` and look for a "Project type:" entry (recorded by `/intake` Step 2b)
2. **If no type was used** — Skip this step
3. **If a type was used:**

   a. Locate the type's `reference-projects.md`:
      - `project-types/public/[type]/reference-projects.md` or
      - `project-types/private/[type]/reference-projects.md`

   b. If `reference-projects.md` doesn't exist yet, create it using the template from the type's existing files (check TYPE.md or reference-projects.md from another type for the pattern)

   c. Read the built project's key files to extract reference data:
      - `CLAUDE.md` — Configuration and voice
      - `context/decisions.md` — Key decisions with rationale
      - `context/requirements.md` — What was built and why
      - `context/constraints.md` — Constraints that shaped the project

   d. Append a new reference project entry:

   ```markdown
   ## [Project Name]

   **Location:** `projects/[client]/[project]/`
   **Client:** [client name]
   **Status:** Active, newly built

   ### Configuration

   | Dimension | Setting |
   |-----------|---------|
   | [Type-relevant dimension] | [Value] |
   ...

   ### Key Decisions

   1. [Decision] — [Rationale]
   ...

   ### What Works Well

   - [Learnings from the build — what patterns emerged]

   ### Files Worth Studying

   - `[path]` — [Why it's worth reading]
   ...
   ```

   e. If prior reference projects exist, add a comparison section:
   ```markdown
   ### Differences from [Prior Project]

   | Aspect | [Prior] | [This Project] |
   |--------|---------|----------------|
   ...
   ```

4. **Report the update:**
   ```
   Updated reference-projects.md for the [type] project type with [project] as a new reference implementation.
   ```

**Why this matters:** Reference projects are the most valuable part of a project type. Each successful build makes the type better for the next project. This step captures learnings while context is fresh — you'll never have a better view of what worked than right after building it.

---

## Key Principles

### Execute, Don't Simulate

**The #1 failure mode is reasoning about what agents would do instead of dispatching them.**

When this command says "invoke the executor agent", it means:
1. Read the agent definition file
2. Build a complete prompt with actual values
3. Call the Task tool with the correct model
4. Wait for the real result

It does NOT mean: imagine what the agent would produce and write a plausible report.

### Three-Layer Verification

Never trust a single source of truth:
1. **Executor claims** it created files → but maybe it simulated
2. **Verifier confirms** files meet criteria → but maybe it also simulated
3. **Orchestrator checks** files exist on disk → this is the hard truth

All three must pass. The orchestrator file check (Step 5e) is the final gate.

### Stay Lightweight

The orchestrator (this main conversation) should:
- Dispatch work to executor agent via Task tool
- Dispatch verification to verifier agent via Task tool
- Independently verify file existence
- Handle failures and retries
- Track progress locally

The orchestrator should NOT:
- Do implementation work itself
- Read and analyze code in detail
- Make architectural decisions during build

### Agent Separation

- **Executor:** Implements the ticket, creates/modifies files (dispatched via Task tool, model from frontmatter)
- **Verifier:** Checks that implementation meets acceptance criteria (dispatched via Task tool, model from frontmatter)
- **Orchestrator:** Coordinates, tracks progress, verifies file existence, handles failures

### Context Isolation

Each agent invocation gets:
- Fresh context window via Task tool
- ALL necessary information in the prompt (absolute paths, full descriptions)
- No assumptions about what they "know"

This means prompts must be self-contained with full paths and complete descriptions. Never pass placeholder values.

### Sequential by Default

Execute tickets one at a time. This:
- Ensures dependencies are respected
- Makes debugging easier
- Prevents file conflicts

Parallel execution is a future optimization — don't attempt it now.

### Verify Before Proceeding

Never assume a ticket completed successfully:
- Executor report says COMPLETED → verify with verifier
- Verifier report says PASS → verify files exist on disk
- Files exist on disk → NOW mark complete

---

## Error Reference

| Situation | Response |
|-----------|----------|
| No tickets.yaml | "Run /plan first" |
| tickets.yaml schema invalid | "Schema validation failed — list problems, stop" |
| project_path doesn't exist | "Project directory not found — check path" |
| Executor timeout | Retry once, then escalate |
| Verifier returns RETRY | Retry with feedback, max 2 times |
| Verifier returns ESCALATE | Present issues to user |
| Orchestrator file check fails | Retry — executor simulated instead of executing |
| "Completed" tickets missing files | Reset to pending, re-execute |
| User aborts | Summarize progress, suggest next steps |
| Resuming partial build | Verify completed ticket files exist, then resume from first pending |

---

## Progress Tracking

Throughout the build, maintain awareness of:
- Current ticket number / total
- Tickets completed successfully
- Tickets failed or skipped
- Files created/modified

Local tracking in `build-progress.md` enables:
- Recovery from context loss
- Resuming partial builds
- Audit trail of what happened

This enables accurate reporting at completion and helps with failure recovery.
