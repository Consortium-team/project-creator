# Knowledge Zones: Integration Guide

How to map zones to directory structure and wire zone-aware commands into a companion project.

---

## Mapping Zones to Directory Structure

Each zone maps to a directory (or set of directories) in the project. The mapping varies by persona because different domains organize their knowledge differently.

### Game Designer Zone Mapping

```
project-root/
├── reference/                    # REFERENCE ZONE
│   ├── frameworks/               # Framework summaries (MDA, Koster, Schell)
│   ├── competitive/              # Competitive analysis
│   └── library/                  # Book notes, design literature
├── design/                       # FIELD ZONE
│   ├── current/                  # Active design iteration
│   │   ├── high-level-design.md  # Vision, pillars, core loops
│   │   └── detailed-design.md   # Mechanics, balance, systems
│   ├── explorations/             # Design explorations not yet committed
│   └── archive/                  # Previous iterations (for reference)
├── context/                      # INSIGHTS + DECISIONS ZONES
│   ├── design/
│   │   ├── insights-log.md       # INSIGHTS ZONE
│   │   ├── skill-assessment.md   # INSIGHTS ZONE
│   │   ├── pillars.md            # DECISIONS ZONE
│   │   └── frameworks.md         # REFERENCE ZONE (cross-ref)
│   ├── decisions.md              # DECISIONS ZONE
│   ├── constraints.md            # DECISIONS ZONE
│   ├── requirements.md           # DECISIONS ZONE
│   └── questions.md              # DECISIONS ZONE
├── tracking/                     # SESSIONS ZONE
│   ├── session-log.md
│   ├── next-actions.md
│   ├── session-records.md
│   └── build-progress.md
└── .claude/
    ├── commands/
    └── skills/
```

### Writing Mentor Zone Mapping

```
project-root/
├── library/                      # REFERENCE ZONE
│   ├── [author]/[work]/          # Contextualized book notes
│   └── style-references/         # Style and craft reference material
├── writing/                      # FIELD ZONE
│   ├── current-project/          # Active writing project
│   │   ├── chapters/             # Chapter drafts
│   │   └── notes/                # Working notes
│   ├── exercises/                # Craft exercises and results
│   └── archive/                  # Completed or shelved work
├── anchors/                      # REFERENCE + INSIGHTS ZONE (hybrid)
│   └── [anchor-name].md          # Life material with extracted qualities
├── context/                      # INSIGHTS + DECISIONS ZONES
│   ├── author/
│   │   ├── profile.md            # REFERENCE ZONE
│   │   ├── craft-insights.md     # INSIGHTS ZONE
│   │   ├── craft-assessment.md   # INSIGHTS ZONE
│   │   ├── voice-analysis.md     # INSIGHTS ZONE
│   │   └── curriculum.md         # DECISIONS ZONE
│   ├── decisions.md              # DECISIONS ZONE
│   ├── constraints.md            # DECISIONS ZONE
│   ├── requirements.md           # DECISIONS ZONE
│   └── questions.md              # DECISIONS ZONE
├── tracking/                     # SESSIONS ZONE
│   ├── session-log.md
│   ├── next-actions.md
│   └── session-records.md
└── .claude/
    ├── commands/
    └── skills/
        └── [mentor]-mentor/      # REFERENCE ZONE (methodology)
```

### Product Manager Zone Mapping

```
project-root/
├── research/                     # REFERENCE ZONE
│   ├── competitive/              # Competitor analysis
│   ├── market/                   # Market research
│   └── user-research/            # User interview notes, surveys
├── specs/                        # FIELD ZONE
│   ├── current/                  # Active specifications
│   └── archive/                  # Previous versions
├── context/                      # INSIGHTS + DECISIONS ZONES
│   ├── product/
│   │   ├── hypothesis.md         # DECISIONS ZONE (strategy anchor)
│   │   ├── insights-log.md       # INSIGHTS ZONE
│   │   ├── user-segments.md      # INSIGHTS + REFERENCE ZONE
│   │   ├── vision.md             # DECISIONS ZONE
│   │   └── feature-concepts.md   # FIELD ZONE (active feature work)
│   ├── decisions.md              # DECISIONS ZONE
│   ├── constraints.md            # DECISIONS ZONE
│   ├── requirements.md           # DECISIONS ZONE
│   └── questions.md              # DECISIONS ZONE
├── tracking/                     # SESSIONS ZONE
│   ├── session-log.md
│   ├── next-actions.md
│   └── session-records.md
└── .claude/
    ├── commands/
    └── skills/
```

