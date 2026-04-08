# AI Slop Checklist

**Purpose:** A verification checklist for Agents 2 (Review) and 5 (Visual Verification) to catch generic AI-generated aesthetics. If someone would immediately recognize the UI as "AI-made," it needs redesign.

**Source:** Adapted from [Impeccable](https://github.com/pbakaus/impeccable) design quality system.

**Last Updated:** 2026-04-08

---

## The Core Test

> "Would someone immediately recognize this as AI-generated?"

Distinctive interfaces make people ask "how was this made?" — not which AI made it. Run through the checklist below before approving any implementation.

---

## Typography Tells

- [ ] **Overused fonts**: Using Inter, Roboto, or Open Sans without project-level justification. Consider alternatives: Plus Jakarta Sans, Figtree, Source Sans 3, or project-specific choices
- [ ] **Flat type scale**: Sizes too close together (14/15/16px). A good scale has meaningful jumps — readers should instantly feel the hierarchy
- [ ] **One weight everywhere**: No variation in font-weight across headings, body, labels, and captions

## Color Tells

- [ ] **Pure grays**: Using `gray-*` tokens without any warmth/tint. Tinted neutrals (add a tiny amount of brand hue) feel more intentional
- [ ] **Pure black backgrounds**: `#000000` in dark mode. Use 12-18% lightness instead (e.g., `#1a1a1a`, `#0f172a`)
- [ ] **Gray text on colored backgrounds**: Use a lighter/darker shade of the background color instead of generic gray
- [ ] **Too many accent colors**: Most apps work with one accent color. Multiple bright accents = visual noise
- [ ] **60-30-10 violation**: More than ~10% of the surface area using accent/highlight colors

## Layout Tells

- [ ] **Excessive card nesting**: Cards inside cards inside cards. Cards should only wrap truly distinct, separable content
- [ ] **Generic card grids**: Uniform bordered rectangles repeated in a grid without variation in size, emphasis, or visual weight
- [ ] **No spatial rhythm**: Random padding/margin values instead of a consistent scale (4, 8, 12, 16, 24, 32, 48, 64px)
- [ ] **No hierarchy**: All elements at the same visual prominence — nothing draws the eye first

## Decoration Tells

- [ ] **Gradient text**: Almost always looks cheap and dated
- [ ] **Glassmorphism**: Frosted glass effects rarely add function and scream "AI template"
- [ ] **Generic drop shadows**: Default `shadow-md` or `shadow-lg` without intention. Either use subtle, tight shadows or use borders
- [ ] **Decorative elements over function**: Fancy backgrounds, orbs, gradients that don't serve the content

## Interaction Tells

- [ ] **Generic button labels**: "OK", "Submit", "Yes/No". Use verb + object: "Save changes", "Delete 5 items", "Send report"
- [ ] **Modal overuse**: Dialogs for everything. Prefer inline editing, sheets, or undo patterns
- [ ] **Empty states say "No items"**: Should provide context + next action. "No reports yet — create your first report to get started"
- [ ] **Generic spinners**: Use skeleton screens that mirror the actual content layout instead
- [ ] **Placeholder-only form labels**: Labels must be distinct visible elements, not just placeholder text that disappears on focus

## Motion Tells

- [ ] **Bounce/elastic easing**: Almost always looks tacky and amateurish
- [ ] **`ease` timing function**: The CSS default `ease` is generic — use exponential curves (quart, quint, expo) for more character
- [ ] **Everything animates at once**: No staggering, no choreography
- [ ] **Missing `prefers-reduced-motion`**: Accessibility requirement, affects ~1/3 of older adults

---

## How to Use This Checklist

**Agent 2 (Review):** Scan the plan for elements that would trigger these tells. Flag them in review notes with suggested alternatives.

**Agent 5 (Visual Verification):** After capturing screenshots, run through this checklist visually. Any checked item should be fixed before approval. Add "AI Slop Score" to the quality assessment — count how many tells are present (0 = distinctive, 5+ = needs redesign).

**The "intentional" exception:** If a project's design system deliberately uses one of these patterns (e.g., Inter is the established font), that's fine — the point is intentional choice, not blanket prohibition.
