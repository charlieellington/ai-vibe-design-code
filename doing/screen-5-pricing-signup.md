# Screen 5: Pricing & Signup - `/pricing`

## Task Title
Implement Pricing & Signup Page with Test Claiming Flow

### Original Request
"Create a plan for implementing Screen 5: Pricing & Signup (`/pricing`) from the MVP implementation plan. The pricing page should capture user email, show pricing tiers (Free Beta, Pro, Expert Analysis), create account via the existing `/api/auth/signup-with-test` API route, claim the anonymous test, and redirect to dashboard."

**Referenced documents:**
- `zebra-planning/user-testing-app/mvp-implementation-plan.md` (Screen 5 specification at lines 1131-1378)
- `zebra-planning/background/business-plan/1 focus/business-plan.md` (pricing strategy, tiers)

### Design Context

**No Figma design provided** - Following existing UI patterns from Screen 2, 3 and 4.

**Visual Consistency Requirements:**
- Same progress indicator pattern (4 circles, step 3 should be active)
- Same gradient background: `bg-gradient-to-b from-background to-muted/20`
- Same Card styling patterns used in `/preview` and `/customize`
- Same Button variants: primary for CTA, outline for secondary
- Same spacing: max-w-6xl container, gap-6/gap-8 patterns

**Pricing Strategy (from Business Plan):**
- **Free Beta Tier (RECOMMENDED)**: Free during beta (€39/month value), 2 tests/month, 5 testers/test
- **Pro Tier**: €49/month - Unlimited tests, unlimited testers, priority processing
- **Expert Analysis**: €300/test - Charlie's personal video analysis (30 min), 5-7 prioritized fixes

**Key UX Considerations:**
- "No credit card required" messaging
- Terms acceptance is required before submission
- Show "Your test is ready!" celebration message
- Free tier should be recommended/highlighted
- After signup: redirect to dashboard with welcome modal

### Codebase Context

**Existing Files to Reference:**
- `app/preview/page.tsx` (lines 95-114) - Shows how `anonymous_session` token is stored
- `app/api/auth/signup-with-test/route.ts` - API route that handles signup + test claiming
- `lib/storage-utils.ts` - Storage utility with sessionStorage/localStorage fallback
- `components/ui/*.tsx` - All required UI components exist

**Storage Keys Used in Flow:**
- **Read from**: `anonymous_session` (set by `/preview` page after creating anonymous test)
- **Write to**: `first_test_token` (for dashboard welcome modal)

**API Route Signature (`/api/auth/signup-with-test`):**
```typescript
POST body: { email: string, sessionToken: string, tier: string }
Response: { testUrl: string, shareToken: string, userId: string, message: string }
```

**Components Available (all exist):**
- `Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter` - from `@/components/ui/card`
- `Button` - from `@/components/ui/button`
- `Input` - from `@/components/ui/input`
- `Label` - from `@/components/ui/label`
- `Badge` - from `@/components/ui/badge`
- `Checkbox` - from `@/components/ui/checkbox`
- `storage` - from `@/lib/storage-utils`

**Icons to Use (from lucide-react):**
- `Check, Sparkles, Zap, Crown, ArrowRight`

### Prototype Scope

**Frontend Only Implementation:**
- Create `app/pricing/page.tsx` as client component
- No backend changes required (API route exists)
- No database changes required
- All UI components already available

**Data Flow:**
1. On mount: Load `anonymous_session` from storage → if missing, redirect to `/`
2. User selects tier (free pre-selected)
3. User enters email, accepts terms
4. Submit to `/api/auth/signup-with-test`
5. On success: Store `shareToken` as `first_test_token`, redirect to `/dashboard?welcome=true`

### Plan

#### Step 1: Create Pricing Page Structure
- **File**: `app/pricing/page.tsx` (new file)
- **Approach**: Client component with 'use client' directive
- **Implementation**:
  - Import all required components and utilities
  - Set up state: `email`, `selectedTier` (default 'free'), `loading`, `sessionToken`, `termsAccepted`
  - useEffect to load `anonymous_session` from storage, redirect if missing
  - Progress indicator showing step 3 of 4 active

