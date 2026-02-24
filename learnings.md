# Design Agents Learnings Library

A categorized reference of patterns, debugging techniques, and lessons learned from previous implementations. Agents should consult relevant sections before implementation.

**How to Use**: Search for keywords related to your current task. Check relevant categories before writing code.

**Last Updated**: 2026-01-30 (Unified table — Discriminated Union for Multi-Type Tables, 4-Perspective UX Refinement Pipeline)

---

## Agent Relevance Index

Which categories each agent should prioritize:

| Agent | Primary Categories | Secondary Categories |
|-------|-------------------|---------------------|
| **Agent 1 (Planning)** | Workflow & Process, Interactions & UX | Layout & Positioning, Drag & Drop |
| **Agent 2 (Review)** | All categories | Validation checkpoint - review all |
| **Agent 3 (Discovery)** | Component Patterns, Data & APIs | CSS & Styling, TypeScript Patterns |
| **Agent 4 (Execution)** | CSS & Styling, React Patterns | Component Patterns, Layout & Positioning |
| **Agent 5 (Verification)** | Layout & Positioning, CSS & Styling | Animations, Component Patterns |
| **Agent 6 (Complete)** | Workflow & Process, Success Patterns | All categories (for learning capture) |
| **Agent 7 (Quick Fix)** | All categories | Rapid iteration - check relevant |
| **Agent 8 (Animation)** | Animations, motion-patterns.md | Component Patterns, React Patterns |

---

## Table of Contents

