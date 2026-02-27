---
name: companion-standards
description: >
  Authoritative reference for companion project structure, Claude Code configuration conventions,
  and ticket schema. Preloaded into agents that create or verify companion artifacts.
user-invocable: false
---

# Companion Standards

Canonical reference for building and verifying Claude Code companion projects created by Project Creator. Agents defer to this skill for all structural and configuration decisions.

---

## Core Principle

Companion projects follow a layered architecture where enforcement mechanism matches instruction criticality. CLAUDE.md holds identity (advisory). Skills hold workflows (on-demand, high attention). Hooks hold critical rules (deterministic, survives compaction). Rules hold domain patterns (path-scoped). Agents provide isolation for heavy work.

---

## Companion Directory Structure

Every companion lives at `companions/[client]/[companion]/` and follows this layout:

```
companions/[client]/[companion]/
├── CLAUDE.md                    # Project identity (<100 lines)
├── README.md                    # Human documentation
├── .claude/
│   ├── settings.json            # Hooks, permissions
│   ├── skills/                  # Workflow skills
│   │   └── [skill-name]/
│   │       └── SKILL.md
│   ├── agents/                  # Agent definitions
│   │   └── [agent-name].md
│   ├── rules/                   # Path-scoped domain rules
│   │   └── [rule-name].md
│   └── hooks/                   # Hook content files
│       └── session-start.md
├── context/                     # Seeding phase outputs
│   ├── requirements.md
│   ├── constraints.md
│   ├── decisions.md
│   └── questions.md
├── reference/                   # Contextualized library materials
│   └── [author]-[title]-companion-notes.md
├── docs/
│   └── plans/
│       ├── YYYY-MM-DD-implementation-spec.md
│       ├── tickets.yaml
│       └── build-progress.md
└── templates/                   # Companion-specific templates
```

### Placement Rules

| Component | Location | NOT Here |
|-----------|----------|----------|
| Skills | `.claude/skills/[name]/SKILL.md` | Root `skills/` |
| Agents | `.claude/agents/[name].md` | Root `agents/` |
| Rules | `.claude/rules/[name].md` | Root `rules/` |
| Hooks content | `.claude/hooks/[name].md` | Inline in settings.json |
| Commands (legacy) | `.claude/commands/[name].md` | Root `commands/` |
| Context files | `context/` | `.claude/context/` |
| Reference files | `reference/` | `.claude/reference/` |
| Plan artifacts | `docs/plans/` | Root `plans/` |
| Templates | `templates/` | `.claude/templates/` |

### Good

```
companions/acme-corp/api-service/.claude/skills/start-day/SKILL.md
companions/acme-corp/api-service/context/requirements.md
companions/acme-corp/api-service/docs/plans/2026-02-26-implementation-spec.md
```

### Bad

```
companions/acme-corp/api-service/skills/start-day.md          # Wrong: not under .claude/
companions/acme-corp/api-service/.claude/context/requirements.md  # Wrong: context is project-level
companions/acme-corp/api-service/plans/spec.md                # Wrong: plans go under docs/
```

---

## Configuration Surface Decisions

Match enforcement mechanism to instruction criticality. This is the reliability hierarchy:

| Tier | Mechanism | Use For |
|------|-----------|---------|
| 1 | Hooks (`.claude/hooks/`) | Rules that MUST be followed with zero exceptions. Survive compaction. |
| 2 | Skills preloaded in agents (`skills:` frontmatter) | Standards agents must follow. High attention — primary context. |
| 3 | Skills in main conversation | Workflow procedures. On-demand loading, better attention than CLAUDE.md. |
| 4 | Rules (`.claude/rules/`) | Domain patterns for specific file types/directories. Path-scoped. |
| 5 | CLAUDE.md | Project identity, cross-cutting constraints. Advisory. Under 100 lines. |

### CLAUDE.md Guidelines

- Under 100 lines for companion projects
- Contains: project identity, role definition, key constraints, directory orientation
- Does NOT contain: workflow procedures, per-command guidance, enforcement lists
- Positive framing: "Execute steps in order" not "NEVER skip steps"

### Skill Types

| Type | Frontmatter | Purpose |
|------|-------------|---------|
| Orchestrator | `disable-model-invocation: true` | User-invoked workflows that dispatch to agents |
| Single | `disable-model-invocation: true` | Interactive dialogue with user, no agent dispatch |
| Reference | `user-invocable: false` | Standards preloaded into agents |

### Agent Frontmatter

Required fields for agent definitions:

```yaml
---
name: [agent-name]
description: [what the agent does]
model: [haiku|sonnet|opus]
tools: [explicit tool whitelist]
skills: [reference skills to preload]
---
```

- Model selection: Haiku for search, Sonnet for structured analysis, Opus for judgment/generation
- Tools: Always explicit whitelist. Read-only agents get `[Read, Glob, Grep]`. Implementation agents get `[Read, Write, Edit, Glob, Grep, Bash]`.
- Skills: Listed skills are injected as full text at startup. Never tell an agent to "read" a preloaded skill.