#### Step 2: Implement Pricing Tiers Display
- **Approach**: Grid of 3 cards, selectable with visual feedback
- **Layout**: `grid md:grid-cols-3 gap-6`
- **Tier Configuration**:
  ```typescript
  const tiers = [
    {
      id: 'free',
      name: 'Free Beta',
      price: 'Free',
      originalPrice: '€39/mo',
      description: 'Perfect for getting started',
      features: [
        '2 tests per month',
        'Up to 5 testers per test',
        'AI transcription',
        'View recordings',
        'Basic support'
      ],
      icon: Sparkles,
      recommended: true
    },
    {
      id: 'pro',
      name: 'Pro',
      price: '€49',
      period: '/month',
      description: 'For teams that test regularly',
      features: [
        'Unlimited tests',
        'Unlimited testers',
        'Priority AI processing',
        'CSV export',
        'Remove branding',
        'Priority support'
      ],
      icon: Zap,
      recommended: false
    },
    {
      id: 'expert',
      name: 'Expert Analysis',
      price: '€300',
      period: '/test',
      description: "Get Charlie's personal analysis",
      features: [
        'Everything in Free',
        '30-min video analysis',
        '5-7 prioritized fixes',
        'Impact/effort matrix',
        'Optional workshop call'
      ],
      icon: Crown,
      recommended: false
    }
  ]
  ```
- **Selection Styling**: Selected card has `ring-2 ring-primary shadow-lg`, others have `hover:shadow-md`
- **Recommended Badge**: Positioned absolutely at `-top-3` on free tier

#### Step 3: Implement Email Capture Form
- **Layout**: Card centered below pricing grid, `max-w-lg mx-auto`
- **Form Elements**:
  - Email input (required, type="email")
  - Checkbox for terms acceptance
  - Submit button with loading state
- **Validation**:
  - Email required
  - Terms must be accepted before submission
  - Show alert if terms not accepted

#### Step 4: Implement Form Submission
- **On Submit**:
  1. Validate terms accepted
  2. Set loading state
  3. Call `/api/auth/signup-with-test` with `{ email, sessionToken, tier }`
  4. On success: Store `shareToken` as `first_test_token` in storage
  5. Clear `anonymous_session` from storage (cleanup)
  6. Redirect to `/dashboard?welcome=true`
- **Error Handling**: Log errors, reset loading state, optionally show toast

#### Step 5: Polish and Accessibility
- **Header**: "Your Test is Ready!" with celebration messaging
- **Progress Indicator**: 4 circles, first 3 filled (primary color)
- **Footer Text**: "No credit card required" under email form
- **Mobile Responsive**: Stack cards vertically on mobile

### Stage
Ready for Manual Testing

### Review Notes

**Requirements Coverage:**
✅ Email capture form with validation
✅ 3 pricing tiers (Free Beta, Pro, Expert Analysis)
✅ Terms acceptance checkbox
✅ API integration with `/api/auth/signup-with-test`
✅ Progress indicator continuation
✅ "No credit card required" messaging
✅ Free tier recommended/highlighted
⚠️ Dashboard redirect (see issue below)

**Technical Validation:**
✅ All UI components verified: Card, CardFooter, Button, Input, Label, Badge, Checkbox
✅ API route signature confirmed: `{ email, sessionToken, tier }` → `{ testUrl, shareToken, userId, message }`
✅ Storage utility exists with `setItem`, `getItem`, `removeItem` methods
✅ Checkbox uses Radix primitive with proper `onCheckedChange` handler
⚠️ Toaster not configured in layout.tsx - error handling should use inline errors, not toast

**Critical Issue - Dashboard Route:**
❌ `/dashboard` route does NOT exist in `app/` directory
- Plan specifies redirect to `/dashboard?welcome=true`
- Dashboard is Screen 6 in MVP plan - not yet implemented
- **Resolution**: Pricing page can be implemented now; redirect target will be created before end-to-end testing

**Technical Refinements:**
1. **Storage cleanup**: Use `storage.removeItem('anonymous_session')` (not `sessionStorage.removeItem`) for consistency with storage utility
2. **Error handling**: Use inline error state (matching `/page.tsx` pattern) rather than toast since Toaster isn't set up
3. **Progress indicator**: First 3 of 4 dots filled (matching `/customize` pattern - pricing is conceptually the final config step)

**Execution Specification Validated:**
- File: `app/pricing/page.tsx` (new)
- Estimated: ~200 lines
- Dependencies: All exist, no installations needed
- Pattern: Follow existing client component patterns from `/customize/page.tsx`

### Questions for Clarification
~~None~~ **RESOLVED**: Dashboard redirect is acceptable as placeholder - dashboard will be implemented as Screen 6 before full flow testing. Pricing page implementation can proceed independently.

### Priority
High - Critical path for user signup flow (Screen 5 of user journey)

### Created
2025-11-26

### Files
- `app/pricing/page.tsx` (new file - ~200 lines)

---

### Technical Discovery (Agent 3)
**Discovery Date**: 2025-11-26  
**Agent**: Design Agent 3 - Technical Discovery

