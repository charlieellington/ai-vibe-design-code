## Build Screen 1: Landing & Pre-Test Survey

### Original Request

**From @poc-build-plan-integrated.md - Screen 1: Landing & Pre-Test Survey (PRESERVED VERBATIM):**

#### Context: Current Project Status (Lines 3-18)
✅ **Already Completed:**
- Next.js app with TypeScript and Tailwind CSS installed
- Supabase authentication system configured
- Supabase client utilities set up
- Environment variables configured (Supabase URL and keys)
- Basic UI components (buttons, inputs, cards) from shadcn/ui
- Authentication flow (login, signup, password reset)
- Protected routes structure

⚠️ **Still Needed:**
- Daily.co integration for audio recording
- Whisper API integration for transcription
- POC test flow screens
- Database schema for test sessions

#### Build Philosophy (Lines 21-26)
- **Build each screen as a complete feature**: Full integration before moving to next screen
- **Test visually at each step**: Ensure everything works before proceeding
- **No auth for POC testers**: While auth exists, POC testers won't need accounts
- **Incremental integration**: Add services as needed per screen

#### Phase 1 Context: Foundation Setup (Already Complete)
**Step 1.1: Install Dependencies** ✅ COMPLETE
```bash
npm install @daily-co/daily-js framer-motion zod
```

**Step 1.2: Update Environment Variables** ✅ COMPLETE
- DAILY_API_KEY (needs to be added)
- OPENAI_API_KEY (needs to be added)
- NEXT_PUBLIC_APP_URL=http://localhost:3001

**Step 1.3: Create Database Schema** ✅ COMPLETE
Migration created: `supabase/migrations/20251027165723_create_test_sessions_table.sql`
```sql
-- Ultra-minimal POC test sessions table
CREATE TABLE IF NOT EXISTS test_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tester_name TEXT NOT NULL,
  tester_email TEXT NOT NULL,
  transcript TEXT,
  audio_url TEXT,
  daily_room_url TEXT,  -- Only URL needed, not name
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

-- Simple RLS for anonymous access
ALTER TABLE test_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all for POC" ON test_sessions
  FOR ALL TO anon
  USING (true);
```

#### Screen 1 Implementation Requirements (Lines 86-153)

**Step 1.1: Initial Route Setup**
```bash
# Create the POC test route
mkdir -p app/zebra
touch app/zebra/page.tsx  # Landing that redirects to survey
mkdir -p app/zebra/[sessionId]
touch app/zebra/[sessionId]/layout.tsx
```

**Step 1.2: Session Management Setup**
Create `/lib/session.ts`:
```typescript
// Core session utilities needed from the start
export async function createTestSession(name: string, email: string) {
  const { data, error } = await supabase
    .from('test_sessions')
    .insert({ tester_name: name, tester_email: email })
    .select()
    .single();
  return data;
}

export async function getTestSession(id: string) {
  const { data, error } = await supabase
    .from('test_sessions')
    .select('*')
    .eq('id', id)
    .single();
  return data;
}
```

**Step 1.3: Build Pre-Test Survey**
Create `/components/test-flow/pre-test-survey.tsx`:
```typescript
// Full implementation with:
- Form with name & email fields
- Supabase integration to create session
- Navigation to next step with session ID
- Error handling
- Loading states
- Reuse existing Input and Button components
```

Create `/app/zebra/page.tsx`:
```typescript
// Landing page that shows the survey
import PreTestSurvey from '@/components/test-flow/pre-test-survey';

export default function ZebraLanding() {
  return <PreTestSurvey />;
}
```

**Integration Points**:
- ✅ Creates session in Supabase on submit
- ✅ Generates unique session ID
- ✅ Routes to `/zebra/[sessionId]/instructions`

**Visual Testing Before Moving On**:
- [ ] Form submission works
- [ ] Session appears in Supabase
- [ ] Navigation works correctly
- [ ] Error states display properly
- [ ] Mobile responsive

#### File References (Lines 528-556)

**Primary Planning Documents:**
- POC/MVP Plan: `/zebra-planning/background/user-testing-app/poc-mvp-plan.md` (Lines 1-243)
  - Overview and goals (Lines 3-4)
  - POC Scope (Lines 14-25)
  - Technical Flow (Lines 26-46)
  - Tech Stack (Lines 49-57)
  - Success Criteria (Lines 58-64)

**User Flow Specification:**
- POC User Flow: `/zebra-planning/background/user-testing-app/poc-user-flow.md` (Lines 1-29)
  - Pre-test survey requirements (Lines 5-7)
  - Task instructions (Lines 8-12)
  - Mic permission flow (Lines 13-15)
  - Main interface specs (Lines 16-21)
  - Thank you screen (Lines 22-24)

**Existing Project Files:**
- Supabase Client: `/lib/supabase/client.ts`
- UI Components: `/components/ui/*`
- Auth Flow: `/app/auth/*`
- Environment: `.env.local` (Supabase configured)

#### Additional Context

**Current Implementation Context:**
- Development server running on http://localhost:3001
- Database schema already created and tested
- Dependencies already installed
- Environment configured (needs Daily.co and OpenAI keys added)
- This is the first screen of 5 in the complete POC flow

