# Game Designer: Typical Capabilities

Which capabilities from `companion-kits/public-kits/capabilities/` this persona typically uses, and how.

---

## Core Capabilities (Always Include)

### Claude Code Configuration
**Role:** The infrastructure layer that makes all other capabilities work reliably.
**How it's used:** Distributes instructions across the reliability hierarchy — hooks for insight capture enforcement (non-optional in game design), skills for framework-heavy analysis workflows, agents with preloaded framework skills for deep design analysis, rules for design document conventions, lean CLAUDE.md for design philosophy. Emphasizes the preloading pattern because agents need full framework context (Koster, Schell, etc.) to do useful analysis.
**Customization:** SessionStart hook with insight capture reminder (mandatory for this persona). Framework analysis skills preloaded into agents via `skills:` frontmatter. Low-freedom skills for insight capture to prevent the model from skipping non-optional steps.

### Reverse Prompting
**Role:** The primary interaction pattern for design exploration.
**How it's used:** The companion asks design questions that push the designer to articulate mechanics, player experience goals, and system interactions. Challenges vague design thinking with specific framework-based questions.
**Customization:** Design-domain questions (player motivation, core loop, feedback systems).

### Context Ecosystem
**Role:** Standard context capture plus game-design-specific artifacts.
**How it's used:** requirements.md, constraints.md, decisions.md — plus design-specific documents (design pillars, mechanics catalog, player personas, balance parameters).
**Customization:** Extended with game design document types and two-layer structure.

### Knowledge Zones
**Role:** Organizing the growing body of design knowledge.
**How it's used:** Reference zone (design literature, frameworks), field zone (active design work), insight zone (accumulated observations), session zone (continuity), decision zone (design choices with rationale).
**Customization:** Zone naming and organization adapted for game design workflows.

### Insight Feedback Loop
**Role:** Non-optional compounding of design observations.
**How it's used:** Every session captures design insights. Periodic synthesis finds patterns across sessions. The companion references accumulated insights when challenging new design ideas.
**Customization:** Insight categories aligned with game design concerns (mechanics, balance, player psychology, systems interaction).

### Session Hygiene
**Role:** Mandatory start/finish protocol.
**How it's used:** Session start: orientation to current design state. Session finish: capture insights, update design documents, git commit. This is non-optional for game design because design thinking is expensive to reconstruct.
**Customization:** Mandatory (not optional) for this persona.

---

## Common Capabilities (Include When Relevant)

### Mentor Framework
**When to include:** When specific game design authors' frameworks should be available as named lenses (e.g., Koster, Schell).
**How it's used:** Named mentor skills provide different analytical framings for the same design question.

### Strategic Planning
**When to include:** When the game project involves business strategy, market positioning, or monetization design.
**How it's used:** Hypothesis-driven approach adapted for game market fit questions.

---

## Rarely Used Capabilities

### Meeting Processing
**When to include:** Only if the design team has regular playtesting sessions or design reviews that produce transcripts.

### Craft Assessment
**When to include:** Not typically used for game design.

### Process Evolution
**When to include:** When the game design companion has been running long enough that its commands need tuning.