#### Component Verification Results

**shadcn/ui Components (All Verified ✅)**:
- **Card Components**: Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter
  - **Location**: `components/ui/card.tsx`
  - **Import**: `@/components/ui/card`
  - **Dependencies**: None (standard React components)
  - **API**: All use standard React.forwardRef pattern with className prop
  - **Props**: All extend `React.HTMLAttributes<HTMLDivElement>`
  - **Styling**: Uses `cn()` utility for className merging, semantic tokens (bg-card, text-card-foreground)

- **Button**:
  - **Location**: `components/ui/button.tsx`
  - **Import**: `@/components/ui/button`
  - **Dependencies**: @radix-ui/react-slot, class-variance-authority
  - **Variants Available**: default, destructive, outline, secondary, ghost, link
  - **Sizes Available**: default (h-9), sm (h-8), lg (h-10), icon (h-9 w-9)
  - **Plan Usage**: `variant="outline"` for tier cards, `size="lg"` for submit button ✅

- **Input**:
  - **Location**: `components/ui/input.tsx`
  - **Import**: `@/components/ui/input`
  - **Dependencies**: None
  - **Props**: Standard input props + className
  - **Type Support**: Accepts `type="email"` as specified in plan ✅

- **Label**:
  - **Location**: `components/ui/label.tsx`
  - **Import**: `@/components/ui/label`
  - **Dependencies**: @radix-ui/react-label, class-variance-authority
  - **Props**: Standard label props + className

- **Badge**:
  - **Location**: `components/ui/badge.tsx`
  - **Import**: `@/components/ui/badge`
  - **Dependencies**: class-variance-authority
  - **Variants Available**: default (bg-primary), secondary, destructive, outline
  - **Plan Usage**: Default variant for "Recommended" badge ✅

- **Checkbox**:
  - **Location**: `components/ui/checkbox.tsx`
  - **Import**: `@/components/ui/checkbox`
  - **Dependencies**: @radix-ui/react-checkbox, lucide-react (Check icon)
  - **Important**: Uses `onCheckedChange` handler (not onChange)
  - **Important**: Handler receives boolean value (checked: boolean)
  - **State Prop**: Uses `checked` prop (not value) for controlled component
  - **Plan Compatibility**: ✅ Verified Agent 2 noted correct usage pattern

#### Icon Library Verification

**lucide-react Icons (All Verified ✅)**:
- **Package Version**: v0.511.0 (installed in package.json)
- **Import Pattern**: `import { IconName } from 'lucide-react'`
- **Icons Required by Plan**:
  - `Check` - ✅ Available (used in pricing features list)
  - `Sparkles` - ✅ Available (Free Beta tier icon)
  - `Zap` - ✅ Available (Pro tier icon)
  - `Crown` - ✅ Available (Expert Analysis tier icon)
  - `ArrowRight` - ✅ Available (Submit button icon)

#### API Route Verification

**`/api/auth/signup-with-test` Endpoint**:
- **Location**: `app/api/auth/signup-with-test/route.ts`
- **Method**: POST
- **Request Body**: `{ email: string, sessionToken: string, tier: string }`
- **Response**: `{ testUrl: string, shareToken: string, userId: string, message: string }`
- **Validation**: Checks for email and sessionToken presence (tier optional, defaults to 'free')
- **Flow**:
  1. Fetches anonymous test using sessionToken from `anonymous_tests` table
  2. Creates user account via Supabase Auth with tier in metadata
  3. Claims test by updating `tests` table (links user_id, sets is_anonymous=false)
  4. Cleans up `anonymous_tests` record
  5. Returns shareToken for `first_test_token` storage
- **Error Handling**: Returns 400 for invalid session, 500 for server errors
- **Plan Compatibility**: ✅ Exact match to plan specification

#### Storage Utility Verification

**`lib/storage-utils.ts`**:
- **Methods**: `setItem(key, value)`, `getItem(key)`, `removeItem(key)`
- **Behavior**: 
  - Primary: sessionStorage
  - Fallback: localStorage (with `_backup_` prefix)
  - Private browsing safe: Falls back to localStorage on sessionStorage errors
- **Storage Keys Used in Flow**:
  - **Read**: `anonymous_session` (set by `/preview` page at line 107)
  - **Write**: `first_test_token` (for dashboard welcome modal)
  - **Cleanup**: Remove `anonymous_session` after successful signup
- **Plan Compatibility**: ✅ All operations verified in existing codebase

#### Database Schema Verification

