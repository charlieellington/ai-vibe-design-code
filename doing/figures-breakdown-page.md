## Figures Breakdown Page — Transparent Evidence for Proposal Claims

### Original Request

Two claims in the proposal evidence section need transparent backing:

1. ~~"Replacement cost: €65–140k and 8–12 weeks with a traditional agency."~~ → **Reframed:** "Before AI-assisted workflows, this cost agencies €65k+ and 8–12 weeks. Most still deliver Figma files."
2. "A founding designer hire: $200k/year, 5–9 months to find, 40% wrong-hire risk." (unchanged)

These are currently plain text in the `EvidenceBlock` component (`evidence-block.tsx`). The user wants:
- An **info icon** next to each claim (matching existing pattern from `how-we-work.tsx`)
- Each icon links to a **dedicated breakdown page** showing how the figures were calculated
- The page should be **transparent and confident** — showing the workings, not being defensive
- Source data comes from three documents: `zebra-design-sprints-value.md`, `research-tech-retrospective.md`, and `research-design-ai-services.md`

### Design Context

**Existing Info Icon Pattern (how-we-work.tsx):**
- Uses Lucide `Info` icon (3.5×3.5px)
- Styled `text-stone-300 hover:text-stone-500`
- Wrapped in Radix Tooltip with optional link
- The "Deep Work" bullet already has this pattern with a link to Pragmatic Engineer

**Proposal Visual System:**
- Mono uppercase headings: `font-mono text-xs font-bold uppercase tracking-[0.2em] text-stone-400`
- Body text: `text-sm text-stone-500/700`
- Separator patterns between sections
- Split-panel layout on desktop, full-width on mobile

**The Breakdown Page Design Direction:**
- NOT a proposal page — simpler, focused, single-column layout
- Should feel like a clean evidence document (institutional, not sales-y)
- Two sections with anchor links: `#the-alternatives` and `#founding-designer`
- Alternative approaches table as primary content format
- Sources cited inline — links to ADPList, Pragmatic Engineer where applicable
- A "Back to proposal" link at the top

### Source Data (Extracted from Planning Documents)

**Section 1: The Alternatives (reframed from "Replacement Cost")**

**The approach — own it, don't hide it:**
The €65k+ figure is real — that's what assembling 3–5 specialists (designer, researcher, facilitator, developer, PM) costs at European market rates. But we're not claiming the old world still applies blindly. The framing is: "This is what it used to cost. AI compressed the implementation side — and we use it. But most agencies and freelancers haven't caught up."

**Why this works for a technical founder:**
- They know AI changed the economics — so we acknowledge it immediately (respect their intelligence)
- They can see the alternatives are STILL in the old world (agencies still deliver Figma files, still need dev after)
- Zebra is positioned as the AI-era approach — ahead of the curve, not claiming old-world prices
- The €65k figure becomes a "before" anchor, making Zebra's €20–30k look like genuine value (not "fair price")

**The narrative arc for the page:**
1. Before AI-assisted workflows → €65k+ and 8–12 weeks was standard
2. AI compressed implementation → but most alternatives haven't caught up
3. Here's what they still look like → [alternatives table]
4. Zebra uses AI coding + senior UX expertise + sprint methodology → [standalone comparison]

**Connection to Felix Lee (ADPList) — bridges both sections:**
Felix Lee's criteria for a founding designer: opinionated about problems, high craft, high product sense, can vibe code to prototype, has shipped products that real people use, self-directed, fast (nothing longer than 2 weeks).
Zebra hits every one of these criteria — PLUS delivers coded output in a sprint process. No other designer or agency is doing this combination yet.

From `zebra-design-sprints-value.md` Part 4 — Alternative Path Comparison:

| Approach | Timeline | Cost | What You Get |
|----------|----------|------|------|
| Traditional agency (Figma only) | 6–8 weeks | €25–50k | Figma files — still need dev after |
| Figma + Dev agency | 12–16 weeks | €40–80k | Handoff friction between teams |
| In-house hire | 5–9 months | €30–60k+ salary + 50–100 hrs founder time | 40% wrong-hire risk |

These alternatives are still operating in the pre-AI workflow: Figma → handoff → dev → revision cycles.

