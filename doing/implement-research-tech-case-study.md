# Implement Research Tech Case Study — Split-Panel Layout

What this file does: Complete implementation plan for the Research Tech case study page using a split-panel layout (fixed left + scrollable right) inspired by endless.design, with uniform slide cards for both screenshots and text content.

---

## Original Request

"Can you please create a plan to implement a case study for research tech from case-study-rt-wireframe.md and case-study-rt-content-plan.md. Visually we're basing this on www.endless.design's layout — see screenshots and matched to the zebra design branding and landing page.

The idea is we have on the right hand side app screens — and these should be inside an app framing with lots of space around them on a square/slide — like endless design. We do something similar for the text slides. They should be the same size cards/squares as the slides with the app screenshots — and with the text in them with lots of whitespace — this makes the simplicity of the content and points really stand out and makes it a joy to use and scroll the right hand side — giving the exact right information we want to give the client."

**Content sources:**
- `case-study-rt-wireframe.md` — Content wireframe with left panel + 12 right panel slides
- `case-study-rt-content-plan.md` — Detailed content plan with reasoning, screenshot instructions, and narrative arc

---

## Reference Images

| Image | Path | Source | Description | Purpose |
|-------|------|--------|-------------|---------|
| Zebra landing page | `.context/attachments/Charlie-Ellington-UX-for-Technical-Teams-02-13-2026_04_26_PM.jpg` | Current site | Full landing page with branding, cards, typography | branding-reference |
| Endless example 1 | `.context/attachments/endless-example-1-v1.png` | endless.design | Fixed left panel + right panel with app screenshots in phone frames on uniform cards with generous whitespace | layout-reference |
| Endless example 2 | `.context/attachments/endless-example-2-v1.png` | endless.design | Same layout — left panel info, right panel with square cards showing app UI in browser frames | layout-reference |

**Primary Visual Direction**: endless.design layout structure (split-panel with uniform slide cards) + zebra design branding (warm cream, Geist Mono, editorial feel)

---

## Design Context

### The endless.design Pattern (What We're Adapting)

From the reference screenshots, the key patterns are:

1. **Fixed left panel** (~30-35% width): Company info, client list, services, CTA buttons — clean and minimal
2. **Scrollable right panel** (~65-70% width): Grid/column of large uniform cards
3. **Uniform card sizing**: Every card (screenshot or content) is the same dimensions — creates a gallery rhythm
4. **App framing**: Screenshots sit inside browser/phone mockups centered within the card
5. **Generous whitespace**: Large padding around the framed screenshot within each card — the content "breathes"
6. **Clean backgrounds**: Cards use white or very light backgrounds
7. **Editorial feel**: The uniform sizing and whitespace creates a magazine/gallery quality

### Zebra Design Branding to Apply