**`tests` Table (from `20250118000000_mvp_complete_setup.sql`)**:
- **Relevant Fields**:
  - `id`: UUID primary key
  - `user_id`: UUID foreign key to auth.users (nullable for anonymous)
  - `share_token`: TEXT unique (generated on creation)
  - `app_url`: TEXT (required)
  - `config`: JSONB (contains title, welcome_message, tasks, thank_you_message, redirect_url)
  - `is_anonymous`: BOOLEAN (default true)
  - `claimed_at`: TIMESTAMP (set when user claims test)

**`anonymous_tests` Table**:
- **Purpose**: Temporary storage for tests created before signup
- **Fields**: session_token (unique), test_data (JSONB), expires_at (24 hours)
- **Cleanup**: Deleted after successful claim

#### Pattern Reference Verification

**Progress Indicator Pattern** (from `/customize/page.tsx` lines 88-96):
```typescript
// 3 filled dots (primary) + 3 filled connectors + 1 empty dot pattern
<div className="flex items-center justify-center gap-2 mb-8">
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-primary" />
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-primary" />
  <div className="w-3 h-3 rounded-full bg-primary" />
  <div className="w-12 h-0.5 bg-border" />
  <div className="w-3 h-3 rounded-full bg-border" />
</div>
```
**Plan Specification**: First 3 dots filled (pricing is step 3 of 4) ✅

**Storage Pattern** (from `/preview/page.tsx` lines 95-114):
```typescript
const handleContinue = async () => {
  setLoading(true);
  try {
    const response = await fetch('/api/tests/anonymous', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(config)
    });
    const { sessionToken } = await response.json();
    storage.setItem('anonymous_session', sessionToken);
    router.push('/pricing');
  } catch (error) {
    console.error('Error creating test:', error);
    setLoading(false);
  }
};
```
**Plan Compatibility**: Pricing page will read `anonymous_session`, write `first_test_token`, cleanup `anonymous_session` ✅

**Client Component Pattern** (from `/customize/page.tsx` lines 1-42):
- Uses `'use client'` directive (line 1)
- useEffect for storage loading with redirect fallback (lines 35-42)
- State management with loading states
- Storage sync on config updates
**Plan Compatibility**: ✅ Pricing page follows same pattern

#### Implementation Feasibility Assessment

**✅ All Components Available**: No installations required
**✅ API Route Verified**: Accepts exact parameters as specified
**✅ Storage Utility Verified**: All methods available and tested
**✅ Icons Available**: All 5 icons exist in lucide-react
**✅ Pattern Examples**: Both `/preview` and `/customize` provide clear reference patterns
**⚠️ Dashboard Route**: Not yet implemented (noted in Review stage, accepted as placeholder)

#### Technical Blockers

**None identified** - All technical requirements verified and available

#### Special Considerations

1. **Checkbox State Management**:
   - Must use `checked` prop (not value)
   - Must use `onCheckedChange` handler (not onChange)
   - Handler receives boolean: `(checked: boolean) => void`
   - Example: `<Checkbox checked={termsAccepted} onCheckedChange={setTermsAccepted} />`

2. **Email Validation**:
   - HTML5 validation via `type="email"` on Input component
   - Additional client-side validation recommended before API call
   - API performs server-side validation (returns 400 if missing)

3. **Error Handling**:
   - Use inline error state (not toast - Toaster not configured)
   - Pattern: `const [error, setError] = useState('')` + conditional render
   - Reference: Similar to other pages in codebase

4. **Storage Cleanup**:
   - Must use `storage.removeItem('anonymous_session')` (not sessionStorage.removeItem)
   - Ensures cleanup across all storage layers (sessionStorage + localStorage backup)

5. **Progress Indicator**:
   - Pricing page is conceptually step 3 of 4 (after URL → Preview → Customize → Pricing)
   - 3 filled dots + 1 empty matches `/customize` pattern

6. **Tier Selection**:
   - Default to 'free' tier (pre-selected)
   - Visual feedback via `ring-2 ring-primary` on selected card
   - Store tier value in state, send to API

#### Installation Commands

**No installations required** - All dependencies already available:
- shadcn/ui components: ✅ Installed
- lucide-react icons: ✅ v0.511.0
- @radix-ui/react-checkbox: ✅ Installed (via shadcn)
- @radix-ui/react-label: ✅ Installed (via shadcn)

#### Discovery Summary

- **All Components Available**: ✅ Yes
- **API Integration Ready**: ✅ Yes
- **Storage Utilities Ready**: ✅ Yes
- **Icons Available**: ✅ All 5 verified
- **Technical Blockers**: ❌ None
- **Ready for Implementation**: ✅ Yes

