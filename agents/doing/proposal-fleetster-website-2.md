## Create Proposal Page: Fleetster Website (v2)

### Original Request
Re-run design-1-proposal.md for the Fleetster website project. Take the existing fleetster-website proposal as inspiration but fix: (1) restore standard template boundaries, (2) use DEFAULT_HOW_WE_WORK + separate Timeline section for day-by-day, (3) add sprint questions as subheading + list in personal opening, (4) keep 5 deliverables, (5) add "What's Not Included" custom section (after-process). Slug: fleetster-website-2.

### Proposal Type
Type A: New Client (full template — evidence block, case studies, credentials included)

### Client Fit Analysis
Tim is not a Zebra Sprint target customer — he's an established company without urgency, not a seed-stage founder on a clock. But he's a warm relationship with a real project that fits sprint shapes when tightly scoped. €10k in April solves immediate cash flow, reduces financial anxiety, and buys time for proper outreach to target customers. The website project (Visual + Build/Validate) aligns with the sprint methodology — especially the in-person user testing component.

### Proposal Content — Left Panel

**Client Identity:**
- clientName: Tim
- clientCompany: Fleetster
- slug: fleetster-website-2
- sidebarLabel: Website Redesign

**Sprint Info:**
- sprintType: "VISUAL + BUILD/VALIDATE"
- sprintCount: 2
- projectStart: "30 March 2026"
- timeline: "30 March – 10 April 2026"

**Investment:**
- totalPrice: 10000
- originalPrice: 20000
- discountLabel: "January rate"
- currency: "EUR"
- paymentSchedule:
  - Sprint 1 (Visual): €5,000 — Before Workshop 1
  - Sprint 2 (Build/Validate): €5,000 — Before Sprint 2

**CTA:**
- ctaText: "Confirm & Start"
- ctaHref: mailto:charlie@zebradesign.io?subject=Fleetster%20website%20sprints%20confirmed&body=Charlie%2C%0A%0ALet%27s%20go%20with%20the%20website.%0A%0ATim

**Client Avatars:**
- Tim: /images/proposals/tim-fleetster.jpeg

**Meta:**
- createdAt: 2026-02-16
- contactEmail: charlie@zebradesign.io

### Proposal Content — Right Panel

**Section 1: Personal Opening**

Three paragraphs + sprint questions block (subheading + numbered list). The personalOpening field is `string | string[]` — currently renders paragraphs only. To support a subheading + numbered list, the PersonalOpening component needs extending. See "Component Changes" below.

Paragraph 1 (engagement overview):
> Tim, two weeks on the fleetster.de website. Week one: I explore 2–3 visual directions for how Fleetster presents itself to fleet managers. Week two: we build the chosen direction into a working landing page, test it with 5–6 real fleet managers, and iterate based on what they actually do.

Paragraph 2 (value argument):
> Why two weeks instead of one? One week gives you a new visual direction and a landing page based on my experience. Two weeks gives you a validated landing page — tested with real fleet managers who actually try to use it. The difference is evidence vs. assumption. After 60+ product sprints with my agency, this is where the real value is — not just the design, but knowing what to do with what your users show you.

Paragraph 3 (pricing — UPDATED):
> Two sprints at €5k each — the rate we agreed in January, held for an earliest April start after current booked projects.

Sprint Questions (subheading + numbered list — NEW):

Subheading: "Three questions drive every design decision"

1. Can fleet managers understand what Fleetster does within 30 seconds of landing?
2. Can users find the content they need — product updates, fleet knowledge, or pricing — without getting lost?
3. Does the new design build trust with fleet management decision-makers?

Footer line: "These are testable. We'll answer each with evidence from the user testing sessions, not opinion."

**Section 2: Evidence Snapshot** — RESEARCH_TECH_EVIDENCE (default)

**Section 3: Case Studies** — DEFAULT_CASE_STUDIES (default — Research Tech + Animatix)

**Section 4: Custom Section — The Two Weeks (position: before-deliverables)**

The day-by-day timeline as its own section, separate from How We Work. Shows the engagement shape — Tim needs to understand this because Visual + Build/Validate is non-standard.

Title: "The Two Weeks"
Intro: "Two sprints across two consecutive weeks. Sprint 1 explores direction. Sprint 2 builds, tests, and iterates."

7 items, 1 sentence each:

1. "Day 1 (Mon) — Visual Direction Workshop"
   "2–3 hours with your team. Define audience priority, visual positioning, and brand constraints."

2. "Days 2–3 (Tue–Wed) — Visual Direction Exploration"
   "Charlie explores 2–3 distinct directions. Daily Loom updates. Shared Wednesday evening."

