## Create Proposal Page: TBLA — Practice Intelligence Dashboard

What this file does: Complete proposal content and build plan for Peter Ellington at TBLA. Custom format — deeper than a standard Zebra Sprint proposal because the deliverables, scope rationale, and validation boundary need explaining in detail. This is a production tool sprint, not a design sprint.

---

### Original Request

Create a proposal for TBLA — Practice Intelligence Dashboard for Dad (Peter Ellington). One Zebra Sprint, €5,000, starting 26 Feb 2026. Custom format with depth on: (1) goals and deliverables, (2) process and expected outcomes, (3) why this scope and what changed during planning, (4) clear validation endpoint. Reference: `zebra-planning/6-clients-and-past-work/tbla/tbla-sprint-plan.md` and draft history.

### Proposal Type

**Custom — Family Client (deeper than Type A or B)**

This isn't a standard new-client pitch or an existing-client booking. It's a detailed brief for a family member who needs to understand exactly what he's getting, why this approach was chosen over alternatives, and where the boundaries are. No evidence block or case studies needed — Dad knows the work. The depth goes into goals, process, and scope rationale instead.

### Client Fit Analysis

Family client. Not an ICP match (accounting practice, not a seed-stage startup) but high strategic value: first non-design sprint validates the methodology for production tool projects. Price (€5k) is below the €8k floor — accepted because it's family and a proof-of-concept for a new sprint type. Does not set external pricing precedent.

---

### Proposal Content — Left Panel

```markdown
**Client Identity:**
- clientName: "Peter"
- clientCompany: "TBLA"
- slug: "tbla"

**Sprint Info:**
- sidebarLabel: "Practice Intelligence"
- sprintType: "BUILD"
- sprintCount: 1
- projectStart: "26 February 2026"
- timeline: "Feb 26 – Mar 5, 2026"

**Investment:**
- totalPrice: 5000
- currency: "EUR"
- priceSize: "text-2xl"
- paymentSchedule:
  - Full payment: €5,000 — After delivery

**CTA:**
- ctaText: "Confirm & Start"
- ctaHref: "mailto:charlie@zebradesign.io?subject=TBLA%20Practice%20Intelligence%20confirmed&body=Charlie%2C%0A%0ALooks%20good.%20Let%27s%20go.%0A%0APeter"
- hideBookCallLink: true

**Avatars:**
- clientAvatars:
  - { src: "/images/proposals/peter-ellington.png", alt: "Peter Ellington" }
  - { src: "/images/proposals/charlie-avatar.webp", alt: "Charlie Ellington" }
- hideSecondAvatar: false

**Validity:**
- validUntil: "2026-03-02"
- validUntilDisplay: "2 March 2026"

**Meta:**
- createdAt: "2026-02-16"
- contactEmail: charlie@zebradesign.io
```

---

### Proposal Content — Right Panel

**This proposal follows a custom structure, not the standard template.** The right panel has 7 sections instead of the usual evidence → case studies → deliverables → how we work flow. No evidence block, no case studies, no client logos.

---

#### Section 1: Personal Opening

> Hey Dad, after listening to what you need and spending time researching every system — APIs, data formats, what connects and what doesn't — I've put together a plan for the first sprint. One week, focused on getting all your data into one place and giving you the tools to actually use it.

> This confirms what we'll build, how the week works, and what you'll have at the end.

---

#### Section 2: Your 4 Goals (sectionTitle: "Your Goals")

These are the goals we're solving for. Everything in this sprint is built to deliver these.

**1. One place with everything about every client**
Right now your client data lives across BrightManager, FreeAgent, TaxCalc, QuickBooks, Xero, and Excel. No single system has the full picture. This sprint pulls all of them together into one unified database — every client, every system, matched and browsable.

**2. Ask questions of that data — see top clients, growth opportunities, upsell targets**
Once unified, the data becomes queryable. A dashboard shows the key information at a glance: your top clients by revenue, who owes money, and which systems have data for each client. For deeper questions — "which clients could go to India?", "who's growing but hasn't added services?" — you use an AI tool called Conductor that can query the full dataset with no limits.