**Recommendation**: Task is **READY FOR EXECUTION** - All technical requirements verified, no blocking issues discovered. Agent 4 can proceed with implementation following the plan and using verified patterns from `/preview/page.tsx` and `/customize/page.tsx`.

**Estimated Implementation Time**: 60-90 minutes (straightforward implementation, all components verified, clear patterns available)

---

### Implementation Notes (Agent 4)
**Implementation Date**: 2025-11-26

#### Summary
Created `/pricing` page with full functionality as specified in the plan:
- Client component with session token validation and redirect logic
- 3 pricing tier cards (Free Beta, Pro, Expert Analysis) with selection state
- Email capture form with terms checkbox using Radix Checkbox component
- API integration with `/api/auth/signup-with-test` endpoint
- Storage management (read `anonymous_session`, write `first_test_token`, cleanup on success)
- Progress indicator (3 filled + 1 empty, matching `/customize` pattern)
- Responsive grid layout (stacks on mobile)

#### Code Quality Metrics
- **TypeScript**: 0 errors (build passed)
- **ESLint**: No new issues introduced (pre-existing issues in other files)
- **Build**: Successful, `/pricing` route generated as static page (○)
- **Lines of Code**: ~300 lines

#### Files Created
- `app/pricing/page.tsx` (new file, 300 lines)

#### Implementation Details
1. **Pricing Tiers**: Used typed interface `PricingTier` with icon component support
2. **Selection State**: Visual feedback via `ring-2 ring-primary shadow-lg` classes
3. **Checkbox**: Correctly implemented with `checked` prop and `onCheckedChange` handler
4. **Error Handling**: Inline error state (no toast since Toaster not configured)
5. **Storage**: Used `storage.removeItem()` for proper cleanup across all storage layers

#### Known Limitations
- `/dashboard` route does not exist yet - redirect will 404 until Screen 6 implemented
- Terms/Privacy links point to `/terms` and `/privacy` which may not exist

---

### Manual Test Instructions

#### Prerequisites
1. Development server running: `pnpm dev` (or start it)
2. Complete the test creation flow first to get an `anonymous_session` token:
   - Go to `http://localhost:3000/` → Enter a URL → Preview → Customize → Save

#### Test Flow

**Test 1: Session Validation**
- [ ] Navigate directly to `http://localhost:3000/pricing` without `anonymous_session` → Should redirect to `/`
- [ ] After completing URL → Preview → Customize flow, should arrive at `/pricing` with session

**Test 2: Visual Layout**
- [ ] Progress indicator shows 3 filled dots + 1 empty dot
- [ ] Header says "Your Test is Ready!"
- [ ] 3 pricing cards displayed in horizontal grid (desktop) or stacked (mobile)
- [ ] "Free Beta" card has "Recommended" badge positioned at top
- [ ] Each card shows: icon, name, price, description, features list, select button

**Test 3: Tier Selection**
- [ ] "Free" tier is pre-selected by default (ring + shadow visible)
- [ ] Clicking another card selects it (visual feedback changes)
- [ ] Only one tier can be selected at a time
- [ ] Button text changes: "Selected" for active, "Select" for others

**Test 4: Email Form**
- [ ] Email input accepts text, validates as email type
- [ ] Terms checkbox is clickable and toggles state
- [ ] Terms links open in new tabs (may 404 if pages don't exist)
- [ ] Submit without terms → Error: "Please accept the terms and conditions"
- [ ] Submit with invalid email → Error: "Please enter a valid email address"
- [ ] Submit with valid email + terms → Button shows "Creating Account..."

**Test 5: Form Submission (Full Flow)**
- [ ] Enter valid email, accept terms, click "Get Started"
- [ ] Button shows loading state
- [ ] On success: Redirects to `/dashboard?welcome=true` (may 404 until dashboard exists)
- [ ] Check storage: `anonymous_session` should be removed, `first_test_token` should exist

**Test 6: Responsive Design**
- [ ] Desktop (>768px): 3 cards in horizontal grid
- [ ] Mobile (<768px): Cards stack vertically
- [ ] Form remains centered and readable at all sizes

**Test 7: Back Navigation**
- [ ] "Back to Preview" button at bottom navigates to `/preview`

#### Expected Behavior
- Page loads correctly with session validation
- All 3 tiers display with correct pricing and features
- Tier selection works with visual feedback
- Form validates email and terms before submission
- API call submits correct payload (`email`, `sessionToken`, `tier`)

#### Notes
- Dashboard redirect will 404 until Screen 6 is implemented - this is expected
- Full end-to-end testing requires all screens (1-6) to be complete
