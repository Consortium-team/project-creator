# LLM-Enabled Workflow Methodology

> **Project Creator Reference Copy** — This is the authoritative methodology document for reverse prompting, meta-project patterns, and failure recovery. Commands and CLAUDE.md reference this for deep patterns.

**Purpose:** Reference knowledge for Claude projects requiring understanding of AI-assisted workflow best practices
**Applicability:** Project Creator projects, project improvement assessments, any context where methodology guidance is needed

---

## Core Insight

The challenge with AI assistants isn't technical—it's organizational. Individual productivity gains don't translate to team or organizational outcomes without systematic approaches to context management and cross-functional learning.

---

## Core Philosophy

**Start "wrong", iterate to find "right", generate everything.**

- Don't pre-plan exhaustively before starting
- Begin with conversation and discovery
- Let patterns emerge through experimentation
- Systematize what works, discard what doesn't
- Automate and generate once patterns are proven

---

## The Four Pillars

### 1. Integrated Toolset
Tools serve specific roles in the workflow:

| Tool | Role | Function |
|------|------|----------|
| Granola AI | Capture | Conversation transcripts |
| Whisper Flow | Input | Voice-first interaction |
| Claude Projects | Ideation | Ad hoc exploration |
| Linear | Context | Cross-project repository |
| Claude Code | Execution | Structured workflows |
| CodeRabbit | Review | Automated PR review |

**Key insight:** Voice input shifts cognition from "what to tell it" to "what you want to achieve."

### 2. Workflow Zones

Work moves through three zones of increasing structure:

**Ad Hoc Zone**
- Tools: Granola, Claude Projects
- Outputs: Insights, direction, requirements
- Character: Unstructured ideation before workflow defined

**Workflow Zone**
- Tools: Claude Code + Commands
- Outputs: Code, documentation, PRs
- Character: Structured, repeatable processes

**Cross-Project Zone**
- Tools: Linear, Shared Skills
- Outputs: Best practices, patterns, templates
- Character: Organizational standards that span projects

**Pattern:** Ideas coalesce into workflows; patterns emerge across workflows into shared standards.

### 3. Project Configuration

**The Configuration Trinity:**

| Document | Audience | Contents |
|----------|----------|----------|
| CLAUDE.md | AI Agent | Project context, coding standards, architecture patterns, constraints |
| README.md | Human Developer | Workflow state machine, command reference, getting started guide |

**Workflow Automation Building Blocks:**

| Building Block | Definition | Examples |
|----------------|------------|----------|
| Commands | Templatized prompts for repeatable workflow steps | /start-issue, /plan-pr, /implement |
| Agents | Orchestrated sub-tasks (black-box execution) | Test generation, research, documentation |
| Skills | Reusable expertise that reduces hallucination | Domain rules, parsing patterns, styling |

**Note:** Industry has not yet consolidated on when to use Commands vs. Agents vs. Skills. Current guidance:
- Commands: Steps requiring visibility and control, entry points to workflows
- Agents: Parallelizable tasks where output can be fully regenerated
- Skills: Domain knowledge reused across multiple commands

### 4. Distinctive Techniques

**Reverse Prompting**
- Standard: You tell LLM what to do → LLM generates output
- Reverse: LLM asks questions → You answer → LLM structures your knowledge

Three phases:
1. **Seeding** — LLM asks questions to draw out raw material
2. **Cultivation** — LLM provides prompts to develop and connect fragments
3. **Shaping** — LLM structures answers into artifacts (PRD, specs, stories)

**Why it matters:** For requirements and design, YOU have the tacit knowledge. The LLM can structure what you know but can't generate it.

### Reverse Prompting Deep Dive

The Writing Companion project demonstrates reverse prompting as a complete system, not just a technique.

**The Core Pattern: Quality Extraction**

Raw material (memories, experiences, knowledge) contains a "quality" — the portable thing that can be abstracted and reused. The LLM's job is to:
1. Ask questions that draw out the raw material
2. Push for specificity (sensory details, concrete examples)
3. Extract the quality — what makes this portable
4. Structure into reusable artifacts

Example transformation:
- Raw: "Finding Little Lap behind McDonald's in the rain"
- Quality: "Joy arriving one day too late"
- Artifact: Anchor file entry with quality, sensory details, seed types

**Phase 1: Seeding in Practice**

A `/capture` command demonstrates seeding:
```
1. Author starts telling a story
2. Claude listens, asks follow-up questions
3. Claude pushes for sensory details ("what do you see/hear when you think of this?")
4. Together, they articulate the quality — the portable thing
5. Claude drafts a structured entry
6. Author confirms before Claude files it
```

The author talks freely. Claude extracts and structures.

**Phase 2: Cultivation in Practice**

