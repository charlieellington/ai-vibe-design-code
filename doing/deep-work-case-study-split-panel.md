# Deep Work Case Study — Split-Panel Article Layout

What this file does: Plan to convert the existing Deep Work case study at `/articles/deep-work-case-study` from a standard ArticleLayout to a simplified split-panel layout matching the Research Tech case study structure — fixed left panel with title/info, scrollable right panel with prose article content (no slide cards).

---

## Original Request

"Create/update a case study page for the deep work case study — `/articles/deep-work-case-study` — to match the layout in the research tech case study. However in a far simpler format... We should have some left hand side content with the title. Then the right hand side should be no content blocks and just the article content as it is — as if scrolling a normal article but the place is now on the right."

---

## Design Context

### Layout Pattern: Simplified Split-Panel

Reuses the Research Tech split-panel pattern but **simplified**:

| Aspect | Research Tech | Deep Work (This Task) |
|--------|--------------|----------------------|
| **Left panel** | Title, metrics, quote, team, live link, CTA | Title, key metrics, CTA (simpler) |
| **Right panel** | SlideCard components (image + text slides) | Prose article content — standard scrolling markdown |
| **Right panel wrapper** | `space-y-2` grid of `SlideCard` components | Single `Prose` container with article body |
| **Route** | `/case-studies/research-tech` | `/articles/deep-work-case-study` (unchanged) |
| **Full viewport overlay** | Yes (`fixed inset-0 z-50`) | Yes — same technique |
| **Mobile** | Sticky bottom bar + expandable drawer | Same pattern (simplified info) |

### Visual System (Same as Research Tech)

- **Background:** `bg-brand-cream text-brand-text`
- **Left panel width:** `lg:w-[380px]`
- **Typography:** Geist Mono for labels, serif for title
- **CTA:** `bg-brand-text` button with `hover:bg-brand-rose`
- **Borders:** `border-brand-shadow/30`

### Design References (for Agent 5 visual verification)

- **Primary reference:** Research Tech case study at `/case-studies/research-tech`
- **Key patterns:** Same fixed left panel + scrollable right panel layout
- **Visual inspiration:** Attio-style clean data layout with content as hero

---

## Codebase Context

### Current Implementation

The Deep Work case study currently lives at:
- **Route:** `src/app/articles/deep-work-case-study/page.mdx`
- **Layout:** Uses `ArticleLayout` component (standard centered prose)
- **Content:** ~153 lines of MDX with images, headings, blockquotes, case study sections

### Files to Reference

| File | Purpose |
|------|---------|
| `src/app/case-studies/research-tech/ResearchTechCaseStudy.tsx` | Split-panel layout template (lines 20-131) |
| `src/app/case-studies/research-tech/LeftPanel.tsx` | Left panel structure (lines 12-91) |
| `src/app/articles/deep-work-case-study/page.mdx` | Current article content to preserve |
| `src/components/Prose.tsx` | Prose wrapper for markdown content |
| `src/components/ArticleLayout.tsx` | Current layout (being replaced) |

### Component Rendering Chain

Current: `page.mdx` → `ArticleLayout` → `Container` → `Prose` → MDX content

New: `page.tsx` → `DeepWorkCaseStudy` → fixed left `LeftPanel` + scrollable right `ArticleContent` (Prose-wrapped)

### Existing Patterns to Reuse

1. **Split-panel overlay:** `fixed inset-0 z-50 flex flex-col lg:flex-row` from ResearchTechCaseStudy.tsx
2. **Left panel structure:** Back link, title, metrics, CTA from LeftPanel.tsx
3. **Mobile bottom bar:** Sticky bar + AnimatePresence drawer from ResearchTechCaseStudy.tsx
4. **Prose component:** `src/components/Prose.tsx` for article body styling

---

## Prototype Scope

- **Frontend only** — no backend changes
- **Content preserved** — all existing MDX article content transfers to JSX
- **Component reuse** — follows established split-panel pattern
- **No new dependencies** — uses existing framer-motion, Next.js Image, Prose

---

## Plan

### Step 1: Create the Deep Work Case Study component directory

Convert from MDX article to component-based page at the same route.

- **Create:** `src/app/articles/deep-work-case-study/DeepWorkCaseStudy.tsx`
  - Client component with `'use client'`
  - Same `fixed inset-0 z-50` overlay pattern as Research Tech
  - Desktop: `lg:flex-row` with fixed left panel + scrollable right
  - Mobile: top bar + sticky bottom bar + expandable drawer
  - Import `LeftPanel` and `ArticleContent`