**From `src/styles/tailwind.css`:**
- Page background: `brand-cream` (#FFF8F3)
- Primary text: `brand-text` (#413C38)
- Accent/CTA hover: `brand-rose` (#E57A9A)
- Card borders: `brand-shadow` (#E5D5C8)
- Warm backgrounds: `warm-50` (#FAF7F3), `warm-100` (#F5F0EA)

**Typography:**
- Headings: Geist Mono, weight 700, letter-spacing -0.02em
- Body: Geist Sans, weight 450, line-height 1.875
- Accent headlines: Fraunces (serif, for the quote)
- Interactive elements (links, buttons, nav): Geist Mono

**Design tokens:**
- Border radius: 8px (`rounded-lg`)
- Text slides: Large type, generous leading, centered
- Minimal decoration — "invisible UI" principle

### Visual Approach for Slide Cards (endless.design Pattern)

**The endless.design card formula (what makes it work):**
1. Card has a **tinted background** — not pure white, slightly warm/grey (`bg-warm-50` or `bg-[#F5F3F0]`)
2. Screenshot sits inside a **device frame** (browser chrome) that is **significantly smaller** than the card — creates the generous whitespace
3. Device frame has a **subtle shadow** to lift it off the card background
4. Every card is the **same height** regardless of content type — uniform rhythm
5. Cards are separated by the page background colour (`brand-cream`) showing through as gaps

**Card wrapper (all slides):**
- Background: `bg-warm-50` (#FAF7F3) — warm tint, NOT pure white
- Rounded: `rounded-xl` (12px for the cards specifically — slightly more than the 8px site default, matching the editorial feel)
- No border — the tinted background against the cream page provides enough contrast
- Fixed aspect ratio: `aspect-[4/3]` — every card same proportions
- Inner padding: `p-12 lg:p-16` — generous whitespace around all content
- `flex items-center justify-center` — content always centred

**Single screenshot slides (slides 1, 2, 5):**
- Browser frame centred in the card, occupying ~75-80% of the card width
- Frame has: `rounded-lg overflow-hidden shadow-lg shadow-black/5` — subtle lift
- Generous space between frame edge and card edge on all sides
- Screenshot fills the browser frame content area

**Dual-image slides (slides 6b, 8, 10):**
- Two device frames side by side within the same card
- **Desktop + mobile layout**: Desktop frame ~60% width, mobile phone frame ~30% width, gap between
- **Two desktop layout** (slide 8): Each frame ~46% width with gap
- Both frames have the same shadow treatment
- Content centred as a group within the card

**Text slides (slides 3, 4, 6, 7, 9):**
- Same card dimensions and background as screenshot slides
- Text centred vertically and horizontally within the card
- Headline text: Geist Mono, `text-2xl lg:text-3xl`, `font-bold`, `text-brand-text`
- Max-width on text: `max-w-lg mx-auto text-center`
- Lots of whitespace — the text "floats" in the card

**Quote slide (slide 12):**
- Same card dimensions and background
- Quote text: Fraunces serif, `text-2xl italic`, `text-brand-text`
- Attribution: Geist Mono, `text-sm`, below quote

**Link slide (slide 11):**
- Same card dimensions and background
- "Evidence." heading in Geist Mono, bold
- Description text below
- Prominent link button

---

## Codebase Context

**Framework:** Next.js 15 App Router
**Styling:** Tailwind CSS v4 with custom `@theme` tokens
**Animations:** Framer Motion 12
**Typography:** Geist Sans + Geist Mono + Fraunces (accent)

### Existing Patterns
- **No existing `/case-studies/` route** — this is the first case study in the new format
- **Proposals** exist at `/proposals/[name]/page.tsx` — vertical slide format (Fleetster) or MDX
- **Home page** has 35/65 split cards for case study previews with browser mockups
- **No split-panel layout component** exists yet — this will be the first implementation
- **Browser chrome mockup** pattern exists in home page (red/yellow/green dots + URL bar) — can be adapted

### Key Files
- `src/styles/tailwind.css` — all brand tokens and global styles
- `src/app/page.tsx` — home page with branding patterns, browser chrome mockups, Framer Motion
- `src/app/proposals/fleetster/page.tsx` — simple slide-based proposal (pattern reference for Slide components)
- `src/components/CaseStudies.tsx` — home page case study cards with visual patterns

### Route Decision
- **Route:** `/case-studies/research-tech`
- **File:** `src/app/case-studies/research-tech/page.tsx`
- This follows the production note from `case-studies-plan.md`

---

## Existing Production Pages (for Visual Consistency)

**Location:** The current zebra design site — this case study should match the warm editorial aesthetic.

**Consistency references:**
- Home page (`/`) — branding, card styling, browser mockups
- Proposals pages — slide pattern, typography scale

**Consistency priority:**
1. Match the brand-cream background, warm typography, and editorial spacing
2. Follow the Geist Mono heading convention
3. Use brand-shadow borders (not heavy shadows)

---

## Plan

### Step 1: Create Route and Page Shell

**File:** `src/app/case-studies/research-tech/page.tsx`

- Create the new route directory and page file
- Full viewport height layout: `h-screen overflow-hidden flex`
- Left panel: `w-[380px] flex-shrink-0` — fixed position, own scroll if needed
- Right panel: `flex-1 overflow-y-auto` — the scroll container for slides
- Background: `bg-brand-cream` for the page
- Export metadata (title, description) for SEO

**Layout structure:**
```
<div className="h-screen flex bg-brand-cream">
  {/* Left Panel - Fixed */}
  <aside className="w-[380px] flex-shrink-0 border-r border-brand-shadow/30 p-10 flex flex-col justify-between overflow-y-auto">
    {/* Left panel content */}
  </aside>

  {/* Right Panel - Scrollable */}
  <main className="flex-1 overflow-y-auto p-8">
    {/* Slide cards */}
  </main>
</div>
```

### Step 2: Build the Left Panel

**Content from `case-study-rt-wireframe.md` (verbatim — this is the source of truth for what appears on the page):**

```
Research Tech
4 Zebra Sprints · React SPA
25+ screens · Live code

"I'm amazed. Unbelievable."
— Bartosz, Co-founder

→ View the live product


[ Book a Sprint → ]
or talk to Bartosz

Charlie Ellington
```

**Styling approach:**
- "Research Tech": Geist Mono, `text-lg font-bold`
- "4 Zebra Sprints · React SPA" + "25+ screens · Live code": Geist Mono, `text-sm`, stacked lines
- Sections separated by `border-b border-brand-shadow/30` dividers
- Quote: Fraunces serif, `text-base italic`, with attribution "— Bartosz, Co-founder" in Geist Mono `text-xs`
- "→ View the live product": Link styled in Geist Mono, `text-sm`, links to `research-tech-zebra.vercel.app`
- "Book a Sprint →": Primary button — `bg-brand-text text-white` with `hover:bg-brand-rose` transition
- "or talk to Bartosz": Secondary text/link — `text-sm text-zinc-500`
- "Charlie Ellington": `text-xs text-zinc-400` at bottom of panel

### Step 3: Build the Slide Card System

**Create reusable slide components within the page file (or extract if >250 lines).**

**SlideCard wrapper (shared by all slide types):**
- `w-full max-w-[800px] mx-auto` — centred in the right panel
- `aspect-[4/3]` — consistent rectangular proportions
- `bg-warm-50 rounded-xl` — warm tinted background, no border
- Inner padding: `p-12 lg:p-16` — generous whitespace
- `flex items-center justify-center` — content always centred
- Consistent spacing between cards: `space-y-6` or `gap-6`

**Slide types:**

**A) SingleScreenshotSlide (slides 1, 2, 5):**
- Card wrapper (above)
- Inner: `BrowserFrame` containing one screenshot
- Frame occupies ~75-80% of card width: `w-[80%]`
- Frame has shadow: `shadow-lg shadow-black/5`
- Screenshot via `next/image` fills the frame content area

**B) DualScreenshotSlide — desktop + mobile (slides 6b, 10):**
- Card wrapper
- Inner: `flex items-end justify-center gap-6`
- Desktop `BrowserFrame` at ~58% of card width
- Mobile `PhoneFrame` at ~25% of card width
- Both have matching shadow treatment
- `items-end` aligns bottoms so mobile frame looks grounded next to desktop

**C) DualScreenshotSlide — two desktops (slide 8):**
- Card wrapper
- Inner: `flex items-center justify-center gap-6`
- Two `BrowserFrame` components each at ~46% of card width
- Side by side, same height

**D) TextSlide (slides 3, 4, 6, 7, 9):**
- Card wrapper (same dimensions)
- Inner: `max-w-lg mx-auto text-center`
- Text in Geist Mono, `text-2xl lg:text-3xl font-bold text-brand-text`
- Each line as a separate `<p>` or `<br />` for the wireframe's line breaks

**E) QuoteSlide (slide 12):**
- Card wrapper
- Quote: Fraunces serif, `text-2xl italic text-brand-text`
- Attribution: Geist Mono, `text-sm mt-6`

**F) LinkSlide (slide 11):**
- Card wrapper
- Heading + description + prominent link styled as button

