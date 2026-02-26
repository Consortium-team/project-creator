# /onboard — Existing Companion Analysis

Analyze an existing companion and fill gaps through reverse prompting.

## Usage

```
/onboard                       # Use current companion
/onboard [client/companion]    # Override for specific companion
```

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Determine the Companion

1. If `$ARGUMENTS` contains a companion path, use that
2. Otherwise, read `tracking/current-companion.md` for the current companion
3. If no companion is set and no argument given:
   ```
   No companion set. Use /companion to set one first:
     /companion [client/companion]
   ```

4. Verify the companion directory exists at `companions/[client]/[companion]/`

---

### Step 2: Scan the Companion

Analyze what exists in the companion directory. Look for:

**Configuration Files:**
- `CLAUDE.md` — Project configuration for Claude
- `README.md` — Human documentation
- `.claude/` directory — Commands, skills, agents

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

---

### Step 3: Analyze Against Methodology

Compare what exists against what a well-configured companion needs:

**Configuration Checklist:**
| Item | Status | Notes |
|------|--------|-------|
| CLAUDE.md exists | FOUND / MISSING | |
| CLAUDE.md defines role | FOUND / PARTIAL / MISSING | |
| CLAUDE.md has coding standards | FOUND / PARTIAL / MISSING | |
| README.md exists | FOUND / MISSING | |
| README.md has getting started | FOUND / PARTIAL / MISSING | |
| Commands defined | FOUND / NONE | count if found |
| Skills defined | FOUND / NONE | count if found |

**Context Checklist:**
| Item | Status | Notes |
|------|--------|-------|
| Purpose documented | FOUND / PARTIAL / MISSING | |
| Users identified | FOUND / PARTIAL / MISSING | |
| Success criteria defined | FOUND / PARTIAL / MISSING | |
| Technical constraints captured | FOUND / PARTIAL / MISSING | |
| Key decisions documented | FOUND / PARTIAL / MISSING | |

---

### Step 4: Generate Report

Present findings in this format:

```
## Onboard Analysis: [companion]

### FOUND
- [list what exists and is well-documented]
- [include specific files and what they cover]

### PARTIAL
- [items that exist but are incomplete]
- [what's there vs. what's missing]

### MISSING
- [items that don't exist or aren't documented]
- [prioritized by importance]

### RECOMMENDATIONS
1. [highest priority gap to fill]
2. [second priority]
3. [etc.]

---

Would you like to start filling these gaps? I'll use reverse prompting to capture what's missing without re-asking about what already exists.
```

---

### Step 5: Fill Gaps (If User Agrees)

If user wants to proceed:

1. **Don't re-capture existing context** — Reference what's already documented
2. **Target specific gaps** — Ask only about what's missing
3. **One question at a time** — Same as `/intake`

For each gap area:

```
I see [what exists] is already documented.

What's missing is [specific gap]. Let me ask about that:

[targeted question about the gap]
```

---

### Step 6: Write to Context Files

Create or update context files in `companions/[client]/[companion]/context/`:

- If context files don't exist, create them
- If they exist, append or update (don't overwrite existing good content)
- Mark new content with `## Added via /onboard [date]` if appending

---

### Step 7: Update Companion Status

If the companion was newly onboarded:

1. **Add to `tracking/projects-log.md`** if not already there
   - Status: `seeding`
   - Note: "Onboarded existing companion"

2. **Update `tracking/current-companion.md`** if this should be current

---

### Step 8: Summarize

```
## Onboard Complete: [companion]

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

## Key Principle

The user cloned this companion for a reason — they have context about it. Your job is to:

1. **See what's there** — Don't assume it's undocumented
2. **Identify true gaps** — Not everything needs to be captured
3. **Build on existing work** — Enhance, don't replace
4. **Ask targeted questions** — About gaps, not about what's documented
