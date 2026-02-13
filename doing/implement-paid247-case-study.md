# Implement Paid24/7 Case Study — Split-Panel Layout

What this file does: Complete implementation plan for the Paid24/7 case study page using the same split-panel layout as Research Tech (fixed left + scrollable right), adapted for a mobile FinTech product with phone frame screenshots. Refined via design-0-refine (4-perspective UX analysis: Claude UX + Claude Simplicity + Gemini UX + Gemini Simplicity).

---

## Original Request

"Create a case study for Paid24/7 at `/case-studies/paid247` in the same style as `/case-studies/research-tech`, using the content plan from `case-study-paid247-content-plan.md` and following the principles from `case-study-recommendations.md` and `case-study-best-practices`. The case study should reuse the existing split-panel layout components (SlideCard, PhoneFrame, BrowserFrame) from the Research Tech implementation. Remove parts that can't be done — like team profile images — since we don't have them for this client."

**Content sources:**
- `case-study-rt-planning/case-study-paid247-content-plan.md` — Content plan with slide sequence, text, and reasoning
- `case-study-rt-planning/case-study-recommendations.md` — 8 conversion principles
- `case-study-rt-planning/workings/case-study-best-practices/case-study-best-practices-06-summary.md` — Template and Logic Library

---

## Design Context

### Reusing the Research Tech Pattern

The Paid24/7 case study uses the SAME visual system as Research Tech:
- **Layout:** Fixed left panel + scrollable right panel with slide cards
- **Components:** SlideCard, PhoneFrame (reused from existing)
- **Branding:** Same warm cream, Geist Mono/Sans/Fraunces typography
- **Animations:** Same Framer Motion scroll-triggered entrance

### Key Visual Differences from Research Tech

| Aspect | Research Tech | Paid24/7 |
|--------|--------------|----------|
| **Screenshot frames** | BrowserFrame (desktop SPA) | PhoneFrame (mobile FinTech app) |
| **Number of slides** | 13 (12 original + 1 dual added) | 8 (1 dual-phone hero + 2 single phone + 5 text) |
| **Team section** | TeamCircles with 5 profile photos | REMOVED — no profile images available |
| **Client quote** | Confirmed ("I'm amazed. Unbelievable.") | Awaiting from Philipp — no placeholder shown |
| **Live product link** | Public shipped product | Developer handover demo |
| **Dual-image slides** | 3 (desktop+mobile combos) | 1 (dual-phone hero) |

### Typography System (Same as Research Tech)

From `Slides.tsx`:
```
eyebrow: 'font-mono text-xs uppercase tracking-[0.2em] text-brand-text/40'
headline: 'font-serif text-3xl tracking-tight leading-[1.1] text-brand-text lg:text-4xl'
body: 'text-lg leading-relaxed text-brand-text/50'
```

---

## Codebase Context

### Existing Components to Reuse

**Already built for Research Tech — reuse directly:**

1. **`src/components/case-studies/SlideCard.tsx`** — Card wrapper with scroll-triggered animation
   - Uses Framer Motion `whileInView` with spring animation
   - `w-full overflow-hidden rounded-xl` + custom className
   - No changes needed

2. **`src/components/case-studies/PhoneFrame.tsx`** — Phone mockup wrapper (dark bezel + notch)
   - NOT used for Paid247 — its dark bezel (`border-[6px] border-zinc-800`) is too heavy for phone screenshots
   - Instead, slides use inline phone-like styling: `rounded-[2rem] ring-1 ring-black/5` (lighter, cleaner look)
   - See slide JSX below for the exact approach

3. **`src/components/case-studies/BrowserFrame.tsx`** — Browser chrome mockup
   - Not needed for Paid247 (mobile app, not desktop)

### Existing Case Study Page to Model

**`src/app/case-studies/research-tech/`** — Complete reference:
- `page.tsx` — Server component with metadata
- `ResearchTechCaseStudy.tsx` — Client component with split-panel layout
- `LeftPanel.tsx` — Fixed side panel
- `Slides.tsx` — Right panel slide cards
- `TeamCircles.tsx` — NOT needed for Paid247