3. "Day 4 (Thu) — Direction Selection + Build Starts"
   "Select direction, define landing page scope. Scope locked. Building starts immediately."

4. "Days 5–6 (Fri–Mon) — Build the Landing Page"
   "Landing page in Astro.js + Sanity.io. Deployed to preview URL Monday evening."

5. "Day 7 (Tue) — In-Person User Testing"
   "5–6 moderated sessions. First impressions, findability tasks, trust comparisons."

6. "Days 8–9 (Wed–Thu) — Analysis + Iteration"
   "ICP-weighted analysis. Quick fixes shipped. Design system docs for Eduard."

7. "Day 10 (Fri) — Presentation (Half Day)"
   "Video clips, findings, sprint question answers, migration recommendations. Handoff."

**Section 5: Deliverables (custom — 5 items)**

Checked against DEFAULT_WHAT_YOU_GET and positioning canvas. Workshop deliverable not added — user decision: Tim doesn't care much for them. Workshops are visible in The Two Weeks timeline (Day 1 + Day 4) and in deliverable descriptions.

1. **2–3 visual directions explored — each a real concept, not a colour variation**
   "Each direction includes hero concept, typography and colour system, component style, and overall visual tone. Charlie recommends one with rationale. You pick."

2. **Landing page built in Astro.js — connected to Sanity.io**
   "Hero with clear value proposition, features for your prioritised audience, social proof, CTA, and responsive design. Header and footer components included. Production code with component system and design tokens for Eduard."

3. **In-person user testing with 5–6 fleet managers**
   "First impression tests, content findability tasks, and trust comparisons against competitors. ICP-weighted analysis — a 200-vehicle fleet manager's feedback is weighted higher than a 5-vehicle operator's."

4. **Evidence-based iteration on the landing page**
   "Two full days to analyse findings and iterate. Quick fixes shipped: copy adjustments, layout reordering, CTA improvements, removing confusing elements."

5. **Migration recommendations + findings presentation**
   "Sprint question answers backed by data. Video clips from testing sessions. Migration priority recommendations — which pages to move first, based on what users actually look for. Design system documentation for Eduard."

**Section 6: How We Work** — DEFAULT_HOW_WE_WORK (standard template)

4 default bullets:
1. Async-first — Daily Loom updates, no standups
2. Scope freeze — Locked after the workshop
3. Deep work — Concentrated design sessions (with Dracula effect tooltip)
4. Day 1 guarantee — Full refund if we don't cover the scope you need in workshop 1

No sectionTitle or sectionIntro overrides — uses the component's default "How We Work" heading. The day-by-day timeline lives in its own "The Two Weeks" custom section above.

processDocsLink: "https://www.zebradesign.io/docs/how-zebra-sprints-work"

**Section 7: Boundaries Text** — DEFAULT_BOUNDARIES_TEXT (restored)

"We've made assumptions and boundaries to create the quote and process. It's important you understand these points in case we need to make adjustments to scope and quote and you have no surprises during the project."

**Section 8: Client Logos** — DEFAULT_CLIENT_LOGOS (default)

**Section 9: Custom Section — What's Not Included (position: after-process)**

Three items from fleetster-project-plan-1-website.md "Addressing What's Not Included." Placed after-process — Tim reads it after understanding the full engagement.

Title: "What's Not Included"
Intro: "Three things this engagement doesn't cover — so there are no surprises."

Item 1:
- title: "One validated landing page — not templates for all three content areas"
- description: "You identified three content areas: product updates, fleet knowledge, and feature pages. This engagement builds one validated landing page — the front door. Building all three without testing any means guessing three times. User testing evidence drives which pages to build next."

Item 2:
- title: "SEO preservation is your engineering team's responsibility"
- description: "This engagement preserves SEO by reusing existing Sanity.io content — nothing is deleted or restructured. Technical SEO migration — redirects, canonical URLs, structured data — is Fleetster engineering's work. Migration priority recommendations from testing will inform which pages to move first."

Item 3:
- title: "Header and footer integration is Fleetster engineering's work"
- description: "Charlie builds new header and footer components in the chosen direction. Integration into the old site is your team's responsibility. Charlie delivers the components and documentation — Eduard handles the dual implementation."

**Section 10: Custom Section — Before We Start (position: after-process)**

Title: "Before We Start"
Intro: "Three things need to be in place before Day 1."

1. "Recruit 5–6 fleet managers for testing day"
   "Mix of existing customers and potential customers. Must be confirmed and scheduled for Day 7 before the engagement starts. No testing without participants — this is the critical gate."

2. "Sanity.io read access"
   "So I can assess the content model and understand existing schemas before building."

3. "Confirm Eduard can work with Astro.js"
   "The component system and design tokens will be in Astro.js + Tailwind. Eduard needs to be able to extend them after the sprint."

