# Screen 4: Customize Test - `/customize`

## Original Request

**From mvp-implementation-plan.md Screen 4:**
"What it does: Optional test customization" - This screen allows users to customize the test configuration (title, welcome message, tasks, instructions, thank you message) before proceeding to pricing/signup.

**MVP Implementation Reference:**
- Route: `/customize`
- Flow position: After Preview (`/preview`) when user clicks "Customize Test"
- Return path: Back to Preview (`/preview`) after saving

## Design Context

**Visual Design:**
- Matches existing Screens 2 & 3 visual language
- Same gradient background: `bg-gradient-to-b from-background to-muted/20`
- Same progress indicator pattern (4 dots with connectors)
- Progress state: Steps 1 & 2 completed (bg-primary), step 3 active (current)
- Uses Card component for form container

**Progress Indicator State:**
```
[filled] --- [filled] --- [filled] --- [empty]
  URL       Preview     Customize     Pricing
```

## Codebase Context

### Existing Patterns from Screens 2 & 3

**Storage Utility** (`lib/storage-utils.ts`):
```typescript
import { storage } from '@/lib/storage-utils';
// storage.getItem('test_config') - retrieve config
// storage.setItem('test_config', JSON.stringify(config)) - save config
```

**TestConfig Interface** (from `app/preview/page.tsx` lines 10-17):
```typescript
interface TestConfig {
  url: string;
  title: string;
  welcome_message: string;
  instructions: string;
  tasks: Array<{ description: string; is_optional?: boolean }>;
  thank_you_message: string;
}
```

**CRITICAL DATA STRUCTURE UPDATE:**
- MVP plan shows tasks as `string[]`
- Actual implementation uses `Array<{ description: string; is_optional?: boolean }>`
- Must use object structure to match existing Preview screen (lines 142-149)

**Components Already Available:**
- Card, CardContent, CardDescription, CardHeader, CardTitle (`@/components/ui/card`)
- Button (`@/components/ui/button`)
- Input (`@/components/ui/input`)
- Label (`@/components/ui/label`)
- Textarea (`@/components/ui/textarea`)
- Tooltip, TooltipContent, TooltipProvider, TooltipTrigger (`@/components/ui/tooltip`)

**Icons from lucide-react (used in MVP plan):**
- ArrowRight, Plus, Trash2, ChevronRight, Info

### Files to Create

- `app/customize/page.tsx` - Main customize screen component

## Prototype Scope

**Frontend Focus:**
- Client component ('use client')
- Read/write to sessionStorage via storage utility
- No database calls on this screen (data saved to DB on Preview continue)
- Form validation (at least 1 task required)

**Component Reuse:**
- Same Card layout pattern as Preview screen
- Same progress indicator from Screens 2 & 3
- Same navigation button patterns

## Plan

### Step 1: Create Route Directory
- Create `app/customize/` directory
- Create `app/customize/page.tsx` file

### Step 2: Implement Component Structure
- File: `app/customize/page.tsx`
- Client component with 'use client' directive
- Import dependencies:
  ```typescript
  import { useState, useEffect } from 'react';
  import { useRouter } from 'next/navigation';
  import { storage } from '@/lib/storage-utils';
  // Card components, Button, Input, Label, Textarea, Tooltip
  // Icons: ArrowRight, Plus, Trash2, ChevronRight, Info
  ```

### Step 3: State Management
- Load config from storage on mount (redirect to `/` if no config)
- Local state for config and showAdvanced toggle
- Update storage on every config change for real-time sync

### Step 4: Basic Form Fields (Always Visible)
- **Test Title** - Input field
- **Welcome Message** - Textarea (2 rows) with Info tooltip
- **Test Tasks** - Dynamic list with:
  - Input for each task description
  - Trash2 button to remove (only if > 1 task)
  - Plus button to add new task
  - **CRITICAL:** Tasks are objects: `{ description: string, is_optional?: boolean }`

### Step 5: Advanced Options (Collapsible)
- ChevronRight toggle with rotation animation
- **Instructions** - Textarea (3 rows)
- **Thank You Message** - Textarea (2 rows)

### Step 6: Action Buttons
- "Back to Preview" - variant="outline", navigates to `/preview`
- "Save & Continue" - primary, saves config and navigates to `/preview`