**3. Identify which work can go to India vs stays in the UK**
With the full picture of each client's services, complexity, and accounting software, you can assess outsourcing suitability. Conductor lets you ask exactly this question across all 400 clients and get a structured answer.

**4. Manage clients with debts**
FreeAgent connects live to the dashboard, so outstanding invoices, overdue amounts, and payment status are always current. No more checking FreeAgent separately — debt information appears alongside everything else.

---

#### Section 3: Why This Approach (sectionTitle: "Why This Scope")

sectionIntro: "I explored three different approaches before arriving at this one. Here's why this is the right balance."

**What I considered:**

The first plan tried to build everything: a full AI analysis layer with automated client scoring, outsourcing assessments, data quality scanning, and a practice summary — on top of the dashboard and data imports. Six AI features in one week. Too much. The data layer wouldn't get the attention it needs, and if the imports or matching are wrong, everything built on top is unreliable.

The second plan swung the other way: unify the data and use only Conductor (the AI chat tool) for all analysis. No dashboard at all. But you asked for a dashboard — something you can open and glance at without typing a query every time. A tool with no visual interface misses that.

**What we're building instead:**

Rather than focus on data automation (live API connections to every system), I've focused on gathering all the data to unify it first, then showing key information on a dashboard, then using an existing AI tool (Conductor) to query it and make decisions — rather than building a custom AI interface from scratch.

This is better than the alternatives:
- **Focus only on APIs and data input** → you get the data in one place but no way to interact with it or see insights at a glance
- **Focus on a custom dashboard with built-in AI** → less time on the data layer, less accuracy in matching, and the AI features are limited to what I pre-build in one week

The approach we're taking means the data layer gets the most development time (because that's the hard problem), you get a dashboard for the obvious questions, and Conductor gives you unlimited flexibility for everything else. Then future sprints can optimise based on what you actually use — hardening your most common Conductor queries into permanent dashboard views, adding live API connections where CSV refresh isn't fast enough, or building team-facing pages.

---

#### Section 4: What You Get (expandDeliverables: true)

**1. Unified data from all 6 systems**
BrightManager, FreeAgent, TaxCalc, QuickBooks, Xero, and Excel data imported into one database. AI matches clients across systems automatically — BrightManager is the canonical source, everything else matches to it. A review queue lets you confirm, reject, or manually fix any uncertain matches. Re-import support means you can refresh data monthly without creating duplicates.

**2. Live billing and debt data from FreeAgent**
OAuth 2.0 connection to FreeAgent pulls invoices, payments, outstanding balances, and overdue status in real time. This is the only data that changes daily — everything else moves slowly enough for CSV imports.

**3. Client dashboard with 3 key views**
A browsable list of all ~400 clients showing which systems have data for each one and whether they're matched. Three views you can open and glance at: top clients by revenue, outstanding debts with amounts and duration, and a data coverage summary showing import freshness per system.

**4. Match review queue**
AI-suggested matches shown with confidence levels. "380 confident matches, 15 uncertain, 5 no-matches — review the uncertain ones." You can confirm, reject, or manually link. This is critical trust-building — if the matches are wrong and you can't fix them easily, the tool is useless.

**5. Conductor AI agent — unlimited queries on your data**
A trained AI agent that knows your database schema, your 4 goals, and what each system's data means. Pre-built example queries to get you started. Can query the database directly, generate visualisations, and do multi-step analysis. Your query history is saved automatically — over time this builds a record of what you actually ask, which tells us what a future sprint should build into the dashboard permanently.

**6. Deployed and working**
Hosted on Vercel, accessible from any browser. Your data stays in a Supabase database in the UK/EU region. You own the data — it's your database instance.

---

#### Section 5: The Week (sectionTitle: "The Week", sectionIntro: "Six working days across one week. Here's what happens each day and what you'll see at each stage.")