Standalone comparison (with gradient accent bar):
A Zebra Sprint: €20–30k, 2–3 weeks. Shipped code + user validation. No handoff. No wrong-hire risk.

**Section 2: Founding Designer Hire**

From `research-design-ai-services.md` — Felix Lee (ADPList Substack, Dec 2025):

- Market rate for senior product designer at startup: **$140–200k base + meaningful equity (0.5–1.5% at seed)**
- "Hiring someone from big tech because they worked on a product you admire is the most expensive mistake founders make. That designer at Meta who worked on Instagram — they were one of 40 designers on that product. They've never had to build 0-1." — Felix Lee
- Hiring timeline: 5–9 months industry standard for founding designer roles
- 40% wrong-hire risk: industry statistic for senior design hires at early-stage

**The comparison** (with gradient accent bar):
A 2–3 sprint Zebra engagement (€20–30k) is 10–15% of a founding designer's annual salary. Delivered in weeks, not months. No equity, no employment risk, no wrong-hire cost.

*Note: The "founding designer criteria" list was removed during UX refinement — it reads like a job description and breaks the persuasion chain. Keep the section tight: market data → quote → cost comparison.*

### Codebase Context

**Files to modify:**
1. `components/proposals/sections/evidence-block.tsx` — Add info icons to the two claim lines
2. `lib/proposals/data.ts` — Update `replacementCost` string from "Replacement cost: €65–140k..." to "Before AI-assisted workflows, this cost agencies €65k+ and 8–12 weeks. Most still deliver Figma files."
3. `lib/proposals/types.ts` — No changes needed (field name `replacementCost` still works semantically)

**Files to create:**
1. `app/proposals/figures/page.tsx` — The breakdown page (server component)
2. `app/proposals/figures/layout.tsx` — Layout wrapper (light mode, clean)

**Existing patterns to reuse:**
- `Info` icon from Lucide (already used in how-we-work.tsx)
- Tooltip from Radix (already imported in how-we-work.tsx)
- Font/colour system from existing proposal sections
- `font-mono text-xs font-bold uppercase tracking-[0.2em] text-stone-400` for headings
- Light mode enforcement from proposal layout

**Component rendering chain:**
- `app/proposals/[slug]/page.tsx` → `ProposalContent` → `EvidenceBlock`
- The `EvidenceBlock` renders `evidence.replacementCost` and `evidence.anchorLine` as plain `<p>` tags (lines 48–53)
- These need to become `<p>` with an inline info icon link

### Wireframe

**Evidence Block (modified) — info icons inline:**
```
Evidence

Most recent: Research Tech — 3 Zebra Sprints over 3.5 weeks

• 25+ screens designed and shipped in code
• 9 user interviews, 2 validation rounds

    "I'm amazed. Unbelievable."
    — Bartosz Barwikowski, Co-founder

Before AI-assisted workflows, this cost         ⓘ
agencies €65k+ and 8–12 weeks.
Most still deliver Figma files.

A founding designer hire: $200k/year,         ⓘ
5–9 months to find, 40% wrong-hire risk.
```

The ⓘ is a small `Info` icon (same size/style as how-we-work.tsx) that links to `/proposals/figures?from={slug}#the-alternatives` and `/proposals/figures?from={slug}#founding-designer` respectively. Icon colour `text-stone-400` (not stone-300) for WCAG contrast. Wrapping `<a>` has `p-2` for 44px touch target.

