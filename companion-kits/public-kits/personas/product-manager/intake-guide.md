# Product Manager: Intake Guide

Type-specific questions for `/intake` when creating a product manager project.

---

## How to Use

When `/intake` is invoked for a product-manager type project, work through these questions. Not all questions apply to every product — use judgment about what to skip or reorder.

**Remember:** One question at a time. Let answers inform follow-up questions. Push for specificity — vague answers produce vague strategy.

---

## Phase 1: The Product Vision

### Core Idea
1. **What's the product idea?** (Describe it as you would to a friend — not a pitch deck)
2. **Where did this idea come from?** (Personal pain? Market observation? Customer request? Something else?)
3. **What problem does it solve?** (Be specific — "who has this problem" and "how bad is it?")

### Motivation
4. **Why you? Why now?** (What's your unfair advantage? What changed in the world?)
5. **What's the dream outcome?** (If this succeeds beyond expectations, what does it look like in 2-3 years?)

### The Quality
6. **What's the ONE thing that makes this product different?** (Not a feature list — the core insight. The thing that, if removed, would make this product pointless.)
   - Push hard here. This often takes multiple questions to uncover.
   - Examples: "It's the reverse prompting." "It's that we own the data layer." "It's the community network effect."

---

## Phase 2: Users and Market

### Target Users
7. **Who is the user?** (Be specific — not "everyone" or "small businesses")
   - What do they do today without this product?
   - How do they currently solve this problem (or work around it)?
8. **Are there multiple user segments?** If so:
   - Which segment would you test with first?
   - Why that one?

### Market Context
9. **What else exists in this space?** (Direct competitors, adjacent products, substitutes)
10. **Why do those solutions fall short?** (What's the gap they leave?)

### Validation
11. **Have you talked to potential users?** (What did they say? What surprised you?)
12. **Is there any evidence this works?** (Prototypes, MVPs, beta tests, analogies from other markets?)

---

## Phase 3: Strategy and Business Model

### Strategic Bets
13. **Tell me a story about something you've built before that succeeded.** (Not the product — the strategy pattern. What was the key insight that made it work?)
    - This reveals the founder's strategic instincts. Listen for patterns like:
      - Focus vs. breadth
      - Testing cheaply before investing
      - Finding the one metric that matters
      - Building moats vs. moving fast
    - Connect this pattern to the current product.

14. **What's your hypothesis?** (If they have one — don't force it. Some founders need to discover it through exploration.)
    - If they have one: "How would you test that?"
    - If they don't: "That's fine — we'll discover it. What do you believe most strongly about this product?"

### Business Model
15. **How does this make money?** (Or will it — what's the revenue model when it gets there?)
16. **What's the path from here to revenue?** (Phase 1 → Phase 2 → Phase 3, or a single focused bet?)

### Defensibility
17. **What would make this hard to copy?** (Network effects? Data moats? Brand? Switching costs?)
18. **What's your biggest strategic risk?** (The thing that keeps you up at night)

---

## Phase 4: Team and Constraints

### Team
19. **Who's on the team today?** (Solo? Co-founders? Contractors?)
20. **What capabilities are you missing?** (Technical? Design? Sales? Domain expertise?)

### Constraints
21. **What's your timeline?** (MVP in weeks? Fundraising deadline? Market window?)
22. **What's your budget?** (Bootstrapped? Seed funded? Revenue-funded?)
23. **What technical constraints exist?** (Platform requirements, integrations, regulatory, etc.)

### Development Approach
24. **How will this get built?** (AI-assisted development? Traditional engineering team? No-code? Hybrid?)
25. **What's the SDLC approach?** (This PM project handles left-side thinking — who handles the right-side building?)
    - If there will be a dev Claude project: note sibling project relationship
    - If external team: note handoff format requirements

---

## Phase 5: Working Style

### Session Rhythm
26. **How do you want to work with this PM?** (Daily check-ins? Weekly deep dives? On-demand when you need to think through something?)
27. **What does a productive PM session look like for you?** (Exploring? Pressure-testing? Generating specs? All of the above?)

### PM Voice Calibration
28. **How direct should the PM be?** (Most people say "very" — confirm)
    - "Should I push back hard when an idea doesn't hold up?"
    - "Should I tell you when you're avoiding a hard question?"
29. **Any topics that are off-limits or sensitive?** (Competitive dynamics, team issues, financial specifics?)

---

## After Intake

Once these questions are answered, you should have enough to:

1. **Articulate the product hypothesis** (or identify that it needs discovery through `/explore`)
2. **Define the target user segment** for initial focus
3. **Understand the strategic pattern** the founder uses (focus vs. breadth, testing instincts, etc.)
4. **Map the competitive landscape** at a high level
5. **Set the PM voice** (how challenging, what behaviors to emphasize)
6. **Establish the working rhythm** (session frequency, primary commands to use)
7. **Identify the dev handoff model** (sibling project, external team, not yet)

Write captured information to:
- `context/requirements.md`
- `context/decisions.md`
- `context/constraints.md`
- `context/questions.md` (for things that need more exploration)

If the founder has existing research, transcripts, or documents, queue up `/process` to extract insights.