### Step 7: Task Management Functions
```typescript
const addTask = () => {
  const newTasks = [...config.tasks, { description: '', is_optional: false }];
  updateConfig({ tasks: newTasks });
};

const updateTask = (index: number, description: string) => {
  const newTasks = [...config.tasks];
  newTasks[index] = { ...newTasks[index], description };
  updateConfig({ tasks: newTasks });
};

const removeTask = (index: number) => {
  const newTasks = config.tasks.filter((_, i) => i !== index);
  updateConfig({ tasks: newTasks });
};
```

## Stage

Confirmed

## Questions for Clarification

~~None - All requirements are clear from MVP plan and existing implementation patterns.~~

**Resolved 2025-01-26:**
- Q: Tooltip component doesn't exist in codebase - how to handle?
- A: **Option A selected** - Install shadcn tooltip (`npx shadcn@latest add tooltip`) during Discovery/Execution

## Review Notes (Agent 2 - 2025-01-26)

### Requirements Coverage
- ✅ All functional requirements addressed
- ✅ TestConfig interface matches existing implementation (object structure for tasks)
- ✅ Storage utility pattern matches Screens 2 & 3
- ✅ Progress indicator pattern validated (3 dots filled for Customize screen)
- ⚠️ Tooltip component needs installation (resolved - will install during execution)

### Technical Validation
- ✅ All file paths verified against existing codebase
- ✅ Import patterns match existing screens
- ✅ Task object structure `{ description: string; is_optional?: boolean }` confirmed
- ✅ Navigation flow validated (returns to `/preview` after save)

### Progress Indicator Correction
Customize screen should show:
```
[filled] --- [filled] --- [filled] --- [empty]
   bg-primary  bg-primary  bg-primary  bg-border
```
- Dots 1, 2, 3: `bg-primary`
- Connectors 1-2, 2-3: `bg-primary`
- Dot 4 and connector 3-4: `bg-border`

### Pre-Execution Checklist
- [ ] Install shadcn tooltip: `npx shadcn@latest add tooltip`
- [ ] Create `app/customize/` directory
- [ ] Implement component following validated patterns

## Priority

High - Required for MVP user flow completion

## Created

2025-01-26

## Files

### Files to Create:
- `app/customize/page.tsx`

### Files to Reference (patterns):
- `app/page.tsx` (Screen 2 - progress indicator, storage usage)
- `app/preview/page.tsx` (Screen 3 - TestConfig interface, Card layout)
- `lib/storage-utils.ts` (storage utility)
- `lib/tests.ts` (Test interface reference)

## Key Differences from MVP Plan

| MVP Plan | Actual Implementation |
|----------|----------------------|
| `tasks: string[]` | `tasks: Array<{ description: string; is_optional?: boolean }>` |
| `sessionStorage.setItem()` | `storage.setItem()` (with fallback) |
| Progress: 4 steps | Progress: 4 dots with connectors (same pattern) |
| Navigates to `/pricing` after continue | Navigates to `/preview` (user can then proceed to pricing) |

## Implementation Notes

1. **Task Object Structure:** The MVP plan's code shows `config.tasks.map((task: string, ...)` but the actual lib/tests.ts and preview page use `{ description: string; is_optional?: boolean }`. The implementation must use the object structure.

2. **Navigation Flow:** After customization, user returns to Preview to confirm changes, then proceeds to pricing. This matches the Preview screen's "Customize Test" button flow.

3. **Storage Sync:** Use `updateConfig` helper that updates both local state and storage simultaneously to prevent data loss.

4. **Validation:** Ensure at least 1 task exists before allowing save.

---

## Technical Discovery (Agent 3 - 2025-01-26)

### Component Identification Verification

**Target Route**: `/customize`  
**Planned Component**: `app/customize/page.tsx` (new file)  
**Flow Position**: After Preview (`/preview`), before Pricing  

**Verification Steps**:
- ✅ Route structure confirmed - simple top-level route pattern matches existing `/preview` route
- ✅ Component will be new client component following Screen 2 & 3 patterns
- ✅ No similar-named components that could cause confusion
- ✅ Navigation flow validated: `/` → `/preview` → `/customize` → back to `/preview`

### MCP Research Results

