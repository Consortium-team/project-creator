---
name: onboard
description: >
  Use when bringing an existing companion up to current standards (re-onboard mode) or when
  converting a native Claude Code project into a Project Creator companion (convert mode).
  Dispatches auditor/analyzer agents, then fills gaps through interactive reverse prompting.
disable-model-invocation: true
argument-hint: "[client/companion]"
---

# /onboard — Existing Companion or Native Project Onboarding

Analyze an existing companion or native Claude Code project and fill gaps through reverse prompting. Two modes:

- **Mode A: Re-onboard existing companion** — Dispatches `companion-auditor` agent to health-check against current standards, then fills gaps interactively
- **Mode B: Convert native project** — Dispatches `project-analyzer` agent to assess persona/capability fit, then fills gaps interactively

**Usage:**
- `/onboard` — Use current companion (defaults to Mode A)
- `/onboard [client/companion]` — Override for specific companion
- After the scan step, the user selects Mode A or Mode B

---

## Step 1: Determine the Companion

1. If `$ARGUMENTS` contains a companion path, use that
2. Otherwise, read `tracking/current-companion.md` for the current companion
3. If no companion is set and no argument given:
   ```
   No companion set. Use /companion to set one first:
     /companion [client/companion]
   ```

4. Verify the companion directory exists at `companions/[client]/[companion]/`

**Determine the organization** from the client portion of the path (e.g., `consortium.team` from `consortium.team/my-companion`).

**Build the accessible kits list** by reading `tracking/permissions.yaml`:
- Always include: `companion-kits/public-kits/`
- Always include: `companion-kits/private-kits/[client]-companion-kit/` (derived from companion path)
- Also include each kit in `always_accessible_private_kits` from permissions.yaml (e.g., `companion-kits/private-kits/[kit-name]/`)

This list determines where to search for personas and capabilities in Mode B.

---

## Step 2: Scan the Companion

Analyze what exists in the companion directory. Look for:

**Configuration Files:**
- `CLAUDE.md` — Project configuration for Claude
- `README.md` — Human documentation
- `.claude/` directory — Commands, skills, agents, hooks, rules

**Documentation:**
- `docs/` directory — Any documentation
- Design docs, specs, plans
- Architecture diagrams or descriptions

**Code Structure:**
- Source directories
- Test directories
- Build/config files

**Context (if using Project Creator structure):**
- `context/requirements.md`
- `context/constraints.md`
- `context/decisions.md`

Present a brief scan summary:
```
## Scan Results: [companion]

**Configuration:** [what was found]
**Documentation:** [what was found]
**Code structure:** [what was found]
**Context files:** [what was found]
```

---

### Compliance Checkpoint 1

**Before proceeding, confirm the scan is complete:**
```
Scan complete for [companion].

This project appears to be:
  A) An existing Project Creator companion (has context/ files, companion-kit structure)
  B) A native Claude Code project (has .claude/ config but not companion structure)

Which mode should I use?
  A) Re-onboard — Health-check against current companion standards
  B) Convert — Analyze for conversion to a Project Creator companion
```

**STOP and wait for user to select Mode A or Mode B.**

---

## Mode A: Re-onboard Existing Companion

### Step 3A: Dispatch Companion Auditor

Read the agent definition at `.claude/agents/companion-auditor.md`.

**Build the agent prompt:**

```
You are auditing an existing companion project against current standards.

## Input

- Companion directory: [absolute path to companions/client/companion]
- Companion name: [client/companion]

Perform a full audit following your process definition. Analyze configuration surface,
directory structure, CLAUDE.md health, skill structure, agent definitions, hooks, and rules.

Generate the structured audit report as defined in your output format.
```

**Invoke the `companion-auditor` agent** (Sonnet, read-only tools, skills: companion-standards).

---

### Step 4A: Present Audit Findings

After the agent returns, present its structured report to the user:

```
## Audit Report: [companion]

[Agent's structured findings — overall health, FOUND, PARTIAL, MISSING, WRONG_LOCATION, prioritized recommendations]

---

Would you like to proceed with filling the identified gaps?
I'll use reverse prompting to capture what's missing without re-asking about what already exists.
```

### Compliance Checkpoint 2A

**STOP and wait for user approval before proceeding to gap-filling.**

The user may want to:
- Proceed with gap-filling (continue to Step 5)
- Address specific findings first
- Stop here and use the report as-is

---

## Mode B: Convert Native Project

### Step 3B: Gather Conversion Context

Before dispatching the analyzer, gather available personas and capabilities:

1. **Scan available personas** across all accessible kit directories (from Step 1):
   - `companion-kits/public-kits/personas/*/PERSONA.md`
   - `companion-kits/private-kits/[kit]/personas/*/PERSONA.md` for each kit in the accessible kits list