### Step 4: Device Frame Components

**A) BrowserFrame component (for desktop screenshots):**
- Light gray top bar (`bg-warm-100 h-8`) with:
  - Three dots (red `bg-red-400`, yellow `bg-yellow-400`, green `bg-green-400`, each `w-2.5 h-2.5 rounded-full`)
  - URL text in `text-xs text-zinc-400 font-mono` — shows the route path
- Content area: screenshot image below the bar
- Outer: `rounded-lg overflow-hidden shadow-lg shadow-black/5`
- Border: `border border-brand-shadow/30`

**B) PhoneFrame component (for mobile screenshots):**
- Rounded container mimicking a phone: `rounded-[2rem] overflow-hidden`
- Thin bezel: `border-[6px] border-zinc-800` (dark phone frame)
- Top notch/island indicator: small centered pill shape at top
- Content area: screenshot image fills the frame
- Shadow: `shadow-lg shadow-black/5`
- Aspect ratio: taller than wide (natural phone proportions, driven by the image)

**Pattern reference:** Home page (`page.tsx`) has browser chrome mockups. Adapt the dot colours and bar styling from there.

### Step 5: Implement the 13 Slides (Right Panel)

**Source screenshots:** `case-study-rt-planning/rt-screenshots/`
**Destination:** Copy to `public/images/case-studies/research-tech/` at build time.

