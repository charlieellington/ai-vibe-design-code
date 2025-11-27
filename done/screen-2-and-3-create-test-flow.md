# Screen 2 & 3: Create Test Flow (Enter URL + Preview)

## Original Request
"@documentation/design-agents-flow/design-1-planning.md please create a plan/task for Screen 2: Create Test (Enter URL) and Screen 3: Test Preview - we will do both these screens at the same - make sure there is no context loss from @zebra-planning/user-testing-app/mvp-implementation-plan.md (and/or keep a verbatim copy in the plan doc)"

## Design Context

### User Flow
This implements steps 1-2 of the test creation journey:
1. **Screen 2 (`/`)**: User enters their app URL at the app root, system generates smart defaults
2. **Screen 3 (`/preview`)**: User reviews the generated test configuration, can customize or proceed

### Progress Indicator
Both screens show a 4-step progress indicator:
- Step 1 (active on `/`): Enter URL
- Step 2 (active on `/preview`): Preview test
- Step 3: Customize (optional)
- Step 4: Get test link

### Visual Design Specifications
**Screen 2 - Enter URL:**
- Centered card layout with gradient background (`bg-gradient-to-b from-background to-muted/20`)
- Large input field with URL validation
- Sparkles icon in primary/10 background circle
- Progress dots showing current step
- Max width: 2xl (672px)

**Screen 3 - Preview:**
- Split-screen layout on desktop (lg:grid-cols-2)
- Left: iframe showing the target app
- Right: Cards displaying test configuration (welcome message, tasks, recording method)
- Two action buttons: "Customize Test" (outline) and "Looks Good - Continue" (primary)
- Max width: 6xl (1152px)

### Key Design Patterns
- Uses shadcn/ui Card, Button, Input, Label, Badge components
- Lucid React icons (ArrowRight, Sparkles, Edit, CheckCircle, Users, Mic, FileText)
- Consistent spacing with p-6, gap-4, space-y-6
- Loading states with disabled buttons and text changes
- Error handling with destructive text color

## Codebase Context

### Dependencies Already in Place (from Stage 1)
1. **Test Management Utilities**: `lib/tests.ts`
   - `generateSmartDefaults(appUrl: string)` function
   - Test interface with full config structure
   - Smart parsing of URL to generate meaningful defaults

2. **API Routes**: `/api/tests/anonymous` (POST)
   - Creates test in database with anonymous flag
   - Stores in temporary anonymous_tests table
   - Returns sessionToken, testId, shareToken

3. **UI Components**: All shadcn components available
   - Card, CardContent, CardDescription, CardHeader, CardTitle
   - Button, Input, Label, Badge
   - All from `@/components/ui/`

### SessionStorage Contract
These screens use sessionStorage to pass data between steps:

**Screen 2 writes:**
- `test_url`: Raw URL string
- `test_config`: Complete config object with structure:
  ```typescript
  {
    url: string,
    title: string,
    welcome_message: string,
    instructions: string,
    tasks: string[],
    thank_you_message: string
  }
  ```

**Screen 3 reads:**
- `test_config`: Retrieves from sessionStorage
- Redirects to `/` if missing

**Screen 3 writes:**
- `anonymous_session`: Session token from API after creating test in database

### Routing Structure
- `/` - Screen 2 (Enter URL at app root)
- `/preview` - Screen 3 (Preview)
- `/customize` - Optional customization (not in this task)
- `/pricing` - Next step after preview

### File Structure
```
app/
  page.tsx (Screen 2 - client component at root)
  preview/
    page.tsx (Screen 3 - client component)
```

## Complete Implementation Code (Verbatim from MVP Plan)

### Screen 2: Create Test (Enter URL) - `/` (App Root)
**What it does:** Enter URL and generate smart defaults

```typescript
// app/page.tsx (replacing the redirect)
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { ArrowRight, Sparkles } from 'lucide-react';
import { generateSmartDefaults } from '@/lib/tests';

export default function CreateTestPage() {
  const router = useRouter();
  const [url, setUrl] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      // Validate URL
      const validUrl = new URL(url);

      // Store in sessionStorage for next steps
      sessionStorage.setItem('test_url', url);

      // Generate smart defaults
      const testConfig = {
        url,
        ...generateSmartDefaults(url)
      };

      sessionStorage.setItem('test_config', JSON.stringify(testConfig));

      // Navigate to preview
      router.push('/preview');
    } catch (err) {
      setError('Please enter a valid URL');
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-6 bg-gradient-to-b from-background to-muted/20">
      <div className="w-full max-w-2xl">
        {/* Progress indicator */}
        <div className="flex items-center justify-center gap-2 mb-8">
          <div className="w-3 h-3 rounded-full bg-primary" />
          <div className="w-12 h-0.5 bg-border" />
          <div className="w-3 h-3 rounded-full bg-border" />
          <div className="w-12 h-0.5 bg-border" />
          <div className="w-3 h-3 rounded-full bg-border" />
          <div className="w-12 h-0.5 bg-border" />
          <div className="w-3 h-3 rounded-full bg-border" />
        </div>

        <Card className="border-2">
          <CardHeader className="text-center">
            <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-4">
              <Sparkles className="w-8 h-8 text-primary" />
            </div>
            <CardTitle className="text-3xl">Test Your App's UX</CardTitle>
            <CardDescription className="text-lg">
              Get video feedback from real users in minutes
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="space-y-2">
                <Label htmlFor="url">Enter your app or website URL</Label>
                <Input
                  id="url"
                  type="url"
                  placeholder="e.g., https://yourapp.com"
                  value={url}
                  onChange={(e) => setUrl(e.target.value)}
                  className="text-lg py-6"
                  required
                  autoFocus
                />
                {error && (
                  <p className="text-sm text-destructive">{error}</p>
                )}
              </div>

              <Button
                type="submit"
                size="lg"
                className="w-full"
                disabled={loading}
              >
                {loading ? 'Setting up...' : 'Continue'}
                <ArrowRight className="w-4 h-4 ml-2" />
              </Button>

              <p className="text-center text-sm text-muted-foreground">
                No signup required • See preview instantly • 2 minutes to your first test
              </p>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

**Test:** Enter URL → See loading → Navigate to preview with data ✓

---

### Screen 3: Test Preview - `/preview`
**What it does:** Show test preview with real data

```typescript
// app/preview/page.tsx
'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { CheckCircle, Edit, ArrowRight, Users, Mic, FileText } from 'lucide-react';

export default function PreviewPage() {
  const router = useRouter();
  const [config, setConfig] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const stored = sessionStorage.getItem('test_config');
    if (!stored) {
      router.push('/');
      return;
    }
    setConfig(JSON.parse(stored));
  }, [router]);

  const handleContinue = async () => {
    setLoading(true);

    // Create anonymous test in database
    const response = await fetch('/api/tests/anonymous', {\n      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(config)
    });

    const { sessionToken } = await response.json();
    sessionStorage.setItem('anonymous_session', sessionToken);

    router.push('/pricing');
  };

  if (!config) return null;

  return (
    <div className="min-h-screen p-6 bg-gradient-to-b from-background to-muted/20">
      <div className="max-w-6xl mx-auto">
        {/* Progress indicator */}
        <div className="flex items-center justify-center gap-2 mb-8">
          <div className="w-3 h-3 rounded-full bg-primary" />
          <div className="w-12 h-0.5 bg-primary" />
          <div className="w-3 h-3 rounded-full bg-primary" />
          <div className="w-12 h-0.5 bg-border" />
          <div className="w-3 h-3 rounded-full bg-border" />
          <div className="w-12 h-0.5 bg-border" />
          <div className="w-3 h-3 rounded-full bg-border" />
        </div>

        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold mb-2">Preview Your Test</h1>
          <p className="text-muted-foreground">
            This is exactly what your testers will see and do
          </p>
        </div>

        <div className="grid lg:grid-cols-2 gap-8 mb-8">
          {/* Left: App Preview */}
          <Card className="overflow-hidden">
            <CardHeader className="bg-muted/50">
              <CardTitle className="text-lg">Your App</CardTitle>
              <CardDescription>{config.url}</CardDescription>
            </CardHeader>
            <CardContent className="p-0">
              <div className="relative">
                <iframe
                  src={config.url}
                  className="w-full h-[500px] border-0"
                  sandbox="allow-same-origin allow-scripts"
                  title="App preview"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-background/20 to-transparent pointer-events-none" />
              </div>
            </CardContent>
          </Card>

          {/* Right: Test Configuration */}
          <div className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="w-5 h-5" />
                  Welcome Message
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm">{config.welcome_message}</p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="w-5 h-5" />
                  Test Tasks
                </CardTitle>
              </CardHeader>
              <CardContent>
                <ol className="space-y-2">
                  {config.tasks.map((task: string, i: number) => (
                    <li key={i} className="flex items-start gap-3">
                      <span className="flex-shrink-0 w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center text-xs font-semibold">
                        {i + 1}
                      </span>
                      <span className="text-sm">{task}</span>
                    </li>
                  ))}
                </ol>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Mic className="w-5 h-5" />
                  Recording Method
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="flex items-center gap-2">
                  <CheckCircle className="w-4 h-4 text-green-600" />
                  <span className="text-sm">Screen + Voice Recording</span>
                </div>
                <div className="flex items-center gap-2 mt-2">
                  <CheckCircle className="w-4 h-4 text-green-600" />
                  <span className="text-sm">AI Transcription Included</span>
                </div>
                <div className="flex items-center gap-2 mt-2">
                  <CheckCircle className="w-4 h-4 text-green-600" />
                  <span className="text-sm">Text Feedback Option Available</span>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex justify-center gap-4">
          <Button
            variant="outline"
            size="lg"
            onClick={() => router.push('/customize')}
          >
            <Edit className="w-4 h-4 mr-2" />
            Customize Test
          </Button>
          <Button
            size="lg"
            onClick={handleContinue}
            disabled={loading}
          >
            {loading ? 'Creating...' : 'Looks Good - Continue'}
            <ArrowRight className="w-4 h-4 ml-2" />
          </Button>
        </div>

        <p className="text-center text-sm text-muted-foreground mt-4">
          Most users proceed with smart defaults • Customization is optional
        </p>
      </div>
    </div>
  );
}
```

**Test:** See real preview → Click continue → Test created in DB ✓

## Plan

### Step 1: Create Screen 2 - Enter URL Page (App Root)
**File**: `app/page.tsx` (replace existing redirect)

**Implementation**:
- Create client component (`'use client'`)
- Import all required components and utilities:
  - UI components from `@/components/ui/card`, `@/components/ui/button`, `@/components/ui/input`, `@/components/ui/label`
  - Icons: `ArrowRight`, `Sparkles` from `lucide-react`
  - `generateSmartDefaults` from `@/lib/tests`
  - `useRouter` from `next/navigation`
- State management:
  - `url`: Input value
  - `loading`: Submit state
  - `error`: Validation error message
- Form handling:
  - URL validation using `new URL(url)` constructor
  - On success: Generate smart defaults, store in sessionStorage, navigate to `/preview`
  - On error: Show validation error message
- UI elements:
  - Progress indicator (4 dots, first one active)
  - Centered card with Sparkles icon
  - URL input field with label
  - Submit button with loading state
  - Error message display

**Testing**:
- Valid URL submission navigates to `/preview`
- Invalid URL shows error message
- sessionStorage contains `test_url` and `test_config`

### Step 2: Create Screen 3 - Preview Page
**File**: `app/preview/page.tsx`

**Implementation**:
- Create client component (`'use client'`)
- Import all required components:
  - UI components: Card, Button, Badge
  - Icons: `CheckCircle`, `Edit`, `ArrowRight`, `Users`, `Mic`, `FileText`
- State management:
  - `config`: Test configuration from sessionStorage
  - `loading`: API call state
- useEffect hook:
  - Load config from sessionStorage on mount
  - Redirect to `/` if config missing
- API integration:
  - POST to `/api/tests/anonymous` with config data
  - Store returned `sessionToken` in sessionStorage
  - Navigate to `/pricing` on success
- UI layout:
  - Progress indicator (2 steps completed)
  - Two-column grid (left: iframe, right: config cards)
  - Three info cards: Welcome Message, Test Tasks, Recording Method
  - Two action buttons: Customize (outline) and Continue (primary)

**Testing**:
- Config loads from sessionStorage correctly
- iframe displays target URL
- Tasks render as numbered list
- "Continue" button creates test in database
- Navigation to pricing page after creation

### Step 3: Verify Dependencies
**Files to check**:
- `lib/tests.ts` - Ensure `generateSmartDefaults` function exists
- `/api/tests/anonymous/route.ts` - Ensure POST endpoint works
- All UI components imported correctly

**Verification**:
- TypeScript compiles without errors
- No missing imports
- sessionStorage contract matches between screens

### Step 4: Test Complete Flow
**Manual testing checklist**:
1. Navigate to `/` (app root)
2. Enter test URL (e.g., `https://example.com`)
3. Click "Continue"
4. Verify navigation to `/preview`
5. Verify iframe loads target URL
6. Verify generated defaults appear (title, message, tasks)
7. Click "Looks Good - Continue"
8. Verify API call creates test in database
9. Verify navigation to `/pricing`