### Design Context

**No Figma Design** - Building functional POC interface
- Use clean, minimal UI matching existing auth flow styling
- Leverage existing shadcn/ui components (Input, Button, Card)
- Focus on clarity and ease of use for testers
- Mobile-responsive design

**Visual Requirements:**
- Simple form layout with clear labels
- Professional appearance matching existing app
- Adequate spacing and readability
- Clear call-to-action button
- Error messaging when form validation fails
- Loading states during submission

**Brand/Style Alignment:**
- Follow existing Tailwind patterns in the project
- Use semantic color tokens (bg-background, text-foreground, etc.)
- Consistent with auth flow UI/UX patterns
- Clean, modern, accessible design

### Codebase Context

**Existing Supabase Integration:**
- Location: `/lib/supabase/client.ts`
- Already configured and working
- Used throughout auth system
- Pattern to follow:
```typescript
import { createClient } from '@/lib/supabase/client';
const supabase = createClient();
```

**Existing UI Components (shadcn/ui):**
- Input: `/components/ui/input.tsx` - text input fields
- Button: `/components/ui/button.tsx` - action buttons with variants
- Label: `/components/ui/label.tsx` - form labels
- Card: `/components/ui/card.tsx` - container components

**Existing Form Patterns (Reference):**
- Login Form: `/components/login-form.tsx`
- Sign Up Form: `/components/sign-up-form.tsx`
- Pattern: Client component with useState, form handling, error states

**App Router Structure:**
- Current auth routes: `/app/auth/*`
- New POC routes: `/app/zebra/*`
- Dynamic routes: `/app/zebra/[sessionId]/*`

**Database Schema Available:**
- Table: `test_sessions`
- Fields: id (UUID), tester_name, tester_email, transcript, audio_url, daily_room_url, started_at, completed_at
- Anonymous access enabled via RLS policy

### Prototype Scope

**Frontend Focus:**
- ✅ Complete implementation (not just prototype)
- ✅ Full Supabase integration required
- ✅ Working navigation to next screen
- ✅ Real data persistence (no mocks)
- ✅ Production-quality error handling
- ✅ Mobile-responsive design

**What This Screen Must Accomplish:**
1. Collect tester name and email
2. Create session record in Supabase
3. Generate unique session ID
4. Navigate to instructions screen with session ID in URL
5. Handle errors gracefully
6. Show loading states
7. Validate form inputs

**Component Reuse:**
- Use existing Input component for text fields
- Use existing Button component for submit
- Use existing Label component for form labels
- Consider Card component for container
- Follow patterns from existing auth forms

**No Backend Changes Needed:**
- Database schema already created
- Supabase client already configured
- RLS policies already set
- Just need to use existing infrastructure

### Plan

#### Step 1: Create Session Management Utility

**File:** `/lib/session.ts` (NEW)
**Purpose:** Centralized session CRUD operations for all screens to use

```typescript
import { createClient } from '@/lib/supabase/client';

export interface TestSession {
  id: string;
  tester_name: string;
  tester_email: string;
  transcript: string | null;
  audio_url: string | null;
  daily_room_url: string | null;
  started_at: string;
  completed_at: string | null;
}

export async function createTestSession(
  name: string,
  email: string
): Promise<{ data: TestSession | null; error: Error | null }> {
  try {
    const supabase = createClient();
    const { data, error } = await supabase
      .from('test_sessions')
      .insert({
        tester_name: name,
        tester_email: email,
      })
      .select()
      .single();

    if (error) throw error;
    return { data, error: null };
  } catch (error) {
    return { data: null, error: error as Error };
  }
}

export async function getTestSession(
  id: string
): Promise<{ data: TestSession | null; error: Error | null }> {
  try {
    const supabase = createClient();
    const { data, error } = await supabase
      .from('test_sessions')
      .select('*')
      .eq('id', id)
      .single();

    if (error) throw error;
    return { data, error: null };
  } catch (error) {
    return { data: null, error: error as Error };
  }
}
```

**Why:**
- Encapsulates all Supabase session operations
- Type-safe with TypeScript interfaces
- Consistent error handling
- Reusable across all screens
- Follows patterns from existing Supabase client usage

#### Step 2: Create Pre-Test Survey Component

**File:** `/components/test-flow/pre-test-survey.tsx` (NEW)
**Purpose:** Form to collect tester info and create session

**Implementation:**
```typescript
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { createTestSession } from '@/lib/session';

export default function PreTestSurvey() {
  const router = useRouter();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    // Basic validation
    if (!name.trim() || !email.trim()) {
      setError('Please fill in all fields');
      setLoading(false);
      return;
    }

    if (!email.includes('@')) {
      setError('Please enter a valid email');
      setLoading(false);
      return;
    }

    // Create session
    const { data, error: sessionError } = await createTestSession(name, email);

    if (sessionError || !data) {
      setError('Failed to create session. Please try again.');
      setLoading(false);
      return;
    }

    // Navigate to instructions with session ID
    router.push(`/zebra/${data.id}/instructions`);
  };

  return (
    <div className="flex min-h-screen items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Welcome to User Testing</CardTitle>
          <CardDescription>
            Please provide your information to begin the test session
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label htmlFor="name">Name</Label>
              <Input
                id="name"
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Your full name"
                disabled={loading}
                required
              />
            </div>

            <div>
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="your.email@example.com"
                disabled={loading}
                required
              />
            </div>

            {error && (
              <p className="text-sm text-destructive">{error}</p>
            )}

            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? 'Creating session...' : 'Start Test'}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
```