Data-driven approach — define slides as an array:

```typescript
type Slide =
  | { type: 'screenshot'; src: string; alt: string; url: string }
  | { type: 'dual-desktop-mobile'; desktop: { src: string; alt: string; url: string }; mobile: { src: string; alt: string } }
  | { type: 'dual-desktop'; left: { src: string; alt: string; url: string }; right: { src: string; alt: string; url: string } }
  | { type: 'text'; lines: string[] }
  | { type: 'quote'; text: string; attribution: string }
  | { type: 'link'; heading: string; description: string; href: string; label: string }

const slides: Slide[] = [
  // 1. HERO — Research Nodes (user chose different hero — more impactful than Processing View)
  // Shows: Research nodes with findings categories, source analysis, cross-referenced data
  { type: 'screenshot',
    src: '/images/case-studies/research-tech/slide-hero-1.png',
    alt: 'Research Nodes — findings categories, source analysis, cross-referenced insights',
    url: 'stellar-labs/research-nodes' },

  // 2. HERO — Executive Brief
  // Shows: 12 key insights across categories with confidence indicators and source counts
  { type: 'screenshot',
    src: '/images/case-studies/research-tech/slide-2-hero.png',
    alt: 'Executive Brief — 12 key insights categorised by risk, opportunity, and conflict',
    url: 'stellar-labs/executive-brief' },

  // 3. CONTEXT
  { type: 'text', lines: [
    'Pre-seed AI startup.',
    'Technical founders. No product/ux designer.',
    '7 months to seed round. No time to hire.',
    'From functional API to investor-demo-ready diligence platform.'
  ] },

  // 4. INSIGHT — The Converting Slide
  { type: 'text', lines: [
    'User testing found AI-chat reduces trust.',
    'That finding saved months of wrong engineering.'
  ] },

  // 5. EVIDENCE DRAWER
  // Shows: Executive Brief with sources panel open — verified sources, confidence analysis, 3-pane layout
  { type: 'screenshot',
    src: '/images/case-studies/research-tech/slide-5.png',
    alt: 'Evidence Drawer — sources panel with verified sources, confidence analysis, and citation context',
    url: 'stellar-labs/executive-brief + sources panel' },

  // 6. NAVIGATION
  { type: 'text', lines: [
    '9 users navigated from summary to evidence',
    'without getting lost. 100% success rate.'
  ] },

  // 6b. NEW — Command Palette + Audio Briefing (desktop + mobile side by side)
  // Shows: The AI command palette overlay (desktop) + Audio Briefing with transcript (mobile)
  // Added per user request — visual slide after the navigation text
  { type: 'dual-desktop-mobile',
    desktop: {
      src: '/images/case-studies/research-tech/slide-6b-0.png',
      alt: 'AI command palette — search, analyse risks, summarise findings',
      url: 'executive-brief/command-palette'
    },
    mobile: {
      src: '/images/case-studies/research-tech/slide-6b-mobile.png',
      alt: 'Audio Briefing on mobile — transcript with chapter navigation'
    }
  },

  // 7. COMPETITIVE
  { type: 'text', lines: [
    'Conflict detection — when sources disagree, show both sides.',
    'No competitor has this.'
  ] },

  // 8. REVIEW QUEUE + RESEARCH PLANNING (two desktop screenshots side by side)
  // Shows: Review Queue with conflict/unverified items + Research Planning preview step
  { type: 'dual-desktop',
    left: {
      src: '/images/case-studies/research-tech/slide-8.png',
      alt: 'Review Queue — conflicts, unverified claims, low confidence items flagged for attention',
      url: 'review-queue'
    },
    right: {
      src: '/images/case-studies/research-tech/slide-8-2.png',
      alt: 'Research Planning — 27 categories, cross-verified, clarification questions before processing',
      url: 'reports/preview'
    }
  },

  // 9. SPEED
  { type: 'text', lines: [
    '25+ screens. 173 components. 55,000 lines of TypeScript.',
    'Shipped to the client\'s codebase in 4 weeks. No Figma.'
  ] },

  // 10. WORKFLOW DAG (desktop + mobile side by side)
  // Shows: Research method preview with full DAG (desktop) + Edit scope with node detail (mobile)
  { type: 'dual-desktop-mobile',
    desktop: {
      src: '/images/case-studies/research-tech/slide-10-1.png',
      alt: 'Research Method Preview — 27-category DAG with dependency edges and colour-coded nodes',
      url: 'reports/preview/dag'
    },
    mobile: {
      src: '/images/case-studies/research-tech/slide-10-2-mobile.png',
      alt: 'Edit Research Scope on mobile — node detail popup with dependencies'
    }
  },

  // 11. EVIDENCE LINK
  { type: 'link',
    heading: 'Evidence.',
    description: 'Explore the actual shipped product and handover.',
    href: 'https://research-tech-zebra.vercel.app/journey',
    label: '→ research-tech-zebra.vercel.app/journey' },

  // 12. CLOSING QUOTE
  { type: 'quote',
    text: '"I\'m amazed. Unbelievable.\nYou are using AI so well,\nand everything was done so fast."',
    attribution: '— Bartosz Barwikowski, Co-founder, Research Tech' },
]
```

