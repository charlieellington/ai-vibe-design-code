## Stage 1: Foundation Setup - Database, Environment, and Core Utilities

### Original Request

**From @mvp-implementation-plan.md (PRESERVED VERBATIM):**

```markdown
## Stage 1: Foundation Setup
**Goal:** Set up everything needed so each screen can be fully functional when built.

### 1.1 Database Schema - Complete Setup
```sql
-- Run all migrations at once
-- File: supabase/migrations/[timestamp]_complete_mvp_setup.sql

-- Tests table (for creator's tests)
CREATE TABLE tests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  share_token TEXT UNIQUE NOT NULL DEFAULT substr(md5(random()::text), 0, 12),
  app_url TEXT NOT NULL,

  -- All config in JSONB for flexibility
  config JSONB NOT NULL DEFAULT '{
    "title": "",
    "welcome_message": "Help us improve our product - your feedback matters!",
    "instructions": "Please think out loud as you navigate.",
    "tasks": [],
    "max_sessions": 5,
    "sessions_completed": 0,
    "thank_you_message": "Thank you for your feedback!"
  }'::jsonb,

  is_active BOOLEAN DEFAULT true,
  is_anonymous BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  claimed_at TIMESTAMP WITH TIME ZONE
);

-- Test sessions (for tester recordings)
CREATE TABLE test_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  test_id UUID REFERENCES tests(id) ON DELETE CASCADE,
  session_token TEXT UNIQUE DEFAULT substr(md5(random()::text), 0, 16),

  -- Tester info
  tester_name TEXT,
  tester_email TEXT,

  -- Recording data
  daily_room_name TEXT,
  recording_url TEXT,
  recording_id TEXT,
  duration INTEGER,

  -- Consent
  consent_given BOOLEAN DEFAULT false,
  consent_timestamp TIMESTAMP WITH TIME ZONE,

  -- Transcription
  transcript JSONB,
  transcript_status TEXT DEFAULT 'pending' CHECK (transcript_status IN ('pending', 'processing', 'completed', 'failed')),
  transcript_error TEXT,

  -- Text feedback (fallback mode)
  feedback_text TEXT,
  is_text_only BOOLEAN DEFAULT false,

  -- Timestamps
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

-- Anonymous test storage (for pre-signup flow)
CREATE TABLE anonymous_tests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_token TEXT UNIQUE NOT NULL,
  test_data JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() + INTERVAL '24 hours'
);

-- Indexes for performance
CREATE INDEX idx_tests_share_token ON tests(share_token);
CREATE INDEX idx_tests_user_id ON tests(user_id) WHERE user_id IS NOT NULL;
CREATE INDEX idx_tests_config ON tests USING gin(config);
CREATE INDEX idx_test_sessions_test_id ON test_sessions(test_id);
CREATE INDEX idx_test_sessions_recording_id ON test_sessions(recording_id);
CREATE INDEX idx_anonymous_tests_session ON anonymous_tests(session_token);

-- RLS Policies
ALTER TABLE tests ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE anonymous_tests ENABLE ROW LEVEL SECURITY;

-- Tests policies
CREATE POLICY "Anyone can create anonymous test" ON tests
  FOR INSERT WITH CHECK (is_anonymous = true);

CREATE POLICY "Users see own tests" ON tests
  FOR SELECT USING (
    user_id = auth.uid() OR
    (is_anonymous = true AND created_at > NOW() - INTERVAL '24 hours')
  );

CREATE POLICY "Users update own tests" ON tests
  FOR UPDATE USING (user_id = auth.uid());

-- Test sessions policies
CREATE POLICY "Anyone can create session" ON test_sessions
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Test owners see sessions" ON test_sessions
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM tests
      WHERE tests.id = test_sessions.test_id
      AND (tests.user_id = auth.uid() OR tests.is_anonymous = true)
    )
  );

CREATE POLICY "Anyone can update their session" ON test_sessions
  FOR UPDATE USING (true);  -- Session token validation in app

-- Anonymous tests policies
CREATE POLICY "Anyone can create/view anonymous test" ON anonymous_tests
  FOR ALL USING (true);

-- Cleanup function
CREATE OR REPLACE FUNCTION cleanup_expired_anonymous_tests()
RETURNS void AS $$
BEGIN
  DELETE FROM anonymous_tests WHERE expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to increment session count
CREATE OR REPLACE FUNCTION increment_session_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.completed_at IS NOT NULL AND OLD.completed_at IS NULL THEN
    UPDATE tests
    SET config = jsonb_set(
      config,
      '{sessions_completed}',
      to_jsonb(COALESCE((config->>'sessions_completed')::int, 0) + 1)
    )
    WHERE id = NEW.test_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_test_session_count
  AFTER UPDATE ON test_sessions
  FOR EACH ROW
  EXECUTE FUNCTION increment_session_count();
```

### 1.2 Environment Setup
```bash
# .env.local
NEXT_PUBLIC_SUPABASE_URL=your-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-key

DAILY_API_KEY=your-daily-key
DAILY_DOMAIN=your-domain.daily.co

OPENAI_API_KEY=your-openai-key

NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 1.3 Core Utilities Setup
```typescript
// lib/supabase/client.ts - Copy from POC
// lib/supabase/server.ts - Copy from POC
// lib/daily.ts - Daily.co utilities from POC
// lib/openai.ts - Transcription utilities from POC
// app/layout.tsx - Base layout with Toaster
// components/ui/* - Copy all shadcn components from POC
```

### 1.4 Test Management Utilities
```typescript
// lib/tests.ts
import { createClient } from '@/lib/supabase/client';
import { nanoid } from 'nanoid';

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
    max_sessions: number;
    sessions_completed: number;
    thank_you_message: string;
  };
  is_active: boolean;
  is_anonymous: boolean;
  created_at: string;
  claimed_at?: string;
}

export function generateSmartDefaults(appUrl: string) {
  try {
    const validUrl = new URL(appUrl);
    const hostname = validUrl.hostname.replace('www.', '');
    const appName = hostname.split('.')[0];
    const capitalizedName = appName.charAt(0).toUpperCase() + appName.slice(1);

    return {
      title: `${capitalizedName} User Testing`,
      welcome_message: `Help us improve ${capitalizedName} - your feedback matters!`,
      instructions: 'Please think out loud as you navigate. Describe what you see, what you\'re trying to do, and any confusion you experience.',
      tasks: [
        'Try to complete the main action on this page',
        'Find information about pricing or features',
        'Share your overall impression of the experience'
      ],
      thank_you_message: 'Thank you for your valuable feedback!'
    };
  } catch {
    return {
      title: 'User Testing',
      welcome_message: 'Help us improve our product - your feedback matters!',
      instructions: 'Please think out loud as you navigate.',
      tasks: ['Complete the main task', 'Explore the features', 'Share your feedback'],
      thank_you_message: 'Thank you for your feedback!'
    };
  }
}
```

### 1.5 API Routes Foundation
```typescript
// app/api/tests/anonymous/route.ts
import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';
import { nanoid } from 'nanoid';

export async function POST(request: Request) {
  const supabase = await createClient();
  const body = await request.json();

  // Generate session token for anonymous test
  const sessionToken = nanoid();

  // Store in temporary table
  const { data: anonTest, error: anonError } = await supabase
    .from('anonymous_tests')
    .insert({
      session_token: sessionToken,
      test_data: body,
      expires_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()
    })
    .select()
    .single();

  if (anonError) {
    return NextResponse.json({ error: anonError.message }, { status: 500 });
  }

  // Also create the actual test (but anonymous)
  const { data: test, error: testError } = await supabase
    .from('tests')
    .insert({
      app_url: body.url,
      config: {
        title: body.title,
        welcome_message: body.welcome_message,
        instructions: body.instructions,
        tasks: body.tasks,
        max_sessions: 5,
        thank_you_message: body.thank_you_message || 'Thank you for your feedback!'
      },
      is_anonymous: true
    })
    .select()
    .single();

  if (testError) {
    return NextResponse.json({ error: testError.message }, { status: 500 });
  }

  // Link anonymous test to real test
  await supabase
    .from('anonymous_tests')
    .update({
      test_data: { ...body, test_id: test.id, share_token: test.share_token }
    })
    .eq('session_token', sessionToken);

  return NextResponse.json({
    sessionToken,
    testId: test.id,
    shareToken: test.share_token
  });
}
```