**Pattern Source:** Based on `/components/sign-up-form.tsx` structure
**Preserves:** Existing form patterns, error handling, loading states
**Reuses:** Button, Input, Label, Card components

#### Step 3: Create Landing Page Route

**File:** `/app/zebra/page.tsx` (NEW)
**Purpose:** Entry point that shows the pre-test survey

```typescript
import PreTestSurvey from '@/components/test-flow/pre-test-survey';

export const metadata = {
  title: 'User Testing | Start Session',
  description: 'Begin your user testing session',
};

export default function ZebraLanding() {
  return <PreTestSurvey />;
}
```

**Why:**
- Simple page that delegates to component
- Proper metadata for SEO
- Server component (default) with client component child
- Clean separation of concerns

#### Step 4: Create Session Layout for Dynamic Routes

**File:** `/app/zebra/[sessionId]/layout.tsx` (NEW)
**Purpose:** Shared layout for all session-specific screens

```typescript
export default function SessionLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
```

**Why:**
- Required for Next.js dynamic route structure
- Can add shared UI elements later (progress bar, header)
- Keeps routes organized
- Simple for now, can be enhanced in future screens

#### Step 5: Visual Testing & Validation

**Test Checklist (Before Moving to Screen 2):**
1. **Form Display:**
   - [ ] Card displays centered on page
   - [ ] Title and description are clear
   - [ ] Form fields have proper labels
   - [ ] Button is prominent and accessible

2. **Form Interaction:**
   - [ ] Can type into name field
   - [ ] Can type into email field
   - [ ] Fields disabled during loading
   - [ ] Button shows loading state

3. **Validation:**
   - [ ] Empty fields show error
   - [ ] Invalid email shows error
   - [ ] Error messages are clear and helpful

4. **Supabase Integration:**
   - [ ] Session created in test_sessions table
   - [ ] tester_name saved correctly
   - [ ] tester_email saved correctly
   - [ ] UUID generated properly
   - [ ] started_at timestamp set

5. **Navigation:**
   - [ ] Successful submit redirects to `/zebra/[sessionId]/instructions`
   - [ ] Session ID in URL matches database ID
   - [ ] No console errors

6. **Error Handling:**
   - [ ] Network errors handled gracefully
   - [ ] Database errors show user-friendly message
   - [ ] Can retry after error

7. **Responsive Design:**
   - [ ] Works on mobile (375px)
   - [ ] Works on tablet (768px)
   - [ ] Works on desktop (1024px+)
   - [ ] Card scales appropriately

8. **Accessibility:**
   - [ ] Form can be submitted with Enter key
   - [ ] Tab order is logical
   - [ ] Labels associated with inputs
   - [ ] Error messages are announced

### Stage

Ready for Manual Testing

### Review Notes

**Review Date:** October 27, 2025 - 6:45 PM PST
**Reviewed by:** Agent 2 (Review & Clarification)

#### Requirements Coverage
✓ All functional requirements from POC build plan addressed
✓ Session management utilities properly scoped
✓ Form validation and error handling included
✓ Supabase integration approach validated
✓ Navigation flow to next screen defined
✓ Mobile responsive requirements included

#### Technical Validation
✓ Database schema already created (verified migration file exists)
✓ All referenced UI components exist in `/components/ui/`
✓ Supabase client configuration verified at `/lib/supabase/client.ts`
✓ Import patterns match existing codebase patterns
✓ No conflicting routes - `/app/zebra` is new
✓ Form patterns follow established auth form structure

#### Design Approach
✓ Clean separation of concerns (utilities, components, routes)
✓ Type-safe implementation with TypeScript interfaces
✓ Reuses existing UI components appropriately
✓ Error handling follows established patterns
✓ Loading states properly implemented

#### Risk Assessment
- **Low risk**: Creating all new files, no modifications to existing code
- **Low risk**: Simple form submission with established patterns
- **Expected behavior**: Navigation to `/zebra/[sessionId]/instructions` will 404 until Screen 2 is built (incremental development approach)
- **Mitigation**: Comprehensive visual testing checklist included

#### Validation Result
**CONFIRMED** - Plan is comprehensive, technically accurate, and ready for Discovery phase. No ambiguities or clarifications needed. The implementation can proceed with confidence.

### Questions for Clarification

None - all requirements are clear from the POC build plan. This is a straightforward form implementation with established patterns.

### Priority

**HIGH** - This is the first screen and blocks all subsequent development

### Created

October 27, 2025 - 6:30 PM PST

### Files