**Figures Breakdown Page wireframe (refined):**
```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  ← Back to proposal                                    │
│    (reads ?from= param → links to /proposals/{slug})   │
│                                                         │
│  ═══════════════════════════════════════════════════    │
│                                                         │
│  HOW WE CALCULATED THESE FIGURES                       │
│                                                         │
│  These are the workings behind the claims in your      │
│  proposal. We believe in transparency — here's         │
│  where the figures come from.                          │
│                                                         │
│  ─────────────────────────────────────────────────     │
│                                                         │
│  #the-alternatives                                      │
│  THE ALTERNATIVES                                       │
│                                                         │
│  Before AI-assisted design workflows, assembling       │
│  the skills a Zebra Sprint delivers — senior UX,       │
│  user research, facilitation, frontend development,    │
│  project management — cost €65,000+ and took           │
│  8–12 weeks at European market rates.                  │
│                                                         │
│  AI has compressed the implementation side. We use     │
│  it extensively. But most agencies and freelancers     │
│  haven't caught up. They still deliver Figma files     │
│  that need months of developer interpretation:         │
│                                                         │
│  ┌──────────────┬──────────┬────────┬────────────────┐ │
│  │ Approach     │ Timeline │   Cost │ What You Get   │ │
│  ├──────────────┼──────────┼────────┼────────────────┤ │
│  │ Agency       │ 6–8 wks  │ €25–50k│ Figma, no code │ │
│  │ Figma + Dev  │ 12–16 wks│ €40–80k│ Handoff issues │ │
│  │ In-house hire│ 5–9 mos  │ €30–60k│ 40% wrong-hire │ │
│  └──────────────┴──────────┴────────┴────────────────┘ │
│       (Cost column: text-right tabular-nums)           │
│                                                         │
│  ┃ A Zebra Sprint: €20–30k, 2–3 weeks.                │
│  ┃ Shipped code + user validation. No handoff.         │
│  (gradient accent bar, same as quote styling)          │
│                                                         │
│  Source: European market rates for design/dev           │
│  agencies and specialists, 2025–2026.                  │
│                                                         │
│  ─────────────────────────────────────────────────     │
│                                                         │
│  #founding-designer                                     │
│  FOUNDING DESIGNER HIRE                                 │
│                                                         │
│  Market data for founding designer at seed-stage:      │
│                                                         │
│  • Salary: $140–200k base + 0.5–1.5% equity           │
│  • Hiring timeline: 5–9 months                         │
│  • Wrong-hire risk: ~40% for senior design roles       │
│                                                         │
│  "Hiring someone from big tech because they worked     │
│  on a product you admire is the most expensive         │
│  mistake founders make."                               │
│  — Felix Lee, ADPList                                  │
│                                                         │
│  ┃ A 2–3 sprint Zebra engagement (€20–30k) is          │
│  ┃ 10–15% of a founding designer's annual salary.      │
│  ┃ Delivered in weeks, not months.                     │
│  (gradient accent bar, same treatment as above)        │
│                                                         │
│  Source: Felix Lee, "How to Hire Extraordinary          │
│  Designers" (ADPList, Dec 2025)                        │
│                                                         │
└─────────────────────────────────────────────────────────┘
```
(No bottom "Back to proposal" link — page is short enough, top link only)

### UX Refinements (4-Perspective Synthesis)

Ran dual-model (Claude + Gemini) × dual-lens (UX Designer + Maeda Simplicity) analysis.
All 4 perspectives agreed on high-confidence changes. Applied below.

**1. Info icon accessibility — touch target + contrast**
- Icon stays `h-3.5 w-3.5` visually but wrapping `<a>` gets `p-2` padding for 44px WCAG touch target
- Colour changes from `text-stone-300` → `text-stone-400` (3.3:1 contrast ratio, passes AA)
- Hover remains `hover:text-stone-500`

**2. "Back to proposal" navigation — pass slug via query param**
- Info icon links become: `/proposals/figures?from={slug}#replacement-cost`
- Figures page reads `?from=` param and renders: `← Back to proposal` linking to `/proposals/{slug}`
- Fallback if no param: `← Back` using browser history

**3. Remove "What founding designers need to do" list**
- All perspectives agreed this breaks the persuasion chain — it reads like a job description
- The section should present market data (salary, timeline, risk) → quote → cost comparison. Nothing else.

**4. Separate Zebra from the comparison table**
- Table shows only third-party alternatives (agency, Figma+Dev, in-house hire)
- Zebra stated separately below with gradient accent bar
- Avoids the "rigged comparison" pattern and builds more trust

**5. Zebra comparison line — visually prominent**
- Standalone line with gradient accent bar after the table
- Same treatment as the Felix Lee quote for visual consistency

**6. Remove bottom "Back to proposal" link**
- Page is short enough (one scroll on desktop). Top link only.

**7. Right-align currency figures in tables**
- Cost column: `text-right tabular-nums` for scanability