**Day 1 (Thu 26 Feb) — Workshop + Setup**
We sit down together and walk through each system. You export sample CSVs from BrightManager, TaxCalc, and the others. We define which fields matter, identify 20 test clients to validate matching against, and I install Conductor on your machine and we practice example queries together. By the end of the day: database schema is built, FreeAgent OAuth is connected, and you've seen Conductor answer a question about your data.

**Day 2 (Fri 27 Feb) — Data Import Pipeline**
BrightManager CSV import built first (canonical source), then TaxCalc, FreeAgent, QuickBooks, Xero. AI matching logic running on upload — clients matched across systems automatically. By the end of the day: your test clients are in the database, matched across systems, and you can see the raw data working.

**Day 3 (Mon 2 Mar) — Core Build**
Client list view with search and sorting. Match review queue for uncertain matches. FreeAgent API integration pulling live billing data. Upload management UI so you can re-import when data changes. By the end of the day: a working app where you can browse clients, see data coverage, and review matches.

**Day 4 (Tue 3 Mar) — Dashboard + Conductor**
Three dashboard views built (top clients, debts, data coverage). Conductor agent file refined with real data in the database. Test queries together — top clients, debt, India suitability. Data quality checks. Deploy to Vercel. By the end of the day: the dashboard is live and Conductor is answering questions accurately.

**Day 5 (Wed 4 Mar) — Validation with All 400 Clients**
This is the critical day. All 400 clients imported and matched. You test: does the client list match your mental model? Do the dashboard views answer your quick-glance needs? Can Conductor answer your deeper questions? We iterate based on what you find. Set up the re-import process so you can refresh data yourself. By the end of the day: working tool with your real data, deployed, Conductor trained and ready.

**Day 6 (Thu 5 Mar) — Buffer + Polish**
For anything that needs fixing from Day 5 testing. If clean, this time goes to the stretch goal: shareable pages (Conductor saves its output to the site, so you can send insights to your team without them needing Conductor).

---

#### Section 6: Validation & Boundaries (boundariesText — custom)

**The test is your 400 clients.**

This sprint succeeds or fails on one thing: you open the dashboard with your real data — all 400 clients, the real names, the real numbers — and it works. That's the validation.

What that means for boundaries:
- **Something broken?** We fix it within the sprint. A bug, a failed match, a missing field — that's what Day 5–6 are for.
- **Doesn't give you the data you need?** That's a valid finding, not a failure. It tells us what a follow-up sprint should build. We don't bolt on new features mid-sprint.
- **Works and you want more?** That's the conversation for a second sprint — backed by evidence from your actual usage, not guesswork.

**This is a production tool, not a prototype.** Unlike a typical design sprint where we're testing ideas, this app must actually work with real data. That means the bar is higher — but it also means you're getting a tool you can use from day one, not a mockup.

**Ongoing maintenance** is a separate conversation. A production app with a live API connection has moving parts. If FreeAgent changes something, or a CSV format shifts, that needs addressing. We'll discuss this after the sprint based on what the tool looks like.

---

#### Section 7: After the Sprint

After delivery, you use the dashboard and Conductor for 2–3 weeks with real data. Your usage patterns — what you ask, what you ignore, what frustrates you — become the evidence for what a second sprint should build.

I'll check in during this period:
- **Week 1:** 30-minute "pair querying" session — we sit together, I help you drive Conductor, make sure you're comfortable.
- **Weeks 2–3:** 15-minute weekly check-in — what did you ask? What worked? What didn't?

**What a second sprint could build**
Based on how you actually use the tool over those 2–3 weeks, a second sprint would harden what matters most: your most-used Conductor queries become permanent dashboard views (no more typing the same question), shareable pages so account managers see key insights without needing Conductor, and automated alerts for the things you check every morning — debt notifications, data freshness warnings, approaching deadlines.

**Longer-term possibilities**
Ideas identified during planning that sit beyond a second sprint. Recorded so nothing is lost: automated debt holds (system pauses accounts when FreeAgent shows overdue debt), deadline alerting (approaching deadlines with incomplete bookkeeping trigger alerts), outsourcing project briefs (generate actual work packages for the India team from the suitability data), trend detection (track changes between data imports — "Client X's turnover dropped 30% year-over-year"), and live API connections replacing CSV imports for Xero and QuickBooks where refresh speed matters.