1. [Workflow & Process](#workflow--process)
2. [CSS & Styling](#css--styling)
3. [React Patterns](#react-patterns)
4. [Drag & Drop](#drag--drop)
5. [Interactions & UX](#interactions--ux)
6. [Layout & Positioning](#layout--positioning)
7. [Animations](#animations)
8. [Data & APIs](#data--apis)
9. [Component Patterns](#component-patterns)
10. [TypeScript Patterns](#typescript-patterns)
11. [Success Patterns](#success-patterns)

---

## Workflow & Process

### Critical Workflow Compliance
**Added**: 2025-01-04
**Context**: Tasks left in wrong Kanban column after implementation
**Problem**: Agent 4 failed to move tasks to Testing section
**Solution**: Mandatory status.md update with task movement verification
**Prevention**: Always move task from "Ready to Execute" → "Testing" before declaring complete

### Testing Section Movement Enforcement
**Added**: 2025-01-04
**Problem**: Agent 4 consistently fails to update Kanban board
**Enforcement**:
1. Move task to "## Testing" in status.md
2. Update Stage to "Ready for Manual Testing" in task file
3. Add implementation notes and manual test instructions
4. User WILL ask "Did you move this to the testing column?" - Answer must be YES

### Image Rendering Validation Requirements
**Added**: 2025-01-04
**Context**: Components implemented but images failed to render
**Problem**: No visual validation after code completion
**Prevention**:
1. After implementing UI components, verify they render correctly in browser
2. Test image loading approach (Next.js Image vs regular img) with actual files
3. When combining aspect-ratio with height constraints, validate no conflicts

### Complete Requirement Implementation
**Added**: 2025-10-01
**Context**: Agent skipped RECOMMENDED features, implementing only basic version
**Solution**: When requirements mark something as RECOMMENDED or PRIMARY, implement it immediately

### Unrelated File Modification Prevention
**Added**: 2025-01-04
**Context**: Accidentally modified unrelated files causing compilation errors
**Prevention**:
1. Verify file directly supports the feature
2. Check import dependencies
3. Confirm no accidental changes to unrelated files

### Debug UI Cleanup Strategy
**Added**: 2025-01-09
**Problem**: Debug elements left in production state
**Solution**: Implement debug elements as easily removable

```typescript
const DEBUG = false; // Single flag to control all debug output

{DEBUG && (
  <div className="fixed top-4 right-4 bg-red-500 text-white p-2">
    Debug info here
  </div>
)}
```

### UX Validation Before Task Completion
**Added**: 2025-01-13
**Context**: Interactive features technically correct but visually broken
**Prevention**: Add mandatory UX validation for drag/drop, animations, interactive features
- Visual State Changes: Verify user can see when interactions start/end
- Feedback Systems: Ensure users get visual confirmation
- Professional Polish: Validate smooth transitions

### AI Studio MCP for Visual/UI Tasks (Replaces gemini-chat)
**Added**: 2025-12-27
**Context**: A reference project discovered AI Studio MCP is far superior for visual work
**Problem**: Single-image prompts with `mcp__gemini__gemini-chat` produce generic, inconsistent code
**Solution**: Use `mcp__aistudio__generate_content` with multi-image context (5-10 reference files)
**Prevention**:
1. Task Classification is MANDATORY before implementation
2. Visual/UI tasks MUST use `mcp__aistudio__generate_content`
3. Include BOTH screenshots AND code files for pattern matching
4. 5-10 reference files produces dramatically better results than 1-2

**Example**:
```typescript
// ❌ Wrong - single prompt, no context
mcp__gemini__gemini-chat({
  message: "Generate a React component for a card...",
})

// ✅ Correct - multi-image context with code files
mcp__aistudio__generate_content({
  user_prompt: "Generate a React + Tailwind card component matching our design system...",
  files: [
    { path: "src/components/ui/Card.tsx" },        // Existing code patterns
    { path: "src/components/ui/Button.tsx" },      // More code context
    { path: "screenshots/existing-card.png" },     // Visual reference
    { path: "docs/design-system.md" },             // Brand guidelines
  ],
  model: "gemini-3.1-pro-preview"  // Default model - check tool schema for current options
})
```

### Visual Verification: Screenshot After Every Significant Change
**Added**: 2025-12-27
**Context**: A reference project - AI comparison caught drift that manual review missed
**Problem**: Code changes accumulate without visual verification, leading to design drift
**Solution**: Capture screenshots via Playwright after every significant UI change
**Prevention**:
1. After implementing UI changes, capture screenshot immediately
2. Use AI comparison to check against design direction
3. Maximum 3 iterations before escalating to human review

**Example**:
```typescript
// Capture after implementation
mcp__playwright__browser_navigate({ url: "http://localhost:[port]/page" })
mcp__playwright__browser_resize({ width: 430, height: 932 })
mcp__playwright__browser_take_screenshot({ filename: "implementation-v1.png" })

// AI verification
mcp__aistudio__generate_content({
  user_prompt: "Compare implementation against design direction. Rate: MATCHES / MINOR_DIFFERENCES / MAJOR_DIFFERENCES",
  files: [
    { path: "screenshots/implementation-v1.png" },
    { path: "reference/design-direction.png" },
  ],
  model: "gemini-3.1-pro-preview"  // Default model - check tool schema for current options
})
```

### Consistency Check for Multi-Screen Features
**Added**: 2025-12-27
**Context**: A reference project had multiple screens that needed identical styling
**Problem**: Same elements styled differently across screens, breaking visual consistency
**Solution**: Create UI element matrix checking consistency across all screens
**Prevention**:
1. Before completing multi-screen features, list all shared elements
2. Compare exact styling across all screens
3. Fix inconsistencies before marking complete

**Example**:
```markdown
| Element | Screen 1 | Screen 2 | Screen 3 | Consistent? |
|---------|----------|----------|----------|-------------|
| Button labels | "Save" | "Save" | "Continue" | ❌ Fix |
| Icon usage | Lucide Check | Lucide Check | Lucide Check | ✅ |
| Typography | text-lg font-semibold | text-lg font-semibold | text-lg font-semibold | ✅ |
| Colors | bg-primary | bg-primary | bg-green-500 | ❌ Fix |
```

### Prototype Specification Precision
**Added**: 2025-01-05
**Context**: User had to clarify wanting exactly 4 character images for prototype
**Problem**: Planning didn't specify exact prototype behavior and data requirements
**Solution**: For prototypes, always specify exact counts, data sets, and fallback behavior
**Prevention**: Include prototype data specifications in plan with specific examples
- Exact counts: "Display exactly 4 character images" not "display character versions"
- Data source mapping: How demo data maps to display
- Fallback behavior: What happens if data source has fewer items than UI expects

### User Feedback Iteration Patterns
**Added**: 2025-01-04
**Context**: Moodboard scroll fix required multiple user corrections
**Problem**: Planning stage missed user guidance indicating CSS-only solutions insufficient
**Solution**: Include user technical preference analysis - when users specify implementation approaches, prioritize those in initial plan
**Prevention**: Parse user technical preferences to select appropriate implementation approach during planning

### Architectural Decision Anticipation
**Added**: 2025-09-03
**Context**: Story Versions task revealed hierarchical vs flat structure wasn't considered
**Problem**: User discovered nested hierarchy issue after implementation, requiring architectural pivot
**Solution**: For features involving data relationships, explicitly consider architectural patterns upfront
**Prevention**: Include architectural decision questions in planning phase:
- "Should this create a nested hierarchy or flat structure?"
- "How should users navigate between related items?"
- "What context should be preserved when switching between items?"

### CSS Scope Clarification Requirements
**Added**: 2025-10-02
**Context**: Site-Wide Focus Hover Effect task had ambiguous scope
**Problem**: User expected entire page content to dim, plan only targeted interactive elements
**Solution**: Always clarify exact scope when dealing with broad terms like "everything" or "all content"
**Prevention**: When requirements use broad terms, enumerate what's included/excluded and ask for specific scope clarification

### Plan-to-Execution Fidelity for New Components
**Added**: 2026-01-08
**Context**: A dashboard plan specified creating NEW [CardComponent] components (4 types: Risk/red, Conflict/orange, Opportunity/green, Question/blue with border-l-4 treatments), but Agent 4 substituted an existing similar component instead. This caused a follow-up task to fix the gap.
**Problem**: When plans specify creating NEW components with specific visual treatments, Agent 4 may substitute existing similar-named components, losing the intended visual treatment and functionality.
**Solution**: Agent 4 MUST verify that new components specified in plans are actually created, not substituted with existing components. When a plan says "Create [CardComponent]", that means CREATE NEW, not reuse an existing similar component.
**Prevention**:
1. Agent 4 must check plan for "Create" vs "Reuse" language and follow exactly
2. When plan specifies visual treatments (border colors, type labels), verify implementation matches
3. Compare implemented component against plan's wireframe/mockup ASCII diagram
4. If tempted to substitute existing component, flag in execution notes for review
5. Agent 5 should verify visual treatment matches plan specification, not just "looks good"

**Example**:
```markdown
Plan says:
- "Create [CardComponent] - 4 variants: Risk (red border-l-4), Conflict (orange), Opportunity (green), Question (blue)"

❌ Wrong execution:
- "Used existing similar component for section content"
- No border-l-4 colored treatments
- No type labels (HIGH PRIORITY RISK, CONFLICT, etc.)

✅ Correct execution:
- Created new [CardComponent] at [path/to/component].tsx
- 4 border color variants: border-l-red-500, border-l-orange-500, border-l-green-500, border-l-blue-500
- Type labels rendered: "HIGH PRIORITY RISK", "CONFLICT", "OPPORTUNITY", "QUESTION"
```

### User-Facing Copy Verification Against Product Documentation
**Added**: 2026-01-15
**Context**: A detail card displayed "~3 days to complete" but product documentation specifies 6-8 hours processing time
**Problem**: Agent 4 implemented plan using field name `estimatedDays` literally without verifying the display copy against product documentation. The data model field name doesn't always match what users should see.
**Solution**: Always verify user-facing copy against source documentation (product specs, user flow docs) before implementing, especially for time/cost/quantity values.
**Prevention**:
1. Before implementing ANY user-visible text involving time, cost, or quantities, check product documentation
2. Field names in data models are for developers; user-facing labels may use different terminology
3. When in doubt, search for the terminology in documentation files: `grep -r "hours\|days" docs/`

**Example**:
```typescript
// ❌ Wrong - used field name literally
<span>~{category.estimatedDays} days to complete</span>

// ✅ Correct - verified against product documentation (6-8 hours processing)
<span>~{category.estimatedDays} hours to complete</span>
```

---

## CSS & Styling

### CSS Opacity Cascading Issues
**Added**: 2025-10-02
**Problem**: Setting opacity on containers creates stacking contexts, making content disappear
**Rules**:
1. Never set opacity on containers (div, section, main, header, footer)
2. Target specific content elements (p, h1-h6, img, svg, span)
3. Opacity on parent affects all children regardless of child opacity

### Use rgba() for Background Transparency, Not Element Opacity
**Added**: 2026-01-29
**Context**: DAG interactive navigation & visual overhaul — a graph node component had `opacity: 0.15` on the entire node div to create a subtle category-tinted background. This made the text inside completely unreadable on the dark canvas.
**Problem**: When you want a semi-transparent background but fully opaque text, using CSS `opacity` on the container dims everything — background AND text together. At `opacity: 0.15`, text is nearly invisible.
**Solution**: Convert hex colors to `rgba()` for the `backgroundColor` property only. Keep element `opacity: 1` (or use it only for intentional whole-node dimming like hover preview).
**Prevention**: When setting background transparency on any element that contains text, always use `rgba(r, g, b, alpha)` or `hsla()` for the background color — never CSS `opacity` on the container.

**Example**:
```typescript
// BAD — dims text AND background together
const bgOpacity = 0.15
style={{ backgroundColor: '#7ee787', opacity: bgOpacity }}

// GOOD — only background is semi-transparent, text stays fully visible
function hexToRgba(hex: string, alpha: number): string {
  const r = parseInt(hex.slice(1, 3), 16)
  const g = parseInt(hex.slice(3, 5), 16)
  const b = parseInt(hex.slice(5, 7), 16)
  return `rgba(${r}, ${g}, ${b}, ${alpha})`
}
style={{ backgroundColor: hexToRgba('#7ee787', 0.15), opacity: 1 }}
```

### Position/Z-index Hover Side Effects
**Added**: 2025-10-02
**Problem**: Adding position: relative and z-index on hover causes flickering
**Solution**: For pure visual effects, avoid changing positioning context on hover
**Prevention**: Prefer properties that don't affect layout: opacity, color, transform

### CSS Height Standardization
**Added**: 2025-01-04
**Problem**: Inline styles conflict with Tailwind classes
**Solution**:
```typescript
// When inline styles don't work:
style={{ height: '36px' }} // ❌ Overridden by CSS classes

// Solutions:
style={{ height: '36px !important' }} // ✅ Force override
// OR remove conflicting CSS classes
```

### shadcn Component Class Override Failures
**Added**: 2026-01-16
**Context**: A modal component had rounded corners despite `rounded-none` class; Button styling inconsistent with design system
**Problem**: shadcn components (Dialog, Button, Textarea) have base classes with `rounded-*` that normal Tailwind class additions don't override
**Solution**:
1. Use Tailwind's important modifier: `!rounded-none` instead of `rounded-none`
2. For Buttons with complex styling requirements, use plain `<button>` elements with direct classes
3. Always verify visual output after applying shadcn components in sharp-corner design systems

**Example**:
```tsx
// ❌ Wrong - shadcn Button has rounded-md baked in, won't override
<Button className="rounded-none">Submit</Button>

// ✅ Correct - use important modifier OR plain button
<DialogContent className="!rounded-none">
<Textarea className="!rounded-none" />

// ✅ For complex button styling, use plain button
<button
  type="button"
  className="h-9 px-4 text-sm font-medium bg-gray-900 text-white hover:bg-gray-800"
>
  Submit
</button>
```

**Prevention**:
1. When using shadcn in sharp-corner design systems, default to `!rounded-none`
2. Compare button styling against existing CTAs in codebase before using Button component
3. Take screenshot after modal implementation to verify corners

### Plain Button Elements Need Explicit rounded-md
**Added**: 2026-01-26
**Context**: Share Modal — raw `<button>` had sharp corners despite design system specifying rounded buttons
**Problem**: When using plain `<button>` elements (to avoid shadcn override issues), `rounded-md` is not applied by default. The button looks square while other buttons appear rounded.
**Solution**: Always include `rounded-md` class on plain button elements when design system specifies rounded interactive elements.

**Example**:
```tsx
// ❌ Wrong - missing rounded-md, button has sharp corners
<button className="h-9 px-4 bg-gray-900 text-white">
  Copy Link
</button>

// ✅ Correct - explicit rounded-md matches design system
<button className="h-9 px-4 rounded-md bg-gray-900 text-white">
  Copy Link
</button>
```

**Prevention**:
1. When creating raw `<button>` elements, include `rounded-md` by default
2. Design system brief specifies: "Sharp corners (0px) for containers, rounded-md (6-8px) for buttons"
3. Check visual consistency after implementing modals with buttons

### Container Overflow for Scaled Elements
**Added**: 2025-10-01
**Problem**: Scaled elements clipped by parent overflow-hidden
**Checklist**:
1. Check parent overflow properties
2. Add padding buffer for scaled elements
3. Test at max scale values
4. Consider z-index for scaled elements above siblings

### Professional Animation Scale Guidelines
**Added**: 2025-10-01
**Problem**: 8% hover scale looked "cartoonish" for business positioning
**Scale Ranges**:
- Ultra-subtle (B2B/Enterprise): 0.5-1.5%
- Subtle (Professional): 1.5-3%
- Noticeable (Consumer): 3-5%
- Playful (Creative): 5-10%

### Minimalist Style Matching
**Added**: 2025-10-01
**Problem**: Heavy styling (bg-zinc-100, shadows) on minimalist site
**Checklist**:
1. Review existing components for border styles, backgrounds, text sizes
2. Stick to established color palette
3. Match visual weight of existing elements
4. Less is more - avoid heavy backgrounds, shadows

### Reference Existing Layout Patterns Before Creating New Pages
**Added**: 2025-12-21
**Context**: Onboarding page created plain header instead of matching dashboard pattern
**Problem**: Agent created minimal header and full-width layout without referencing existing patterns
**Solution**: ALWAYS search for and reference existing header/layout patterns in codebase
**Prevention**:
1. Search for existing headers: `grep -r "header" app/` or glob for `**/header*.tsx`
2. Look at dashboard/authenticated pages for established patterns
3. Apply consistent constraints: `max-w-4xl`, `max-w-6xl` for content width
4. Match header styling: `bg-white dark:bg-background`, `h-14`, flex layout

**Example**:
```typescript
// ❌ Wrong - plain text header, no width constraint
<header className="border-b">
  <div className="container mx-auto px-4 py-4">
    <div className="text-lg font-semibold">Zebra Design</div>
  </div>
</header>

// ✅ Correct - matches dashboard pattern
<header className="border-b bg-white dark:bg-background">
  <div className="container max-w-4xl mx-auto flex h-14 items-center px-6">
    <Link href="/" className="flex items-center font-semibold text-lg">
      Zebra Design
    </Link>
  </div>
</header>
```

### Card Component Padding Override
**Added**: 2025-01-09
**Problem**: Default Card py-6 and gap-6 create too much spacing
**Solution**:
```typescript
// ❌ Wrong - assumes padding comes from custom styles
<Card className="space-y-0">

// ✅ Correct - explicitly override Card defaults
<Card className="py-3 gap-0 space-y-0">
```

### Design Language Consistency Check
**Added**: 2026-01-08
**Context**: A new card component created with rounded corners while codebase uses sharp corners
**Problem**: Agent followed task file wireframe ASCII mockup instead of checking existing component patterns. Also used shadcn Accordion defaults (rounded-lg) without overriding to match codebase.
**Solution**: Before creating ANY new card/grid component, verify styling against existing cards
**Prevention**:
1. ALWAYS read existing card components ([CardComponent], etc.) before creating new ones
2. Document shared design patterns: corners, borders, spacing, action text, colors
3. Override shadcn defaults to match codebase patterns (rounded-lg → sharp)
4. Never trust ASCII mockups for exact CSS - they're for layout structure, not styling details
5. Agent 3 Discovery should compare new component styling against existing similar components

**Example**:
```tsx
// ❌ Wrong - followed ASCII mockup and shadcn defaults
<AccordionItem className="rounded-lg border border-gray-200 border-l-4">
<div className="space-y-3">  {/* Spaced cards */}

// ✅ Correct - matches existing [CardComponent] design language
<AccordionItem className="group border-l-4">
<div className="border border-gray-200 divide-y divide-gray-200">  {/* Connected grid */}
```

### Post-Implementation Design Refinement Patterns
**Added**: 2026-01-08
**Context**: Value Preview page evolved significantly from original wireframe through iterative design refinement. Original plan used violet gradient banner + white expanded panels; final implementation uses clean white background + unified dark "Control Center" panel.
**Problem**: Original wireframe specifications (violet gradients, rounded corners, separate expand states) diverged from final implementation during design iteration. This is NORMAL and expected — wireframes are starting points, not rigid specs.
**Solution**: Design iteration is healthy. Document the evolution pattern: wireframe → implementation → design refinement → final state. When post-implementation changes happen, update task file notes to capture the design rationale.
**Prevention**:
1. Expect design iteration — wireframes are conversation starters, not contracts
2. When visual direction shifts (e.g., violet → black, rounded → sharp), update component file headers with rationale
3. For unified layouts (card + expanded content), design the connected state FIRST
4. "Control Center" pattern: When card selection reveals technical details, use same dark theme for both selected card and detail panel
5. Document final visual direction in component file headers for future agents

**Example**:
```tsx
// Original wireframe (journey page)
<div className="rounded-xl border-2 border-violet-200 bg-gradient-to-r from-violet-50">
  <button className="bg-violet-600">Start New Report</button>
</div>

// Final implementation (design refined for cleaner reference app-inspired look)
<div className="flex items-start justify-between gap-8">
  <Button className="bg-gray-900 hover:bg-gray-800">Start New Report</Button>
</div>

// Note: File header documents the design shift
/**
 * [BannerComponent] - Premium CTA banner for starting an action.
 * Clean, minimal design with neutral colors (like reference app).
 * No border box - content breathes on page background.
 */
```

### Unified Dark Panel for Technical Depth (Control Center Pattern)
**Added**: 2026-01-08
**Context**: Value Preview "How we built this" section evolved from a small white expandable card to a full-width dark "Control Center" with stats panel + execution trace side-by-side.
**Problem**: Original plan showed expanded state as separate white card below grid. User feedback/iteration led to unified dark panel that connects visually with the selected card.
**Solution**: When showing technical depth (traces, logs, stats), use a unified dark theme that spans both the trigger (card) and the detail panel. This creates visual cohesion and signals "you're now in technical view."
**Prevention**:
1. For expand-to-show-technical patterns, plan the unified dark container from the start
2. Selected card state should transition TO the dark theme to connect with detail panel
3. Use consistent dark palette: `bg-[#0B1120]` (near-black), `bg-[#0f172a]` (dark slate), `bg-slate-800` (lighter sections)
4. Side-by-side layout (stats | trace) works better than stacked for wide screens
5. Add `variant: 'light' | 'dark'` prop to components that may appear in both contexts

**Example**:
```tsx
// ✅ Unified Control Center pattern
{expandedReport && (
  <section className="pb-12">
    <div className="overflow-hidden bg-[#0B1120] shadow-xl">
      <div className="flex flex-col lg:flex-row">
        {/* Stats Panel - dark variant */}
        <div className="w-full lg:w-1/3 bg-[#0f172a] p-8">
          <DetailStats item={expandedReport} variant="dark" />
        </div>
        {/* Execution Trace - integrated */}
        <div className="w-full lg:w-2/3 bg-[#0B1120]">
          <[TreeComponent] nodes={traceTree} />
        </div>
      </div>
    </div>
  </section>
)}
```

### Gradient/Fade Effect Clarification
**Added**: 2025-01-04
**Context**: Moodboard scroll fix task initially misunderstood user gradient requirements
**Problem**: Agent planned opacity fade instead of background gradient mask
**Solution**: When users mention "fade effect" or "gradient", clarify the exact visual behavior before planning
**Prevention**: Always clarify whether "fade" means element opacity or background masking effect
- Fade Type: Opacity fade (element transparency) vs. background gradient mask
- CSS Approach: Background gradient (bg-gradient-to-t) vs. opacity animations vs. backdrop filters

### CSS Positioning with Tailwind Values
**Added**: 2025-09-04
**Problem**: Used approximate values instead of exact Tailwind pixels
**Solution**: Always verify exact Tailwind values
- w-16 = 64px (not ~60px)
- w-72 = 288px (not ~280px)

### Page Container Consistency Pattern (Single Card Container)
**Added**: 2026-01-15
**Context**: Workflow Preset Selection page initially used `bg-gray-100` page background with floating cards. User pointed out it looked "very different from our other screens."
**Problem**: Different pages using different container patterns creates visual inconsistency. Compare a form page (single card container on white background) vs initial preset selection (gray background with floating cards).
**Solution**: For form-like pages with selectable options, use the single card container pattern:
- Page background: `bg-white`
- Single outer card: `border border-gray-200 bg-white p-8`
- All content inside the card
- CTA button inside the card (not floating below)
**Prevention**:
1. BEFORE implementing new pages, check similar existing pages for container patterns
2. Look specifically at existing form-like pages (e.g., create/new forms, onboarding) for patterns
3. "Sheet on Desk" metaphor: Content surface (`bg-white`) floats on background (`bg-gray-100`) - but for form pages, entire form is ONE sheet
4. Compare screenshots side-by-side before declaring implementation complete

**Example**:
```tsx
// ❌ Wrong - gray background with floating cards (inconsistent)
<div className="bg-gray-100 min-h-screen">
  <div className="space-y-4">
    <Card>Option 1</Card>
    <Card>Option 2</Card>
  </div>
  <Button>Submit</Button>
</div>

// ✅ Correct - single card container on white (matches existing form pages)
<div className="bg-white min-h-screen">
  <div className="mx-auto max-w-2xl px-6 py-12">
    <div className="border border-gray-200 bg-white p-8">
      <div className="space-y-4">
        <SelectableCard>Option 1</SelectableCard>
        <SelectableCard>Option 2</SelectableCard>
      </div>
      <Button className="mt-8 w-full">Submit</Button>
    </div>
  </div>
</div>
```

### Grayscale Chrome: Color Reserved for Data Only
**Added**: 2026-01-15
**Context**: Workflow Preset Selection initially used blue (`border-blue-600`, `ring-blue-600`, `bg-blue-50`) for selected state. User pointed out: "we shouldn't be using blue highlights when something is selected."
**Problem**: Using colored accents (blue, violet, etc.) for selection states violates the design system principle: "Color is reserved exclusively for user data" (project design system docs).
**Solution**: All chrome (UI elements like borders, rings, backgrounds for selection) must use grayscale only. Color is reserved for data visualization, insights, and user content.
**Prevention**:
1. Selection states: `border-gray-900`, `ring-gray-900`, `bg-gray-50` — NOT blue
2. Check project design system docs before choosing selection colors
3. Grayscale includes: gray-900 (black), gray-700, gray-500, gray-300, gray-200, gray-100, gray-50, white
4. Color is ONLY for: Chart data, insight type indicators (risk=red, opportunity=green), user-generated content

**Example**:
```tsx
// ❌ Wrong - using color for UI selection state
className={selected ? 'border-blue-600 ring-1 ring-blue-600 bg-blue-50' : 'border-gray-200'}

// ✅ Correct - grayscale chrome, color reserved for data
className={selected ? 'border-gray-900 ring-1 ring-gray-900 bg-gray-50' : 'border-gray-200'}
```

### Invisible UI: Remove Redundant Indicators
**Added**: 2026-01-15
**Context**: A selectable card had both a radio circle indicator AND border/background change for selection state. User asked "Do we need the circle select?"
**Problem**: Redundant UI elements (showing selection state twice) add visual clutter without adding information.
**Solution**: Follow "Invisible UI" philosophy — if the primary visual (border change, background change) already clearly communicates the state, remove secondary indicators.
**Prevention**:
1. After implementing selection states, ask: "Is the state clear without this indicator?"
2. Border + ring is sufficient for card selection — radio circles are redundant
3. Remove padding accommodations when removing indicators (`pr-8` → no padding for removed top-right radio)
4. Test by squinting at the UI — if selection is still obvious, the indicator was redundant

### Pipeline Schematic Pattern with divide-x
**Added**: 2026-01-27
**Context**: Collapsing a multi-stage process — needed to show 6 connected stages in a horizontal strip
**Problem**: Floating separate cards (with `space-x-4` or `gap-4`) look disconnected. User and Gemini analysis suggested "connected grid" pattern.
**Solution**: Use `divide-x divide-gray-200` for connected horizontal stages. This creates a unified strip where stages flow into each other.

**Pattern**:
```tsx
// ✅ Pipeline schematic - connected strip
<div className="border border-gray-200 bg-white">
  <div className="grid grid-cols-6 divide-x divide-gray-200">
    {stages.map((stage) => (
      <div key={stage.id} className="flex flex-col items-center gap-2 py-4 px-2">
        <span className="font-mono text-[10px] text-gray-400">{stage.step}</span>
        <StageIcon className="size-4 text-gray-500" />
        <span className="text-[13px] font-medium text-gray-900">{stage.label}</span>
      </div>
    ))}
  </div>
  {/* Optional: Completion bar at bottom */}
  <div className="h-1 bg-emerald-500" />
</div>
```

**Key Insight**: `divide-x` creates internal borders between grid children without outer borders, making elements feel like one unified component rather than separate cards.

**Use Cases**:
- Research pipeline stages
- Step indicators
- Process flows
- Any horizontal sequence that should feel connected

**Prevention**: When designing horizontal sequences, ask: "Should these feel like separate steps or one unified flow?" If unified, use `divide-x` instead of `gap` or `space-x`.

### Visual Style Brief: Container vs Badge Radius Distinction
**Added**: 2026-01-15
**Context**: Issue detail card had `rounded-lg` on the container and `rounded` on badges, but both should have different treatments per project design system docs
**Problem**: Agent applied similar border-radius to both structural containers and interactive badges, violating the "sharp containers, soft interactions" principle
**Solution**: Per project design system docs:
- **Structural containers** (cards, panels, modals): 0px radius (sharp corners)
- **Tags/badges/pills**: `rounded-full` (full pill shape)
- **Interactive elements** (buttons, inputs): `rounded-md` or `rounded-lg` as specified
**Prevention**:
1. Before styling any new component, identify if it's a CONTAINER (sharp) or BADGE/TAG (pill)
2. When adding hover tooltips or detail cards, default to sharp corners
3. Priority/status badges should always be `rounded-full` with `text-[9px]` or smaller
4. Review project design system docs "Sharp containers, soft interactions" section before implementing

**Example**:
```tsx
// ❌ Wrong - applying same radius to container and badge
<div className="rounded-lg p-4 bg-white">
  <span className="rounded px-2 py-0.5 bg-red-500">HIGH</span>
</div>

// ✅ Correct - sharp container, pill badge
<div className="p-4 bg-white border">  {/* No rounded */}
  <span className="rounded-full px-2 py-0.5 bg-red-500">HIGH</span>
</div>
```

### Tailwind CSS v4 JIT Dynamic Class Detection Failure
**Added**: 2026-01-15
**Context**: Card simplification task — colored left borders (border-l-red-500, etc.) appeared gray despite correct class names in config.
**Problem**: Tailwind CSS v4 JIT compiler cannot statically detect class names constructed from variables at runtime. When using `config.borderColor` (which resolves to "border-l-red-500"), the class is never generated because JIT doesn't see it in the source code. Additionally, global CSS rules like `* { border-color: var(--color-border); }` override any dynamically applied classes.
**Solution**: For color properties that need to be dynamic (based on data/config), use inline styles with hex values instead of Tailwind classes. Inline styles have higher CSS specificity and don't require JIT detection.
**Prevention**:
1. If using config objects with Tailwind class names AND colors appear wrong, check if classes are being generated
2. Add `borderColorHex` (or similar) property with actual hex values (#ef4444, #f97316, etc.)
3. Apply via inline style: `style={{ borderLeftColor: config.borderColorHex }}`
4. Check global CSS for `* { border-color: ... }` rules that might override
5. Alternative: Add all possible class variants to a safelist in tailwind.config.js

**Example**:
```tsx
// ❌ Wrong - Tailwind JIT won't detect dynamic class names
const CARD_TYPE_CONFIG = {
  risk: { borderColor: "border-l-red-500" },  // Not detected by JIT
}
<div className={cn("border-l-4", config.borderColor)} />  // Gray border appears

// ✅ Correct - inline styles always work
const CARD_TYPE_CONFIG = {
  risk: {
    borderColor: "border-l-red-500",     // For static usage if needed
    borderColorHex: "#ef4444"            // For dynamic inline styles
  },
}
<div
  className="border-l-4"
  style={{ borderLeftColor: config.borderColorHex }}  // Red border appears
/>
```

### h-full Does Not Propagate Through overflow-y-auto Parent Chains
**Added**: 2026-01-29
**Context**: Renaming a feature section — DAG needed to fill full viewport height
**Problem**: `h-full` on a child element does not propagate through parent chains that include `overflow-y-auto`. The parent's `overflow-y-auto` creates a scrollable context without a defined height, so `h-full` resolves to "100% of undefined" and collapses.
**Solution**: Use viewport-calc heights (`min-h-[calc(100vh-Xpx)]`) or `flex-1` within a flex-col parent instead of relying on `h-full` propagation through overflow containers.
**Prevention**:
1. Before using `h-full`, trace the parent chain and check for `overflow-y-auto` containers
2. If found, switch to `min-h-[calc(100vh-Xpx)]` where X accounts for fixed headers
3. Or use `flex-1` in a `flex flex-col` parent with `min-h-0` to allow flex shrinking

**Example**:
```tsx
// ❌ Wrong - h-full won't propagate through overflow-y-auto parent
<main className="overflow-y-auto">
  <div className="h-full">  {/* Collapses to content height */}
    <ReactFlowCanvas />
  </div>
</main>

// ✅ Correct - viewport-calc bypasses overflow chain
<div className="flex min-h-[calc(100vh-3.5rem)] flex-col">
  <div className="flex-1 min-h-0">
    <ReactFlowCanvas className="h-full" />
  </div>
</div>
```

---

## React Patterns

### React Hooks Validation
**Added**: 2025-09-03
**Problem**: Conditional useQuery violates Rules of Hooks
**Solution**:
```typescript
// ❌ Wrong - conditional hook call
const data = condition ? useQuery(api.func, args) : undefined;

// ✅ Correct - always call hook, use skip
const data = useQuery(api.func, condition ? args : "skip");
```

### React Hydration Error Debugging
**Added**: 2025-01-04
**Problem**: Nested Button components cause hydration mismatches
**Solution**:
```typescript
// ❌ Wrong - nested Button components
<Button>
  <Button>Action</Button>
</Button>

// ✅ Correct - div with button behavior
<div className="button-styles cursor-pointer" onClick={handleMain}>
  <button onClick={handleAction}>Action</button>
</div>
```

### Component Preservation During Large Changes
**Added**: 2025-01-04
**Problem**: Large layout changes accidentally remove components or props
**Checklist**:
1. List all components interacting with modified area
2. Verify all required props preserved
3. Test component in all intended states
4. Ensure conditional rendering logic intact

### Component Hierarchy Analysis
**Added**: 2025-01-13
**Problem**: Toggle buttons placed in hidden header section
**Prevention**:
1. Trace component tree and prop passing
2. Check for showHeader, showActions that control visibility
3. Read parent components to understand prop flow

### State Reset Handler Pattern
**Added**: 2025-01-04
**Problem**: cloneElement for passing handlers caused timing issues
**Solution**: Use React Context with useRef for stable handler registration

```typescript
const resetHandlerRef = useRef<(() => void) | undefined>();
const setResetHandler = useCallback((handler: (() => void) | undefined) => {
  resetHandlerRef.current = handler;
}, []);

<ResetContext.Provider value={{ setResetHandler }}>
  {children}
</ResetContext.Provider>
```

### Duplicate State Management Prevention
**Added**: 2025-01-09
**Problem**: Files added to both uploadedFiles and imageReferences causing duplicate display
**Solution**: Maintain single source of truth per file

```typescript
// ❌ Wrong - adds to both arrays
setUploadedFiles(prev => [...prev, newFile]);
onAddReference(newReference); // Duplicate

// ✅ Correct - single source of truth
setUploadedFiles(prev => [...prev, newFile]);
```

### Selection State: Add vs Replace Semantics
**Added**: 2026-01-15
**Context**: Workflow Side-by-Side Layout — clicking between presets did not update the DAG visualization
**Problem**: `selectMultiple(ids)` function only ADDS to existing selection, never clears. When switching from "Full Scope" (27 categories) to "Focused Scope" (6 categories), all 27 categories remained highlighted because the 6 new ones were ADDED to the existing 27.
**Solution**: Implement separate `setSelection(ids)` function that REPLACES entire selection with new IDs (creates new Set, not additive)
**Prevention**:
1. When implementing selection state hooks, always provide BOTH `selectMultiple` (additive) AND `setSelection` (replace) functions
2. For preset/mode switching, ALWAYS use replace semantics
3. For user clicking individual items, use toggle/additive semantics
4. Name functions clearly: `add*`, `toggle*` for additive; `set*`, `replace*` for complete replacement

**Example**:
```typescript
// ❌ Wrong - only additive function
const selectMultiple = (ids: number[]) => {
  setSelectedIds(prev => {
    const next = new Set(prev)
    ids.forEach(id => next.add(id))  // Only adds, never clears
    return next
  })
}

// When switching presets:
handleSelectPreset('team-founders')  // Adds 6 to existing 27 = 33 selected

// ✅ Correct - provide both additive AND replace functions
const selectMultiple = (ids: number[]) => {
  setSelectedIds(prev => {
    const next = new Set(prev)
    ids.forEach(id => next.add(id))
    return next
  })
}

const setSelection = (ids: number[]) => {
  setSelectedIds(new Set(ids))  // Complete replacement
}

// When switching presets:
handleSelectPreset('team-founders')  // Replaces selection = exactly 6 selected
```

### Radix asChild Conflict with Nested Components
**Added**: 2026-01-15
**Context**: Chat History Dropdown - buttons stopped working after adding Tooltips
**Problem**: When using Radix `asChild` pattern with nested wrapper components (like Tooltip), click handlers don't reach the actual button
**Root Cause**: `asChild` merges props with its immediate child. If that child is a wrapper (Tooltip, div, etc.) that doesn't forward unknown props, handlers are lost.

```typescript
// ❌ Wrong - Tooltip swallows click handler from PopoverTrigger
<PopoverTrigger asChild>
  <Tooltip>
    <TooltipTrigger asChild>
      <button>Click me</button>
    </TooltipTrigger>
  </Tooltip>
</PopoverTrigger>

// ✅ Correct - Pass plain button to PopoverTrigger, no Tooltip nesting
<PopoverTrigger asChild>
  <button>Click me</button>
</PopoverTrigger>

// ✅ Alternative - Separate desktop (Popover) and mobile (Tooltip) implementations
const buttonDesktop = <button>Click</button> // For PopoverTrigger
const buttonMobile = (
  <Tooltip>
    <TooltipTrigger asChild>
      <button onClick={handler}>Click</button>
    </TooltipTrigger>
  </Tooltip>
)
```

**Prevention**: When combining Radix components with `asChild`:
1. Never nest Tooltip inside PopoverTrigger (or similar compound triggers)
2. If you need both tooltip and popover, separate desktop/mobile implementations
3. Test clicking immediately after adding wrapper components

---

## Drag & Drop

### Visual Drag Feedback Preservation
**Added**: 2025-01-13
**Problem**: HTML5 drag API replaced custom drag, eliminating visual feedback
**Solution**: Implement hybrid approach - HTML5 API for compatibility PLUS visual feedback

```typescript
// ✅ Hybrid system with both APIs
<div
  draggable={true}
  onDragStart={handleDragStart}  // HTML5 for payload
  onMouseDown={handleMouseDown}  // Custom for visual feedback
>
```

### Mouse-Based Drag System
**Added**: 2025-01-09
**Problem**: HTML5 drag API fails with React component unmounting during state changes
**Solution**: Use mouse events with React Portal for drag ghost

```typescript
useEffect(() => {
  if (!isDragging) return;

  const handleMouseMove = (e: MouseEvent) => {
    setPosition({ x: e.clientX, y: e.clientY });
  };

  document.addEventListener("mousemove", handleMouseMove);
  document.addEventListener("mouseup", handleMouseUp);

  return () => {
    document.removeEventListener("mousemove", handleMouseMove);
    document.removeEventListener("mouseup", handleMouseUp);
  };
}, [isDragging]);

{isDragging && createPortal(<DragGhost />, document.body)}
```

### Event Propagation and Button Conflicts
**Added**: 2025-01-09
**Problem**: mouseDown for drag prevents button clicks
**Solution**:
```typescript
const handleMouseDown = (e: React.MouseEvent) => {
  const target = e.target as HTMLElement;
  if (target.closest('button')) return; // Let button handle events
  // Start drag...
};

<Button onMouseDown={(e) => e.stopPropagation()}>
  Action
</Button>
```

### Drop Zone Positioning Pattern
**Added**: 2025-01-09
**Solution**:
1. Start with inset expansion: -inset-8
2. Add fixed height, not constraints
3. Adjust vertical positioning incrementally
4. Test with actual content, not empty states

### Cross-Component Interaction Mapping
**Added**: 2025-01-09
**Context**: Moodboard drag affordance task missed crucial interaction between demo characters and AI input areas
**Problem**: Failed to identify that demo character drag should work with BOTH main content AND AI text input areas
**Solution**: Always map ALL possible drop targets and interaction flows when planning drag/drop features
**Prevention**: Create explicit interaction matrix showing drag sources, drop targets, and expected behaviors

### Drag and Drop Pattern Analysis
**Added**: 2025-01-05
**Context**: Drag Demo Characters task needed affordance pattern like existing prompt input drop zone
**Problem**: Planning didn't identify and reference existing drag/drop patterns in the codebase
**Solution**: Always identify existing UI patterns when planning similar functionality
**Prevention**: Search for existing patterns (`grep -r "drop-target" components/`) and document pattern details

---

## Interactions & UX

### Agent 0 Multi-Perspective Workflow Prevents Iteration Loops
**Added**: 2026-01-29
**Context**: Category alignment task — post-implementation visual refinement decisions
**Problem**: After implementing domain categories, the page had too many competing visual signals (coloured borders, coloured pills, coloured icons, header badge). Each element was individually justified but collectively created a "Christmas tree" effect. Without structured decision-making, this would have been multiple rounds of back-and-forth.
**Solution**: Used Agent 0 (design-0-refine.md) 4-perspective workflow — 2 Claude subagents + 2 Gemini MCP calls in parallel — to get unanimous/majority decisions on 3 changes simultaneously:
1. Gray domain borders (unanimous YES)
2. Remove header badge, merge source count into subtitle (2-2 split, user chose MODIFY)
3. Desaturate signal pills (unanimous MODIFY)

All 3 changes shipped in one pass with zero rework.

**Prevention**: For any visual change that affects multiple competing elements, run Agent 0 before implementing. The parallel 4-perspective format catches design conflicts before they become code iterations.

### Visual Hierarchy Through Reduction, Not Addition
**Added**: 2026-01-29
**Context**: Report summary insight cards had domain border colours, signal-type pill colours, trust indicators, and a header badge all competing for attention
**Problem**: User testing showed sources/verification trust indicators are what users value most, but they were visually subordinate to decorative domain colours and signal-type badges
**Solution**: Systematic reduction — remove or neutralise everything that isn't the primary action:
1. Domain borders → gray (then removed entirely)
2. Signal pills → muted text-only colour (no background fill)
3. Header badge → removed, useful data merged into subtitle text
4. Result: Trust indicators (source counts, confidence) became the most prominent interactive element by default — no new styling needed, just removal of visual competition

**Prevention**: When adding new visual categories/groupings, audit whether existing elements should be reduced to compensate. Apply Maeda's Law 1 (Reduce) proactively.

### Mobile Accessibility for Desktop-First Features
**Added**: 2026-01-16
**Context**: Mobile detail panel access — desktop text selection unavailable on mobile
**Problem**: Desktop relies on text selection → tooltip, but mobile text selection is fiddly (long-press, drag handles) and users may never discover the feature
**Solution**: Multi-layer approach with "Inspect" mode for mobile:

1. **Add explicit mobile affordances to existing UI elements** — don't add new floating buttons
2. **Show evidence first, chat second** — "Inspect" mode pre-loads sources (not empty chat input)
3. **Responsive breakpoint `lg:hidden` / `hidden lg:block`** — keep desktop pattern, add mobile pattern
4. **Context-appropriate navigation** — per-finding sources → Evidence Panel; bulk sources → Sources page

**Implementation Pattern**:
```typescript
// Context state for mode switching
const [mode, setMode] = useState<"chat" | "inspect">("chat")
const [inspectData, setInspectData] = useState<{ title: string; sources: Source[] } | null>(null)

// Open method for inspect mode
const openInspect = (title: string, sources: Source[]) => {
  setMode("inspect")
  setInspectData({ title, sources })
  setOpen(true)
}

// In drawer render:
{mode === "inspect" && inspectData ? (
  <DetailPanel title={inspectData.title} sources={inspectData.sources} onClose={close} />
) : (
  <ChatInterface />
)}
```

**Mobile Button Pattern**:
```tsx
{/* Mobile-only tappable row */}
<div className="lg:hidden">
  <button onClick={() => openInspect(finding.title, finding.sources)}>
    View {sources.length} sources & analysis
  </button>
</div>
{/* Desktop: existing source list */}
<div className="hidden lg:block">
  {sources.map(source => <SourceRow key={source.id} />)}
</div>
```

**Key Insight**: "If you need a banner to explain UI, the UI has failed" — remove tip banners on mobile and replace with obvious tappable affordances.

### Share Modal UX — Copy Link as Primary Action
**Added**: 2026-01-26
**Context**: Share Modal had Copy Link button + separate Cancel/Share Report footer buttons
**Problem**: User confused by having both "Copy Link" and "Share Report" buttons — "I can click copy but I can also click share report - that doesn't make sense"
**Solution**: Remove redundant footer buttons. Copy Link IS the share action. Modal becomes:
1. Access control dropdown (who can access)
2. Link preview with Copy button
3. No footer (close via X or clicking outside)

**Pattern**:
```tsx
// ❌ Wrong - redundant actions confuse users
<DialogContent>
  <AccessControl />
  <LinkPreview>
    <Button variant="secondary">Copy Link</Button>  {/* Action 1 */}
  </LinkPreview>
  <DialogFooter>
    <Button variant="ghost">Cancel</Button>
    <Button>Share Report</Button>  {/* Action 2 - what does this do? */}
  </DialogFooter>
</DialogContent>

// ✅ Correct - single clear action
<DialogContent>
  <AccessControl />
  <LinkPreview>
    <Button className="bg-gray-900 text-white">Copy Link</Button>  {/* Primary action */}
  </LinkPreview>
  {/* No footer - Copy Link IS sharing */}
</DialogContent>
```

**Key Insight**: For share modals, copying the link IS the share action. A separate "Share" button implies something additional will happen (like sending an email), which confuses users when it doesn't.

**Prevention**:
1. Before adding modal footers, ask: "Is this action different from buttons already in the modal?"
2. If footer action duplicates an inline action, remove the footer
3. Test modal UX by describing what each button does — if you can't explain the difference, remove one

### Chat Input Persistence After Required Action
**Added**: 2026-01-26
**Context**: Confirm Page Redesign — chat input was hidden once user answered clarifications
**Problem**: After user completes required action (answering clarifications), hiding the input prevents continued conversation. Users may want to add more notes.
**Solution**: Keep chat input visible in "ready" state with contextual placeholder change:
- `awaiting-response` state: "Type your response..."
- `ready` state: "Add any additional notes..."

**Pattern**:
```tsx
// ❌ Wrong - removes input after required action
{pageState === 'awaiting-response' && <ChatInput />}

// ✅ Correct - input persists with contextual placeholder
{(pageState === 'awaiting-response' || pageState === 'ready') && (
  <ChatInput
    placeholder={pageState === 'awaiting-response'
      ? 'Type your response...'
      : 'Add any additional notes...'
    }
  />
)}
```

**Key Insight**: Claude-like UX allows continued conversation even after the "blocking" question is answered. Removing input feels like the conversation is forcibly closed.

### Future Tense for Pre-Action Messaging
**Added**: 2026-01-26
**Context**: Confirm Page verification badge said "cross-checked" (past tense) before research started
**Problem**: Describing actions that haven't happened yet in past/present tense confuses users about current state
**Solution**: Use future tense ("will be") for actions that happen AFTER user confirms

**Examples**:
```tsx
// ❌ Wrong - implies it already happened
"Each finding cross-checked by multiple AI systems"

// ✅ Correct - clearly describes future action
"Each finding will be cross-checked by multiple AI systems"
```

**Prevention**: Before finalizing copy, ask: "Has this action happened yet?" If no, use future tense.

### Visible Labels vs Tooltip-Only — Always Show Meaning
**Added**: 2026-01-27
**Context**: Collapsing a process overview — initial implementation showed icons with tooltips only, no visible labels
**Problem**: User feedback: "I was expecting to see what each of the research stages were - adding a bit more meaning to this" — tooltips require hover, not discoverable on mobile
**Solution**: Always show visible labels for stage/step indicators. Tooltips should provide ADDITIONAL context, not be the ONLY way to understand meaning.

**Pattern**:
```tsx
// ❌ Wrong - icon with tooltip only (meaning hidden behind hover)
<Tooltip>
  <TooltipTrigger>
    <Database className="size-4 text-gray-500" />
  </TooltipTrigger>
  <TooltipContent>Sources</TooltipContent>
</Tooltip>

// ✅ Correct - visible label + tooltip for extra detail
<Tooltip>
  <TooltipTrigger className="flex flex-col items-center gap-2">
    <span className="font-mono text-[10px] text-gray-400">01</span>
    <Database className="size-4 text-gray-500" />
    <span className="text-[13px] font-medium text-gray-900">Sources</span>
  </TooltipTrigger>
  <TooltipContent>
    Gathered documents from web searches, databases, and uploads
  </TooltipContent>
</Tooltip>
```

**Key Insight**: If you're adding a tooltip, ask: "Would users understand this element without hovering?" If no, the label should be visible.

**Prevention**:
1. Tooltips supplement visible labels — they don't replace them
2. Mobile users can't hover — visible labels are essential
3. When designing iconography, always pair with visible text unless icon is universally understood (close X, hamburger menu)

### Clickable Stages for Progressive Disclosure
**Added**: 2026-01-27
**Context**: Collapsing a process overview — user asked if clicking stages should expand the full graph
**Problem**: Only one expand affordance ("See Full Process" button) — power users scanning the UI may not notice the button
**Solution**: Make stage elements clickable as an alternate expand path. Multiple affordances for the same action improves discoverability.

**Pattern**:
```tsx
function ResearchPipeline({ onExpand }: { onExpand: () => void }) {
  return (
    <div className="grid grid-cols-6 divide-x divide-gray-200">
      {STAGES.map((stage) => (
        <button
          type="button"
          onClick={onExpand}  // Same action as "See Full Process" button
          className="cursor-pointer hover:bg-gray-50"
        >
          <Stage {...stage} />
        </button>
      ))}
    </div>
  )
}
```

**Key Insight**: For progressive disclosure UIs, the collapsed preview itself should be clickable to expand. It's the most direct mapping of "I want to see more of this."

### Cross-Screen Data Value Consistency
**Added**: 2026-01-26
**Context**: Confirm page showed "~7 hours" but processing page shows "6h 30m"
**Problem**: Different screens showing different values for the same data (estimated time) erodes trust
**Solution**: Use consistent values across related screens in the user flow

**Pattern**:
```typescript
// Define constants for reuse
const ESTIMATED_TIME = "6h 30m"  // Single source of truth

// Use in confirm page
<span>{ESTIMATED_TIME} estimated</span>

// Use in processing page
<span>Estimated: {ESTIMATED_TIME}</span>
```

**Prevention**: When implementing time/cost/count values, search codebase for related screens and ensure consistency.

### Interactive State Debugging
**Added**: 2025-01-06
**Problem**: Basic state pattern didn't anticipate complex interactions
**Solution**:
```typescript
// Use interaction-aware pattern
const [textareaFocused, setTextareaFocused] = useState(false);
const [optionsInteracting, setOptionsInteracting] = useState(false);

useEffect(() => {
  setShowOptions((textareaFocused || optionsInteracting) && mode === "character");
}, [textareaFocused, optionsInteracting, mode]);
```

### Progressive UI Enhancement
**Added**: 2025-01-06
**Problem**: Basic functionality without multiple discovery pathways
**Pattern**:
1. Primary functionality: Core feature works
2. Discovery affordances: Multiple ways to find/trigger
3. Visual feedback: Clear indication of interactions
4. Fallback options: Alternative methods

### Interaction Trigger Pattern Selection
**Added**: 2025-01-04
**Decision Matrix**:
- onFocus/onBlur: Persistent UI when interacting with field
- onChange/typing: Dynamic content depending on input
- onClick: Explicit user actions
- onHover: Desktop-only enhancements

### Carousel Pause on Hover
**Added**: 2025-10-02
**Required Pattern**:
```typescript
const [isCarouselHovered, setIsCarouselHovered] = useState(false)

<div
  onMouseEnter={() => setIsCarouselHovered(true)}
  onMouseLeave={() => setIsCarouselHovered(false)}
>
  <div style={{
    animationPlayState: (prefersReducedMotion || isCarouselHovered) ? 'paused' : 'running'
  }}>
```

### Input Affordance Design
**Added**: 2025-01-05
**Problem**: Textarea blended with background, unclear affordance
**Solution**: Always use distinct background (typically white) for text inputs

### Arbitrary Validation Barriers
**Added**: 2025-01-05
**Problem**: 50-character minimum blocked submission
**Principle**: Some feedback is better than none. Use soft encouragement, not hard blocks.

### Context-Appropriate Button Text
**Added**: 2025-01-05
**Solution**: Use mode-specific text
```typescript
<Button>
  {isTextMode ? 'Save & Continue' : 'Finish Test'}
</Button>
```

### Bidirectional Functionality Analysis
**Added**: 2025-01-06
**Context**: Demo Asset Library required multiple iterations due to missing bidirectional functionality planning
**Problem**: Agent only planned one-way drag (moodboard → demo section) but user expected reverse functionality
**Solution**: Always analyze and explicitly plan bidirectional workflows when implementing drag-and-drop
**Prevention**: When planning interactive features, ALWAYS ask "What should users be able to do in the reverse direction?"

### Post-Completion Behavior Analysis
**Added**: 2025-11-26
**Context**: Screen 4 Customize Test task required mid-implementation addition of redirect URL feature
**Problem**: Original plan didn't consider what happens after users complete the flow
**Solution**: For user flow tasks, always analyze post-completion behaviors during planning
**Prevention**: Ask "What options should users have after completing this step?" and document post-completion behaviors

### Clarify Interaction Type Early (Simulated vs Real)
**Added**: 2025-12-27
**Context**: A reference project - confusion about whether actions were simulated or required real input
**Problem**: Planning didn't specify if interactions were demos or actual flows
**Solution**: During planning, explicitly clarify: Is this a demo/simulation or real user interaction?
**Prevention**:
- Simulated: Auto-triggered animations, scripted sequences, no real user input needed
- Real: Actual user clicks, real data input, real API calls
- Document interaction type in task file before implementation

### Timer Auto-Action Clarity
**Added**: 2025-12-27
**Context**: A reference project had auto-advancing screens that confused implementation
**Problem**: "Then it advances to next screen" left unclear - user-triggered or auto?
**Solution**: Always specify exact trigger mechanism for screen transitions
**Prevention**:
- Explicit timer: "After 3 seconds, auto-advance to Screen 2"
- User action: "User taps 'Continue' button to advance"
- Completion: "After animation ends, auto-transition"
- Never use vague "then it goes to next screen"

### UX Discoverability Planning
**Added**: 2025-01-06
**Context**: Demo Asset Library required multiple UI affordances after user couldn't discover functionality
**Problem**: Agent planned focus-based discovery but user needed explicit UI elements
**Solution**: Always plan multiple discovery patterns for interactive features
**Prevention**: Plan at least 2-3 different ways users can discover the functionality

### Mode System Analysis
**Added**: 2025-01-04
**Context**: AI Generation Options task required three iterations because mode-specific behavior wasn't analyzed
**Problem**: Agent didn't examine existing mode system (Character/Image/Video modes)
**Solution**: For UI features that might be mode-dependent, always analyze the existing mode/tab system first
**Prevention**: Identify existing mode systems and document mode restrictions before planning

### Bidirectional Action UX Completeness
**Added**: 2026-01-15
**Context**: Category Detail Card "Remove from scope" button removed category from DAG but the card remained in the chat
**Problem**: Original UX spec only defined what happens when ADDING to scope (detail card appears). It didn't define what happens to UI artifacts (cards, messages) when the underlying data is REMOVED.
**Solution**: When implementing add/remove or toggle actions, explicitly define what happens to related UI elements in BOTH directions (add AND remove).
**Prevention**:
1. When planning UX for add/toggle actions, always ask: "What happens to the UI element when this is undone/reversed?"
2. Include reverse-action behavior in verification checklist
3. For chat-based UIs: Messages created by actions should be removed when actions are reversed

**Example**:
```typescript
// ❌ Wrong - only handles toggle, forgets about UI artifact
const handleRemoveCategory = (categoryId: number) => {
  toggleCategory(categoryId)  // Removes from scope
  // Card message stays in chat forever!
}

// ✅ Correct - handles both data AND UI artifact
const handleRemoveCategory = (categoryId: number) => {
  toggleCategory(categoryId)  // Removes from scope
  setChatMessages(prev => prev.filter(msg =>
    !(msg.type === 'category-detail' && msg.categoryId === categoryId)
  ))  // Also removes the card from chat
}
```

### Direct Manipulation State Transitions
**Added**: 2026-01-15
**Context**: Clicking DAG node to deselect (in selection mode) didn't switch to chat mode — user had to point this out
**Problem**: handleNodeClick only switched modes when ADDING to scope. Clicking to REMOVE left the user in selection mode, creating a confusing state where they were customizing scope but still seeing the preset selection UI.
**Solution**: Any direct manipulation on a visualization (clicking nodes, dragging, etc.) should trigger appropriate state/mode transitions regardless of whether the action is add, remove, select, or deselect.
**Prevention**:
1. When implementing click handlers on visualizations, consider mode transitions for ALL interaction types
2. Ask: "If the user is directly manipulating the data, what view/mode should they be in?"
3. Direct manipulation = customization mode, not preset selection mode

**Example**:
```typescript
// ❌ Wrong - only switches mode when adding
const handleNodeClick = (categoryId: number) => {
  const wasSelected = selectedIds.has(categoryId)
  toggleCategory(categoryId)
  if (!wasSelected) {
    setMode('chat')  // Only switches when adding
    // Removing leaves user in wrong mode!
  }
}

// ✅ Correct - switches mode for any direct manipulation
const handleNodeClick = (categoryId: number) => {
  const wasSelected = selectedIds.has(categoryId)
  toggleCategory(categoryId)

  // Any direct DAG interaction means user is customizing
  if (mode === 'selection') {
    setMode('chat')
  }

  if (!wasSelected) {
    // Add detail card for additions
    setChatMessages(prev => [...prev, detailMessage])
  }
}
```

### Dual-Model UX Analysis for Mobile Spacing
**Added**: 2026-01-29
**Context**: Mobile card spacing improvements for [CardComponent] variants
**Pattern**: Send screenshots to Gemini Pro 3 (via AI Studio MCP) for independent visual assessment, then synthesize with Claude's code-level analysis before planning changes.
**Key Insight**: Gemini caught two issues Claude's code analysis missed:
- `flex-wrap` needed on metadata rows so trust indicators wrap gracefully at narrow widths
- `leading-relaxed` on mobile titles for better readability at `text-base` size
**Why It Works**: Code analysis focuses on structure and class names; visual model analysis focuses on perceived spacing and readability. Combining both catches more issues.
**Apply When**: Mobile/responsive layout tasks where spacing and visual density are the primary concerns.

### Mobile-Only Tailwind Changes via Base + md: Override
**Added**: 2026-01-29
**Context**: Needed to increase mobile padding/gap without affecting desktop
**Pattern**: Change base value and add `md:` prefix to restore desktop original:
```
// Before: py-3 (both mobile and desktop)
// After:  py-4 md:py-3 (mobile gets py-4, desktop stays py-3)
```
**Key Prerequisite**: Verify mobile and desktop use separate code paths (`md:hidden` / `hidden md:flex`) so changes don't cascade unexpectedly.

---

## Layout & Positioning

### Global vs Container Event Tracking
**Added**: 2025-10-01
**Problem**: Tracked mouse only within container instead of page-wide
**Decision Matrix**:
- Page-wide: `document.addEventListener('mousemove')`
- Container-specific: onMouseMove on container
- Component-specific: onMouseEnter/Leave
- Always clean up global listeners in useEffect return

### Fill Remaining Viewport with flex-1
**Added**: 2026-01-27
**Context**: Collapsing a section — white space visible below the collapsed section
**Problem**: Content ends before viewport bottom, leaving jarring white space with a different background color
**Solution**: Use `flex flex-col` on parent container and `flex-1` on the last section to fill remaining space

**Pattern**:
```tsx
// Parent container must be flex column with min-height
<div className="min-h-screen bg-gray-50 flex flex-col">
  <Header />      {/* Fixed height */}
  <Content />     {/* Variable height */}
  <Footer className="flex-1" />  {/* Fills remaining viewport */}
</div>
```

**Key Insight**: When a page has sections with different background colors, any remaining viewport space needs to match the final section's color to avoid visual jarring.

**Prevention**:
1. Check for white/empty space at the bottom of pages at various viewport heights
2. Use `flex-1` on the final section that should expand to fill
3. Parent container must have `flex flex-col` and usually `min-h-screen`

### Fixed vs Sticky Positioning
**Added**: 2025-01-04
**Decision Matrix**:
- sticky: Scrolls with content until threshold, then sticks
- fixed: Stays in same viewport position regardless of scroll
- absolute: Positioned relative to nearest positioned parent

### Route Layout Architecture
**Added**: 2025-01-04
**Problem**: Standalone components instead of integrating with layout system caused 404s
**Analysis**:
1. Check route group structure
2. Validate layout inheritance
3. Test component integration with existing sidebars/topbars
4. Avoid double-wrapping with nested layouts

### Component Changes Not Appearing - CRITICAL
**Added**: 2025-09-02
**Problem**: Modifying wrong component in complex architectures
**MANDATORY PROCESS**:
1. Trace from page file to actual rendered component
2. Add test visual element: `<div className="bg-red-500">TEST</div>`
3. Confirm test element visible on target page
4. Only then proceed with actual implementation

### Layout Inconsistency Deep Debugging
**Added**: 2025-02-09
**Problem**: Surface-level fixes don't resolve architectural inconsistencies
**Solution**: Compare complete render structure, not just props and CSS
- Image cards: Component → UnifiedCard (single layer)
- Video cards: Component → Card + CardHeader → UnifiedCard (double layer)

### Fixed Positioning Banner Overlap
**Added**: 2025-11-26
**Problem**: Fixed banners overlap progress indicators
**Decision Matrix**:
1. Fixed: Only when must stay in viewport AND no other elements need that space
2. Normal flow: When elements should push content down (preferred for banners)
3. Sticky: When element should stick after scrolling past

### Inline vs Floating Component Positioning and Styling
**Added**: 2026-01-16
**Context**: Converting a floating player component from fixed overlay to inline position within a detail view
**Problem**: Multiple iterations needed — wrong initial placement (before stats row instead of after), styling too heavy for inline context
**Solution**:
1. When converting floating → inline, clarify EXACT placement in content hierarchy (e.g., "after X, before Y")
2. Floating components need LIGHTER styling for inline context:
   - Shadows: `shadow-lg` → `shadow-sm` (inline elements shouldn't dominate)
   - Corners: `rounded-lg` → `rounded-sm` (blend with surrounding content)

### React Flow Viewport Sync for HTML Overlays
**Added**: 2026-01-26
**Context**: Column headers above DAG needed to stay aligned with nodes during zoom/pan
**Problem**: Fixed DOM headers don't move when React Flow canvas is panned/zoomed, causing misalignment
**Solution**: Sync HTML overlays with React Flow viewport using CSS transform
```tsx
// Track viewport state
const [viewport, setViewport] = useState<Viewport>({ x: 0, y: 0, zoom: 1 })

// In ReactFlow: onViewportChange={setViewport}

// Apply same transform to overlay
<div style={{
  transform: `translate(${viewport.x}px, ${viewport.y}px) scale(${viewport.zoom})`,
  transformOrigin: '0 0',
}}>
  {/* Headers stay aligned with nodes */}
</div>
```
**Key Points**:
- Don't use fixed viewport (breaks zoom/pan UX)
- Use `pointer-events-none` on overlay container to not interfere with React Flow interactions
- Calculate overlay positions using same constants as node positions (START_X, COLUMN_SPACING)
3. Add `variant` prop to support both modes without duplicating component:
   ```tsx
   variant === "floating"
     ? "fixed bottom-4 left-1/2 z-50 rounded-lg shadow-lg"
     : "w-full rounded-sm shadow-sm"
   ```
**Prevention**:
- Ask user: "Should this appear before [X] or after [Y]?" — never assume
- Inline elements should feel part of the page, not overlay-like
- Consider the visual weight hierarchy: floating = prominent, inline = integrated

### Feature Consistency Across Multi-Screen Flows
**Added**: 2025-11-26
**Problem**: Feature added to some screens but missing from others
**Prevention**: Create checklist of ALL screens before implementing:
```markdown
- [x] Welcome screen
- [x] Mic check screen
- [x] Instructions screen
- [x] Test screen ← Easy to miss
- [x] Complete screen
```

### Navigation Integration Requirements
**Added**: 2025-01-04
**Context**: Moodboard navigation task revealed critical gap in planning navigation integrations
**Problem**: Agent planned standalone navigation components instead of integrating with existing layout system
**Solution**: Always analyze existing navigation architecture before planning new navigation features
**Prevention**: Search for existing navigation components first and plan integration rather than replacement

### UI Constraint and Space Analysis
**Added**: 2025-01-13
**Context**: Cards/List Toggle task required multiple layout iterations
**Problem**: Agent planned features without analyzing available space and existing UI element constraints
**Solution**: Always analyze layout constraints and space allocation before planning UI additions
**Prevention**:
1. Container Space Analysis: Measure available horizontal/vertical space
2. Existing Element Priority: Identify essential vs. moveable elements
3. Label Length Planning: Plan for shortened labels in constrained spaces

### Full-Bleed Canvas Layouts Need Floating Navigation Triggers
**Added**: 2026-01-29
**Context**: Converting a page to full-bleed canvas — hiding AppHeader for full-bleed DAG canvas removed the sidebar trigger
**Problem**: When a page hides the AppHeader to achieve a full-bleed canvas layout (e.g., React Flow graph filling the viewport), the normal SidebarTrigger in the header disappears, leaving users with no way to open the sidebar for navigation.
**Solution**: Add a floating `SidebarTrigger` (e.g., `fixed top-4 left-4 z-50`) so users can always access sidebar navigation even when the header is hidden. Use the `isFullBleed` pattern in the parent layout to conditionally hide the header and add the floating trigger.
**Prevention**:
1. Whenever planning a full-bleed or canvas-style layout, check if removing the header removes navigation access
2. Add floating trigger for sidebar access as part of the full-bleed implementation
3. Use a layout-level flag (`isFullBleed`) so the pattern is reusable across future canvas views

**Example**:
```tsx
// Parent layout ([parent-layout].tsx)
const isFullBleed = location.pathname.includes('/[canvas-route]')

return (
  <>
    {!isFullBleed && <AppHeader />}
    {isFullBleed && <SidebarTrigger className="fixed top-4 left-4 z-50" />}
    <main className={isFullBleed ? "h-screen" : "overflow-y-auto"}>
      <Outlet />
    </main>
  </>
)
```

---

## Animations

### CSS Animation vs React State
**Added**: 2025-10-01
**Decision Tree**:
1. Continuous Motion: CSS @keyframes with transform, infinite duration
2. User-Triggered: React state with transition classes
3. Data-Driven: React state with conditional rendering
4. Performance-Critical: Always prefer CSS for 60fps

### Text Animation Layout Strategy
**Added**: 2025-10-01
**Problem**: Width-based animations cause text clipping
**Solution**: Use height-based animations with overflow handling
```css
max-h-0 → max-h-20 + overflow-hidden
```

### Proximity Detection Simplification
**Added**: 2025-10-01
**Problem**: Complex mouse tracking when simple hover was sufficient
**Guideline**: Start with simplest interaction pattern, add complexity only when validated

### Animation Implementation Approach Analysis
**Added**: 2025-10-01
**Context**: Logo Carousel task required multiple iterations due to wrong animation approach
**Problem**: Agent chose fade in/out animation instead of continuous scrolling
**Solution**: When users describe continuous motion, analyze movement patterns before selecting animation technique
**Prevention**: Parse animation descriptions for keywords like "continuous", "scrolling", "running" to select appropriate techniques

### Animation Speed and User Control Planning
**Added**: 2025-10-01
**Context**: Logo Carousel required multiple speed adjustments
**Problem**: Didn't plan for user interaction effects on animation speed
**Solution**: For animated elements with user interaction, plan specific speed values and interaction effects upfront
**Prevention**: Specify exact timing values and interaction effects rather than vague "speed up on hover" descriptions
- Base Animation Speed: Specific duration values (e.g., 8 seconds for full cycle)
- Interaction Speed Modifiers: Exact multipliers for hover, proximity, focus states

### Entry Animation Pattern with tw-animate-css (No Framer Motion)
**Added**: 2026-01-15
**Context**: Processing View needed entry animations when navigating from Workflow screen
**Problem**: Agent 8 Animation protocol references Framer Motion spring physics, but project uses tw-animate-css (Tailwind CSS animations plugin)
**Solution**: Use Tailwind's `animate-in` utility with directional slide classes for entry animations
**Prevention**:
1. Check package.json for animation library BEFORE implementing — look for `framer-motion` vs `tw-animate-css`
2. tw-animate-css provides: `animate-in`, `fade-in-0`, `slide-in-from-{direction}-{distance}`, `duration-{ms}`, `delay-{ms}`, `ease-out`
3. Stagger panels with `delay-150` for professional "unfolding" effect

**Example**:
```tsx
// ❌ Wrong - Framer Motion not installed
<motion.div
  initial={{ x: -20, opacity: 0 }}
  animate={{ x: 0, opacity: 1 }}
  transition={{ type: 'spring', stiffness: 400 }}
>

// ✅ Correct - tw-animate-css classes
<div className="animate-in slide-in-from-left-4 fade-in-0 duration-500 ease-out">
  {/* Content */}
</div>

// ✅ Staggered panels
<div className="animate-in slide-in-from-left-4 duration-500 ease-out">
  {/* Left panel - no delay */}
</div>
<div className="animate-in slide-in-from-right-4 duration-500 delay-150 ease-out">
  {/* Right panel - 150ms delay */}
</div>
```

### Spring Physics Reference (Framer Motion)
**Added**: 2025-12-27
**Context**: A reference project established consistent spring values for premium motion feel
**Problem**: Arbitrary spring values lead to inconsistent motion feel across features
**Solution**: Use established spring values from `motion-patterns.md` reference
**Prevention**: Check motion-patterns.md before implementing any spring animations

**Quick Reference** (full details in motion-patterns.md):
| Element | Spring Values | Notes |
|---------|---------------|-------|
| Avatar/card entry | `spring(350, 15)` | Bouncy, with initial rotate + scale |
| Text reveal | `spring(200, 20)` | Smooth y-slide, stagger 0.1s |
| Button entry | `spring(400, 25)` | Quick pop |
| Button tap | `scale: 0.92, duration: 0.05` | HARD snap, no soft ease |
| Sheet/modal | `spring(300, 30)` | y: '100%' → '0%' |

**Duration Rules**:
- Transitions: 150-300ms
- Stagger: 0.08-0.1s between elements
- Ambient: 4-7s cycles (varied per element to prevent sync)

---

## Data & APIs

### UI Data Display Validation
**Added**: 2025-09-03
**Problem**: Wrong object structure assumed (branch.branchMetadata?.branchName vs branch.branchName)
**Solution**: Verify actual data structure in database queries before implementing UI

### HTML Entity Decoding in API Routes
**Added**: 2025-10-01
**Problem**: RSS feed displayed &#8217; instead of apostrophes
**Solution**: Always decode HTML entities when fetching external content
```typescript
.replace(/&#8217;/g, "'")
.replace(/&#8220;/g, '"')
.replace(/&#8221;/g, '"')
.replace(/&apos;/g, "'")
```

### Database Schema for Multi-Mode Features
**Added**: 2025-01-05
**Problem**: is_text_mode field discovered retroactively
**Prevention**: Plan database structure upfront for features with multiple modes

### Dynamic vs Static Content Planning
**Added**: 2025-10-01
**Context**: Newsletter CTA expected dynamic content from external source (Substack RSS)
**Problem**: Agent didn't clarify whether content should be static examples or dynamically fetched
**Solution**: Always specify data source expectations - static, dynamic, API, RSS, mock data, etc.

### AI Studio MCP File Type Limitations
**Added**: 2026-01-08
**Context**: Using `mcp__aistudio__generate_content` with Gemini 3 Pro for visual analysis
**Problem**: Markdown (.md) files cause `Unsupported MIME type: application/octet-stream` error
**Solution**:
- **Images (PNG, JPG)**: Send as file attachments ✅
- **Code files (TSX, TS)**: Send as file attachments ✅
- **Markdown files**: Embed content directly in `user_prompt` text ❌ (don't attach)
**Prevention**: When calling AI Studio MCP, never include .md files in the `files` array. Read the markdown content and include it as text in the prompt instead.

### React Flow Height Requirements
**Added**: 2026-01-06
**Context**: Visual Consistency task - workflow canvas showing blank on Orchestration, Agents, Synthesis phases
**Problem**: React Flow nodes not rendering despite correct data. Used `min-h-[500px]` for container.
**Solution**: React Flow requires explicit height (`h-[500px]`), not min-height (`min-h-[500px]`)
**Prevention**: Always use explicit height for React Flow containers, never min-height

**Example**:
```tsx
// ❌ Wrong - React Flow won't render nodes
<div className={cn('w-full min-h-[500px] bg-white', className)}>
  <ReactFlow nodes={nodes} edges={edges} ... />
</div>

// ✅ Correct - explicit height makes React Flow render properly
<div className={cn('w-full h-[500px] bg-white', className)}>
  <ReactFlow nodes={nodes} edges={edges} ... />
</div>
```

### Time Estimation for Parallel Processing Systems
**Added**: 2026-01-15
**Context**: A summary card displayed "~91 hours" for full scope instead of ~2 hours
**Problem**: `calculateEstimatedTime()` was SUMMING individual task times (27 × ~3.4 = 91), but workers/agents run in PARALLEL, not sequentially
**Solution**: Use a formula that accounts for concurrency:
```typescript
// ❌ Wrong - sequential sum (91 hours for 27 categories)
return categoryIds.reduce((total, id) => total + category.estimatedDays, 0)

// ✅ Correct - parallel formula (2 hours for 27 categories)
const baseTime = 0.5
const perCategory = 0.055  // Small overhead per task
const rawTime = baseTime + (categoryIds.length * perCategory)
return Math.min(Math.round(rawTime * 2) / 2, 3)  // Cap at 3 hours
```
**Prevention**: When displaying time estimates for systems with parallel task execution:
1. Check if tasks run concurrently (agents, workers, threads)
2. If parallel: use max(task times) + overhead, NOT sum
3. Validate against known benchmarks (e.g., preset data showing full scope = 2 hours)

---

## Component Patterns

### Drawer Mode Guard Must Include All Valid Modes
**Added**: 2026-01-29
**Context**: Trust indicators overhaul — "Ask in chat" button closed the drawer instead of transitioning
**Problem**: `[drawer-component].tsx` had a `hasContent` guard that checked for `inspectData` and `allSourcesMode` but didn't include `mode === "chat"` as a valid content state. When switching from inspect to chat mode, the guard returned false and the drawer closed.
**Solution**: Added `|| mode === "chat"` to the hasContent condition. Any mode that should keep the drawer open must be explicitly included in the guard.
**Prevention**: When adding new drawer modes or mode transitions, always check the content guard in the parent drawer component. Guard conditions that enumerate valid states will break when new states are added.

### Clickable Badge Pattern — onClick + cursor-pointer on Tooltip-Wrapped Elements
**Added**: 2026-01-29
**Context**: Trust indicators overhaul — confidence badge needed to be clickable to open evidence drawer
**Problem**: [BadgeComponent] was wrapped in a Tooltip with `cursor-help`. Adding onClick required changing the wrapper from `<span>` to `<button>` and swapping the cursor.
**Solution**: Accept optional `onClick` prop. When present, render as `<button type="button" onClick={onClick} className="cursor-pointer">` wrapping the content (inside TooltipTrigger if tooltip exists). When absent, keep `<span className="cursor-help">` for tooltip-only behavior.
**Prevention**: Design badge/indicator components with optional `onClick` from the start. When a component has both tooltip and click behavior, the click target should be a `<button>` for accessibility, not a `<span>` or `<div>`.

### Backward-Compatible Optional Props for Incremental Feature Rollout
**Added**: 2026-01-29
**Context**: Trust indicators overhaul — adding confidence data to existing insight/finding interfaces
**Problem**: New features (confidence levels, rejected sources) needed to be added to existing data interfaces without breaking components that don't have the data yet (e.g., other report types).
**Solution**: All new fields added as optional (`confidence?: ConfidenceData`, `rejectedSources?: RejectedSource[]`). Components check for presence before rendering: `{confidence ? <[BadgeComponent] /> : <[FallbackBadge] />}`. This allows incremental rollout — only enhanced data shows confidence while other data types gracefully fall back.
**Prevention**: When adding new data dimensions to existing interfaces, always make them optional. Design the rendering components with fallback behavior for when the data is absent.

### Discriminated Union for Multi-Type Unified Tables
**Added**: 2026-01-30
**Context**: Unified table — merging two entity types (e.g., TypeA and TypeB) into one table
**Problem**: Two data types with different fields (TypeA has `companyName`, `updatedAt`, `metrics`; TypeB has `name`, `deliveredAt`, `analysts`) need to display in a single table. Direct union creates type narrowing issues and empty-cell problems.
**Solution**: Create a discriminated union with a shared base interface and `itemType: 'typeA' | 'typeB'` discriminator. Normalize display-facing fields (`displayName`, `updatedAt`) during merge. Use `analysts?: undefined` on TypeA so TypeScript allows field access without narrowing.
**Prevention**: When merging two entity types into one view, always create a dedicated union type with a discriminator field. Normalize display fields at merge time, not render time. Mark cross-type fields as `fieldName?: undefined` on the type that doesn't have them.

### Background Implementation Fallback
**Added**: 2025-10-01
**Problem**: SVG background failed to load
**Strategy**:
1. CSS Primary: Start with CSS gradients that always work
2. Asset Enhancement: Add SVG/image as enhancement layer
3. Graceful Degradation: Ensure CSS fallback is complete

### ScrollArea Implementation
**Added**: 2025-09-02
**Problem**: ScrollArea without proper height context
**Solution**:
```typescript
// ❌ Wrong
<div className="flex-1">
  <ScrollArea><Content /></ScrollArea>
</div>

// ✅ Correct - min-h-0 allows flex shrinking
<div className="flex-1 min-h-0">
  <ScrollArea className="h-full"><Content /></ScrollArea>
</div>
```

### Hover State Flashing Fix
**Added**: 2025-01
**Problem**: Overlay blocks mouse events causing rapid flashing
**Solution**: Add `pointer-events-none` to overlay

### Brand Logo/Icon Implementation from Reference Images
**Added**: 2026-01-15
**Context**: Multi-Model Verification Indicators task — user provided brand logo PNGs, agent created invented approximations instead of matching actual logos
**Problem**: When implementing brand icons (Claude, Gemini, ChatGPT), agent made up generic shapes instead of matching user-provided reference images. User had to correct multiple times.
**Root Cause**: Agent treated reference images as "inspiration" rather than exact specifications to match.
**Solution**:
1. **View reference images BEFORE writing any SVG code** — use Read tool on provided PNGs
2. **Match the actual logo shape exactly** — don't create "simplified versions" or "approximations"
3. **For complex logos, describe what you see** before coding: "12 tapered rays from center" not "starburst"
4. **After implementation, compare visually** — take screenshot and verify against reference
**Prevention**:
- When user provides brand logo files, those ARE the specification
- Never invent icon shapes when references are provided
- Ask for reference images if implementing brand icons without them
- Brand recognition requires accuracy — close enough is not good enough

### Tooltip Reliability
**Added**: 2025-01
**Problem**: Standard Tooltip fails in complex hover layouts
**Solution**: Use HoverCard pattern instead

### Multi-File Component Cleanup
**Added**: 2025-01
**Problem**: Compilation errors from dangling imports after component deletion
**Prevention**:
1. Search entire codebase for component references
2. Remove all imports in all files
3. Run compilation check immediately after cleanup

### Existing Component Discovery Requirements
**Added**: 2025-01-09
**Context**: AI Generation Card task failed due to creating new components instead of modifying existing ones
**Problem**: Agent created entirely new component instead of identifying and modifying existing UnifiedPromptCard
**Solution**: Always examine the target page/route thoroughly to identify existing components before planning
**Prevention**: Use explicit component discovery process:
1. Visit the target URL mentioned in the request
2. Examine page source and components to identify existing implementations
3. Search codebase for related component files
4. Verify modification vs creation approach - prefer extending existing components

### Chat UI Patterns (Typewriter, Typing Indicator)
**Added**: 2025-12-27
**Context**: A reference project chat interface required specific animation patterns
**Problem**: Chat interfaces need coordinated animations for natural feel
**Solution**: Use proven patterns for chat UI elements

**Typewriter Effect**:
```typescript
function TypewriterText({ text, speed = 18, onComplete }) {
  const [displayedText, setDisplayedText] = useState('')
  const [currentIndex, setCurrentIndex] = useState(0)

  useEffect(() => {
    if (currentIndex < text.length) {
      const timeout = setTimeout(() => {
        setDisplayedText((prev) => prev + text[currentIndex])
        setCurrentIndex((prev) => prev + 1)
      }, speed)
      return () => clearTimeout(timeout)
    } else if (onComplete) {
      onComplete()
    }
  }, [currentIndex, text, speed, onComplete])

  return <p>{displayedText}</p>
}
```

**Typing Indicator (Dots)**:
```typescript
{[0, 1, 2].map((dot) => (
  <motion.div
    key={dot}
    className="w-3 h-3 bg-gray-400 rounded-full"
    animate={{ opacity: [0.4, 1, 0.4] }}
    transition={{
      duration: 1,
      repeat: Infinity,
      delay: dot * 0.2,
      ease: 'easeInOut',
    }}
  />
))}
```

**Chat Bubble Entry**:
```typescript
<motion.div
  initial={{ y: 30, scale: 0.9, opacity: 0 }}
  animate={{ y: 0, scale: 1, opacity: 1 }}
  transition={{ type: 'spring', stiffness: 400, damping: 30 }}
>
  <ChatBubble />
</motion.div>
```

---

## TypeScript Patterns

### Optional Chaining Validation
**Added**: 2025-01-09
**Problem**: Array.find() returns T | undefined but code expected T | null
**Solution**:
```typescript
// ❌ Wrong
const model = models.find(m => m.id === id);

// ✅ Correct
const model = models.find(m => m.id === id) ?? null;
```

### DropdownMenuContent Props
**Added**: 2025-01
**Problem**: Invalid props on DropdownMenuContent
**Solution**: onOpenChange, open, defaultOpen go on parent DropdownMenu, not Content

### Interactive CLI Component Installation
**Added**: 2025-01-09
**Problem**: CLI prompts block automation
**Solution**: Check component existence before installation, skip existing

### Override Shared Component Defaults via className Prop
**Added**: 2026-01-29
**Context**: Renaming a feature section — [GraphComponent] has internal `h-[700px]` used by 4 consumers across multiple pages
**Problem**: Temptation to change a shared component's internal height to `h-full` to fit one consumer's layout, which would break the other 3 consumers that rely on the fixed height default.
**Solution**: Pass `className="h-full"` from the parent that needs the override. The shared component should use `cn("h-[700px]", className)` so the caller's class merges/overrides the default via Tailwind's `cn()` utility.
**Prevention**:
1. Before modifying a shared component, check how many consumers use it (`grep -r "ComponentName" --include="*.tsx"`)
2. If multiple consumers exist, override via `className` prop from the specific parent that needs different behavior
3. The shared component keeps its safe default; callers opt in to overrides

**Example**:
```tsx
// Shared component (DO NOT CHANGE the default)
function [GraphComponent]({ className }: { className?: string }) {
  return <div className={cn("h-[700px]", className)}>...</div>
}

// Consumer A (uses default 700px) — untouched
<[GraphComponent] />

// Consumer B (needs full height) — override via className
<[GraphComponent] className="h-full" />
```

---

## Success Patterns

### Unified table — Full Pipeline with Stakeholder-Driven UX Refinement (Visually Verified)
**Added**: 2026-01-30
**Context**: Unified table — merging two separate dashboard sections into one unified table with search and tabs, driven by stakeholder presentation feedback
**Success Factors**:
- Agent 0 (design-0-refine) ran 4-perspective UX analysis that unanimously agreed on removing TYPE column and merging Analysts into Name cell — zero debate on core decisions
- Agent 2 caught 8 implementation gaps (ut mode, date unification, null sort, name normalization, file size, archived scope, TooltipProvider, header consolidation) — all had clear resolutions
- Agent 3 found 4 design language conflicts (tab style, badge shape, input corners, tab color) before Agent 4 started — prevented visual inconsistency
- Agent 3 corrected Agent 2's R7 (TooltipProvider already provided by SidebarProvider) — review layers catch each other's errors
- Proactive component extraction (5 files) kept all files under 250 lines despite significant feature addition
- User's manual visual verification passed without requiring any fixes
**Key Insight**: When stakeholder feedback provides clear direction ("just one table with search"), the 4-perspective UX analysis adds the most value in simplifying further (removing columns, merging inline) rather than debating the core decision.

### Multi-Perspective UX Analysis Prevents CSS Spec Conflicts
**Added**: 2026-01-30
**Context**: Report summary "View All Findings" link — 4-perspective UX analysis (design-0-refine) produced a plan with `font-medium` and `py-2.5` CSS specs. Agent 3 Discovery caught that these conflicted with existing design language (`py-2`, no font-medium on navigation links).
**Success Factors**:
- Agent 0 (design-0-refine) produced high-confidence UX decisions where all 4 perspectives agreed
- Agent 3 Discovery independently verified CSS against actual codebase files and overrode the plan specs
- The override was respected by Agent 4 — no visual inconsistency in final implementation
**Prevention**: Always verify UX plan CSS specs against actual codebase patterns in Agent 3. UX perspectives propose ideal styling; Discovery grounds it in reality.

### Conditional-to-Always-Visible: Export Shared Constants for DRY
**Added**: 2026-01-30
**Context**: Converting a "show more" link from conditional to always-visible required a parent page to also use a category-to-section mapping (previously internal to the link component) for looking up item counts.
**Problem**: Two files need the same category-to-section ID mapping. Duplicating violates DRY.
**Solution**: Export the existing mapping constant from the component file. Single source of truth, zero duplication.
**Prevention**: When a constant is used by a component AND its parent for related logic, export it from the component file rather than duplicating.

### Domain Alignment — User Testing Evidence Drove Zero-Debate Decisions
**Added**: 2026-01-29
**Context**: Category alignment task — restructuring from signal types to domain categories
**Success Factors**:
- Strong user testing evidence (9 users, 3 ICP explicitly requesting domain categories) made the core decision unambiguous
- Preserving signal types as tags satisfied the one ICP user who validated them
- Agent 2 review caught 7 implementation issues before Agent 4 started (navigation links, hardcoded ID checks, search cleanup, data-type-specific insights, hex values, clarification answers)
- Agent 3 discovery found 3 design language conflicts (blue collision, badge borders, question badge color) and resolved them before implementation
- 12-file change across mock data, routes, and components compiled cleanly on first pass
- Post-implementation refinements (visual de-clutter) completed via Agent 0 quick workflow without touching the core structural changes

### Trust indicators overhaul — 5 Sub-Features via Full Agent Pipeline (Score 9/10)
**Added**: 2026-01-29
**Context**: Trust indicators overhaul — 5 interconnected sub-features (confidence badges, remove chat, confidence narrative, rejected sources, ask-in-chat) implemented via Agents 2-5
**Success Factors**:
- Comprehensive plan with detailed mock data narratives (7 confidence stories) eliminated ambiguity during execution
- Agent 2 review caught 8 technical issues before execution (direct [BadgeComponent] in [CardComponent], missing [DrawerComponent] passthrough, file size concerns, indicator props gap)
- Agent 3 discovery verified all 12+ file paths, confirmed all dependencies available (no installations needed), documented exact line numbers for removal targets
- Backward-compatible optional props (`confidence?`, `rejectedSources?`) allowed other data types to gracefully fall back without changes
- Component extraction (sub-components extracted to separate files) kept the main panel under 250 lines
- Agent 5 caught 2 functional bugs (drawer guard, collapsed-by-default) and fixed both in single iterations
- Post-pipeline quick fix (confidence badge clickable to open drawer) was a clean 2-file change

### Zero-Iteration Implementation Factors
**Added**: 2025-01-09 (Moody Characters task)
**Success Factors**:
- Complete requirements documentation with all features specified
- Proper component reuse strategy verified before implementation
- Systematic architecture planned and executed
- Comprehensive TypeScript interfaces
- Proper workflow compliance

### Multi-Page Form Flow Success Pattern
**Added**: 2025-12-21 (Onboarding)
**Success Factors**:
- Used shadcn MCP to verify/install required components (radio-group, separator)
- Added public routes to middleware for unauthenticated access
- Client components (`'use client'`) for pages with interactivity
- Server components for static content pages
- Controlled form state with validation-based button enabling
- Print-to-PDF via `window.print()` for simple invoice download

### Successful Landing Page MVP Pattern
**Added**: 2025-01-20
**Key Practices**:
1. Load ALL sections from task file
2. Use todo list tracking all sections
3. Run build immediately after implementation
4. Fix ESLint issues proactively
5. Correctly update status.md workflow

### Foundation/Design Token Implementation Success
**Added**: 2026-01-06 (Foundation/Step 0)
**Success Factors**:
- Comprehensive plan with exact CSS token values from project design system docs
- Technical Discovery (Agent 3) verified ALL dependencies before execution
- Clear build order specified: CSS tokens → StatusBadge → DotGridBackground → PhaseCard → Animations
- Followed existing component patterns (cva + cn from badge.tsx)
- Foundation work recognized as not needing visual verification (no UI to screenshot)
- Todo list tracked all 7 implementation steps
- Build verification run immediately after implementation

**Key Insight**: For infrastructure/foundation tasks, skip Agent 5 visual verification when there's no rendered UI to test. Move directly to Complete after build passes.

### Zero-Iteration UI Component Implementation
**Added**: 2026-01-06 (AppHeader)
**Success Factors**:
- User-provided reference images with annotated purposes (layout-reference, component-reference)
- Plan included exact CSS values from project design system docs (h-14, px-6/lg:px-12, border-b)
- Agent 2 refinements were specific and actionable (text-xs vs text-sm for avatar proportion)
- Technical Discovery validated approach decision (custom vs shadcn installation)
- Implementation followed plan exactly without deviation
- Accessibility included from start (aria-label, type="button")

**Key Insight**: When users provide reference images with clear purpose annotations AND the plan includes exact CSS classes/values, zero iterations are achievable. The combination of visual direction + technical specificity eliminates guesswork.

**Pattern for Future Tasks**:
1. Request/gather reference images with purpose annotations
2. Extract exact values from design system (not approximate)
3. Include Agent 2 refinements as specific modifications
4. Validate technical approach in Discovery before execution
5. Follow plan exactly - don't improvise

### Comprehensive Panel/Sidebar Implementation Success
**Added**: 2026-01-06 (Sources Panel)
**Success Factors**:
- Detailed visual specs from AI analysis (Gemini Pro 3) including exact Tailwind classes and pixel values
- Clear visual metaphor documented ("Sheet on Desk" - panel on gray bg outside white content)
- Phased implementation plan: Phase 1 (Core), Phase 2 (Interactivity), Phase 3 (Polish/stretch)
- Technical Discovery verified all shadcn components existed (Button, Input, Collapsible)
- Mock data pattern matched existing codebase conventions (interfaces → data → helpers)
- Agent 4 checked learnings.md before implementation
- Workflow compliance: Task correctly moved to Testing with manual test instructions

**Key Insight**: For complex panel/sidebar implementations, having AI-generated visual specs with exact CSS values (w-60, w-12, bg-gray-50, h-8, px-3, etc.) eliminates design guesswork. Combined with phased delivery, this enables clean first-pass implementation.

**Pattern for Panel/Sidebar Tasks**:
1. Document visual metaphor clearly (what sits where, why)
2. Include exact dimensions for open/collapsed states
3. Specify all interaction states (default, hover, selected)
4. Use phased approach: Core functionality first, interactivity second, polish as stretch
5. Verify existing UI component availability before planning custom work
6. Match mock data patterns to existing codebase conventions

### Consolidation/Refactor Task Success (UI Reorganization)
**Added**: 2026-01-06 (Action Items Section)
**Success Factors**:
- Task file included **exact code snippets** of what to move/replace (not just line numbers)
- All clarification questions resolved in Agent 2 phase BEFORE execution:
  - "What should clicking do?" → Console log for MVP
  - "Show empty state or hide?" → Hide entirely
  - "Remove from filter bar?" → Yes, single source of truth
- Technical Discovery identified **existing pattern to reuse** (ChevronRight hover animation from [CardComponent])
- Clear ASCII mockup of target UI in task file
- Strategic alignment documented (Q2/Q3 sprint goals, Maeda's ORGANIZE law)

**Key Insight**: For UI consolidation/refactor tasks, having the **actual source code** of elements being moved in the task file eliminates ambiguity. Combined with resolved clarification questions and identified reusable patterns, enables zero-iteration implementation.

**Pattern for Consolidation Tasks**:
1. Include exact code snippets of what's being moved/replaced (not just descriptions)
2. Resolve ALL clarification questions before execution (edge cases, empty states, removal scope)
3. Identify and document existing patterns to reuse for visual consistency
4. Include ASCII/wireframe of target state
5. Document strategic alignment (helps verify scope is correct)

### Command Palette / Search Integration Success
**Added**: 2026-01-06 (Command+K Search)
**Success Factors**:
- Technical Discovery verified shadcn command component existed in codebase
- Custom hook pattern (useCommandShortcut) kept keyboard logic separate from UI
- TanStack Router type-safe navigation required params syntax: `{ to: "/[route]/$itemId", params: { itemId: "demo-item" } }`
- Barrel exports (index.ts) for clean imports
- User feedback incorporated quickly: header layout adjusted from center search to right-aligned

**Key Insight**: For command palette implementations, the shadcn command component (cmdk) provides solid foundation. Keep keyboard shortcut logic in dedicated hook for reusability. User feedback on layout positioning is common - plan for flexibility.

**Pattern for Command Palette Tasks**:
1. Check for existing shadcn command component before installing
2. Create dedicated hook for keyboard shortcuts (testable, reusable)
3. Use Portal rendering for overlay to avoid z-index issues
4. TanStack Router: Always use params object for type-safe routes
5. Plan header layout with flexibility - user preferences vary on search positioning

### Visual Consistency Multi-Page Implementation
**Added**: 2026-01-06 (Visual Consistency)
**Success Factors**:
- Plan documented exact CSS patterns from project design system docs ("Border-Grid/Rails" metaphor)
- Agent 7 quick-fix workflow enabled rapid iteration on user feedback (4 fixes in one session)
- Explicit file-by-file verification checklist in task file caught all changes needed
- User screenshots identified issues that code review missed (blank canvas, styling mismatches)

**Key Insight**: For visual consistency tasks across multiple pages, having the **exact CSS pattern values** in the plan is critical. The "Rails" pattern (`bg-gray-100` outer + `max-w-7xl border-x border-gray-200 bg-white` inner) and section dividers (`border-b border-gray-200`) should be copy-paste ready.

**Pattern for Visual Consistency Tasks**:
1. Document exact CSS classes for each pattern, not just descriptions
2. Include file-by-file checklist with specific changes
3. Verify component library usage (React Flow, Card, etc.) for special requirements
4. Use Agent 7 quick-fix workflow for user-reported issues
5. Request screenshots from user to catch visual issues code review misses

### Multi-Page Placeholder/Demo Flow Success
**Added**: 2026-01-07 (User Journey Placeholder Pages)
**Success Factors**:
- Reusable wrapper component (JourneyPage) reduced code duplication across 14+ pages
- Content sourced directly from existing documentation files (user flow docs, planning docs)
- Workshop context pages (0a/0b/0c) set meeting agenda before diving into user journey
- Badge system (Sprint 1 green, Future gray, Workshop purple, Built blue) clearly communicated scope
- Back/Next navigation integrated into AppHeader actions slot
- Journey index page provided quick navigation for workshop facilitator

**Key Insight**: For demo/workshop flows with many placeholder pages, a reusable page wrapper component with standardized props (stepLabel, title, subtitle, description, details, navigation) enables rapid creation of consistent pages while allowing custom content where needed.

**Pattern for Workshop Demo Tasks**:
1. Create reusable page wrapper component with standardized props
2. Source content from existing documentation files rather than inventing new copy
3. Include setup/context pages BEFORE the main flow to set expectations
4. Use badge system to clearly show scope (what's built vs planned)
5. Provide index/overview page for non-linear navigation during workshops

### Design Simplification with A/B Comparison Success
**Added**: 2026-01-07 (Report Overview V2 Maeda Simplification)
**Success Factors**:
- New route (`/[route]/[item]-2`) preserved original for A/B comparison
- Gemini 3 Pro consultation provided specific CSS patterns for each Maeda law application
- Dependencies (tooltip, popover) identified and installed in Discovery phase
- V2 components named with `-v2.tsx` suffix for clear differentiation
- Systematic application of Maeda's Laws: REDUCE (remove filter tabs), ORGANIZE (visual hierarchy), TIME (inline content), TRUST (elevated action items)

**Key Insight**: When applying design simplification principles, creating a parallel V2 route allows safe experimentation while preserving the original for comparison. This enables user feedback on both versions during testing.

**Pattern for Design Simplification Tasks**:
1. Create new route for V2, don't modify V1 in place
2. Use AI consultation (Gemini 3 Pro) for specific CSS patterns
3. Name V2 components with consistent suffix (`-v2.tsx`)
4. Map each change to a specific design principle (Maeda's Laws, etc.)
5. Install dependencies during Discovery before execution

### Multi-Pattern Component Implementation Success
**Added**: 2026-01-08
**Context**: Detail screen implementing 5 reference app patterns with 8 new components
**Success Factors**:
1. **Visual pattern specifications with ASCII wireframes** — Task file included detailed wireframes for each pattern (Pattern 1: AI Insights, Pattern 4: Feasibility Ratings, Pattern 5: Card-based AI)
2. **Consistency checklist in task file** — Agent 2 added explicit checklist: sharp corners, border-based depth, CARD_TYPE_CONFIG colors, p-6 card padding, existing component imports
3. **Component implementation priority order** — Task specified build order: [RatingComponent] → [GridComponent] → [FactorsComponent] → [CardComponent] → [QuestionComponent] → differentiators
4. **Code pattern documentation** — [DrawerComponent] integration pattern included with state management code snippets
5. **Tailwind class mapping table** — Visual Reference Analysis mapped UI elements to exact Tailwind classes

**Key Insight**: For tasks implementing multiple visual patterns from external inspiration (reference app), include:
- ASCII wireframes showing structure (NOT exact CSS — wireframes are layout, not styling)
- Exact Tailwind class mappings for each UI element
- Component build order with dependencies
- Consistency checklist against existing design language
- Integration patterns with existing components ([DrawerComponent], [CardComponent] Accordion)

**Pattern for Multi-Pattern Tasks**:
1. Document each pattern with ASCII wireframe for STRUCTURE
2. Create Tailwind class mapping table for STYLING
3. Specify component build order with DEPENDENCIES
4. Add consistency checklist against EXISTING patterns
5. Include integration code SNIPPETS for complex interactions
6. Agent 3 Discovery verifies ALL shadcn components available before execution

### Card Height Consistency for Variable Content
**Added**: 2026-01-07
**Context**: Module Card Icon Cleanup task - cards with warning text were taller than cards without
**Problem**: Initial implementation didn't account for consistent card heights when some cards have optional content (warnings) and others don't, causing uneven grid appearance
**Solution**: Add `min-h-[200px]` (or appropriate value) to card containers when cards may have variable content
**Prevention**: For grid card layouts with optional content, always specify minimum height during planning to ensure visual consistency

**Example**:
```tsx
// ❌ Wrong - cards without warnings will be shorter
<div className={cn(
  "flex h-full flex-col p-6",
  hasConflict && "bg-orange-50/30"
)}>

// ✅ Correct - minimum height ensures consistent card sizing
<div className={cn(
  "flex h-full min-h-[200px] flex-col p-6",
  hasConflict && "bg-orange-50/30"
)}>
```

### Two-Level UI Layout Consistency
**Added**: 2026-01-08
**Context**: Processing View Refinements - [TreeComponent] terminal box was full width while Level 1 cards used max-w-5xl
**Problem**: User had to clarify whether terminal box should be full width or match the constrained layout of content above
**Solution**: Apply consistent `max-w-5xl mx-auto` wrapper to multi-level UI sections for cohesive column alignment
**Prevention**: When designing multi-level UIs, explicitly specify whether each level should use the same width constraint or have different widths. Default to matching the primary content width for visual cohesion.

**Example**:
```tsx
// ❌ Wrong - Level 2 full width while Level 1 is constrained
<section className="px-6 py-6">  {/* Level 1 - max-w-5xl */}
  <div className="mx-auto max-w-5xl">...</div>
</section>
<section className="px-6 py-6">  {/* Level 2 - full width */}
  <div className="overflow-hidden rounded-lg border">...</div>
</section>

// ✅ Correct - unified column width
<section className="px-6 py-6">  {/* Level 1 */}
  <div className="mx-auto max-w-5xl">...</div>
</section>
<section className="px-6 py-6">  {/* Level 2 - same constraint */}
  <div className="mx-auto max-w-5xl">
    <div className="overflow-hidden rounded-lg border">...</div>
  </div>
</section>
```

### Mock Data Cost Scaling for Realistic Values
**Added**: 2026-01-08
**Context**: Processing View trace tree showed ~$0.58 total cost, but realistic research costs are ~$100
**Problem**: Token-level mock costs from initial implementation don't match real-world research cost expectations
**Solution**: Scale mock data costs to reflect realistic operation costs. For research workflows using multiple AI models, costs should be in $10-100+ range, not cents.
**Prevention**: When creating mock data for AI/ML operations, consider the business context:
- Token-level costs (~$0.01-1): Individual API calls
- Task-level costs (~$1-10): Single research operations
- Workflow-level costs (~$50-500): Complete research/analysis workflows

**Example**:
```typescript
// ❌ Wrong - token-level costs don't match research workflow scale
{ label: 'workflow_orchestration', tokens: 920000, cost: 0.58 }

// ✅ Correct - costs scaled for realistic research workflow (~$100 total)
{ label: 'workflow_orchestration', tokens: 81060400, cost: 102.08 }
```

### Two-Tier Form Implementation Success
**Added**: 2026-01-08
**Context**: Onboarding Two-Tier Design implementation (Tier 1: Quick Start + Tier 2: Customize Your Settings)
**Success Factors**:
1. **Agent 2 Review** identified missing Select component (shadcn) before execution, preventing install-during-build issues
2. **Agent 3 Discovery** verified design language consistency — flagged using plain `div` instead of shadcn Card component to maintain sharp corners
3. **Agent 5 Visual Verification** caught remaining design system issues:
   - Background color: `bg-white` → `bg-gray-100` (Sheet on Desk metaphor)
   - Google button styling: Added explicit `bg-white` for crisp appearance
4. **Existing components reused**: shadcn Collapsible for expand/collapse animation worked perfectly for Tier 2 reveal

**Key Insight**: For form pages with expandable sections, the Collapsible component provides smooth animations without custom implementation. The design discovery phase correctly identified visual-technical reconciliation (sharp corners required plain div, not Card component).

**Pattern for Two-Tier Forms**:
1. Agent 2 Review: Check for missing form components (Select, Radio, etc.)
2. Agent 3 Discovery: Verify card styling matches existing production pages (sharp vs rounded)
3. Use shadcn Collapsible for expand/collapse sections
4. Agent 5: Verify background colors match app metaphor (Sheet on Desk = gray-100 outer, white inner)
5. GoogleIcon (or other brand icons) should use official colors with explicit SVG paths

### Landing Page with Expandable Technical Depth (Value Preview Pattern)
**Added**: 2026-01-08
**Context**: Value Preview landing page successfully combines simple CTA with progressively revealed technical depth.
**Success Factors**:
- Two-zone structure: Zone 1 (CTA) + Zone 2 (Content grid) per Maeda's REDUCE principle
- Metrics embedded on cards (tokens, cost, time saved) — shows differentiation without explaining
- "How" button expands unified dark "Control Center" panel with stats + full trace
- Selected card transitions to dark theme, visually connecting to expanded panel
- [TreeComponent] component reused from Processing View for technical execution details
- Connected grid borders (`border-l border-t` on grid, `border-b border-r` on cards) per [CardComponent] pattern
- File headers document design rationale (e.g., "Clean, minimal design with neutral colors like reference app")

**Key Insight**: For landing pages showing "value before signup", the pattern of (clean CTA → feature cards with metrics → expandable technical depth) works well. The key is making the technical depth OPTIONAL via progressive disclosure, not mandatory viewing.

**Pattern for Similar Tasks**:
1. Start with Maeda REDUCE — 2 zones max for landing pages
2. Embed differentiation metrics ON the cards, not in separate explanation sections
3. Use tooltips for metric explanations (hover reveals meaning)
4. "How" or "Details" actions should expand unified panel, not navigate away
5. Unified dark theme for technical depth signals "you're looking under the hood"
6. Reuse existing trace/technical components when available

### Text Selection Tooltip / Browser API Integration Success
**Added**: 2026-01-09
**Context**: Detail drawer text selection tooltip — implementing ChatGPT-style text selection pattern
**Success Factors**:
1. **Agent 2 caught styling inconsistency early** — Original plan suggested `rounded-lg + shadow-sm`, but review with AI Studio MCP found codebase uses `rounded-md + shadow-md` for interactive floating elements (Popover pattern)
2. **Agent 3 verified design language against actual code** — Read real component files (popover.tsx, button.tsx, tooltip.tsx) to confirm styling patterns
3. **Agent 4 signed design verification** — Explicit "SIGNED: I have compared my planned CSS to existing page code and they MATCH" in execution notes
4. **Browser Selection API selected correctly** — Native `window.getSelection()` API with `getRangeAt(0).getBoundingClientRect()` for tooltip positioning
5. **Portal pattern for z-index** — `createPortal` to body element avoided stacking context issues
6. **Provider pattern for state management** — TextSelectionProvider context cleanly manages tooltip + drawer state across wrapped content

**Key Insight**: For floating UI elements (tooltips, popovers), the discovery phase MUST compare planned styling against existing floating elements in the codebase, not just cards/containers. Interactive floating elements follow different patterns than structural cards.

**Pattern for Browser API Tasks**:
1. Agent 2: Compare styling to existing FLOATING elements (Popover, Tooltip, Command)
2. Agent 3: Verify browser API compatibility and positioning approach
3. Use Portal rendering for any floating element that needs to escape parent overflow
4. Provider pattern when multiple components share selection/drawer state
5. Include dismissal patterns: Escape key, click outside, action completion

### Maeda Radical Card Simplification Success
**Added**: 2026-01-15
**Context**: Detail card simplification — applying Maeda's Laws across [CardComponent], [QuestionComponent], LimitationsSection
**Success Factors**:
1. **Single reference pattern identified** — [CardComponent] provided exact Maeda Radical layout to replicate (dot + title + timeframe + chevron)
2. **CARD_TYPE_CONFIG reuse** — Used existing config for dotColor, borderColor, labelColor consistency across all card types
3. **TIME_HORIZON_LABELS lookup** — Converted numeric ratings (1-5) to human-readable strings without duplicating data
4. **Container pattern fix** — [QuestionComponent] changed from full border to border-l-4 pattern to match [CardComponent]
5. **LimitationsSection streamlined** — Section-level count replaced per-item badges (Maeda REDUCE)

**Key Insight**: When simplifying multiple related components, identify ONE reference component ([CardComponent]) and systematically replicate its exact pattern to all others. Use existing config objects (CARD_TYPE_CONFIG) for color consistency.

**Pattern for Card Simplification Tasks**:
1. Identify the best existing implementation as reference pattern
2. Map config object properties to each component type
3. Collapsed state: dot + title + metadata + chevron (single-line)
4. Expanded state: type label, full description, supporting data
5. Remove per-item visual noise in favor of section-level indicators

### TanStack Router Search Params Success
**Added**: 2026-01-15
**Context**: Structure Preview Research Summary — passing form data between pages
**Success Factors**:
1. **First validateSearch usage in codebase** — Established pattern for future search param validation
2. **Type-safe search params** — Interface for url/name/fileNames with undefined handling
3. **Smart fallbacks** — `displayName` from search params OR hardcoded fallback for demo
4. **Edge case handling** — Component gracefully handles all combinations (0 docs, no URL, both, neither)
5. **Navigation preservation** — "Add more documents" navigates back to the previous form page with params preserved

**Key Insight**: TanStack Router's `validateSearch` + `Route.useSearch()` pattern is cleaner than URL query strings for passing structured data between pages. Great for multi-step flows where previous form data needs to be displayed.

**Pattern for Multi-Page Data Flow**:
1. Define interface for search params with optional fields
2. Use validateSearch to cast types from Record<string, unknown>
3. Access via Route.useSearch() for type-safe values
4. Provide sensible fallbacks for demo/direct navigation scenarios
5. Preserve params when navigating back via navigate({ search: { ...currentSearch } })

### Progressive Discovery UX Pattern Success
**Added**: 2026-01-15
**Context**: Text Selection Discoverability — implementing hint banner, cursor cues, persistent highlight
**Success Factors**:
1. **Layered discovery** — Banner (first-time), cursor (always), highlight (contextual) provide multiple paths to feature understanding
2. **Generic localStorage hook** — `useFirstTimeHint(key)` reusable for any future first-time hints
3. **Overlay highlight pattern** — Fixed position overlay more robust than browser selection (which clears on any click)
4. **Drawer state observation** — useEffect watching `open` state to clear highlight on close
5. **Visual theme consistency** — Banner, highlight, and drawer all use blue accents for cohesion

**Key Insight**: For hidden features (like text selection → evidence), implement discovery at multiple levels. First-time users need explicit education (banner), but the feature should also be discoverable through interaction cues (cursor, hover states).

**Pattern for Feature Discoverability Tasks**:
1. Create reusable localStorage hook for first-time hints
2. Banner: Blue info style, dismissible, localStorage persistence
3. Cursor cues: `cursor-text select-text` on interactive areas
4. Selection persistence: Use overlay div instead of browser selection
5. Match visual theme to related UI (drawer, tooltip, highlight all same color family)

### Mobile Flex-Column Layout: flex-1 vs h-full
**Added**: 2026-01-15
**Context**: Structure Preview mobile responsive layout — chat input scrolled with content instead of being fixed at bottom
**Problem**: Using `h-full` for children in flex-column layouts doesn't work on mobile without explicit parent height. Children try to be "100% of parent" but parent has no height set.
**Solution**: Use `flex-1` instead of `h-full` for children that should fill remaining space in flex-column layouts. `flex-1` (flex-grow: 1) expands to fill available space regardless of explicit parent height.
**Prevention**:
1. For mobile-responsive flex-column layouts, always use `flex-1` for content areas that should fill remaining space
2. Reserve `h-full` for when parent has explicit height or when in a non-flex context
3. Combine with `lg:flex-initial` when element should only flex on mobile, have fixed width on desktop

**Example**:
```tsx
// ❌ Wrong - h-full needs explicit parent height (fails on mobile)
<div className="flex flex-col">
  <header>...</header>
  <div className="h-full">  {/* Won't fill remaining space */}
    <ChatContent />
  </div>
</div>

// ✅ Correct - flex-1 fills available space in flex container
<div className="flex flex-col">
  <header>...</header>
  <div className="flex-1">  {/* Fills remaining height */}
    <ChatContent />
  </div>
</div>

// ✅ Responsive pattern - flex on mobile, fixed on desktop
<div className="flex w-full flex-1 flex-col lg:w-[400px] lg:flex-initial lg:border-r">
```

### Paired Navigation Button Styling Consistency
**Added**: 2026-01-15
**Context**: Graph Overlay "Back to chat" button initially styled as primary dark button, but user pointed out it should match the subtle "View Graph" button style
**Problem**: Bidirectional navigation buttons (A→B and B→A) with different visual weights create cognitive dissonance. If "View Graph" is a subtle gray row, "Back to chat" being a prominent dark button feels jarring.
**Solution**: Paired navigation actions should have matching visual styles. Both buttons should share: container style, icon treatment, metadata display, and hover behavior.
**Prevention**:
1. When implementing navigation that goes A→B, immediately plan the B→A return action with matching styling
2. Use mirrored icons: ChevronRight for "go forward", ChevronLeft for "go back"
3. Include the same metadata on both buttons (count, time estimate) for context continuity
4. If one button is subtle (`bg-gray-50 hover:bg-gray-100`), the paired button should match

**Example**:
```tsx
// "View Graph" button (Chat → Graph)
<button className="flex w-full items-center justify-between bg-gray-50 px-4 py-3 hover:bg-gray-100">
  <div className="flex items-center gap-2">
    <GitBranch className="size-4 text-gray-500" />
    <span className="text-sm font-medium text-gray-900">View Graph</span>
  </div>
  <div className="flex items-center gap-2 text-sm text-gray-500">
    <span>{count}</span>
    <span>•</span>
    <span>~{hours}h</span>
    <ChevronRight className="size-4" />  {/* Forward indicator */}
  </div>
</button>

// "Back to chat" button (Graph → Chat) - MATCHES the above
<button className="flex w-full items-center justify-between bg-gray-50 px-4 py-3 hover:bg-gray-100">
  <div className="flex items-center gap-2">
    <ChevronLeft className="size-4 text-gray-500" />  {/* Back indicator */}
    <span className="text-sm font-medium text-gray-900">Back to chat</span>
  </div>
  <div className="flex items-center gap-2 text-sm text-gray-500">
    <span>{count}</span>
    <span>•</span>
    <span>~{hours}h</span>
    <MessageSquare className="size-4" />  {/* Destination hint */}
  </div>
</button>
```

### Viewport-Height Layouts in Nested Router Outlets
**Added**: 2026-01-15
**Context**: Full-page chat layout — chat input wouldn't anchor to viewport bottom despite using `h-full` and `min-h-full`
**Problem**: TanStack Router's parent layout wraps `<Outlet />` in a scrollable container (`overflow-y-auto`) without explicit height propagation. Child routes using `h-full` or `min-h-full` don't fill the viewport because the parent `<main>` has no defined height — children try to be "100% of undefined".
**Solution**: Use `min-h-[calc(100vh-Xpx)]` where X is the header height to explicitly set viewport-relative height. Also use negative margins (`-mx-8`) to counteract parent padding if needed for edge-to-edge layouts.
**Prevention**:
1. When building full-viewport layouts (chat, dashboards) inside nested routes, check if parent propagates height
2. If parent has `overflow-y-auto` without explicit height, `h-full` won't work — use viewport calc instead
3. Pattern: `min-h-[calc(100vh-60px)]` for content that should fill viewport minus header
4. For inputs that should stay at viewport bottom, use flex-col with `flex-1` for content area

**Example**:
```tsx
// ❌ Wrong - parent outlet doesn't propagate height
<div className="flex h-full flex-col">  {/* h-full = 100% of nothing */}
  <ChatContent className="flex-1" />
  <ChatInput />  {/* Floats in middle, not at bottom */}
</div>

// ✅ Correct - explicit viewport-relative height
<div className="flex min-h-[calc(100vh-60px)] flex-col">
  <ChatContent className="flex-1" />
  <ChatInput />  {/* Stays at viewport bottom */}
</div>

// ✅ With parent padding compensation
<div className="-mx-8 flex min-h-[calc(100vh-60px)] flex-col">
  {/* Counteracts parent's px-8 padding for edge-to-edge */}
</div>
```

### Pattern-Based Mobile Responsive Implementation Success
**Added**: 2026-01-15
**Context**: Processing View Mobile Responsive — implementing mobile layout for processing page following structure-preview mobile pattern
**Success Factors**:
1. **Reference completed task** — Reading a completed task file from the done folder provided proven template with exact patterns
2. **Plan included exact line numbers** — Agent 2 verified line numbers against actual source code (341, 343, 502)
3. **Explicit differentiation documented** — Plan clearly stated WHY the new overlay component differs from the existing one (no auto-close, progress metrics)
4. **Learnings applied proactively** — Mobile flex-column, paired button styling patterns from learnings.md used without prompting
5. **Single iteration through all agents** — No rework needed, 9/10 visual score on first verification
6. **New component justified** — Option A vs Option B analysis with clear recommendation and reasoning

**Key Insight**: When implementing a feature similar to one already completed, read the completed task file as a template. The combination of (proven pattern + explicit differences + applied learnings) leads to zero-iteration implementation.

**Pattern for Similar Feature Tasks**:
1. Search the completed tasks folder for tasks with similar requirements
2. Read the full completed task file including Implementation Notes
3. Create new plan following the same structure, explicitly documenting differences
4. Reference learnings.md for patterns that apply
5. Verify plan accuracy in Agent 2 by comparing against actual source code
6. When creating variants of existing components, document WHY a new component vs extending existing

### Post-Implementation REDUCE Simplification Success
**Added**: 2026-01-16
**Context**: Onboarding & Customization Flow — removed focus areas checkboxes AFTER initial implementation was complete
**Success Factors**:
1. **User question triggered analysis** — "Should focus areas immediately affect the workflow graph?"
2. **Redundancy identified during discussion** — Focus areas (Step 1) and presets (Step 2) ask the same question in different packaging
3. **REDUCE principle applied** — If two UI elements serve the same purpose, remove one
4. **Clean removal** — Deleted FocusArea type, removed from hook, component, and props chain
5. **Documentation updated** — Testing plan, team presentation, status.md all updated to reflect change
6. **Build verification** — Confirmed build passes after removal

**Key Insight**: Post-implementation simplification is valid and valuable. Features that seem necessary during planning may reveal redundancy after implementation. The REDUCE principle applies not just to initial design but to ongoing refinement.

**Pattern for Post-Implementation Simplification**:
1. When user questions value of an element, analyze whether it duplicates another element
2. Apply REDUCE: "Does this add value that can't be achieved elsewhere?"
3. Remove cleanly: types → hooks → components → props → documentation
4. Update all related documentation (testing plans, status.md, presentations)
5. Verify build passes after removal
6. Document the REDUCE decision with clear rationale

**Decision Framework**:
| Question | Focus Areas (Step 1) | Presets (Step 2) |
|----------|---------------------|------------------|
| What do you care about? | Founder, Market, Tech, Capital | Team Focus, Market Focus, etc. |
| Immediate feedback? | None (graph unchanged) | Graph updates to show preset |
| Required? | Optional | Required for research |
| **Verdict** | ❌ REMOVE (redundant) | ✅ KEEP (primary mechanism) |

### Know When NOT to Add Features — REDUCE Applied Proactively
**Added**: 2026-01-16
**Context**: Report Details task — Limitations smart collapse reverted AFTER implementation
**Success Factors**:
1. **Multi-perspective analysis first** — 6 perspectives (3 Claude + 3 Gemini) analyzed options before implementation
2. **Implementation revealed reality** — With only 3-5 items, "+1 more" button added friction without reducing cognitive load
3. **User feedback caught it** — "This is just creating an unnecessary modification"
4. **Quick revert** — Removed useState, VISIBLE_COUNT, toggle logic, unused imports
5. **Documented reasoning** — Added to team-presentation.md under "What We Didn't Do (And Why)"

**Key Insight**: Progressive disclosure scales with content volume. Collapsing 3 items to show 2 is friction; collapsing 20 items to show 3 is helpful. Know the threshold where REDUCE means "add less code" not "add collapse logic."

**Pattern for Progressive Disclosure Decisions**:
| Content Volume | Action | Reason |
|----------------|--------|--------|
| 1-5 items | Show all | Collapse adds friction without benefit |
| 6-10 items | Optional collapse | Could help, test with users |
| 10+ items | Collapse or filter | Essential for scannability |
| 20+ items | Tabs or categories | Progressive disclosure + categorization |

**REDUCE Principle Clarification**:
- REDUCE doesn't always mean "add smart collapse"
- REDUCE can mean "don't add UI complexity when content is already manageable"
- Simplest solution for 3 items is showing 3 items

### isFullBleed Layout Pattern for Canvas Views
**Added**: 2026-01-29
**Context**: Converting a page to full-bleed canvas — needed full-viewport DAG canvas without AppHeader
**Success Factors**:
1. **Agent 2 critical correction** — Caught the plan to modify shared [GraphComponent] component (used by 4 consumers) and redirected to className override pattern
2. **Layout-level extensibility** — `isFullBleed` flag in parent layout ([parent-layout].tsx) conditionally hides AppHeader and adds floating SidebarTrigger, reusable for any future canvas view
3. **Minimal file changes** — Only 3 files modified (sidebar label, page component, parent layout) for a complete UX transformation
4. **User research driven** — Direct quote from user testing justified the change from process explanation to navigation tool

**Key Insight**: When converting a content page to a canvas/graph navigation view, the changes are primarily about removing framing chrome and adjusting layout constraints, not rebuilding the underlying visualization. The `isFullBleed` pattern makes this a reusable layout strategy.

**Pattern for Canvas View Tasks**:
1. Strip chrome from the page component (stats, alerts, footers) — keep only the visualization
2. Override shared component dimensions via className prop, never modify the shared component
3. Add isFullBleed flag to parent layout for header/trigger management
4. Use viewport-calc heights or flex-1 for full-height layouts inside overflow-y-auto parent chains
5. Always add floating navigation trigger when hiding the header

---

## Adding New Learnings

When Agent 6 captures a new learning, add it to the appropriate category using this format:

```markdown
### [Issue Title]
**Added**: [DATE]
**Context**: [What happened that caused the issue]
**Problem**: [Specific gap that caused iterations]
**Solution**: [Exact improvement]
**Prevention**: [How to prevent recurrence]

**Example** (optional):
```code
// Show before/after pattern
```
```

Categories to use:
- Workflow & Process
- CSS & Styling
- React Patterns
- Drag & Drop
- Interactions & UX
- Layout & Positioning
- Animations
- Data & APIs
- Component Patterns
- TypeScript Patterns
- Success Patterns (for patterns that worked well)