#### Component Availability Check

**Tooltip Component Research:**
- **MCP Query**: `mcp_shadcn-ui-server_list-components`
- **Result**: ✅ Tooltip IS available in shadcn component library
- **Current Status**: ❌ NOT installed in codebase (verified via grep and package.json)
- **Required Action**: Install before execution

**Tooltip Status Verification:**
```bash
# Component list check
✅ "tooltip" appears in shadcn component list

# Codebase check
❌ No tooltip.tsx in components/ui/ directory
❌ No @radix-ui/react-tooltip in package.json
```

#### Existing Components Verified

**Card Component** (`components/ui/card.tsx`):
- ✅ Available and installed
- **Import Path**: `@/components/ui/card`
- **Components**: Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter
- **API Verified**: 
  - All accept standard HTMLDivElement props
  - className prop for custom styling
  - forwardRef pattern for ref handling

**Button Component** (`components/ui/button.tsx`):
- ✅ Available and installed
- **Import Path**: `@/components/ui/button`
- **Variants**: default, destructive, outline, secondary, ghost, link
- **Sizes**: default (h-9), sm (h-8), lg (h-10), icon (h-9 w-9)
- **API**: Standard button props + variant + size + asChild
- **Dependencies**: @radix-ui/react-slot (already installed)

**Input Component** (`components/ui/input.tsx`):
- ✅ Available and installed
- **Import Path**: `@/components/ui/input`
- **API**: Standard HTML input props
- **Styling**: Consistent with design system (h-9, rounded-md, border)

**Label Component** (`components/ui/label.tsx`):
- ✅ Available and installed
- **Import Path**: `@/components/ui/label`
- **Dependencies**: @radix-ui/react-label (already installed: v2.1.6)
- **API**: Standard label props with htmlFor support

**Textarea Component** (`components/ui/textarea.tsx`):
- ✅ Available and installed
- **Import Path**: `@/components/ui/textarea`
- **API**: Standard HTML textarea props
- **Styling**: field-sizing-content, min-h-16, consistent design system

#### Icons Verification

**lucide-react** (v0.511.0):
- ✅ Already installed
- **Icons Required**: ArrowRight, Plus, Trash2, ChevronRight, Info
- **All Verified**: ✅ All icons available in current version

#### Storage Utility Verification

**File**: `lib/storage-utils.ts`
- ✅ Confirmed available and working
- **API**:
  - `storage.setItem(key, value)` - Saves to sessionStorage with localStorage fallback
  - `storage.getItem(key)` - Reads from sessionStorage → localStorage backup → localStorage
  - `storage.removeItem(key)` - Removes from all storage locations
- **Features**:
  - Automatic fallback for private browsing mode
  - Backup to localStorage for data persistence
  - Used successfully in Screens 2 & 3

#### Progress Indicator Pattern Research

**Screen 2 Pattern** (`app/page.tsx` lines 78-86):
```jsx
{/* 1 filled dot, 3 empty */}
<div className="flex items-center justify-center gap-2 mb-8">
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-border" />
  <div className="w-3 h-3 rounded-full bg-border" />
  <div className="w-12 h-0.5 bg-border" />
  <div className="w-3 h-3 rounded-full bg-border" />
  <div className="w-12 h-0.5 bg-border" />
  <div className="w-3 h-3 rounded-full bg-border" />
</div>
```

**Screen 3 Pattern** (`app/preview/page.tsx` lines 100-108):
```jsx
{/* 2 filled dots + connector, 2 empty */}
<div className="flex items-center justify-center gap-2 mb-8">
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-primary" />  {/* Connector also filled */}
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-border" />
  <div className="w-3 h-3 rounded-full bg-border" />
  <div className="w-12 h-0.5 bg-border" />
  <div className="w-3 h-3 rounded-full bg-border" />
</div>
```

**Screen 4 Pattern** (Customize - to implement):
```jsx
{/* 3 filled dots + 2 filled connectors, 1 empty */}
<div className="flex items-center justify-center gap-2 mb-8">
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-primary" />
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-primary" />  {/* Second connector also filled */}
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-border" />
  <div className="w-3 h-3 rounded-full bg-border" />
</div>
```