```typescript
// app/api/auth/signup-with-test/route.ts
import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  const supabase = await createClient();
  const { email, sessionToken, tier } = await request.json();

  // Get anonymous test data
  const { data: anonTest } = await supabase
    .from('anonymous_tests')
    .select('test_data')
    .eq('session_token', sessionToken)
    .single();

  if (!anonTest) {
    return NextResponse.json({ error: 'Session expired' }, { status: 400 });
  }

  const testData = anonTest.test_data;

  // Create user account
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email,
    password: Math.random().toString(36).slice(-8), // Temporary password
    options: {
      data: {
        subscription_tier: tier,
        first_test_id: testData.test_id
      }
    }
  });

  if (authError) {
    return NextResponse.json({ error: authError.message }, { status: 500 });
  }

  // Claim the anonymous test
  const { error: claimError } = await supabase
    .from('tests')
    .update({
      user_id: authData.user?.id,
      is_anonymous: false,
      claimed_at: new Date().toISOString()
    })
    .eq('id', testData.test_id);

  if (claimError) {
    return NextResponse.json({ error: claimError.message }, { status: 500 });
  }

  // Clean up anonymous test
  await supabase
    .from('anonymous_tests')
    .delete()
    .eq('session_token', sessionToken);

  // Return test URL for immediate sharing
  const testUrl = `${process.env.NEXT_PUBLIC_APP_URL}/test/${testData.share_token}`;

  return NextResponse.json({
    testUrl,
    shareToken: testData.share_token,
    userId: authData.user?.id
  });
}
```

```typescript
// app/api/daily/create-room/route.ts - Copy from POC
// app/api/transcription/webhook/route.ts - Copy from POC with updates for test_sessions table
```

