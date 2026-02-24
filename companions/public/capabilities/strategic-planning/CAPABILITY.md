# Capability: Strategic Planning

Hypothesis-driven strategic thinking as a decision lens. A central hypothesis anchors the project and filters every decision, scope choice, and priority call.

---

## What It Is

Strategic planning in the companion framework is not "make a plan and execute it." It is the discipline of maintaining a living strategic hypothesis that evolves as understanding deepens and acts as the decision filter for everything the companion does.

The pattern comes from the GreenChef case: discover the hypothesis first, test it cheaply, use it to filter every feature, scope, and priority decision. A product that tries to be everything for everyone is a product with no strategy. The hypothesis forces specificity.

---

## The Strategy-as-Anchor Pattern

Every companion project that uses strategic planning has a **strategy anchor** — a central hypothesis or set of principles that filters all downstream decisions.

The anchor is:
- **Living** — It evolves as evidence accumulates. Version 1 is speculative. Version 5 is tested.
- **Central** — Every command should be aware of it. It is not one context file among many — it is THE context file.
- **Testable** — A hypothesis that cannot be tested is not a hypothesis. It is a hope.
- **Falsifiable** — The companion should actively seek evidence that could disprove the hypothesis, not just confirm it.

### What the Anchor Looks Like

For a **product manager** companion, the anchor is a product hypothesis:
> "We believe [specific user segment] will [specific behavior] because [specific reason], and we can test this by [specific test]."

For a **game designer** companion, the anchor is a set of design pillars:
> "This game is about [core experience]. Every mechanic must serve [pillar 1], [pillar 2], or [pillar 3]. If a mechanic doesn't serve a pillar, it doesn't ship."

For a **strategic companion**, the anchor is a business hypothesis:
> "We believe [market positioning] will [competitive advantage] because [differentiated insight], measured by [specific metrics]."

---

## When to Use

| Companion Type | Role of Strategic Planning | Weight |
|----------------|---------------------------|--------|
| Product Manager | Central — the hypothesis IS the methodology | Core |
| Game Designer | Supporting — design pillars as strategy anchor for market fit | Common |
| Strategic Companion | Central — business strategy as the hypothesis | Core |
| Software Developer | Light — ADRs serve a similar function at the architecture level | Rare |
| Writing Mentor | Minimal — craft development does not typically use hypothesis-driven strategy | Rare |

---

## Hypothesis Lifecycle

Hypotheses are not born validated. They mature through stages.

### Speculative

The hypothesis is an initial guess. It has not been tested or even fully articulated. It may contain vague terms, undefined user segments, or untestable claims.

**Companion behavior:** Challenge the hypothesis aggressively. Push for specificity. Ask "Who exactly?" and "How would we test this?" and "What would prove this wrong?"

**Example:**
> "We think small businesses will want our product."
>
> Companion: "Which small businesses? A 3-person design studio and a 50-person manufacturing company are both 'small businesses' but have nothing in common. Which one are you picturing?"

### Proposed

The hypothesis is specific enough to be tested. It names a user segment, a behavior, a reason, and a test. It may not yet have evidence.

**Companion behavior:** Shift from challenging the hypothesis to designing tests. Ask "What's the cheapest way to test this?" and "What evidence would make you abandon this?"

**Example:**
> "We believe solo founders building AI products will pay for a PM thinking partner because they lack a co-founder to challenge their thinking. We can test this by offering 5 free sessions and measuring re-engagement."

### Tested

Evidence has been gathered for or against the hypothesis. The hypothesis may have been refined based on what was learned.

**Companion behavior:** Analyze evidence. Surface contradictions between hypothesis and evidence. Propose refinements. Track what was learned.

**Example:**
> "3 of 5 solo founders re-engaged. But the 2 who didn't said the PM voice was too aggressive for their stage — they needed encouragement first, challenge later. Refining: segment by founder maturity."

### Validated

The hypothesis has survived multiple tests and the evidence supports it. It becomes the decision lens with high confidence.

**Companion behavior:** Use the hypothesis confidently as a filter. When the user proposes a feature, scope change, or priority shift, evaluate it against the validated hypothesis. Flag anything that does not serve it.

---

## Key Principle: Every Command Should Be Hypothesis-Aware

The strategy anchor is not just for strategic commands. It should influence every interaction.

- `/explore` should filter exploration topics against the hypothesis: "This is interesting, but does it serve our hypothesis?"
- `/process` should connect meeting insights to the hypothesis: "This customer said X, which [supports | challenges | is orthogonal to] our hypothesis."
- `/spec` should scope features against the hypothesis: "This feature serves hypothesis pillar 2 directly. This other feature is nice-to-have but doesn't serve any pillar."
- `/synthesize` should evaluate accumulated insights against the hypothesis: "Three of your last five insights point to a different user segment than your hypothesis targets. Worth revisiting?"

---

## Evidence Tracking

Strategic planning requires tracking evidence for and against the hypothesis.

### Evidence Types

| Type | Source | Example |
|------|--------|---------|
| **Direct** | User research, customer conversations | "5 of 7 users said they would pay for this" |
| **Indirect** | Market signals, competitor behavior | "Competitor X just pivoted away from this segment" |
| **Contradictory** | Any source | "Our hypothesis says users want simplicity, but power users keep asking for advanced features" |
| **Absent** | Expected evidence that didn't appear | "We expected sign-ups from the launch. None came." |

### The Contradiction Discipline

Contradictory evidence is the most valuable. Companions must surface it immediately and prominently — not bury it in a summary.

Pattern:
> "Your hypothesis says [X]. But this meeting transcript contains [Y], which directly contradicts that. Three options: (1) the hypothesis is wrong, (2) this evidence is an outlier, (3) the hypothesis needs refinement. Which do you think?"

---

## Relationship to Other Capabilities

### Reverse Prompting
Reverse prompting discovers the hypothesis. Strategic planning maintains and tests it. The seeding phase is where the hypothesis first emerges — through questions, not through generation.

### Context Ecosystem
The hypothesis lives in `context/product/hypothesis.md` (or equivalent persona-specific location). It is a living document that evolves over time. Evidence is tracked alongside it.

### Meeting Processing
Meetings are a primary source of evidence for or against the hypothesis. The meeting processing capability should automatically evaluate new information against the current hypothesis.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Untestable hypothesis | "We will build the best product" is not testable | Push for specific, falsifiable claims |
| Hypothesis as mission statement | Static, never challenged, never updated | Living document with version history |
| Confirmation bias | Only tracking supporting evidence | Actively seek and surface contradictions |
| Strategy without evidence | Hypothesis stays speculative forever | Design and run cheap tests |
| Feature-first thinking | Building features without strategy filter | Every feature must serve the hypothesis |
| Hypothesis worship | Refusing to update despite contradictory evidence | Hypotheses are meant to be refined or abandoned |