A `/seed` command demonstrates cultivation:
```
1. Claude reads context (what's been written, what needs practice)
2. Claude reads anchor files (structured life material)
3. Claude extracts quality from an anchor
4. Claude invents a NEW situation (transformed, not relabeled)
5. Claude presents the situation, invites author refinement
6. Author adjusts through dialogue
7. ONLY THEN does Claude apply mentor framings
8. Author picks what resonates
```

Key insight: Refinement happens through dialogue BEFORE final output. The author's input enriches the prompt—this IS cultivation.

**Phase 3: Shaping in Practice**

A `/harvest` command demonstrates shaping:
```
1. Save the writing to structured location
2. Update tracking documents with what emerged
3. Capture craft discoveries into knowledge docs
4. Confirm next prompts
```

Session learnings become externalized knowledge that persists.

**Multiple Perspectives Pattern**

The same raw material can be interpreted through different lenses:
- Gaiman lens: "Write toward the discomfort"
- Sanderson lens: "Practice this specific craft skill"
- Patterson lens: "Make it hook immediately"

Multiple perspectives reveal different aspects of the same quality. Author picks what resonates for their current state.

**The Foundation Investment**

Before the workflow runs, significant seeding happens:
- Share writing samples → LLM creates author profile
- Share life stories → LLM creates autobiography/anchor files
- Share existing work → LLM analyzes what's working

This foundation (15-20 hours in the Writing Companion) makes every subsequent session more effective. The LLM has real context, not guesses.

**Implementation Requirements**

For reverse prompting to work as a system:
1. **Structured capture** — Commands that guide the seeding conversation
2. **Quality extraction** — The transformation from raw to portable
3. **Cultivation artifacts** — Documents that hold the extracted knowledge
4. **Multiple lenses** — Different perspectives on the same material
5. **Refinement loops** — Author input before final output
6. **Tracking** — What's been used, what's emerging, what's working

**Document-Based Planning**
- Planning applies at any scale: task → feature → project → portfolio
- Plans live in project directory (Git controlled), not plan mode
- Enables team review, searchable history, scales across people and time

| Scale | Example | Artifact |
|-------|---------|----------|
| Task | Single function, bug fix | Mental checklist |
| Feature | New capability | SDD (Software Design Doc) |
| Project | New system, major refactor | PRD + multiple SDDs |
| Portfolio | Multi-quarter initiative | Roadmap + project plans |

---

## Context Ecosystem

Context isn't one thing—it's an ecosystem of groupings with different lifecycles.

### Two Types of Context Groups

**Project-Specific Context Group**
- Skills, Commands, Agents, Knowledge (Markdown docs)
- One per Claude Code project
- Scoped to that project's needs

**Shared Context Group**
- Skills, Commands, Agents, Knowledge (Markdown docs)
- Plus: Linear (decisions, rationale, patterns)
- Accessible across projects and teams

### Session Access Model

Each session has access to:
1. Its project's context group (externalized, persists)
2. Shared context groups (organizational knowledge)

Session-only context (working memory) is lost at /compact. Externalize important decisions and learnings.

---

## Linear Usage Patterns

Linear serves as the cross-context bridge — the place where plans, decisions, and learnings persist across sessions and can be accessed from any project.

### Pattern 1: Transcript → Structured Plan (Ad-Hoc Zone)

**Context:** Claude Projects chat, Cowork task
**Input:** Transcript discussing a concept
**Prompt pattern:** "Go over this transcript and propose an overall plan broken into trackable tasks"
**Output:** Linear tickets with structure

Use case: Any project needing decomposition into smaller chunks. Most commonly for implementation tasks, but applicable to any work requiring breakdown.

### Pattern 2: Cross-Project Augmentation

**Flow:**
1. Start in one context (Claude Projects chat, Cowork task)
2. Create initial tickets/plan in Linear
3. Move to a "reference project" — a Claude Project with proven patterns and good context
4. Have it read the tickets just created
5. Prompt: "Apply the best practices from this project to these tickets"
6. Update tickets with augmented approach

Use case: Applying proven patterns to new work without re-explaining the patterns each time.

### Pattern 3: Plan Evolution (Workflow Zone)

**Context:** Claude Code project, working through tickets
**Trigger:** Realize plan needs to change based on learnings
**Prompt pattern:** "Based on what we've learned, how would you change our approach to this?"
**Output:** Proposed ticket rewrites, new tickets, reorganization
**Action:** If agreed, coding agent executes the changes in Linear

Use case: Plans are living documents. As understanding evolves, tickets evolve.

### What Linear Functions As

| Function | Description |
|----------|-------------|
| Externalized plan | Survives /compact, persists across sessions |
| Cross-context bridge | Tickets can be read/augmented from different projects |
| Living documentation | Evolves as understanding changes |
| Decisions repository | Captures rationale, not just tasks |