---

#### Section 8: Next Steps (closingLine)

"Confirm you're happy with this approach — reply to this or tell me in person. We'll go through the CSV exports together on Day 1. We start February 26th."

---

### Reductions Applied

| Original | Reduced To | Why |
|----------|-----------|-----|
| 4-paragraph personal opening explaining project history | 2 sentences | Dad knows the backstory — he lived it |
| "Why This Approach" with full technical comparison table | 3 paragraphs — alternatives explored, what we chose, why it's better | Narrative flow, not a table. Dad doesn't need to compare API features. |
| 8 deliverables with sub-bullets | 6 deliverables, each one paragraph | Scannable. Each deliverable is one thing, clearly described. |
| Detailed risk assessment table | Cut entirely | Unnecessary in a client proposal — that's internal planning. |
| Evidence block + case studies | Cut entirely | Dad doesn't need social proof. He's family. |
| Client logos | Cut entirely | Same reason. |
| Lengthy Conductor features list | Folded into deliverable #5 | One deliverable, not a feature spec. |

---

### Design Context

**Template reference:** `/proposals/spooren` — the closest existing custom proposal (family project, 1 sprint, custom deliverables and schedule)
**Component location:** `/components/proposals/` (existing split-panel components)
**Data location:** `/lib/proposals/` (types and defaults)
**Visual layout:** Split-panel, fixed left (320px lg, 400px xl) + scrollable right

**Key differences from standard proposals:**
1. **No evidence block** — cut entirely (family client)
2. **No case studies** — cut entirely
3. **No client logos** — cut entirely (empty array, like Spooren)
4. **Custom "Your Goals" section** — a dedicated section before deliverables that frames the 4 goals as the proposal lead. This needs a rendering approach — either as part of personalOpening (string array with longer content) or as a new section component.
5. **Custom "Why This Scope" section** — a narrative section explaining the approach. Same rendering question.
6. **Custom "After the Sprint" section** — post-delivery plan. Could be folded into boundariesText or closingLine area.
7. **expandDeliverables: true** — all deliverables expanded by default (like Spooren)

**Rendering approach: Headline + expandable pattern throughout.** Use the same expand/collapse pattern as deliverables for all substantial sections: Goals, Why This Scope, What You Get, The Week, Validation & Boundaries, and After the Sprint. Each item shows a bold headline; clicking expands the description. This keeps the page scannable while allowing depth.

Specifically:
- **Your 4 Goals** → 4 expandable items (headline = goal name, body = one paragraph)
- **Why This Scope** → 3 expandable items ("What I considered", "What we're building instead", "Why this is better")
- **What You Get** → 6 expandable items (as written)
- **The Week** → 6 expandable items (day title + expected outcome)
- **Validation & Boundaries** → 3 expandable items ("The 400-client test", "Production tool, not a prototype", "Ongoing maintenance")
- **After the Sprint** → 3 expandable items ("Check-in plan", "What a second sprint could build", "Longer-term possibilities")

This may require extending the proposal components to support multiple expandable sections, or reusing the existing `whatYouGet` rendering pattern with different data arrays. The design agent should use the deliverables expand/collapse component as the base pattern and apply it to each section.

---

### Codebase Context

**New file needed:** `lib/proposals/tbla.ts` (proposal data)
**Route:** `/app/proposals/tbla` (uses existing dynamic route)
**Pattern to follow:** `SPOOREN_PROPOSAL` in `lib/proposals/spooren.ts` (custom deliverables, custom schedule, family client)
**Image added:** `public/images/proposals/peter-ellington.png` (already copied)

---

### Plan

**Step 1:** Create `lib/proposals/tbla.ts` with:
- `TBLA_WHAT_YOU_GET: DeliverableItem[]` — 6 custom deliverables
- `TBLA_HOW_WE_WORK: WorkBullet[]` — 6 days, each with expected outcomes
- `TBLA_PROPOSAL: ProposalData` — full proposal object

