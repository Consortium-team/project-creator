# Capability: Process Evolution

Continuously improving the companion's own commands, agents, and skills based on usage experience.

---

## What It Is

Process evolution is the discipline of treating the companion's configuration — its commands, agents, skills, and protocols — as a living system that improves through use. The first version of any companion is never the best version. Commands are written based on assumptions about how work will flow. Those assumptions are wrong in ways that can only be discovered through actual use.

The pattern:

1. **Use** — Run the commands, follow the protocols, do the work.
2. **Record** — After each session, note what could have gone better. What was awkward? What took too long? What was missing? What was unnecessary?
3. **Analyze** — Periodically review accumulated records for patterns. One-off complaints are noise. Recurring themes are signal.
4. **Evolve** — Propose and implement concrete changes to commands, agents, or skills based on the patterns.
5. **Use** — Run the improved versions. The cycle repeats.

This is not occasional maintenance. It is a continuous improvement loop that runs alongside the companion's primary work.

---

## The Two Commands

Process evolution is powered by two commands that work together.

### /record

Captures a session-level observation about what could be improved. Run at the end of a session (or mid-session when something goes noticeably wrong).

**What it captures:**
- What happened (the specific situation)
- What was expected (what should have happened)
- What actually happened (the gap between expected and actual)
- Suggested improvement (optional — the user may not know the fix yet)

**Properties:**
- Quick to run (under 2 minutes)
- Low friction (should not feel like paperwork)
- Captures the moment while it is fresh
- Appends to a running log, not a structured analysis

### /evolve

Analyzes accumulated records and proposes concrete changes. Run periodically (every 5-10 sessions, or when the record log has 5+ entries).

**What it does:**
- Reads all accumulated session records
- Identifies recurring patterns (a complaint that appears once is noise; three times is a signal)
- Proposes specific changes to commands, agents, or skills
- Presents proposals with rationale and before/after comparisons
- Implements approved changes

**Properties:**
- Deliberate and thorough (takes a full working block)
- Produces actionable proposals, not vague suggestions
- Changes are always reviewed before implementation
- Changes are committed with clear rationale

---

## When to Use

Any companion that has been running long enough that its initial configuration needs tuning. This threshold is typically 5-10 sessions.

| Companion Type | Process Evolution Role | Weight |
|----------------|----------------------|--------|
| Game Designer | Core — design process evolves with the designer's maturity | Strong |
| Writing Mentor | Core — writing process and curriculum evolve with the writer | Strong |
| Product Manager | Recommended — strategy methodology evolves with the product | Moderate |
| Strategic Companion | Recommended — operational processes evolve with the business | Moderate |
| Software Developer | Moderate — development workflow evolves with codebase maturity | Moderate |

---

## Key Principle: Start Wrong, Iterate to Right

The first version of every command, protocol, and workflow is based on assumptions. Some of those assumptions will be wrong. This is expected and desirable — the alternative (spending excessive time on the perfect first version) is worse.

Process evolution gives permission to ship imperfect commands knowing that the improvement mechanism exists. The cost of starting wrong is low if the iteration loop is fast. The cost of waiting for perfect is high because "perfect" requires experience that only comes from use.

**The three-phase methodology applied to process itself:**
- **Seeding:** The initial commands and protocols are planted based on best guesses and reference projects.
- **Cultivation:** Through use, observations accumulate about what works and what does not. Records grow.
- **Shaping:** Evolved commands emerge — refined, adapted, and tested by actual use.

---

## What Gets Evolved

### Commands

Commands are the most common evolution target. Typical evolutions:

| Pattern | Example | Evolution |
|---------|---------|-----------|
| Missing step | /status reads context but not insights log | Add insights log reading step |
| Wrong order | /harvest captures insights before reviewing work | Reorder: review first, then capture |
| Too heavy | /checkpoint takes 10 minutes | Strip to essentials, make detailed capture optional |
| Too light | /seed produces surface-level prompts | Add mentor framing and craft assessment awareness |
| Missing command | No way to quickly add a decision | Create /decide command |

### Skills

Mentor skills and domain skills evolve as understanding deepens:

| Pattern | Example | Evolution |
|---------|---------|-----------|
| Shallow mentor | King mentor only references "On Writing" | Expand with "Danse Macabre" and interview material |
| Wrong invocation criteria | Le Guin mentor invoked for plot questions | Narrow "When to Invoke" to sentence-level and voice questions |
| Missing skill | No skill for handling writer's block | Create .claude/skills/creative-blocks/SKILL.md |

### Protocols

Session hygiene, insight capture, and other protocols evolve:

| Pattern | Example | Evolution |
|---------|---------|-----------|
| Too rigid | Session start always runs full protocol | Add "quick start" mode for short sessions |
| Missing trigger | No signal to run /evolve | Add session-count trigger to /status |
| Wrong frequency | Craft recalibration every 5 sessions is too frequent | Change to every 10 sessions |

### Agents

Agent prompts and parameters evolve:

| Pattern | Example | Evolution |
|---------|---------|-----------|
| Wrong model | Verification using Opus when Sonnet is sufficient | Switch verifier to Sonnet |
| Missing context | Executor agent does not receive insights log | Add insights log to executor prompt |
| Too broad | Agent tries to do too much in one pass | Split into focused sub-agents |

---

## The Evolution Discipline

Not every complaint warrants a change. Process evolution requires discipline to distinguish signal from noise.

### The Three-Occurrence Rule

A single observation is an anecdote. Two observations are a coincidence. Three observations are a pattern. Do not evolve commands based on single occurrences — wait for the pattern to confirm.

Exceptions:
- A command that fails catastrophically (loses data, produces wrong output) should be fixed immediately
- A command that is clearly missing a step (the user always has to do the step manually after the command runs) can be fixed on the second occurrence

### Before/After Analysis

Every proposed change should include:
- **Before:** What the command/skill/protocol does now
- **After:** What it will do after the change
- **Why:** The pattern in session records that motivated this
- **Risk:** What could go wrong with this change

### Reversibility

Evolved commands should be committed with clear commit messages so they can be reverted if the change makes things worse. The git history is the undo mechanism for process evolution.

---

## Relationship to Other Capabilities

### Session Hygiene
Session hygiene provides the structure that makes process evolution possible. The finish protocol is where /record is most naturally invoked. Without session hygiene, observations are lost.

### Insight Feedback Loop
Process observations are a form of insight — but about the companion's process, not the domain. The insights log tracks domain insights; session records track process observations. They are parallel feedback loops.

### Context Ecosystem
Evolved commands change how the context ecosystem is read and written. When a command gains a new step that reads an additional context file, the context ecosystem is effectively extended.

---

## Anti-Patterns

| Anti-Pattern | Problem | Better Approach |
|--------------|---------|-----------------|
| Evolving after one complaint | Changes based on noise, not signal | Wait for three occurrences (the pattern rule) |
| Evolving without records | Changes based on feeling, not evidence | Always base evolution on documented session records |
| Wholesale rewrites | Rewriting a command from scratch when small changes would suffice | Make the smallest change that addresses the pattern |
| Not testing evolved commands | Changing a command and never verifying it works | Run the evolved command in the next session and check |
| Evolution paralysis | Accumulating records but never running /evolve | Set a trigger (session count or record count) and commit to it |
| Changing what works | Evolving a command that is working well because it "could be better" | If it is not producing session records, leave it alone |