**Section 11: Closing Line**

"Reply to confirm and we'll lock in two weeks from 30 March. Critical: 5–6 fleet managers need to be confirmed for testing day before we start."

### Render Order (how these sections appear on the page)

1. Personal Opening (3 paragraphs + sprint questions subheading/list)
2. **The Two Weeks** (custom section, before-deliverables) — day-by-day timeline
3. What You Get — 5 deliverables
4. Evidence Snapshot — Research Tech
5. Case Studies — Research Tech + Animatix
6. How We Work — DEFAULT (async-first, scope freeze, deep work, Day 1 guarantee) + boundaries + payment
7. **What's Not Included** (custom section, after-process) — 3 exclusions
8. **Before We Start** (custom section, after-process) — 3 prerequisites
9. Credentials — client logos
10. Next Steps — closing line

### Component Changes

**PersonalOpening component** needs to support a sprint questions block (subheading + numbered list) after the paragraphs. Options:

Option A: Extend `personalOpening` type to accept structured content:
```typescript
personalOpening: string | string[] | (string | { type: 'sprint-questions'; heading: string; questions: string[]; footer?: string })[];
```

Option B: Add a new optional field to ProposalData:
```typescript
sprintQuestions?: {
  heading: string;
  questions: string[];
  footer?: string;
};
```

Recommendation: Option B — cleaner separation, doesn't pollute the personalOpening type. The PersonalOpening component checks for `sprintQuestions` prop and renders the block after the paragraphs.

### Reductions Applied

| Original | Reduced To | Why |
|----------|-----------|-----|
| 3-paragraph opening | 3 paragraphs + sprint questions block | User requested sprint questions in header as subheading + list |
| 7 howWeWork items in How We Work section | DEFAULT_HOW_WE_WORK (4 bullets) + separate Timeline custom section | User: use default bullets, add Timeline section for day-by-day |
| Day-by-day descriptions 2-3 sentences each | 1 sentence each in Timeline section | "Too dense — quick parts" |
| Custom boundariesText with embedded exclusions | DEFAULT_BOUNDARIES_TEXT + "What's Not Included" section | User: restore template boundaries. Project plan: exclusions prominent, not buried |
| 6 deliverables (with workshops) | 5 deliverables | User: keep at 5, Tim doesn't care. Workshops visible in Timeline Day 1 + Day 4 |
| "honoring what we discussed in January" | "the rate we agreed in January, held for an earliest April start after current booked projects" | User update — clarifies timing constraint |

### Validation Checklist

- [x] One recommendation, no menu — sprint count stated, not offered as options
- [ ] Custom opening is 2-3 sentences — **DEVIATION**: 3 paragraphs + sprint questions block. User explicitly overrode.
- [x] Proposal ≠ contract — no legal language
- [x] Content maps to ProposalData interface — all fields have values (sprintQuestions requires new optional field)
- [x] REDUCE pass completed — documented above

### Design Context
**Template reference:** /proposals/example (the standard template)
**Component location:** /components/proposals/ (existing split-panel components)
**Data location:** /lib/proposals/ (types and defaults)
**Visual layout:** Split-panel, fixed left (320px lg, 400px xl) + scrollable right

### Codebase Context
**New file needed:** /lib/proposals/fleetster-website-2.ts (proposal data)
**Route:** /app/proposals/fleetster-website-2 (uses existing dynamic route)
**Pattern to follow:** FLEETSTER_PROPOSAL in /lib/proposals/fleetster.ts + EXAMPLE_PROPOSAL in /lib/proposals/data.ts

### Plan
Step 1: Add `sprintQuestions` optional field to ProposalData interface in types.ts
Step 2: Update PersonalOpening component to render sprint questions block when present
Step 3: Create /lib/proposals/fleetster-website-2.ts with ProposalData
Step 4: Import and add to ALL_PROPOSALS array in /lib/proposals/data.ts
Step 5: Test at localhost:3000/proposals/fleetster-website-2
Step 6: Update /lib/proposals/fleetster.ts boundariesText link from /proposals/fleetster-website to /proposals/fleetster-website-2

### Assets Needed
- [x] Tim avatar — already exists at /public/images/proposals/tim-fleetster.jpeg

### Questions for User
None — all decisions resolved.

### Stage
Ready for Review

### Priority
High — cash flow engagement for April

### Created
2026-02-16

### Files
- lib/proposals/types.ts (add sprintQuestions optional field)
- components/proposals/sections/personal-opening.tsx (render sprint questions block)
- lib/proposals/fleetster-website-2.ts (new)
- lib/proposals/data.ts (add to ALL_PROPOSALS)
- lib/proposals/fleetster.ts (update cross-link)