### Linear Best Practices

- **Externalize early** — Don't keep plans only in conversation; create tickets
- **Include rationale** — Tickets should capture *why*, not just *what*
- **Update as you learn** — Plans that don't evolve become stale
- **Use from reference projects** — Best practices transfer through ticket augmentation

---

## Maturation Phases

### Phase 1: Finding "Right"
- **Activity:** Start wrong, iterate through experimentation
- **Discover:** Commands, agents, skills, and knowledge that work for your context
- **Outcome:** A working template emerges
- **Scope:** Individual

### Phase 2: Repeating "Right"
- **Activity:** Use working template as basis for Project Creator project
- **Systematize:** Individual practices so new projects start with proven patterns
- **Outcome:** Project Creator project
- **Scope:** Individual (Systematic)

### Phase 3: Scaling "Right"
- **Activity:** Consolidate and align across team and organization
- **Standardize:** Shared context groups emerge
- **Outcome:** Organizational standards
- **Scope:** Team / Organization

**Principle:** Each phase builds on the last. You can't scale what you haven't systematized. You can't systematize what you haven't discovered.

---

## Failure Recovery Patterns

Initial commands, skills, agents, and knowledge aren't perfect—they're "what gets you started." The improvement happens through structured failure recovery.

### The Core Pattern

When a command doesn't produce the expected result, or you find yourself re-prompting in similar ways:

1. **Observe** — Notice the pattern. "This keeps happening."
2. **Discuss** — In the same session, talk about it: "Notice this thing that's happening. This is what went right, but this is what I'd like us to fix."
3. **Ask for Critical Options** — Prompt: "Be critical about this and give me some options for how to fix it."
4. **Encode the Fix** — Update the command/skill/knowledge with the learning
5. **Validate** — Test the next invocation to confirm the fix works

### Running Case Studies

The mechanism for capturing these learnings is the **running case study**:

- Maintain a case study document for important projects
- Capture each iteration: what changed, why, what emerged
- Document both the failures and the fixes
- Include timeline and time investment

**What a good case study captures:**
- Foundation/setup phase (what context was built)
- Evolution of commands through versions (v1 → v2 → v3 → v4)
- Specific failure moments and the insights they produced
- Validation that fixes worked

### Example: Command Evolution Pattern

From the Writing Companion case study, the `/seed` command evolved through use:

| Version | What Changed | Why |
|---------|--------------|-----|
| v1 | Basic prompt generation | Starting point |
| v2 | Added mentor selection | Different perspectives needed |
| v3 | Added seed types | More variety needed |
| v4 | Added "good prompt formula" | Learned that vague prompts don't work |

Each version encoded a learning from actual use.

### Example: The Sameness Problem

**Failure observed:** Prompts were just different framings of autobiography—not true fiction.

**Analysis session:** Noticed that every prompt was "write about [this memory from your life]" with different framing.

**Insight extracted:** Life material should be *anchors*, not direct prompts. The *quality*—the portable thing—should inspire invented characters.

**Fix encoded:** Redesigned anchor files with quality extraction. Modified `/seed` to generate prompts for invented fiction that draws from anchor qualities, not literal stories.

**Validation:** Next session produced varied prompts for invented situations that still carried authentic emotional weight.

### Example: The Producer Analysis

**Failure observed:** Initial prompt for The Producer had problems (wrong setting, generic character, vague lie).

**Analysis session:** After writing, explicitly analyzed what made the *refined* prompt work vs. the *initial* prompt.

**Insights extracted:**
- Prompt needs specificity: named lies, why chains, verified settings
- Prompt needs gaps: leave room for discovery during writing
- Author refinement should happen before mentor framings

**Fix encoded:** Six specific changes to `/seed` command, including "Show Your Work" requirements and reordered phases.

**Validation:** Next `/seed` invocation showed refinements working—author input enriched the prompt before framings were generated.

### Enabling Claude to See Sessions

For this pattern to work, Claude needs ability to:
- Review transcripts from sessions where failures occurred
- Access the running case study to see what's been tried
- Understand what worked and what didn't across sessions

This is why case studies live in the project directory—Claude can read them and learn from accumulated experience.

### Key Insight

Commands and skills improve because you use them, notice when they don't work, analyze why, and update them. The initial version is never the final version. Build the feedback loop into your workflow.

---

## Meta-Project Patterns

Some projects create or manage other projects. These "meta-projects" require specific patterns for managing parent-child relationships and multi-project context.

### The Parent-Child Pattern

**Use case:** A project that creates, onboards, or manages multiple sub-projects (e.g., Project Creator, Template Generator).