---

## How Different Personas Organize Their Zones Differently

The five zones are universal but their relative size and importance varies.

| Zone | Game Designer | Writing Mentor | Product Manager |
|------|-------------|----------------|-----------------|
| **Reference** | Large — many frameworks, competitive analysis, design literature | Medium — library, style references, mentor skills | Medium — market research, competitor analysis |
| **Field** | Medium — active design documents, current iteration | Large — chapters, drafts, exercises (the actual writing) | Medium — active specs and feature concepts |
| **Insights** | Large — design insights compound heavily | Large — craft insights, voice analysis, assessment | Medium — strategic observations, evidence patterns |
| **Sessions** | Medium — standard session tracking | Medium — standard session tracking | Medium — standard session tracking |
| **Decisions** | Medium — design pillars, mechanic decisions | Small — curriculum decisions, creative direction | Large — hypothesis, strategy, scope decisions |

### Why This Matters for Intake

During project intake, the zone structure helps determine what directories to create and how to weight the initial setup. A writing companion needs a robust Field zone from the start (the writer has material). A game designer companion needs a robust Reference zone (frameworks and literature). A PM companion needs a robust Decisions zone (hypothesis and strategy).

---

## How Commands Should Target Specific Zones

Zone-aware commands read only the zones they need.

### Pattern: Zone-Targeted Reading

```markdown
## Step 1: Read Context (Zone-Targeted)

Read from DECISIONS zone:
- `context/decisions.md`
- `context/[persona]/hypothesis.md` (or equivalent anchor)

Read from INSIGHTS zone:
- `context/[persona]/insights-log.md` (recent entries only)
- `context/[persona]/craft-assessment.md` (summary section only)

Do NOT read:
- Reference zone (not needed for this command)
- Sessions zone (orientation was done in /status)
- Field zone (this command does not review work)
```

### Pattern: Zone-Specific Writing

```markdown
## Step N: Update [Zone Name]

Write to INSIGHTS zone:
- Append insight to `context/[persona]/insights-log.md`

Write to SESSIONS zone:
- Update `tracking/session-log.md`
- Update `tracking/next-actions.md`

Do NOT write to:
- Decisions zone (no decisions were made this session)
- Reference zone (no new reference material)
- Field zone (no work products created this session)
```

### Zone Reading Order for Orientation

When a command needs broad orientation (like /status), read zones in priority order:

1. **Sessions** — What happened recently, what is queued (most immediately relevant)
2. **Decisions** — What has been decided (highest authority)
3. **Insights** — What has been observed (informs current session)
4. **Field** — What is in progress (context for work)
5. **Reference** — Background knowledge (read only if specific reference is needed)

---

## When to Introduce Zone Organization

Zones are not needed from day one. A new companion project with four context files and an empty session log does not need five named zones — it needs to do work and accumulate material.

### Introduce Zones When:

- The `context/` directory has more than 10 files
- Commands are reading files they do not need (wasting tokens)
- The user or companion has difficulty finding things
- Session start orientation takes too long because there is too much to read
- The project has been running for 10+ sessions

### How to Introduce Zones to an Existing Project

1. **Audit current files** — List all files and their purposes
2. **Classify each file** — Which zone does it belong to?
3. **Reorganize if needed** — Move files to zone-aligned directories (or just document which files belong to which zone without moving)
4. **Update commands** — Add zone-targeting to command reading steps
5. **Document the mapping** — Add a zone map to the project's CLAUDE.md or a dedicated reference file

