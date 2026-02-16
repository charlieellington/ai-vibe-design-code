## Create Proposal Page: Fleetster Website

### Original Request
Create a proposal for the Fleetster website project — Visual + Build/Validate engagement for fleetster.de. Two sprints at €5k each (relationship rate). Context from fleetster-project-plan-1-website.md, pricing strategy, and existing fleetster-app proposal.

### Proposal Type
Type A: New Client (full template — evidence block, case studies, credentials included)

### Client Fit Analysis
Tim is not a Zebra Sprint target customer — he's an established company without urgency, not a seed-stage founder on a clock. But he's a warm relationship with a real project that fits sprint shapes when tightly scoped. €10k in April solves immediate cash flow, reduces financial anxiety, and buys time for proper outreach to target customers. The website project (Visual + Build/Validate) aligns with the sprint methodology — especially the in-person user testing component, which is the real differentiator.

### Proposal Content — Left Panel

**Client Identity:**
- clientName: Tim
- clientCompany: Fleetster
- slug: fleetster-website

**Sprint Info:**
- sprintType: "VISUAL + BUILD/VALIDATE"
- sprintCount: 2
- projectStart: "April 2026"
- timeline: "Two consecutive weeks"

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
- ctaHref: mailto:charlie@zebradesign.io?subject=Fleetster%20website%20sprints%20confirmed

**Meta:**
- createdAt: 2026-02-16
- contactEmail: charlie@zebradesign.io

### Proposal Content — Right Panel

**Personal Opening:**
> Tim, two weeks on the fleetster.de website. Week one: I explore 2–3 visual directions for how Fleetster presents itself to fleet managers. Week two: we build the chosen direction into a working landing page, test it with 5–6 real fleet managers, and iterate based on what they actually do.
>
> The testing is the real value — five sessions with fleet managers will tell you more about what works than any internal discussion. That data drives migration decisions, not assumptions.
>
> Two sprints at €5k each, honoring what we discussed in January. Standard rate is €10k per sprint.

**Evidence Block:** RESEARCH_TECH_EVIDENCE (default)
**Case Studies:** DEFAULT_CASE_STUDIES (default — Research Tech + Animatix)
**Client Logos:** DEFAULT_CLIENT_LOGOS (default)

**What You Get (custom):**
1. 2–3 visual directions explored — each a real concept, not a colour variation
2. Landing page built in Astro.js — connected to Sanity.io
3. In-person user testing with 5–6 fleet managers
4. Evidence-based iteration on the landing page
5. Migration recommendations + findings presentation

**How We Work (custom — day-by-day):**
- Day 1 (Mon) — Visual Direction Workshop
- Days 2–3 (Tue–Wed) — Visual Direction Exploration
- Day 4 (Thu) — Direction Selection + Build Starts
- Days 5–6 (Fri–Mon) — Build the Landing Page
- Day 7 (Tue) — In-Person User Testing
- Days 8–9 (Wed–Thu) — Analysis + Iteration
- Day 10 (Fri) — Presentation (Half Day)

**Custom Section — Before We Start:**
1. Recruit 5–6 fleet managers for testing day (critical gate)
2. Sanity.io read access
3. Confirm Eduard can work with Astro.js

**Boundaries Text (custom):**
This sprint builds one validated landing page — not templates for all three content areas. User testing evidence drives which pages to build next. SEO migration is your engineering team's responsibility. Charlie builds new header/footer components; integration into the existing site is Fleetster engineering's work.

**Closing Line:**
Reply to confirm and we'll lock in two consecutive weeks in April. Critical: 5–6 fleet managers need to be confirmed for testing day before we start.

### Reductions Applied
| Original | Reduced To | Why |
|----------|-----------|-----|
| 7 deliverables drafted | 5 deliverables | Merged component system into landing page, presentation into migration recs |
| 4 pre-sprint items | 3 items | Workshop attendees covered in Day 1 description |
| Separate "What's Not Included" section | Integrated into boundariesText | One field handles it |
| Verbose testing methodology | Kept in howWeWork Day 7 only | Details belong in process, not deliverables |
| 4-sentence personal opening | 3 paragraphs | Each paragraph earns its place: engagement, value of testing, pricing |

### Design Context
**Template reference:** /proposals/fleetster-app (the existing Fleetster prototype proposal)
**Component location:** /components/proposals/ (existing split-panel components)
**Data location:** /lib/proposals/ (types and defaults)
**Visual layout:** Split-panel, fixed left (320px lg, 400px xl) + scrollable right

### Codebase Context
**New file created:** /lib/proposals/fleetster-website.ts (proposal data)
**Route:** /app/proposals/fleetster-website (uses existing dynamic route)
**Pattern followed:** FLEETSTER_PROPOSAL in /lib/proposals/fleetster.ts + EXAMPLE_PROPOSAL in /lib/proposals/data.ts

### Plan
Step 1: ✅ Created /lib/proposals/fleetster-website.ts with ProposalData
Step 2: ✅ Imported and added to ALL_PROPOSALS array in /lib/proposals/data.ts
Step 3: No custom images needed — Tim's avatar already exists at /public/images/proposals/tim-fleetster.jpeg
Step 4: Test at localhost:3000/proposals/fleetster-website

### Assets Needed
- [x] Tim avatar — already exists at /public/images/proposals/tim-fleetster.jpeg

### Questions for User
1. April dates: specific weeks in April to lock in? The project plan says "from Foncil" — any preferred week?
2. Should the proposal link to the app prototype proposal (fleetster-app) or keep them completely separate?

### Stage
Ready for Review

### Priority
High — cash flow engagement for April

### Created
2026-02-16

### Files
- lib/proposals/fleetster-website.ts (new) ✅
- lib/proposals/data.ts (updated — added to ALL_PROPOSALS) ✅
