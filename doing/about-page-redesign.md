## Redesign About Page — Personal Narrative with Card Format

### Original Request

"Based on what you found and the context from this chat, can you please make a plan for updating the about page using @ai-vibe-design-code/design-1-planning.md but I do want everything in the same format - that's the simplicity - and it's ok because we have the chapters. Additionally, all case studies should come much higher before chapter 1."

**Key User Decisions:**
- ALL 16 items use the same card format as the homepage (35/65 split). No visual tier variation.
- Chapters provide grouping and variation. The format consistency IS the simplicity.
- All 3 testimonials (Bartek, Szymon, Mike) move BEFORE Chapter 1 — establishes social proof early.
- The 16 items stay in their original chronological order across chapters.
- Email signup between chapters.
- Soft CTAs at natural points.

**Content from about-page-update.md (16 items in user's original order):**
1. Zebra Design Sprint Docs — https://www.zebradesign.io/docs
2. User Testing Tool (self-built product)
3. Design Agents — article + GitHub repo
4. Visual Motion Design Agents — GitHub repo
5. Building a gift list app for daughter's birth — cocoellington.com
6. IFS App — case study article
7. Returning to work with clarity and flow — photo
8. Sabbatical — article link
9. Building off-grid campervans — photo
10. Building Deep Work Studio (long read) — article + logos
11. DIY electric yacht conversion — photo
12. Ramp Network — designed first product — Medium article
13. Nexus Mutual — designed one of first DeFi web3 products
14. Founder of Yoga Retreat Company — €1.5M annual revenue — photo
15. Teaching sailing — photo
16. Ocean kid — photo

**Analysis context (from `/deeper-short` dual-model analysis):**
- Both Claude and Gemini agree on chapter-based grouping, testimonials woven in, email signup, soft CTAs
- User overrides the analysis recommendation of 3 visual formats — wants one consistent format
- Full analysis docs: `workings/about-page-redesign/about-page-redesign-03-summary.md`

---

### Design Context

**Visual Format — Homepage Card Pattern (source of truth: `src/app/page.tsx`):**
- `<section>` containing `<motion.article>` with `rounded-xl overflow-hidden`
- `flex flex-col lg:flex-row` layout
- Left column: `lg:w-[35%] p-8 lg:p-12` — badges, serif title, description, CTA link
- Right column: `lg:w-[65%] min-h-[350px] lg:min-h-[550px]` — visual content
- White card bg: `bg-white dark:bg-zinc-800`
- Box shadow: `0 0 0 10px rgba(229,213,200,0.5), 0 4px 12px -2px rgba(65,60,56,0.06)`
- Hover: `whileHover={{ y: -4 }}` with enhanced shadow
- Scroll animation: `whileInView` with `springBouncy` transition
- Badge style: `font-mono text-xs uppercase` with `border-[#AFACFF]/50 bg-[#AFACFF]/10`
- Title: `font-serif text-3xl lg:text-4xl` (Fraunces)
- Description: `text-brand-text/70 text-lg leading-relaxed`
- CTA: arrow icon with `springSnappy` hover

**Gradient backgrounds per card (each card gets its own):**
- Lavender: `linear-gradient(135deg, #F8F6FF 0%, #F0EEFF 30%, #FFF5F8 60%, #FFF8F5 100%)`
- Teal: `linear-gradient(135deg, #EEEAFF 0%, #F2EEFF 40%, #F5F0FF 70%, #FFF8F5 100%)`
- Dark (Animatix): `linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)`
- Coral (Paid24/7): `linear-gradient(135deg, #E8E4FF 0%, #F5E6F0 40%, #FFE8E0 70%, #FFF2E8 100%)`
- Green (Ramp): `#f0f7f0`
- Blue-grey (Deep Work): `linear-gradient(135deg, #E8F2F5 0%, #F0EEF5 40%, #F5F0F0 70%, #FFF8F5 100%)`
- Warm peach (User Testing): `linear-gradient(135deg, #FFF5F0 0%, #FFE8E0 30%, #FFEBD8 60%, #FFF2E8 100%)`

**Card direction alternation:**
- Default: text-left (order-1), visual-right (order-2) on desktop
- Flipped: visual-left (order-1), text-right (order-2) — achieved by swapping `order-1`/`order-2`
- Alternate every other card to prevent visual monotony

**Testimonial format (from `src/app/refer/ReferContent.tsx` lines 190-276):**
- Avatar + company logo overlap pattern
- `font-mono text-base` for quote text
- `text-brand-text/60 text-sm` for attribution
- Framer Motion fade-in animation

**Typography:**
- Fraunces serif for headings (`font-serif`)
- System/Geist for body text
- Design tokens: `brand-cream`, `brand-text`, `brand-rose`

**Existing components to reuse:**
- `UserTestingCard` (`src/components/case-studies/UserTestingCard.tsx`) — self-contained with video hover
- `BrowserFrame` (`src/components/case-studies/BrowserFrame.tsx`)
- Spring configs: `springBouncy`, `springSmooth`, `springSnappy`, `springBadge`
- Stagger variants: `staggerContainer`, `fadeUpChild`, `badgeChild`

---

### Codebase Context

**Framework:** Next.js 15 (App Router), React 19, Tailwind CSS v4, Framer Motion 12
**Dev server:** `next dev` (port 3000)

**Primary file to modify:**
- `src/app/about/page.tsx` (358 lines) — current About page, will be completely rewritten

**Current page structure being replaced:**
- Server component with intro, logos, article categories, Substack embed, timeline grid
- Will become a client component (needs `'use client'` for Framer Motion)

**Key dependencies:**
- `framer-motion` — animations, `whileInView`, spring configs
- `next/image` — optimised images
- `next/font/google` — Fraunces font
- `clsx` — conditional classes
- `next-themes` — dark mode (existing in layout)

**Assets available:**
- About photos: `/images/zebra/about/` (Wingfoiling, Surfing, Remote work campervan, Electric sailing yacht, Founder yoga retreat, Kitesurfing 1 & 2)
- Case study screenshots: `/images/case-studies/` (research-tech/, animatix, paid-247, deep-1 through deep-4)
- Build screenshots: `/images/zebra/builds/` (Nexus Mutual, Ramp, IFS Application, Deep Work Studio, Ethereum Foundation)
- Client logos: `/images/zebra/logos/` (all existing)
- User testing: `/images/user-testing-demo-fallback.png`, `/User Testing App Demo.mp4`
- Referrer avatars: `/images/referrers/` (bartek.jpg, szymon.jpg, mike.png, ramp-logo.jpg, hummingbot-logo.jpg)
- Charlie photo: `/images/zebra/other/charlie-ellington.jpg`

**Articles with MDX pages (for linking):**
- `/articles/design-agents-flow` — Design Agents
- `/articles/sabbatical` — Sabbatical
- `/articles/ifs-case-study` — IFS App
- `/articles/building-deep-work-studio` — Deep Work Studio
- `/articles/ramp-spotlights` — Ramp Spotlights

**Substack articles (external links):**
- User Testing Tool: `https://open.substack.com/pub/charliedesign/p/the-user-testing-tool-i-wish-existed`

---

### Plan

**Important architectural decisions:**
1. The About page must match the landing page's full visual style — not just cards, but background, orbs, header, nav, typography.
2. Currently, the landing page has all these elements inline in `page.tsx` (~1166 lines). The About page should reuse them, not recreate them.
3. The approach: **extract shared layout and card components from the landing page**, then both pages import from the same source.

---

#### Step 1: Extract shared page layout — `PageLayout`

**File:** `src/components/layout/PageLayout.tsx` (~100 lines)

Extract from `src/app/page.tsx` (lines 258-336):
- Full-viewport wrapper: `fixed inset-0 overflow-auto bg-brand-cream dark:bg-zinc-900`
- Fraunces font variable
- Selection colour styling
- Decorative gradient orbs (lavender top-right, coral bottom-left with floating animation)
- Static header (avatar, nav, theme toggle — visible before scroll)
- Fixed header (appears on scroll-up)
- `useScrollDirection` hook (lines 52-91)

This wraps `children` so any page can use the same visual shell.

**Source components to extract from `page.tsx`:**
- `useScrollDirection` hook (lines 52-91)
- `ThemeToggle` (lines 151-170)
- `MobileNavigation` (lines 188-221)
- `DesktopNavigation` (lines 224-255)
- Static + Fixed header blocks (lines 282-336)
- Decorative orbs (lines 268-279)

After extraction, `page.tsx` imports `PageLayout` and wraps its content. No visual change — just code reuse.

---

#### Step 2: Extract shared card component — `CaseStudyCard`

**File:** `src/components/layout/CaseStudyCard.tsx` (~120 lines)

Extract the repeating card pattern from `src/app/page.tsx`. Every case study card follows the identical structure:
- `<section>` → `<motion.article>` with shadow, hover, rounded-xl
- `flex flex-col lg:flex-row`
- Left: `lg:w-[35%]` — badges, title, description, CTA
- Right: `lg:w-[65%]` — visual content (passed as `children` or render prop)

Props:
- `badges: string[]`
- `title: string`
- `description: string`
- `ctaText: string`
- `ctaHref: string`
- `ctaExternal?: boolean`
- `visualContent: React.ReactNode` — the right column content
- `gradient: string` — background gradient for visual column
- `reversed?: boolean` — flip column order for alternation

Spring configs (`springBouncy`, `springSnappy`, etc.) and motion variants (`staggerContainer`, `badgeChild`, `fadeUpChild`) should be extracted to a shared `src/components/layout/motion-config.ts` file.

After extraction, `page.tsx` case studies use `<CaseStudyCard>` instead of duplicating ~80 lines each. Both pages share the same component.

---

#### Step 3: Extract motion config

**File:** `src/components/layout/motion-config.ts` (~30 lines)

Extract from `src/app/page.tsx` (lines 29-50):
- `springBouncy`, `springSmooth`, `springSnappy`, `springBadge`
- `staggerContainer`, `fadeUpChild`, `badgeChild`

These are currently duplicated in `page.tsx` and `UserTestingCard.tsx`. Single source of truth.

---

#### Step 4: Create small About-specific components

**File:** `src/components/about/AboutSections.tsx` (~150 lines)

These are small, About-page-specific pieces that don't need their own files:

1. **`Testimonials`** — Reuse the testimonial pattern from `src/app/refer/ReferContent.tsx` (avatar + company logo overlap, monospace quote, attribution). Display all 3 in a grid.

2. **`ChapterDivider`** — Subtle chapter marker (generous whitespace, small date range text in `font-mono uppercase`, optional thin line).

3. **`EmailSignup`** — Substack iframe embed (reuse from current about page) with updated copy: "Follow along — I send personal updates about what I'm building and where I am."

4. **`SoftCTA`** — "Currently taking select sprints →" link at page bottom.

---

#### Step 5: Create visual content helpers

**File:** `src/components/about/AboutVisuals.tsx` (~120 lines)

Visual content for the right column of each `CaseStudyCard`:

1. **`BrowserScreenshot`** — Browser chrome + Image. Reuse the exact browser chrome pattern from `page.tsx` (lines 599-608: dots + URL bar). Used for: Sprint Docs, Design Agents, Gift List App, IFS App, Ramp, Nexus Mutual.

2. **`PhotoVisual`** — Full-bleed photo with gradient mask fade. Used for: Wingfoiling, Sabbatical, Campervans, Yacht, Yoga, Sailing, Ocean kid.

3. **`LogoGrid`** — Client logo grid. Reuse the exact pattern from `page.tsx` Deep Work card (lines 1078-1106). Used for: Deep Work Studio card.

---

#### Step 6: Rewrite the About page

**File:** `src/app/about/page.tsx` (~250 lines)

`'use client'` component that imports and composes:
- `PageLayout` for the full visual shell (background, orbs, header, nav)
- `CaseStudyCard` for each of the 16 items
- `Testimonials`, `ChapterDivider`, `EmailSignup`, `SoftCTA` from AboutSections
- `BrowserScreenshot`, `PhotoVisual`, `LogoGrid` from AboutVisuals
- `UserTestingCard` directly (already self-contained)

---

#### Step 7: Update landing page to use extracted components

**File:** `src/app/page.tsx` (refactor, no visual change)

Update `page.tsx` to import from the extracted shared components:
- Wrap content in `<PageLayout>` instead of inline layout code
- Replace inline case study cards with `<CaseStudyCard>` components
- Import spring configs from `motion-config.ts`

This ensures both pages stay in sync and reduces `page.tsx` from ~1166 lines significantly.

**Page structure (testimonials before Chapter 1, items in original order):**

```
HERO
├── Photo of Charlie (keep current)
├── "I'm Charlie." headline
├── Updated subtitle: "I design products for technical founders — in code, not Figma.
│   Before that: design studios, campervans, yoga retreats, and a lot of ocean.
│   Here's everything."
├── Social links (LinkedIn, GitHub)
└── Client logos (8 logos)

TESTIMONIALS (all 3 — establishes social proof before the narrative)
├── Bartek (Research Tech): "I'm amazed. Unbelievable..."
├── Szymon (Ramp): "Shortest design cycle available on the market..."
└── Mike (Hummingbot): "In a mere two weeks..."

CHAPTER 1: "Now" (2024-2026)
├── ChapterDivider: "Now" (2024-2026)
├── Card 1: Zebra Design Sprint Docs
│   Badges: ['Docs', 'Next.js']
│   CTA: "View docs →" → https://www.zebradesign.io/docs
│   Visual: BrowserScreenshot or iframe of docs site
├── Card 2: User Testing Tool (REVERSED)
│   Use the existing UserTestingCard component (self-contained with video hover)
│   Adapt to fit within AboutCard pattern or use directly
├── Card 3: Design Agents
│   Badges: ['AI', 'Open Source']
│   CTA: "Read article →" → /articles/design-agents-flow
│   Visual: BrowserScreenshot with GitHub repo screenshot or code snippet
├── Card 4: Visual Motion Design Agents (REVERSED)
│   Badges: ['AI', 'Animation', 'Open Source']
│   CTA: "View on GitHub →" → external GitHub link
│   Visual: GitHub repo card or animation screenshot
├── Card 5: Gift List App — Coco
│   Badges: ['Personal', 'Full-Stack']
│   CTA: "Visit app →" → https://cocoellington.com
│   Visual: BrowserScreenshot or iframe of cocoellington.com
├── Card 6: IFS App (REVERSED)
│   Badges: ['Personal', 'UX Case Study']
│   CTA: "Read case study →" → /articles/ifs-case-study
│   Visual: BrowserScreenshot with /images/zebra/builds/IFS Application (1).png

EMAIL SIGNUP
"Follow along — I send personal updates about what I'm building and where I am."

CHAPTER 2: "The Reset" (2023-2024)
├── ChapterDivider: "The Reset" (2023-2024)
├── Card 7: Returning to work with clarity and flow
│   Badges: ['2024', 'Renewal']
│   Description: Short personal text about returning with clarity
│   Visual: PhotoVisual with /images/zebra/about/Wingfoiling.jpg
├── Card 8: Sabbatical (REVERSED)
│   Badges: ['2023', 'Sabbatical']
│   CTA: "Read article →" → /articles/sabbatical
│   Visual: PhotoVisual with /images/zebra/about/Surfing.jpg
├── Card 9: Building off-grid campervans
│   Badges: ['2023', 'Off-Grid']
│   Description: Short text about van life
│   Visual: PhotoVisual with /images/zebra/about/Remote work campervan.jpg

CHAPTER 3: "Web3 Era" (2017-2023)
├── ChapterDivider: "Web3 Era" (2017-2023)
├── Card 10: Building Deep Work Studio (REVERSED)
│   Badges: ['2018-2023', 'Web3', 'Remote-first']
│   CTA: "Read the story →" → /articles/building-deep-work-studio
│   Visual: LogoGrid component (Deep Work, Ramp, Ethereum, Nexus, Maker, ConsenSys, Arbitrum)
├── Card 11: DIY electric yacht conversion
│   Badges: ['2018', 'Engineering']
│   Description: Short text about converting a yacht to electric
│   Visual: PhotoVisual with /images/zebra/about/Electric sailing yacht conversion.jpg
├── Card 12: Ramp Network (REVERSED)
│   Badges: ['Web3', 'Product Design']
│   CTA: "View case study →" → /case-studies/ramp-network
│   Visual: BrowserScreenshot with /images/zebra/builds/Ramp (1).png
├── Card 13: Nexus Mutual
│   Badges: ['DeFi', 'Web3', 'First Product']
│   CTA: "View project →" (external or article)
│   Visual: BrowserScreenshot with /images/zebra/builds/Nexus Mutual.png

CHAPTER 4: "First Chapters" (pre-2017)
├── ChapterDivider: "First Chapters" (pre-2017)
├── Card 14: Yoga Retreat Company (REVERSED)
│   Badges: ['2013-2017', 'Founder', '€1.5M Revenue']
│   Description: Founded and scaled a yoga retreat company
│   Visual: PhotoVisual with /images/zebra/about/Founder yoga retreat company.jpg
├── Card 15: Teaching sailing
│   Badges: ['2008-2012', 'Leadership']
│   Description: Teaching sailing, learning to lead
│   Visual: PhotoVisual with /images/zebra/about/Kitesurfing 1.jpg
├── Card 16: Ocean kid (REVERSED)
│   Badges: ['1989', 'Origins']
│   Description: On the ocean since age 11
│   Visual: PhotoVisual with /images/zebra/about/Kitesurfing 2.jpg

SOFT CTA
"Currently taking select sprints →" → link to sprint booking
```

**Card direction pattern:** Alternate `reversed` prop on every other card within each chapter. First card in each chapter starts normal (text-left, visual-right), second is reversed, etc.

---

#### Step 8: Handle the UserTestingCard integration

The existing `UserTestingCard` (`src/components/case-studies/UserTestingCard.tsx`) is self-contained with its own `<section>` wrapper and duplicated spring configs. After Step 3, update it to import from `motion-config.ts` instead. Otherwise use it directly — it already matches the card format perfectly.

---

#### Step 9: Performance considerations

- Use `whileInView` with `viewport={{ once: true }}` on all cards (already the homepage pattern)
- Lazy load images with `loading="lazy"` on non-above-fold cards
- The video in UserTestingCard already uses `preload="metadata"`
- Consider `next/dynamic` for below-fold card sections if bundle size is a concern

---

#### Step 10: Verify and test

- Run `npm run build` to verify no TypeScript errors
- Start dev server and visually verify:
  - Landing page looks identical (no regression from extraction)
  - About page matches landing page visual style (background, orbs, header, cards)
  - All 16 cards render with correct alternation
  - Testimonials appear before Chapter 1
  - Email signup appears between Chapter 1 and 2
  - Dark mode works
  - Mobile responsiveness (cards stack vertically)
  - All links work (internal articles, external Substack/GitHub)

---

### Stage
Ready for Manual Testing

### Review Notes

**Reviewed by:** Agent 2 (Review) — 2026-02-17

**AI Studio MCP:** Not used (no reference images in task)

**Verdict:** VALIDATED — Plan is sound and ready for discovery.

**Requirements Coverage:** All 6 requirements confirmed (16 items in order, testimonials before Ch1, email signup between chapters, soft CTAs, same card format, chapter grouping).

**Design Context accuracy:** All card structure details, spring configs, gradient backgrounds, badge styles, column alternation, and testimonial patterns verified against actual `page.tsx` (1181 lines) and `ReferContent.tsx` (lines 190-276). Every claim matches the source code.

**Asset paths:** All 19 referenced image/video paths verified to exist in `/public/`.

**Route links:** All 5 article routes and 1 case-study route verified to exist.

**Architecture:** Extraction of PageLayout, CaseStudyCard, and motion-config is the correct approach for code reuse and single source of truth.

**Notes for Discovery/Execution agents:**

1. **PageLayout size:** Plan estimates ~100 lines but actual extraction (including icon components, hooks, nav, theme toggle) is closer to ~250 lines. Consider splitting SVG icons into a separate utility file to stay under the limit.

2. **About page card data:** 16 cards with badges, titles, descriptions, CTAs, gradients, and visual content will push the About page past 250 lines. Recommend extracting card data to `src/components/about/about-data.ts`.

3. **BrowserFrame style:** The existing `BrowserFrame.tsx` uses different styling (warm-100, h-8, smaller dots) than the homepage inline browser chrome (stone-100, h-10, 3px dots). The new `BrowserScreenshot` helper should match the homepage style, which is the design source of truth.

4. **Missing visual assets:** Cards 3 (Design Agents) and 4 (Visual Motion Design Agents) reference GitHub screenshots that do not yet exist. These will need to be created or sourced during implementation.

5. **Sprint Docs card (Card 1):** If using iframe, watch for CSP issues. A static screenshot is safer.

6. **New file:** Add `src/components/about/about-data.ts` to the Files list (~50 lines, card content definitions).

### Questions for Clarification

No blocking questions. All noted items are implementation details, not plan gaps.

### Priority
High

### Created
2026-02-17

### Files

**New files (extracted from landing page):**
- `src/components/layout/PageLayout.tsx` — Shared page shell (background, orbs, header, nav, theme toggle)
- `src/components/layout/CaseStudyCard.tsx` — Shared card component (35/65 split, badges, title, CTA, visual)
- `src/components/layout/motion-config.ts` — Shared spring configs and motion variants

**New files (About-specific):**
- `src/components/about/AboutSections.tsx` — Testimonials, ChapterDivider, EmailSignup, SoftCTA
- `src/components/about/AboutVisuals.tsx` — BrowserScreenshot, PhotoVisual, LogoGrid

**Modified files:**
- `src/app/about/page.tsx` — Complete rewrite using shared components
- `src/app/page.tsx` — Refactor to use extracted shared components (no visual change)
- `src/components/case-studies/UserTestingCard.tsx` — Update to import from shared motion-config

---

### Technical Discovery

**Discovered by:** Agent 3 (Technical Discovery) — 2026-02-17

---

#### 1. MCP Connection Verification

- **shadcn/ui MCP:** Connected and responding. Full component list available (accordion, alert, badge, button, card, dialog, etc.). Confirmed: no shadcn components needed for this task — the plan correctly extracts custom Framer Motion card patterns from the landing page instead of using shadcn Card.

---

#### 2. Component Identification Verification

| File | Status | Lines | Notes |
|------|--------|-------|-------|
| `src/app/page.tsx` | EXISTS | 1181 | Source of truth for card pattern, layout, nav, theme toggle, spring configs |
| `src/app/about/page.tsx` | EXISTS | 358 | Server component, will be completely rewritten as client component |
| `src/components/case-studies/UserTestingCard.tsx` | EXISTS | 232 | Self-contained card with video hover. Duplicates spring configs. |
| `src/components/case-studies/BrowserFrame.tsx` | EXISTS | 37 | Different styling than homepage browser chrome — do NOT reuse for About page |
| `src/app/refer/ReferContent.tsx` | EXISTS | 976 | Testimonial pattern source (lines 190-276). Also duplicates spring configs. |
| `src/components/case-studies/SlideCard.tsx` | EXISTS | 32 | Duplicates `springSmooth` only |
| `src/components/layout/` | DOES NOT EXIST | — | Must be created. Plan is correct. |
| `src/components/about/` | DOES NOT EXIST | — | Must be created. Plan is correct. |

**Spring config duplication count:** 4 files duplicate the same configs. Extraction to `motion-config.ts` is justified.

---

#### 3. Design Language Consistency Verification (BLOCKING)

**Step 1: Documented design language from source of truth (`page.tsx`):**

| Pattern | Exact Value | Source |
|---------|-------------|--------|
| Card wrapper | `<motion.article>` with `rounded-xl overflow-hidden` | page.tsx L370 |
| Card bg | `bg-white dark:bg-zinc-800` | page.tsx L370 |
| Card shadow (rest) | `0 0 0 10px rgba(229,213,200,0.5), 0 4px 12px -2px rgba(65,60,56,0.06)` | page.tsx L375 |
| Card shadow (hover) | `0 0 0 10px rgba(229,213,200,0.5), 0 20px 40px -12px rgba(253,167,160,0.25), 0 20px 40px -12px rgba(228,189,218,0.2)` | page.tsx L379 |
| Card hover lift | `whileHover={{ y: -4 }}` | page.tsx L377 |
| Layout | `flex flex-col lg:flex-row` | page.tsx L385 |
| Left column | `w-full lg:w-[35%] p-8 lg:p-12 flex flex-col justify-between relative z-10` | page.tsx L387 |
| Right column | `w-full lg:w-[65%] min-h-[350px] lg:min-h-[550px] relative overflow-hidden` | page.tsx L492 |
| Mobile order | Text: `order-2 lg:order-1`, Visual: `order-1 lg:order-2` | page.tsx L387, L492 |
| Badge container | `flex flex-wrap gap-2 mb-6` with `staggerContainer` variants | page.tsx L391 |
| Badge style | `px-3 py-1 text-xs font-mono text-brand-text dark:text-zinc-300 border border-[#AFACFF]/50 dark:border-[#AFACFF]/40 rounded bg-[#AFACFF]/10 dark:bg-[#AFACFF]/15 uppercase tracking-wide` | page.tsx L400 |
| Title | `font-serif text-3xl lg:text-4xl text-brand-text dark:text-white mb-4 tracking-tight leading-tight` | page.tsx L408 |
| Description | `text-brand-text/70 dark:text-zinc-400 text-lg leading-relaxed mb-8` | page.tsx L413 |
| CTA wrapper | `<motion.div whileTap={{ scale: 0.95 }} transition={{ duration: 0.05 }}>` | page.tsx L474 |
| CTA link | `flex items-center gap-2 text-brand-text dark:text-white font-medium hover:text-brand-rose dark:hover:text-gradient-pink-purple transition-colors` | page.tsx L475 |
| CTA arrow | `<motion.svg>` with `whileHover={{ x: 4 }}` and `springSnappy` transition | page.tsx L477-485 |
| Section wrapper | `<section className="w-full max-w-7xl mx-auto px-6 pb-24 lg:pb-32">` | page.tsx L368 |
| Scroll animation | `whileInView` with `viewport={{ once: true, margin: "-100px" }}` | page.tsx L525 |
| Page background | `fixed inset-0 overflow-auto bg-brand-cream dark:bg-zinc-900 text-brand-text dark:text-zinc-100 selection:bg-gradient-pink-purple/30 dark:selection:bg-gradient-pink-purple/40 z-50` | page.tsx L264 |
| Browser chrome bar | `h-10 bg-stone-100 border-b border-stone-200` with `w-3 h-3` dots and `/80` opacity | page.tsx L613-622 |
| Browser chrome URL | `bg-white rounded-md px-3 py-1 text-xs text-zinc-500 text-center max-w-[200px] mx-auto` | page.tsx L618-620 |
| Browser container | `absolute top-8 left-8 right-0 bottom-0 shadow-2xl rounded-tl-xl overflow-hidden bg-white` | page.tsx L604 |
| Gradient mask | `maskImage: 'linear-gradient(to bottom, black 70%, transparent 100%)'` | page.tsx L628-629 |

**Step 2: Plan alignment check — PASS.**
The plan's CaseStudyCard props (badges, title, description, ctaText, ctaHref, visualContent, gradient, reversed) will produce the exact same HTML/CSS structure as verified above.

**Step 3: shadcn defaults that would need overriding — N/A.**
No shadcn components are used. The plan correctly avoids shadcn Card (which uses different border/shadow/padding defaults) and instead extracts from `page.tsx`.

---

#### 4. BrowserFrame Style Mismatch — CONFIRMED

The existing `BrowserFrame.tsx` (`src/components/case-studies/BrowserFrame.tsx`) uses different styling from the homepage browser chrome:

| Property | BrowserFrame.tsx | Homepage (page.tsx) |
|----------|------------------|---------------------|
| Bar height | `h-8` | `h-10` |
| Bar bg | `bg-warm-100` | `bg-stone-100` |
| Dot size | `h-2.5 w-2.5` | `w-3 h-3` |
| Dot opacity | full (`bg-red-400`) | `/80` suffix (`bg-red-400/80`) |
| Border | `border border-brand-shadow/30` | `border-b border-stone-200` |
| Font | `font-mono text-xs text-zinc-400` | `text-xs text-zinc-500` |
| Container | Full rounded (`rounded-lg`) | Corner-only rounded (`rounded-tl-xl`) |
| Position | Static | `absolute top-8 left-8 right-0 bottom-0` |

**Decision: Do NOT reuse `BrowserFrame.tsx`.** The new `BrowserScreenshot` helper must match the homepage's inline browser chrome exactly. This aligns with the plan.

---

#### 5. Spring Config Duplication Audit

Files with duplicated spring configs:
1. `src/app/page.tsx` — all 4 springs + 3 variants (lines 29-50)
2. `src/components/case-studies/UserTestingCard.tsx` — `springBouncy`, `springSnappy`, `staggerContainer`, `badgeChild` (lines 25-38)
3. `src/app/refer/ReferContent.tsx` — all 4 springs + 3 variants (lines 36-54)
4. `src/components/case-studies/SlideCard.tsx` — `springSmooth` only (line 12)

Extraction to `src/components/layout/motion-config.ts` will eliminate this duplication. After extraction, all 4 files should import from this single source. The `ReferContent.tsx` file should also be updated (not in plan scope but noted).

---

#### 6. Asset Verification

**About photos (`/public/images/zebra/about/`):**
| Asset | Status |
|-------|--------|
| `Wingfoiling.jpg` | EXISTS |
| `Surfing.jpg` | EXISTS |
| `Remote work campervan.jpg` | EXISTS |
| `Electric sailing yacht conversion.jpg` | EXISTS |
| `Founder yoga retreat company.jpg` | EXISTS |
| `Kitesurfing 1.jpg` | EXISTS |
| `Kitesurfing 2.jpg` | EXISTS |

**Build screenshots (`/public/images/zebra/builds/`):**
| Asset | Status |
|-------|--------|
| `IFS Application (1).png` | EXISTS |
| `Ramp (1).png` | EXISTS |
| `Nexus Mutual.png` | EXISTS |

**Client logos (`/public/images/zebra/logos/`):**
| Asset | Status |
|-------|--------|
| `deep-work-logo.svg` | EXISTS |
| `ramp-logo-network.svg` | EXISTS |
| `ethereum.svg` | EXISTS |
| `nexus mutual.png` | EXISTS |
| `MAKER-DAO-LOGO.png` | EXISTS |
| `Consensys_logo_2023.svg.png` | EXISTS |
| `arbitrum.png` | EXISTS |
| `spark.png` | EXISTS |
| `ramp.png` | EXISTS |

**Referrer avatars (`/public/images/referrers/`):**
| Asset | Status |
|-------|--------|
| `bartek.jpg` | EXISTS |
| `szymon.jpg` | EXISTS |
| `mike.png` | EXISTS |
| `ramp-logo.jpg` | EXISTS |
| `hummingbot-logo.jpg` | EXISTS |

**Charlie photo:**
| Asset | Status |
|-------|--------|
| `/images/zebra/other/charlie-ellington.jpg` | EXISTS |

**User testing assets:**
| Asset | Status |
|-------|--------|
| `/images/user-testing-demo-fallback.png` | EXISTS |
| `/User Testing App Demo.mp4` | EXISTS |
| `/images/user-testing-video-poster.png` | MISSING |

**Note:** `user-testing-video-poster.png` is referenced in `UserTestingCard.tsx` as the video poster but does not exist on disk. This is a pre-existing issue in the codebase — the video falls back to no poster. Not a blocker for this task since `UserTestingCard` already works without it.

**Missing assets (from Agent 2 review, confirmed):**
- Cards 3 and 4 (Design Agents, Visual Motion Design Agents) reference GitHub repo screenshots that do not exist. Implementation will need placeholder visuals or screenshots must be created during execution.

---

#### 7. Dependency Verification

| Dependency | Required | Installed Version | Status |
|------------|----------|-------------------|--------|
| `framer-motion` | Yes | `^12.23.26` | OK |
| `next-themes` | Yes | `^0.4.6` | OK |
| `clsx` | Yes | `^2.1.1` | OK |
| `next` (includes `next/font/google`, `next/image`) | Yes | `15.5.9` | OK |
| `react` | Yes | `^19.1.2` | OK |
| `@headlessui/react` | Yes (MobileNavigation uses Popover) | `^2.2.6` | OK |
| `geist` | Yes (body font) | `^1.5.1` | OK |

**No new packages need to be installed.**

---

#### 8. Architecture Notes for Execution Agent

1. **`src/components/layout/` directory does not exist** — must be created.

2. **`src/components/about/` directory does not exist** — must be created.

3. **PageLayout extraction must include `@headlessui/react` imports** — `MobileNavigation` uses `Popover`, `PopoverButton`, `PopoverBackdrop`, `PopoverPanel` from `@headlessui/react`. These must be imported in `PageLayout.tsx`.

4. **PageLayout must include 6 SVG icon components** — `CloseIcon`, `ChevronDownIcon`, `SunIcon`, `MoonIcon` are inline in `page.tsx` (lines 100-149). Recommend extracting to a separate `src/components/layout/icons.tsx` file to keep `PageLayout.tsx` under 250 lines. (~50 lines for icons).

5. **`fraunces` font variable** — Currently initialized in `page.tsx` (lines 93-98) and in `ReferContent.tsx` (lines 25-29). Must be exported from `PageLayout.tsx` or from a shared location. Each page that uses `PageLayout` should not need to re-initialize the font.

6. **Avatar image import** — `page.tsx` uses `import avatarImage from '@/images/avatar.png'` (static import for optimized handling). `PageLayout` must preserve this import pattern.

7. **About page will become a client component** — Current `about/page.tsx` is a server component (`async function About()` with `getAllArticles()`). The new version needs `'use client'` for Framer Motion. The `getAllArticles()` call will be removed since the new About page doesn't list articles.

8. **Existing `Card.tsx` (`src/components/Card.tsx`)** is a different component (used for article listings). It is NOT the same as the homepage card pattern. Do not confuse or merge them.

9. **Existing `ClientLogos.tsx`** uses `Card` component and a different layout (2-column grid with dark mode logo switching). The homepage card's inline logo grid is the source of truth for the About page.

10. **Review Note #2 confirmed:** 16 cards with all their data will push `about/page.tsx` past 250 lines. The recommended `src/components/about/about-data.ts` file for card content definitions should be added.

11. **Review Note #1 confirmed:** PageLayout with all nav, icons, hooks, and theme toggle is closer to ~250 lines. Splitting icons to `icons.tsx` will keep both files manageable.

---

#### 9. Visual-Technical Reconciliation

- **Correct approach: extract from landing page, not use shadcn.** The landing page uses custom Framer Motion `<motion.article>` cards with inline box-shadow, spring animations, and gradient backgrounds. shadcn Card uses Radix primitives and different defaults (border, padding, background) that would require extensive overriding.

- **No new shadcn installations needed.** Confirmed.

- **The landing page is the single source of truth** for visual patterns. The refer page (`ReferContent.tsx`) already copies from it successfully (identical card structure, same spring configs, same testimonial pattern). The About page should follow the same approach.

---

#### 10. Execution File List (Updated)

**New files to create:**
1. `src/components/layout/PageLayout.tsx` (~200 lines) — shared page shell
2. `src/components/layout/icons.tsx` (~50 lines) — SVG icon components extracted from page.tsx
3. `src/components/layout/CaseStudyCard.tsx` (~120 lines) — shared card component
4. `src/components/layout/motion-config.ts` (~30 lines) — shared spring configs and variants
5. `src/components/about/AboutSections.tsx` (~150 lines) — Testimonials, ChapterDivider, EmailSignup, SoftCTA
6. `src/components/about/AboutVisuals.tsx` (~120 lines) — BrowserScreenshot, PhotoVisual, LogoGrid
7. `src/components/about/about-data.ts` (~80 lines) — card content data for all 16 items

**Files to modify:**
1. `src/app/about/page.tsx` — complete rewrite (~200 lines, composes shared components + data)
2. `src/app/page.tsx` — refactor to use extracted components (no visual change)
3. `src/components/case-studies/UserTestingCard.tsx` — import from shared motion-config

**Files NOT to modify (outside scope):**
- `src/app/refer/ReferContent.tsx` — duplicates configs but not in task scope
- `src/components/case-studies/SlideCard.tsx` — duplicates `springSmooth` but not in task scope

---

### Implementation Notes

**Implemented by:** Agent 4 (Execution) — 2026-02-17

**Build status:** `npm run build` passes with zero TypeScript errors. All 57 pages generated successfully.

**Files created (7 new):**
1. `src/components/layout/motion-config.ts` (28 lines) — shared spring configs and motion variants
2. `src/components/layout/icons.tsx` (60 lines) — CloseIcon, ChevronDownIcon, SunIcon, MoonIcon SVGs
3. `src/components/layout/PageLayout.tsx` (208 lines) — shared page shell with bg, orbs, headers, nav, theme toggle
4. `src/components/layout/CaseStudyCard.tsx` (122 lines) — shared 35/65 card component with badges, title, CTA
5. `src/components/about/about-data.ts` (175 lines) — all 16 card items across 4 chapters
6. `src/components/about/AboutSections.tsx` (148 lines) — Testimonials, ChapterDivider, EmailSignup, SoftCTA
7. `src/components/about/AboutVisuals.tsx` (143 lines) — BrowserScreenshot, PhotoVisual, LogoGrid, CodeVisual

**Files modified (3):**
1. `src/app/about/page.tsx` — complete rewrite (165 lines, was 358 lines as server component)
2. `src/app/page.tsx` — refactored to use PageLayout wrapper and shared motion-config imports (was 1181 lines, now 609 lines)
3. `src/components/case-studies/UserTestingCard.tsx` — imports from motion-config.ts instead of duplicating (was 232 lines, now 218 lines)

**Architecture decisions:**
1. **Landing page cards kept inline:** The homepage cards (Zebra Sprint, Research Tech, Animatix, Paid24/7, Ramp, Deep Work) each have unique visual content and behavior (iframe, side-by-side images, tandem phones, Spotlight2b component, demo button) that cannot be expressed through CaseStudyCard's `visualContent` prop without significant complexity. Keeping them inline preserves exact visual behavior and avoids regression risk. The layout shell (PageLayout) and motion configs are shared.
2. **CodeVisual component:** For Cards 3 and 4 (Design Agents, Visual Motion Design Agents), GitHub screenshots do not exist. Created a `CodeVisual` component that renders a styled code snippet card as a placeholder visual. The dark variant matches the Animatix dark gradient.
3. **Cards with no meaningful CTA:** Cards 7, 9, 11, 14, 15, 16 (personal/photo cards) link to `/about` as they have no external article. These could be updated when articles are written.

**All line counts under 250 lines.** Largest file is PageLayout.tsx at 208 lines.

---

### Manual Test Instructions

1. **Start dev server:** `npm run dev` from the project root
2. **Landing page (http://localhost:3000):** Verify the page looks identical to before refactoring:
   - Background gradient orbs (lavender top-right, coral bottom-left) with floating animation
   - Static header visible before scrolling, fixed header on scroll-up
   - Hero text with gradient "beautifully"
   - All 5 case study cards render correctly (Sprint, Research Tech, Animatix, Paid24/7, Ramp, Deep Work)
   - Spotlight2b animation and "Demo animation" button on Ramp card
   - Closing CTA section with black button
   - Dark mode toggle works
   - Mobile nav (hamburger menu) works on small screens
3. **About page (http://localhost:3000/about):** Verify the new narrative page:
   - Hero: Charlie photo (rotated), "I'm Charlie." headline, subtitle, LinkedIn/GitHub links, client logos
   - Testimonials: 3 testimonials (Bartosz, Szymon, Mike) in grid before Chapter 1
   - Chapter 1 "Now" (2024-2026): 6 cards alternating direction
     - Card 1: Sprint Docs with BrowserScreenshot
     - Card 2: UserTestingCard with video hover (play/pause/mute controls)
     - Card 3: Design Agents with code snippet visual
     - Card 4: Visual Motion Design Agents with dark code visual (reversed)
     - Card 5: Gift List App with BrowserScreenshot
     - Card 6: IFS App with BrowserScreenshot (reversed)
   - Email signup (Substack iframe) between Chapter 1 and 2
   - Chapter 2 "The Reset" (2023-2024): 3 cards with photos
   - Chapter 3 "Web3 Era" (2017-2023): 4 cards (Deep Work logo grid, yacht photo, Ramp screenshot, Nexus screenshot)
   - Chapter 4 "First Chapters" (pre-2017): 3 cards with photos
   - Soft CTA at bottom: "Currently taking select sprints"
   - Chapter dividers with horizontal lines and date ranges
   - All cards have hover lift animation and shadow transition
   - All links work (internal articles, external GitHub/Substack)
   - Dark mode works throughout
   - Mobile responsive (cards stack vertically, photos/screenshots adjust)