**New Files to Create:**
- `/lib/session.ts` - Session management utilities
- `/components/test-flow/pre-test-survey.tsx` - Survey form component
- `/app/zebra/page.tsx` - Landing page route
- `/app/zebra/[sessionId]/layout.tsx` - Session layout

**Existing Files Referenced:**
- `/lib/supabase/client.ts` - Supabase client (already exists)
- `/components/ui/button.tsx` - Button component (already exists)
- `/components/ui/input.tsx` - Input component (already exists)
- `/components/ui/label.tsx` - Label component (already exists)
- `/components/ui/card.tsx` - Card component (already exists)
- `/components/sign-up-form.tsx` - Pattern reference (already exists)

**Database:**
- `test_sessions` table (already created via migration)

### Technical Notes

**Dependencies Already Installed:**
- @daily-co/daily-js (for future screens)
- framer-motion (for animations if needed)
- zod (for validation if needed)

**Environment Variables Needed:**
- NEXT_PUBLIC_SUPABASE_URL (already configured)
- NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY (already configured)
- DAILY_API_KEY (needed for Screen 3)
- OPENAI_API_KEY (needed for Screen 5)

**Testing URLs:**
- Landing: http://localhost:3001/zebra
- After submit: http://localhost:3001/zebra/[uuid]/instructions (Screen 2)

**Database Verification:**
After creating a test session, verify in Supabase:
```sql
SELECT * FROM test_sessions ORDER BY started_at DESC LIMIT 1;
```

### Success Criteria

**Screen 1 is complete when:**
1. ✅ User can access `/zebra`
2. ✅ Form displays with name and email fields
3. ✅ Form validation prevents empty/invalid submissions
4. ✅ Session created in Supabase on submit
5. ✅ User redirected to instructions screen with session ID
6. ✅ Error states handled gracefully
7. ✅ Mobile responsive
8. ✅ All Visual Testing checklist items pass

**Ready to proceed to Screen 2 when:**
- All success criteria met
- No console errors
- Database contains test session
- Navigation works correctly

---

## Technical Discovery (Agent 3)

**Discovery Date:** October 27, 2025 - 7:00 PM PST
**Discovery Agent:** Agent 3 (Technical Discovery & MCP Research)

### Component Identification Verification

- **Target Page**: `/zebra` (Landing page - NEW route)
- **Primary Component**: `PreTestSurvey` component (NEW)
- **Verification Steps**:
  - [x] No existing `/app/zebra/` route - clear path for new routes
  - [x] No route conflicts identified
  - [x] All referenced UI components exist and verified
  - [x] Form pattern established and consistent with existing auth forms

### Supabase Client Integration Research

**Component**: `createClient` from `/lib/supabase/client.ts`
**Status**: ✅ Verified and ready to use

**Import Pattern** (Lines 1-8):
```typescript
import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
  );
}
```

**Usage Pattern Found** (from existing forms):
```typescript
import { createClient } from '@/lib/supabase/client';
const supabase = createClient();

// Then use supabase.from(), supabase.auth, etc.
```

**Verification**: Used consistently in 7 existing component files
- ✅ Pattern established across auth forms
- ✅ No conflicts or alternative patterns found
- ✅ Environment variables already configured

### shadcn/ui Component Research

#### Button Component
**Location**: `/components/ui/button.tsx`
**Status**: ✅ Available
**Key Props**:
- `type`: "button" | "submit" | "reset"
- `disabled`: boolean
- `className`: string (for custom styles)
- `variant`: "default" | "destructive" | "outline" | "secondary" | "ghost" | "link"
- `size`: "default" | "sm" | "lg" | "icon"

**Default Variant**: "default" (primary style)
**Usage in Plan**: `<Button type="submit" className="w-full" disabled={loading}>`
**Verification**: ✅ Matches existing auth form usage

#### Input Component
**Location**: `/components/ui/input.tsx`
**Status**: ✅ Available
**Key Props**:
- `type`: "text" | "email" | "password" | etc.
- `value`: string
- `onChange`: (e) => void
- `placeholder`: string
- `disabled`: boolean
- `required`: boolean
- `id`: string (for label association)

**Default Styling**: Includes focus states, disabled states, responsive text sizing
**Usage in Plan**: Matches required form field pattern
**Verification**: ✅ Used consistently in existing auth forms

#### Label Component
**Location**: `/components/ui/label.tsx`
**Status**: ✅ Available
**Key Props**:
- `htmlFor`: string (associates with input id)
- `className`: string (for custom styles)

**Implementation**: Uses @radix-ui/react-label primitive
**Usage in Plan**: `<Label htmlFor="name">Name</Label>`
**Verification**: ✅ Standard pattern across codebase

#### Card Components
**Location**: `/components/ui/card.tsx`
**Status**: ✅ All sub-components available
**Components Available**:
- `Card` - Main container (border, shadow, rounded corners)
- `CardHeader` - Top section (flex-col, space-y-1.5, p-6)
- `CardTitle` - Heading text (font-semibold, leading-none)
- `CardDescription` - Subtitle (text-sm, muted-foreground)
- `CardContent` - Main content area (p-6, pt-0)
- `CardFooter` - Bottom section (if needed)

