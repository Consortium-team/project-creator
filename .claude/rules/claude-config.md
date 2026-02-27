---
globs: [".claude/**"]
---

Use `.claude/skills/[name]/SKILL.md` for new workflows (not `.claude/commands/`).

Skill types: orchestrator (disable-model-invocation: true), single (disable-model-invocation: true), reference (user-invocable: false).

Agent definitions require explicit model, tools whitelist, and skills list in frontmatter.

Hook content lives in `.claude/hooks/[name].md`, referenced from settings.json via `cat` command.

Rules use YAML frontmatter with `globs:` for path scoping. Keep rules under 30 lines with positive framing.
