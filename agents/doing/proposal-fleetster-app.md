## Create Proposal Page: Fleetster

### Original Request

Create a proposal for Tim / Fleetster for the Fleetster Small prototype transformation. Build + Validate engagement — two sprints at €5k/sprint = €10k total. This is proposal 2 of 2 (the website proposal is being handled separately and comes first in the sales strategy). The prototype proposal follows the `1-tim-proposal-context.md` strategy closely and fits the standard template.

### Proposal Type

Type A: New Client (full template) — Tim is a past client but this is the first Zebra Sprint engagement.

### Client Fit Analysis

Tim is not the ideal Zebra Sprint target customer — established company, no urgency, historically price-sensitive (~€569/day anchor from 2024). But his February 2026 email showed a genuine behavioral shift: framing in weeks not scattered days, a working prototype in shadcn, asking about availability for "a week." The prototype transformation is a clean sprint shape — pure UX transformation of a raw data table into a real product. Closest parallel to Research Tech.

**The pragmatic case:** €10k in April fills a cash flow gap with zero acquisition cost, buys time for outreach to target customers. Tim fills a gap. He doesn't define the business.

**Critical boundaries to hold:** Tim's January instinct was "one day per week for five weeks" and "chasing developers." The sprint model boundary must be absolute — compressed weeks, scope freeze, no ongoing availability.

---

### Proposal Content — Left Panel

```
clientName: "Tim"
clientCompany: "Fleetster"
slug: "fleetster"
sidebarLabel: "Prototype Transformation"

sprintType: "BUILD + VALIDATE"
sprintCount: 2
projectStart: "April 2026"
timeline: "Two consecutive weeks"

totalPrice: 10000
originalPrice: 20000
discountLabel: "January rate"
currency: "EUR"

paymentSchedule:
  - Sprint 1 (Build): €5,000 — Before Workshop 1
  - Sprint 2 (Validate): €5,000 — Before Sprint 2

ctaText: "Confirm & Start"
ctaHref: "mailto:charlie@zebradesign.io?subject=Fleetster%20sprints%20confirmed&body=Charlie%2C%0A%0ALet%27s%20go.%0A%0ATim"

clientAvatars:
  - { src: "/images/proposals/tim-fleetster.jpeg", alt: "Tim" }

createdAt: "2026-02-16"
contactEmail: "charlie@zebradesign.io"
```

---

### Proposal Content — Right Panel

#### Section 1: Personal Opening (CUSTOM)

```
personalOpening: [
  "Tim, the Fleetster Small prototype is the right shape for a Build + Validate engagement — transform the UX in your shadcn codebase, then test it with real fleet managers before your developers build further.",
  "Two sprints at €5k each, honoring what we discussed in January. Standard rate is €10k per sprint."
]
```

#### Section 2: Evidence Snapshot (TEMPLATE)

Use `RESEARCH_TECH_EVIDENCE` from defaults — no changes.

#### Section 3: Case Studies (TEMPLATE)

Use `DEFAULT_CASE_STUDIES` — Research Tech + Animatix.

#### Section 4: What You Get (CUSTOM)

| # | Title | Description |
|---|-------|-------------|
| 1 | Workshop — your team's knowledge drives the design | Your domain experts and developers join the workshop. We map prototype priorities, user flows, and system scope together. Everyone aligned as stakeholders — no feedback rounds. |
| 2 | Prototype UX transformation — shipped to your shadcn codebase | The Fleetster Small prototype redesigned with proper UX thinking — visual design, information hierarchy, navigation patterns applied to your existing shadcn/Tailwind code. Production code, not a Figma file. |
| 3 | User validated — tested with 5–6 real fleet managers | Facilitated user test sessions reveal what works and what doesn't before developers build further. Real fleet managers using the actual prototype — evidence, not assumptions. |
| 4 | Evidence-based iteration on the prototype | With the results of the user tests, we iterate on the design to implement changes. Quick fixes shipped during the validate sprint. |
| 5 | Strategic recommendations — presentation and clear next steps | Prototype and user testing results presented with strategic recommendations. Clear direction for what the full system should look like after the prototype phase. |

#### Section 5: How We Work (TEMPLATE)

Use `DEFAULT_HOW_WE_WORK` — async-first, scope freeze, deep work, Day 1 guarantee. Standard operational principles.

Add `processDocsLink: "https://www.zebradesign.io/docs/how-zebra-sprints-work"`

#### Section 6: Boundaries Text (CUSTOM)

```
boundariesText: "The sprint scope covers the front-end UX transformation and user validation described above. It does not include backend development, developer coordination, Eduard training, website design, or ongoing availability after sprint completion."
```

#### Section 7: Client Logos (TEMPLATE)

Use `DEFAULT_CLIENT_LOGOS`.

#### Section 8: Closing

```
closingLine: "Reply to confirm and we'll lock in two consecutive weeks in April."
```

---

### Reductions Applied

| Original | Reduced To | Why |
|----------|-----------|-----|
| 3-sentence opening with context about website being separate proposal | 2 paragraphs, 3 sentences — prototype only, price anchored | This proposal is only about the prototype. Website context belongs in the email reply, not here. |
| 6 deliverables including design system documentation | 5 deliverables aligned to DEFAULT_WHAT_YOU_GET structure | Design system is implied in transformation deliverable. Keep template shape. |
| Custom scope boundaries section (3 items) | Single boundariesText paragraph | One text block is simpler than a custom section. Template-conformant. |
| Custom day-by-day How We Work | DEFAULT_HOW_WE_WORK (4 operational bullets) | User requested template-conformant. Standard Build + Validate doesn't need day-by-day. |

---

### Design Context

**Template reference:** /proposals/example (the standard template)
**Component location:** /components/proposals/ (existing split-panel components)
**Data location:** /lib/proposals/ (types and defaults)
**Visual layout:** Split-panel, fixed left (320px lg, 400px xl) + scrollable right
**Pattern to follow:** EXAMPLE_PROPOSAL in data.ts (standard template) + TBLA for ProposalData structure

### Codebase Context

**New file needed:** /lib/proposals/fleetster.ts (proposal data)
**Route:** /app/proposals/fleetster (uses existing dynamic route)
**Pattern to follow:** EXAMPLE_PROPOSAL in /lib/proposals/data.ts
**Registry update:** Add to ALL_PROPOSALS array in /lib/proposals/data.ts

### Plan

Step 1: Create /lib/proposals/fleetster.ts with ProposalData
Step 2: Import FLEETSTER_PROPOSAL and add to ALL_PROPOSALS array in /lib/proposals/data.ts
Step 3: Avatar images already in /public/images/proposals/
Step 4: Test at localhost:3000/proposals/fleetster

### Assets

- [x] Client avatar: `/public/images/proposals/tim-fleetster.jpeg`
- [x] Fleetster logo: `/public/images/proposals/fleetster-logo.jpeg` (available if needed)

### Questions for User

1. **Email reply draft:** Saved separately to `zebra-planning/6-clients-and-past-work/fleetster/tim-reply-draft.md`. It references both proposals (website + prototype) with a placeholder for the website proposal link.

### Stage

Ready for Review

### Priority

High — proposal should be ready to send when Tim returns from Geotab.

### Created

2026-02-16

### Files

- lib/proposals/fleetster.ts (new)
- lib/proposals/data.ts (add to ALL_PROPOSALS)
- public/images/proposals/tim-fleetster.jpeg (added)
- public/images/proposals/fleetster-logo.jpeg (added)
- zebra-planning/6-clients-and-past-work/fleetster/tim-reply-draft.md (email reply draft — new)