**Default Styling**:
- Card: `rounded-xl border bg-card text-card-foreground shadow`
- CardHeader: `flex flex-col space-y-1.5 p-6`
- CardContent: `p-6 pt-0` (padding-top removed to connect with header)

**Usage in Plan**: Full card structure with header and content
**Verification**: ✅ Matches existing auth form structure exactly

### Database Schema Verification

**Table**: `test_sessions`
**Migration File**: `/supabase/migrations/20251027165723_create_test_sessions_table.sql`
**Status**: ✅ Already created and applied to database

**Schema Verified** (Lines 2-11):
```sql
CREATE TABLE IF NOT EXISTS test_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tester_name TEXT NOT NULL,
  tester_email TEXT NOT NULL,
  transcript TEXT,
  audio_url TEXT,
  daily_room_url TEXT,
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);
```

**RLS Policy Verified** (Lines 13-18):
- Anonymous access enabled via "Allow all for POC" policy
- `FOR ALL TO anon USING (true)` - Allows all operations without auth
- Appropriate for POC phase

**Field Mapping to Plan**:
- ✅ `id` (UUID) - Auto-generated primary key
- ✅ `tester_name` (TEXT NOT NULL) - Required field
- ✅ `tester_email` (TEXT NOT NULL) - Required field
- ✅ `started_at` (TIMESTAMP) - Auto-set on creation
- ✅ Other fields (transcript, audio_url, etc.) - For future screens

**No Changes Needed**: Schema matches implementation plan exactly

### TypeScript Configuration Verification

**Config File**: `/tsconfig.json`
**Status**: ✅ Properly configured

**Key Settings Verified**:
- Path alias: `"@/*": ["./*"]` - Allows `@/components/`, `@/lib/`, etc.
- Strict mode: `true` - Type safety enforced
- JSX: `"react-jsx"` - React 19 compatible
- Module resolution: `"bundler"` - Next.js compatible

**Import Pattern**:
```typescript
import { createClient } from '@/lib/supabase/client';
import { Button } from '@/components/ui/button';
```

**Verification**: ✅ All planned imports will work correctly

### Routing Pattern Verification

**Existing Pattern** (from `/app/auth/login/page.tsx`):
```typescript
import { LoginForm } from "@/components/login-form";

export default function Page() {
  return (
    <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
      <div className="w-full max-w-sm">
        <LoginForm />
      </div>
    </div>
  );
}
```

**Pattern Analysis**:
- Page component is a server component (default)
- Delegates rendering to client component
- Handles responsive layout and centering
- Simple and clean separation of concerns

**Plan Comparison**:
```typescript
// Plan uses similar pattern with slight variation
import PreTestSurvey from '@/components/test-flow/pre-test-survey';

export default function ZebraLanding() {
  return <PreTestSurvey />;
}
```

**Recommendation**: ✅ Plan is simpler (component handles its own layout), which is fine. PreTestSurvey component includes the centering div internally.

**Dynamic Route Structure**:
- New: `/app/zebra/page.tsx` - Landing/survey page
- New: `/app/zebra/[sessionId]/layout.tsx` - Layout for session routes
- Future: `/app/zebra/[sessionId]/instructions/page.tsx` - Next screen

**Verification**: ✅ Standard Next.js 14+ App Router dynamic route pattern

### Form Pattern Verification

**Reference Form**: `/components/sign-up-form.tsx` and `/components/login-form.tsx`

**Established Pattern**:
1. ✅ `"use client"` directive at top
2. ✅ `useState` for form fields (name, email, etc.)
3. ✅ `useState` for loading state (`isLoading`)
4. ✅ `useState` for error state (`error`)
5. ✅ `useRouter` from `next/navigation` for navigation
6. ✅ `handleSubmit` async function with `e.preventDefault()`
7. ✅ Create Supabase client inside handler: `const supabase = createClient()`
8. ✅ Set loading state before async operation
9. ✅ Basic validation before API call
10. ✅ Try-catch error handling
11. ✅ Router navigation on success: `router.push()`
12. ✅ Error display: `{error && <p className="text-sm text-destructive">{error}</p>}`
13. ✅ Loading state on button: `disabled={isLoading}`
14. ✅ Button text changes during loading

**Plan Alignment Check**:
```typescript
// From planned implementation
const [name, setName] = useState('');
const [email, setEmail] = useState('');
const [loading, setLoading] = useState(false);
const [error, setError] = useState<string | null>(null);

const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  setError(null);
  setLoading(true);
  // ... validation and API call
};
```

**Verification**: ✅ Plan perfectly matches established patterns
**Note**: Plan uses `loading` instead of `isLoading` - both are acceptable, but `isLoading` is more common in codebase

### Error Styling Verification

**Pattern Found**: `text-destructive` semantic token
**Used in**: 
- `/components/ui/button.tsx` - destructive variant
- Existing error messages in forms (verified as `text-red-500` in some places)

**Plan Uses**: `text-destructive`
**Verification**: ✅ Correct semantic token for theme compatibility

**Note**: Some existing forms use `text-red-500` instead. Plan's `text-destructive` is better as it respects theme configuration.

### Dependency Verification

