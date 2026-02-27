---
globs: ["companions/**"]
---

Companion projects follow this directory layout:
- `context/` for requirements.md, constraints.md, decisions.md, questions.md
- `reference/` for contextualized library materials
- `docs/plans/` for implementation specs, tickets.yaml, build-progress.md
- `templates/` for companion-specific templates
- `.claude/` for skills, agents, rules, hooks, settings.json

Place Claude Code configuration components under `.claude/`, not at project root.
Each companion has its own independent git repository.