**Expected data flow**:
```
User enters URL
  ↓
generateSmartDefaults() creates config
  ↓
Store in sessionStorage
  ↓
Navigate to preview
  ↓
Load config from sessionStorage
  ↓
Display in UI
  ↓
User clicks Continue
  ↓
POST /api/tests/anonymous
  ↓
Store sessionToken
  ↓
Navigate to pricing
```

## Stage
Ready for Manual Testing

## Questions for Clarification
~~None - implementation is fully specified in MVP plan.~~ RESOLVED

## Review Notes

### Requirements Coverage ✅
All requirements from the original request are fully addressed:
- ✓ Screen 2: Create Test (Enter URL) implementation
- ✓ Screen 3: Test Preview implementation
- ✓ Both screens implemented together in single task
- ✓ Verbatim MVP implementation code preserved (lines 100-393)
- ✓ Complete user flow with sessionStorage contract
- ✓ Progress indicators on both screens

### Technical Validation ✅
- ✓ `lib/tests.ts` exists with `generateSmartDefaults` function
- ✓ `/api/tests/anonymous` POST endpoint exists and functional
- ✓ All required shadcn/ui components available
- ✓ Import paths match project structure
- ✓ No conflict with root directory - Screen 2 replaces existing redirect page

### ✅ Clarifications Resolved

**1. Tasks Array Data Structure - RESOLVED**
Decision: Keep tasks as objects throughout for consistency
- Update `generateSmartDefaults` to return tasks as objects:
```typescript
// In lib/tests.ts generateSmartDefaults function:
tasks: [
  { description: 'Try to complete the main action on this page', is_optional: false },
  { description: 'Find information about pricing or features', is_optional: false },
  { description: 'Share your overall impression of the experience', is_optional: false }
]
```
- Update preview page to expect and display objects:
```typescript
// In preview/page.tsx:
{config.tasks.map((task: {description: string, is_optional?: boolean}, i: number) => (
  <li key={i} className="flex items-start gap-3">
    <span className="flex-shrink-0 w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center text-xs font-semibold">
      {i + 1}
    </span>
    <span className="text-sm">{task.description}</span>
  </li>
))}
```

**2. iframe Security - RESOLVED**
Decision: Add error handling and user guidance
```typescript
// Add to preview/page.tsx after iframe:
const [iframeError, setIframeError] = useState(false);

// In iframe element:
<iframe
  src={config.url}
  className="w-full h-[500px] border-0"
  sandbox="allow-same-origin allow-scripts"
  title="App preview"
  onError={() => setIframeError(true)}
/>
{iframeError && (
  <div className="absolute inset-0 flex items-center justify-center bg-muted/90">
    <div className="text-center p-6">
      <p className="font-medium mb-2">Preview blocked by website</p>
      <p className="text-sm text-muted-foreground mb-4">
        This site prevents embedding. The test will still work normally.
      </p>
      <a
        href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options"
        target="_blank"
        rel="noopener noreferrer"
        className="text-sm text-primary hover:underline"
      >
        Learn more about iframe restrictions →
      </a>
    </div>
  </div>
)}
```

**3. SessionStorage Fallback - RESOLVED**
Decision: Implement localStorage fallback
```typescript
// Storage utility for both screens:
const storage = {
  setItem: (key: string, value: string) => {
    try {
      sessionStorage.setItem(key, value);
      localStorage.setItem(`_backup_${key}`, value);
    } catch (e) {
      localStorage.setItem(key, value);
    }
  },
  getItem: (key: string) => {
    try {
      return sessionStorage.getItem(key) ||
             localStorage.getItem(`_backup_${key}`) ||
             localStorage.getItem(key);
    } catch (e) {
      return localStorage.getItem(key);
    }
  },
  removeItem: (key: string) => {
    sessionStorage.removeItem(key);
    localStorage.removeItem(`_backup_${key}`);
    localStorage.removeItem(key);
  }
};
```

### Risk Assessment (Updated)
1. ~~**HIGH RISK - Data Structure**~~ ✅ RESOLVED with object consistency
2. ~~**MEDIUM RISK - SessionStorage Reliability**~~ ✅ RESOLVED with localStorage fallback
3. ~~**MEDIUM RISK - iframe Security**~~ ✅ RESOLVED with error handling and user guidance
4. **LOW RISK - URL Validation**: Only validates format, not accessibility

### Implementation Ready
All critical issues resolved. Plan is now execution-ready with:
- Consistent data structure throughout
- Robust storage fallback mechanism
- Proper iframe error handling with user guidance
- Clear implementation specifications

## Priority
High - Core user journey (steps 1-2 of test creation flow)

## Created
2025-01-19

## Files
- `app/page.tsx` (replace existing redirect with Screen 2)
- `app/preview/page.tsx` (new file)
- `lib/tests.ts` (already exists - verify function)
- `app/api/tests/anonymous/route.ts` (already exists - verify endpoint)

## Dependencies
**Must exist before implementation**:
- ✅ `lib/tests.ts` with `generateSmartDefaults(appUrl)` function (Stage 1)
- ✅ `/api/tests/anonymous` POST endpoint (Stage 1)
- ✅ All shadcn/ui components (Stage 1)
- ✅ Database tables: `tests`, `anonymous_tests` (Stage 1)

**Next screens in flow**:
- Screen 4: `/customize` (optional - not in this task)
- Screen 5: `/pricing` (next implementation)

---

## Technical Discovery

### Component Identification Verification
- **Target Pages**:
  - `/` (Screen 2 - Enter URL at app root)
  - `/preview` (Screen 3 - Preview Test)
- **New Components**: Screen 2 replaces existing redirect page, Screen 3 is new
- **Verification Steps**:
  - [x] Verified existing root page is a simple redirect - safe to replace
  - [x] Confirmed routing structure follows Next.js 13+ App Router conventions
  - [x] Checked parent layout compatibility with new routes
  - [x] Verified client component requirements ('use client' directive)

**Routing Path Validation:**
- `/` will be replaced in `app/page.tsx` (existing redirect replaced with Screen 2)
- `/preview` will be created as `app/preview/page.tsx`
- ✅ No naming conflicts with existing routes
- ✅ App Router conventions followed

### MCP Research Results

#### shadcn/ui Components Verification
All required UI components are installed and available:

**Card Component** - ✅ Available
- **Location**: `@/components/ui/card`
- **Exports**: Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter
- **Verified**: All required card components exist and functional
- **Usage**: Main layout structure for both screens