**Required Dependencies** (from package.json):
- ✅ `@supabase/ssr` - Latest (for createBrowserClient)
- ✅ `@supabase/supabase-js` - Latest (for Supabase types)
- ✅ `@radix-ui/react-label` - ^2.1.6 (for Label component)
- ✅ `@radix-ui/react-slot` - ^1.2.2 (for Button component)
- ✅ `next` - Latest (for router, navigation)
- ✅ `react` - ^19.0.0 (for hooks)
- ✅ `next-themes` - ^0.4.6 (for theme support)

**Foundation Dependencies** (already installed for future screens):
- ✅ `@daily-co/daily-js` - ^0.85.0
- ✅ `framer-motion` - ^12.23.24
- ✅ `zod` - ^4.1.12

**No Additional Installations Required**: All dependencies present

### Implementation Feasibility Assessment

**Technical Blockers**: ❌ None identified
**Risk Level**: 🟢 Low

**Feasibility Breakdown**:

1. **Session Management Utility** (`/lib/session.ts`):
   - ✅ Supabase client pattern verified
   - ✅ Database schema matches requirements
   - ✅ Type definitions straightforward
   - ✅ Error handling pattern established
   - Risk: 🟢 Low - Standard CRUD operations

2. **Pre-Test Survey Component** (`/components/test-flow/pre-test-survey.tsx`):
   - ✅ All UI components available
   - ✅ Form pattern established
   - ✅ Router navigation pattern verified
   - ✅ Error handling consistent with existing code
   - Risk: 🟢 Low - Standard form with established patterns

3. **Landing Page Route** (`/app/zebra/page.tsx`):
   - ✅ No route conflicts
   - ✅ Routing pattern verified
   - ✅ Metadata pattern established
   - Risk: 🟢 Low - Simple page delegation

4. **Session Layout** (`/app/zebra/[sessionId]/layout.tsx`):
   - ✅ Dynamic route pattern standard
   - ✅ Simple passthrough layout appropriate
   - Risk: 🟢 Low - Minimal implementation

**Overall Assessment**: ✅ Ready for immediate implementation with zero blocking issues

### Discovery Summary

**All Components Available**: ✅ Yes
- Button, Input, Label, Card (with all sub-components)
- All located in `/components/ui/`
- All verified compatible with plan

**Technical Blockers**: ❌ None
- All dependencies installed
- Database schema created
- Supabase client configured
- Environment variables set
- No route conflicts

**Ready for Implementation**: ✅ Yes
- All technical requirements verified
- All patterns established and documented
- All imports and paths confirmed
- Zero modifications needed to existing code

**Special Notes**:
1. **Error Display Consistency**: Plan uses `text-destructive` which is better than some existing forms that use `text-red-500`. This is an improvement.
2. **Loading State Variable**: Plan uses `loading` while existing forms use `isLoading`. Both work, but recommend keeping `loading` for simplicity since plan is already written.
3. **Form Layout**: PreTestSurvey component handles its own centering div (unlike auth forms which delegate to page). This is fine and keeps component self-contained.
4. **Navigation Target**: Will navigate to `/zebra/[sessionId]/instructions` which will 404 until Screen 2 is built. This is expected and part of incremental development approach.

### Required Installations

**No installations required** - All dependencies already present in package.json

### Files to Create

**New Files** (All verified as non-conflicting):
1. `/lib/session.ts` - Session management utilities
2. `/components/test-flow/pre-test-survey.tsx` - Survey form component
3. `/app/zebra/page.tsx` - Landing page route
4. `/app/zebra/[sessionId]/layout.tsx` - Session layout

**No Existing Files to Modify**: ✅ Clean implementation with zero conflicts

### Recommended Implementation Order

1. **First**: Create `/lib/session.ts` (no dependencies on other new files)
2. **Second**: Create `/components/test-flow/pre-test-survey.tsx` (depends on session.ts)
3. **Third**: Create `/app/zebra/page.tsx` (depends on PreTestSurvey component)
4. **Fourth**: Create `/app/zebra/[sessionId]/layout.tsx` (independent, for future screens)

**Rationale**: Bottom-up approach ensures dependencies are available when needed

### Visual Testing Preparation

**Testing URL**: http://localhost:3001/zebra
**Database Verification Query**:
```sql
SELECT * FROM test_sessions ORDER BY started_at DESC LIMIT 1;
```

**Expected Flow**:
1. User visits `/zebra`
2. Sees form with name and email fields
3. Fills in form and submits
4. Session created in database
5. Redirected to `/zebra/[uuid]/instructions` (will 404 until Screen 2)