### Screenshot File Mapping

| Slide | Source file (`rt-screenshots/`) | Dest (`public/images/case-studies/research-tech/`) | Layout |
|-------|------|------|--------|
| 1 (Hero) | `slide-hero-1.png` | `slide-hero-1.png` | Single — BrowserFrame |
| 2 (Hero) | `slide-2-hero.png` | `slide-2-hero.png` | Single — BrowserFrame |
| 5 | `slide-5.png` | `slide-5.png` | Single — BrowserFrame |
| 6b (NEW) | `slide-6b-0.png` + `slide-6b-mobile.png` | same names | Dual — BrowserFrame + PhoneFrame |
| 8 | `slide-8.png` + `slide-8-2.png` | same names | Dual — two BrowserFrames |
| 10 | `slide-10-1.png` + `slide-10-2-mobile.png` | same names | Dual — BrowserFrame + PhoneFrame |

All screenshots accounted for. 8 files → 13 slides (5 single-image, 3 dual-image, 5 text-only).

### Step 6: Scroll Animations (Framer Motion)

- **Slide entrance:** Each slide fades in and translates up slightly as it enters the viewport
- Use `motion.div` with `whileInView` for scroll-triggered animations
- Subtle spring animation: `{ type: 'spring', stiffness: 200, damping: 20 }`
- Stagger if multiple slides visible simultaneously
- Keep animations minimal — the content should be the focus

### Step 7: Mobile Responsive Layout

**Below `lg` breakpoint (1024px):**
- Left panel collapses — no longer fixed side-by-side
- **Option A (recommended): Sticky bottom bar**
  - Compact bar: Client name + key metric + "Book a Sprint" CTA
  - Always visible at bottom of screen
  - Full left panel content accessible via tap/expand
- Right panel goes full-width
- Cards maintain generous whitespace but reduce padding: `p-8` instead of `p-12`

**Below `sm` breakpoint (640px):**
- Cards: `p-6`, reduced max-width
- Text slides: `text-xl` instead of `text-2xl`
- Browser frames scale down proportionally

### Step 8: SEO Metadata

```typescript
export const metadata = {
  title: 'Research Tech Case Study — Zebra Design',
  description: 'From functional API to investor-demo-ready AI diligence platform. 4 Zebra Sprints, 25+ screens, 173 components, shipped in code.',
}
```

---

## Component Sources

