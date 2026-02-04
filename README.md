# Project Creator

Create well-configured Claude Code projects through guided conversation.

---

## Quick Start

### Starting a New Project

```bash
# Point Claude Code at this directory
cd project-creator

# Create a new project
/project new consortium.team/presentation-workflow

# Start the intake conversation
/intake

# (Answer questions as Claude draws out your requirements)

# Check what's still needed
/gaps

# End your session
/checkpoint
```

### Onboarding an Existing Project

```bash
# Clone your existing project into projects/
git clone <repo-url> projects/acme-corp/existing-api

# Set it as current
/project acme-corp/existing-api

# Analyze and fill gaps
/onboard
```

### Continuing Work

```bash
# Set your project
/project consortium.team/presentation-workflow

# See where you left off
/gaps

# Continue capturing
/intake

# End session
/checkpoint
```

---

## Commands

### `/project` — Manage Project Context

| Usage | What It Does |
|-------|--------------|
| `/project` | Show current project and list all projects |
| `/project client/name` | Set current project (must exist) |
| `/project new client/name` | Create new project and set as current |

**Examples:**
```
/project                                    # What am I working on?
/project consortium.team/writing-companion  # Switch to this project
/project new 7tworld/api-refactor          # Start a new project
```

### `/intake` — New Project Reverse Prompting

Starts a guided conversation to capture project requirements. Claude asks questions one at a time about:

- **Purpose** — What problem does this solve?
- **Users** — Who will use this?
- **Success criteria** — How will we know it works?
- **Constraints** — Technical, time, organizational limits
- **Context** — Related systems, prior art

Captured information is written to `[project]/context/` files.

### `/onboard` — Existing Project Analysis

For projects that already exist. Claude:

1. Analyzes what's there (CLAUDE.md, README, commands, etc.)
2. Reports what's FOUND vs MISSING
3. Asks before filling gaps
4. Uses reverse prompting to capture what's missing

**Prerequisite:** Clone/copy the project into `projects/[client]/[name]/` first.

### `/process` — Handle External Inputs

Feed in transcripts, documents, or notes. Claude extracts:

- Requirements mentioned
- Constraints identified
- Decisions implied
- Questions raised

Updates project context files with structured information.

**Usage:**
```
/process
(paste your transcript or notes)

/process path/to/document.md
```

### `/gaps` — Assessment

Checks captured context against what's needed for a complete project:

- Is the purpose clear?
- Are users identified?
- Are success criteria defined?
- Are constraints captured?
- Are key decisions documented?

Reports gaps with priorities and suggests what to capture next.

### `/checkpoint` — Session Capture

Run before ending a session. Claude:

1. Summarizes what was captured
2. Updates tracking files
3. Notes patterns discovered
4. Identifies next steps
5. Prepares handoff notes

---

## Directory Structure

```
project-creator/
├── CLAUDE.md           # Configuration for Claude
├── README.md           # This file
├── methodology.md      # Deep reference on reverse prompting
├── tracking/
│   ├── current-project.md      # Which project is active
│   ├── projects-log.md         # Registry of all projects
│   └── patterns-discovered.md  # Learnings for future use
├── templates/          # Project templates (emerges over time)
├── docs/               # Planning documents
└── projects/           # Sub-projects (git-ignored)
    └── [client]/
        └── [project]/  # Each has its own git repo
```

### Sub-Project Structure

When you create a project, it gets:

```
projects/client/project/
├── .git/               # Independent git repo
└── context/
    ├── requirements.md # Captured requirements
    ├── constraints.md  # Technical and business constraints
    └── decisions.md    # Decisions made during intake
```

As the project matures through seeding, it will eventually have CLAUDE.md, README.md, commands, etc.

---

## When to Use What

| Situation | Command |
|-----------|---------|
| Starting fresh with an idea | `/project new` then `/intake` |
| Have an existing codebase | Clone it, then `/onboard` |
| Have meeting notes or transcripts | `/process` |
| Want to see what's missing | `/gaps` |
| Ending a work session | `/checkpoint` |
| Switching between projects | `/project client/name` |

---

## The Three Phases

Project creation happens in phases:

| Phase | Focus | When You're Here |
|-------|-------|------------------|
| **Seeding** | Capture requirements and context | Starting out — this is where `/intake` lives |
| **Cultivation** | Develop requirements, resolve ambiguity | Have raw material, need to refine |
| **Shaping** | Generate artifacts, validate | Ready to create CLAUDE.md, commands, etc. |

This version of Project Creator focuses on **Seeding**. Cultivation and Shaping commands will come later.

---

## Tips

1. **Answer naturally** — Don't try to structure your answers. Claude will extract and organize.

2. **It's okay to not know** — "I'm not sure yet" is a valid answer. It helps identify gaps.

3. **Use `/process` liberally** — Meeting transcripts, slack conversations, existing docs — feed them in.

4. **Run `/gaps` often** — It shows you where you are and what's next.

5. **Always `/checkpoint`** — Context can be lost. Checkpoints preserve progress.

6. **Projects evolve** — The first pass won't be perfect. That's expected.