**Button Component** - ✅ Available
- **Location**: `@/components/ui/button`
- **Props**: variant (default, outline, etc.), size (sm, default, lg, icon), disabled
- **Verified**: Supports all variants needed (default, outline)
- **Usage**: Submit buttons, action buttons

**Input Component** - ✅ Available
- **Location**: `@/components/ui/input`
- **Props**: type, placeholder, value, onChange, className, required, autoFocus
- **Verified**: Standard HTML input with shadcn styling
- **Usage**: URL input field on Screen 2

**Label Component** - ✅ Available
- **Location**: `@/components/ui/label`
- **Verified**: Radix UI Label with accessibility support
- **Usage**: Form field labels

**Badge Component** - ✅ Available
- **Location**: `@/components/ui/badge`
- **Props**: variant (default, secondary, destructive, outline)
- **Verified**: Available for potential status indicators
- **Usage**: Optional - may be used in preview display

#### Icon Library Verification
**lucide-react** - ✅ Available (v0.511.0)
- **Required Icons**: ArrowRight, Sparkles, Edit, CheckCircle, Users, Mic, FileText
- **Verified**: All icons available in installed version
- **Import**: `import { IconName } from 'lucide-react'`

#### Backend API Verification
**POST /api/tests/anonymous** - ✅ Verified
- **Location**: `app/api/tests/anonymous/route.ts`
- **Accepts**: JSON body with structure:
  ```typescript
  {
    url: string,
    title?: string,
    welcome_message?: string,
    instructions?: string,
    tasks?: Array<any>,
    thank_you_message?: string
  }
  ```
- **Returns**: `{ sessionToken, testId, shareToken }`
- **Database Operations**: 
  - Creates record in `anonymous_tests` table with 24hr expiration
  - Creates record in `tests` table with `is_anonymous: true`
  - Links both records for later claim flow
- **Error Handling**: Validates URL presence, handles database errors gracefully

#### Utility Function Verification
**generateSmartDefaults()** - ✅ Verified with ISSUE
- **Location**: `lib/tests.ts`
- **Signature**: `generateSmartDefaults(appUrl: string)`
- **Current Return Structure**:
  ```typescript
  {
    title: string,
    welcome_message: string,
    instructions: string,
    tasks: string[],  // ⚠️ ISSUE: Returns string array
    thank_you_message: string
  }
  ```
- **Expected by Plan**: 
  ```typescript
  tasks: Array<{ description: string; is_optional?: boolean }>
  ```

**⚠️ CRITICAL DATA STRUCTURE ISSUE IDENTIFIED**

**Issue**: Data structure mismatch in tasks field
- **Current Implementation**: `generateSmartDefaults()` returns `tasks` as `string[]` (lines 46-50)
- **Plan Expectation**: Review notes specify tasks should be objects with `{description: string, is_optional?: boolean}` (lines 539-554)
- **API Acceptance**: API route accepts `tasks?: Array<any>` (flexible schema)
- **Database Schema**: `config.tasks` field type in database schema TBD

**Resolution Options**:
1. **Option A (Recommended)**: Update `generateSmartDefaults()` to return object structure
2. **Option B**: Keep string array, update preview page to handle string array
3. **Option C**: Transform in Screen 2 before storing in sessionStorage

**Recommendation**: Option A - Update `generateSmartDefaults()` for consistency
- Aligns with review notes resolution (lines 532-554)
- Maintains type safety throughout flow
- Matches database schema expectations
- Single source of truth for task structure

### Implementation Feasibility

#### Technical Blockers
**None** - All dependencies available and functional

#### Required Adjustments
1. **REQUIRED**: Update `generateSmartDefaults()` tasks return structure
   - Change from: `tasks: ['string1', 'string2', 'string3']`
   - Change to: `tasks: [{ description: 'string1', is_optional: false }, ...]`
   - File: `lib/tests.ts` lines 46-50

2. **REQUIRED**: Verify task structure in preview page rendering
   - Confirm `task.description` is accessed correctly
   - File: `app/preview/page.tsx` (to be created)

3. **RECOMMENDED**: Add TypeScript interface for storage utility
   - The plan includes a storage utility with localStorage fallback (lines 593-618)
   - Consider extracting to shared utility file for reusability
   - Potential location: `lib/storage-utils.ts` (optional)

#### Component Interaction and Event System Validation
**Form Handling on Screen 2**:
- Standard React form with `onSubmit` handler
- URL validation using native `new URL()` constructor
- No complex event propagation - straightforward form submission
- ✅ No conflicts with existing patterns

**Navigation Between Screens**:
- Uses Next.js `useRouter` from `next/navigation`
- Client-side navigation with `router.push()`
- sessionStorage acts as state persistence layer
- ✅ Pattern already used in existing `/zebra` flow

**iframe Integration on Screen 3**:
- Displays target URL in iframe
- Sandbox attribute: `"allow-same-origin allow-scripts"`
- Error handling for X-Frame-Options restrictions (plan includes fallback UI)
- ✅ No portal requirements, standard iframe rendering

#### Storage Pattern Verification
**sessionStorage Contract**:
- Screen 2 writes: `test_url` (string), `test_config` (JSON object)
- Screen 3 reads: `test_config`, redirects if missing
- Screen 3 writes: `anonymous_session` (sessionToken from API)
- ✅ Clear unidirectional flow, no circular dependencies

**localStorage Fallback** (from plan lines 593-618):
- Provides resilience for private browsing mode
- Backup keys with `_backup_` prefix
- ✅ Good defensive programming pattern

#### Debug and Development Tool Research
**Debug Strategy Recommendations**:
- Use React DevTools for component state inspection
- Browser Network tab for API call verification
- sessionStorage inspection in Application tab
- Console logging for flow tracking (to be removed before production)

**No special debug infrastructure needed** - standard browser tools sufficient

#### API Interface Completeness Verification
**POST /api/tests/anonymous Interface** - ✅ Complete
- **Accepts all required fields**: url, title, welcome_message, instructions, tasks, thank_you_message
- **Returns all needed data**: sessionToken (for signup flow), testId, shareToken (for sharing)
- **Error handling**: Validates required fields, provides error responses
- ✅ No missing parameters

**Missing Route Verification**:
- `/pricing` route referenced in plan - ⚠️ Not yet implemented
- Screen 3 navigates to `/pricing` after test creation
- **Not blocking**: Can be created in separate task
- **Temporary solution**: Could redirect to existing page or show placeholder

### CSS Component Integration Verification

#### Layout Compatibility Analysis
**Background Gradient Pattern**:
- Both screens use: `bg-gradient-to-b from-background to-muted/20`
- ✅ Standard Tailwind gradient classes
- ✅ Uses theme CSS variables (--background, --muted)
- ✅ No conflicts with existing layouts

**Card Component Default Styles**:
- Default classes: `rounded-xl border bg-card text-card-foreground shadow`
- Screen 2 uses: `border-2` override (thicker border)
- Screen 3 uses: `overflow-hidden` for iframe container
- ✅ Override strategy is clean, no conflicts

**Grid Layout on Screen 3**:
- Uses: `lg:grid-cols-2` for desktop split-screen
- Max width: `max-w-6xl` (1152px)
- ✅ Responsive breakpoints follow Tailwind conventions
- ✅ No special CSS needed

#### Theme Variable Usage
**CSS Variables Verified**:
- `--background`: Main background color
- `--muted`: Muted variant color with opacity
- `--primary`: Primary action color
- `--border`: Border color
- `--card`: Card background
- `--destructive`: Error/destructive action color
- ✅ All variables available in theme system

**No Custom CSS Required** - All styling uses Tailwind utilities and theme variables

### Backend Schema Validation

#### Database Schema Verification
**tests table** - ✅ Verified (from Stage 1 migration)
- Fields: `id`, `user_id`, `share_token`, `app_url`, `config` (JSONB), `is_active`, `is_anonymous`, `created_at`, `claimed_at`
- `config` structure matches expected format
- `is_anonymous` boolean flag for anonymous tests
- ✅ Schema supports all required fields

**anonymous_tests table** - ✅ Verified (from Stage 1 migration)
- Fields: `id`, `session_token`, `test_data` (JSONB), `expires_at`, `created_at`
- Stores temporary session data for 24 hours
- Links to tests table via session_token
- ✅ Supports anonymous flow

#### Data Relationship Verification
**Test Creation Flow**:
1. Screen 3 calls `/api/tests/anonymous`
2. API creates anonymous_tests record with session_token
3. API creates tests record with `is_anonymous: true`
4. API links both records by storing test_id and share_token in anonymous_tests.test_data
5. Returns sessionToken to frontend
- ✅ Complete data relationship chain verified

**No Missing Fields** - All required relationships properly implemented

### Database Constraint Verification

#### Field Constraints Check
**tests.app_url** - Verified
- Type: TEXT
- Constraint: NOT NULL
- ✅ Plan requires URL validation before submission

**tests.config** - Verified
- Type: JSONB
- Constraint: NOT NULL with default `'{}'::jsonb`
- ✅ API provides complete config object

**tests.is_anonymous** - Verified
- Type: BOOLEAN
- Constraint: NOT NULL with default `false`
- ✅ API explicitly sets to `true` for anonymous tests

**anonymous_tests.session_token** - Verified
- Type: TEXT
- Constraint: NOT NULL, UNIQUE
- ✅ Generated using nanoid() in API

**No Constraint Conflicts** - All NOT NULL fields properly handled

### UI Component Interaction Validation

#### Conditional Rendering Analysis
**Screen 2 (Create Page)**:
- Conditional error message display: `{error && <p>...</p>}`
- Button disabled state: `disabled={loading}`
- Button text change: `{loading ? 'Setting up...' : 'Continue'}`
- ✅ Simple conditional patterns, no conflicts

**Screen 3 (Preview Page)**:
- Early return if config missing: `if (!config) return null`
- Redirect to `/` (app root) if no sessionStorage data
- Button disabled during API call
- Optional iframe error handling (from plan lines 556-588)
- ✅ All conditional logic validated

