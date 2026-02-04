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

### Step 2: Load Ticket Data and Check for Prior Progress

**Prefer local tickets.yaml:**

1. Check for `projects/[client]/[project]/docs/plans/tickets.yaml`
2. If exists, parse ticket data from there (more reliable than Linear markdown)
3. If not exists, fall back to reading from Linear (see Legacy Linear section below)
4. Load the spec file path from tickets.yaml metadata

**Check for prior progress:**

Check `projects/[client]/[project]/docs/plans/build-progress.md` for prior progress:
- If some tickets show `completed`, skip them
- Resume from first `pending` ticket
- Report: "Resuming build from ticket #N (tickets 1-M already complete)"

**tickets.yaml structure:**

```yaml
project:
  name: [project name]
  path: [absolute path to project directory]
  spec: [relative path to implementation spec]

tickets:
  - id: 1
    title: [ticket title]
    description: |
      [full description]
    acceptance_criteria:
      - [criterion 1]
      - [criterion 2]
    input_files:
      - [relative path]
    output_files:
      - [relative path]
    dependencies: []  # list of ticket IDs this depends on
    status: pending   # pending, in_progress, completed, skipped
  - id: 2
    ...
```

**If no tickets.yaml exists:**

Look for a plan file at `projects/[client]/[project]/docs/plans/*-implementation-spec.md`

If no spec exists:
```
No implementation plan found for [project].

Run /plan first to create tickets from your requirements.
```

**Legacy Linear fallback:**

Use the Linear MCP tools to find the project:
1. Call `mcp__linear__linear_getProjects` to list projects
2. Find the project matching this build (by name or stored project ID in the spec)
3. Call `mcp__linear__linear_getProjectIssues` to get all issues

If no Linear project or no tickets found:
```
No tickets found for [project].

Check that /plan completed successfully and created tickets.
```

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

#### 5c. Invoke Ticket Executor Agent

Invoke the `ticket-executor` agent with:

**Project Directory:** [absolute path from tickets.yaml]
**Implementation Spec:** [spec path from tickets.yaml]
**Ticket:** [title]
**Description:** [full description]
**Acceptance Criteria:**
[list from tickets.yaml]
**Input Files:**
[list from tickets.yaml]
**Output Files:**
[list from tickets.yaml]

Wait for executor to complete and return its execution report.

#### 5d. Invoke Ticket Verifier Agent

Invoke the `ticket-verifier` agent with:

**Project Directory:** [absolute path]
**Acceptance Criteria:**
[list from tickets.yaml]
**Expected Output Files:**
[list from tickets.yaml]
**Executor Report:**
[paste executor's execution report]

Wait for verifier response.

#### 5e. Handle Verifier Results

Based on verifier recommendation:

- **PROCEED:** Continue to next ticket
- **RETRY:**
  1. Pass verifier's issues to executor
  2. Re-run executor with: "Previous attempt had issues: [verifier feedback]. Fix these specific problems."
  3. Re-run verifier
  4. Max 2 retries, then escalate
- **ESCALATE:** Stop and present issues to user

#### 5f. Update Local Progress

After each ticket completes:

Update `projects/[client]/[project]/docs/plans/build-progress.md`:
- Change ticket status from `pending` to `completed`
- Add timestamp
- Log any issues that were resolved

This enables recovery if context is lost mid-build.

**build-progress.md format:**

```markdown
# Build Progress

**Started:** [timestamp]
**Last Updated:** [timestamp]

## Tickets

| # | Title | Status | Completed At | Notes |
|---|-------|--------|--------------|-------|
| 1 | [Title] | completed | 2024-01-15 10:30 | |
| 2 | [Title] | completed | 2024-01-15 10:45 | Retry needed - missing import |
| 3 | [Title] | pending | | |
...

## Issues Resolved

- Ticket #2: Missing import statement, fixed on retry
```

Also report progress:
```
Ticket [#]/[total] complete: [Title]
- Files created: [list]
- Files modified: [list]
```

Optionally add a comment to the Linear ticket noting completion (if using Linear).

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

---

## Key Principles

### Stay Lightweight

The orchestrator (this main conversation) should:
- Dispatch work to executor agent
- Dispatch verification to verifier agent
- Handle failures and retries
- Track progress locally

The orchestrator should NOT:
- Do implementation work itself
- Read and analyze code in detail
- Make architectural decisions during build

### Agent Separation

- **Executor:** Implements the ticket, creates/modifies files
- **Verifier:** Checks that implementation meets acceptance criteria
- **Orchestrator:** Coordinates, tracks progress, handles failures

This separation ensures:
- Clear responsibility boundaries
- Independent verification
- Reliable retry logic

### Context Isolation

Each agent invocation gets:
- Fresh context window
- ALL necessary information in the prompt
- No assumptions about what they "know"

This means prompts must be self-contained with full paths and complete descriptions.

### Sequential by Default

Execute tickets one at a time. This:
- Ensures dependencies are respected
- Makes debugging easier
- Prevents file conflicts

Parallel execution is a future optimization — don't attempt it now.

### Verify Before Proceeding

Never assume a ticket completed successfully. The verifier agent must confirm:
- Output files exist and have expected content
- Acceptance criteria are met
- No errors were encountered

---

## Error Reference

| Situation | Response |
|-----------|----------|
| No tickets.yaml or spec | "Run /plan first" |
| No tickets found | "No tickets found - check plan output" |
| Executor timeout | Retry once, then escalate |
| Verifier returns RETRY | Retry with feedback, max 2 times |
| Verifier returns ESCALATE | Present issues to user |
| User aborts | Summarize progress, suggest next steps |
| Resuming partial build | Skip completed tickets, start from first pending |

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