**Step 2:** Import and add `TBLA_PROPOSAL` to `ALL_PROPOSALS` array in `lib/proposals/data.ts`

**Step 3:** `peter-ellington.png` is already in `public/images/proposals/` — no action needed

**Step 4:** Implement headline + expandable pattern for all custom sections. Reuse the existing deliverables expand/collapse component as the base pattern. Each section (Goals, Why This Scope, What You Get, The Week, Validation, After the Sprint) renders as a list of expandable items with bold headline + description body. This may require:
- Extending `ProposalData` with a `customSections` array, or
- Creating multiple `DeliverableItem[]` arrays in `tbla.ts` (one per section) and rendering them with section headers in the component

**Step 5:** Test at `localhost:3000/proposals/tbla`

**Step 6:** Verify the expand/collapse pattern works across all sections and the page reads as scannable headlines with depth available on click.

---

### Assets Needed

- [x] Peter Ellington avatar (`public/images/proposals/peter-ellington.png`) — already copied
- [ ] No other assets needed (no case study screenshots, no custom graphics)

### Questions — Resolved

1. **Payment timing:** Full payment after delivery. ✅ Confirmed.
2. **Homework checklist:** No pre-made checklist — CSV export instructions will be covered in Workshop 1. ✅ No homeworkLink in proposal.
3. **Second avatar:** Peter + Charlie. ✅ Both avatars in sidebar.
4. **Goals section rendering:** Headline + expandable pattern, same as deliverables. Applied across all sections. ✅

### Stage
Ready for Manual Testing

### Priority
High — sprint starts 26 Feb (10 days away)

### Created
16 February 2026

### Files
- `lib/proposals/tbla.ts` (new — proposal data)
- `lib/proposals/types.ts` (edit — added CustomSection interface)
- `lib/proposals/data.ts` (edit — add to ALL_PROPOSALS)
- `components/proposals/sections/expandable-section.tsx` (new — accordion section component)
- `components/proposals/proposal-content.tsx` (edit — custom sections + closing line case)
- `components/proposals/sections/how-we-work.tsx` (edit — conditional boundariesText)
- `public/images/proposals/peter-ellington.png` (already added)

### Implementation Notes (Agent 4)
**Completed**: 16 February 2026

**Architecture decisions**:
- Added `CustomSection` type with `position: "before-deliverables" | "after-process"` to control section placement
- Created generic `ExpandableSection` component using existing shadcn Accordion for reuse across future proposals
- Custom sections render as individual slide cards, same as all other sections
- Closing line renders as a third case in ProposalContent (no homework, no standard NextSteps)
- Empty `boundariesText` skips rendering in HowWeWork (TBLA has boundaries in a separate custom section)

**Avatar fix**: Removed duplicate Charlie avatar from clientAvatars — sidebar already renders Charlie hardcoded

### Manual Testing Instructions
1. Dev server running: `pnpm dev`
2. Navigate to: `http://localhost:3000/proposals/tbla`

**Visual verification**:
- [ ] Sidebar: ZEBRA x TBLA, Practice Intelligence label, BUILD, €5,000, 2 avatars (Charlie + Peter)
- [ ] Personal Opening: "Hey Dad..." with 2 paragraphs
- [ ] Your Goals: 4 accordion items that expand on click
- [ ] Why This Scope: intro text + 3 accordion items
- [ ] What You Get: 6 deliverables always expanded with em-dash format
- [ ] The Week: 6 days with descriptions + payment line
- [ ] Validation & Boundaries: 3 accordion items
- [ ] After the Sprint: 3 accordion items
- [ ] Next Steps: closing line text
- [ ] CTA button: "Confirm & Start" links to mailto
- [ ] No evidence block, no case studies, no client logos (all correctly hidden)

**Regression check**:
- [ ] /proposals/spooren still renders correctly
- [ ] /proposals/example still renders correctly
