# Implementation Roadmap

## Overview

This document details the concrete implementation steps for Project Creator. Each phase builds on the previous one.

**Dependency order:**
1. Foundation Files → everything references these
2. Tracking Infrastructure → commands need somewhere to write state
3. Core Command (`/project`) → other commands depend on current project context
4. Seeding Commands → the main workflows
5. First Test → validate the system works

**Estimated effort:** 7-11 hours (from ticket)

---

## Phase 1: Foundation Files (COMPLETED)

Core configuration that defines how Project Creator works.

### 1.1 CLAUDE.md

- [x] Create CLAUDE.md with:
  - [x] Role definition (collaborator, reverse prompting heavy, critical and creative)
  - [x] Parent-child pattern description (ignore child CLAUDE.md at parent level)
  - [x] Three phases overview (seeding, cultivation, shaping) with seeding focus
  - [x] Reference to methodology.md for deep patterns
  - [x] Guidance on how to use commands

### 1.2 README.md

- [x] Create README.md with:
  - [x] Quick start guide (how to begin a session)
  - [x] Command reference with examples
  - [x] Directory structure explanation
  - [x] When to use `/intake` vs `/onboard`
  - [x] Session workflow examples

### 1.3 Methodology Reference

- [x] Copy `llm-workflow-methodology.md` to `methodology.md`
- [x] Add Project Creator-specific header noting this is the reference doc

### 1.4 Git Configuration

- [x] Create `.gitignore` with `projects/` entry
- [x] Initialize git repo (if not already)
- [x] Create `templates/` directory (empty, for future use)

---

## Phase 2: Tracking Infrastructure (COMPLETED)

Files that maintain state across sessions.

### 2.1 Tracking Directory

- [x] Create `tracking/` directory
- [x] Create `tracking/current-project.md` with initial content explaining format
- [x] Create `tracking/projects-log.md` with header and empty table
- [x] Create `tracking/patterns-discovered.md` with header explaining purpose

---

## Phase 3: Core Command — `/project` (COMPLETED)

The foundation command that all other commands depend on.

### 3.1 Command File

- [x] Create `.claude/commands/project.md`
- [x] Implement three modes:
  - [x] No args: Show current project + list all clients/projects
  - [x] `[client/project]`: Set current project (must exist)
  - [x] `new [client/project]`: Create directory structure and set as current

### 3.2 Project Creation Logic

- [x] Create client directory if needed (`projects/[client]/`)
- [x] Create project directory (`projects/[client]/[project]/`)
- [x] Initialize git repo in project directory
- [x] Create minimal scaffold (context/ directory for requirements)
- [x] Update `tracking/current-project.md`
- [x] Add entry to `tracking/projects-log.md`

### 3.3 Project Listing Logic

- [x] Scan `projects/` directory for clients
- [x] Scan each client for projects
- [x] Display hierarchically with current marked

---

## Phase 4: Seeding Commands (COMPLETED)

The main workflows for capturing project requirements.

### 4.1 `/intake` — New Project Reverse Prompting

- [x] Create `.claude/commands/intake.md`
- [x] Read current project context (or accept override)
- [x] Implement reverse prompting flow:
  - [x] Ask questions one at a time
  - [x] Cover: purpose, users, constraints, success criteria, technical context
  - [x] Push for specificity (like Writing Companion's sensory details)
  - [x] Extract the "quality" — what makes this project distinct
- [x] Create/update project context files:
  - [x] `[project]/context/requirements.md` — captured requirements
  - [x] `[project]/context/constraints.md` — technical and business constraints
  - [x] `[project]/context/decisions.md` — decisions made during intake
- [x] Update `tracking/projects-log.md` with session summary

### 4.2 `/onboard` — Existing Project Analysis

- [x] Create `.claude/commands/onboard.md`
- [x] Verify project exists and has content to analyze
- [x] Analyze existing files against methodology checklist:
  - [x] CLAUDE.md present and complete?
  - [x] README.md present and useful?
  - [x] Commands defined?
  - [x] Skills defined?
  - [x] Documentation present?
- [x] Produce structured report: FOUND / MISSING / RECOMMENDATIONS
- [x] Ask before starting gap-filling reverse prompting
- [x] Target gaps specifically (don't re-capture what exists)

### 4.3 `/process` — External Input Processing

- [x] Create `.claude/commands/process.md`
- [x] Accept input types:
  - [x] Pasted text (transcripts, notes)
  - [x] File path (documents, existing specs)
- [x] Extract structured information:
  - [x] Requirements mentioned
  - [x] Constraints identified
  - [x] Decisions implied
  - [x] Questions raised
- [x] Update project context files with extracted content
- [x] Flag items needing clarification for `/intake` follow-up

### 4.4 `/gaps` — Assessment

- [x] Create `.claude/commands/gaps.md`
- [x] Read all project context files
- [x] Compare against methodology checklist:
  - [x] Purpose clearly defined?
  - [x] Users identified?
  - [x] Success criteria specified?
  - [x] Technical constraints captured?
  - [x] Key decisions documented?
- [x] Produce gap report with priorities
- [x] Suggest which gaps to fill next (and how)

### 4.5 `/checkpoint` — Session Capture

- [x] Create `.claude/commands/checkpoint.md`
- [x] Summarize what was captured this session
- [x] Update tracking files:
  - [x] `tracking/projects-log.md` — session entry
  - [x] `tracking/patterns-discovered.md` — any new patterns noticed
- [x] Identify concrete next steps
- [x] Prepare handoff notes (for potential context loss)
- [x] Optionally commit changes to project git repo

---

## Phase 5: First Test

Validate the system works end-to-end.

### 5.1 Test Scenario

- [ ] Run: `/project new acme-corp/sample-project`
- [ ] Run: `/intake` and go through reverse prompting
- [ ] Run: `/process` with sample transcript (if available)
- [ ] Run: `/gaps` to see assessment
- [ ] Run: `/checkpoint` to capture session

### 5.2 Validation

- [ ] Verify project directory created correctly
- [ ] Verify context files populated
- [ ] Verify tracking files updated
- [ ] Verify gap assessment is meaningful
- [ ] Verify checkpoint captures useful state

### 5.3 Refinement

- [ ] Note any friction points
- [ ] Update commands based on learnings
- [ ] Document patterns in `tracking/patterns-discovered.md`

---

## Success Criteria Checklist

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

## Notes for Multi-Session Implementation

If this takes multiple sessions:

1. **Phase 1-2** can be done in one session (foundation + tracking)
2. **Phase 3** (`/project` command) should be its own session — it's the critical dependency
3. **Phase 4** commands can be done 1-2 per session, in order:
   - `/intake` first (core workflow)
   - `/checkpoint` second (enables clean session ends)
   - `/gaps` third (enables assessment)
   - `/process` fourth (extends intake)
   - `/onboard` fifth (variant of intake)
4. **Phase 5** (first test) validates everything

Each session should end with:
- Committing completed work
- Noting which checkboxes are done
- Identifying the next phase to tackle
