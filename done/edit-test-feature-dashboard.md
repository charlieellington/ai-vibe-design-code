# Edit Test Feature for Dashboard

## Original Request
"Add ability for test creators to edit their existing tests from the dashboard, including:
- Edit test configuration (title, welcome message, tasks, instructions, thank you message, redirect URL)
- Pause/unpause tests (toggle `is_active`) - **blocks new testers when paused**"

**Additional Context:**
- Dashboard shows test cards with Copy Link and Results buttons
- Active/Paused badge displays but users cannot change it
- No edit functionality exists - once a test is created, it cannot be modified
- `/customize` page only works during initial creation flow (uses sessionStorage)
- Tester flow already checks `is_active` and shows "Test Not Found" if paused (Option 1 behavior confirmed)

## Design Context
No Figma design provided - follow existing dashboard modal patterns (Welcome Modal, Success Modal).

**UI Pattern Reference:**
- Existing modals in dashboard use Dialog component from shadcn
- Form inputs follow same patterns as `/customize` page
- Button row pattern: `[Copy] [Edit] [Results]` (add Edit in middle)

## Codebase Context

### Key Files:
1. **`app/dashboard/page.tsx`** (~679 lines)
   - Contains: WelcomeModal, SuccessModal components
   - Test cards with action buttons (Copy Link, Results)
   - State: `tests`, `user`, `showWelcomeModal`, `showSuccessModal`
   - Uses: Dialog, Button, Badge, Card components from shadcn
   - Demo mode: handles `?demo=true` with sample data

2. **`lib/tests.ts`** - Test interface definition
   ```typescript
   export interface Test {
     id: string;
     user_id?: string;
     share_token: string;
     app_url: string;
     config: {
       title: string;
       welcome_message: string;
       instructions: string;
       tasks: Array<{ description: string; is_optional?: boolean }>;
       max_sessions?: number;
       sessions_completed?: number;
       thank_you_message: string;
     };
     is_active: boolean;
     is_anonymous: boolean;
     created_at: string;
     claimed_at?: string;
   }
   ```

3. **`app/customize/page.tsx`** - Reference for form pattern
   - Task add/remove/edit pattern
   - Collapsible advanced options
   - Form validation

4. **`app/api/tests/[id]/route.ts`** - Does NOT exist (needs creation)

### Existing Components (verified available):
- Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter
- Input, Label, Textarea, Button
- Checkbox (for potential pause toggle)
- ChevronRight (for collapsible sections)
- Trash2, Plus icons (for task management)

### RLS Policy (from MVP plan):
```sql
CREATE POLICY "Users update own tests" ON tests
  FOR UPDATE USING (user_id = auth.uid());
```
This confirms users can only update their own tests.

## Plan

### Step 1: Create API Route
**File:** `app/api/tests/[id]/route.ts` (NEW)

```typescript
// PATCH handler for updating tests
export async function PATCH(
  request: Request,
  { params }: { params: { id: string } }
) {
  const supabase = await createClient();

  // 1. Verify user is authenticated
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  // 2. Parse request body
  const body = await request.json();
  const { config, is_active } = body;

  // 3. Update test (RLS ensures user owns it)
  const { data, error } = await supabase
    .from('tests')
    .update({ config, is_active })
    .eq('id', params.id)
    .eq('user_id', user.id) // Extra safety
    .select()
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json(data);
}
```

### Step 2: Add Edit Button to Test Cards
**File:** `app/dashboard/page.tsx`

Add Edit icon import:
```typescript
import { Edit } from 'lucide-react';
```

Add button in action buttons section (between Copy and Results):
```tsx
<Button
  variant="outline"
  size="sm"
  className="flex-1"
  onClick={() => setEditingTest(test)}
>
  <Edit className="w-4 h-4" />
</Button>
```

### Step 3: Add EditTestModal State
**File:** `app/dashboard/page.tsx`

Add state:
```typescript
const [editingTest, setEditingTest] = useState<TestWithSessions | null>(null);
```

### Step 4: Create EditTestModal Component
**File:** `app/dashboard/page.tsx` (inline component)

Modal structure:
- DialogHeader: "Edit Test"
- Form fields:
  - Title (Input)
  - Welcome Message (Textarea)
  - Tasks (add/remove like /customize)
  - Collapsible Advanced Options:
    - Instructions (Textarea)
    - Thank You Message (Textarea)
    - Redirect URL (Input, optional)
  - Status Toggle:
    - Active / Paused radio or switch
    - Warning text: "Paused tests show 'Test Not Found' to new testers"
- DialogFooter: Cancel, Save Changes buttons

### Step 5: Implement Save Handler
```typescript
const handleSaveTest = async () => {
  if (!editingTest) return;

  // Demo mode - just update local state
  if (!supabase) {
    setTests(prev => prev?.map(t =>
      t.id === editingTest.id ? { ...t, ...editConfig } : t
    ) || null);
    toast.success('Test updated (demo mode)');
    setEditingTest(null);
    return;
  }

  // Real mode - call API
  const response = await fetch(`/api/tests/${editingTest.id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      config: editConfig.config,
      is_active: editConfig.is_active
    })
  });

  if (response.ok) {
    const updated = await response.json();
    setTests(prev => prev?.map(t =>
      t.id === updated.id ? { ...t, ...updated } : t
    ) || null);
    toast.success('Test updated successfully');
    setEditingTest(null);
  } else {
    toast.error('Failed to update test');
  }
};
```

### Step 6: Wire Up Modal Open/Close
- Opening: `onClick={() => setEditingTest(test)}`
- Closing: `onOpenChange={(open) => !open && setEditingTest(null)}`
- Modal visible when: `editingTest !== null`

## Stage
Complete

## Review Notes (Phase 2)
**Requirements Coverage:** ✅ All 10 requirements addressed
**Technical Validation:** ✅ All file paths verified, API route pattern validated
**Risk Assessment:** Low - follows existing modal and API patterns
**Validation Question Answer:** Plan is complete and executable with no ambiguities

## Implementation Notes (Phase 4)
**Completed:** 2025-11-27

### Files Modified/Created:
- ✅ `app/api/tests/[id]/route.ts` (NEW - ~49 lines) - PATCH endpoint for updating tests
- ✅ `app/dashboard/page.tsx` (MODIFIED - now ~1029 lines) - Added Edit modal and handlers

### Features Implemented:
- ✅ Edit button on test cards (Copy | Edit | Results pattern)
- ✅ Edit modal with all configuration fields:
  - Title (Input)
  - Welcome Message (Textarea)
  - Tasks with add/remove/edit (same pattern as /customize)
  - Collapsible Advanced Options (Instructions, Thank You Message, Redirect URL)
- ✅ Status toggle (Active/Paused) with warning: "Paused tests will show 'Test Not Found' to new testers"
- ✅ Save handler with API call (real mode) or local state update (demo mode)
- ✅ Toast notifications for success/error feedback
- ✅ Quick stats update (Active Tests count) reflects status changes

### Testing:
- ✅ TypeScript build: 0 errors
- ✅ Visual verification with Playwright:
  - Edit button visible on all test cards
  - Modal opens with pre-populated fields
  - Advanced Options toggle works
  - Paused status shows warning message
  - Save updates test card badge and Active Tests count
  - Toast notification "Test updated (demo mode)" shown

## Questions for Clarification
None - requirements are clear:
- Edit modal approach confirmed
- Pause behavior confirmed (blocks new testers)
- Form fields match existing customize page

## Priority
Medium

## Created
2025-11-27

## Files
- `app/api/tests/[id]/route.ts` (NEW)
- `app/dashboard/page.tsx` (MODIFY)