### Step 2: Create the Left Panel

- **Create:** `src/app/articles/deep-work-case-study/LeftPanel.tsx`
  - **Simpler than Research Tech** — no team section, no live product link
  - Contents:
    - Back link (→ home)
    - Title: "Deep Work Studio" (`font-serif text-lg`)
    - Key metrics: "50+ projects · $800k peak revenue" and "38+ designers · 4 years" (`font-mono text-sm text-brand-text/70`)
    - Brief description line (optional)
    - CTA button: "2026 Availability →" (`bg-brand-text hover:bg-brand-rose`)
  - Same `w-full lg:w-[380px]` sizing
  - Same `flex h-full flex-col justify-between` structure

### Step 3: Create the Article Content component

- **Create:** `src/app/articles/deep-work-case-study/ArticleContent.tsx`
  - Client component wrapping the existing article content in `Prose`
  - Transfer ALL content from current `page.mdx` into JSX
  - Use `Next/Image` for all images (already used in MDX)
  - Wrap in a container with max-width for comfortable reading: `max-w-3xl mx-auto`
  - Add appropriate padding: `p-8 lg:p-12`
  - All MDX markdown converts to JSX elements:
    - `##` → `<h2>`
    - `###` → `<h3>`
    - `####` → `<h4>`
    - `**text**` → `<strong>`
    - Lists → `<ul>/<li>`
    - Links → `<Link>` or `<a>`
    - Images → `<Image>` (Next.js)
    - Blockquotes → `<blockquote>`
  - Preserve the callout box for the longer write-up link
  - Apply `prose dark:prose-invert` styling via Prose component

### Step 4: Update the page entry point

- **Modify:** `src/app/articles/deep-work-case-study/page.mdx` → rename to `page.tsx`
  - Replace MDX with component import
  - Keep metadata export for SEO
  - Render `<DeepWorkCaseStudy />`

```tsx
import { DeepWorkCaseStudy } from './DeepWorkCaseStudy'

export const metadata = {
  title: 'Deep Work Case Study: Building a Highly Profitable Design Consultancy in Web3\'s Golden Era',
  description: 'How we scaled from 2 founders to 38+ designers, completing 50+ projects with peak revenues of $800k annually',
}

export default function DeepWorkCaseStudyPage() {
  return <DeepWorkCaseStudy />
}
```

### Step 5: Verify and test

- Confirm route `/articles/deep-work-case-study` renders the split-panel layout
- Check desktop: left panel fixed, right article scrolls
- Check mobile: top bar, content scrolls, bottom bar with CTA, info drawer works
- Verify all images load correctly
- Verify all links work (internal and external)

---

## Key Implementation Notes

### Right Panel Differences from Research Tech

The right panel is NOT slide cards. It's a single scrollable article:

```tsx
{/* Right Panel — Scrollable article content */}
<main className="flex-1 overflow-y-auto">
  <ArticleContent />
</main>
```

Where `ArticleContent` wraps everything in:
```tsx
<div className="mx-auto max-w-3xl p-8 lg:p-12">
  <Prose>
    {/* All article content as JSX */}
  </Prose>
</div>
```

This gives the feel of reading a normal article, just positioned in the right panel.

### Content to Preserve from MDX

All content from the current `page.mdx` (lines 19-153):
- Hero image
- "The Opportunity" section
- Callout box linking to longer write-up
- Team collaboration image
- "Our Productized Approach" with 4 phases, each with a case study sub-section
- "Our Products" section
- "Scaling Impact" section
- "Working with Engineering-Dominant Teams" section
- "Results That Matter" section with 4 metric groups
- "The Key Lesson for Today's Market" section
- "Behind the Scenes" closing section

### Left Panel Content (Extracted from Article)

Key metrics to show:
- **50+ projects** completed
- **$800k** peak annual revenue
- **38+ designers** managed
- **4 years** (2019-2023)

---

## Stage

Planning

## Questions for Clarification

No clarification questions — the request is clear. Left panel with title/info, right panel with prose article content.

## Priority

Medium

## Created

2026-02-13

## Files

| Action | File |
|--------|------|
| Create | `src/app/articles/deep-work-case-study/DeepWorkCaseStudy.tsx` |
| Create | `src/app/articles/deep-work-case-study/LeftPanel.tsx` |
| Create | `src/app/articles/deep-work-case-study/ArticleContent.tsx` |
| Delete | `src/app/articles/deep-work-case-study/page.mdx` |
| Create | `src/app/articles/deep-work-case-study/page.tsx` |