### Route

- **Route:** `/case-studies/paid247`
- **Directory:** `src/app/case-studies/paid247/`
- **Pattern:** Same as Research Tech

### Key Technical Details

- **Framework:** Next.js 15 App Router
- **Layout override:** Uses `fixed inset-0 z-50` overlay (same as Research Tech) to bypass site Header/Footer
- **Fraunces font:** Import per-component via `next/font/google` (same pattern as Research Tech)
- **Brand tokens:** All in `src/styles/tailwind.css`

---

## Screenshot Strategy

### The Problem

Current screenshots (`public/images/paid247-*.png`) are developer handover documentation pages — phone mockup WITH spec notes, headings, and bullet points alongside. These need to be cropped or re-captured for the case study.

### The Solution

**Option A (Recommended): Crop existing screenshots to phone UI only**
- Use image editing to extract just the phone mockup from each documentation screenshot
- Save cropped versions to `public/images/case-studies/paid247/`

**Option B: Re-capture from handover site**
- Visit `paid247-design.vercel.app` at mobile viewport (375px)
- Take clean screenshots of each screen
- Requires the handover site to be functional and current

### Screenshot File Plan

| Slide | Source | Cropped File | What It Shows |
|-------|--------|-------------|---------------|
| 1 (Dual Hero — left) | `paid247-completion-card.png` | `slide-1-hero.png` | Multi-currency account complete + card activation |
| 1 (Dual Hero — right) | `paid247-country-specific.png` | `slide-2-hero.png` | Country detection with feature benefits |
| 4 | `paid247-updated-onboard.png` | `slide-4-onboarding.png` | Location permission with clear benefits |
| 6 | `paid247-ton-accounts.png` | `slide-6-ton.png` | USDT account connected + CHF setup |

**Action required:** Screenshots need to be cropped/prepared BEFORE implementation. The plan assumes clean phone-only images will exist at `public/images/case-studies/paid247/`.

**Fallback:** If clean screenshots aren't available, use the full documentation screenshots with larger padding in the SlideCard to compensate for the surrounding spec text. This is not ideal but functional.

---

## Plan

### Step 1: Create Route and Page Shell

**Files to create:**
- `src/app/case-studies/paid247/page.tsx`
- `src/app/case-studies/paid247/Paid247CaseStudy.tsx`
- `src/app/case-studies/paid247/LeftPanel.tsx`
- `src/app/case-studies/paid247/Slides.tsx`

**`page.tsx`** — Server component:
```typescript
import { Paid247CaseStudy } from './Paid247CaseStudy'

export const metadata = {
  title: 'Paid24/7 Case Study — Zebra Design',
  description: 'From broken onboarding to production-ready React code. Design sprint + UX sprint for a FinTech startup building WeChat Pay for Telegram.',
}

export default function Paid247CaseStudyPage() {
  return <Paid247CaseStudy />
}
```