**8. Reframe "Replacement Cost" → "The Alternatives" with "before AI" anchor (post-refinement)**
- Kept the €65k+ figure — but as a "before AI" historical anchor, not a current claim
- Narrative: "This used to cost €65k+. AI compressed implementation — we use it. But most agencies haven't caught up."
- Positions Zebra as ahead of the curve: AI coding + senior UX + sprint methodology + coded output
- Felix Lee connection: his founding designer criteria (vibe code, high craft, ship products, fast) — Zebra hits all of them in a sprint process. No other designer/agency does this yet.
- Alternatives table shows competitors still in the old world (Figma files, handoffs)
- Value proposition: removes risk and time, saves money, AND is the AI-era approach

### Plan

**Step 1: Create the figures breakdown page route**
- File: `app/proposals/figures/page.tsx` (server component)
- Content: Two sections with anchor IDs (`the-alternatives`, `founding-designer`)
- Layout: Single-column, clean, max-w-2xl centered
- Style: Same stone colour system as proposals, mono headings
- Reads `?from=` query param for "Back to proposal" link
- Section 1: "The Alternatives" — "before AI" framing (€65k+ anchor), alternatives table, Zebra standalone line
- Section 2: "Founding Designer Hire" — market data, Felix Lee quote, cost comparison
- No role-by-role cost table, no founding designer criteria list

**Step 2: Create figures layout**
- File: `app/proposals/figures/layout.tsx`
- Light mode enforcement (same as proposal layout)
- Simple, clean — no split-panel, just centred content

**Step 3: Update evidence-block.tsx + data.ts**
- Make evidence-block a client component (`"use client"`) to support interactive link
- Add `Info` icon (Lucide) next to both claim lines
- Each icon is an `<a>` to `/proposals/figures?from={slug}#the-alternatives` and `#founding-designer`
- Update `replacementCost` string in `data.ts` to the reframed claim
- Style: `text-stone-400 hover:text-stone-500`, icon `h-3.5 w-3.5`, link padding `p-2` for touch target
- Opens in new tab (`target="_blank"`) so the prospect doesn't leave the proposal
- Need to pass `slug` down — either via props from `ProposalContent` or read from URL params

### Design References

**Visual Direction:**
- Follow existing proposal stone colour palette
- Same mono uppercase headings for sections
- Tables: clean, minimal borders (stone-200), right-aligned currency columns (`text-right tabular-nums`)
- Pull-quotes with gradient accent bar (same as evidence block)
- Zebra comparison line gets same gradient bar treatment
- Overall feel: institutional, transparent, confident — like a well-formatted appendix

**Consistency with:**
- `evidence-block.tsx` — colour system, typography
- `how-we-work.tsx` — info icon pattern (size, colour, interaction)
- Proposal layout — light mode, stone palette

### Acceptance Criteria

- [ ] Evidence block claim updated to "Before AI-assisted workflows, this cost agencies €65k+ and 8–12 weeks. Most still deliver Figma files."
- [ ] `data.ts` `replacementCost` string updated to match
- [ ] Info icon appears inline next to the "Before AI-assisted workflows..." line
- [ ] Info icon appears inline next to "A founding designer hire..." line
- [ ] Icons use `text-stone-400` (not stone-300) for WCAG contrast
- [ ] Icons have 44px minimum touch target via padding
- [ ] Clicking either icon opens the figures page in a new tab with `?from={slug}`
- [ ] Figures page loads at `/proposals/figures`
- [ ] "Back to proposal" link reads `?from=` param and links to `/proposals/{slug}`
- [ ] "The Alternatives" section opens with "before AI" framing — €65k+ as historical anchor, then "AI compressed implementation, but most haven't caught up"
- [ ] Alternatives table shows agency, Figma+dev, in-house hire — all still in pre-AI workflow
- [ ] Zebra Sprint comparison appears below table as standalone line with gradient accent bar
- [ ] Founding designer section shows market data with source attribution
- [ ] Founding designer section includes Felix Lee quote — no "criteria" list
- [ ] Both sections have anchor IDs (`#the-alternatives`, `#founding-designer`)
- [ ] Page has "Back to proposal" navigation at top only (no bottom link)
- [ ] Page enforces light mode
- [ ] Responsive: tables work on mobile (horizontal scroll or stacked)
- [ ] The tone is confident and factual, not defensive

### Stage
Ready for Execution

### Priority
High

