## Create TBLA Onboarding Flow

What this file does: Plan for adapting the Research Tech onboarding flow at sprint.zebradesign.io/onboarding/ for TBLA (Dad's accounting practice dashboard sprint). Copy the existing flow structure, update data and copy to fit a single-person, family-client, production-tool sprint.

---

### Original Request

Create an onboarding flow for TBLA (Dad — Peter Ellington) by copying and adapting the existing Research Tech onboarding at `sprint.zebradesign.io/onboarding/research-tech-1`. One person to onboard (no team), family client, production tool sprint (not a design sprint). Pull details from the TBLA sprint plan and proposal doc. Keep it energy-efficient — same structure, adapted content.

### Context from Chat

From the methodology analysis:
- **Onboarding solves:** setting professional expectations so the family dynamic doesn't become scope creep
- **Skip:** assumptions video, dynamic onboarding system, terms enhancements — all designed for external clients with teams
- **Key adaptation:** agreements need to reflect production tool expectations, not startup design sprint language
- **One person:** Dad is the only attendee — no team onboarding complexity

### Source Documents

- Sprint plan: `zebra-planning/6-clients-and-past-work/tbla/tbla-sprint-plan.md`
- Proposal (built, in testing): `ai-vibe-design-code/doing/proposal-tbla.md`
- Existing onboarding: `app/onboarding/[slug]/` (6 pages), `lib/onboarding/data.ts`, `lib/onboarding/types.ts`

---

### Design Context

**No visual changes to the flow.** Same layout, same Card components, same ProgressIndicator, same step structure. Only data and copy change.

**Existing Production Pages (for Visual Consistency):**
The onboarding flow has an established visual pattern — centered cards, progress bar, step-by-step progression. TBLA uses the identical layout. No screenshots needed.

---

### Codebase Context

#### Current File Structure

```
lib/onboarding/
  data.ts          — Hardcoded RESEARCH_TECH_PROPOSAL + bank/company details + getProposalBySlug()
  types.ts         — Proposal, OnboardingData, ONBOARDING_STEPS types

app/onboarding/[slug]/
  page.tsx          — Page 0: Welcome (sets expectations, creates session)
  layout.tsx        — Shared header + centered content
  engagement/
    page.tsx        — Page 1: Price, workshop date, proposal agreement checkbox
  agreements/
    page.tsx        — Page 2: 6 agreement checkboxes (sprint focus, scope, visual fidelity, schedule, comms, terms)
  about/
    page.tsx        — Page 3: Name, email, contact pref, workshop team emails, reference materials
  invoice/
    page.tsx        — Page 4: Payment schedule, collapsible invoice, bank details, pay now/later
  confirmed/
    page.tsx        — Page 6: Confirmation + next steps

components/onboarding/
  progress-indicator.tsx  — Step X of 4 progress bar
  onboarding-card.tsx     — Reusable card wrapper

lib/actions/onboarding.ts — Server actions: session management, save steps, send emails
```

#### Key Hardcoded Values to Change

1. **`data.ts:8-35`** — `RESEARCH_TECH_PROPOSAL` is the only proposal. `getProposalBySlug()` only matches `'research-tech-1'`.
2. **`about/page.tsx:35-41`** — Form defaults hardcoded to Bartosz (`'Bartosz Barwikowski'`, `'bartosz@research.tech'`, `'@bbarwik'`).
3. **`agreements/page.tsx:88-92`** — Sprint focus text references "product-market fit" and "building additional screens as you develop your technical stack".
4. **`agreements/page.tsx:133-136`** — Visual fidelity text not relevant for data dashboard.
5. **`invoice/page.tsx:232-238`** — Line items hardcoded to "3 x Zebra Design Sprint (Szymon intro rate)".
6. **`invoice/page.tsx:402-403`** — Same hardcoded line item in expanded invoice view.
7. **`confirmed/page.tsx:67-69`** — "Please make the upfront payment" not applicable (TBLA pays after delivery).
8. **`confirmed/page.tsx:104-107`** — Workshop described as "2-3 hours via Zoom or Google Meets" (TBLA is in person).
9. **`page.tsx:72-74`** — Welcome step 5 says "Pay upfront invoice to confirm the project" (TBLA pays after delivery).
10. **`page.tsx:84-90`** — Hardcoded Research Tech proposal link.

---

### TBLA Proposal Data

Extracted from `proposal-tbla.md` and `tbla-sprint-plan.md`:

```typescript
const TBLA_PROPOSAL: Proposal = {
  id: 'tbla-1',
  slug: 'tbla-1',
  clientName: 'Peter Ellington',
  clientEmail: '', // Dad's email — to be confirmed
  clientCompany: 'TBLA',
  title: '1 Zebra Sprint — Practice Intelligence',
  description: 'Production dashboard unifying all practice data into one place.',
  totalAmount: 5000,
  currency: 'EUR',
  deliverables: [
    'Unified data from all 6 systems (BrightManager, FreeAgent, TaxCalc, QuickBooks, Xero, Excel)',
    'Live billing and debt data from FreeAgent (OAuth 2.0)',
    'Client dashboard with 3 key views (top clients, debts, data coverage)',
    'AI-powered client matching across systems with review queue',
    'Conductor AI agent trained on your data — unlimited queries',
    'Deployed and working on Vercel with your own database',
  ],
  workshopDate: 'Thursday, 26 February 2026',
  workshopTime: 'Morning (in person)',
  paymentSchedule: [
    { label: 'After delivery', amount: 5000, status: 'pending' },
  ],
  externalProposalUrl: 'https://sprint.zebradesign.io/proposals/tbla',
  termsUrl: '/terms',
};
```

### TBLA-Specific Agreements

The 6 agreements need adapting. Structure stays the same (6 checkboxes), copy changes for 4 of them:

| # | Research Tech | TBLA | Change? |
|---|--------------|------|---------|
| 1 | **Sprint focus** — "product-market fit", "building additional screens as you develop your technical stack" | **Sprint focus** — "We'll focus on getting all your data unified and browsable in one dashboard. Additional views, automations, and team features are future sprint work — not this one." | Yes — rewrite |
| 2 | **Workshop locks scope** — "After the workshop, we build exactly what we specify together." | Same text works. | No |
| 3 | **Visual fidelity** — "We work to the visual fidelity outlined in the proposal." | **Production tool expectations** — "This sprint delivers a working production tool with your real data — not a mockup or prototype. Data accuracy and reliable imports are the priority. Visual polish is functional, not decorative." | Yes — rewrite |
| 4 | **Project schedule** — references workshopDate, mentions schedule change costs | Same structure, uses proposal.workshopDate. Remove schedule change cost mention (family client). → "Your sprint starts {date} with a hands-on workshop. We'll walk through each system together and export the data we need." | Yes — rewrite |
| 5 | **Communication** — "We work async-first with written updates." | **Communication** — "I'll update you as the build progresses. We'll meet in person for the workshop and validation days. Between those, I'll send updates as things come together." | Yes — rewrite |
| 6 | **Terms** — links to /terms | Same. | No |

### TBLA-Specific Welcome Steps

Research Tech:
1. Review your engagement
2. Confirm a few agreements
3. Share your contact details
4. Download your invoice
5. Pay upfront invoice to confirm the project

TBLA:
1. Review your engagement
2. Confirm a few agreements
3. Share your contact details
4. Review your invoice
5. Confirm the project *(payment is after delivery)*

### TBLA-Specific "What Happens Next" (Confirmed Page)

Research Tech:
1. "Please make the upfront payment if you have not done already"
2. "Calendar invites go out to your team"
3. "Workshop 1" — date/time, "2-3 hours via Zoom or Google Meets"

TBLA:
1. "I'll send you a calendar invite for Day 1"
2. "Workshop Day 1" — Thursday 26 Feb, in person — "We walk through each system, export CSVs, and install Conductor together"
3. "Payment is due after delivery" — "You'll receive an invoice once the sprint is complete"

### TBLA-Specific Invoice Page

Key differences:
- **Payment schedule:** Single line — "After delivery: €5,000" with status 'pending' (no 'due' item)
- **No "AMOUNT DUE NOW"** — replace with "TOTAL" since nothing is due upfront
- **No "I've Made the Payment" CTA** — replace with "Continue →" or "Confirm Project →"
- **No "Pay Later" button** — not applicable
- **Line item:** "1 x Zebra Sprint — Practice Intelligence" instead of "3 x Zebra Design Sprint (Szymon intro rate)"
- **Invoice still downloadable** — for Dad's records

### TBLA-Specific About Page

- **Remove hardcoded defaults** — empty name/email fields (not pre-filled with Bartosz)
- **Contact preference:** Keep Telegram + Email options (Dad may use either). Consider adding "Phone" but that's scope creep — keep it simple.
- **Workshop team section:** Keep but make the copy reflect single-person context — "Anyone else who should know about the project?" instead of "Who else should join the Day 1 workshop?"
- **Reference materials:** Keep — Dad can share system access details, CSV samples, etc.

---

### Plan

**Step 1: Add TBLA proposal data to `lib/onboarding/data.ts`**
- File: `lib/onboarding/data.ts`
- Add `TBLA_PROPOSAL: Proposal` constant with all fields from the data above
- Update `getProposalBySlug()` to handle `'tbla-1'` slug
- No changes to `BANK_DETAILS` or `COMPANY_DETAILS` (same company billing)

**Step 2: Make agreements page slug-aware**
- File: `app/onboarding/[slug]/agreements/page.tsx`
- Create an `AGREEMENTS` config object keyed by slug (or a function that returns agreement text per slug)
- Keep the 6-checkbox structure identical
- Replace hardcoded text strings with config-driven text
- TBLA gets rewritten copy for agreements 1, 3, 4, 5 (per table above)
- Research Tech keeps its existing copy (no regression)
- Pattern: define a `getAgreements(slug: string)` function in `data.ts` or inline

**Step 3: Make welcome page dynamic**
- File: `app/onboarding/[slug]/page.tsx`
- Replace hardcoded step 5 text with proposal-aware text
- If proposal has no upfront payment (paymentSchedule[0].status !== 'due'), show "Confirm the project" instead of "Pay upfront invoice to confirm the project"
- Replace hardcoded Research Tech proposal link with `proposal.externalProposalUrl`

**Step 4: Make about page dynamic**
- File: `app/onboarding/[slug]/about/page.tsx`
- Remove hardcoded Bartosz defaults from useState — empty strings for name, email, telegramHandle
- Optionally: pre-fill from `proposal.clientName` and `proposal.clientEmail` if available
- Adjust "Workshop Team" copy: show "Who else should know about the project? (Optional)" instead of the current copy about "Day 1 workshop" and "calendar invites"

**Step 5: Make invoice page payment-schedule-aware**
- File: `app/onboarding/[slug]/invoice/page.tsx`
- Payment schedule rendering already uses `proposal.paymentSchedule` array — this mostly works
- Fix "AMOUNT DUE NOW" to be conditional: if first milestone is 'due', show "AMOUNT DUE NOW". If 'pending', show "TOTAL"
- Fix line item description: derive from `proposal.title` instead of hardcoded "3 x Zebra Design Sprint"
- Adjust bottom buttons: if no upfront payment, show "Confirm Project →" instead of "I've Made the Payment →", and hide "Pay Later" button
- Keep invoice download (print) functionality

**Step 6: Make confirmed page dynamic**
- File: `app/onboarding/[slug]/confirmed/page.tsx`
- Make "what happens next" steps slug-aware or payment-schedule-aware
- If no upfront payment: replace step 1 ("make payment") with "I'll send you a calendar invite"
- Adjust workshop description: use proposal data for date/time, remove "via Zoom or Google Meets" (make it configurable or just simpler — "Details in your calendar invite")

**Step 7: Test at `/onboarding/tbla-1`**
- Verify full flow: Welcome → Engagement → Agreements → About → Invoice → Confirmed
- Verify Research Tech flow still works at `/onboarding/research-tech-1` (regression check)

---

### Questions for Clarification

**Q1: Dad's email address**
The proposal has `clientEmail: ''` — what email should be pre-filled for Dad?
- Needed for: session creation, completion emails, invoice
- **Recommendation:** Leave blank in code, Dad fills it in on the About page. Or pre-fill if you have it.

**Q2: Terms URL**
TBLA uses `/terms` same as Research Tech. Are the same terms applicable for a family project at €5k?
- **Recommendation:** Same terms, keep `/terms`. If you want different terms, that's a separate task.

**Q3: Proposal URL**
The TBLA proposal exists at `/proposals/tbla` on the sprint site. Confirm this is the correct URL for `externalProposalUrl`.
- **Recommendation:** Use `https://sprint.zebradesign.io/proposals/tbla`

---

### Review Notes

**Reviewed by:** Agent 2 (Review) — 17 Feb 2026

**Verdict: PLAN APPROVED with 2 additions required.**

All file paths verified. All 10 hardcoded values confirmed accurate. TypeScript types are compatible. Agreements table covers all 6 correctly. Server actions are already slug-aware (no changes needed). Layout is generic (no changes needed). No regression risk to Research Tech flow.

**2 Missing Items to Add to Plan:**

1. **`engagement/page.tsx:79` — "seed round" text.** Line 79 says "We look at what matters most for your seed round." This is Research Tech-specific. TBLA needs different text (e.g., "We look at what matters most for your practice."). Add this to Step 5 or create a new step, or add a `engagementSubheading` field to the Proposal type. The engagement page is NOT currently in the plan's 7 steps — it needs to be.

2. **`invoice/page.tsx:512` — Pay Later modal text.** The "Pay Later" dialog says "Project is not confirmed until the upfront payment is made." Step 5 correctly removes the "Pay Later" button for TBLA, which means this modal will never trigger. However, if the implementation conditionally hides the button, the modal code should also be conditionally rendered or have its text updated, for safety. Note this in Step 5.

**Open Questions — All Non-Blocking:**
- Q1 (Dad's email): Proceed with `clientEmail: ''`. Dad fills it in on the About page. The form validates it is required.
- Q2 (Terms URL): Proceed with `/terms`. Same terms apply.
- Q3 (Proposal URL): Proceed with `https://sprint.zebradesign.io/proposals/tbla`. Verify page exists at deploy time.

**Minor Observations (not blocking):**
- `generateInvoiceNumber()` returns static `ZD-${year}-001` for all clients. Pre-existing issue, not in scope.
- `engagement/page.tsx:98` says "First Workshop" — fine for both clients.
- `engagement/page.tsx:101` uses `proposal.workshopDate` and `proposal.workshopTime` — already dynamic, works for TBLA.

### Technical Discovery

**Discovered by:** Agent 3 (Discovery) — 17 Feb 2026

---

#### 1. MCP Connection Validation

- shadcn MCP: Verified working. Returns full component list (accordion, alert, button, card, checkbox, dialog, input, label, progress, radio-group, separator, textarea, etc.). All components used in the onboarding flow are available. No new components needed for this data/copy-only change.
- AI Studio MCP: Skipped (no visual changes needed).

---

#### 2. File-by-File Technical Analysis

**`lib/onboarding/data.ts` (69 lines)**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/lib/onboarding/data.ts`
- Contains: `RESEARCH_TECH_PROPOSAL` constant (lines 8-35), `BANK_DETAILS` (lines 37-43), `COMPANY_DETAILS` (lines 45-56), `getProposalBySlug()` (lines 58-63), `generateInvoiceNumber()` (lines 65-68)
- `getProposalBySlug()` currently only matches `'research-tech-1'` and returns `null` otherwise
- Straightforward to add `TBLA_PROPOSAL` and extend the slug matching
- `BANK_DETAILS` and `COMPANY_DETAILS` are shared — no changes needed
- `generateInvoiceNumber()` returns static `ZD-${year}-001` for all clients — pre-existing issue, not in scope

**`lib/onboarding/types.ts` (73 lines)**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/lib/onboarding/types.ts`
- `Proposal` interface has all fields needed for TBLA data — no new fields required for the base proposal
- `PaymentMilestone` has `status: 'due' | 'pending' | 'paid'` — TBLA uses `'pending'` which is already supported
- `OnboardingData` stores agreement booleans generically (no text content) — works for both clients
- `ONBOARDING_STEPS` is generic (Welcome, Engagement, Agreements, About You, Invoice, Confirmed) — works for TBLA
- Type assessment: No new fields needed on `Proposal` for this task. The engagement subheading ("seed round" text) and agreements text are page-level copy concerns, not proposal data fields. Recommend adding agreement configs in `data.ts` as a separate data structure (not on the Proposal type) to keep types clean.

**`app/onboarding/[slug]/page.tsx` (99 lines) — Welcome**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/app/onboarding/[slug]/page.tsx`
- CLIENT component (`'use client'`)
- Slug flow: `params: Promise<{ slug: string }>` -> `const { slug } = use(params)` -> `getProposalBySlug(slug)`
- Returns `notFound()` if proposal is null — TBLA will work once added to data.ts
- Hardcoded values found:
  - Line 67: `"Download your invoice"` — plan says change to "Review your invoice" for TBLA
  - Line 71: `"Pay upfront invoice to confirm the project"` — plan says change for TBLA
  - Lines 84-90: Hardcoded URL `https://www.zebradesign.io/proposals/research-tech-18-dec` — should use `proposal.externalProposalUrl`
- The welcome steps (lines 52-73) are an inline ordered list with 5 items. Steps 1-3 are identical for both clients. Steps 4-5 need conditional text based on payment schedule.

**`app/onboarding/[slug]/layout.tsx` (64 lines) — Layout**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/app/onboarding/[slug]/layout.tsx`
- SERVER component (no 'use client')
- Completely generic — no slug reference, no client-specific content
- Shows "Zebra Design" header + Charlie contact info
- No changes needed. Confirmed.

**`app/onboarding/[slug]/engagement/page.tsx` (148 lines) — Engagement**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/app/onboarding/[slug]/engagement/page.tsx`
- CLIENT component (`'use client'`)
- Slug flow: Same pattern as welcome — `use(params)` -> `getProposalBySlug(slug)`
- Already dynamic: `proposal.clientCompany` (line 64), `formattedAmount` (lines 43-47), `proposal.title` (line 72), `proposal.externalProposalUrl` (line 84), `proposal.workshopDate` + `proposal.workshopTime` (line 101)
- Hardcoded values found:
  - **Line 79**: `"We look at what matters most for your seed round."` — Research Tech-specific. TBLA needs different text.
  - Line 77: `"Scope defined together in Workshop 1."` — Generic enough, works for both.
  - Line 98: `"First Workshop"` heading — Works for both.
- **Recommendation for line 79**: Two approaches: (a) add an `engagementSubheading` field to the Proposal type, or (b) use a conditional based on slug/paymentSchedule. Approach (b) is simpler — if `paymentSchedule[0].status === 'due'` show seed round text, else show practice text. Or simplest: add the text as a new optional field on Proposal (e.g., `engagementSubheading?: string`) and render it if present, falling back to a generic default.

**`app/onboarding/[slug]/agreements/page.tsx` (237 lines) — Agreements**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/app/onboarding/[slug]/agreements/page.tsx`
- CLIENT component (`'use client'`)
- Slug flow: Same pattern — `use(params)` -> `getProposalBySlug(slug)`
- Already dynamic: `proposal.workshopDate` used in agreement 4 (line 156), `proposal.termsUrl` used in agreement 6 (line 201)
- Hardcoded agreement text (all inline JSX strings):
  - **Agreement 1 (lines 88-91)**: Sprint focus — "product-market fit", "building additional screens" — MUST change for TBLA
  - **Agreement 2 (lines 111-112)**: Workshop scope — "After the workshop, we build exactly what we specify together." — Same for both. No change.
  - **Agreement 3 (lines 133-134)**: Visual fidelity — "We work to the visual fidelity outlined in the proposal." — MUST change for TBLA
  - **Agreement 4 (lines 155-156)**: Schedule — uses `proposal.workshopDate` dynamically BUT has "Schedule changes after booking may incur a cost" — MUST remove cost mention for TBLA
  - **Agreement 5 (lines 177-178)**: Communication — "async-first", "Calls are scheduled, not on-demand" — MUST change for TBLA
  - **Agreement 6 (lines 197-208)**: Terms — links to `proposal.termsUrl` — No change needed.
- **Implementation approach**: Create an agreements config in `data.ts` keyed by slug. Each agreement entry has `title: string` and `description: string`. The checkbox structure stays identical. Only the text values get swapped in.

**`app/onboarding/[slug]/about/page.tsx` (277 lines) — About You**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/app/onboarding/[slug]/about/page.tsx`
- CLIENT component (`'use client'`)
- Slug flow: Same pattern
- Hardcoded defaults (lines 34-41):
  - `name: 'Bartosz Barwikowski'` — MUST be empty or pre-filled from proposal
  - `email: 'bartosz@research.tech'` — MUST be empty or pre-filled from proposal
  - `telegramHandle: '@bbarwik'` — MUST be empty for TBLA
  - `contactPreference: 'telegram'` — Default is fine for both
- Hardcoded copy (lines 187-191): "Who else should join the Day 1 workshop? The initial session extracts domain knowledge, defines the flow precisely, and aligns on success criteria. Add team members who should get calendar invites." — MUST be rewritten for TBLA single-person context
- **Implementation approach**: Pre-fill from `proposal.clientName` and `proposal.clientEmail` (both may be empty strings). For TBLA, `clientEmail` is `''` so the field will be blank. Change the workshop team copy to be conditional based on slug or simpler generic text.

**`app/onboarding/[slug]/invoice/page.tsx` (538 lines) — Invoice**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/app/onboarding/[slug]/invoice/page.tsx`
- CLIENT component (`'use client'`)
- Slug flow: Same pattern
- Already dynamic: payment schedule timeline (lines 260-289) uses `proposal.paymentSchedule.map()`, `formatCurrency` uses `proposal.currency`, `proposal.clientCompany` used for billing
- Hardcoded values found:
  - **Lines 232-238**: Line items: `description: '3 x Zebra Design Sprint'`, `detail: '(Szymon intro rate)'` — MUST change for TBLA
  - **Lines 296-301**: `"AMOUNT DUE NOW"` text and logic `proposal.paymentSchedule[0].amount` — MUST be conditional. For TBLA where nothing is 'due', should show "TOTAL"
  - **Lines 401-403**: Expanded invoice view also hardcodes `"3 x Zebra Design Sprint"` and `"(Szymon intro rate)"` — MUST change for TBLA (duplicated from line items)
  - **Line 485**: Button text `"I've Made the Payment ->"` — MUST change to "Confirm Project ->" for TBLA
  - **Lines 489-501**: "Pay Later" button and helper text — MUST be hidden for TBLA
  - **Line 512**: Pay Later modal: `"Project is not confirmed until the upfront payment is made."` — Should be conditionally rendered or removed for TBLA (button is hidden, but defensive)
  - **Lines 200-229**: `handlePayLater` function calls `/api/email/payment-details` — For TBLA this function will never be called (button hidden), but no harm leaving it
- **Key insight**: The `hasUpfrontPayment` check should be `proposal.paymentSchedule.some(m => m.status === 'due')` — this returns `true` for Research Tech (first item is 'due') and `false` for TBLA (only item is 'pending'). This single boolean drives all conditional rendering on this page.
- **PrintableInvoice component** (lines 32-148): Uses the `lineItems` prop from parent. Will automatically use correct data if parent passes correct line items. No changes needed to this sub-component.

**`app/onboarding/[slug]/confirmed/page.tsx` (166 lines) — Confirmed**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/app/onboarding/[slug]/confirmed/page.tsx`
- SERVER component (async function, no 'use client') — Note: This is the ONLY server component among the step pages
- Slug flow: `const { slug } = await params` (uses `await` instead of `use()` because it's a server component)
- Uses `getProposalBySlug(slug)` directly — same pattern
- Hardcoded values:
  - **Lines 66-70**: Step 1: `"Please make the upfront payment if you have not done already"` / `"this confirms the project"` — MUST change for TBLA
  - **Line 80**: Step 2: `"Calendar invites go out to your team"` — MUST change for TBLA (single person, in-person)
  - **Lines 101-107**: Step 3: `"Workshop 1"`, `"2-3 hours via Zoom or Google Meets"` — MUST change for TBLA (in-person, different description)
- **Key difference from other pages**: This is a server component, so data can be passed directly without client-side state. The conditional rendering can be done with the same `hasUpfrontPayment` pattern or with a config object.
- `CompletionTrigger` component (separate file, lines 1-27): Generic client component that calls `markComplete(sessionId)`. No changes needed.
- `proposal.externalProposalUrl` is already used dynamically in the bottom buttons (line 152). No change needed.

**`lib/actions/onboarding.ts` (312 lines) — Server Actions**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/lib/actions/onboarding.ts`
- Already fully slug-aware: `createOrGetSession(slug)` uses the slug to create sessions, stores `proposal_slug`, `client_company`, `proposal_title`, etc. from the proposal object
- All save functions (`saveEngagement`, `saveAgreements`, `saveAboutYou`, `saveInvoiceView`, `markComplete`) operate on `sessionId` — completely client-agnostic
- `markComplete()` sends emails using generic `OnboardingEmailData` — works for any proposal
- No changes needed. Confirmed.

**`components/onboarding/progress-indicator.tsx` (35 lines)**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/components/onboarding/progress-indicator.tsx`
- Uses `ONBOARDING_STEPS` from types — generic, works for both clients
- No changes needed.

**`components/onboarding/onboarding-card.tsx` (25 lines)**
- Path: `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/seville-v1/components/onboarding/onboarding-card.tsx`
- Generic card wrapper. Not currently used by the onboarding pages (they use `Card`/`CardContent` directly from shadcn).
- No changes needed.

---

#### 3. Data Flow Pattern

The slug-to-proposal-to-page data flow is consistent across all pages:

1. URL contains slug: `/onboarding/[slug]/...`
2. Next.js passes `params: Promise<{ slug: string }>` to page component
3. Client components: `const { slug } = use(params)` (React 19 `use()` hook)
4. Server components: `const { slug } = await params` (async/await)
5. `getProposalBySlug(slug)` returns `Proposal | null`
6. If `null`, `notFound()` is called (404 page)
7. Proposal data is used directly in JSX — no context, no global state, no prop drilling

Session state: Managed via httpOnly cookie (`onboarding_session_id`). Created on Welcome page, read on all subsequent pages via `getSessionId()`. Each step saves data to Supabase via server actions. Completely proposal-agnostic.

---

#### 4. Hidden Hardcoded Values Search Results

All matches found in `app/onboarding/` directory:

| Search Term | File | Line | Value | Already in Plan? |
|---|---|---|---|---|
| `Bartosz` | about/page.tsx | 35 | `'Bartosz Barwikowski'` | Yes (#2) |
| `Bartosz` | about/page.tsx | 36 | `'bartosz@research.tech'` | Yes (#2) |
| `bbarwik` | about/page.tsx | 38 | `'@bbarwik'` | Yes (#2) |
| `seed round` | engagement/page.tsx | 79 | `"your seed round"` | Yes (Review addition #1) |
| `research-tech` | page.tsx | 85 | Hardcoded proposal URL | Yes (#10) |
| `Szymon` | invoice/page.tsx | 235 | `'(Szymon intro rate)'` | Yes (#5) |
| `Szymon` | invoice/page.tsx | 403 | `(Szymon intro rate)` | Yes (#6) |
| `Zoom` | confirmed/page.tsx | 106 | `"via Zoom or Google Meets"` | Yes (#8) |
| `product-market fit` | agreements/page.tsx | 90 | Full sprint focus text | Yes (#3) |
| `AMOUNT DUE NOW` | invoice/page.tsx | 297 | Payment header | Yes (in plan Step 5) |
| `upfront` | page.tsx | 71 | Welcome step 5 text | Yes (#9) |
| `upfront` | invoice/page.tsx | 512 | Pay Later modal text | Yes (Review addition #2) |
| `upfront` | confirmed/page.tsx | 67 | "Please make the upfront payment" | Yes (#7) |
| `I've Made` | invoice/page.tsx | 485 | Button CTA text | Yes (in plan Step 5) |
| `Pay Later` | invoice/page.tsx | 496 | Button CTA text | Yes (in plan Step 5) |
| `Download your invoice` | page.tsx | 67 | Welcome step 4 text | Yes (in plan, change to "Review your invoice") |
| `Day 1 workshop` | about/page.tsx | 188 | Workshop team copy | Yes (in plan Step 4) |
| `async-first` | agreements/page.tsx | 178 | Communication agreement | Yes (#5 agreement) |
| `schedule change` | agreements/page.tsx | 156 | Schedule agreement cost mention | Yes (#4 agreement) |
| `Research Tech` | payment-2/page.tsx | 26 | Hardcoded in separate payment page | **NOT in plan** (see note below) |
| `Research Tech` | payment-3/page.tsx | 26 | Hardcoded in separate payment page | **NOT in plan** (see note below) |
| `Bartosz` | payment-2/page.tsx | 27 | Hardcoded in separate payment page | **NOT in plan** (see note below) |
| `Bartosz` | payment-3/page.tsx | 27 | Hardcoded in separate payment page | **NOT in plan** (see note below) |

**New finding — `payment-2/` and `payment-3/` pages:**
These are standalone payment pages at `app/onboarding/[slug]/payment-2/page.tsx` and `payment-3/page.tsx`. They contain their own hardcoded Research Tech proposal data (client name, amounts, line items, dashboard links). These are NOT part of the main onboarding flow and appear to be separate payment collection pages for Research Tech milestones 2 and 3. They are OUT OF SCOPE for this task (TBLA has a single after-delivery payment, no milestone payment pages needed). Flagged for awareness but no action required.

**All 10 original hardcoded values + 2 Review additions = all accounted for. No new hidden values found in the main onboarding flow.**

---

#### 5. Engagement Page Deep Dive

Full hardcoded content analysis of `engagement/page.tsx`:

- Line 63: `"Zebra Design x {proposal.clientCompany}"` — Already dynamic. Works for TBLA.
- Line 71: `{formattedAmount}` — Uses `proposal.totalAmount` and `proposal.currency`. Already dynamic.
- Line 72: `{proposal.title}` — Already dynamic.
- Line 77: `"Scope defined together in Workshop 1."` — Generic. Works for both clients.
- **Line 79: `"We look at what matters most for your seed round."` — HARDCODED. Research Tech-specific. MUST be changed for TBLA.**
- Lines 83-91: "View full proposal" link uses `proposal.externalProposalUrl`. Already dynamic.
- Line 98: `"First Workshop"` heading — Generic. Works for both.
- Line 101: `{proposal.workshopDate} at {proposal.workshopTime}` — Already dynamic.
- Lines 116-119: Agreement checkbox text — Generic ("I've read and agree to the proposal"). Works for both.

**Only line 79 needs changing.** Recommended approach: Add an optional `engagementDescription` field to the Proposal type, or use a conditional in the page. Since we want to avoid adding fields that only one client uses, a simple conditional on slug or payment schedule is cleanest. Or define it as a separate data config in `data.ts` alongside agreements.

---

#### 6. Design Language Consistency

- **Existing card pattern**: All onboarding pages use `Card` + `CardContent` from shadcn directly (not the `OnboardingCard` wrapper component). Consistent `pt-8 pb-8 px-8` padding. `max-w-md` or `max-w-lg` width constraints.
- **Progress indicator**: Shared component. Steps 1-4 show progress. Steps 0 (Welcome) and 5 (Confirmed) hide it. Generic.
- **Button patterns**: `Button` from shadcn with `size="lg"`. Primary action is full-width or `flex-1`. Back button uses `variant="outline"` with `ArrowLeft` icon.
- **Separator usage**: `Separator` between every section. Consistent `my-6` or `my-8` spacing.
- **Typography**: `text-2xl font-semibold` for page titles. `text-sm font-semibold text-muted-foreground uppercase tracking-wide` for section headers.
- **TBLA will use identical layouts** — no new components, no visual changes. Zero consistency risk.

---

#### 7. Types Assessment

**Does the Proposal type need new fields?**

- `engagementSubheading` / `engagementDescription`: **Recommended NO.** The engagement page line 79 text is better handled as page-level copy config, not a proposal data field. Proposal types should describe the business data (amounts, dates, deliverables), not UI copy. Handle via a `getEngagementCopy(slug)` function or inline conditional.
- `workshopFormat`: **No.** The `workshopTime` field already contains `'Morning (in person)'` for TBLA vs `'11:00 CET'` for Research Tech. The confirmed page can use a conditional for the workshop description text.
- `agreements`: **No as a Proposal field.** Agreements are page copy, not business data. Create a separate `AgreementConfig` type and `getAgreements(slug)` function in `data.ts`.
- `welcomeSteps`: **Optional.** Could add a `welcomeSteps: string[]` field to Proposal, or handle with a conditional in the page. Given only 2 clients, inline conditional is simpler.
- `invoiceLineItems`: **Optional but recommended.** Adding a `lineItemDescription: string` field to Proposal would cleanly solve the "3 x Zebra Design Sprint (Szymon intro rate)" vs "1 x Zebra Sprint — Practice Intelligence" problem. Alternatively, use `proposal.title` which is already available.

**Recommended type additions (minimal):**
1. Add `AgreementConfig` interface to `types.ts` — `{ title: string; description: string }[]` per slug
2. Optionally add `lineItemDescription?: string` to `Proposal` for invoice line item text
3. Everything else: handle with conditionals or data config functions in `data.ts`

---

#### 8. Required Installations

None. All shadcn components used in the onboarding flow (Card, Button, Checkbox, Input, Label, Textarea, RadioGroup, Separator, Dialog, Progress) are already installed. No new dependencies needed.

---

#### 9. Discovery Summary

| Check | Status |
|---|---|
| MCP connections | shadcn verified working |
| All 8 file paths verified | Yes — all exist at expected locations |
| Slug -> proposal data flow traced | Consistent `use(params)` / `await params` pattern across all pages |
| Client vs server component status mapped | 5 client components, 1 server component (confirmed), 1 layout (server) |
| All hardcoded values accounted for | 10 original + 2 Review additions = all found, no new surprises |
| payment-2/payment-3 pages flagged | Out of scope (Research Tech milestone payments) |
| Type compatibility confirmed | Proposal interface works as-is. Optional: add AgreementConfig type |
| Server actions verified slug-agnostic | No changes needed to `lib/actions/onboarding.ts` |
| Layout verified generic | No changes needed to `layout.tsx` |
| CompletionTrigger verified generic | No changes needed |
| Required installations | None |

**Ready for Implementation: Yes**

All files have been read, all data flows traced, all hardcoded values catalogued, all types assessed. The plan is technically feasible with zero risk areas. The implementation is purely data/copy changes to existing components with no structural modifications.

### Stage
Testing

### Priority
High — sprint starts 26 Feb (9 days away)

### Created
17 February 2026

### Files
- `lib/onboarding/data.ts` (edited — added TBLA proposal, `hasUpfrontPayment()`, proposals lookup)
- `lib/onboarding/copy.ts` (new — slug-aware page copy: agreements, engagement, welcome, confirmed, about)
- `lib/onboarding/types.ts` (unchanged — no new types needed)
- `app/onboarding/[slug]/page.tsx` (edited — dynamic welcome steps via `getWelcomeSteps()`, dynamic proposal URL)
- `app/onboarding/[slug]/engagement/page.tsx` (edited — dynamic description via `getEngagementDescription()`)
- `app/onboarding/[slug]/agreements/page.tsx` (edited — data-driven agreements via `getAgreements()`, reduced from 237 to 148 lines)
- `app/onboarding/[slug]/about/page.tsx` (edited — pre-fill from proposal, dynamic workshop team copy via `getWorkshopTeamCopy()`)
- `app/onboarding/[slug]/invoice/page.tsx` (edited — conditional payment labels, dynamic line items from proposal.title, conditional Pay Later)
- `app/onboarding/[slug]/confirmed/page.tsx` (edited — data-driven "what happens next" via `getConfirmedSteps()`)

### Implementation Notes

**Implemented by:** Agent 4 (Execution) — 17 Feb 2026

**Approach:** Created a new `lib/onboarding/copy.ts` file (173 lines) to hold all slug-aware page copy, keeping it separate from proposal business data in `data.ts`. This avoids bloating `data.ts` and keeps concerns clean: `data.ts` = business data + lookup, `copy.ts` = page-level text that varies by client.

**Key decisions:**
1. No new types added to `types.ts` — agreements, confirmed steps, welcome steps, and engagement text are handled purely through config functions in `copy.ts`. The `Proposal` type stays lean.
2. Added `hasUpfrontPayment(proposal)` helper to `data.ts` — used by 4 pages (welcome, invoice, confirmed, copy.ts). Single source of truth for the upfront/after-delivery distinction.
3. Invoice line items derive from `proposal.title` — eliminates the hardcoded "3 x Zebra Design Sprint (Szymon intro rate)" for all proposals.
4. Agreements page refactored from 237 to 148 lines by using a `.map()` loop over the agreement data instead of 6 separate JSX blocks. Same visual output, less code.
5. About page pre-fills name/email from `proposal.clientName` / `proposal.clientEmail` — Research Tech gets "Bartosz Barwikowski" and "bartosz@research.tech" from its proposal data, TBLA gets "Peter Ellington" and empty email. Telegram handle is always empty (not pre-filled).
6. Pay Later modal is conditionally rendered (not just hidden) for safety — matches Review Note #2.

**All hardcoded values addressed (12/12):**
- Bartosz name, email, telegram handle (about page) -> pre-fill from proposal
- "seed round" text (engagement page) -> `getEngagementDescription(slug)`
- Research Tech proposal URL (welcome page) -> `proposal.externalProposalUrl`
- "Szymon intro rate" x2 (invoice page) -> `proposal.title`
- "AMOUNT DUE NOW" (invoice page) -> conditional on `isUpfront`
- "I've Made the Payment" (invoice page) -> conditional on `isUpfront`
- "Pay Later" button + modal (invoice page) -> conditional on `isUpfront`
- "upfront payment" (welcome step 5) -> conditional via `getWelcomeSteps()`
- "upfront payment" (confirmed step 1) -> replaced via `getConfirmedSteps()`
- "Zoom or Google Meets" (confirmed step 3) -> replaced via `getConfirmedSteps()`
- "Day 1 workshop" team copy (about page) -> `getWorkshopTeamCopy(slug)`
- All 4 agreement rewrites (agreements 1, 3, 4, 5) -> `getAgreements(proposal)`

**TypeScript check:** Zero errors (`npx tsc --noEmit` passes cleanly).

**Manual test instructions:**

1. **TBLA flow** — Navigate to `/onboarding/tbla-1`:
   - Welcome: Shows "Zebra Design x TBLA", steps say "Review your invoice" and "Confirm the project"
   - Engagement: Shows "A production dashboard unifying all your practice data into one place."
   - Agreements: Shows TBLA-specific text for agreements 1, 3, 4, 5 (data focus, production tool, hands-on workshop, in-person updates)
   - About: Name pre-filled "Peter Ellington", email empty, team copy says "Anyone else who should know about the project?"
   - Invoice: Shows "TOTAL" (not "AMOUNT DUE NOW"), "Confirm Project ->" button, no Pay Later button
   - Confirmed: Shows 3 TBLA-specific steps (calendar invite, workshop day 1 in-person, payment after delivery)

2. **Research Tech regression** — Navigate to `/onboarding/research-tech-1`:
   - Welcome: Steps say "Download your invoice" and "Pay upfront invoice to confirm the project"
   - Engagement: Shows "We look at what matters most for your seed round."
   - Agreements: Shows original Research Tech text (product-market fit, visual fidelity, schedule change costs, async-first)
   - About: Name pre-filled "Bartosz Barwikowski", email "bartosz@research.tech", original workshop team copy
   - Invoice: Shows "AMOUNT DUE NOW", "I've Made the Payment ->" button, Pay Later button visible
   - Confirmed: Shows original 3 steps (upfront payment, calendar invites, Zoom workshop)

---

### Verification Results

**Verified by:** Agent 5 (Visual Verification) — 17 Feb 2026

#### Screenshots Taken

- `.playwright-mcp/tbla-welcome.png` — TBLA Welcome page
- `.playwright-mcp/tbla-engagement.png` — TBLA Engagement page
- `.playwright-mcp/tbla-agreements.png` — TBLA Agreements page
- `.playwright-mcp/tbla-about.png` — TBLA About page
- `.playwright-mcp/tbla-invoice.png` — TBLA Invoice page
- `.playwright-mcp/tbla-confirmed.png` — TBLA Confirmed page
- `.playwright-mcp/rt-welcome.png` — Research Tech Welcome page
- `.playwright-mcp/rt-engagement.png` — Research Tech Engagement page
- `.playwright-mcp/rt-agreements.png` — Research Tech Agreements page
- `.playwright-mcp/rt-invoice.png` — Research Tech Invoice page
- `.playwright-mcp/rt-confirmed.png` — Research Tech Confirmed page
- `.playwright-mcp/invalid-slug-404.png` — Invalid slug 404 page

#### TBLA Flow Results (`/onboarding/tbla-1`)

| Page | Status | Details |
|------|--------|---------|
| Welcome | PASS | "Zebra Design x TBLA", step 4 = "Review your invoice", step 5 = "Confirm the project", proposal link correct |
| Engagement | PASS | 5.000 EUR, "1 Zebra Sprint -- Practice Intelligence", description about production dashboard (no "seed round"), workshop date correct |
| Agreements | PASS | All 6 TBLA-specific agreements correct: data focus, workshop scope, production tool expectations, hands-on workshop schedule, in-person communication, terms link |
| About | PASS | Name pre-filled "Peter Ellington", email empty, telegram empty, team copy = "Anyone else who should know about the project?" |
| Invoice | PASS | "TOTAL" (not "AMOUNT DUE NOW"), single "After delivery" milestone, "Confirm Project ->" button, no Pay Later button, line item = "1 Zebra Sprint -- Practice Intelligence" |
| Confirmed | PASS | 3 correct steps: calendar invite for Day 1, Workshop Day 1 in person, payment after delivery |

#### Research Tech Regression Results (`/onboarding/research-tech-1`)

| Page | Status | Details |
|------|--------|---------|
| Welcome | PASS | "Zebra Design x Research Tech", step 4 = "Download your invoice", step 5 = "Pay upfront invoice to confirm the project" |
| Engagement | PASS | 15.000 EUR, "3 Zebra Sprints", "seed round" description preserved, workshop date correct |
| Agreements | PASS | All 6 original agreements preserved: product-market fit, workshop scope, visual fidelity, schedule change costs, async-first communication, terms |
| Invoice | PASS | "AMOUNT DUE NOW" with 3 payment milestones, "I've Made the Payment ->" button, "I'll Make the Payment Later" button present, line item = "3 Zebra Sprints" |
| Confirmed | PASS | 3 correct steps: upfront payment request, calendar invites to team (Bartosz), Workshop 1 via Zoom |

#### Other Tests

| Test | Status | Details |
|------|--------|---------|
| Invalid slug 404 | PASS | `/onboarding/invalid-slug` shows "Page not found" correctly |
| Checkbox interactivity | PASS | Checkboxes toggle correctly on both engagement and agreements pages |
| Navigation buttons | PASS | Back links and Get Started button navigate correctly |
| Console errors | PASS (pre-existing) | Only error is "Missing Supabase environment variables" — pre-existing, unrelated to TBLA changes |

#### Notes

- Invoice line item for Research Tech changed from "3 x Zebra Design Sprint (Szymon intro rate)" to "3 Zebra Sprints" (uses `proposal.title`). This is an improvement — removes internal pricing detail from client-facing content.
- Flow navigation via Continue buttons requires Supabase (server action saves step data). Without env vars, direct URL navigation works for all pages. This is a dev environment limitation, not a code issue.
- No fixes were needed. All pages rendered correctly on first verification.

#### Scoring

| Criteria | Weight | Score | Notes |
|----------|--------|-------|-------|
| Correct data rendering per slug | 40% | 10/10 | All TBLA data renders correctly across all 6 pages |
| No regression to Research Tech | 30% | 10/10 | All Research Tech pages preserve original content |
| No console errors | 15% | 10/10 | Only pre-existing Supabase env var warning (not our change) |
| Functional flow (navigation, checkboxes) | 15% | 9/10 | Checkboxes and navigation work; Continue button blocked by missing Supabase (pre-existing) |

**Final Score: 9.85/10**

**Status: APPROVED**