**`Paid247CaseStudy.tsx`** — Client component (adapted from `ResearchTechCaseStudy.tsx`):
```tsx
'use client'

import { useState } from 'react'
import Link from 'next/link'
import Image from 'next/image'
import { motion, AnimatePresence } from 'framer-motion'
import avatarImage from '@/images/avatar.png'
import { LeftPanel } from './LeftPanel'
import { Slides } from './Slides'

export function Paid247CaseStudy() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  return (
    <div className="fixed inset-0 z-50 flex flex-col bg-brand-cream text-brand-text lg:flex-row">
      {/* Desktop: Left Panel (hidden on mobile) */}
      <div className="hidden h-full lg:block">
        <LeftPanel />
      </div>

      {/* Mobile: Top bar with back nav */}
      <div className="flex items-center justify-between border-b border-brand-shadow/30 px-4 py-3 lg:hidden">
        <Link
          href="/"
          className="flex items-center gap-2 font-mono text-sm text-brand-text/70 hover:text-brand-text transition-colors"
        >
          <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
          </svg>
          Back
        </Link>
        <span className="font-mono text-sm font-bold">Paid24/7</span>
        <div className="w-12" />
      </div>

      {/* Right Panel — Scrollable slides */}
      <main className="flex-1 overflow-y-auto px-2 py-2 lg:py-2 lg:pr-2 lg:pl-2 lg:pb-2">
        <Slides />
      </main>

      {/* Mobile: Sticky bottom bar with CTA */}
      <div className="flex items-center justify-between border-t border-brand-shadow/30 bg-white/80 px-4 py-3 backdrop-blur-sm lg:hidden">
        <div className="flex items-center gap-3">
          <div className="relative h-8 w-8 overflow-hidden rounded-full">
            <Image src={avatarImage} alt="Charlie Ellington" fill sizes="32px" className="object-cover" />
          </div>
          <div>
            <p className="font-mono text-xs font-bold text-brand-text">Paid24/7</p>
            <p className="font-mono text-xs text-brand-text/60">Sprint · React code</p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="rounded-md border border-brand-shadow/50 px-3 py-1.5 font-mono text-xs text-brand-text transition-colors hover:bg-warm-100"
          >
            Info
          </button>
          <Link
            href="https://sprint.zebradesign.io/"
            className="bg-brand-text px-4 py-1.5 font-mono text-xs font-medium text-white transition-colors hover:bg-brand-rose"
            style={{ borderRadius: '4px' }}
          >
            2026 Availability
          </Link>
        </div>
      </div>

      {/* Mobile: Expandable info panel */}
      <AnimatePresence>
        {mobileMenuOpen && (
          <>
            <motion.div
              className="fixed inset-0 z-40 bg-black/20 backdrop-blur-xs lg:hidden"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setMobileMenuOpen(false)}
            />
            <motion.div
              className="fixed inset-x-0 bottom-0 z-50 max-h-[70vh] overflow-y-auto rounded-t-2xl bg-white shadow-2xl lg:hidden"
              initial={{ y: '100%' }}
              animate={{ y: 0 }}
              exit={{ y: '100%' }}
              transition={{ type: 'spring', stiffness: 300, damping: 30 }}
            >
              <div className="p-2 text-center">
                <div className="mx-auto h-1 w-10 rounded-full bg-zinc-300" />
              </div>
              <LeftPanel />
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  )
}
```

### Step 2: Build the Left Panel

**`LeftPanel.tsx`** — Following Research Tech format but WITHOUT team section and WITHOUT quote placeholder:

```
Paid24/7                              ← font-serif text-lg
FinTech Payments · Telegram           ← font-mono text-sm text-brand-text/70
Design Sprint + UX Sprint             ← font-mono text-sm text-brand-text/70

[KEY METRIC LINE — see note below]    ← text-base text-brand-text (promoted to quote position)

→ View the developer handover         ← font-mono text-sm, link to paid247-design.vercel.app

[ 2026 Availability → ]               ← bg-brand-text text-white, hover:bg-brand-rose
```