### Created
13 February 2026

### Files
- `app/proposals/figures/page.tsx` (CREATE)
- `app/proposals/figures/layout.tsx` (CREATE)
- `components/proposals/sections/evidence-block.tsx` (MODIFY — add info icons)
- `lib/proposals/data.ts` (MODIFY — update `replacementCost` string)

### Technical Discovery

Verified by Agent 3 (Discovery) on 13 February 2026. All findings based on codebase research.

#### 1. Existing Patterns Found

**Info icon pattern (`how-we-work.tsx`, lines 10, 43–69):**
- Import: `import { Info } from "lucide-react";`
- Size: `h-3.5 w-3.5`
- Colour: `text-stone-300 hover:text-stone-500 transition-colors`
- Wrapped in Radix `Tooltip` with `TooltipTrigger` (asChild on a `<button>`)
- TooltipContent has `side="top"` and `sideOffset={6}`, with `max-w-xs text-left leading-relaxed`
- Optional tooltip link styled: `text-stone-300 hover:text-white transition-colors border-b border-stone-500 hover:border-white`
- The component is `"use client"` (required for tooltip interactivity)

**Same Info icon also used in:**
- `what-you-get.tsx` (line 10, 36): Used as accordion indicator, size `h-4 w-4`, `text-stone-300` with state-dependent colour via `group-data-[state=open]:text-stone-500`
- `credentials.tsx` (line 9, 54): Same accordion indicator pattern

**Light mode enforcement (`app/proposals/[slug]/layout.tsx`, lines 19–23):**
```tsx
<div className="light" style={{ colorScheme: "light" }}>
  {children}
</div>
```
Simple wrapper, no extra dependencies. Can be reused identically for `app/proposals/figures/layout.tsx`.

**Mono uppercase heading pattern (consistent across all proposal sections):**
```tsx
<h2 className="font-mono text-xs font-bold uppercase tracking-[0.2em] text-stone-400 mb-6">
```
Used in: `evidence-block.tsx` (line 18), `how-we-work.tsx` (line 32), `what-you-get.tsx` (line 25), `credentials.tsx` (line 25), `next-steps.tsx` (line 15), `personal-opening.tsx` (line 16).

**Gradient accent bar (`evidence-block.tsx`, line 38):**
```tsx
<div className="absolute left-0 top-0 bottom-0 w-1 rounded-full zebra-gradient-bg" />
```
Parent div: `relative pl-6 py-4 mb-8`. The `zebra-gradient-bg` class is defined in `globals.css` (line 53): `background: linear-gradient(to right, #F4A4B6, #B6A7EA, #F6C0A8)`. This pattern can be reused for the Zebra comparison lines on the figures page.

**Separator component (`components/ui/separator.tsx`):**
Available via `@/components/ui/separator`. Uses Radix `@radix-ui/react-separator`. Renders a 1px line with `bg-border` colour. Already imported (but unused) in `evidence-block.tsx` (line 9). Can be used for section dividers on the figures page, or use plain `<hr>` or `border-t` classes.

#### 2. Component Availability

**Lucide icons:**
- `Info` - Already imported in `how-we-work.tsx`, `what-you-get.tsx`, `credentials.tsx`. Confirmed available.
- `ArrowLeft` - Already imported in `app/dashboard/research-tech-1/(resources)/layout.tsx` (line 13). Confirmed available. Usage pattern: `<ArrowLeft className="h-4 w-4" />` alongside text in a `Link` component.
- `ArrowRight` - Used in `proposal-sidebar.tsx` and `mobile-cta-bar.tsx`.

**Radix Tooltip:**
- Full component available at `@/components/ui/tooltip` exporting `Tooltip`, `TooltipTrigger`, `TooltipContent`, `TooltipProvider`.
- Each `Tooltip` auto-wraps itself in a `TooltipProvider` with `delayDuration={0}`.

**Radix Separator:**
- Available at `@/components/ui/separator`. Already imported in `evidence-block.tsx`.

**Next.js Link:**
- Not currently used in any proposal components (all links are plain `<a>` tags). The `ArrowLeft` back navigation in `resources/layout.tsx` uses Next.js `Link` from `next/link`. The figures page should use `Link` for the "Back to proposal" link for client-side navigation.