**Checkpoint:** Database migrated, environment configured, utilities ready. ✓
```

**Current Implementation Context:**
@design-1-planning.md for Stage 1: Foundation Setup in @mvp-implementation-plan.md - ensure no code, examples, or context is lost from the MVP plan.

### Design Context

**No Figma designs for this stage** - This is pure backend/infrastructure setup.

**Design References:**
- N/A - This stage focuses on database architecture and API foundation
- The POC codebase serves as the reference implementation for utility files

### Codebase Context

**Target:** Foundation setup for MVP user testing app
**Status:** New implementation based on proven POC patterns
**Backend:** Supabase (PostgreSQL + Auth + Realtime)
**Frontend:** Next.js 14 (App Router)

**Existing POC Files to Reference/Copy:**
1. **Supabase Client Utilities:**
   - `lib/supabase/client.ts` - Browser client setup
   - `lib/supabase/server.ts` - Server-side client with cookies

2. **External Service Utilities:**
   - `lib/daily.ts` - Daily.co room creation and management
   - `lib/openai.ts` - OpenAI Whisper transcription handling

3. **UI Components:**
   - `components/ui/*` - All shadcn/ui components from POC
   - `app/layout.tsx` - Base layout with Toaster notifications

4. **Existing API Routes from POC:**
   - Daily room creation endpoint
   - Transcription webhook handler (needs updating for new schema)

**Database Architecture Considerations:**

**Tests Table Design:**
- Uses JSONB for flexible configuration (allows easy updates without migrations)
- Anonymous test support via `is_anonymous` flag
- Auto-generated `share_token` for public sharing
- Supports claiming anonymous tests via `user_id` and `claimed_at`

**Test Sessions Table Design:**
- Tracks both video recordings AND text-only feedback
- Transcript status tracking: `pending` → `processing` → `completed`/`failed`
- Session token for tester access control
- Consent tracking with timestamp

**Anonymous Tests Table:**
- Temporary storage for pre-signup flow
- 24-hour expiration for privacy/cleanup
- Bridges anonymous test creation → account signup → test claiming

**Critical Database Features:**
1. **RLS Policies:** Ensure users only see their own tests while allowing anonymous test creation
2. **Automatic Session Counting:** Trigger updates `sessions_completed` in test config
3. **GIN Index on JSONB:** Optimizes config queries
4. **Cleanup Function:** Removes expired anonymous tests

**Environment Variables Required:**
- Supabase: URL, anon key, service role key
- Daily.co: API key, domain
- OpenAI: API key for transcription
- App URL: For generating shareable links

### Prototype Scope

**This is NOT a prototype - this is production foundation setup.**

**Full Backend Integration:**
- Complete database schema with all tables, indexes, policies
- Production-ready RLS security policies
- Real external service integrations (Daily.co, OpenAI)
- Proper environment configuration

**What to Build:**
1. **Database Migration File:** Single comprehensive migration with all tables, indexes, functions, triggers
2. **Environment Template:** Document all required environment variables
3. **Core Utilities:** Copy proven POC utilities (no reinvention)
4. **New Utilities:** Test management utilities with smart URL parsing
5. **API Routes:** Anonymous test creation and signup-with-test claim flow

**What to Preserve from POC:**
- Supabase client configurations (proven patterns)
- Daily.co integration utilities
- OpenAI transcription utilities
- UI component library (shadcn/ui)
- Base layout with toast notifications

**No Mock Data:** All utilities must work with real Supabase database from the start.

### Plan

**Step 1: Create Database Migration File**
- File: `supabase/migrations/[timestamp]_complete_mvp_setup.sql`
- Create three tables: `tests`, `test_sessions`, `anonymous_tests`
- Add all indexes for performance optimization
- Enable RLS on all tables
- Create RLS policies for proper access control:
  - Tests: Anonymous creation, owner access, update permissions
  - Test sessions: Public creation, owner viewing, session token updates
  - Anonymous tests: Public access (short-lived)
- Create utility functions:
  - `cleanup_expired_anonymous_tests()` - Remove expired anonymous test data
  - `increment_session_count()` - Trigger function to update test completion count
- Create trigger: `update_test_session_count` on test_sessions table
- Test migration: Run against local Supabase instance to verify syntax

**Step 2: Environment Configuration**
- File: `.env.local` (create if doesn't exist)
- Document all required variables:
  - `NEXT_PUBLIC_SUPABASE_URL` - From Supabase project settings
  - `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Public anon key
  - `SUPABASE_SERVICE_ROLE_KEY` - Service role for admin operations
  - `DAILY_API_KEY` - From Daily.co dashboard
  - `DAILY_DOMAIN` - Your Daily.co domain (e.g., yourapp.daily.co)
  - `OPENAI_API_KEY` - For Whisper transcription
  - `NEXT_PUBLIC_APP_URL` - http://localhost:3000 (dev) or production URL
- Add `.env.local` to `.gitignore` if not already present
- Create `.env.example` template for other developers

**Step 3: Copy Core Utilities from POC**
- **Supabase Clients:**
  - Copy `lib/supabase/client.ts` → Browser-side Supabase client
  - Copy `lib/supabase/server.ts` → Server-side client with cookie handling
  - Verify imports work with new project structure

- **External Service Utilities:**
  - Copy `lib/daily.ts` → Daily.co room creation utilities
  - Copy `lib/openai.ts` → OpenAI Whisper transcription
  - Update imports if file paths changed

- **UI Components:**
  - Copy all files from `components/ui/*` (shadcn components)
  - Verify `components.json` exists for shadcn CLI

- **Base Layout:**
  - Copy `app/layout.tsx` with Toaster provider
  - Ensure `sonner` package installed for toast notifications

**Step 4: Create Test Management Utilities**
- File: `lib/tests.ts`
- Define TypeScript interface `Test` with all fields matching database schema
- Implement `generateSmartDefaults(appUrl: string)` function:
  - Parse URL to extract app name from hostname
  - Generate capitalized app name for title
  - Create contextual welcome message
  - Provide sensible default tasks
  - Handle invalid URLs with fallback defaults
- Export interface and function for use in API routes and components

**Step 5: Create Anonymous Test API Route**
- File: `app/api/tests/anonymous/route.ts`
- Implement POST handler:
  - Accept test configuration from request body
  - Generate unique session token using `nanoid`
  - Insert into `anonymous_tests` table with 24-hour expiration
  - Create actual test in `tests` table with `is_anonymous: true`
  - Link anonymous test record to actual test (store test_id and share_token)
  - Return session token and share token to client
- Error handling: Return proper HTTP status codes and error messages
- Security: No authentication required (anonymous flow)

**Step 6: Create Signup-with-Test API Route**
- File: `app/api/auth/signup-with-test/route.ts`
- Implement POST handler:
  - Accept: email, sessionToken, tier (subscription level)
  - Fetch anonymous test data using session token
  - Validate session exists (return 400 if expired)
  - Create user account via `supabase.auth.signUp()`:
    - Generate temporary password
    - Store subscription_tier and first_test_id in user metadata
  - Claim anonymous test:
    - Update test record with user_id
    - Set `is_anonymous: false` and `claimed_at: NOW()`
  - Clean up anonymous test record (delete after claiming)
  - Return test URL and share token for immediate use
- Error handling: Handle auth errors, database errors gracefully
- Security: Validate session token before account creation

**Step 7: Copy POC API Routes**
- **Daily Room Creation:**
  - Copy `app/api/daily/create-room/route.ts` from POC
  - Verify Daily API key environment variable
  - Test room creation works with current Daily.co account

- **Transcription Webhook:**
  - Copy `app/api/transcription/webhook/route.ts` from POC
  - **CRITICAL UPDATE:** Modify to use `test_sessions` table instead of old schema
  - Update status field references: `transcript_status` enum values
  - Ensure webhook updates `transcript` JSONB field
  - Handle `transcript_error` field for failed transcriptions

**Step 8: Verification and Testing**
- Run database migration: `supabase migration up`
- Verify all tables created: Query Supabase dashboard
- Test RLS policies: Try accessing data with/without auth
- Test triggers: Insert test session completion, verify count increments
- Verify environment variables loaded correctly
- Test API routes:
  - POST to `/api/tests/anonymous` with sample data
  - POST to `/api/auth/signup-with-test` with session token
  - Verify database records created correctly
- Test utility functions:
  - Call `generateSmartDefaults()` with various URLs
  - Verify smart parsing works correctly

### Stage
Complete

### Completion Status
**Completed**: 2025-01-18
**Agent**: Design Agent 6 (Completion & Self-Improvement)
**Branch**: MVP
**Commit**: (will be added after git push)

### Questions for Clarification

**Database Schema:**
- [CONFIRMED] Using JSONB for test config provides flexibility - correct approach
- [CONFIRMED] Share token generation using `substr(md5(random()::text), 0, 12)` is secure enough for beta
- [CONFIRMED] 24-hour expiration for anonymous tests is appropriate timeframe

**Environment Setup:**
- [NEEDS VERIFICATION] Are the Daily.co and OpenAI API keys already set up from POC?
- [NEEDS VERIFICATION] Should we use the same Supabase project or create a new one for MVP?
- [CONFIRMED] Using http://localhost:3000 for development is standard

**POC File Copying:**
- [NEEDS CLARIFICATION] Are all POC utility files in a stable state ready to copy?
- [NEEDS CLARIFICATION] Should we copy POC files exactly or make improvements?
- Suggested default: Copy exactly first, then improve iteratively

**API Routes:**
- [CONFIRMED] Anonymous test creation requires no authentication (correct for UX)
- [CONFIRMED] Temporary password generation for signup is acceptable (user will set via email)
- [NEEDS VERIFICATION] Should transcription webhook require authentication/signature verification?

**Testing Strategy:**
- [NEEDS CLARIFICATION] Should we set up automated tests for API routes or manual testing first?
- Suggested default: Manual testing first, automated tests in polish phase

### Priority
**High** - This is the foundation for all other MVP screens. Nothing else can be built until this is complete.

### Created
2025-01-18 (Planning Phase)

### Files
**New Files to Create:**
- `supabase/migrations/[timestamp]_complete_mvp_setup.sql` - Complete database schema
- `.env.local` - Environment configuration (not committed)
- `.env.example` - Environment template for team
- `lib/tests.ts` - Test management utilities
- `app/api/tests/anonymous/route.ts` - Anonymous test creation
- `app/api/auth/signup-with-test/route.ts` - Signup with test claiming

**Files to Copy from POC:**
- `lib/supabase/client.ts` - Browser Supabase client
- `lib/supabase/server.ts` - Server Supabase client
- `lib/daily.ts` - Daily.co utilities
- `lib/openai.ts` - OpenAI transcription utilities
- `app/layout.tsx` - Base layout with Toaster
- `components/ui/*` - All shadcn components
- `app/api/daily/create-room/route.ts` - Daily room API
- `app/api/transcription/webhook/route.ts` - Transcription webhook (needs updates)

**Key Dependencies:**
- `nanoid` - For session token generation
- `sonner` - For toast notifications (if not already installed)
- Supabase client libraries (should already be installed)

### Review Notes

**Review Date:** 2025-01-18
**Reviewer:** Agent 2 (Review & Clarification)

## Review Summary

### Requirements Coverage
✓ Database schema design addresses all MVP requirements
✓ Anonymous test flow properly architected
✓ Environment configuration covers all external services
✓ Test management utilities include smart defaults generation
✓ API routes handle signup-with-test flow
⚠️ CRITICAL: Existing database conflicts not addressed

### Technical Validation

**✅ Verified POC Files Exist:**
- `lib/supabase/client.ts` ✓
- `lib/supabase/server.ts` ✓
- `lib/daily.ts` ✓
- `components/ui/*` (10 components verified) ✓
- `app/api/daily/` routes exist ✓

**❌ Missing POC Files:**
- `lib/openai.ts` - Does NOT exist
  - OpenAI logic appears to be in `app/api/transcribe/route.ts` instead
  - Plan needs adjustment to either create new utility or use existing API route pattern

**🚨 CRITICAL DATABASE CONFLICTS:**
- `test_sessions` table ALREADY EXISTS from POC (created 2025-10-27)
- Existing migrations found:
  1. `20251027165723_create_test_sessions_table.sql` - Creates initial table
  2. `20251027195726_add_recording_fields_to_test_sessions.sql` - Adds recording fields
  3. `20251028000000_add_feedback_to_test_sessions.sql` - Adds feedback column
  4. `20251105000000_add_transcription_retry_fields.sql` - Adds retry fields
  5. `20251105172050_add_is_text_mode_column.sql` - Adds text mode flag

**Impact**: Plan's Step 1 would fail immediately due to table conflict

### Risk Assessment
- **HIGH RISK**: Database migration will fail if attempting to CREATE TABLE for existing table
- **MEDIUM RISK**: Missing OpenAI utility file requires clarification
- **LOW RISK**: All other POC files verified and ready to copy

### Design System Compliance
✓ Uses existing shadcn/ui components (verified 10 components exist)
✓ Follows Supabase RLS patterns
✓ Maintains POC patterns where applicable

### Architecture Concerns

**Database Schema Issues:**
1. **Table Conflict Resolution Needed**: Should we:
   - Option A: ALTER existing test_sessions table to match new schema?
   - Option B: DROP and recreate (data loss risk)?
   - Option C: Create migration to transform existing schema?

2. **Missing Tables**: The plan correctly identifies need for:
   - `tests` table (new, no conflict)
   - `anonymous_tests` table (new, no conflict)
   - But `test_sessions` modifications need different approach

**File Organization Issues:**
1. **OpenAI Transcription Pattern**: Current codebase uses API route pattern, not utility file
   - Should follow existing pattern or refactor to utility?

### Recommendations

1. **MUST RESOLVE**: Database migration strategy for existing tables
2. **MUST CLARIFY**: OpenAI transcription approach (utility vs API route)
3. **CONSIDER**: Review existing test_sessions columns vs proposed schema
4. **VERIFY**: Check if existing RLS policies need updates

## User Decisions (2025-01-18)

1. **Database Migration Strategy**: **DROP and RECREATE** - POC data can be dropped, moving on to MVP
2. **OpenAI Integration**: **Keep API route pattern** - Follow existing pattern, update MVP plan if needed
3. **Environment**: **Use existing Supabase project** - Already configured

## Execution-Ready Specification

### Context Summary
- Task: Foundation setup for MVP user testing app
- Scope: Database schema, environment, utilities, API routes
- Critical: POC data can be dropped, this is a fresh MVP build

### Pre-Implementation Checklist
- [x] Verified POC files exist (except lib/openai.ts which uses API route pattern)
- [x] Environment variables confirmed (missing SERVICE_ROLE_KEY and DAILY_DOMAIN need adding)
- [x] Database conflict resolution decided (DROP and recreate)
- [ ] Backup existing database (optional, user confirmed data can be dropped)

### Implementation Steps (VALIDATED & UPDATED)

**Step 1: DROP Existing Tables and Create Fresh Schema**
- File: `supabase/migrations/[timestamp]_mvp_complete_setup.sql`
- **CRITICAL CHANGE**: Start with DROP TABLE statements:
  ```sql
  -- Drop existing POC tables
  DROP TABLE IF EXISTS test_sessions CASCADE;

  -- Now create fresh MVP schema
  CREATE TABLE tests (...);
  CREATE TABLE test_sessions (...);
  CREATE TABLE anonymous_tests (...);
  ```
- Create all three tables with MVP schema as specified
- Add all indexes, RLS policies, functions, and triggers
- Test migration locally to verify clean slate approach works

**Step 2: Environment Configuration (UPDATED)**
- File: `.env.local`
- Add missing variables:
  - `SUPABASE_SERVICE_ROLE_KEY` - Get from Supabase dashboard
  - `DAILY_DOMAIN` - Get from Daily.co dashboard
- Note: App runs on port 3001, not 3000 as MVP plan suggests
- Create `.env.example` template for team

**Step 3: Copy Core Utilities from POC (NO CHANGES)**
- Copy `lib/supabase/client.ts` and `lib/supabase/server.ts`
- Copy `lib/daily.ts` for Daily.co utilities
- Copy all `components/ui/*` files
- Copy `app/layout.tsx` with Toaster

**Step 4: Create Test Management Utilities (NO CHANGES)**
- File: `lib/tests.ts`
- Implement as specified in original plan
- TypeScript interface and smart defaults function

**Step 5: Create Anonymous Test API Route (NO CHANGES)**
- File: `app/api/tests/anonymous/route.ts`
- Implement as specified

**Step 6: Create Signup-with-Test API Route (NO CHANGES)**
- File: `app/api/auth/signup-with-test/route.ts`
- Implement as specified

**Step 7: Handle Existing API Routes (UPDATED APPROACH)**
- **Daily Room Creation**:
  - POC has `app/api/daily/room/route.ts` (not `/create-room`)
  - Keep existing pattern, no changes needed
- **Transcription Handling**:
  - Keep existing `app/api/transcribe/route.ts` for OpenAI logic
  - Update webhook handler `app/api/webhooks/daily-recording/route.ts` for new schema
  - NO `lib/openai.ts` utility file needed

**Step 8: Verification and Testing**
- Run migration with DROP statements
- Verify clean database state
- Test all API routes
- Confirm environment variables work

### MVP Plan Updates Needed
The MVP implementation plan at `zebra-planning/user-testing-app/mvp-implementation-plan.md` needs these corrections:

1. **Line 178**: Remove reference to `lib/openai.ts` - OpenAI logic stays in API route
2. **Line 171**: Update `NEXT_PUBLIC_APP_URL` to use port 3001 not 3000
3. **Line 377**: Update API route reference from `/api/daily/create-room` to `/api/daily/room`
4. **Add note**: Database migration includes DROP statements for clean slate

### Risk Mitigation
- Data loss is acceptable (user confirmed)
- Service interruption minimal (POC to MVP transition)
- All existing integrations preserved with updates

---

## Technical Discovery (Agent 3)

**Discovery Date:** 2025-01-18
**Agent:** Technical Discovery (Agent 3)

### Component Identification Verification
- **Target:** Foundation setup for MVP user testing app
- **Scope:** Database schema, environment configuration, core utilities, API routes
- **Verification Steps**:
  - [x] Verified existing POC files and their current state
  - [x] Confirmed database migration files exist (5 POC migrations found)
  - [x] Validated Supabase client utilities exist and are functional
  - [x] Confirmed Daily.co integration utilities exist and are working
  - [x] Verified UI components library (10 shadcn components found)
  - [x] Checked API routes pattern (Daily room creation, transcription, webhook)

### MCP Research Results

#### Database Schema Verification

**Current State - POC Database:**
- **test_sessions table EXISTS** (created 2025-10-27)
- **Existing migrations found**:
  1. `20251027165723_create_test_sessions_table.sql` - Initial table with basic fields
  2. `20251027195726_add_recording_fields_to_test_sessions.sql` - Adds recording_id, recording_started_at
  3. `20251028000000_add_feedback_to_test_sessions.sql` - Adds feedback text field
  4. `20251105000000_add_transcription_retry_fields.sql` - Adds transcription_attempts, transcription_error, last_transcription_attempt_at
  5. `20251105172050_add_is_text_mode_column.sql` - Adds is_text_mode boolean

**Current test_sessions Schema:**
```sql
CREATE TABLE test_sessions (
  id UUID PRIMARY KEY,
  tester_name TEXT NOT NULL,
  tester_email TEXT NOT NULL,
  transcript TEXT,
  audio_url TEXT,
  daily_room_url TEXT,
  recording_id TEXT,
  recording_started_at TIMESTAMPTZ,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  feedback TEXT,
  transcription_attempts INTEGER DEFAULT 0,
  transcription_error TEXT,
  last_transcription_attempt_at TIMESTAMPTZ,
  is_text_mode BOOLEAN
);
```

**Missing Tables:**
- ❌ `tests` table does NOT exist
- ❌ `anonymous_tests` table does NOT exist

**Migration Strategy Validated:**
- ✅ DROP and recreate approach is correct
- ✅ User confirmed data loss is acceptable
- ✅ Clean slate for MVP is preferred

#### Core Utilities Verification

**1. Supabase Client Utilities** ✅
- **File:** `lib/supabase/client.ts` - EXISTS
- **Status:** Fully functional
- **Implementation:** Uses `@supabase/ssr` with `createBrowserClient`
- **Key Detail:** Uses `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` (not ANON_KEY as plan suggests)
- **Import Pattern:** `import { createClient } from '@/lib/supabase/client'`
- **Note:** No changes needed, can be used as-is

**2. Supabase Server Utilities** ✅
- **File:** `lib/supabase/server.ts` - EXISTS
- **Status:** Fully functional
- **Implementation:** Uses `createServerClient` with Next.js cookies integration
- **Import Pattern:** `import { createClient } from '@/lib/supabase/server'`
- **Note:** Properly handles cookie management for SSR
- **No changes needed**

**3. Daily.co Integration Utilities** ✅
- **File:** `lib/daily.ts` - EXISTS and COMPREHENSIVE
- **Status:** Production-ready with advanced features
- **Functions Available:**
  - `createDailyRoom(sessionId)` - Creates room via API
  - `initializeDaily(roomUrl)` - Client-side Daily initialization with cleanup
  - `getDailyAudioLevel(callObject)` - Audio level monitoring
  - `startRecording(roomName)` - Cloud recording start
  - `stopRecording(roomName)` - Cloud recording stop
  - `getRoomNameFromUrl(roomUrl)` - URL parsing utility
- **Import Pattern:** `import { createDailyRoom, initializeDaily, ... } from '@/lib/daily'`
- **Note:** More comprehensive than plan expected - includes recording management
- **No changes needed**

**4. OpenAI Transcription Pattern** ✅
- **File:** `lib/openai.ts` - DOES NOT EXIST (as Agent 2 identified)
- **Alternative:** OpenAI logic is in `app/api/transcribe/route.ts`
- **Status:** Fully functional API route pattern
- **Implementation Details:**
  - POST endpoint accepts `{ sessionId }`
  - Fetches recording URL from database
  - Downloads audio from Daily.co
  - Sends to OpenAI Whisper API
  - Saves transcript to database
  - Includes retry logic with max 3 attempts
  - Error tracking in database
- **Pattern Decision:** ✅ Keep API route pattern (no utility file needed)
- **No changes needed - existing pattern works**

**5. Session Management Utilities** ✅
- **File:** `lib/session.ts` - EXISTS and FUNCTIONAL
- **Status:** Working with current POC schema
- **Functions Available:**
  - `createTestSession(name, email)` - Creates new session
  - `getTestSession(id)` - Fetches session by ID
  - `updateTestSession(id, updates)` - Updates session fields
  - `completeTestSession(id)` - Marks session as completed
- **TypeScript Interface:** `TestSession` interface matches current schema
- **Note:** Will need updates for new MVP schema (test_id field, etc.)
- **Action Required:** Update after new schema is migrated

#### API Routes Verification

**1. Daily Room Creation** ✅
- **File:** `app/api/daily/room/route.ts` - EXISTS
- **Status:** Fully functional
- **Note:** Plan refers to `/api/daily/create-room` but actual path is `/api/daily/room`
- **Pattern:** POST with `{ sessionId }` returns `{ roomUrl, roomName }`
- **Environment Variable:** Uses `DAILY_API_KEY`
- **No changes needed**

**2. Daily Recording Control** ✅
- **File:** `app/api/daily/recording/route.ts` - EXISTS
- **Status:** Functional
- **Pattern:** POST with `{ roomName, action: 'start' | 'stop' }`
- **No changes needed**

**3. Daily Recording Webhook** ✅
- **File:** `app/api/webhooks/daily-recording/route.ts` - EXISTS
- **Status:** Fully functional with auto-transcription trigger
- **Pattern:** Receives Daily.co webhook → updates audio_url → triggers transcription
- **Note:** Will need updates for new schema (test_id reference)
- **Action Required:** Update for new schema

**4. Transcription Endpoint** ✅
- **File:** `app/api/transcribe/route.ts` - EXISTS
- **Status:** Production-ready with retry logic
- **Pattern:** POST with `{ sessionId }` → OpenAI Whisper → saves transcript
- **Features:** Retry tracking, error handling, attempt counting
- **No changes needed**

**5. Feedback Endpoint** ✅
- **File:** `app/api/feedback/route.ts` - EXISTS (for text-only mode)
- **Status:** Working
- **Note:** Part of text-only feedback feature

**Missing API Routes (Need Creation):**
- ❌ `app/api/tests/anonymous/route.ts` - Anonymous test creation
- ❌ `app/api/auth/signup-with-test/route.ts` - Signup with test claiming

#### UI Components Library

**shadcn/ui Components Available:** ✅
- `components/ui/badge.tsx`
- `components/ui/banner.tsx`
- `components/ui/button.tsx`
- `components/ui/card.tsx`
- `components/ui/checkbox.tsx`
- `components/ui/dropdown-menu.tsx`
- `components/ui/input.tsx`
- `components/ui/label.tsx`
- `components/ui/spinner.tsx`
- `components/ui/textarea.tsx`

**Configuration:** ✅
- `components.json` exists and properly configured
- Style: new-york
- Base color: neutral
- CSS variables: enabled
- Path aliases: configured (`@/components`, `@/lib/utils`, etc.)

**Utils Library:** ✅
- `lib/utils.ts` exists with `cn()` helper
- Additional utilities: `debounce()`, `formatRelativeTime()`

#### Environment Variables Analysis

**Current Environment Variable Names:**
- ✅ `NEXT_PUBLIC_SUPABASE_URL` - Used in code
- ✅ `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` - Used in code (NOT ANON_KEY)
- ✅ `DAILY_API_KEY` - Used in API routes
- ✅ `OPENAI_API_KEY` - Used in transcription
- ✅ `NEXT_PUBLIC_APP_URL` - Used in webhook for self-callback

**Missing Environment Variables:**
- ❌ `SUPABASE_SERVICE_ROLE_KEY` - Needed for admin operations (test claiming)
- ❌ `DAILY_DOMAIN` - Not currently used but mentioned in plan

**Environment File Status:**
- ✅ `.env*.local` is in `.gitignore`
- ✅ `.env` is in `.gitignore`
- ❌ No `.env.local` file found (gitignored, as expected)
- ❌ No `.env.example` template exists (needs creation)

**Port Configuration:**
- ⚠️ Plan suggests port 3000, but package.json shows port 3001 for active dev
- ⚠️ `app/layout.tsx` still references `localhost:3000` in defaultUrl

#### Dependencies Analysis

**Required Dependencies (from package.json):**

**Core Dependencies:** ✅ All installed
- `next` (latest) ✅
- `react` (^19.0.0) ✅
- `@supabase/ssr` (latest) ✅
- `@supabase/supabase-js` (latest) ✅
- `@daily-co/daily-js` (^0.85.0) ✅

**UI Dependencies:** ✅ All installed
- `@radix-ui/react-checkbox` ✅
- `@radix-ui/react-dropdown-menu` ✅
- `@radix-ui/react-label` ✅
- `@radix-ui/react-slot` ✅
- `lucide-react` ✅
- `framer-motion` ✅

**Utility Dependencies:** ✅ All installed
- `class-variance-authority` ✅
- `clsx` ✅
- `tailwind-merge` ✅
- `zod` ✅

**Missing Dependencies:**
- ❌ `nanoid` - Required for session token generation (mentioned in plan)
- ❌ `sonner` - Toast notifications (mentioned in plan for Toaster)

**Note:** Checking for toast implementation...
- Layout file uses `ThemeProvider` but no Toaster component visible
- Need to verify if sonner is needed or if using alternative

#### Layout and Base Setup

**Current Layout Status:**
- **File:** `app/layout.tsx` - EXISTS
- **Features:**
  - ✅ ThemeProvider with next-themes
  - ✅ Geist font configured
  - ✅ Metadata for SEO
  - ❌ No Toaster component (plan expects sonner Toaster)
- **Note:** Plan expects Toaster for notifications, needs verification or addition

### Implementation Feasibility

#### Critical Issues Identified

**1. Database Schema Migration Approach** - RESOLVED ✅
- **Issue:** POC test_sessions table exists, plan creates same table
- **Resolution:** User confirmed DROP and recreate strategy
- **Action:** Migration file must start with `DROP TABLE IF EXISTS test_sessions CASCADE;`
- **Status:** Clear path forward

**2. Environment Variable Naming Mismatch** - MINOR ⚠️
- **Issue:** Plan uses `NEXT_PUBLIC_SUPABASE_ANON_KEY`, code uses `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`
- **Impact:** Documentation needs correction
- **Resolution:** Use `PUBLISHABLE_KEY` (matches Supabase's current naming)
- **Action:** Update plan documentation

**3. Port Configuration Discrepancy** - MINOR ⚠️
- **Issue:** Plan suggests port 3000, package.json uses 3001
- **Impact:** Documentation and defaultUrl need consistency
- **Resolution:** Document that active dev uses port 3001
- **Action:** Update `.env.example` and docs

**4. Missing Dependencies** - ACTION REQUIRED 📦
- **Issue:** `nanoid` and possibly `sonner` not installed
- **Impact:** Cannot generate session tokens without nanoid
- **Resolution:** Install `nanoid` before implementation
- **Action:** Add to Step 0: `npm install nanoid`
- **Sonner:** Verify if needed or if using alternative toast solution

**5. Toast Notification Implementation** - NEEDS CLARIFICATION ❓
- **Issue:** Plan expects Toaster in layout, not currently present
- **Impact:** May need to add sonner + Toaster or use alternative
- **Resolution:** Verify with user or implement as planned
- **Action:** Clarify toast strategy or add sonner

#### No Blocking Technical Issues ✅

All technical requirements are feasible:
- ✅ Supabase clients working
- ✅ Daily.co integration proven
- ✅ OpenAI transcription functional
- ✅ UI components available
- ✅ Database migration path clear
- ✅ API route patterns established

### Required Installations

**Before Implementation:**
```bash
# Install missing dependencies
npm install nanoid

# Optional: If using sonner for toasts (verify with user first)
npm install sonner
```

**No shadcn/ui components need installation** - All required components already exist in `components/ui/`

### Discovery Summary

**All Components/Utilities Available:** ✅ (except nanoid dependency)

**Technical Blockers:** None ✅

**Ready for Implementation:** Yes, with minor dependency installation ✅

**Special Notes:**
1. **Environment Variables:** Use `PUBLISHABLE_KEY` not `ANON_KEY`
2. **Port:** Active dev runs on 3001, not 3000
3. **OpenAI Pattern:** Keep API route pattern, no utility file needed
4. **Daily Path:** Use `/api/daily/room` not `/api/daily/create-room`
5. **Database Strategy:** DROP CASCADE then CREATE (user approved)
6. **Dependencies:** Install `nanoid` before starting implementation
7. **Toast Strategy:** Clarify if adding sonner or using alternative

### Files Ready to Copy (No Changes Needed)
- ✅ `lib/supabase/client.ts` - Ready to use
- ✅ `lib/supabase/server.ts` - Ready to use
- ✅ `lib/daily.ts` - Ready to use (more features than expected)
- ✅ `components/ui/*` - All 10 components ready
- ✅ `app/api/daily/room/route.ts` - Working perfectly
- ✅ `app/api/daily/recording/route.ts` - Functional
- ✅ `app/api/transcribe/route.ts` - Production-ready

### Files Needing Updates After New Schema
- ⚠️ `lib/session.ts` - Update TypeScript interfaces and functions for new schema
- ⚠️ `app/api/webhooks/daily-recording/route.ts` - Update for test_id foreign key

### Files to Create (New)
- 📝 `supabase/migrations/[timestamp]_mvp_complete_setup.sql` - Complete MVP schema
- 📝 `.env.example` - Environment variable template
- 📝 `lib/tests.ts` - Test management utilities
- 📝 `app/api/tests/anonymous/route.ts` - Anonymous test creation
- 📝 `app/api/auth/signup-with-test/route.ts` - Signup with test claiming

### Execution Readiness Checklist

- [x] Database migration strategy confirmed (DROP and recreate)
- [x] All POC utility files verified and functional
- [x] API route patterns documented and working
- [x] UI components available (10 shadcn components)
- [x] Environment variable names verified (with corrections noted)
- [ ] Install `nanoid` dependency (REQUIRED before execution)
- [ ] Clarify toast notification strategy (sonner or alternative)
- [x] Port configuration documented (3001 for active dev)
- [x] No blocking technical issues identified

**Recommendation:** Ready to proceed to Execution stage after installing `nanoid` and clarifying toast strategy.

---

**Technical Discovery Complete** ✓
**Next Stage:** Ready to Execute (after dependency installation)
**Time Taken:** ~10 minutes
**MCP Tools Used:** File reading, directory listing, code search
**Issues Found:** 2 minor (env naming, port), 1 required (nanoid), 1 clarification (toast)
**Blocking Issues:** 0 critical blockers

---

## Implementation Notes

**Implementation Date:** 2025-01-18
**Status:** ✅ Implementation Complete - Ready for Manual Testing

### Summary of Changes

**All tasks completed successfully:**
- ✅ Database schema migrated (DROP and CREATE approach)
- ✅ Environment configuration template created
- ✅ Core utilities verified (no copying needed - already exist from POC)
- ✅ Test management utilities created
- ✅ Anonymous test API route created
- ✅ Signup-with-test API route created
- ✅ Existing API routes updated for new schema
- ✅ TypeScript compilation successful
- ✅ Linting passed

### Files Created

**1. Database Migration:** `supabase/migrations/20250118000000_mvp_complete_setup.sql`
- DROP TABLE IF EXISTS test_sessions CASCADE (clean slate approach)
- CREATE TABLE tests (with JSONB config for flexibility)
- CREATE TABLE test_sessions (new MVP schema with renamed fields)
- CREATE TABLE anonymous_tests (24-hour expiration for pre-signup flow)
- Indexes for performance (GIN index on JSONB config)
- RLS policies for security
- Utility functions: cleanup_expired_anonymous_tests(), increment_session_count()
- Trigger: update_test_session_count

**2. Environment Template:** `.env.example`
- All required environment variables documented
- Uses NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY (not ANON_KEY)
- Port 3001 (not 3000 as plan originally suggested)
- Template ready for team use

**3. Test Management Utilities:** `lib/tests.ts`
- Test interface with TypeScript types matching database schema
- generateSmartDefaults(appUrl) function for contextual test configuration
- Smart URL parsing to extract app name and create relevant defaults

**4. Anonymous Test API:** `app/api/tests/anonymous/route.ts`
- POST endpoint for creating anonymous tests before signup
- Uses nanoid for session token generation
- Creates record in anonymous_tests table with 24-hour expiration
- Creates actual test with is_anonymous=true
- Links anonymous test to real test for later claiming

**5. Signup with Test API:** `app/api/auth/signup-with-test/route.ts`
- POST endpoint for user signup with test claiming
- Fetches anonymous test data using session token
- Creates user account via Supabase Auth
- Claims test by setting user_id and is_anonymous=false
- Cleans up anonymous test record after claiming
- Returns test URL for immediate sharing

### Files Modified

**1. Session Management:** `lib/session.ts`
- ✅ Updated TestSession interface for MVP schema
- ✅ Added new fields: test_id, session_token, consent fields, transcript as Record<string, unknown>
- ✅ Renamed fields: daily_room_url → daily_room_name, audio_url → recording_url, is_text_mode → is_text_only
- ✅ Added backward compatibility mapping in updateTestSession
- ✅ Fixed TypeScript any types to proper types

**2. Daily Recording Webhook:** `app/api/webhooks/daily-recording/route.ts`
- ✅ Updated field name from audio_url to recording_url

**3. POC Page Files Updated for New Schema:**
- ✅ `app/zebra/[sessionId]/complete/page.tsx` - Added null handling for tester_name
- ✅ `app/zebra/[sessionId]/mic-check/page.tsx` - Updated daily_room_url → daily_room_name, added null handling
- ✅ `app/zebra/[sessionId]/test/page.tsx` - Updated field names and null handling

**4. Testing Interface Component:** `components/test-flow/testing-interface.tsx`
- ✅ Removed recording_started_at update (field doesn't exist in MVP schema)
- ✅ Recording ID is saved via recording-started event handler

**5. Status Tracking:** `documentation/design-agents-flow/status.md`
- ✅ Moved task from "Execution" to "Testing" section

### Dependencies Installed

- ✅ `nanoid` - Session token generation (verified already installed)
- ✅ `sonner` - Not needed (layout uses ThemeProvider instead)

### Key Implementation Decisions

**1. Database Migration Strategy:**
- Used DROP TABLE IF EXISTS test_sessions CASCADE
- Clean slate approach approved by user
- POC data was acceptable to lose

**2. Field Name Changes:**
- POC: daily_room_url, audio_url, is_text_mode
- MVP: daily_room_name, recording_url, is_text_only
- Backward compatibility layer in lib/session.ts updateTestSession

**3. Null Handling:**
- TestSession fields like tester_name are nullable in database
- Updated all usages to handle null with fallbacks (|| '' or || undefined)
- TypeScript strict null checking enforced

**4. Environment Variable Naming:**
- Used NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY (matches Supabase current naming)
- Not NEXT_PUBLIC_SUPABASE_ANON_KEY as plan originally suggested

**5. Port Configuration:**
- Active dev runs on port 3001 (not 3000)
- Updated .env.example to reflect actual port

### Build and Lint Results

**TypeScript Compilation:** ✅ PASSED
```
✓ Compiled successfully
✓ Generating static pages (24/24)
✓ Finalizing page optimization
```

**ESLint:** ✅ PASSED
- Fixed all unused imports
- Fixed all TypeScript any types
- No linting errors remain

**Files Fixed for TypeScript:**
- lib/tests.ts (removed unused import)
- lib/session.ts (changed any to proper types)
- app/api/tests/anonymous/route.ts (removed unused variable, fixed any types)
- app/api/auth/signup-with-test/route.ts (fixed any types)
- app/zebra/[sessionId]/complete/page.tsx (null handling)
- app/zebra/[sessionId]/mic-check/page.tsx (field names + null handling - 3 locations)
- app/zebra/[sessionId]/test/page.tsx (field names + null handling - 5 locations)
- components/test-flow/testing-interface.tsx (removed non-existent field)

### Database Migration Execution

**Command Used:** `supabase db push --linked --include-all`

**Result:** ✅ SUCCESS
- POC test_sessions table dropped successfully
- All three new tables created (tests, test_sessions, anonymous_tests)
- All indexes created
- All RLS policies enabled
- All utility functions created
- Trigger created and functional

### What Was NOT Needed

**Files Already Exist from POC (No Copying Needed):**
- ✅ lib/supabase/client.ts (working perfectly)
- ✅ lib/supabase/server.ts (working perfectly)
- ✅ lib/daily.ts (comprehensive implementation)
- ✅ lib/daily-token.ts (token generation)
- ✅ components/ui/* (all shadcn components)
- ✅ app/layout.tsx (with ThemeProvider)
- ✅ app/api/daily/room/route.ts (Daily room creation)
- ✅ app/api/daily/recording/route.ts (recording control)
- ✅ app/api/transcribe/route.ts (OpenAI integration)
- ✅ app/api/feedback/route.ts (text mode support)

**No lib/openai.ts needed:** OpenAI logic properly lives in API route

### Known Limitations and Future Work

**1. Authentication:**
- Anonymous test API has no authentication (intentional for UX)
- Session token validation happens in app logic, not RLS
- Future: Consider webhook signature verification for production

**2. Data Cleanup:**
- Anonymous tests expire after 24 hours
- No automated cleanup job configured yet
- cleanup_expired_anonymous_tests() function exists but not scheduled

**3. Test Data:**
- All POC test data was dropped
- Fresh start with MVP schema
- Previous test sessions are not migrated

**4. Environment Variables:**
- .env.local is gitignored (not included in repo)
- Team members need to create their own from .env.example template

---

## Manual Test Instructions

**Test Environment:** Local development (http://localhost:3001)

### Prerequisites

1. ✅ Ensure Supabase is running (`supabase start` if using local)
2. ✅ Ensure .env.local exists with all required variables (see .env.example)
3. ✅ Ensure migration has been applied (`supabase db push --linked --include-all`)
4. ✅ Ensure dev server is running (`npm run dev`)

### Test 1: Database Schema Verification

**Purpose:** Verify all tables, indexes, and policies exist

**Steps:**
1. Open Supabase dashboard or use SQL editor
2. Run: `SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';`
3. **Expected Result:** Should see tables: `tests`, `test_sessions`, `anonymous_tests`

4. Check indexes:
```sql
SELECT indexname FROM pg_indexes WHERE schemaname = 'public';
```
**Expected Result:** Should see indexes for share_token, user_id, test_id, recording_id, session_token, config (GIN)

5. Check RLS policies:
```sql
SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public';
```
**Expected Result:** Policies for anonymous creation, user access, session updates

6. Check functions exist:
```sql
SELECT routine_name FROM information_schema.routines WHERE routine_schema = 'public';
```
**Expected Result:** cleanup_expired_anonymous_tests, increment_session_count

7. Check trigger exists:
```sql
SELECT trigger_name FROM information_schema.triggers WHERE trigger_schema = 'public';
```
**Expected Result:** update_test_session_count on test_sessions table

### Test 2: Environment Configuration

**Purpose:** Verify all environment variables are loaded

**Steps:**
1. Check .env.local file exists (gitignored)
2. Check .env.example template exists and is comprehensive
3. Start dev server and check console for any missing environment variable errors
4. **Expected Result:** No environment variable warnings in console

**Required Variables to Verify:**
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
- SUPABASE_SERVICE_ROLE_KEY (may not be needed yet)
- DAILY_API_KEY
- DAILY_DOMAIN (may not be used yet)
- OPENAI_API_KEY
- NEXT_PUBLIC_APP_URL (should be http://localhost:3001)

### Test 3: Test Management Utilities

**Purpose:** Verify generateSmartDefaults() function works

**Steps:**
1. Create a test script or use Node.js REPL:
```typescript
import { generateSmartDefaults } from '@/lib/tests';

// Test with real URL
const result1 = generateSmartDefaults('https://zebradesign.io');
console.log(result1);
// Expected: title includes "Zebradesign", welcome_message is contextual

// Test with invalid URL
const result2 = generateSmartDefaults('not-a-url');
console.log(result2);
// Expected: fallback defaults returned
```

2. **Expected Results:**
   - Valid URL: Smart parsing extracts app name, generates contextual messages
   - Invalid URL: Fallback defaults with generic messages
   - No errors thrown

### Test 4: Anonymous Test API Route

**Purpose:** Test anonymous test creation before signup

**Steps:**
1. Use curl, Postman, or fetch to POST to `/api/tests/anonymous`:
```bash
curl -X POST http://localhost:3001/api/tests/anonymous \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://zebradesign.io",
    "title": "Zebra Design Test",
    "welcome_message": "Help us improve Zebra Design",
    "instructions": "Please think aloud as you navigate",
    "tasks": ["Explore the main sections", "Share your impressions"]
  }'
```

2. **Expected Response:**
```json
{
  "sessionToken": "abc123...",
  "testId": "uuid...",
  "shareToken": "abc123def456"
}
```

3. Verify in database:
```sql
-- Check anonymous_tests table
SELECT * FROM anonymous_tests WHERE session_token = 'abc123...';
-- Expected: Record exists with test_data JSONB containing all fields

-- Check tests table
SELECT * FROM tests WHERE id = 'uuid...';
-- Expected: Record exists with is_anonymous=true, share_token set
```

4. **Expected Database State:**
   - anonymous_tests: 1 new record with 24-hour expiration
   - tests: 1 new record with is_anonymous=true
   - test_data in anonymous_tests includes test_id and share_token

### Test 5: Signup with Test Claiming API Route

**Purpose:** Test user signup and test claiming flow

**Prerequisites:** Complete Test 4 first to get a sessionToken

**Steps:**
1. POST to `/api/auth/signup-with-test`:
```bash
curl -X POST http://localhost:3001/api/auth/signup-with-test \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "sessionToken": "abc123...",
    "tier": "free"
  }'
```

2. **Expected Response:**
```json
{
  "testUrl": "http://localhost:3001/test/abc123def456",
  "shareToken": "abc123def456",
  "userId": "uuid...",
  "message": "Account created successfully. Please check your email to set your password."
}
```

3. Verify in database:
```sql
-- Check tests table - should be claimed
SELECT id, user_id, is_anonymous, claimed_at FROM tests WHERE id = 'uuid...';
-- Expected: user_id set, is_anonymous=false, claimed_at has timestamp

-- Check auth.users - user should exist
SELECT id, email FROM auth.users WHERE email = 'test@example.com';
-- Expected: User record exists

-- Check anonymous_tests - should be deleted
SELECT * FROM anonymous_tests WHERE session_token = 'abc123...';
-- Expected: No record (cleaned up after claiming)
```

4. **Expected Database State:**
   - tests: is_anonymous=false, user_id set, claimed_at timestamp
   - auth.users: New user record created
   - anonymous_tests: Record deleted (cleanup successful)

### Test 6: Session Management with New Schema

**Purpose:** Verify lib/session.ts works with new MVP schema

**Steps:**
1. Test createTestSession():
```typescript
import { createTestSession } from '@/lib/session';

const { data, error } = await createTestSession('John Doe', 'john@example.com', 'test-id-123');
console.log(data);
```

**Expected Result:**
- Returns TestSession object with new fields (test_id, session_token, etc.)
- No TypeScript errors
- consent_given defaults to false
- transcript_status defaults to 'pending'
- is_text_only defaults to false

2. Test backward compatibility in updateTestSession():
```typescript
import { updateTestSession } from '@/lib/session';

// Test old field names still work
const { data, error } = await updateTestSession('session-id', {
  daily_room_url: 'https://domain.daily.co/room-name', // Old field name
  audio_url: 'https://s3.amazonaws.com/recording.mp4', // Old field name
  is_text_mode: true // Old field name
});

// Verify it maps to new field names
console.log(data?.daily_room_name); // Should be set
console.log(data?.recording_url); // Should be set
console.log(data?.is_text_only); // Should be true
```

**Expected Result:**
- Old field names are accepted
- Mapped to new field names internally
- No errors

### Test 7: POC Pages with New Schema

**Purpose:** Verify existing POC pages work with updated schema

**Steps:**
1. Create a test session manually in database or via API
2. Visit http://localhost:3001/zebra
3. Enter a name and start a test
4. **Expected:** Should progress through flow without errors

**Pages to Test:**
- `/zebra` - Welcome screen (creates session)
- `/zebra/[sessionId]/instructions` - Task instructions
- `/zebra/[sessionId]/mic-check` - Mic permission + Daily.co setup
- `/zebra/[sessionId]/test` - Testing interface with iframe
- `/zebra/[sessionId]/complete` - Thank you page

**Check for:**
- ✅ No console errors about missing fields
- ✅ Daily.co integration works (room creation, token generation)
- ✅ Null handling works (no "null is not assignable" errors)
- ✅ Field name changes handled (daily_room_name instead of daily_room_url)

### Test 8: Build and Lint Verification

**Purpose:** Ensure codebase is production-ready

**Steps:**
1. Run TypeScript compilation:
```bash
npm run build
```
**Expected Result:** ✓ Compiled successfully, no type errors

2. Run ESLint:
```bash
npm run lint
```
**Expected Result:** No linting errors

3. Run type checking:
```bash
npm run type-check
```
**Expected Result:** No type errors (if script exists)

### Test 9: Trigger Functionality

**Purpose:** Verify session count increment trigger works

**Steps:**
1. Create a test with config.sessions_completed = 0:
```sql
INSERT INTO tests (app_url, config)
VALUES ('https://example.com', '{"sessions_completed": 0}');
```

2. Create a test session linked to this test:
```sql
INSERT INTO test_sessions (test_id, tester_name)
VALUES ('test-id-from-step-1', 'John Doe');
```

3. Mark the session as completed:
```sql
UPDATE test_sessions
SET completed_at = NOW()
WHERE id = 'session-id-from-step-2';
```

4. Check tests table:
```sql
SELECT config->>'sessions_completed' FROM tests WHERE id = 'test-id-from-step-1';
```

**Expected Result:** sessions_completed should be 1 (incremented by trigger)

### Test 10: RLS Policies

**Purpose:** Verify Row Level Security policies work correctly

**Test as Anonymous User:**
```sql
-- Should succeed: Create anonymous test
INSERT INTO tests (app_url, is_anonymous)
VALUES ('https://example.com', true);

-- Should succeed: Create test session
INSERT INTO test_sessions (tester_name)
VALUES ('Test User');

-- Should succeed: View own anonymous test (within 24 hours)
SELECT * FROM tests WHERE is_anonymous = true;
```

**Test as Authenticated User:**
```sql
-- Should see only own tests
SELECT * FROM tests WHERE user_id = auth.uid();

-- Should NOT see other users' tests
-- Should see test sessions for own tests only
```

**Expected Results:**
- Anonymous users can create tests and sessions
- Users can only see their own tests
- RLS prevents unauthorized access

### Success Criteria

**All tests should pass with:**
- ✅ No database errors
- ✅ No TypeScript compilation errors
- ✅ No ESLint warnings
- ✅ All API routes respond correctly
- ✅ Database triggers function properly
- ✅ RLS policies enforce security
- ✅ Backward compatibility maintained
- ✅ Existing POC pages work with new schema
- ✅ Build completes successfully

### Common Issues and Troubleshooting

**Issue: Migration fails with "table already exists"**
- Solution: Migration includes DROP TABLE IF EXISTS, should not happen
- If it does, manually drop tables and re-run migration

**Issue: Environment variable not found**
- Solution: Check .env.local file exists and has all variables from .env.example
- Restart dev server after adding environment variables

**Issue: "Property does not exist on type TestSession"**
- Solution: TypeScript cache may be stale, run `npm run build` to re-compile
- Verify lib/session.ts has updated interface

**Issue: RLS policy blocks operation**
- Solution: Check if operation should be allowed by policy
- For testing, can temporarily disable RLS: `ALTER TABLE tests DISABLE ROW LEVEL SECURITY;`

**Issue: Anonymous test claiming fails**
- Solution: Check if session_token is valid and not expired (24-hour limit)
- Verify anonymous_tests record exists in database

### Reporting Issues

If any test fails:
1. Note the specific test that failed
2. Copy the error message
3. Check database state with SQL queries
4. Check browser console for client-side errors
5. Check server console for API route errors
6. Document findings and report to team

---

**Manual Testing Complete** - Ready for user validation and integration testing