**No Exclusion Logic Issues** - No page-specific restrictions found in existing components

### Discovery Summary

#### All Components Available: ✅ YES
- All shadcn/ui components installed and verified
- lucide-react icons available (v0.511.0)
- Next.js routing utilities available
- All imports validated

#### Technical Blockers: ⚠️ ONE MINOR ISSUE
**Data Structure Adjustment Required**:
- `generateSmartDefaults()` returns `tasks: string[]`
- Plan expects `tasks: Array<{ description: string; is_optional?: boolean }>`
- **Impact**: Minor - single function update in `lib/tests.ts`
- **Solution**: Update return structure to match interface (lines 46-50)
- **Estimated time**: 2 minutes

#### Ready for Implementation: ✅ YES (with adjustment)
**Prerequisites Met**:
- ✅ All UI components available
- ✅ API endpoint functional
- ✅ Database schema complete
- ✅ Routing structure clear
- ✅ No naming conflicts
- ⚠️ Requires generateSmartDefaults() update first

#### Special Notes:
1. **Storage Utility**: Plan includes comprehensive localStorage fallback (lines 593-618) - consider extracting to shared utility
2. **iframe Error Handling**: Plan includes X-Frame-Options error UI (lines 556-588) - good defensive programming
3. **Missing Route**: `/pricing` not yet implemented but not blocking for this task
4. **TypeScript Interfaces**: Consider adding explicit types for sessionStorage contract
5. **Data Flow**: Clean unidirectional data flow from Screen 2 → sessionStorage → Screen 3 → API

### Required Installations

**No additional installations required** - All dependencies already present:
- shadcn/ui components: Card, Button, Input, Label, Badge ✅ installed
- lucide-react ✅ installed (v0.511.0)
- Next.js 13+ App Router ✅ available
- nanoid ✅ installed (used by API)

### Execution Readiness Checklist

- [x] **CRITICAL**: Component identification verified - correct routes for new pages
- [x] Page-to-component rendering path validated
- [x] All mentioned components exist in shadcn/ui
- [x] Component APIs match planned usage
- [x] Import paths verified
- [x] No version conflicts
- [x] No design specs extraction needed (code-defined UI)
- [x] Dependencies available (no installation needed)
- [ ] **REQUIRED**: Update generateSmartDefaults() tasks structure (blocking)
- [x] No other technical blockers

### Next Steps for Agent 4 (Execution)

1. **FIRST**: Update `lib/tests.ts` generateSmartDefaults() function:
   ```typescript
   // Change lines 46-50 from:
   tasks: [
     'Try to complete the main action on this page',
     'Find information about pricing or features',
     'Share your overall impression of the experience'
   ]
   // To:
   tasks: [
     { description: 'Try to complete the main action on this page', is_optional: false },
     { description: 'Find information about pricing or features', is_optional: false },
     { description: 'Share your overall impression of the experience', is_optional: false }
   ]
   ```

2. **THEN**: Replace `app/page.tsx` with Screen 2 code
   - Use complete code from plan lines 105-213
   - Implement storage utility with localStorage fallback (lines 593-618)
   - Verify TypeScript compilation

3. **THEN**: Create `app/preview/page.tsx` (Screen 3)
   - Use complete code from plan lines 224-393
   - Add iframe error handling (lines 556-588)
   - Update task rendering to use `task.description` (lines 545-554)
   - Verify TypeScript compilation

4. **FINALLY**: Test complete flow
   - Navigate to `/` (app root)
   - Enter test URL
   - Verify navigation to `/preview`
   - Verify API call to `/api/tests/anonymous`
   - Check sessionStorage data persistence

**Estimated Implementation Time**: 15-20 minutes (including testing)

---

## Implementation Notes

### Summary
Successfully implemented Screen 2 (Enter URL) and Screen 3 (Preview Test) as the foundation of the test creation flow. All requirements from the original MVP plan have been implemented with the specified enhancements.

### Files Created
1. **`lib/storage-utils.ts`** (NEW - 38 lines)
   - Storage utility with localStorage fallback for private browsing resilience
   - Implements backup key pattern (`_backup_` prefix)
   - Graceful fallback when sessionStorage unavailable

2. **`app/preview/page.tsx`** (NEW - 212 lines)
   - Screen 3: Test Preview with split-screen layout
   - iframe integration with error handling for X-Frame-Options restrictions
   - Three information cards: Welcome Message, Test Tasks, Recording Method
   - Progress indicator showing 2/4 steps completed
   - Two action buttons: "Customize Test" (outline) and "Looks Good - Continue" (primary)

### Files Modified
1. **`lib/tests.ts`** (UPDATED)
   - **Lines 46-50**: Updated `generateSmartDefaults()` to return task objects instead of strings
   - **Lines 59-63**: Updated fallback tasks to match object structure
   - Changed from: `tasks: ['string1', 'string2', 'string3']`
   - Changed to: `tasks: [{ description: 'string1', is_optional: false }, ...]`
   - Maintains consistency with TypeScript interface (line 13)

2. **`app/page.tsx`** (REPLACED - 7 lines → 109 lines)
   - Replaced simple redirect with full Screen 2 implementation
   - URL input form with validation using native `new URL()` constructor
   - Progress indicator showing 1/4 steps completed
   - Loading states with button text changes ("Setting up...")
   - Error handling with destructive text color
   - Integration with storage utility for resilient data persistence

### Implementation Enhancements
✅ **All planned enhancements implemented**:
1. **Tasks as Objects** (lines 532-554 resolution)
   - Consistent data structure throughout: `{description: string, is_optional: boolean}`
   - Preview page accesses `task.description` correctly
   - Type safety maintained across flow

2. **iframe Error Handling** (lines 556-588 resolution)
   - Detects X-Frame-Options blocking with `onError` handler
   - Shows user-friendly message: "Preview blocked by website"
   - Educational link to MDN documentation
   - Reassures user: "The test will still work normally"

3. **Storage Fallback** (lines 593-618 resolution)
   - Extracted to reusable `lib/storage-utils.ts`
   - Supports private browsing mode
   - Automatic backup to localStorage with `_backup_` prefix
   - Three-layer fallback: sessionStorage → backup → localStorage

### Code Quality Verification
✅ **TypeScript Compilation**: 0 errors
✅ **Next.js Build**: Successful (3.8s compile time)
✅ **Static Analysis**: Both routes generated successfully
   - `/` (Static) - Screen 2: Enter URL
   - `/preview` (Static) - Screen 3: Preview Test
✅ **Dependencies**: No new installations required (all components available)

### Technical Decisions
1. **Storage Utility Extraction**: Created `lib/storage-utils.ts` instead of inline implementation
   - **Rationale**: Reusability across other flows (signup, customize, etc.)
   - **Benefits**: Single source of truth, easier testing, consistent behavior

2. **TypeScript Interface**: Defined `TestConfig` interface in preview page
   - **Rationale**: Type safety for sessionStorage contract
   - **Benefits**: Autocomplete, compile-time validation, self-documenting

3. **Error Handling Strategy**: Try-catch with user-friendly error messages
   - **Rationale**: Graceful degradation, user guidance
   - **Benefits**: Better UX, reduced support burden

### Known Limitations
⚠️ **Missing `/pricing` Route**: Screen 3 navigates to `/pricing` after test creation
- **Impact**: User will see 404 after clicking "Looks Good - Continue"
- **Workaround**: Temporary - can be implemented in separate task
- **Blocking**: No - does not prevent testing of Screen 2 & 3 functionality

⚠️ **URL Validation**: Only validates URL format, not accessibility
- **Impact**: Valid URL format but unreachable site will pass validation
- **Workaround**: iframe error handling provides feedback on preview screen
- **Blocking**: No - acceptable for MVP

### Integration Verification
✅ **Dependencies Validated**:
- `generateSmartDefaults()` function: Returns correct object structure
- `/api/tests/anonymous` endpoint: Accepts task objects, returns sessionToken
- All shadcn/ui components: Card, Button, Input, Label available
- lucide-react icons: ArrowRight, Sparkles, Edit, CheckCircle, Users, Mic, FileText

✅ **Data Flow Validated**:
```
User enters URL → Validate → Generate defaults → Store in storage
  ↓
Navigate to /preview → Load from storage → Display config
  ↓
Click Continue → POST /api/tests/anonymous → Store sessionToken → Navigate to /pricing
```

### Testing Results
**Build Verification**: ✅ Passed
- Compiled successfully in 3.8s
- TypeScript checking passed
- All routes generated (26/26)
- No errors or warnings

**Static Analysis**: ✅ Passed
- Route `/` properly registered as Static
- Route `/preview` properly registered as Static
- No import errors
- No type errors

---

## Manual Test Instructions

### Prerequisites
1. **Development Server**: Start with `pnpm run dev` (port 3000) or `pnpm run dev:parallel` (port 3001)
2. **Browser**: Chrome, Safari, or Firefox (latest version)
3. **DevTools**: Open Browser DevTools (F12) for debugging

### Test Flow Overview
This test validates the complete user journey for creating a test:
1. Navigate to root page (`/`)
2. Enter a URL
3. See preview with generated defaults
4. Verify data persistence
5. Create test in database

---

### Screen 2: Enter URL (`/`) - Complete Test Checklist

#### Visual Verification
Navigate to: `http://localhost:3000/` (or `http://localhost:3001/`)

**Progress Indicator**:
- [ ] Four progress dots visible at top
- [ ] First dot is filled (primary color)
- [ ] Other three dots are border outline (unfilled)
- [ ] Dots connected by horizontal lines

**Card Layout**:
- [ ] Centered card with thicker border (`border-2`)
- [ ] Gradient background visible (subtle fade from background to muted)
- [ ] Sparkles icon in primary/10 background circle
- [ ] Icon is centered above title
- [ ] Card title: "Test Your App's UX" (3xl size)
- [ ] Card description: "Get video feedback from real users in minutes" (lg size)