- **Tier 1 (shadcn/ui)**: Button (for CTA)
- **Custom**: SlideCard, BrowserFrame, PhoneFrame, TextSlide, QuoteSlide, LinkSlide, DualScreenshotSlide
- **Framer Motion**: Scroll-triggered fade-in animations
- **Next.js**: Image (for screenshot optimisation), Link (for CTAs)

---

## File Structure

```
src/app/case-studies/
  research-tech/
    page.tsx          # Main page — may exceed 250 lines due to 13 slides + left panel

public/images/case-studies/research-tech/
    slide-hero-1.png          # Slide 1 — Research Nodes (provided)
    slide-2-hero.png          # Slide 2 — Executive Brief (provided)
    slide-5.png               # Slide 5 — Evidence Drawer with sources panel (provided)
    slide-6b-0.png            # Slide 6b desktop — Command Palette (provided)
    slide-6b-mobile.png       # Slide 6b mobile — Audio Briefing (provided)
    slide-8.png               # Slide 8 left — Review Queue (provided)
    slide-8-2.png             # Slide 8 right — Research Planning (provided)
    slide-10-1.png            # Slide 10 desktop — Workflow DAG (provided)
    slide-10-2-mobile.png     # Slide 10 mobile — Edit Scope (provided)
```

Extract components (page will exceed 250 lines with 13 slides + device frames):
```
src/components/case-studies/
    BrowserFrame.tsx    # Reusable browser chrome mockup
    PhoneFrame.tsx      # Reusable phone mockup
    SlideCard.tsx       # Card wrapper with aspect ratio + background
```

---

## Screenshot Status

All 8 screenshot files provided. No missing screenshots.

---

## Prototype Scope

- **Frontend only** — static page, no CMS or dynamic data
- **Screenshots as static images** — stored in `/public/images/case-studies/research-tech/`
- **Placeholder images** until real screenshots are provided
- **No backend integration** — all content hardcoded in the component
- **Reusable layout** — built so future case studies can use the same split-panel pattern

---

## Questions for Clarification

No clarification questions — all screenshots provided, slide-6b-1.png confirmed removed.

---

## Review Notes (Agent 2)

**Reviewed**: 2026-02-13
**Visual Reference Analysis**: AI Studio MCP — analyzed 3 reference images (Zebra landing page, 2x endless.design)

### Requirements Coverage
- ✓ All 13 slides defined with typed data structure
- ✓ All 8 screenshot files present and mapped to slides
- ✓ Left panel content matches wireframe verbatim
- ✓ BrowserFrame pattern exists in page.tsx (lines 482-491) — adapt for reusable component
- ✓ Route `/case-studies/research-tech` follows production convention
- ✓ SEO metadata included
- ✓ Mobile responsive approach defined (sticky bottom bar)
- ✓ Framer Motion scroll animations match existing codebase patterns

### Technical Notes
- `rounded-xl` renders as 8px due to tailwind.css override (`--radius-xl: 0.5rem`) — this is correct for the design system
- Fraunces font already imported in `page.tsx` — reuse the same import pattern
- Browser chrome dots pattern (red/yellow/green) exists in both `page.tsx:482-491` and `CaseStudies.tsx:148-158`
- Spring configs in `page.tsx:29-32` can be reused
- Brand tokens all verified in `src/styles/tailwind.css`

### Visual Reference Analysis (AI Studio MCP)
- Layout: 35%/65% split confirmed — plan's `w-[380px]` is narrower but appropriate for the minimal content
- Card pattern: Uniform sizing with `aspect-[4/3]` and generous padding confirmed
- Device frames: CSS-constructed frames (not bitmap mockups) — matches existing patterns
- Branding: warm-50 card backgrounds against brand-cream page — correct contrast approach

### Validation
- No clarification questions identified
- Plan is complete and execution-ready

## Technical Discovery (Agent 3)

**Completed**: 2026-02-13

### Dependency Verification
- ✅ `framer-motion: ^12.23.26` — installed
- ✅ `next: 15.5.9` — App Router confirmed
- ✅ `geist: ^1.5.1` — fonts available via layout.tsx
- ✅ `lucide-react: ^0.468.0` — available for icons
- ✅ `clsx: ^2.1.1` — className utility available
- ✅ `next/image`, `next/link` — built-in