2. **Scan available capabilities** across all accessible kit directories (from Step 1):
   - `companion-kits/public-kits/capabilities/*/CAPABILITY.md`
   - `companion-kits/private-kits/[kit]/capabilities/*/CAPABILITY.md` for each kit in the accessible kits list

3. Build lists with brief descriptions for each.

### Step 4B: Dispatch Project Analyzer

Read the agent definition at `.claude/agents/project-analyzer.md`.

**Build the agent prompt:**

```
You are analyzing a native Claude Code project for conversion into a Project Creator companion.

## Input

- Project directory: [absolute path to companions/client/companion]
- Project name: [client/companion]
- Organization: [org]

## Available Personas
[List each persona with brief description from PERSONA.md]

## Available Capabilities
[List each capability with brief description from CAPABILITY.md]

Perform a full analysis following your process definition. Deep scan the project, map
current state, assess persona fit, recommend capabilities, plan migration, and assess risks.

Generate the structured analysis report as defined in your output format.
```

**Invoke the `project-analyzer` agent** (Opus, read-only tools, skills: companion-standards).

---

### Step 5B: Present Analysis and Recommendations

After the agent returns, present its findings:

```
## Project Analysis: [companion]

**Project Type:** [from agent report]
**Conversion Complexity:** [from agent report]

**Persona Recommendation:** [persona name]
[Rationale]

**Capability Recommendations:**
- Core: [list]
- Recommended: [list]
- Optional: [list]

**Migration Plan:**
[Numbered steps from agent]

**Risk Assessment:**
[Key risks from agent]

---

Does this analysis look right? Should I proceed with creating the companion context
based on these recommendations?
```

### Compliance Checkpoint 2B

**STOP and wait for user approval before proceeding to gap-filling.**

The user may want to:
- Accept recommendations and proceed (continue to Step 5)
- Modify persona or capability selections
- Stop here and use the analysis as-is

If the user accepts, record the persona and capability decisions in `context/decisions.md`:
```markdown
| Persona: [name] | Recommended by project-analyzer based on [evidence] | [date] |
| Capabilities: [list] | Selected during conversion from native project | [date] |
```

---

## Step 5: Fill Gaps (Interactive — Both Modes)

If the user agrees to proceed with gap-filling:

1. **Don't re-capture existing context** — Reference what's already documented
2. **Target specific gaps** — Ask only about what's missing based on the audit/analysis report
3. **One question at a time** — Same reverse prompting discipline as `/intake`

For each gap area:

```
I see [what exists] is already documented.

What's missing is [specific gap]. Let me ask about that:

[targeted question about the gap]
```

**Work through gaps in priority order** from the audit (Mode A) or analysis (Mode B) report.

**Key areas to cover if missing:**
- Purpose — What problem does this solve? Why does it matter?
- Users — Who uses this? What do they need?
- Success criteria — How will we know it's working?
- Constraints — Technical, time, resource, organizational
- Context — Related systems, existing patterns
- The quality — What makes this distinct?

---

## Step 6: Write to Context Files

Create or update context files in `companions/[client]/[companion]/context/`:

- If context files don't exist, create them
- If they exist, append or update (don't overwrite existing good content)
- Mark new content with `## Added via /onboard [date]` if appending

**Standard context files:**
- `context/requirements.md` — What the companion must do
- `context/constraints.md` — Boundaries and limitations
- `context/decisions.md` — Choices made and rationale

---

### Compliance Checkpoint 3

**After writing context files, confirm with the user:**
```
Context files updated. Here's what was written:

- context/requirements.md — [summary of additions]
- context/constraints.md — [summary of additions]
- context/decisions.md — [summary of additions]

Does this look accurate? Any corrections needed before we proceed?
```

**STOP and wait for user confirmation.**

---

## Step 7: Update Companion Status

If the companion was newly onboarded:

1. **Add to `tracking/projects-log.md`** if not already there
   - Status: `seeding`
   - Note: "Onboarded existing companion" (Mode A) or "Converted native project" (Mode B)

2. **Update `tracking/current-companion.md`** if this should be current

---

## Step 8: Summarize

```
## Onboard Complete: [companion]

**Mode:** [Re-onboard / Convert]

**Analyzed:**
- [count] configuration files
- [count] documentation files
- [count] source directories

**Gaps Filled:**
- [what was captured]

**Remaining Gaps:**
- [what still needs work]

**Next Steps:**
  /gaps      — See full assessment
  /intake    — Continue capturing context
  /process   — Feed in additional documents
  /checkpoint — Save session state
```

---

## Key Principles

- **See what's there** — Don't assume it's undocumented
- **Identify true gaps** — Not everything needs to be captured
- **Build on existing work** — Enhance, don't replace
- **Ask targeted questions** — About gaps, not about what's documented
- **Gate on approval** — Never proceed past analysis without user consent
