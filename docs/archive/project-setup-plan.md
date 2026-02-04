# Project Setup Plan: Project Creator

## Executive Summary

Project Creator is a Claude Code meta-project that creates other Claude Code projects through reverse prompting. The key insight is that **requirements and design knowledge live in the user's head** — the LLM's job is to draw it out systematically, not generate it.

**Core Function:** Transform ambiguous project ideas into well-configured Claude Code projects with appropriate CLAUDE.md, README.md, commands, and initial structure.

**Usage Pattern:**
- Point Cowork task or Claude Code session at Project Creator directory
- Sub-projects created in git-ignored subdirectories, organized by client
- Shared directory means both Cowork and Claude Code see full context
- Sub-project eventually graduates to independent Claude Code project

---

## Phase 1: Understanding the Domain

### 1.1 The Three Phases of Reverse Prompting

From `llm-workflow-methodology.md`:

| Phase | Focus | What Happens |
|-------|-------|--------------|
| **Seeding** | Capture | LLM asks questions to draw out raw material — requirements, constraints, context |
| **Cultivation** | Develop | LLM provides prompts to develop and connect fragments, resolve ambiguity |
| **Shaping** | Generate | LLM structures answers into artifacts (CLAUDE.md, README, commands, etc.) |

**This ticket covers Seeding phase commands only.** Cultivation and Shaping commands will come later.

### 1.2 The Parent-Child Pattern

From `llm-workflow-methodology.md` (Meta-Project Patterns):

```
project-creator/
├── CLAUDE.md                    # Parent configuration
├── .gitignore                   # Contains: projects/
└── projects/                    # Git-ignored; sub-projects live here
    ├── [client-a]/
    │   ├── [project-1]/         # Independent git repo
    │   └── [project-2]/
    └── [client-b]/
        └── [project-3]/
```

**Key principles:**
1. **Git isolation** — `projects/` folder is git-ignored; sub-projects have independent repos
2. **Client grouping** — Projects organized by client
3. **CLAUDE.md at root** — Parent ignores child CLAUDE.md files when working at parent level
4. **Context separation** — When working IN a sub-project, only sub-project context applies

### 1.3 Reference Implementation Patterns

From `case-study-writing-companion.md`:

| Writing Companion | Project Creator Equivalent |
|-------------------|---------------------------|
| `/capture` — guided conversation to extract life material | `/intake` — guided conversation to extract project requirements |
| `/seed` — generate prompts from captured material | (Cultivation phase — future) |
| `/harvest` — end-of-session capture | `/checkpoint` — session state capture |
| Anchor files with "quality extraction" | Project context files with requirement extraction |

The Writing Companion evolved commands through use (v1 → v4). Project Creator should expect similar evolution.

---

## Phase 2: Proposed Architecture

### 2.1 Directory Structure

```
project-creator/
├── CLAUDE.md                    # Project Creator configuration
├── README.md                    # Workflow guide for humans
├── methodology.md               # Copy of llm-workflow-methodology.md
├── tracking/
│   ├── current-project.md       # Format: client/project-name
│   ├── projects-log.md          # What projects have been created, their status
│   └── patterns-discovered.md   # Learnings that should become templates
├── templates/                   # Project archetypes (emerges over time)
├── .gitignore                   # Contains: projects/
├── .claude/
│   └── commands/
│       ├── project.md           # Set/show/create current project context
│       ├── intake.md            # Seeding: new project via reverse prompting
│       ├── onboard.md           # Seeding: existing project analysis + gap filling
│       ├── process.md           # Seeding: analyze external inputs
│       ├── gaps.md              # Seeding: assess what's captured vs. needed
│       └── checkpoint.md        # Seeding: session capture
└── projects/                    # Git-ignored; organized by client
    └── [client]/
        └── [project]/           # Independent git repo
```

### 2.2 Commands (Seeding Phase)

| Command | Purpose | Modeled After |
|---------|---------|---------------|
| `/project` | Set/show/create current project context | Git branch pattern |
| `/intake` | New project via reverse prompting | Writing Companion `/capture` |
| `/onboard` | Analyze existing project + fill gaps | Methodology "onboard vs intake" pattern |
| `/process` | Analyze external inputs (transcripts, docs) | Writing Companion input processing |
| `/gaps` | Assess what's captured vs. what's needed | Quality check before proceeding |
| `/checkpoint` | Session state capture | Writing Companion `/harvest` |

**All commands:** Accept optional `[client/project]` parameter; use current if not specified.

### 2.3 Skills

**None for v1.** The reverse prompting methodology lives in CLAUDE.md and methodology.md. Skills can emerge through use if we find reusable patterns that benefit from skill encapsulation.

### 2.4 Sub-agents

**None for v1.** Reverse prompting is inherently conversational and sequential. Sub-agents would be useful for parallelizable tasks, but that's not the nature of this work.

---

## Phase 3: Key Files to Create

### Configuration Files