```tsx
'use client'

import Link from 'next/link'

export function LeftPanel() {
  return (
    <aside className="flex h-full w-full flex-shrink-0 flex-col justify-between overflow-y-auto p-8 lg:w-[380px] lg:p-10">
      {/* Top section: Project info */}
      <div>
        {/* Back navigation */}
        <Link
          href="/"
          className="mb-4 flex items-center gap-2 font-mono text-sm text-brand-text/70 hover:text-brand-text transition-colors"
        >
          <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
          </svg>
          Back
        </Link>

        {/* Project name */}
        <h1 className="font-serif text-lg">Paid24/7</h1>

        {/* Key metrics */}
        <div className="mt-2 space-y-0.5 font-mono text-sm text-brand-text/70">
          <p>FinTech Payments · Telegram</p>
          <p>Design Sprint + UX Sprint</p>
        </div>

        <div className="mt-6" />

        {/* Key metric — promoted to quote position */}
        <p className="text-base text-brand-text">
          [KEY METRIC — needs verified copy from source content]
        </p>

        <div className="mt-6" />

        {/* Handover link */}
        <Link
          href="https://paid247-design.vercel.app"
          target="_blank"
          rel="noopener noreferrer"
          className="font-mono text-sm text-brand-text hover:text-brand-rose transition-colors"
        >
          → View the developer handover
        </Link>
      </div>

      {/* Bottom section: CTAs */}
      <div className="mt-10 space-y-4">
        <Link
          href="https://sprint.zebradesign.io/"
          className="flex w-full items-center justify-center gap-2 bg-brand-text px-6 py-3 font-mono text-sm font-medium text-white transition-colors hover:bg-brand-rose"
          style={{ borderRadius: '4px' }}
        >
          2026 Availability →
        </Link>
      </div>
    </aside>
  )
}
```