**Directory Structure (with client grouping):**
```
parent-project/
├── CLAUDE.md                    # Parent configuration
├── .gitignore                   # Contains: companions/ (ignores entire folder)
├── tracking/
│   └── current-companion.md     # Format: client/companion-name
└── companions/                  # Git-ignored; companion projects live here
    ├── [client-a]/
    │   ├── [companion-1]/
    │   │   ├── CLAUDE.md        # Companion's own config
    │   │   └── ...              # Independent git repo
    │   └── [companion-2]/
    └── [client-b]/
        └── [companion-3]/
```

**Example:**
```
project-creator/
└── companions/
    ├── acme-corp/
    │   └── api-refactor/
    ├── startup-inc/
    │   ├── web-app/
    │   └── data-pipeline/
    └── example-org/
        └── onboarding-system/
```

**Key principles:**
1. **Git isolation** — The `companions/` folder is git-ignored; companion projects have their own independent repos
2. **Client grouping** — Companions organized by client for multi-client workflows
3. **CLAUDE.md at root** — Parent's CLAUDE.md instructs Claude Code to ignore child CLAUDE.md files when working at parent level
4. **Shared directory access** — Both Cowork and Claude Code pointed at parent can see parent + all client/project children
5. **Context separation** — When working IN a sub-project (Claude Code pointed there), only sub-project context applies

### The Current Companion Pattern

**Use case:** Commands that need to know which companion to operate on.

**Implementation:**
- Store current companion in simple state file (e.g., `tracking/current-companion.md`)
- Companion references use `client/companion-name` format
- All commands accept optional `[client/companion]` parameter
- If no parameter, use current companion
- If no current companion and no parameter, list clients/companions and ask

**Command pattern:**
```
/project                              # Show current + list all clients/projects
/project [client/project]             # Set current project
/project new [client/project]         # Create new client (if needed) and project, set as current
```

**Examples:**
```
/project acme-corp/web-app                        # Set current
/project new startup-inc/api-refactor             # Create and set
/intake                                           # Uses current project
/intake acme-corp/onboarding                      # Override for specific project
```

This mirrors how git works: you're in a repo (current context), but can specify paths explicitly.

### The Onboard vs. Intake Pattern

**Two entry points for sub-projects:**

| Pattern | Starting Point | Use Case |
|---------|---------------|----------|
| `/intake` | Blank slate | New project, pure reverse prompting |
| `/onboard` | Existing project | Project created elsewhere, analyze + fill gaps |

**`/onboard` flow:**
1. User clones existing project into `projects/`
2. `/onboard` analyzes what exists against methodology
3. Produces report: FOUND / MISSING / RECOMMENDATIONS
4. Asks before starting reverse prompting
5. Targets gaps specifically, not starting from scratch

This handles the common case where projects exist in partial states and need systematizing.

### When to Use Meta-Project Patterns

- Building a "project factory" that creates configured projects
- Managing multiple related projects with shared methodology
- Onboarding existing projects into a systematic workflow
- Any situation where one Claude Code project needs to work on another

---

## Key Principles

1. **It's organizational, not technical** — Structure beats ad-hoc for teams and time
2. **Context is an ecosystem** — Project-specific and shared groups with different lifecycles
3. **Plan in documents, not plan mode** — Scales across people, teams, and time
4. **Reverse prompting unlocks left-shift** — Extract requirements and design knowledge
5. **Mature in phases** — Find right → Repeat right → Scale right

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Copy-paste prompting | No consistency, no learning | Templated commands |
| Session-only context | Knowledge lost at /compact | Externalize to documents, Linear |
| Individual focus only | Gains don't scale to team | Build shared context groups |
| Code generation only | Requirements and design remain ad-hoc | Apply methodology to full lifecycle |
| Pre-planning everything | Delays learning, plans become stale | Start wrong, iterate to find right |
| Batch processing | Context degrades, quality drops | Small batches with verification |

---

## Application Guidance

### For Project Creator Projects
Use this methodology to design what configurations new projects should start with:
- What commands are proven for this type of project?
- What skills reduce errors in this domain?
- What shared context groups should be linked?
- What CLAUDE.md sections are essential?

### For Project Improvement Assessment
Evaluate existing projects against this methodology:
- Which maturation phase is this project in?
- Is context being externalized or lost at /compact?
- Are there patterns that should become commands?
- Are there learnings that should become shared context?

### For Any Claude Code Project
Reference this knowledge when making decisions about:
- When to create a command vs. do something ad-hoc
- When something should become a skill vs. stay in CLAUDE.md
- How to structure planning and documentation
- When to use reverse prompting vs. direct generation

---

**Version:** 1.0
**Based on:** Client results showing methodology performs ~6 months ahead of industry best practices
**Positioning:** Shape best practices, not follow them