**Pattern Analysis**:
- ✅ Simple div-based implementation (no component needed)
- ✅ Consistent styling: `w-3 h-3` for dots, `w-12 h-0.5` for connectors
- ✅ Color progression: `bg-primary` for completed, `bg-border` for upcoming
- ✅ Connectors between dots also change color based on progress

#### TestConfig Interface Verification

**Source**: `app/preview/page.tsx` lines 11-18

```typescript
interface TestConfig {
  url: string;
  title: string;
  welcome_message: string;
  instructions: string;
  tasks: Array<{ description: string; is_optional?: boolean }>;
  thank_you_message: string;
}
```

**Verification Results**:
- ✅ Interface matches plan requirements
- ✅ **CRITICAL**: Tasks are objects, NOT strings
- ✅ Optional `is_optional` flag supported
- ✅ All fields are strings (no complex types)
- ✅ Used consistently in Preview screen

### Implementation Feasibility

#### Technical Blockers
- ⚠️ **Minor blocker**: Tooltip component needs installation before execution
  - **Resolution**: Install via `npx shadcn@latest add tooltip`
  - **Impact**: 1-2 minutes during execution phase
  - **Risk**: Low - standard shadcn component installation

#### No Other Blockers Identified
- ✅ All other components already available
- ✅ All dependencies already installed (React 19, Next.js latest, lucide-react)
- ✅ Storage utility working and tested in Screens 2 & 3
- ✅ Router and navigation patterns validated
- ✅ Task object structure confirmed and documented

#### Resource Availability
- ✅ TestConfig interface available for import from preview page OR redeclare locally
- ✅ storage utility available at `@/lib/storage-utils`
- ✅ All UI components ready (except tooltip)
- ✅ All icons available
- ✅ Pattern examples available from Screens 2 & 3

### Required Installations

```bash
# Tooltip component (only missing component)
npx shadcn@latest add tooltip

# Expected installation details:
# - Adds: components/ui/tooltip.tsx
# - Dependency: @radix-ui/react-tooltip (will be added to package.json)
# - Bundle size: ~8-10KB
# - Installation time: ~30 seconds
```

**Post-installation imports:**
```typescript
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/components/ui/tooltip';
```

### Discovery Summary

- **All Components Available**: ✅ Yes (after tooltip installation)
- **Technical Blockers**: None (tooltip installation is minor)
- **Ready for Implementation**: ✅ Yes
- **Special Notes**: 
  - Task structure MUST use object format: `{ description: string; is_optional?: boolean }`
  - Progress indicator uses simple div pattern (no component)
  - Navigation returns to `/preview` (not `/pricing`)
  - Storage utility handles private browsing mode automatically

### Discovery Checklist

- ✅ **CRITICAL**: Component identification verified - correct route and file confirmed
- ✅ Page-to-component rendering path validated
- ✅ All mentioned components exist in shadcn/ui (tooltip needs install)
- ✅ Component APIs match planned usage
- ✅ Import paths verified
- ✅ No version conflicts
- ✅ Dependencies verified available
- ⚠️ One component requires installation (tooltip)
- ✅ No blocking technical issues

### Installation Impact Analysis

**Tooltip Component:**
- **Package**: @radix-ui/react-tooltip
- **Size**: ~8-10KB minified
- **Dependencies**: None beyond existing @radix-ui packages
- **Breaking Changes**: None
- **Compatibility**: ✅ Compatible with React 19
- **Installation Command**: `npx shadcn@latest add tooltip`

**Total Bundle Impact**: ~8-10KB (negligible for this application)

---

## Stage Update

**Previous Stage**: Ready for Execution
**Current Stage**: Ready for Manual Testing
**Next Agent**: User (Manual Testing) → Agent 5 (Completion)

**Ready Date**: 2025-01-26
**Execution Date**: 2025-01-26

---

## Implementation Notes (Agent 4 - 2025-01-26)

### Implementation Summary

**Files Created:**
- `app/customize/page.tsx` (268 lines) - Full customize screen implementation

**Dependencies Installed:**
- `@radix-ui/react-tooltip` via `npx shadcn@latest add tooltip`
- Created: `components/ui/tooltip.tsx`

### Features Implemented

1. **Progress Indicator**: 3 filled dots + 2 filled connectors (matching Screen 4 position)