**Differences from Research Tech LeftPanel:**
- NO `<TeamSection />` — removed (no profile images available)
- NO quote placeholder — removed per UX refinement (all 4 perspectives agreed a placeholder signals "unfinished" and hurts trust). When Philipp provides a quote, add it back in the quote position.
- Key metric PROMOTED to the quote position — needs verified copy from the actual user testing data (the "50%" figure was fabricated in a draft rewrite and shouldn't be used)
- "FinTech Payments · Telegram" added as domain context — so the prospect knows the industry BEFORE scrolling (addresses Gemini UX feedback about the "buried lead")
- Link goes to handover demo, not a public shipped product

### Step 3: Build the 8 Slides (Right Panel)

**`Slides.tsx`** — Following Research Tech Slides format. Refined from 9 to 8 slides by merging the two hero screenshots into a dual-phone composition (addresses visual monotony feedback from all Gemini perspectives).

```typescript
const IMG = '/images/case-studies/paid247'

// Reuse same typography classes from Research Tech
const eyebrow = 'font-mono text-xs uppercase tracking-[0.2em] text-brand-text/40'
const headline = 'font-serif text-3xl tracking-tight leading-[1.1] text-brand-text lg:text-4xl'
const body = 'text-lg leading-relaxed text-brand-text/50'
const screenshotImg = 'w-full rounded ring-1 ring-black/5'
```

#### Slide 1: DUAL HERO — Account Complete + Country Detection
```tsx
{/* Two phones side by side — creates visual density and avoids "lonely phone" problem */}
<SlideCard className="flex items-end justify-center gap-6 bg-white p-16 lg:gap-8 lg:p-20">
  <div className="w-[42%] max-w-[240px]">
    <Image
      src={`${IMG}/slide-1-hero.png`}
      alt="Multi-currency account setup complete — CHF and USD balances with debit card activation"
      width={400}
      height={800}
      className="w-full rounded-[2rem] ring-1 ring-black/5"
      priority
    />
  </div>
  <div className="w-[42%] max-w-[240px]">
    <Image
      src={`${IMG}/slide-2-hero.png`}
      alt="Country detection — Switzerland detected with feature benefits and identity check"
      width={400}
      height={800}
      className="w-full rounded-[2rem] ring-1 ring-black/5"
      priority
    />
  </div>
</SlideCard>
```

**Why dual-phone composition (UX refinement):**
- Single phone screenshots in a wide card create too much whitespace (Gemini UX: "floating in negative space")
- Two phones side-by-side creates visual density similar to Research Tech's dual-image slides (6b, 8, 10)
- Shows range: the END RESULT (account complete) AND the JOURNEY (country detection) in one visual
- `items-end` aligns bottoms so both phones look grounded together

#### Slide 2: CONTEXT (Text)
```tsx
<SlideCard className="flex min-h-[420px] flex-col items-start justify-center bg-white p-10 lg:min-h-[500px] lg:p-16">
  <span className={eyebrow}>The challenge</span>
  <h2 className={`mt-6 max-w-lg ${headline}`}>
    Pre-seed FinTech startup.
    <br />
    &ldquo;WeChat Pay for Telegram.&rdquo;
    <br />
    <span className="text-brand-text/40">
      Users couldn&apos;t complete onboarding.
    </span>
  </h2>
  <p className={`mt-6 max-w-md ${body}`}>
    Virtual cards, IBAN integration, and blockchain — before a single real user.
  </p>
</SlideCard>
```

#### Slide 3: INSIGHT (Text) — THE Converting Slide
```tsx
<SlideCard className="flex min-h-[420px] flex-col items-start justify-center bg-white p-10 lg:min-h-[500px] lg:p-16">
  <span className={eyebrow}>The insight</span>
  <h2 className={`mt-6 max-w-lg ${headline}`}>
    &ldquo;I only want one button...
    <br />
    there&apos;s too much to read.&rdquo;
  </h2>
  <p className={`mt-6 max-w-md ${body}`}>
    That user feedback reshaped the entire product.
  </p>
</SlideCard>
```

**Preserved as separate slide from Context (rejecting Gemini Maeda's merge suggestion):** Context and Insight serve different psychological functions. Context creates identification ("that's me"). Insight creates the "I might be making that mistake" trigger. Merging them dilutes both. The Research Tech case study keeps these separate too — it's the proven pattern.

#### Slide 4: SCREENSHOT — Updated Onboarding
```tsx
<SlideCard className="bg-white p-16 lg:p-20">
  <Image
    src={`${IMG}/slide-4-onboarding.png`}
    alt="Simplified onboarding — location permission with clear benefit messaging and progressive disclosure"
    width={400}
    height={800}
    className="mx-auto max-w-[280px] rounded-[2rem] ring-1 ring-black/5"
  />
</SlideCard>
```

**Note:** Single phone screenshot IS fine here — it's the SOLUTION to the problem just described. The prospect naturally focuses on it because they want to see the fix.

#### Slide 5: VALIDATION (Text)
```tsx
<SlideCard className="flex min-h-[420px] flex-col items-start justify-center bg-white p-10 lg:min-h-[500px] lg:p-16">
  <span className={eyebrow}>Validation</span>
  <h2 className={`mt-6 max-w-lg ${headline}`}>
    User testing caught the problem before launch.
  </h2>
  <p className={`mt-6 max-w-md ${body}`}>
    6 sessions. Zero guesswork.
  </p>
</SlideCard>
```

#### Slide 6: SCREENSHOT — TON Accounts
```tsx
<SlideCard className="bg-white p-16 lg:p-20">
  <Image
    src={`${IMG}/slide-6-ton.png`}
    alt="USDT account connected via TON blockchain — crypto complexity hidden behind familiar banking interface"
    width={400}
    height={800}
    className="mx-auto max-w-[280px] rounded-[2rem] ring-1 ring-black/5"
  />
</SlideCard>
```

**Kept (rejecting Gemini Maeda's cut suggestion):** For a FinTech audience, showing blockchain complexity mastered IS part of the transformation story. Removing it weakens the domain expertise signal. The case study audience is FinTech founders — they need to see this.

#### Slide 7: SPEED (Text)
```tsx
<SlideCard className="flex min-h-[420px] flex-col items-start justify-center bg-white p-10 lg:min-h-[500px] lg:p-16">
  <span className={eyebrow}>The output</span>
  <h2 className={`mt-6 max-w-lg ${headline}`}>
    Design sprint to production React code
    <br />
    in 3 weeks.
  </h2>
  <p className={`mt-6 max-w-md ${body}`}>
    No Figma. No handoff gap. The client came back twice.
  </p>
</SlideCard>
```

#### Slide 8: EVIDENCE + HANDOVER LINK
```tsx
<SlideCard className="flex min-h-[420px] flex-col items-start justify-center bg-white p-10 lg:min-h-[500px] lg:p-16">
  <span className={eyebrow}>Evidence</span>
  <h2 className={`mt-6 max-w-lg ${headline}`}>
    See the developer handover.
  </h2>
  <p className={`mt-4 max-w-md ${body}`}>
    Explore the actual delivered onboarding flows and components.
  </p>
  <Link
    href="https://paid247-design.vercel.app"
    target="_blank"
    rel="noopener noreferrer"
    className="mt-8 inline-flex items-center gap-2 rounded bg-brand-text px-6 py-3 font-mono text-sm font-medium text-white transition-colors hover:bg-brand-rose"
  >
    → View developer handover
  </Link>
</SlideCard>
```

**Kept (rejecting Gemini Maeda's redundancy argument):** Yes, the handover link is also in the left panel. But slide 8 serves a different function — it's the "reward" for scrolling to the bottom, the same pattern as Research Tech's slide 11. Removing it makes the scroll end abruptly after the speed card.

### Step 4: Mobile Responsive Layout

Same pattern as Research Tech:

**Mobile top bar:**
- Back link (← Back) + "Paid24/7" title centred

**Mobile sticky bottom bar:**
- Avatar (Charlie's) + "Paid24/7" + "Sprint · React code"
- "Info" button (expands left panel as bottom sheet)
- "Book a Sprint" primary CTA

**Mobile expandable info panel:**
- AnimatePresence bottom sheet with LeftPanel content
- Same spring animation as Research Tech

### Step 5: Screenshot Preparation

**Create directory and prepare images:**
```bash
mkdir -p public/images/case-studies/paid247
```

**Crop source images** (manual step or use Playwright to capture from handover site):
- `paid247-completion-card.png` → crop phone UI → `slide-1-hero.png`
- `paid247-country-specific.png` → crop phone UI → `slide-2-hero.png`
- `paid247-updated-onboard.png` → crop phone UI → `slide-4-onboarding.png`
- `paid247-ton-accounts.png` → crop phone UI → `slide-6-ton.png`

### Step 6: SEO Metadata

```typescript
export const metadata = {
  title: 'Paid24/7 Case Study — Zebra Design',
  description: 'From broken onboarding to production-ready React code. Design sprint + UX sprint for a FinTech startup building WeChat Pay for Telegram.',
}
```

### Step 7: Future — Add Client Quote (When Available)

When Philipp provides a quote, add Slide 10:
```tsx
{/* 10. CLOSING QUOTE — Add when Philipp provides */}
<SlideCard className="flex min-h-[420px] flex-col items-start justify-center bg-white p-10 lg:min-h-[500px] lg:p-16">
  <blockquote className="font-mono max-w-lg text-2xl font-bold leading-snug text-brand-text lg:text-3xl">
    &ldquo;[Philipp's quote here]&rdquo;
  </blockquote>
  <p className="mt-8 font-mono text-xs text-brand-text/40">
    — Philipp [Surname], Founder, Paid24/7
  </p>
</SlideCard>
```

And update LeftPanel quote from placeholder to actual quote.

---

## File Structure

```
src/app/case-studies/
  paid247/
    page.tsx                    # Server component — metadata + renders Paid247CaseStudy
    Paid247CaseStudy.tsx        # Client component — split-panel layout (same as ResearchTechCaseStudy.tsx)
    LeftPanel.tsx               # Fixed side panel — no TeamCircles, no quote placeholder
    Slides.tsx                  # 8 slide cards (1 dual-phone + 2 single phone + 5 text)

public/images/case-studies/paid247/
    slide-1-hero.png            # Slide 1 left — Account Complete (cropped from paid247-completion-card.png)
    slide-2-hero.png            # Slide 1 right — Country Detection (cropped from paid247-country-specific.png)
    slide-4-onboarding.png      # Slide 4 — Updated Onboarding (cropped from paid247-updated-onboard.png)
    slide-6-ton.png             # Slide 6 — TON Accounts (cropped from paid247-ton-accounts.png)
```

**Reused components (no changes needed):**
```
src/components/case-studies/
    SlideCard.tsx               # ✅ Reuse as-is
    PhoneFrame.tsx              # ✅ Available if needed (may use inline styling instead)
    BrowserFrame.tsx            # ❌ Not needed for mobile app
```

---

## Component Sources

- **Reused**: SlideCard (case-studies)
- **Framework**: Next.js Image, Link
- **Animation**: Framer Motion (AnimatePresence, motion)
- **No new dependencies required**

---

## Acceptance Criteria

- [ ] Page renders at `/case-studies/paid247`
- [ ] Split-panel layout: fixed left panel + scrollable right panel (desktop)
- [ ] Mobile: top bar + scrollable slides + sticky bottom bar + expandable info panel
- [ ] 8 slides render with scroll-triggered animations (1 dual-phone hero + 2 single phone + 5 text)
- [ ] Phone screenshots display cleanly in rounded phone-style frames
- [ ] Text slides match Research Tech typography (eyebrow + headline + body)
- [ ] Left panel shows project info, domain context, key metric (verified), deliverables, handover link, CTA (no quote placeholder)
- [ ] No TeamCircles / profile images (removed)
- [ ] "Book a Sprint" CTA links to sprint.zebradesign.io
- [ ] Handover link opens paid247-design.vercel.app in new tab
- [ ] Back link returns to home page
- [ ] No console errors
- [ ] Visual style matches Research Tech case study

---

## Stage
Planning — Ready for Review

## Priority
High

## Created
2026-02-13

## Files
- `src/app/case-studies/paid247/page.tsx` (NEW)
- `src/app/case-studies/paid247/Paid247CaseStudy.tsx` (NEW)
- `src/app/case-studies/paid247/LeftPanel.tsx` (NEW)
- `src/app/case-studies/paid247/Slides.tsx` (NEW)
- `public/images/case-studies/paid247/` (NEW directory — cropped screenshots)

---

## UX Refinement Analysis (design-0-refine)

### 4-Perspective Synthesis

| Perspective | Rating | Key Feedback |
|-------------|--------|-------------|
| Claude UX | 7/10 | Quote placeholder hurts trust. Single phone screenshots risk visual monotony in wide cards. |
| Claude Simplicity | 7/10 | 9 slides acceptable but two heroes feel repetitive. Domain context ("FinTech Payments") should be visible immediately. |
| Gemini UX Designer | 7.5/10 | "Floating in negative space" for single phone screenshots. Quote placeholder is "actively harmful". Buried lead — domain not clear until slide 3. |
| Gemini Maeda Simplicity | 6/10 | Cut to 5 slides. Merge context + insight. Remove TON screenshot. Remove evidence link (redundant with left panel). |

### What All 4 Agreed On (Applied)
1. **Remove quote placeholder** — signals "unfinished" and hurts trust. Promoted a key metric to the quote position instead (needs verified copy — the "50%" figure was fabricated).
2. **Add domain context** — "FinTech Payments · Telegram" added to left panel so prospects know the industry immediately.

### What 3/4 Agreed On (Applied)
3. **Merge dual heroes** — two separate hero slides with single phone screenshots create visual monotony. Combined into one dual-phone side-by-side composition (9 → 8 slides).

### What Was Rejected (With Reasoning)
- **Cut to 5 slides** (Gemini Maeda) — Too aggressive. Loses domain expertise signals and the evidence reward for scrolling. Research Tech has 13 slides; 8 is already leaner.
- **Merge context + insight** (Gemini Maeda) — These serve different psychological functions. Context = identification ("that's me"). Insight = trigger ("I might be making that mistake"). Research Tech keeps them separate.
- **Remove TON screenshot** (Gemini Maeda) — For FinTech audience, showing blockchain complexity mastered IS the domain expertise signal. Removing weakens the case study's relevance.
- **Remove evidence slide** (Gemini Maeda) — The handover link in the left panel and the evidence slide serve different functions. The slide is the scroll-completion reward. Research Tech has the same pattern (slide 11).
