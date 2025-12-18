# Design Agents Learnings Library

A categorized reference of patterns, debugging techniques, and lessons learned from previous implementations. Agents should consult relevant sections before implementation.

**How to Use**: Search for keywords related to your current task. Check relevant categories before writing code.

**Last Updated**: 2025-12-18

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
**Prevention**: Read full requirements including strategic context, implement all recommended features first

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

---

## CSS & Styling

### CSS Opacity Cascading Issues
**Added**: 2025-10-02
**Problem**: Setting opacity on containers creates stacking contexts, making content disappear
**Rules**:
1. Never set opacity on containers (div, section, main, header, footer)
2. Target specific content elements (p, h1-h6, img, svg, span)
3. Opacity on parent affects all children regardless of child opacity

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

### CSS Positioning with Tailwind Values
**Added**: 2025-09-04
**Problem**: Used approximate values instead of exact Tailwind pixels
**Solution**: Always verify exact Tailwind values
- w-16 = 64px (not ~60px)
- w-72 = 288px (not ~280px)

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

---

## Interactions & UX

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

---

## Component Patterns

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

---

## Success Patterns

### Zero-Iteration Implementation Factors
**Added**: 2025-01-09 (Moody Characters task)
**Success Factors**:
- Complete requirements documentation with all features specified
- Proper component reuse strategy verified before implementation
- Systematic architecture planned and executed
- Comprehensive TypeScript interfaces
- Proper workflow compliance

### Successful Landing Page MVP Pattern
**Added**: 2025-01-20
**Key Practices**:
1. Load ALL sections from task file
2. Use todo list tracking all sections
3. Run build immediately after implementation
4. Fix ESLint issues proactively
5. Correctly update status.md workflow

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