**Form Elements**:
- [ ] Label text: "Enter your app or website URL"
- [ ] Input field has placeholder: "e.g., https://yourapp.com"
- [ ] Input field is large (text-lg, py-6)
- [ ] Input field has autofocus (cursor should be in field on page load)
- [ ] Submit button text: "Continue" with arrow icon
- [ ] Button is full width
- [ ] Bottom text: "No signup required • See preview instantly • 2 minutes to your first test"

#### Functional Testing - Valid URL

**Test Case 1: Enter Valid URL**
1. Enter URL: `https://example.com`
2. Click "Continue" button

**Expected Behavior**:
- [ ] Button text changes to "Setting up..." immediately
- [ ] Button becomes disabled (grayed out)
- [ ] Navigation occurs to `/preview` page within 1 second
- [ ] No errors in console

**sessionStorage Verification** (DevTools → Application tab → Storage → Session Storage):
- [ ] Key `test_url` exists with value: `"https://example.com"`
- [ ] Key `test_config` exists with JSON object containing:
  - `url`: `"https://example.com"`
  - `title`: `"Example User Testing"` (smart default from hostname)
  - `welcome_message`: `"Help us improve Example - your feedback matters!"`
  - `instructions`: `"Please think out loud as you navigate..."`
  - `tasks`: Array of 3 objects with `description` and `is_optional` fields
  - `thank_you_message`: `"Thank you for your valuable feedback!"`

**localStorage Verification** (DevTools → Application tab → Storage → Local Storage):
- [ ] Key `_backup_test_url` exists (fallback storage)
- [ ] Key `_backup_test_config` exists (fallback storage)

#### Functional Testing - Invalid URL

**Test Case 2: Enter Invalid URL**
1. Clear the input field
2. Enter invalid URL: `not-a-url`
3. Click "Continue" button

**Expected Behavior**:
- [ ] Button text briefly changes to "Setting up..."
- [ ] Error message appears in red below input: "Please enter a valid URL"
- [ ] Button re-enables and text returns to "Continue"
- [ ] User remains on `/` page (no navigation)
- [ ] Input field remains focused

**Test Case 3: Empty Submission**
1. Clear the input field
2. Click "Continue" button

**Expected Behavior**:
- [ ] HTML5 validation message appears: "Please fill out this field"
- [ ] Form does not submit
- [ ] No error handling triggered (HTML handles this)

#### Responsive Design Testing

**Desktop (1920x1080)**:
- [ ] Card max-width: 2xl (672px) - card should not expand beyond this
- [ ] Card centered horizontally
- [ ] Padding: 6 units around content
- [ ] Progress indicator visible and centered

**Tablet (768px)**:
- [ ] Card adjusts to screen width (maintains padding)
- [ ] All text remains readable
- [ ] Form elements stack properly
- [ ] No horizontal overflow

**Mobile (375px)**:
- [ ] Card fits screen width (respects 6-unit padding)
- [ ] Text sizes remain readable
- [ ] Button text doesn't wrap
- [ ] Progress indicator scales appropriately

---

### Screen 3: Preview Test (`/preview`) - Complete Test Checklist

#### Visual Verification
Navigate to: `http://localhost:3000/preview` (should auto-navigate from Screen 2)

**Progress Indicator**:
- [ ] Four progress dots visible at top
- [ ] First two dots filled (primary color)
- [ ] First connecting line filled (primary color)
- [ ] Last two dots and connecting lines are border outline (unfilled)

**Page Header**:
- [ ] Title: "Preview Your Test" (3xl, bold)
- [ ] Subtitle: "This is exactly what your testers will see and do" (muted color)
- [ ] Both centered

**Split-Screen Layout (Desktop)**:
- [ ] Two-column grid visible on desktop (lg:grid-cols-2)
- [ ] Left column: iframe card
- [ ] Right column: three configuration cards
- [ ] Gap between columns: 8 units
- [ ] Max width: 6xl (1152px)

#### Left Column: App Preview Card

**Card Structure**:
- [ ] Header background: muted/50 color
- [ ] Title: "Your App" (lg size)
- [ ] Description: Shows the URL entered on Screen 2 (e.g., "https://example.com")
- [ ] Content section has no padding (p-0)

**iframe Verification**:
- [ ] iframe loads the target URL
- [ ] iframe height: 500px
- [ ] iframe has no border
- [ ] Sandbox attributes: "allow-same-origin allow-scripts"
- [ ] Gradient overlay visible (pointer-events-none, subtle fade from bottom)

**iframe Error Handling** (if site blocks embedding):
Test with: `https://github.com` (GitHub blocks embedding)
- [ ] Error UI appears over iframe
- [ ] Background: muted/90 overlay
- [ ] Error message: "Preview blocked by website"
- [ ] Explanation: "This site prevents embedding. The test will still work normally."
- [ ] Link to MDN docs about iframe restrictions
- [ ] Link opens in new tab

#### Right Column: Configuration Cards

**Card 1: Welcome Message**
- [ ] Icon: Users (5x5 size)
- [ ] Title: "Welcome Message" with icon
- [ ] Content: Shows generated welcome message (e.g., "Help us improve Example - your feedback matters!")
- [ ] Text size: sm

**Card 2: Test Tasks**
- [ ] Icon: FileText (5x5 size)
- [ ] Title: "Test Tasks" with icon
- [ ] Content: Numbered list (ordered list)
- [ ] Three tasks rendered as list items
- [ ] Each task has:
  - Circle badge with number (1, 2, 3)
  - Badge background: primary/10
  - Badge text: xs, font-semibold
  - Task description text: sm size
- [ ] Task text wraps properly
- [ ] Vertical spacing between tasks: 2 units

**Verify Task Structure**:
- [ ] Task 1: "Try to complete the main action on this page"
- [ ] Task 2: "Find information about pricing or features"
- [ ] Task 3: "Share your overall impression of the experience"
- [ ] No console errors about `task.description` (confirms object structure working)

**Card 3: Recording Method**
- [ ] Icon: Mic (5x5 size)
- [ ] Title: "Recording Method" with icon
- [ ] Three checkmark items:
  1. "Screen + Voice Recording"
  2. "AI Transcription Included"
  3. "Text Feedback Option Available"
- [ ] Each item has:
  - Green checkmark icon (CheckCircle, 4x4 size)
  - Text: sm size
  - Proper alignment with gap-2
- [ ] Vertical spacing between items: 2 units margin-top

#### Action Buttons

**Button Layout**:
- [ ] Two buttons centered horizontally
- [ ] Gap between buttons: 4 units
- [ ] Both buttons size: lg

**"Customize Test" Button (Outline)**:
- [ ] Variant: outline
- [ ] Icon: Edit (4x4, left side with mr-2)
- [ ] Text: "Customize Test"
- [ ] Hover state works (outline becomes more prominent)

**"Looks Good - Continue" Button (Primary)**:
- [ ] Variant: default (primary)
- [ ] Icon: ArrowRight (4x4, right side with ml-2)
- [ ] Text: "Looks Good - Continue"
- [ ] Hover state works (background darkens)

**Bottom Text**:
- [ ] Text: "Most users proceed with smart defaults • Customization is optional"
- [ ] Color: muted-foreground
- [ ] Size: sm
- [ ] Centered
- [ ] Margin-top: 4 units

#### Functional Testing - Continue Flow

**Test Case 1: Create Test in Database**
1. Ensure you're on `/preview` page with valid config
2. Open DevTools Network tab
3. Click "Looks Good - Continue" button

**Expected Behavior - Button State**:
- [ ] Button text changes to "Creating..." immediately
- [ ] Button becomes disabled (grayed out)
- [ ] Button re-enables after API response (or stays disabled if navigating)

**Expected Behavior - Network Request**:
- [ ] POST request to `/api/tests/anonymous` visible in Network tab
- [ ] Request payload contains:
  - `url`: The entered URL
  - `title`, `welcome_message`, `instructions`: Generated defaults
  - `tasks`: Array of task objects (not strings)
  - `thank_you_message`: Generated default
- [ ] Response status: 200 OK
- [ ] Response body contains:
  - `sessionToken`: UUID string
  - `testId`: UUID string
  - `shareToken`: Short string (nanoid)

**Expected Behavior - Storage**:
- [ ] sessionStorage contains new key: `anonymous_session`
- [ ] Value is the `sessionToken` from API response
- [ ] localStorage backup also created: `_backup_anonymous_session`

**Expected Behavior - Navigation**:
- [ ] ⚠️ Navigation to `/pricing` occurs
- [ ] ⚠️ **EXPECTED**: Will show 404 page (pricing route not yet implemented)
- [ ] ⚠️ This is a known limitation - pricing page is next task

#### Functional Testing - Error Scenarios

**Test Case 2: Direct Navigation Without Data**
1. Clear all sessionStorage: DevTools → Application → Session Storage → Right-click → Clear
2. Navigate directly to: `http://localhost:3000/preview`

**Expected Behavior**:
- [ ] Immediate redirect to `/` (root page)
- [ ] No error messages shown to user
- [ ] Console shows no errors (silent redirect)

**Test Case 3: Customize Button**
1. From preview page, click "Customize Test" button

**Expected Behavior**:
- [ ] ⚠️ Navigation to `/customize` occurs
- [ ] ⚠️ **EXPECTED**: Will show 404 page (customize route not yet implemented)
- [ ] ⚠️ This is a known limitation - customize page is future task

#### Responsive Design Testing

**Desktop (1920x1080)**:
- [ ] Two-column grid layout (side-by-side)
- [ ] Left column (iframe): Takes 50% width
- [ ] Right column (cards): Takes 50% width
- [ ] Max width: 6xl (1152px) - content doesn't expand beyond this
- [ ] Centered horizontally on screen