**Success Indicators**:
- Form displays correctly
- Validation works (empty fields, invalid email)
- Session appears in database with correct data
- Navigation occurs (even if target page doesn't exist yet)
- No console errors during submission
- Mobile responsive at all breakpoints

---

**Discovery Status**: ✅ Complete - Ready for Agent 4 (Execution)
**Next Stage**: Execution (Agent 4)
**Estimated Implementation Time**: 15-20 minutes (4 files, all straightforward)

---

## Implementation Notes (Agent 4)

**Implementation Date:** October 27, 2025 - 8:00 PM PST
**Implemented by:** Agent 4 (Execution & Implementation)

### Files Created

All 4 files successfully created as planned:

1. **`/lib/session.ts`** - Session management utilities
   - Created TypeScript interface `TestSession` matching database schema
   - Implemented `createTestSession()` function with error handling
   - Implemented `getTestSession()` function with error handling
   - Uses existing Supabase client pattern from `/lib/supabase/client.ts`
   - Type-safe Promise return with data/error tuple pattern

2. **`/components/test-flow/pre-test-survey.tsx`** - Survey form component
   - Client component with `"use client"` directive
   - useState for form fields (name, email), loading state, and error state
   - Form validation (empty fields, basic email validation)
   - Supabase integration via `createTestSession()`
   - Navigation to `/zebra/[sessionId]/instructions` on success
   - Error display with `text-destructive` semantic token
   - Loading states on form fields and submit button
   - Reuses shadcn/ui components: Card, CardHeader, CardTitle, CardDescription, CardContent, Input, Label, Button
   - Centered layout with responsive design (`min-h-screen`, `max-w-md`, `p-4`)

3. **`/app/zebra/page.tsx`** - Landing page route
   - Server component (Next.js default)
   - Imports and renders PreTestSurvey component
   - Includes proper metadata for SEO
   - Clean delegation pattern

4. **`/app/zebra/[sessionId]/layout.tsx`** - Session layout for dynamic routes
   - Simple passthrough layout for future screens
   - Establishes dynamic route structure for session-based pages
   - Can be enhanced later with progress indicators or shared UI

### Implementation Approach

Followed recommended bottom-up dependency order from Agent 3:
1. First: Session utilities (no dependencies)
2. Second: Survey component (depends on session.ts)
3. Third: Landing page (depends on PreTestSurvey)
4. Fourth: Session layout (independent)

### Code Quality

- ✅ All TypeScript types properly defined
- ✅ Error handling follows established patterns
- ✅ Form patterns match existing auth forms
- ✅ Semantic color tokens used (`text-destructive` vs hardcoded colors)
- ✅ Loading states implemented consistently
- ✅ Validation before API calls
- ✅ Clean separation of concerns
- ✅ No modifications to existing files (zero conflicts)

### Deviations from Plan

**None** - Implementation matches plan exactly as specified by Agent 1 and verified by Agent 3.

### Technical Details

- Development server already running on port 3001 (no restart needed)
- Next.js hot-reload will automatically pick up new files
- Database schema already created and verified
- All dependencies already installed (no npm/pnpm install needed)
- Anonymous RLS policy allows session creation without authentication

### Expected Behavior

1. User visits `http://localhost:3001/zebra`
2. Sees pre-test survey form with name and email fields
3. Submits form after filling in required information
4. Session created in `test_sessions` table in Supabase
5. User redirected to `/zebra/[uuid]/instructions` (will 404 until Screen 2 is built - this is expected)

### Known Limitations

- Navigation target (`/zebra/[sessionId]/instructions`) will show 404 until Screen 2 is implemented
- This is intentional and part of the incremental development approach
- Basic email validation (checks for `@` character) - can be enhanced later if needed

---

## Manual Test Instructions

### Prerequisites

- Development server running on `http://localhost:3001`
- Access to Supabase dashboard to verify database records
- Modern web browser (Chrome, Firefox, Safari, Edge)

### Test Procedure

#### 1. Visual Verification

Navigate to: `http://localhost:3001/zebra`

**Expected Visual Elements:**
- [ ] Page loads without errors
- [ ] Card container centered on screen
- [ ] Title: "Welcome to User Testing"
- [ ] Description: "Please provide your information to begin the test session"
- [ ] Two form fields visible:
  - [ ] Name field with label "Name" and placeholder "Your full name"
  - [ ] Email field with label "Email" and placeholder "your.email@example.com"
- [ ] Submit button labeled "Start Test"
- [ ] Clean, professional design matching existing auth pages
- [ ] No console errors in browser DevTools

#### 2. Form Validation Testing

**Test A: Empty Form Submission**
1. Leave both fields empty
2. Click "Start Test" button
3. **Expected:** Error message displays: "Please fill in all fields"
4. **Expected:** Form does NOT submit

**Test B: Invalid Email**
1. Enter name: "Test User"
2. Enter email: "notanemail"
3. Click "Start Test"
4. **Expected:** Error message displays: "Please enter a valid email"
5. **Expected:** Form does NOT submit

**Test C: Only Name Filled**
1. Enter name: "Test User"
2. Leave email empty
3. Click "Start Test"
4. **Expected:** Error message displays: "Please fill in all fields"

**Test D: Only Email Filled**
1. Leave name empty
2. Enter email: "test@example.com"
3. Click "Start Test"
4. **Expected:** Error message displays: "Please fill in all fields"

#### 3. Successful Submission Testing

**Test E: Valid Submission**
1. Enter name: "Test User"
2. Enter email: "test@example.com"
3. Click "Start Test"
4. **Expected During Submission:**
   - [ ] Button text changes to "Creating session..."
   - [ ] Button becomes disabled
   - [ ] Form fields become disabled
   - [ ] Brief loading state visible
5. **Expected After Submission:**
   - [ ] Page redirects to `/zebra/[uuid]/instructions` (will show 404 - this is expected)
   - [ ] URL contains a UUID (e.g., `/zebra/abc123-def456-...`)
   - [ ] No console errors during submission

#### 4. Database Verification

**Verify in Supabase Dashboard:**
1. Open Supabase dashboard
2. Navigate to Table Editor → `test_sessions`
3. Check most recent record
4. **Expected Fields:**
   - [ ] `id`: Valid UUID (matches URL)
   - [ ] `tester_name`: "Test User" (as entered)
   - [ ] `tester_email`: "test@example.com" (as entered)
   - [ ] `started_at`: Current timestamp
   - [ ] `transcript`: NULL
   - [ ] `audio_url`: NULL
   - [ ] `daily_room_url`: NULL
   - [ ] `completed_at`: NULL

**Alternative Database Query:**
```sql
SELECT * FROM test_sessions ORDER BY started_at DESC LIMIT 1;
```

#### 5. Responsive Design Testing

**Test F: Mobile View (375px)**
1. Open browser DevTools
2. Toggle device toolbar
3. Set viewport to iPhone SE (375px)
4. Refresh page
5. **Expected:**
   - [ ] Card fits within viewport
   - [ ] No horizontal scrolling
   - [ ] Form fields are readable and usable
   - [ ] Button is full-width and tappable
   - [ ] Text is legible

**Test G: Tablet View (768px)**
1. Set viewport to iPad (768px)
2. **Expected:**
   - [ ] Card centered with appropriate spacing
   - [ ] Layout remains clean and professional

**Test H: Desktop View (1920px)**
1. Set viewport to desktop (1920px or full screen)
2. **Expected:**
   - [ ] Card centered with max-width constraint
   - [ ] Not stretched full-width
   - [ ] Professional appearance maintained

#### 6. Error Handling Testing

**Test I: Simulate Network Error**
1. Open DevTools → Network tab
2. Set throttling to "Offline"
3. Fill in form and submit
4. **Expected:**
   - [ ] Error message displays: "Failed to create session. Please try again."
   - [ ] Form returns to editable state
   - [ ] Can retry after re-enabling network

**Test J: Browser Navigation**
1. Complete a successful submission (reach 404 page)
2. Click browser back button
3. **Expected:**
   - [ ] Returns to survey form
   - [ ] Form is cleared (fresh state)
   - [ ] Can submit another session

#### 7. Accessibility Testing

**Test K: Keyboard Navigation**
1. Tab through form elements
2. **Expected Tab Order:**
   - [ ] 1. Name field
   - [ ] 2. Email field
   - [ ] 3. Start Test button
3. Fill form using keyboard only
4. Press Enter to submit
5. **Expected:** Form submits successfully

**Test L: Form Labels**
1. Inspect HTML in DevTools
2. **Expected:**
   - [ ] Label `htmlFor` matches Input `id` for name field
   - [ ] Label `htmlFor` matches Input `id` for email field
   - [ ] Labels are clickable and focus their inputs

#### 8. Multiple Submission Testing

**Test M: Create Multiple Sessions**
1. Complete 3 separate form submissions with different data
2. Check Supabase database
3. **Expected:**
   - [ ] 3 separate session records created
   - [ ] Each has unique UUID
   - [ ] Each has correct tester data
   - [ ] Timestamps are sequential

### Success Criteria

**This implementation is ready to proceed to Screen 2 when:**

✅ **Visual Requirements:**
- [ ] Form displays correctly on all screen sizes
- [ ] Design matches existing app aesthetic
- [ ] Professional appearance

✅ **Functional Requirements:**
- [ ] Form validation prevents invalid submissions
- [ ] Valid submissions create database records
- [ ] Navigation to instructions page works (even if 404)
- [ ] No console errors during normal operation

✅ **Data Requirements:**
- [ ] Sessions created in `test_sessions` table
- [ ] Correct data stored (name, email, timestamps)
- [ ] UUIDs generated properly

✅ **Error Handling:**
- [ ] Empty fields show appropriate errors
- [ ] Invalid email shows appropriate errors
- [ ] Network errors handled gracefully
- [ ] User can retry after errors

✅ **Accessibility:**
- [ ] Keyboard navigation works
- [ ] Form labels properly associated
- [ ] Mobile responsive

### Troubleshooting

**If form doesn't appear:**
- Check console for errors
- Verify development server is running on port 3001
- Clear browser cache and hard refresh

**If submission fails:**
- Check Supabase connection in environment variables
- Verify `test_sessions` table exists
- Check RLS policies are enabled for anonymous access
- Review browser console for specific error messages

**If redirect doesn't work:**
- This is expected behavior - Screen 2 doesn't exist yet
- Verify URL changes to include UUID
- 404 page is normal at this stage

### Next Steps

After manual testing confirms all success criteria are met:
1. This task moves to Agent 5 for completion documentation
2. Screen 2 (Task Instructions) can begin implementation
3. Database schema is ready for future screens

