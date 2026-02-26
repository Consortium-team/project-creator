# Software Developer: Typical Capabilities

Which capabilities from `companion-kits/public-kits/capabilities/` this persona typically uses, and how.

---

## Core Capabilities (Always Include)

### Context Ecosystem
**Role:** The foundation of document-driven development.
**How it's used:** requirements.md, constraints.md, decisions.md, questions.md — plus the docs context ecosystem (living documents, active documents, permanent documents). The 6-document active set pattern.
**Customization:** Extended with development-specific living documents (current-architecture.md, current-features.md, current-security-assessment.md, current-test-strategy.md).

### Process Evolution
**Role:** Continuous improvement of the development workflow.
**How it's used:** `/record` captures developer observations about configuration quality. `/evolve` finds patterns across records and proposes maturation steps. References everything-claude-code as a critical thinking lens.
**Customization:** Evolution targets are development-specific: commands, agents, skills, workflow tuning.

---

## Common Capabilities (Include When Relevant)

### Reverse Prompting
**When to include:** During intake and onboarding to extract architecture knowledge, coding standards, and domain constraints from the developer.
**How it's used:** Limited to the seeding phase. During implementation, the workflow is predominantly direct (generate from plans).

### Session Hygiene
**When to include:** Always for Level 2 projects. Optional for Level 1.
**How it's used:** `/start-issue` at session start, `/close-issue` at end. `/capture-learnings` after each completed issue updates living documents.

### Knowledge Zones
**When to include:** For Level 2 projects with accumulated documentation.
**How it's used:** Living docs (reference zone), active docs (field zone), ADRs + guides (permanent zone), evolution records (insight zone).

### Strategic Planning
**When to include:** When the software project has a sibling PM project or when architectural decisions need strategic framing.
**How it's used:** Less hypothesis-driven than PM, more decision-record-driven. ADRs serve as the strategic artifact.

---

## Rarely Used Capabilities

### Meeting Processing
**When to include:** Only if the development team has regular planning/standup meetings whose content needs to be captured.

### Mentor Framework
**When to include:** Not typically used for software development.

### Craft Assessment
**When to include:** Not typically used for software development.

### Insight Feedback Loop
**When to include:** Effectively replaced by the process evolution capability for software projects. The `/record` + `/evolve` pattern serves this function.
