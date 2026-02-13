## Proposal Split-Panel Template

### Original Request

Create a reusable split-panel proposal template on sprint.zebradesign.io at `/proposals/[slug]`. The template serves as an "asynchronous sales agent" — it must work for two audiences simultaneously: the founder who was on the call AND the absent co-founder/CTO who wasn't.

**Layout:** Fixed left sidebar (booking info: price, deliverables, CTA, validity, credentials) + scrollable right content area (narrative: personal opening, evidence, case studies, how we work). Inspired by endless.design's portfolio layout.

**Template efficiency:** 80% template / 20% custom per client. Target: 20 minutes per proposal. The left panel is filling in 6 values. The right panel's custom content is 2-3 sentences + engagement-specific details.

**Immediate clients:** Fleetster (€10k, 2 sprints), Spooren (€2,500, website), TBLA (dashboard, TBD pricing). All future Zebra Sprint clients will use this template.

**Source documents:**
- `proposals-project/proposals-visual-layout.md` — split-panel layout spec
- `proposals-project/proposal-template-brief.md` — content structure and sections
- `proposals-project/proposals-approach.md` — where proposals live and technical decisions
- `proposals-project/old-proposals/research-tech-18-dec-page.tsx` — existing Research Tech proposal (slide-deck format, to be superseded)
- `.context/attachments/endless-example-1.png` and `endless-example-2.png` — visual reference

---

### UX Refinements Applied

**Based on 4-perspective analysis (Claude UX + Claude Simplicity + Gemini UX + Gemini Simplicity)**

#### Guiding Principle

**The left panel is the contract. The right panel is the pitch.**

The previous version turned the right panel into a second contract — repeating engagement details, adding legal-style assumptions, documenting process. The fix: trust the sidebar to handle the transaction, let the right panel do pure storytelling.

#### High Confidence Changes (all 4 perspectives agreed)

1. **Remove "Your Engagement" card from right panel.** The sidebar already shows price, timeline, sprint type, and deliverables. Repeating this in a card on the right creates triple-redundancy. The user processes the same data three times (sidebar summary → engagement card → What You Get). Trust the sidebar.

2. **Remove "Process" section entirely.** Workshop → Build → Test → Iterate is generic agency filler. The brief says: "Process invites doubt. Results inspire confidence." The "How We Work" bullets already frame the method as benefits, not steps. Absorbed into How We Work.

3. **Remove "Assumptions" section from the proposal.** The brief explicitly says: "NOT an assumptions section. The Zebra Sprint is a product — deliverables are listed, scope is frozen after Day 1." Assumptions break the productised service mental model. A section titled "Assumptions" tells the prospect: "Here's a list of things that might go wrong." Move this content to the engagement agreement (sent post-commitment). The "scope freeze" bullet in How We Work handles the critical expectation during the sales phase.

4. **Remove recovery graph and UC Irvine research.** This is a sales proposal, not a seminar. Intellectually interesting but adds cognitive load without adding commercial value. All 4 perspectives flagged this as self-indulgent.

5. **Kill all collapsible/accordion content.** Hidden content in a proposal is wasted content. If the prospect never expands it, they miss it. If it's important enough to exist, show it. If it's not important enough to show, remove it from the proposal entirely.

6. **CTA button must have honest labelling.** "Confirm Sprint →" implies a digital transaction. The action opens a pre-filled email. Label: "Reply to Confirm →" or "Email to Confirm →".

7. **Mobile sticky bar: price + CTA only.** Drop the sprint type badge. On 375px, 3 elements creates cramped layout and small tap targets. CTA button minimum 48px tall.

8. **Sidebar viewport safety.** On 13" laptops (~800px viewport height), the sidebar will overflow. Make it `overflow-y-auto` with its own scroll.

#### Simplifications Made

| Original (10 sections) | Refined (6 sections) | Rationale |
|------------------------|---------------------|-----------|
| Evidence, then separate Case Studies section | Evidence Snapshot, then Case Studies immediately after | Group all "proof" together. The CTO scans proof → decides. |
| "Your Engagement" card (What/How/Timeline/Total) | Removed — sidebar handles price/timeline/total | Triple redundancy eliminated. Engagement specifics folded into Personal Opening. |
| Process section (4-phase breakdown) | Removed — absorbed into How We Work bullets | "Process invites doubt, results inspire confidence." |
| How We Work (4 bullets + collapsible deep-dive with recovery graph) | How We Work (4 bullets only) | The proposal sells. The agreement educates. No nested content. |
| Assumptions (3 collapsible accordions) | Removed — moved to engagement agreement | Wrong energy for sales. "Here's what might go wrong" kills momentum. |
| "What You Get" with verbose descriptions per deliverable | "What You Get" tight checklist, one-liner per item | The sidebar has the summary; the right panel adds one line of context, not a paragraph. |
| Evidence: "25+ screens, 173 components, 55k lines, 9 interviews" | Evidence: "25+ screens, 9 user interviews" + prominent quote | Component count and lines of code are developer vanity metrics. The client quote does more persuasive work. |
| Case Studies: dark/light cards with extensive text and tags | Case Studies: 2 browser mockups, one line each, "this is the fidelity you can expect" | Visual proof, not text cards. Show, don't tell. |