### Hook Setup

Minimum viable hook setup for any companion:

```json
{
  "hooks": {
    "SessionStart": [{
      "hooks": [{
        "type": "command",
        "command": "cat .claude/hooks/session-start.md"
      }]
    }]
  }
}
```

SessionStart hook content: 5-7 critical rules, positive framing, fires at startup AND after compaction.

### Rules

Rules use YAML frontmatter with `globs:` for path scoping:

```yaml
---
globs: ["*.py", "tests/**"]
---
[Rule content — under 30 lines, positive framing]
```

---

## Ticket Schema

Tickets in `docs/plans/tickets.yaml` follow this exact schema. Field names are snake_case and non-negotiable.

### Top-Level Fields

| Field | Type | Required |
|-------|------|----------|
| `project_name` | string | yes |
| `project_path` | string (absolute path) | yes |
| `spec_file` | string (relative path) | yes |
| `linear_parent_issue` | string | yes |

### Per-Ticket Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `id` | integer | yes | Sequential: 1, 2, 3... |
| `linear_id` | string | yes | Linear identifier: "CON-XX" |
| `title` | string | yes | Imperative: "Build X", "Create Y" |
| `size` | string | yes | "S" or "M" only |
| `status` | string | yes | pending, in_progress, completed, skipped |
| `blocked_by` | list[int] | yes | Ticket IDs, or empty `[]` |
| `description` | string | yes | Full context for a fresh agent |
| `input_files` | list[string] | yes | Relative paths from project root |
| `output_files` | list[string] | yes | At least one entry |
| `acceptance_criteria` | list[string] | yes | Specific, verifiable |

### Good

```yaml
tickets:
  - id: 1
    linear_id: "CON-44"
    title: "Create project CLAUDE.md"
    size: "S"
    status: "pending"
    blocked_by: []
    description: |
      Create the main CLAUDE.md configuration file for the companion.
      Follow the reliability hierarchy: identity and cross-cutting constraints only.
    input_files:
      - "context/requirements.md"
      - "context/decisions.md"
    output_files:
      - "CLAUDE.md"
    acceptance_criteria:
      - "CLAUDE.md exists and is under 100 lines"
      - "Contains project identity and role definition"
```

### Bad

```yaml
tickets:
  - Id: 1                    # Wrong: camelCase, should be snake_case
    linearId: "CON-44"       # Wrong: camelCase
    Title: "Creating X"      # Wrong: gerund, should be imperative
    size: "L"                # Wrong: only S or M allowed
    blockedBy: []            # Wrong: camelCase, should be blocked_by
    outputFiles: []          # Wrong: empty output_files
```

---

## Three-Layer Architecture

The pattern for reliable workflows:

```
USER -> ORCHESTRATOR (skill) -> AGENT (subagent) <- REFERENCE SKILL (preloaded)
        validates inputs        does heavy work      defines standards
        sequences phases        reads many files      sole authority on domain
        dispatches to agent     synthesizes content   DRY across agents
        presents output         returns to caller     injected at startup
        gates on human approval
```

### When to Use Each Layer

| Question | Answer | Layer |
|----------|--------|-------|
| Validates user input or presents output? | Yes | Orchestrator |
| Requires human approval before proceeding? | Yes | Orchestrator |
| Reads many files and synthesizes content? | Yes | Agent |
| Generates substantial text? | Yes | Agent |
| Defines standards multiple agents share? | Yes | Reference skill |
| Primarily dialogue with the user? | Yes | Single skill (no agent) |

### Orchestrator Structure

Orchestrator skills follow: Validate -> Dispatch -> Present -> Gate

Between phases, output compliance checkpoints:

```
Phase 1 Complete. Collected values:
- [Parameter]: [actual value]
- [Path]: [actual value]

Proceeding to Phase 2.
```

---

## Anti-Patterns

| Pattern | Why It Fails | Do This Instead |
|---------|-------------|-----------------|
| Everything in CLAUDE.md | Attention degrades with length; wrong mechanism | Distribute across reliability hierarchy |
| Telling agents to read preloaded skills | Skill is already injected; wastes tokens | Trust `skills:` frontmatter means preloaded |
| Fat orchestrators doing heavy work | Context fills; no isolation benefit | Delegate heavy work to agents |
| Agents without reference skills | Agent improvises standards | Add reference skills to `skills:` frontmatter |
| Negative framing ("NEVER do X") | Activates prohibited behavior | Positive framing ("Do Y instead") |
| Default tool scope on agents | Agent accesses tools it shouldn't | Explicit `tools:` whitelist |
| Skipping validation before dispatch | Agent receives bad inputs | Orchestrator validates first |
| Missing human gate | Acts without user approval | Present output, wait for decision, then act |
| Placeholder values in agent prompts | Agent can't resolve `[PATH_FROM_STEP_1]` | Build complete prompts with actual values |
| Creating `.claude/` components at project root | Wrong location | Always under `.claude/` directory |