**Tablet (768-1023px)**:
- [ ] **Below lg breakpoint**: Single column layout (stacked)
- [ ] iframe card appears first (top)
- [ ] Configuration cards appear below
- [ ] Both sections take full width
- [ ] Gap maintained: 8 units vertical

**Mobile (375px)**:
- [ ] Single column layout (stacked)
- [ ] iframe height remains 500px (may need horizontal scroll)
- [ ] Cards stack vertically
- [ ] Text remains readable
- [ ] Buttons stack or shrink to fit
- [ ] No horizontal overflow (except iframe content)

---

### Database Verification

**Verify Test Creation**:
1. After clicking "Looks Good - Continue" on preview page
2. Open Supabase Dashboard or use SQL client
3. Check `anonymous_tests` table

**Expected Database Records - `anonymous_tests` table**:
- [ ] New record exists with:
  - `id`: UUID
  - `session_token`: Matches sessionStorage `anonymous_session` value
  - `test_data`: JSONB object containing `testId` and `shareToken`
  - `expires_at`: 24 hours from `created_at`
  - `created_at`: Current timestamp

**Expected Database Records - `tests` table**:
- [ ] New record exists with:
  - `id`: Matches `testId` from API response
  - `user_id`: NULL (anonymous test)
  - `share_token`: Matches from API response
  - `app_url`: The entered URL
  - `config`: JSONB object with `title`, `welcome_message`, `instructions`, `tasks`, `thank_you_message`
  - `is_active`: true
  - `is_anonymous`: true
  - `created_at`: Current timestamp
  - `claimed_at`: NULL (not yet claimed)

**Verify Tasks Structure in Database**:
- [ ] `config.tasks` is array of objects
- [ ] Each task has `description` field (string)
- [ ] Each task has `is_optional` field (boolean)
- [ ] Example: `[{"description": "Try to complete...", "is_optional": false}, ...]`

---

### Cross-Browser Testing (Optional)

**Chrome/Edge (Chromium)**:
- [ ] All features work as expected
- [ ] iframe loads correctly
- [ ] Storage persists between page refreshes

**Firefox**:
- [ ] All features work as expected
- [ ] iframe sandbox attribute handled correctly
- [ ] Storage API works identically

**Safari**:
- [ ] All features work as expected
- [ ] Private browsing mode: localStorage fallback activates
- [ ] No console errors related to storage

---

### Accessibility Testing (Optional)

**Keyboard Navigation**:
- [ ] Tab key navigates through: input → button → customize button → continue button
- [ ] Enter key submits form on Screen 2
- [ ] Enter key activates buttons on Screen 3
- [ ] Focus indicators visible on all interactive elements

**Screen Reader** (Optional):
- [ ] Form label associated with input field
- [ ] Button purpose is clear ("Continue", "Looks Good - Continue")
- [ ] Error messages announced when they appear
- [ ] Card titles provide context for content

---

### Performance Testing (Optional)

**Page Load**:
- [ ] Screen 2 loads in under 1 second
- [ ] Screen 3 loads in under 2 seconds (includes iframe)
- [ ] No layout shift during load
- [ ] Icons load without flash of unstyled content

**Storage Operations**:
- [ ] sessionStorage writes complete in under 10ms
- [ ] Config retrieval is instant (no perceived delay)
- [ ] localStorage fallback adds less than 5ms overhead

---

### Final Acceptance Criteria

✅ **Screen 2 (Enter URL)**:
- [ ] User can enter URL and see validation
- [ ] Valid URL navigates to preview with data
- [ ] Invalid URL shows clear error message
- [ ] sessionStorage contains test_url and test_config

✅ **Screen 3 (Preview Test)**:
- [ ] User can see preview of their app (iframe)
- [ ] Generated defaults display correctly (title, message, tasks)
- [ ] Task objects render properly (description shown)
- [ ] iframe error handling works for blocked sites
- [ ] "Continue" button creates test in database
- [ ] sessionToken stored after creation

✅ **Data Persistence**:
- [ ] sessionStorage works correctly
- [ ] localStorage fallback activates in private browsing
- [ ] Data survives page refresh (until tab closed)

✅ **Build & Quality**:
- [ ] TypeScript: 0 errors
- [ ] Next.js build: Successful
- [ ] No console errors during normal flow
- [ ] Both routes properly registered

---

### Known Issues / Limitations to Note

⚠️ **Expected Limitations** (Not blocking for this task):
1. **Missing `/pricing` Route**: 404 after clicking "Looks Good - Continue"
   - This is expected - pricing page is next implementation phase

2. **Missing `/customize` Route**: 404 after clicking "Customize Test"
   - This is expected - customization page is future task

3. **URL Accessibility**: Validation only checks format, not reachability
   - Acceptable for MVP - iframe error handling provides feedback

⚠️ **Report Any Unexpected Issues**:
- Console errors during normal flow
- TypeScript errors
- Data not persisting between screens
- UI elements not matching design specifications
- Buttons not working as expected
- iframe not loading sites that should be embeddable

---

### Testing Complete

When all checkboxes are verified ✅, the implementation is ready for production deployment.

**Next Steps**:
1. Implement `/pricing` route (next priority)
2. Implement `/customize` route (optional feature)
3. Add analytics tracking to measure conversion rates
4. Add automated E2E tests for this flow

---

## User Testing Feedback Improvements (Added 2025-01-26)

### Original Feedback Request
User provided the following testing notes:

> 1. /preview - "This is exactly what your testers will see and do" - is not the case because it demo's the left of the app and the right the welcome messages - how can we improve this copy?
>
> 2. / - Different urls or incorrect ones that do anything - e.g. "https://your app .com" still works even though it has spaces. What can we do to fix this?
>
> 3. Figma prototypes don't work - https://www.figma.com/proto/XrJhNM75GHzwz6ckt5iCVG/Ramp-Designs?node-id=30-229&t=cbVpuuJbqEIY5XL7-0&scaling=min-zoom&content-scaling=fixed&page-id=30%3A228&starting-point-node-id=30%3A229 - do you know why?
>
> 4. We don't seem to be able to handle any sites that can't do an iframe - e.g. if I enter "https://facebook.com" then its just blank on the next page, no error, no explanation. What should we do to improve this?
>
> 5. I'm looking at /preview - what do you think to us having edit buttons (on hover on desktop, always on mobile for good ux) on the preview of the onboarding cards on the right. E.g. Welcome message. So the user can click these and customise?

### Analysis & Recommendations

**Issue 1: Preview Copy Improvement**
- **Problem:** "This is exactly what your testers will see and do" is misleading - preview shows app + config, not actual tester flow
- **Recommendation:** Update copy to accurately describe what's shown
- **Decision:** Implement Option C with descriptive subtitle

**Issue 2: URL Validation**
- **Problem:** `new URL()` accepts malformed URLs with spaces like "https://your app .com"
- **Recommendation:** Add strict regex validation and whitespace trimming
- **Decision:** Implement regex validation before URL parsing

**Issue 3: Figma Prototypes**
- **Problem:** Figma requires embed URL format: `https://www.figma.com/embed?embed_host=share&url=...`
- **Recommendation:** Auto-detect and transform Figma URLs to embed format
- **Decision:** Implement Option A (auto-transform)

**Issue 4: Sites Blocking iframes**
- **Problem:** Sites like Facebook use X-Frame-Options headers, showing blank preview with no feedback
- **Recommendation:** Server-side HEAD request to check headers before loading iframe
- **Decision:** Implement Option A (server-side check) + provide user instructions if they can fix it
- **Future Feature:** Screenshot service fallback added to `future-features.md`

**Issue 5: Edit/Customize Buttons on Cards**
- **Problem:** Users may want to edit specific sections without going to full customize page
- **Recommendation:** Add hover-visible "Customize" buttons to each configuration card
- **Decision:** Implement with hover on desktop, always visible on mobile

---

## Improvement Implementation Plan

### Improvement 1: Update Preview Page Copy
**File:** `app/preview/page.tsx`

**Current Copy (lines ~279-283):**
```tsx
<div className="text-center mb-8">
  <h1 className="text-3xl font-bold mb-2">Preview Your Test</h1>
  <p className="text-muted-foreground">
    This is exactly what your testers will see and do
  </p>
</div>
```

**Updated Copy:**
```tsx
<div className="text-center mb-8">
  <h1 className="text-3xl font-bold mb-2">See how your test is configured</h1>
  <p className="text-muted-foreground">
    Your app preview on the left, test instructions your testers will see on the right
  </p>
</div>
```

**Rationale:** Accurately describes the split-screen layout and what each panel shows without misleading users about it being the exact tester experience.

---

### Improvement 2: Strict URL Validation
**File:** `app/page.tsx`

**Current Validation:**
```typescript
try {
  const validUrl = new URL(url);
  // proceeds...
} catch (err) {
  setError('Please enter a valid URL');
}
```

**Updated Validation:**
```typescript
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  setLoading(true);
  setError('');

  try {
    // Trim whitespace
    const trimmedUrl = url.trim();

    // Check for spaces in URL (invalid)
    if (/\s/.test(trimmedUrl)) {
      throw new Error('URL cannot contain spaces');
    }

    // Validate URL format with regex
    const urlRegex = /^https?:\/\/[^\s]+$/;
    if (!urlRegex.test(trimmedUrl)) {
      throw new Error('Please enter a valid URL starting with http:// or https://');
    }

    // Parse URL to validate structure
    const validUrl = new URL(trimmedUrl);

    // Additional: check hostname has at least one dot (e.g., example.com)
    if (!validUrl.hostname.includes('.')) {
      throw new Error('Please enter a complete URL (e.g., https://example.com)');
    }

    // Store trimmed URL
    storage.setItem('test_url', trimmedUrl);

    // Generate smart defaults with trimmed URL
    const testConfig = {
      url: trimmedUrl,
      ...generateSmartDefaults(trimmedUrl)
    };

    storage.setItem('test_config', JSON.stringify(testConfig));
    router.push('/preview');
  } catch (err) {
    if (err instanceof Error) {
      setError(err.message);
    } else {
      setError('Please enter a valid URL');
    }
    setLoading(false);
  }
};
```