1. **CLAUDE.md** — Master configuration
   - Define the role (collaborator, reverse prompting heavy, critical and creative)
   - Describe the parent-child pattern
   - Define the three phases (seeding focus for now)
   - Reference methodology.md for deep patterns

2. **README.md** — Human workflow guide
   - Quick start: how to begin a session
   - Command reference with examples
   - Directory structure explanation
   - When to use `/intake` vs `/onboard`

3. **methodology.md** — Copy of `llm-workflow-methodology.md`
   - Full reference for reverse prompting patterns
   - Failure recovery patterns
   - Meta-project patterns

### Tracking Files

4. **tracking/current-project.md** — Simple state file
   - Contains: `client/project-name`
   - Updated by `/project` command

5. **tracking/projects-log.md** — Project registry
   - What projects have been created
   - Current status (seeding, cultivation, shaping, graduated)
   - Key decisions made

6. **tracking/patterns-discovered.md** — Evolution log
   - Learnings from using the system
   - Patterns that should become templates
   - Command improvements identified

### Commands

7. **`.claude/commands/project.md`**
   ```
   /project                              # Show current + list all
   /project [client/project]             # Set current
   /project new [client/project]         # Create and set as current
   ```

8. **`.claude/commands/intake.md`** — Reverse prompting for new projects
   - Ask questions one at a time
   - Draw out: purpose, users, constraints, success criteria
   - Create initial project structure
   - Populate context files with captured requirements

9. **`.claude/commands/onboard.md`** — Analyze existing projects
   - User must `git clone` existing project first
   - Analyze what exists against methodology
   - Produce report: FOUND / MISSING / RECOMMENDATIONS
   - Target gaps specifically via reverse prompting

10. **`.claude/commands/process.md`** — Handle external inputs
    - Accept transcripts, documents, notes
    - Extract structured requirements
    - Update project context files

11. **`.claude/commands/gaps.md`** — Assessment
    - Review captured context against methodology checklist
    - Identify what's missing or unclear
    - Prioritize what to capture next

12. **`.claude/commands/checkpoint.md`** — Session capture
    - Summarize what was captured this session
    - Update tracking files
    - Identify next steps
    - Prepare for potential context loss

### Infrastructure

13. **.gitignore** — Must include `projects/`

14. **templates/** — Empty directory (emerges over time)

---

## Phase 4: Design Decisions

### Resolved

1. **Project reference format:** `client/project-name`
   - Matches directory structure
   - Clear hierarchy
   - Example: `acme-corp/sample-project`

2. **Current project storage:** Markdown file (`tracking/current-project.md`)
   - Consistency with other tracking files
   - Can include additional context if needed later

3. **Methodology reference:** Copy, not symlink
   - Self-contained project
   - Can annotate/extend for project-creator-specific notes

4. **Command parameter pattern:** Optional `[client/project]` override
   - Use current if not specified
   - Explicit override when needed
   - Mirrors git's path behavior

### To Discover Through Use

5. **Sub-project initialization:** What files should `/project new` create?
   - Minimal: just directory + .git
   - Or: scaffold with empty CLAUDE.md, README.md?
   - Will discover through first uses

6. **Template emergence:** When do patterns become templates?
   - Track in `patterns-discovered.md`
   - Formalize when pattern appears 3+ times

7. **Graduation criteria:** When is a sub-project ready to leave?
   - Has CLAUDE.md, README.md, commands
   - Has been validated through use
   - Will define more precisely through experience

---

## Phase 5: How a Session Works

### Starting a New Project

```
# Point Claude Code at project-creator directory
cd project-creator

# Create new project context
/project new acme-corp/sample-project

# Start reverse prompting
/intake

# (Claude asks questions one at a time, captures answers)

# Process any external inputs
/process [paste transcript or path to doc]

# Check what's still needed
/gaps

# End session
/checkpoint
```

### Onboarding an Existing Project

```
# Clone existing project into projects/
git clone <repo> projects/acme-corp/existing-api

# Set as current
/project acme-corp/existing-api

# Analyze and fill gaps
/onboard

# (Claude analyzes, reports findings, asks to fill gaps)

# End session
/checkpoint
```

### Continuing Work

```
# Set current project
/project acme-corp/sample-project

# Check where we left off
/gaps

# Continue reverse prompting or process new inputs
/intake  # or /process

# End session
/checkpoint
```

---

## Success Criteria

- [ ] CLAUDE.md clearly describes the pattern and role
- [ ] README.md is usable by a human starting a session
- [ ] `/project` correctly handles client/project hierarchy
- [ ] `/intake` draws out requirements through reverse prompting
- [ ] `/onboard` analyzes existing projects and fills gaps
- [ ] `/process` handles transcripts and extracts structured content
- [ ] `/gaps` identifies meaningful gaps
- [ ] `/checkpoint` captures session state usefully
- [ ] All commands respect current project context
- [ ] First test produces a seeded sub-project

---

## First Test

After initial build:

```
/project new acme-corp/sample-project
/intake
/process [transcripts]
/gaps
/checkpoint
```

This validates the full seeding workflow.