#### What Content Moves (Not Lost)

| Content | Old Location | New Location |
|---------|-------------|--------------|
| Assumptions (methodology, fidelity, scope changes) | Right panel accordions | Acknowledged in How We Work ("boundaries that protect both of us" + "How Zebra Sprints work →" link to zebradesign.io/docs). Full detail on docs page. |
| Process (Workshop → Build → Test → Iterate) | Standalone section | Absorbed into How We Work "scope freeze" and "deep work" bullets |
| Recovery graph, UC Irvine research | How We Work collapsible | Dropped entirely |
| Engagement specifics (which flow, which structure) | Standalone card in right panel | One sentence in Personal Opening |
| Scope change pricing (€1k+ after workshop) | Assumptions accordion | Engagement agreement |
| What's not included (brand, backend, native, maintenance) | Assumptions accordion | Engagement agreement |

#### Additional Refinements (3/4 agreed)

- **Brand gradient on CTA button.** The most important interactive element should carry the most emotional warmth.
- **Client quote as pull-quote.** "I'm amazed. Unbelievable." — larger type, offset treatment so it doesn't compete with metrics.
- **Add "Questions?" email link below CTA.** One small line catches the user who wants to engage but isn't ready to click Confirm.
- **Add subtle "Prepared for [CLIENT NAME]" line** near the top. Social signal that increases perceived exclusivity.
- **Design expired state.** After validity date, disable CTA: "This proposal has expired — reach out to discuss." Rest of page remains readable.
- **Subtle card borders.** White cards on cream background need `border: 1px solid rgba(0,0,0,0.05)` for contrast.
- **Custom 404 for proposals route.** Branded error with contact email.
- **Case studies closing line.** "These examples represent the visual fidelity and scope you can expect." — sets expectations that Assumptions used to handle, but through showing rather than disclaiming.

#### What to PRESERVE (do not touch)

- **The split-panel architecture.** Sidebar for scanning, right panel for narrative. All 4 perspectives praised this.
- **Price always visible, never scrolls away.** This is trust architecture.
- **One recommendation, no tiers, no option menus.** The absence of choice is the most powerful simplification.
- **Personal opening as section 1 on the right panel.** The founder sees their own words reflected back.
- **Warm cream background and generous whitespace.** The visual tone says "we're designers who care."
- **14-day validity.** Creates natural urgency without pressure.

---

### Reference Images

| Image | Path | Source | Description | Purpose |
|-------|------|--------|-------------|---------|
| endless.design 1 | `.context/attachments/endless-example-1-v2.png` | endless.design | Fixed left sidebar (~25% width): logo, tagline, 2-col client list, services grid, green CTAs, pricing. Right panel: mobile app screenshots (Shrine) in a grid | layout-reference |
| endless.design 2 | `.context/attachments/endless-example-2-v2.png` | endless.design | Same fixed left sidebar. Right panel: website mockups (desktop + mobile), bold typography cards, warm orange tones | layout-reference |
| zebradesign.io — Hero | `.context/attachments/Screenshot 2026-02-13 at 14.56.27.png` | zebradesign.io homepage | Large monospace hero: "I make interfaces work beautifully for humans." "beautifully" in pink-lavender-peach gradient. Cream background, generous whitespace | color-reference, layout-reference |
| zebradesign.io — Case Studies | `.context/attachments/Screenshot 2026-02-13 at 14.56.37.png` | zebradesign.io homepage | Two case study cards: dark navy card + light cream card. Monospace headings + "View case study →" links | component-reference |
| zebradesign.io — Credentials + Sprints | `.context/attachments/Screenshot 2026-02-13 at 14.56.44.png` | zebradesign.io homepage | Dark card: "50+ sprints." with grouped product screenshots. Gradient text on "15+ Years Expertise." | color-reference, component-reference |
| sprint.zebradesign.io — Calendar | `.context/attachments/Screenshot 2026-02-13 at 14.56.53.png` | sprint.zebradesign.io | "Zebra Sprint. 2026 Availability." with pink-lavender gradient. Week-by-week calendar grid | layout-reference, color-reference |

**Primary Visual Direction**: endless.design's split-panel layout adapted from portfolio showcase to proposal context.

**Consistency Targets**: Must visually feel like part of sprint.zebradesign.io and zebradesign.io:
- Same monospace heading treatment for section titles
- Same gradient text usage on key phrases (pink→lavender→peach)
- Same cream textured background
- Case study cards follow the dark/light card pattern from the homepage
- Browser chrome mockup pattern for showing work samples

**Note for Review + Execution Stages**: Before or during execution, run all 6 reference images through Gemini analysis (`mcp__aistudio__generate_content` with model `gemini-3-pro-preview`) to extract specific spacing values, colour codes, typography sizes, and component patterns.