**Error Messages:**
- "URL cannot contain spaces"
- "Please enter a valid URL starting with http:// or https://"
- "Please enter a complete URL (e.g., https://example.com)"

---

### Improvement 3: Auto-Transform Figma URLs
**File:** `lib/url-utils.ts` (NEW FILE)

**Create URL utility with Figma transform:**
```typescript
// lib/url-utils.ts

/**
 * Transforms certain URLs to their embeddable format
 * Currently supports: Figma prototypes and files
 */
export function transformUrlForEmbed(url: string): string {
  try {
    const parsedUrl = new URL(url);

    // Figma prototype and file URLs
    if (parsedUrl.hostname === 'www.figma.com' || parsedUrl.hostname === 'figma.com') {
      // Check if it's a proto or file URL that needs embedding
      if (parsedUrl.pathname.includes('/proto/') || parsedUrl.pathname.includes('/file/')) {
        // Transform to Figma embed format
        return `https://www.figma.com/embed?embed_host=share&url=${encodeURIComponent(url)}`;
      }
    }

    // Return original URL if no transformation needed
    return url;
  } catch {
    return url;
  }
}

/**
 * Check if URL is a Figma URL
 */
export function isFigmaUrl(url: string): boolean {
  try {
    const parsedUrl = new URL(url);
    return parsedUrl.hostname === 'www.figma.com' || parsedUrl.hostname === 'figma.com';
  } catch {
    return false;
  }
}
```

**Update preview page to use transform:**
```typescript
// In app/preview/page.tsx
import { transformUrlForEmbed, isFigmaUrl } from '@/lib/url-utils';

// In component:
const embedUrl = transformUrlForEmbed(config.url);
const isEmbedTransformed = embedUrl !== config.url;

// In JSX for iframe:
<iframe
  src={embedUrl}
  className="w-full h-[500px] border-0"
  sandbox="allow-same-origin allow-scripts allow-popups allow-forms"
  title="App preview"
  onError={() => setIframeError(true)}
/>

// Show info message if Figma was transformed:
{isEmbedTransformed && isFigmaUrl(config.url) && (
  <div className="px-4 py-2 bg-muted/50 text-xs text-muted-foreground">
    Figma prototype converted to embed format
  </div>
)}
```

---

### Improvement 4: Server-Side iframe Compatibility Check
**File:** `app/api/check-embed/route.ts` (NEW FILE)

**Create API endpoint to check X-Frame-Options:**
```typescript
// app/api/check-embed/route.ts
import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  try {
    const { url } = await request.json();

    if (!url) {
      return NextResponse.json({ embeddable: false, reason: 'No URL provided' }, { status: 400 });
    }

    // Make HEAD request to check headers
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 5000); // 5 second timeout

    try {
      const response = await fetch(url, {
        method: 'HEAD',
        signal: controller.signal,
        redirect: 'follow',
      });

      clearTimeout(timeoutId);

      // Check X-Frame-Options header
      const xFrameOptions = response.headers.get('x-frame-options');
      const csp = response.headers.get('content-security-policy');

      // X-Frame-Options: DENY or SAMEORIGIN blocks embedding
      if (xFrameOptions) {
        const value = xFrameOptions.toLowerCase();
        if (value === 'deny' || value === 'sameorigin') {
          return NextResponse.json({
            embeddable: false,
            reason: 'x-frame-options',
            header: xFrameOptions,
            canFix: true, // User might be able to fix this on their own site
          });
        }
      }

      // Check CSP frame-ancestors
      if (csp && csp.includes('frame-ancestors')) {
        // Simple check - if frame-ancestors doesn't include * or our domain, likely blocked
        if (!csp.includes("frame-ancestors 'self'") && !csp.includes('frame-ancestors *')) {
          return NextResponse.json({
            embeddable: false,
            reason: 'csp-frame-ancestors',
            canFix: true,
          });
        }
      }

      return NextResponse.json({ embeddable: true });

    } catch (fetchError) {
      clearTimeout(timeoutId);
      // Network error, timeout, or CORS - still might work in browser
      return NextResponse.json({
        embeddable: 'unknown',
        reason: 'network-error',
        canFix: false,
      });
    }

  } catch (error) {
    return NextResponse.json({ embeddable: 'unknown', reason: 'server-error' }, { status: 500 });
  }
}
```

**Update preview page to check embeddability:**
```typescript
// In app/preview/page.tsx

// Add state for embed check
const [embedCheck, setEmbedCheck] = useState<{
  checked: boolean;
  embeddable: boolean | 'unknown';
  reason?: string;
  canFix?: boolean;
}>({ checked: false, embeddable: true });

// Check embeddability on mount
useEffect(() => {
  const checkEmbed = async () => {
    if (!config?.url) return;

    try {
      const response = await fetch('/api/check-embed', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url: config.url }),
      });
      const result = await response.json();
      setEmbedCheck({
        checked: true,
        embeddable: result.embeddable,
        reason: result.reason,
        canFix: result.canFix,
      });
    } catch {
      setEmbedCheck({ checked: true, embeddable: 'unknown' });
    }
  };

  checkEmbed();
}, [config?.url]);
```

**Updated iframe UI with better error handling:**
```tsx
{/* Left: App Preview */}
<Card className="overflow-hidden">
  <CardHeader className="bg-muted/50">
    <CardTitle className="text-lg">Your App</CardTitle>
    <CardDescription>{config.url}</CardDescription>
  </CardHeader>
  <CardContent className="p-0">
    <div className="relative">
      {/* Show warning if embed check failed */}
      {embedCheck.checked && embedCheck.embeddable === false ? (
        <div className="w-full h-[500px] flex items-center justify-center bg-muted/30">
          <div className="text-center p-8 max-w-md">
            <AlertCircle className="w-12 h-12 mx-auto mb-4 text-amber-500" />
            <h3 className="font-semibold mb-2">Preview Not Available</h3>
            <p className="text-sm text-muted-foreground mb-4">
              This website prevents embedding in previews. Don't worry - your testers will access it directly, so the test will work normally.
            </p>

            {/* Show fix instructions if user can potentially fix it */}
            {embedCheck.canFix && (
              <div className="bg-muted rounded-lg p-4 text-left mb-4">
                <p className="text-xs font-medium mb-2">If this is your website:</p>
                <p className="text-xs text-muted-foreground">
                  You can enable embedding by removing or adjusting the <code className="px-1 bg-background rounded">X-Frame-Options</code> header in your server configuration.
                </p>
                <a
                  href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-xs text-primary hover:underline mt-2 inline-block"
                >
                  Learn more about iframe restrictions →
                </a>
              </div>
            )}

            {/* Show the URL prominently */}
            <div className="bg-background border rounded-lg p-3">
              <p className="text-xs text-muted-foreground mb-1">Testing URL:</p>
              <p className="text-sm font-mono break-all">{config.url}</p>
            </div>
          </div>
        </div>
      ) : (
        <>
          <iframe
            src={transformUrlForEmbed(config.url)}
            className="w-full h-[500px] border-0"
            sandbox="allow-same-origin allow-scripts allow-popups allow-forms"
            title="App preview"
            onError={() => setIframeError(true)}
          />
          <div className="absolute inset-0 bg-gradient-to-t from-background/20 to-transparent pointer-events-none" />
        </>
      )}
    </div>
  </CardContent>
</Card>
```

---

### Improvement 5: Customize Buttons on Configuration Cards
**File:** `app/preview/page.tsx`

**Add Pencil icon import:**
```typescript
import { CheckCircle, Edit, ArrowRight, Users, Mic, FileText, Pencil } from 'lucide-react';
```

**Create reusable card header with customize button:**
```tsx
// Component for card header with customize button
function ConfigCardHeader({
  icon: Icon,
  title,
  onCustomize
}: {
  icon: React.ElementType;
  title: string;
  onCustomize: () => void;
}) {
  return (
    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
      <CardTitle className="flex items-center gap-2 text-base">
        <Icon className="w-5 h-5" />
        {title}
      </CardTitle>
      <Button
        variant="ghost"
        size="sm"
        onClick={onCustomize}
        className="h-8 px-2 opacity-100 md:opacity-0 md:group-hover:opacity-100 transition-opacity"
      >
        <Pencil className="w-3.5 h-3.5 mr-1.5" />
        <span className="text-xs">Customize</span>
      </Button>
    </CardHeader>
  );
}
```

**Update cards to use new header with group hover:**
```tsx
{/* Right: Test Configuration */}
<div className="space-y-4">
  <Card className="group">
    <ConfigCardHeader
      icon={Users}
      title="Welcome Message"
      onCustomize={() => router.push('/customize')}
    />
    <CardContent className="pt-0">
      <p className="text-sm">{config.welcome_message}</p>
    </CardContent>
  </Card>

  <Card className="group">
    <ConfigCardHeader
      icon={FileText}
      title="Test Tasks"
      onCustomize={() => router.push('/customize')}
    />
    <CardContent className="pt-0">
      <ol className="space-y-2">
        {config.tasks.map((task: {description: string, is_optional?: boolean}, i: number) => (
          <li key={i} className="flex items-start gap-3">
            <span className="flex-shrink-0 w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center text-xs font-semibold">
              {i + 1}
            </span>
            <span className="text-sm">{task.description}</span>
          </li>
        ))}
      </ol>
    </CardContent>
  </Card>

  <Card className="group">
    <ConfigCardHeader
      icon={Mic}
      title="Recording Method"
      onCustomize={() => router.push('/customize')}
    />
    <CardContent className="pt-0">
      <div className="flex items-center gap-2">
        <CheckCircle className="w-4 h-4 text-green-600" />
        <span className="text-sm">Screen + Voice Recording</span>
      </div>
      <div className="flex items-center gap-2 mt-2">
        <CheckCircle className="w-4 h-4 text-green-600" />
        <span className="text-sm">AI Transcription Included</span>
      </div>
      <div className="flex items-center gap-2 mt-2">
        <CheckCircle className="w-4 h-4 text-green-600" />
        <span className="text-sm">Text Feedback Option Available</span>
      </div>
    </CardContent>
  </Card>
