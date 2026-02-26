# Software Development: Intake Guide

Type-specific questions for `/intake` when creating a software development project.

---

## How to Use

When `/intake` is invoked for a software-development type project, work through these questions. Not all questions apply to every project — use judgment about what to skip or reorder.

**Remember:** One question at a time. Let answers inform follow-up questions. Push for specificity — vague architecture produces vague code.

**Community reference:** [everything-claude-code](https://github.com/affaan-m/everything-claude-code) serves as a critical thinking reference throughout the project lifecycle — during intake, planning, and evolution. It represents community consensus on Claude Code project configuration. Use it as input to judgment, not as a prescription. Think critically about what applies and what doesn't.

---

## Phase 1: The Project

### Identity
1. **What are we building?** (Describe the system — not features, but what it IS)
2. **Is this greenfield or existing?**
   - Greenfield: What's the starting point? Any reference implementations?
   - Existing: Where's the codebase? What state is it in? What's the pain?
3. **What problem does this solve?** (Who has this problem and how bad is it?)

### Scope and Maturity
4. **What maturity level fits this project?**
   - Level 1 (Exploratory/Demo): Prototype, proof-of-concept, demo for a prospect
   - Level 2 (Production): Long-lived application, team project, shipping to real users
   - Unsure: Start at Level 1, graduate when needed
5. **Is there a companion PM project?** (If so: where does it live, what does it produce, how do specs flow into this project?)

---

## Phase 2: Architecture and Tech Stack

### Technical Foundation
6. **What's the tech stack?** (Languages, frameworks, databases, infrastructure)
   - Frontend: React? Vue? Mobile? None?
   - Backend: Node? Python? Go? Serverless?
   - Database: PostgreSQL? MongoDB? None yet?
   - Infrastructure: Vercel? Railway? AWS? Local only?
7. **Is this a monorepo or multi-repo?** (If monorepo: what are the packages/services?)
8. **What external services or APIs does this integrate with?** (Auth providers, payment, third-party APIs, etc.)

### Architecture
9. **Describe the high-level architecture.** (Don't worry about getting it perfect — we'll refine this into `current-architecture.md`)
   - What are the major components?
   - How do they communicate?
   - What's the data flow?
10. **Are there any architectural constraints or non-negotiables?** (Must use X, can't use Y, must run on Z)

### Reference Material
11. **Are there existing design documents, Figma mockups, or visual references?**
    - If yes: we'll use these to create a visual guide or design skill
12. **Are there reference implementations we should study?** (Open source projects, internal projects, competitor products)

---

## Phase 3: Development Workflow

### Linear Setup
13. **What Linear team and project will this use?** (Existing or need to create?)
14. **What's the ticket prefix?** (e.g., IMA for imaginesports, 7TW for 7tworld)
15. **How are tickets structured?** (One issue = one PR? Or one issue = multiple PRs?)

### Git Workflow
16. **What's the branching convention?** (e.g., `feat/[PREFIX]-[N]-description`, `fix/[PREFIX]-[N]-description`)
17. **What's the main branch?** (`main`, `master`, `develop`?)
18. **Any PR requirements?** (Required reviewers, CI checks, PR template?)

### Development Approach
19. **Describe how you want to work with Claude Code during implementation.**
    - Review SDD before implementation starts?
    - Run `/implement` per subtask and review output?
    - How much do you want to review between implement calls?
20. **What does "done" look like for a PR?** (Tests pass? Coverage threshold? Linting clean? Visual check?)

---

## Phase 4: Testing Strategy

### Current State
21. **What testing exists today?** (If existing project: what's the test coverage, frameworks, and philosophy?)
22. **What testing framework does this project use?** (Jest, Vitest, pytest, Go test, etc.)

### Test Philosophy
23. **What's the overall test strategy?** (This will seed `current-test-strategy.md`)
    - What types of tests matter most? (Unit, integration, E2E, visual?)
    - What coverage targets are appropriate?
    - Are there areas that need extra rigor? (Security, financial calculations, data integrity?)
24. **What invariants must always hold?** (Properties that should never be violated — this feeds into specification-based testing)
    - Example: "User balances must never go negative"
    - Example: "API responses must always include a request ID"
25. **Are there known testing gaps or pain points?** (Tests that don't catch real bugs, areas with no coverage, flaky tests?)

### Threat Model (for test design)
26. **What could go wrong that would be really bad?** (Security breaches, data loss, financial errors, etc.)
    - This feeds into the test design section of SDDs
    - Not exhaustive — just the things that keep you up at night

---

## Phase 5: Security and Quality

### Security Posture
27. **What's the security profile of this project?** (Public-facing? Internal tool? Handles PII? Financial data?)
28. **What authentication/authorization is in place or needed?** (Clerk, Auth0, custom JWT, etc.)
29. **Any compliance requirements?** (GDPR, SOC 2, HIPAA, PCI, etc.)

### Code Quality
30. **What coding standards matter?** (Linting rules, formatting, naming conventions, etc.)
    - If existing project: point to existing config files
    - If greenfield: describe preferences or reference a style guide
31. **Any anti-patterns to watch for?** (Things Claude tends to do that you don't want)

---

## Phase 6: Team and Constraints

### Team
32. **Who's on the development team?** (Solo? Multiple developers? Roles?)
33. **Who reviews code?** (The developer themselves? A team lead? Automated review?)
34. **Who else needs to understand this codebase?** (Stakeholders, future developers, clients?)

### Constraints
35. **What's the timeline?** (Sprint cadence? Deadline? Ongoing?)
36. **Any resource constraints?** (API costs, infrastructure limits, licensing?)
37. **What MCP servers are needed?** (Linear is required — what else? Figma? Granola? GitHub?)

---

## Phase 7: Community Pattern Evaluation

The core workflow and document structure from earlier phases give the project a solid foundation. Before finalizing, review [everything-claude-code](https://github.com/affaan-m/everything-claude-code) to see if community patterns would make a **material difference** to this specific project's setup.

**The principle:** Start simple. The core workflow is deliberately lightweight — it scales well without additions. Only adopt community patterns that solve a real problem this project has today, not problems it might have someday. When in doubt, skip it — the `/evolve` command exists specifically to add things later when running experience shows they're needed.

**How to use it:** Fetch and review the repository's commands, agents, skills, and configuration patterns. For each potentially relevant pattern, evaluate honestly:
- Does this solve a problem this project actually has *right now*?
- Would skipping it create a real quality gap, or just a theoretical one?
- Does it fit the lightweight-but-robust principle, or does it add cognitive load without proportional value?
- Is this better handled by `/evolve` later, once the developer has session experience to draw from?

### Skills Assessment
38. **Are there community skill patterns that would materially improve this project's output quality?** The bar is: would this skill noticeably reduce hallucination or catch a class of errors that the core workflow wouldn't catch on its own?
    - Language-specific conventions — worth it if Claude consistently generates non-idiomatic code for this stack
    - Framework patterns — worth it if the framework has strong opinions that Claude tends to violate
    - Domain rules — worth it if the domain has invariants that are expensive to get wrong (financial, medical, security)
    - If the answer is "maybe" — skip it. Add it via `/evolve` when you have evidence.

### Agent Assessment
39. **Would additional agents beyond the base set (SDD generator, plan generator, test validator) make a material difference?** The bar is: would this agent catch something the developer would otherwise miss?
    - Code review agent — material for solo developers on production systems
    - Security review agent — material for projects handling PII, financial data, or compliance-sensitive work
    - If the project is Level 1 or exploratory — the base agents are almost certainly sufficient.

### Command Assessment
40. **Are there community command patterns that address a known gap?** The bar is: does the developer already know they'll need this, based on past experience?
    - The core workflow (start-issue → plan-pr → implement → capture-learnings → close-issue) plus `/record` and `/evolve` covers most needs
    - Only add commands that address a specific, known pain point — not speculative ones
    - Prefer enhancing existing commands over adding new ones
    - When uncertain: start without it. `/record` + `/evolve` will surface the need if it's real.

---

## After Intake

Once these questions are answered, you should have enough to:

1. **Set the maturity level** (Level 1 or Level 2)
2. **Generate `current-architecture.md`** from the architecture discussion
3. **Generate `current-test-strategy.md`** from the testing discussion
4. **Configure the command workflow** with appropriate commands and agents
5. **Identify skills** needed from everything-claude-code or custom
6. **Set up Linear** with the right project, prefix, and ticket structure
7. **Establish the git workflow** (branching, PR process)
8. **Identify the active document set** and create templates

Write captured information to:
- `context/requirements.md`
- `context/decisions.md`
- `context/constraints.md`
- `context/questions.md` (for things that need more exploration)

If the project is existing (onboard path):
1. Analyze the codebase to generate living documents
2. Reverse prompt for what can't be inferred (intent, constraints, technical debt vs. deliberate choice)
3. Set up the command workflow
4. Start using it from the next ticket forward

If there are existing documents, transcripts, or notes, queue up `/process` to extract information.