Moving files is not always necessary. Sometimes documenting "these files are the Insights zone, these are the Decisions zone" in CLAUDE.md is sufficient. The value is in commands knowing which files to read, not in physical directory structure.

---

## Examples from Different Personas

### Game Designer: /explore Command (Zone-Aware)

```markdown
# /explore

Explore a design question through framework-guided conversation.

## Step 1: Read from Zones

REFERENCE zone:
- `reference/frameworks/[relevant-framework].md` — Framework to apply

DECISIONS zone:
- `context/design/pillars.md` — Current design pillars

INSIGHTS zone:
- `context/design/insights-log.md` — Recent design insights
  (last 5 entries, filtered by category matching the exploration topic)

## Step 2: Explore through reverse prompting
[Standard reverse prompting, informed by framework and pillars]

## Step 3: Write to Zones

INSIGHTS zone:
- Append new insights to `context/design/insights-log.md`

DECISIONS zone (if applicable):
- Append new decisions to `context/decisions.md`

SESSIONS zone:
- Note exploration topic in session log
```

### Writing Mentor: /seed Command (Zone-Aware)

```markdown
# /seed

Generate a writing prompt from accumulated material.

## Step 1: Read from Zones

REFERENCE zone:
- `anchors/` — Available anchor material
- `.claude/skills/[mentor]-mentor/SKILL.md` — Selected mentor

INSIGHTS zone:
- `context/author/craft-assessment.md` — Current development focus
- `context/author/craft-insights.md` — Recent craft observations

DECISIONS zone:
- `context/author/curriculum.md` — Current curriculum priorities

Do NOT read from SESSIONS zone (not needed for seed generation).
Do NOT read from FIELD zone (seed should be fresh, not derivative of current work).

## Step 2: Generate seed
[Seed generation using anchor material, mentor framing, and craft focus]

## Step 3: Write to Zones

FIELD zone:
- Write seed to `writing/exercises/[date]-seed.md`
```

### Product Manager: /process Command (Zone-Aware)

```markdown
# /process

Process a meeting transcript for strategic insights.

## Step 1: Read from Zones

DECISIONS zone:
- `context/product/hypothesis.md` — Current hypothesis (for evidence checking)
- `context/decisions.md` — Recent decisions (for contradiction checking)

INSIGHTS zone:
- `context/product/insights-log.md` — Existing insights (for connection)

REFERENCE zone (if needed):
- `research/user-research/` — Previous user research (for context)

## Step 2: Process the transcript
[Standard meeting processing with hypothesis evidence checking]

## Step 3: Write to Zones

DECISIONS zone:
- New decisions to `context/decisions.md`
- Evidence to `context/product/hypothesis.md`
- Resolved questions moved in `context/questions.md`

INSIGHTS zone:
- New insights to `context/product/insights-log.md`

SESSIONS zone:
- Processing summary to `tracking/session-log.md`
```

---

## Common Pitfalls

### Zones as Bureaucracy

If zone organization makes commands more complex without making them more effective, the zoning is not working. The test: are commands reading fewer irrelevant files? If yes, zones are working. If commands read the same files as before, zones are overhead without benefit.

### Zone Purity Obsession

Some files naturally span zones. An `anchors/` directory in a writing project is both Reference (static material) and Insights (the extracted qualities evolve). Do not agonize over the classification — assign a primary zone and cross-reference.

### Premature Zone Migration

Do not reorganize an entire project into zones just because the concept exists. Wait until the material accumulates enough that the organization provides real value. A project with 5 files does not need zone directories.

### Forgetting to Update Commands

Introducing zones without updating commands to target them is pointless. The value of zones is in zone-targeted reading. If commands still read `context/*` (everything), the zones are just folders.

### Zone Drift

Over time, files may end up in the wrong zone as the project evolves. Periodically audit (perhaps during /evolve) whether files are in their right zones and whether the zone mapping in CLAUDE.md is current.