### Layout Integration Discovery
- **CRITICAL**: Layout component (`src/components/Layout.tsx`) wraps all pages with Header + Footer + background container
- **Solution**: Use same pattern as home page (`page.tsx:267`) — `fixed inset-0 overflow-auto z-50` overlay to create own full-viewport layout
- This covers the Layout's Header/Footer and allows the case study its own split-panel navigation
- Fraunces font is imported per-page (in page.tsx) — will need same import in case study page

### Component Availability
- No `src/components/ui/` shadcn components installed — CTAs should use styled `<Link>` elements matching existing home page patterns
- No existing `src/components/case-studies/` directory — will create for BrowserFrame, PhoneFrame, SlideCard
- `public/images/case-studies/` directory exists (contains other case study images) — will create `research-tech/` subdirectory

### Font System
- `GeistSans.className` and `GeistMono.variable` set on `<html>` element in layout.tsx — globally available
- Fraunces loaded per-component via `next/font/google` (see page.tsx:93-98) — need same import in case study

### Screenshot Files Verified
All 8 source files exist in `case-study-rt-planning/rt-screenshots/`:
- slide-hero-1.png, slide-2-hero.png, slide-5.png
- slide-6b-0.png, slide-6b-mobile.png
- slide-8.png, slide-8-2.png
- slide-10-1.png, slide-10-2-mobile.png

### Discovery Summary
- **All dependencies available**: ✅
- **Technical blockers**: None
- **Ready for implementation**: Yes

## Visual Verification Results (Agent 5)
**Completed**: 2026-02-13
**Agent**: Agent 5 (Visual Verification & Fix)
**URL Tested**: http://localhost:3001/case-studies/research-tech

### Screenshots Analyzed
- Desktop (1440x900) — Captured and analyzed
- Wide Desktop (1920x1080) — Captured and analyzed
- Mobile (375x812) — Captured and analyzed

### Fixes Applied
1. **SlideCard background contrast** (file: `src/components/case-studies/SlideCard.tsx`)
   - Problem: `bg-warm-50` (#FAF7F3) nearly invisible against `bg-brand-cream` (#FFF8F3)
   - Fix: Changed to `bg-white` for clear card-to-background contrast

2. **Left panel height** (file: `src/app/case-studies/research-tech/ResearchTechCaseStudy.tsx`)
   - Problem: Left panel wrapper div didn't stretch to full viewport height
   - Fix: Added `h-full` to wrapper div so `justify-between` pushes CTAs to bottom

3. **Left panel aside height** (file: `src/app/case-studies/research-tech/LeftPanel.tsx`)
   - Problem: `<aside>` element didn't inherit full height from wrapper
   - Fix: Added `h-full` so flex `justify-between` works properly

### Visual Analysis
**Layout & Positioning**: PASS
- Split-panel layout working correctly at all viewports
- Left panel fixed with CTAs at bottom, right panel scrolls independently
- Mobile: top bar, scrollable content, sticky bottom bar all correct

**Visual Styling**: PASS
- White slide cards clearly visible on cream background
- Browser frames with traffic lights and URL bar rendering correctly
- Phone frames with dark bezel and notch rendering correctly
- Brand colors (cream, brown text, rose accent) consistent

**Responsiveness**: PASS
- 1440px: Clean split layout
- 1920px: Content properly centered, scales well
- 375px: Full mobile layout with Info bottom sheet

**Functional Testing**:
- Back link works (href="/")
- Info button opens bottom sheet with LeftPanel (AnimatePresence)
- Book a Sprint CTA present on desktop and mobile
- View live product link works
- All 13 slides render with scroll-triggered animations
- 0 console errors

### Final Score: 8.5/10

**Status**: APPROVED — Ready for Production

## Stage
Visual Verification Complete - APPROVED

## Priority
High

## Created
2026-02-13

## Files
- `src/app/case-studies/research-tech/page.tsx` (NEW)
- `src/components/case-studies/BrowserFrame.tsx` (NEW — reusable browser chrome mockup)
- `src/components/case-studies/PhoneFrame.tsx` (NEW — reusable phone mockup)
- `src/components/case-studies/SlideCard.tsx` (NEW — card wrapper with aspect ratio + background)
- `public/images/case-studies/research-tech/` (NEW directory — copy from `case-study-rt-planning/rt-screenshots/`)