2. **Basic Form Fields (Always Visible)**:
   - Test Title (Input)
   - Welcome Message (Textarea with Info tooltip)
   - Test Tasks (Dynamic list with add/remove functionality)
     - Uses correct object structure: `{ description: string; is_optional?: boolean }`
     - Numbered task indicators (1, 2, 3...)
     - Trash button to remove (only if > 1 task)
     - Plus button to add new task

3. **Advanced Options (Collapsible)**:
   - ChevronRight toggle with rotation animation
   - Test Instructions (Textarea)
   - Thank You Message (Textarea)

4. **Action Buttons**:
   - "Back to Preview" (outline variant, navigates to `/preview`)
   - "Save & Continue" (primary, validates and navigates to `/preview`)

5. **Validation**: At least 1 task with content required before save

6. **Storage Sync**: Real-time sync to sessionStorage via `updateConfig` helper

### Code Quality Metrics

- **TypeScript**: 0 errors
- **Next.js Build**: Successful
- **Route Status**: `/customize` - Static page (prerendered)
- **ESLint**: No warnings (HTML entities properly escaped)

### Pattern Compliance

- ✅ Uses same gradient background as Screens 2 & 3
- ✅ Uses same progress indicator pattern
- ✅ Uses storage utility from `@/lib/storage-utils`
- ✅ Task object structure matches TestConfig interface
- ✅ TooltipProvider wraps entire component
- ✅ Redirects to `/` if no config in storage

---

## Manual Test Instructions

### Prerequisites
1. Development server running at `http://localhost:3001`
2. Complete the URL entry flow first to have a test config in storage

### Test Flow

**Setup (Required):**
1. Go to `http://localhost:3001/` (landing page)
2. Enter a URL (e.g., `https://example.com`) and click Continue
3. This creates a test config in storage and navigates to Preview

**From Preview Page:**
1. Click "Customize Test" button
2. Should navigate to `http://localhost:3001/customize`

### Visual Verification Checklist

- [ ] Progress indicator shows 3 filled dots (primary color) and 1 empty dot
- [ ] Page title reads "Customize Your Test"
- [ ] Card displays "Test Configuration" header

### Form Fields Verification

**Basic Fields:**
- [ ] Test Title input is pre-populated with default value
- [ ] Welcome Message textarea is pre-populated with default
- [ ] Tasks list shows default tasks with numbered indicators (1, 2, 3...)
- [ ] Info icons show tooltips on hover (Welcome Message, Test Tasks)

**Task Management:**
- [ ] Click "Add Task" button - new empty task appears
- [ ] Type in a task field - updates correctly
- [ ] Click trash icon on task - task is removed
- [ ] Cannot remove last task (trash button hidden when only 1 task)

**Advanced Options:**
- [ ] Click "Advanced Options" - section expands with rotation animation
- [ ] Test Instructions textarea is visible and editable
- [ ] Thank You Message textarea is visible and editable
- [ ] Click "Advanced Options" again - section collapses

### Action Buttons Verification

- [ ] "Back to Preview" button navigates to `/preview`
- [ ] "Save & Continue" button is disabled if all tasks are empty
- [ ] "Save & Continue" button is enabled if at least 1 task has content
- [ ] Clicking "Save & Continue" navigates to `/preview`

### Data Persistence Verification

1. Make changes on customize page (edit title, add/remove tasks)
2. Navigate back to Preview
3. [ ] Preview should show the updated configuration
4. Navigate back to Customize (via "Customize Test" button)
5. [ ] Changes should persist (not reset to defaults)

### Edge Cases

- [ ] Direct navigation to `/customize` without config redirects to `/`
- [ ] Empty task descriptions are handled gracefully
- [ ] Long text in fields doesn't break layout

### Responsive Testing

- [ ] Desktop (1920px): Card centered, readable layout
- [ ] Tablet (768px): Card adjusts to viewport, no overflow
- [ ] Mobile (375px): Single column layout, all fields accessible

### Final Approval Criteria

**Move to Complete** if:
- All visual elements render correctly
- All form interactions work as expected
- Data persists between page navigations
- No console errors

**Move to Needs Work** if:
- Form fields don't update storage
- Navigation doesn't work
- Visual inconsistencies with other screens