#### 3. Design Language Summary

**Typography:**
- Section headings: `font-mono text-xs font-bold uppercase tracking-[0.2em] text-stone-400 mb-6`
- Body text: `text-sm text-stone-500` (secondary), `text-sm text-stone-700` (primary body)
- Base body: `text-base leading-relaxed text-stone-700` (personal opening only)
- Bold/emphasis: `text-sm font-semibold text-stone-900` (how-we-work bullet titles)
- Quote: `text-2xl font-semibold text-stone-900 leading-snug`
- Attribution: `text-sm text-stone-500 not-italic`

**Colours (stone palette consistently used):**
- `text-stone-400` — headings, bullet markers, secondary icons
- `text-stone-500` — body text (secondary)
- `text-stone-700` — body text (primary)
- `text-stone-900` — emphasis, bold titles, quotes
- `text-stone-300` — muted icon default states
- `border-stone-100` — accordion borders
- `border-stone-200` — (not found in proposals, but reasonable for table borders)
- `border-stone-300` — link underlines
- `bg-stone-100` — numbered circle backgrounds (next-steps.tsx)

**Spacing:**
- Section margins: `mb-6` (headings), `mb-8` (sub-sections), `mb-4` (tight)
- List spacing: `space-y-1.5` (tight bullets), `space-y-3` (loose bullets), `space-y-4` (how-we-work)
- Slide card pattern: `bg-white rounded-[4px] px-8 py-8 md:px-10 md:py-10 xl:py-14`
- Content max-width: `max-w-3xl mx-auto` (inside slide cards)

**Table styling:**
- No existing table component in the proposal system. The figures page will be the first to use one.
- Approach: Use semantic `<table>` with Tailwind. Based on codebase conventions: `border-stone-200` for borders, `text-sm text-stone-700` for cell text, `text-right tabular-nums` for cost columns, `font-semibold text-stone-900` for header row.

#### 4. Slug Propagation — Key Technical Detail

**Current chain:** `[slug]/page.tsx` (has `slug`) → `ProposalContent` (receives `proposal: ProposalData`, which includes `proposal.slug`) → `EvidenceBlock` (receives only `evidence: EvidenceBlockType` which does NOT include `slug`).

**Solution:** Add a `slug` prop to `EvidenceBlock`:
```tsx
interface EvidenceBlockProps {
  evidence: EvidenceBlockType;
  slug: string; // NEW — needed for info icon links
}
```
Then pass it from `ProposalContent`: `<EvidenceBlock evidence={proposal.evidenceBlock} slug={proposal.slug} />`

This is the cleanest approach — follows existing prop-drilling patterns in the codebase (e.g., `proposal.currency` passed to `HowWeWork`). The component also needs `"use client"` directive since the Info icons will be `<a>` tags (no interactivity needed — just links, so actually `"use client"` is NOT required for plain `<a>` tags; only Tooltip requires it. If using plain links without tooltips, the server component can stay as-is).

#### 5. Route Conflict Check

**Static route `/proposals/figures` vs dynamic route `/proposals/[slug]`:** No conflict. In Next.js App Router, static routes take priority over dynamic segments. The static `app/proposals/figures/page.tsx` will be matched first when the path is exactly `/proposals/figures`. The dynamic `app/proposals/[slug]/page.tsx` will only match other slugs. This is standard Next.js behaviour and is safe.

**No rewrites or redirects** in `next.config.ts` that would interfere.

**Note:** The slug value `"figures"` should not be used as a proposal slug in `data.ts` to avoid shadowing. The current only proposal slug is `"example"`, so no conflict exists.

#### 6. searchParams in Server Components

**Existing pattern (`app/auth/error/page.tsx`, lines 2–8):**
```tsx
export default async function Page({
  searchParams,
}: {
  searchParams: Promise<{ error: string }>;
}) {
  const params = await searchParams;
  // use params.error
}
```
The `searchParams` is a `Promise` in Next.js 15 server components and must be `await`ed. The figures page should follow this exact pattern for the `?from=` parameter:
```tsx
searchParams: Promise<{ from?: string }>
```

#### 7. Technical Blockers

**None identified.** All required components, icons, patterns, and routing structures are available and verified. The implementation can proceed as planned.