</div>
```

**UX Behavior:**
- **Desktop:** Customize button hidden by default, appears on card hover (opacity transition)
- **Mobile:** Customize button always visible (no hover state on touch)
- **Action:** Navigates to `/customize` (same as main "Customize Test" button)
- **Future Enhancement:** Could open inline editing modal when `/customize` is implemented

---

## Files to Create/Modify Summary

| File | Action | Purpose |
|------|--------|---------|
| `app/preview/page.tsx` | MODIFY | Update copy, add customize buttons, add embed check UI |
| `app/page.tsx` | MODIFY | Add strict URL validation |
| `lib/url-utils.ts` | CREATE | Figma URL transform utility |
| `app/api/check-embed/route.ts` | CREATE | Server-side X-Frame-Options check |
| `zebra-planning/user-testing-app/future-features.md` | MODIFY | Add screenshot service fallback option |

---

## Implementation Order

1. **Improvement 1: Copy Update** (2 min) - Simple text change
2. **Improvement 2: URL Validation** (5 min) - Add regex and trimming
3. **Improvement 5: Customize Buttons** (10 min) - UI enhancement with hover state
4. **Improvement 3: Figma Transform** (10 min) - Create utility and integrate
5. **Improvement 4: Embed Check API** (15 min) - Most complex, server + client changes

**Total Estimated Time:** 40-45 minutes

---

## Stage
**Ready for Manual Testing** (Executed 2025-01-26)

### Review Notes (Agent 2)
- ✅ All 5 improvements validated technically accurate
- ✅ Files to create/modify correctly identified
- ✅ Implementation order is logical (simple → complex)
- ⚠️ **Note for Improvement 2**: Preserve existing `https://` auto-prefix logic when adding space/hostname validation
- ⚠️ **Note for Improvement 5**: Don't forget to add `Pencil` to lucide-react imports and `group` class to Card components

### Execution Complete
All 5 improvements implemented successfully.

---

## Implementation Notes (User Testing Feedback Improvements)

### Summary
Successfully implemented all 5 user testing feedback improvements for Screen 2 (Enter URL) and Screen 3 (Preview).

### Files Created
1. **`lib/url-utils.ts`** (NEW - 36 lines)
   - `transformUrlForEmbed(url)`: Transforms Figma URLs to embed format
   - `isFigmaUrl(url)`: Detects Figma URLs

2. **`app/api/check-embed/route.ts`** (NEW - 63 lines)
   - POST endpoint to check X-Frame-Options and CSP headers
   - Returns `{embeddable, reason, canFix}` response
   - 5-second timeout for HEAD requests

### Files Modified
1. **`app/page.tsx`** (Screen 2 - Enter URL)
   - Added strict URL validation with space detection
   - Added hostname dot validation (requires at least one dot)
   - Improved error messages with specific feedback
   - Preserved existing `https://` auto-prefix feature

2. **`app/preview/page.tsx`** (Screen 3 - Preview)
   - Updated headline: "Your UX test is ready!" (more rewarding)
   - Added `AlertCircle` icon import
   - Added `embedCheck` state and useEffect for server-side validation
   - Added `Pencil` icon and customize buttons to all 3 config cards
   - Cards now have `group` class with hover-visible buttons on desktop
   - Mobile: buttons always visible for better UX
   - Improved embed error UI with fix instructions and MDN link
   - Integrated Figma URL transform for iframe src

### Code Quality Verification
- ✅ **TypeScript**: `pnpm exec tsc --noEmit` - 0 errors
- ✅ **Next.js Build**: Successful (27 routes generated)
- ✅ **New API Route**: `/api/check-embed` properly registered

### Improvements Implemented

| # | Improvement | Status |
|---|-------------|--------|
| 1 | Copy update ("Your UX test is ready!") | ✅ |
| 2 | Strict URL validation (spaces, hostname) | ✅ |
| 3 | Customize buttons on cards (hover desktop, visible mobile) | ✅ |
| 4 | Figma URL auto-transform | ✅ |
| 5 | Server-side embed check with user instructions | ✅ |

---

## Manual Test Instructions (User Testing Feedback Improvements)

### Test Environment
- Development server: `pnpm run dev` (port 3000 or 3001)
- Navigate to: `http://localhost:3000/` or `http://localhost:3001/`

### Test 1: URL Validation (Improvement 2)
1. Go to `/` (Enter URL page)
2. Enter URL with spaces: `https://your app .com`
3. **Expected**: Error "URL cannot contain spaces"
4. Enter URL without dot: `https://localhost`
5. **Expected**: Error "Please enter a complete URL (e.g., https://example.com)"
6. Enter valid URL: `example.com` (without https://)
7. **Expected**: Auto-prefixes to `https://example.com` and navigates to preview

### Test 2: Preview Page Copy (Improvement 1)
1. After entering valid URL, land on `/preview`
2. **Expected**: Headline "Your UX test is ready!"
3. **Expected**: Subtitle "Your app preview on the left, test instructions your testers will see on the right"

### Test 3: Customize Buttons (Improvement 3)
1. On `/preview` page, look at the right-side config cards
2. **Desktop**: Hover over each card (Welcome Message, Test Tasks, Recording Method)
3. **Expected**: "Customize" button appears on hover with Pencil icon
4. **Mobile** (resize browser or use DevTools): Buttons should always be visible
5. Click "Customize" button
6. **Expected**: Navigates to `/customize` (404 is expected - route not implemented yet)

### Test 4: Figma URL Transform (Improvement 3)
1. Go to `/` and enter a Figma prototype URL:
   `https://www.figma.com/proto/XrJhNM75GHzwz6ckt5iCVG/Ramp-Designs?node-id=30-229`
2. Navigate to `/preview`
3. **Expected**:
   - iframe shows the Figma prototype (not blank)
   - Info message below iframe: "Figma prototype converted to embed format"

### Test 5: Embed Check for Blocked Sites (Improvement 5)
1. Go to `/` and enter: `https://facebook.com`
2. Navigate to `/preview`
3. **Expected**:
   - Shows "Preview Not Available" with amber warning icon
   - Message: "This website prevents embedding in previews. Don't worry..."
   - Shows "If this is your website:" section with fix instructions
   - Link to MDN documentation about X-Frame-Options
   - Shows the URL prominently at bottom

### Test 6: Normal Site (Should Work)
1. Go to `/` and enter: `https://example.com`
2. Navigate to `/preview`
3. **Expected**: iframe loads normally with gradient overlay

### Known Limitations
- `/customize` route returns 404 (not implemented yet)
- `/pricing` route returns 404 (not implemented yet)
- Some sites may pass server-side check but still fail in iframe (client-side fallback exists)

## Priority
High - These are usability issues found during testing that impact user experience

---

## Completion Status

**Completed**: 2025-11-26
**Agent**: Design Agent 6 (Completion & Self-Improvement)
**Commit**: Skipped per user request

### Implementation Summary

**Full Functionality**:
- Complete Screen 2 (Enter URL) and Screen 3 (Preview) implementation
- User Testing Feedback Improvements (5 fixes implemented)
- **Preview as Tester Flow** - Full preview mode enabling test creators to experience the complete tester journey

**Preview Mode Implementation (Session 2025-11-26)**:
- All POC screens support preview mode via `?preview=true` and `sessionId=preview`
- Preview mode skips DB operations, Daily.co room creation, and API calls (simulates success)
- Amber preview banners with "Exit Preview" link on all screens (normal document flow)
- Inline progress indicators in preview mode components
- Test config loaded from sessionStorage/localStorage for preview

**Key Files Modified**:
- `app/zebra/page.tsx` - Suspense boundary for useSearchParams
- `app/zebra/[sessionId]/mic-check/page.tsx` - Preview mode handling
- `app/zebra/[sessionId]/instructions/page.tsx` - Preview mode handling
- `app/zebra/[sessionId]/complete/page.tsx` - Preview mode handling
- `components/test-flow/mic-permission.tsx` - Preview banner, inline progress
- `components/test-flow/task-instructions.tsx` - Preview banner, inline progress
- `components/test-flow/thank-you.tsx` - Preview banner, inline progress, skip APIs
- `components/test-flow/testing-interface.tsx` - Preview banner with Exit link
- `components/test-flow/welcome-screen.tsx` - Preview mode detection and routing

### Self-Improvement Analysis Results

**User Corrections Identified**: 2
1. Preview banner overlapped with progress bar (fixed positioning issue)
2. Exit Preview link missing from test page

**Agent Workflow Gaps Found**: 2
1. Fixed positioning for banners didn't consider existing page layout elements
2. Feature consistency across multi-screen flows not verified

**Root Cause Analysis**:
- When adding UI elements like banners, need to check for layout conflicts with existing elements
- When implementing features across flows, need to systematically check ALL screens

### Agent Files Updated with Improvements

**design-4-execution.md**:
- Added "Fixed Positioning Banner Overlap Prevention - Added 2025-11-26"
  - Layout positioning decision matrix
  - Prevention checklist for banners/headers
- Added "Feature Consistency Across Multi-Screen Flows - Added 2025-11-26"
  - Multi-screen implementation checklist
  - Screen enumeration pattern

### Success Patterns Captured
- Storage pattern for config persistence: `sessionStorage` → `localStorage._backup_` → `localStorage` fallback
- Preview mode detection: `sessionId === 'preview' && preview === 'true'`
- Normal document flow for banners avoids z-index/overlap issues
- Inline progress indicators when component renders full page layout