**Primary Code References for Visual Consistency**:
- **`zebra-design/`** (submodule) — the production codebase for zebradesign.io. The **landing page** (`app/page.tsx` or equivalent) is the gold-standard design. Read this code to extract exact Tailwind classes, spacing values, typography scale, colour tokens, card patterns, gradient implementation, and component structure. Do not guess from screenshots — match the actual code.
- **`app/page.tsx`** (this app — sprint.zebradesign.io) — the calendar landing page. The proposal must feel like a sibling page to this. Read it for the shared design language: cream background, monospace headings, gradient text, card shadows, spacing rhythm.
- These two pages are the consistency floor. The proposal should look like it belongs on either site.

---

### Design Context

#### Visual System (from globals.css)

**Font:** Geist Sans (via next/font/google)
**Background:** Warm cream `--background: 31 56% 97%` (#FFF8F3 approximate)
**Card:** Pure white `--card: 0 0% 100%`
**Primary:** Near-black `--primary: 0 0% 9%`
**Border:** Warm beige `--border: 28 12% 90%`
**Radius:** 0.375rem (6px) — `rounded-xl`, `rounded-lg`, `rounded-md` all map to this same `--radius`
**Brand colours:** `--zebra-pink: #F4A4B6`, `--zebra-lavender: #B6A7EA`, `--zebra-peach: #F6C0A8`
**Brand gradient:** `linear-gradient(to right, #F4A4B6, #B6A7EA, #F6C0A8)`
**Textured background:** `.bg-cream-textured` class available
**Dark mode:** Supported but proposals should be light-mode only

#### Design Language Audit (from codebase review)

**Typography:**
- Landing page uses `font-mono` — all text inherits monospace
- Hero headings: `text-4xl md:text-6xl lg:text-7xl font-bold tracking-tight leading-[1.05]`
- Subtitles: `text-stone-500 text-sm leading-relaxed`
- Micro labels: `text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400`
- Selection colour: `selection:bg-[#B6A7EA] selection:text-white`

**Colour Palette (in use):**
- Background: `bg-[#FFF8F3]`
- Text primary: `text-stone-900`
- Text secondary: `text-stone-500`, `text-stone-400`
- Card bg: `bg-white`
- Card border: `border-stone-100`
- Card shadow: `shadow-[0_1px_2px_0_rgba(0,0,0,0.03)]`
- Hover shadow: `shadow-[0_8px_20px_-8px_rgba(0,0,0,0.1)]`

**Spacing:**
- Page padding: `px-6 md:px-12 py-12 md:py-16`
- Max width: `max-w-7xl`
- Section gaps: `mb-8`
- Card radius: `rounded-xl` (6px via tailwind config override)

**Component Patterns:**
- shadcn/ui Card, Button, Badge, Separator available
- Custom shadow-card: very subtle
- framer-motion used on landing page
- `REVEAL_EASE: [0.23, 1, 0.32, 1]`

**Key Pattern:** Landing page does NOT use shadcn Card directly — sprint cards are custom `motion.button` elements. For proposals, use shadcn Card for structured content.

**Key Pattern:** `rounded-xl` is 6px in this project (tailwind config override), not the standard 12px.

**Existing Onboarding Route Pattern (to follow):**
- `app/onboarding/[slug]/page.tsx` — Client component with `use(params)`, `getProposalBySlug(slug)`, `notFound()`

#### Visual Patterns from Production Pages

**1. Typography Hierarchy (monospace statement style)**
- Large monospace headings (~48-64px), bold, statement format with periods
- Body text: Geist sans-serif (~14-16px), regular weight
- **For proposal**: Section headings use monospace statement style

**2. Gradient Text Treatment**
- Key phrases only, never full sentences
- Left-to-right: pink → lavender → peach
- Only on text ≥ 24px (WCAG contrast)
- **For proposal**: Use on sidebar price or one key right-panel phrase

**3. Case Study Card Treatment**
- Dark card (navy) + light card (cream) side by side
- Monospace headings, tag badges, "View case study →" links
- Screenshots inside browser chrome mockups
- **For proposal**: Case studies section uses this pattern

**4. Overall Spatial Rhythm**
- Generous vertical spacing (80-120px+ between sections)
- Content never cramped — whitespace is a design choice
- Cards have generous padding (~32-48px internal)

#### Design Principles

1. **The proposal IS the pitch.** A well-crafted web page demonstrates design engineering capability.
2. **Warm, premium, confident.** Cream backgrounds, clean typography, generous whitespace.
3. **No dark mode on proposals.** Shared externally via URL. Consistency matters.
4. **Mobile-first CTA.** Price and confirm button must always be accessible.
5. **Never use brand gradient on text < 24px.** WCAG compliance.

---

### Refined Wireframes

#### Desktop Layout (≥1024px)

```
┌──────────────────────────┬──────────────────────────────────────────────┐
│                          │                                              │
│  Prepared for [CLIENT]   │   [1. Personal Opening]                     │
│  ZEBRA × [CLIENT]        │   "Hi [Name], great speaking on [day]..."   │
│                          │   2-3 sentences from the call.              │
│  ───────────────         │   I recommend a Build + Validate            │
│                          │   engagement for [specific flow].           │
│  BUILD + VALIDATE        │                                              │
│  2 Sprints               │   ─────────────────────────────────────     │
│  April 2026              │                                              │
│                          │   [2. Evidence Snapshot]                     │
│  ───────────────         │   Most recent: Research Tech — 3 sprints    │
│                          │   • 25+ screens designed and shipped         │
│  €20,000                 │   • 9 user interviews, 2 validation rounds  │
│                          │                                              │
│  ───────────────         │   ┌─────────────────────────────────────┐   │
│                          │   │  "I'm amazed. Unbelievable."       │   │
│  ┌────────────────────┐  │   │  — Bartosz Barwikowski, Co-founder  │   │
│  │ Reply to Confirm → │  │   └─────────────────────────────────────┘   │
│  │  (gradient button)  │  │                                              │
│  └────────────────────┘  │   Replacement cost: €65-140k, 8-12 weeks.  │
│                          │   A founding designer hire: $200k/year,     │
│  Questions?              │   5-9 months to find, 40% wrong-hire risk.  │
│  charlie@zebradesign.io  │                                              │
│                          │   ─────────────────────────────────────     │
│                          │                                              │
│                          │   [3. Case Studies]                         │
│                          │   ┌─────────────────┬─────────────────┐    │
│                          │   │ DARK CARD        │ LIGHT CARD      │    │
│                          │   │ [AI][UX][CODE]   │ [FINTECH][REACT]│    │
│                          │   │ "Investor-ready  │ "Critical       │    │
│                          │   │  in four weeks"  │  onboarding UX" │    │
│                          │   │ ┌─browser──────┐ │ ┌─browser─────┐ │    │
│                          │   │ │ screenshot   │ │ │ screenshot  │ │    │
│                          │   │ └──────────────┘ │ └─────────────┘ │    │
│                          │   │ View study →     │ View study →    │    │
│                          │   └─────────────────┴─────────────────┘    │
│                          │   "These examples represent the visual     │
│                          │    fidelity and scope you can expect."      │
│                          │                                              │
│                          │   ─────────────────────────────────────     │
│                          │                                              │
│                          │   [4. What You Get]                         │
│                          │   ✓ Day 1 Workshop — scope locked           │
│                          │   ✓ Working flow shipped to codebase        │
│                          │   ✓ User testing with 5-6 real users        │
│                          │   ✓ Evidence-based iteration                │
│                          │   ✓ Results presentation                    │
│                          │   ✓ Design direction document              │
│                          │                                              │
│                          │   €10,000 upfront · €10,000 after Build    │
│                          │                                              │
│                          │   ─────────────────────────────────────     │
│                          │                                              │
│                          │   [5. How We Work]                          │
│                          │   • Async-first — daily Loom, no standups   │
│                          │   • Scope freeze — locked after Workshop    │
│                          │   • Deep work — 4-5hrs concentrated/day     │
│                          │   • Day 1 guarantee — full refund option    │
│                          │                                              │
│                          │   Zebra Sprints have boundaries that        │
│                          │   protect both of us.                       │
│                          │   How Zebra Sprints work →                  │
│                          │                                              │
│                          │   We've made assumptions and boundaries     │
│                          │   to create the quote and process. It's     │
│                          │   important you understand these points     │
│                          │   in case we need to make adjustments to    │
│                          │   scope and quote and you have no           │
│                          │   surprises during the project.             │
│                          │                                              │
│                          │   ─────────────────────────────────────     │
│                          │                                              │
│                          │   [6. Credentials]                          │
│                          │   ┌────────────────────────────────────┐    │
│                          │   │ CLIENT LOGOS GRID                  │    │
│                          │   │ Deep Work · Ramp · EF · Nexus     │    │
│                          │   │ MakerDAO · Consensys · Arbitrum    │    │
│                          │   └────────────────────────────────────┘    │
│                          │   Charlie Ellington · Design Engineer       │
│                          │   50+ sprints                               │
│                          │                                              │
│                          │   ─────────────────────────────────────     │
│                          │                                              │
│                          │   [7. Next Steps]                           │
│                          │   1. Reply to confirm                        │
│                          │   2. I'll send agreement + first invoice     │
│                          │                                              │
│                          │   Valid until [DATE]                         │
│                          │                                              │
└──────────────────────────┴──────────────────────────────────────────────┘
     FIXED (sticky)                    SCROLLS (overflow-y-auto)
     ~320px width                      fills remaining space
     NO overflow needed                ~5 viewport heights total
     (minimal content)
```

**Key sidebar change:** Stripped to 5 elements only: identity, sprint info, price, CTA, questions. Everything else (deliverables, payment schedule, validity, logos, credentials) moved to right panel. The sidebar now fits any viewport height without scrolling.

**Key changes from bloated version:**
- Sidebar: 5 elements (was 11). No scroll needed.
- Right panel: 7 sections (was 10). ~5 viewport heights (was 7-8).
- Removed: Your Engagement card, Process section, Assumptions, all collapsibles, recovery graph.
- Payment schedule: one line under What You Get (not a standalone section).
- Credentials + logos: own section between How We Work and Next Steps.
- Validity date: closing line in Next Steps (not sidebar).

#### Mobile Layout (<1024px)

```
┌──────────────────────────────────────────────────┐
│                                                  │
│  Prepared for [CLIENT]                           │
│  ZEBRA × [CLIENT]                                │
│                                                  │
│  [1. Personal Opening]                           │
│  "Hi [Name], great speaking on [day]..."         │
│                                                  │
│  [2. Evidence Snapshot]                          │
│  ...pull-quote prominent...                      │
│                                                  │
│  [3. Case Studies]                               │
│  ...stacked vertically on mobile...              │
│                                                  │
│  [4. What You Get]                               │
│  ...tight checklist + payment schedule...        │
│                                                  │
│  [5. How We Work]                                │
│  ...4 bullets...                                 │
│                                                  │
│  [6. Credentials]                                │
│  ...logo grid + name/title...                    │
│                                                  │
│  [7. Next Steps]                                 │
│  ...2 actions + validity date...                 │
│                                                  │
├──────────────────────────────────────────────────┤
│  €20,000       [ Reply to Confirm → ]            │
│  ─── STICKY BOTTOM BAR (price + CTA only) ───   │
└──────────────────────────────────────────────────┘
```

**Mobile:** Price + CTA only in sticky bar. No badge. CTA minimum 48px tall. Sidebar identity + sprint info appears at top of stacked content. All other content is in the scrollable sections.

#### Expired State

CTA button disabled, text: "This proposal has expired — reach out to discuss." Validity line: "Expired on [date]." Rest of page remains readable.

---

### Codebase Context

**Framework:** Next.js 16, App Router, TypeScript
**UI Library:** shadcn/ui + Tailwind CSS
**Font:** Geist Sans
**Existing patterns:**
- `app/onboarding/[slug]/` — dynamic slug routing pattern (follow this)
- `lib/onboarding/data.ts` — hardcoded proposal data with `getProposalBySlug()`
- `lib/onboarding/types.ts` — `Proposal`, `PaymentMilestone` types
- `components/ui/` — full shadcn library

**No existing `/proposals` route.** Greenfield feature.

**Key technical decisions:**
1. No authentication — public URLs shared with prospects
2. Light mode only — force light theme
3. No Supabase — hardcoded data per proposal
4. Responsive — split-panel on desktop, stacked with sticky CTA on mobile

---

### Component Architecture

```
app/proposals/[slug]/
├── page.tsx              — Server component, looks up proposal data, renders layout
└── layout.tsx            — Forces light mode, sets metadata per proposal

components/proposals/
├── proposal-layout.tsx   — Split-panel shell (fixed left + scrollable right)
├── proposal-sidebar.tsx  — Left panel: identity, sprint info, price, CTA, questions (minimal)
├── proposal-content.tsx  — Right panel: 7 sections in scroll order
├── mobile-cta-bar.tsx    — Sticky bottom bar for mobile (price + CTA only)
├── browser-chrome.tsx    — Reusable browser mockup wrapper for case study screenshots
└── sections/
    ├── personal-opening.tsx   — 2-3 sentence custom opening (includes engagement recommendation)
    ├── evidence-block.tsx     — Stats, pull-quote, replacement cost, anchor line
    ├── case-studies.tsx       — 2 browser mockup cards (dark/light), minimal text
    ├── what-you-get.tsx       — Tight ✓ checklist, one-liner per deliverable
    ├── how-we-work.tsx        — 4 bullets, no collapsibles
    ├── credentials.tsx        — Logo grid + name/title/sprint count
    └── next-steps.tsx         — 2 binary actions + validity date
```

**Estimated sizes:**
- `proposal-layout.tsx` — ~80 lines
- `proposal-sidebar.tsx` — ~80 lines (minimal: identity, sprint info, price, CTA, questions + expired state)
- `proposal-content.tsx` — ~45 lines (renders 7 sections in order)
- `browser-chrome.tsx` — ~30 lines
- `personal-opening.tsx` — ~25 lines
- `evidence-block.tsx` — ~60 lines
- `case-studies.tsx` — ~80 lines (2 cards with browser chrome)
- `what-you-get.tsx` — ~35 lines
- `how-we-work.tsx` — ~40 lines (4 bullets, no nested content)
- `credentials.tsx` — ~50 lines (logo grid + name/title)
- `next-steps.tsx` — ~30 lines (2 steps + validity date)
- `mobile-cta-bar.tsx` — ~40 lines
- `types.ts` — ~70 lines
- `data.ts` — ~100 lines template defaults + ~50 lines per client

All components under 250 lines. Total new code: ~750-850 lines across ~14 files.

**Removed from bloated version:**
- `collapsible.tsx` — no more accordions
- `sections/engagement-card.tsx` — sidebar handles this
- `sections/process-section.tsx` — absorbed into How We Work
- `sections/assumptions.tsx` — moved to engagement agreement

---

### Data Model

```typescript
// lib/proposals/types.ts

export interface ProposalData {
  // Identity
  slug: string;
  clientName: string;           // "Tim"
  clientCompany: string;        // "Fleetster"

  // Left Panel — Minimal (identity, sprint info, price, CTA)
  sprintType: string;           // "BUILD + VALIDATE"
  sprintCount: number;          // 2
  timeline: string;             // "April 2026"
  totalPrice: number;           // 20000
  currency: string;             // "EUR"
  ctaText: string;              // "Reply to Confirm"
  ctaHref: string;              // mailto: link with pre-filled subject
  discountLabel?: string;       // Optional: "Szymon Intro Rate"
  originalPrice?: number;       // Optional: 25000

  // Right Panel — The Pitch
  personalOpening: string;      // 2-3 sentences (CUSTOM per client)
  evidenceBlock?: EvidenceBlock; // Optional — some proposals skip this
  caseStudies?: CaseStudy[];    // Optional — visual proof cards
  whatYouGet: DeliverableItem[];
  paymentSchedule: PaymentStep[]; // Shown under What You Get
  howWeWork: WorkBullet[];      // 4 bullets, always visible
  clientLogos: ClientLogo[];    // Credentials section
  validUntil: string;           // ISO date "2026-03-27"
  validUntilDisplay: string;    // "27 March 2026" — shown in Next Steps

  // Meta
  createdAt: string;
  contactEmail: string;         // "charlie@zebradesign.io"
}

export interface PaymentStep {
  label: string;    // "Upfront"
  amount: number;   // 10000
  when: string;     // "Before Workshop 1"
}

export interface EvidenceBlock {
  clientName: string;           // "Research Tech"
  summary: string;              // "3 Zebra Sprints over 3.5 weeks"
  bullets: string[];            // Screens + interviews only
  quote: string;                // "I'm amazed. Unbelievable."
  quoteAttribution: string;     // "Bartosz Barwikowski, Co-founder"
  replacementCost: string;      // "€65-140k and 8-12 weeks"
  anchorLine: string;           // Founding designer comparison
}

export interface CaseStudy {
  title: string;                // "Investor-ready in four weeks"
  slug: string;                 // "animatix-case-study"
  tags: string[];               // ["AI", "UX", "SHIPPED IN CODE"]
  screenshotUrl: string;        // "/images/articles/animatix-case-study/..."
  linkText: string;             // "View case study"
  variant: 'dark' | 'light';
}

export interface DeliverableItem {
  title: string;                // "Day 1 Workshop — scope locked"
}

export interface WorkBullet {
  title: string;                // "Async-first"
  description: string;          // "Daily Loom updates, no standups"
}

export interface ClientLogo {
  name: string;
  src: string;
  darkModeSrc?: string;
}
```

**Changes from bloated data model:**
- Removed `EngagementDetails` — sidebar no longer handles engagement details
- Removed `ProcessStep[]` — no process section
- Removed `Assumption[]` — moved to engagement agreement
- Removed `SprintExample[]` — moved to engagement agreement
- Removed `HowWeWork` complex interface with deep-dive — now just `WorkBullet[]`
- Removed `sidebarDeliverables` — sidebar is minimal, deliverables are in What You Get only
- Moved `paymentSchedule`, `clientLogos`, `validUntil` from sidebar to right panel sections
- Simplified `DeliverableItem` — title only, no verbose description
- Simplified `CaseStudy` — removed `description` field (visual proof, minimal text)

---

### Plan

#### Step 1: Create proposal data types
- **File:** `lib/proposals/types.ts`
- **What:** All interfaces from data model above
- **Pattern:** Follow `lib/onboarding/types.ts`

#### Step 2: Create template defaults and example proposal data
- **File:** `lib/proposals/data.ts`
- **What:** Template defaults (80% shared) + one example proposal + `getProposalBySlug()`
- **Template defaults:**
  - `RESEARCH_TECH_EVIDENCE` — Evidence block for AI/SaaS clients
  - `DEFAULT_CASE_STUDIES` — 2 case studies (Animatix dark + Paid247 light)
  - `DEFAULT_HOW_WE_WORK` — 4 work bullets
  - `DEFAULT_CLIENT_LOGOS` — Logo array
  - `DEFAULT_WHAT_YOU_GET` — 6 deliverable items

#### Step 3: Create split-panel layout
- **File:** `components/proposals/proposal-layout.tsx`
- **What:** CSS Grid — `grid-cols-[320px_1fr]` on `lg:`, single column below
- Left panel: `sticky top-0 h-screen overflow-y-auto`
- Background: `bg-cream-textured`

#### Step 4: Build left panel (sidebar — minimal)
- **File:** `components/proposals/proposal-sidebar.tsx`
- **What:** In order: Prepared for → ZEBRA × [CLIENT] → Sprint info (type, count, timeline) → Price (large, bold) → CTA (gradient button) → Questions? email
- Expired state: CTA disabled, message shown
- No deliverables, no payment schedule, no logos, no credentials, no validity — all moved to right panel

#### Step 5: Build browser chrome utility
- **File:** `components/proposals/browser-chrome.tsx`
- macOS-style dots + URL bar wrapper

#### Step 6: Build right panel sections
- **File:** `components/proposals/proposal-content.tsx` — Renders 7 sections conditionally
- **Section files:**
  - `sections/personal-opening.tsx` — Paragraph render
  - `sections/evidence-block.tsx` — Stats, pull-quote (larger type, offset), anchor line
  - `sections/case-studies.tsx` — 2 browser mockup cards, dark/light variants, closing fidelity line
  - `sections/what-you-get.tsx` — Tight ✓ checklist + payment schedule line underneath
  - `sections/how-we-work.tsx` — 4 bullets + boundaries acknowledgment with link to zebradesign.io/docs
  - `sections/credentials.tsx` — Client logo grid + "Charlie Ellington · Design Engineer · 50+ sprints"
  - `sections/next-steps.tsx` — 2 numbered steps + "Valid until [DATE]" closing line

#### Step 7: Build mobile sticky CTA bar
- **File:** `components/proposals/mobile-cta-bar.tsx`
- `fixed bottom-0 lg:hidden` — price + CTA only
- Minimum 48px CTA height

#### Step 8: Create proposal route
- **File:** `app/proposals/[slug]/page.tsx` — Server component, notFound() if null
- **File:** `app/proposals/[slug]/layout.tsx` — Forces light mode, metadata
- Custom 404 with contact email

#### Step 9: Test with example data
- Navigate to `/proposals/example`
- Verify desktop split-panel, mobile stacked + sticky bar
- Verify CTA opens pre-filled email
- Verify expired state
- Verify 404 for unknown slugs

---

### Immediate Client Adaptations

| Client | Sprint Type | Price | Evidence Block | Notes |
|--------|------------|-------|----------------|-------|
| **Fleetster** | BUILD + VALIDATE (2 sprints) | €10,000 | Research Tech | Honouring €5k/sprint. Evidence-first. |
| **Spooren** | WEBSITE REBUILD (1 week) | €2,500 | Deep Work | Family project. Skip evidence block and case studies. |
| **TBLA** | DASHBOARD (1 week) | TBD | N/A | May not need formal proposal. |

**Template flexibility:** Each section renders conditionally. If `evidenceBlock` is null, it's skipped. If `caseStudies` is empty, it's skipped. This supports both full proposals and simplified ones.

---

### Acceptance Criteria

**Layout & Architecture**
- [ ] `/proposals/[slug]` renders a split-panel proposal page
- [ ] Left panel sticky on desktop with `overflow-y-auto`
- [ ] Right panel scrolls with 7 content sections (~5 viewport heights)
- [ ] Page forces light mode
- [ ] No authentication required
- [ ] Semantic HTML: `<aside>` for sidebar, `<main>` for content, heading hierarchy
- [ ] All components under 250 lines

**Left Panel (Sidebar — Minimal)**
- [ ] "Prepared for [CLIENT NAME]" + "ZEBRA × [CLIENT]" header
- [ ] Sprint info: type, count, timeline
- [ ] Price is visual anchor — large, bold, never scrolls away
- [ ] Optional discount display: original price struck through + discount label
- [ ] CTA: "Reply to Confirm →" with gradient background, opens mailto:
- [ ] "Questions?" email link below CTA
- [ ] Expired state: CTA disabled, message shown, page readable
- [ ] No deliverables, no payment schedule, no logos, no credentials, no validity in sidebar

**Right Panel (7 sections)**
- [ ] Personal opening: 2-3 custom sentences including engagement recommendation
- [ ] Evidence block with pull-quote (larger type, offset) — conditional
- [ ] Anchor line integrated into Evidence closing
- [ ] Case studies: 2 browser mockup cards (dark/light), minimal text, closing fidelity line — conditional
- [ ] What You Get: tight ✓ checklist + payment schedule line underneath
- [ ] How We Work: 4 bullets + boundaries acknowledgment ("Zebra Sprints have boundaries..." + "We've made assumptions..." + "How Zebra Sprints work →" link to zebradesign.io/docs)
- [ ] Credentials: client logo grid + name/title/sprint count
- [ ] Next Steps: 2 binary actions + "Valid until [DATE]" closing line
- [ ] No Engagement card, no Process section, no Assumptions section
- [ ] No collapsibles or accordion interactions anywhere

**Visual Consistency**
- [ ] Matches sprint.zebradesign.io and zebradesign.io visual language
- [ ] Monospace heading treatment on section titles
- [ ] Brand gradient only on text ≥ 24px (WCAG)
- [ ] White cards have subtle border on cream background
- [ ] Warm cream textured background
- [ ] Generous vertical spacing between sections (80-120px)

**Mobile**
- [ ] Single-column with sticky bottom bar (price + CTA only)
- [ ] Mobile CTA button minimum 48px tall
- [ ] Case study cards stack vertically

**Error States**
- [ ] Custom 404 with contact email for unknown slugs

---

### Stage
Complete

### Priority
High

### Created
13 February 2026

### Questions for Clarification

None. The 4-perspective analysis resolved the key tension: RT proposal content (assumptions, process, scope) is important but belongs in the engagement agreement, not the sales proposal. Case studies survive as visual proof. The brief's structure wins.

---

### Files
**New files to create:**
- `app/proposals/[slug]/page.tsx`
- `app/proposals/[slug]/layout.tsx`
- `components/proposals/proposal-layout.tsx`
- `components/proposals/proposal-sidebar.tsx`
- `components/proposals/proposal-content.tsx`
- `components/proposals/mobile-cta-bar.tsx`
- `components/proposals/browser-chrome.tsx`
- `components/proposals/sections/personal-opening.tsx`
- `components/proposals/sections/evidence-block.tsx`
- `components/proposals/sections/case-studies.tsx`
- `components/proposals/sections/what-you-get.tsx`
- `components/proposals/sections/how-we-work.tsx`
- `components/proposals/sections/credentials.tsx`
- `components/proposals/sections/next-steps.tsx`
- `lib/proposals/types.ts`
- `lib/proposals/data.ts`

**No existing files modified.**

---

### Visual Research Note (for Review + Execution Stages)

**Before or during execution**, the executing agent MUST do both:

**1. Read the actual code (PRIMARY — source of truth):**
- `zebra-design/` submodule → landing page file (likely `app/page.tsx`) — extract exact Tailwind classes, typography scale, spacing values, gradient implementation, card component patterns, shadow tokens. This is the gold-standard design for zebradesign.io.
- `app/page.tsx` in this app (sprint.zebradesign.io) — extract the calendar landing page's design language. The proposal must feel like a sibling to this page.

**2. Analyse reference images (SECONDARY — for patterns not obvious in code):**
- Run all 6 reference screenshots through `mcp__aistudio__generate_content` with model `gemini-3-pro-preview`
- Extract: sidebar proportions (endless.design), content density, visual rhythm, CTA placement patterns

Code is the source of truth. Screenshots confirm the intent. Together they ensure production quality.

---

### Review Notes (Agent 2 — 13 February 2026)

**Status:** APPROVED — Plan is complete, technically accurate, and executable.

**Requirements Coverage:** All 30+ requirements verified with corresponding plan steps.

**Technical Validation:**
- All file paths follow Next.js 16 App Router conventions ✓
- CSS variables, gradient classes, and Tailwind config verified against actual codebase ✓
- shadcn/ui Card, Button, Badge, Separator, Tooltip all available ✓
- Data model interfaces are well-typed and support conditional sections ✓
- `rounded-xl` confirmed as 6px via tailwind config override ✓

**Execution Note — Server Component Params:**
The plan references the onboarding pattern (`use(params)`) but specifies server components. In Next.js 16 server components, use:
```typescript
export default async function ProposalPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
}
```

**Visual Reference Analysis (AI Studio MCP):**
- Sidebar at 320px (22% of 1440px) is correct for the minimal 5-element content
- `font-mono` for headings matches sprint.zebradesign.io (not zebradesign.io which uses Fraunces)
- All color tokens verified: `#FFF8F3` bg, stone-900/500/400 text, gradient values match
- Card styling follows sprint.zebradesign.io patterns (border-stone-100, subtle shadow)
- Spacing: lean toward 100-120px between sections for premium feel

**Cross-Page Consistency Patterns (from codebase):**
1. `bg-cream-textured` class for page background
2. `font-mono` for section headings
3. `text-stone-900/500/400` text hierarchy
4. `selection:bg-[#B6A7EA] selection:text-white`
5. `zebra-gradient-text` class for gradient phrases (≥24px only)
6. Cards: white bg, `border-stone-100`, `shadow-[0_1px_2px_0_rgba(0,0,0,0.03)]`
7. `text-[10px] font-bold uppercase tracking-[0.2em] text-stone-400` for micro labels

**Risk Assessment:** All low severity. No blockers identified.

---

### Technical Discovery (Agent 3 — 13 February 2026)

**All Components Available:** YES — Card, Button, Badge, Separator, Tooltip all installed
**All Dependencies Available:** YES — lucide-react, next-themes, framer-motion, cva, typography plugin
**No Installations Needed**

**Image Asset Blocker (RESOLVED):**
Case study screenshots and client logos live in `zebra-design/public/images/`. Agent 4 must copy required images to `public/images/proposals/` and `public/images/logos/` before building components.

**Critical Execution Notes:**
1. Use `stone-*` colors (sprint.zebradesign.io), NOT `zinc-*` (zebradesign.io)
2. Server component `page.tsx` → use `await params`, not `use(params)`
3. `rounded-xl` = 6px (tailwind config override)
4. Copy images first before building components
5. Force light mode in proposals layout
6. BrowserChrome pattern available in `zebra-design/src/app/proposals/research-tech-18-dec/page.tsx:100-119`
7. `bg-cream-textured`, `zebra-gradient-text`, `zebra-gradient-bg` utility classes available
8. `font-mono` for section headings
9. Greenfield — no existing `/app/proposals/` route
10. `scrollbar-hide` utility class available for sidebar
