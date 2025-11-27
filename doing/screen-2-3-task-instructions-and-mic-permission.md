# Screen 2 & 3: Task Instructions and Mic Permission with Daily.co

## Original Request

**From user instruction:**
"@design-1-planning.md for implementing ### Screen 2: Task Instructions and ### Screen 3: Mic Permission & Test (with Daily.co) on @poc-build-plan-integrated.md. Make sure no context is lost from @poc-build-plan-integrated.md when creating the task. We're going to do screen 2 and 3 together as one task."

**Complete context from poc-build-plan-integrated.md (PRESERVED VERBATIM):**

### Current Project Status (Lines 3-18)
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

### Build Philosophy (Lines 21-26)
- **Build each screen as a complete feature**: Full integration before moving to next screen
- **Test visually at each step**: Ensure everything works before proceeding
- **No auth for POC testers**: While auth exists, POC testers won't need accounts
- **Incremental integration**: Add services as needed per screen

### Screen 1 Implementation Status (Lines 156-182)
> **📍 IMPLEMENTATION STATUS (Updated: October 27, 2025 - 8:15 PM PST)**
>
> **Screen 1: COMPLETE ✅**
> - All files created and tested successfully
> - Form validation working
> - Supabase session creation verified
> - Navigation to `/zebra/[sessionId]/instructions` functional (404 expected until Screen 2 built)
>
> **Files Created:**
> - `/lib/session.ts` - Session management utilities (createTestSession, getTestSession)
> - `/components/test-flow/pre-test-survey.tsx` - Survey form component with validation
> - `/app/zebra/page.tsx` - Landing page route
> - `/app/zebra/[sessionId]/layout.tsx` - Session layout for dynamic routes
>
> **Infrastructure Changes:**
> - **Auth Bypass Added**: `/lib/supabase/middleware.ts` lines 6-15 bypass auth for `/zebra` routes
>   - ⚠️ Remove this exception after POC to re-enable authentication
> - Development server running on port 3001
> - Database schema created via migration `20251027165723_create_test_sessions_table.sql`
>
> **Ready for Screen 2:** Instructions page implementation
> - Session ID available in URL from Screen 1 navigation
> - `getTestSession()` utility ready to validate session exists
> - Need to create `/app/zebra/[sessionId]/instructions/page.tsx`

### Screen 2: Task Instructions (Lines 156-228)

#### Step 2.1: Dynamic Routing Setup
```bash
mkdir -p app/zebra/[sessionId]/instructions
touch app/zebra/[sessionId]/instructions/page.tsx
```

#### Step 2.2: Build Instructions Screen
Create `/components/test-flow/task-instructions.tsx`:
```typescript
// Full implementation with:
- Task list display (review zebradesign.io)
- Emphasis on "think aloud" requirement
- Time estimate
- Progress indicator (Step 2 of 5)
```

Create `/app/zebra/[sessionId]/instructions/page.tsx`:
```typescript
// Instructions page that:
- Validates session exists
- Shows task instructions
- Routes to mic check
```

#### Step 2.3: Progress Indicator Component
Create `/components/test-flow/progress-indicator.tsx`:
```typescript
// Reusable progress bar
- Shows current step
- Visual progress
- Used across all screens
```

**Integration Points**:
- ✅ Validates session ID from URL
- ✅ Updates session status in Supabase
- ✅ Routes to `/zebra/[sessionId]/mic-check`

**Visual Testing Before Moving On**:
- [ ] Instructions display clearly
- [ ] Session validation works
- [ ] Navigation maintains session ID
- [ ] Progress indicator shows correctly

### Screen 3: Mic Permission & Test (with Daily.co) (Lines 230-311)

#### Step 3.1: Daily.co Integration Setup
Create `/lib/daily.ts`:
```typescript
import DailyIframe from '@daily-co/daily-js';

export async function createDailyRoom(sessionId: string) {
  // Call API to create room
  const response = await fetch('/api/daily/room', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ sessionId })
  });
  return response.json();
}

export function initializeDaily(roomUrl: string) {
  return DailyIframe.createCallObject({
    url: roomUrl,
    audioSource: true,
    videoSource: false
  });
}
```

#### Step 3.2: Daily API Route
Create `/app/api/daily/room/route.ts`:
```typescript
export async function POST(request: Request) {
  // Create Daily room with audio-only config
  // Use DAILY_API_KEY from env
  // Return room URL

  const config = {
    properties: {
      enable_chat: false,
      enable_screenshare: false,
      enable_video: false,
      start_audio_off: false,
      start_video_off: true,
    }
  };

  // Create room via Daily API
  // Return { roomUrl }
}
```

#### Step 3.3: Build Mic Permission Screen
Create `/components/test-flow/mic-permission.tsx`:
```typescript
// Full implementation with:
- Daily.co pre-call UI
- Audio level visualization
- Test recording capability
- "I can hear myself" confirmation
```

Create `/app/zebra/[sessionId]/mic-check/page.tsx`:
```typescript
// Mic check page that:
- Creates Daily room
- Shows mic permission UI
- Updates session with room URL
- Routes to test when ready
```

**Integration Points**:
- ✅ Creates Daily.co room via API
- ✅ Updates session with room URL
- ✅ Confirms mic works before proceeding
- ✅ Routes to `/zebra/[sessionId]/test`

**Visual Testing Before Moving On**:
- [ ] Daily room created successfully
- [ ] Mic permission flow works
- [ ] Audio levels show correctly
- [ ] Can hear test recording
- [ ] Error states handled

### Phase 1: Foundation Setup - Environment Variables (Lines 43-52)
Add to `.env.local`:
```env
# Existing Supabase vars already configured ✅

# New additions needed:
DAILY_API_KEY=your_daily_api_key
OPENAI_API_KEY=your_openai_api_key
NEXT_PUBLIC_APP_URL=http://localhost:3001
```

### Database Schema Context (Lines 56-75)
```sql
-- Ultra-minimal POC test sessions table
CREATE TABLE IF NOT EXISTS test_sessions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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

### State Management Strategy (Lines 487-491)
- **URL-based**: Session ID in URL for shareability
- **Database-driven**: Supabase as source of truth
- **Minimal client state**: Only temporary UI state
- **No complex state libraries**: Keep it simple for POC

### What We're NOT Building (POC Scope) (Lines 520-530)
❌ User accounts for testers
❌ Payment processing
❌ Admin dashboard
❌ Multiple test management
❌ Real-time transcription display
❌ Analytics or reporting
❌ Email notifications
❌ Custom branding
❌ Test templates

## Design Context

**No Figma designs provided** - This is a functional POC focused on user testing flow.

**UI Requirements**:
- Clean, simple interface using existing shadcn/ui components
- Progress indicators to show user journey
- Clear task instructions
- Professional mic check interface with audio visualization
- Error states with helpful messaging

**Design System**:
- Use existing shadcn/ui components (Button, Card, Input, Badge)
- Follow Tailwind CSS patterns established in project
- Maintain consistency with Screen 1 (pre-test-survey.tsx)

## Codebase Context

### Existing Files to Reference

**Session Management** (Lines 98-118):
- `/lib/session.ts` - Already contains `createTestSession()` and `getTestSession()`
- Need to add: `updateTestSession()` function for storing Daily room URL

**Existing Components**:
- `/components/ui/button.tsx` - shadcn Button component
- `/components/ui/card.tsx` - shadcn Card component
- `/components/ui/input.tsx` - shadcn Input component
- `/components/ui/badge.tsx` - shadcn Badge component
- `/components/test-flow/pre-test-survey.tsx` - Example of test flow component structure

**Routing Structure**:
- `/app/zebra/page.tsx` - Landing page with survey
- `/app/zebra/[sessionId]/layout.tsx` - Layout for session-based routes
- Navigation flow: `/zebra` → `/zebra/[sessionId]/instructions` → `/zebra/[sessionId]/mic-check` → `/zebra/[sessionId]/test`

**Supabase Integration**:
- `/lib/supabase/client.ts` - Supabase client utilities
- `/lib/supabase/middleware.ts` - Auth bypass already configured for `/zebra` routes (lines 6-15)
- Database table: `test_sessions` with columns: `id`, `tester_name`, `tester_email`, `daily_room_url`, `started_at`, `completed_at`

**Environment Variables**:
- Supabase: Already configured ✅
- Daily.co: Need to add `DAILY_API_KEY`
- OpenAI: Need to add `OPENAI_API_KEY` (for later screens)
- App URL: Need to add `NEXT_PUBLIC_APP_URL`

### Dependencies Already Installed
- Next.js 14+ with App Router
- TypeScript
- Tailwind CSS
- Supabase client
- shadcn/ui components

### Dependencies to Install
```bash
npm install @daily-co/daily-js
```

## Prototype Scope

**Frontend Focus**: Complete screen implementations with full integration
**Component Reuse**: Leverage existing shadcn/ui components
**Real Backend Integration**: Using Supabase and Daily.co APIs
**Mock Data**: None needed - real session data flows through system
**Testing Approach**: Visual testing at each step before proceeding

## Plan

### Step 1: Environment Setup and Dependencies

**File**: `.env.local`
**Action**: Add Daily.co API key
```env
DAILY_API_KEY=<your-daily-api-key-here>
NEXT_PUBLIC_APP_URL=http://localhost:3001
```

**Terminal Commands**:
```bash
npm install @daily-co/daily-js
```

**Verification**:
- [ ] Daily.co package installed successfully
- [ ] Environment variable added to .env.local (not committed to git)

---

### Step 2: Update Session Management Utilities

**File**: `/lib/session.ts`
**Action**: Add function to update session with Daily room URL

**Current Implementation** (Lines 98-118 from poc-build-plan-integrated.md):
```typescript
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

**Add to file**:
```typescript
export async function updateTestSession(
  id: string, 
  updates: { daily_room_url?: string; completed_at?: string }
) {
  const { data, error } = await supabase
    .from('test_sessions')
    .update(updates)
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw error;
  return data;
}
```

**Preserve**: Existing functions and imports
**Imports needed**: Already has supabase client imported

---

### Step 3: Create Progress Indicator Component

**File**: `/components/test-flow/progress-indicator.tsx`
**Action**: Create new reusable progress component

**Implementation**:
```typescript
'use client';

interface ProgressIndicatorProps {
  currentStep: number;
  totalSteps: number;
  stepLabel?: string;
}

export function ProgressIndicator({ 
  currentStep, 
  totalSteps, 
  stepLabel 
}: ProgressIndicatorProps) {
  const percentage = (currentStep / totalSteps) * 100;
  
  return (
    <div className="w-full space-y-2">
      <div className="flex justify-between text-sm text-muted-foreground">
        <span>{stepLabel || `Step ${currentStep} of ${totalSteps}`}</span>
        <span>{Math.round(percentage)}%</span>
      </div>
      <div className="h-2 bg-secondary rounded-full overflow-hidden">
        <div 
          className="h-full bg-primary transition-all duration-300"
          style={{ width: `${percentage}%` }}
        />
      </div>
    </div>
  );
}
```

**Styling**: Uses Tailwind semantic tokens (bg-primary, text-muted-foreground, bg-secondary)
**Component Pattern**: Follows existing shadcn/ui patterns

---

### Step 4: Create Task Instructions Component

**File**: `/components/test-flow/task-instructions.tsx`
**Action**: Create instructions display component

**Implementation**:
```typescript
'use client';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { useRouter } from 'next/navigation';

interface TaskInstructionsProps {
  sessionId: string;
}

export function TaskInstructions({ sessionId }: TaskInstructionsProps) {
  const router = useRouter();

  const handleContinue = () => {
    router.push(`/zebra/${sessionId}/mic-check`);
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <Card className="max-w-2xl w-full">
        <CardHeader>
          <div className="flex items-center justify-between mb-4">
            <Badge variant="outline">Step 2 of 5</Badge>
            <span className="text-sm text-muted-foreground">~5-10 minutes</span>
          </div>
          <CardTitle className="text-2xl">Your Testing Task</CardTitle>
        </CardHeader>
        
        <CardContent className="space-y-6">
          <div>
            <h3 className="font-semibold mb-2">What you'll do:</h3>
            <p className="text-muted-foreground">
              You'll be visiting <strong>zebradesign.io</strong> and exploring the website 
              while speaking your thoughts out loud.
            </p>
          </div>

          <div>
            <h3 className="font-semibold mb-2">Important: Think Aloud</h3>
            <p className="text-muted-foreground">
              Please <strong>narrate your thoughts continuously</strong> as you navigate. 
              Tell us what you're looking at, what you're thinking, what confuses you, 
              and what you find interesting.
            </p>
          </div>

          <div>
            <h3 className="font-semibold mb-2">Your goals:</h3>
            <ul className="list-disc list-inside space-y-1 text-muted-foreground">
              <li>Understand what Zebra Design offers</li>
              <li>Explore the main sections of the website</li>
              <li>Share your first impressions and any questions</li>
              <li>Identify anything confusing or unclear</li>
            </ul>
          </div>

          <div className="bg-muted p-4 rounded-lg">
            <p className="text-sm">
              💡 <strong>Tip:</strong> There are no wrong answers! We want to hear your 
              honest reactions and thoughts, even if they're negative.
            </p>
          </div>
        </CardContent>

        <CardFooter>
          <Button onClick={handleContinue} size="lg" className="w-full">
            Continue to Mic Check
          </Button>
        </CardFooter>
      </Card>
    </div>
  );
}
```

**Component Reuse**: Uses existing shadcn/ui Card, Button, Badge components
**Styling**: Follows semantic Tailwind patterns
**Navigation**: Routes to mic-check on continue

---

### Step 5: Create Task Instructions Page Route

**File**: `/app/zebra/[sessionId]/instructions/page.tsx`
**Action**: Create page that validates session and shows instructions

**Directory structure needed**:
```bash
mkdir -p app/zebra/[sessionId]/instructions
```

**Implementation**:
```typescript
import { redirect } from 'next/navigation';
import { getTestSession } from '@/lib/session';
import { TaskInstructions } from '@/components/test-flow/task-instructions';
import { ProgressIndicator } from '@/components/test-flow/progress-indicator';

export default async function InstructionsPage({
  params,
}: {
  params: { sessionId: string };
}) {
  // Validate session exists
  const session = await getTestSession(params.sessionId);
  
  if (!session) {
    redirect('/zebra');
  }

  return (
    <div className="container mx-auto py-8">
      <div className="max-w-2xl mx-auto mb-8">
        <ProgressIndicator currentStep={2} totalSteps={5} />
      </div>
      <TaskInstructions sessionId={params.sessionId} />
    </div>
  );
}
```

**Server Component**: Uses Next.js App Router server component for data fetching
**Session Validation**: Redirects to start if session doesn't exist
**Layout**: Uses existing `/app/zebra/[sessionId]/layout.tsx`

---

### Step 6: Create Daily.co Integration Library

**File**: `/lib/daily.ts`
**Action**: Create new Daily.co utility functions

**Implementation**:
```typescript
import DailyIframe from '@daily-co/daily-js';

export async function createDailyRoom(sessionId: string) {
  const response = await fetch('/api/daily/room', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ sessionId }),
  });

  if (!response.ok) {
    throw new Error('Failed to create Daily room');
  }

  return response.json();
}

export function initializeDaily(roomUrl: string) {
  return DailyIframe.createCallObject({
    url: roomUrl,
    audioSource: true,
    videoSource: false,
  });
}

export function getDailyAudioLevel(callObject: any): number {
  try {
    const stats = callObject.getInputAudioLevel();
    return stats || 0;
  } catch (error) {
    console.error('Error getting audio level:', error);
    return 0;
  }
}
```

**New file**: Creates utility functions for Daily integration
**Error handling**: Includes basic error handling for API calls
**Audio monitoring**: Provides function to get audio levels for visualization

---

### Step 7: Create Daily.co API Route

**File**: `/app/api/daily/room/route.ts`
**Action**: Create API endpoint to create Daily rooms

**Directory structure needed**:
```bash
mkdir -p app/api/daily/room
```

**Implementation**:
```typescript
import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  try {
    const { sessionId } = await request.json();

    if (!sessionId) {
      return NextResponse.json(
        { error: 'Session ID is required' },
        { status: 400 }
      );
    }

    const dailyApiKey = process.env.DAILY_API_KEY;
    if (!dailyApiKey) {
      return NextResponse.json(
        { error: 'Daily API key not configured' },
        { status: 500 }
      );
    }

    // Create Daily room with audio-only configuration
    const response = await fetch('https://api.daily.co/v1/rooms', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${dailyApiKey}`,
      },
      body: JSON.stringify({
        name: `test-${sessionId}`,
        privacy: 'private',
        properties: {
          enable_chat: false,
          enable_screenshare: false,
          enable_recording: 'cloud',
          start_audio_off: false,
          start_video_off: true,
          max_participants: 1,
        },
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      console.error('Daily API error:', error);
      return NextResponse.json(
        { error: 'Failed to create Daily room' },
        { status: response.status }
      );
    }

    const data = await response.json();

    return NextResponse.json({
      roomUrl: data.url,
      roomName: data.name,
    });

  } catch (error) {
    console.error('Error creating Daily room:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

**API Integration**: Calls Daily.co API to create rooms
**Configuration**: Audio-only, recording enabled, single participant
**Error Handling**: Comprehensive error handling with logging
**Security**: Uses environment variable for API key

---

### Step 8: Create Mic Permission Component

**File**: `/components/test-flow/mic-permission.tsx`
**Action**: Create mic check interface with audio visualization

**Implementation**:
```typescript
'use client';

import { useState, useEffect, useRef } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { useRouter } from 'next/navigation';
import { initializeDaily, getDailyAudioLevel } from '@/lib/daily';

interface MicPermissionProps {
  sessionId: string;
  roomUrl: string;
}

export function MicPermission({ sessionId, roomUrl }: MicPermissionProps) {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [audioLevel, setAudioLevel] = useState(0);
  const [canContinue, setCanContinue] = useState(false);
  const callObjectRef = useRef<any>(null);

  useEffect(() => {
    let mounted = true;
    let levelInterval: NodeJS.Timeout;

    async function setupDaily() {
      try {
        // Initialize Daily call object
        const callObject = initializeDaily(roomUrl);
        callObjectRef.current = callObject;

        // Join the room
        await callObject.join();

        if (!mounted) {
          callObject.destroy();
          return;
        }

        setIsLoading(false);

        // Monitor audio levels
        levelInterval = setInterval(() => {
          if (callObjectRef.current) {
            const level = getDailyAudioLevel(callObjectRef.current);
            setAudioLevel(level);
            
            // If audio detected, enable continue button
            if (level > 0.1 && !canContinue) {
              setCanContinue(true);
            }
          }
        }, 100);

      } catch (err) {
        console.error('Error setting up Daily:', err);
        if (mounted) {
          setError('Failed to initialize microphone. Please check your browser permissions.');
          setIsLoading(false);
        }
      }
    }

    setupDaily();

    return () => {
      mounted = false;
      if (levelInterval) clearInterval(levelInterval);
      if (callObjectRef.current) {
        callObjectRef.current.destroy();
      }
    };
  }, [roomUrl, canContinue]);

  const handleContinue = () => {
    // Leave the call but don't destroy - we'll rejoin in the test screen
    if (callObjectRef.current) {
      callObjectRef.current.leave();
    }
    router.push(`/zebra/${sessionId}/test`);
  };

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <Card className="max-w-md w-full">
          <CardContent className="pt-6">
            <div className="text-center space-y-4">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto" />
              <p className="text-muted-foreground">Connecting to audio system...</p>
            </div>
          </CardContent>
        </Card>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <Card className="max-w-md w-full">
          <CardHeader>
            <CardTitle className="text-destructive">Microphone Error</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">{error}</p>
          </CardContent>
          <CardFooter>
            <Button onClick={() => window.location.reload()} className="w-full">
              Try Again
            </Button>
          </CardFooter>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <Card className="max-w-md w-full">
        <CardHeader>
          <div className="flex items-center justify-between mb-4">
            <Badge variant="outline">Step 3 of 5</Badge>
          </div>
          <CardTitle className="text-2xl">Microphone Check</CardTitle>
        </CardHeader>
        
        <CardContent className="space-y-6">
          <p className="text-muted-foreground">
            Please speak into your microphone to test the audio.
          </p>

          {/* Audio Level Visualization */}
          <div className="space-y-2">
            <label className="text-sm font-medium">Audio Level</label>
            <div className="h-4 bg-secondary rounded-full overflow-hidden">
              <div 
                className={`h-full transition-all duration-100 ${
                  audioLevel > 0.1 ? 'bg-green-500' : 'bg-muted-foreground'
                }`}
                style={{ width: `${Math.min(audioLevel * 100, 100)}%` }}
              />
            </div>
          </div>

          {canContinue ? (
            <div className="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 p-4 rounded-lg">
              <p className="text-sm text-green-800 dark:text-green-200">
                ✓ Microphone is working! You can continue.
              </p>
            </div>
          ) : (
            <div className="bg-muted p-4 rounded-lg">
              <p className="text-sm">
                💡 <strong>Tip:</strong> Say something like "testing 1, 2, 3" to test your microphone.
              </p>
            </div>
          )}
        </CardContent>

        <CardFooter>
          <Button 
            onClick={handleContinue} 
            size="lg" 
            className="w-full"
            disabled={!canContinue}
          >
            {canContinue ? 'Start Test' : 'Waiting for audio...'}
          </Button>
        </CardFooter>
      </Card>
    </div>
  );
}
```

**Daily.co Integration**: Initializes Daily call object and monitors audio
**Audio Visualization**: Real-time audio level meter
**UX Flow**: Only enables continue button after audio detected
**Error Handling**: Graceful error states with retry option
**Component Reuse**: Uses existing shadcn/ui components
**Cleanup**: Proper useEffect cleanup to destroy Daily object

---

### Step 9: Create Mic Check Page Route

**File**: `/app/zebra/[sessionId]/mic-check/page.tsx`
**Action**: Create page that sets up Daily room and shows mic check

**Directory structure needed**:
```bash
mkdir -p app/zebra/[sessionId]/mic-check
```

**Implementation**:
```typescript
import { redirect } from 'next/navigation';
import { getTestSession, updateTestSession } from '@/lib/session';
import { MicPermission } from '@/components/test-flow/mic-permission';
import { ProgressIndicator } from '@/components/test-flow/progress-indicator';
import { createDailyRoom } from '@/lib/daily';

export default async function MicCheckPage({
  params,
}: {
  params: { sessionId: string };
}) {
  // Validate session exists
  const session = await getTestSession(params.sessionId);
  
  if (!session) {
    redirect('/zebra');
  }

  // Create Daily room if not already created
  let roomUrl = session.daily_room_url;
  
  if (!roomUrl) {
    try {
      const roomData = await createDailyRoom(params.sessionId);
      roomUrl = roomData.roomUrl;
      
      // Update session with room URL
      await updateTestSession(params.sessionId, {
        daily_room_url: roomUrl,
      });
    } catch (error) {
      console.error('Failed to create Daily room:', error);
      // TODO: Better error handling - maybe redirect to error page
      throw error;
    }
  }

  return (
    <div className="container mx-auto py-8">
      <div className="max-w-2xl mx-auto mb-8">
        <ProgressIndicator currentStep={3} totalSteps={5} />
      </div>
      <MicPermission sessionId={params.sessionId} roomUrl={roomUrl} />
    </div>
  );
}
```

**Server Component**: Creates Daily room server-side
**Session Update**: Stores Daily room URL in database
**Error Handling**: Basic error handling (can be enhanced)
**Room Reuse**: Checks if room already created before making new one

---

### Step 10: Visual Testing Checklist

**Screen 2 Testing**:
- [ ] Navigate to `/zebra` and complete survey
- [ ] Verify redirect to `/zebra/[sessionId]/instructions`
- [ ] Instructions display clearly with proper formatting
- [ ] Progress indicator shows "Step 2 of 5" correctly
- [ ] Time estimate displays (~5-10 minutes)
- [ ] Task list is readable and well-formatted
- [ ] "Think aloud" emphasis is clear
- [ ] Continue button routes to `/zebra/[sessionId]/mic-check`
- [ ] Session ID maintained in URL throughout navigation
- [ ] Mobile responsive (test on narrow viewport)

**Screen 3 Testing**:
- [ ] Loading state displays while connecting to Daily
- [ ] Daily room created successfully (check Supabase for `daily_room_url`)
- [ ] Microphone permission prompt appears
- [ ] After granting permission, audio level meter appears
- [ ] Speaking causes audio level meter to move
- [ ] Continue button disabled until audio detected
- [ ] Continue button enables after audio detected
- [ ] Success message displays when mic working
- [ ] Continue button routes to `/zebra/[sessionId]/test` (404 expected - Screen 4 not built yet)
- [ ] Error state displays if mic permission denied
- [ ] Retry button works in error state
- [ ] Mobile responsive mic check interface

**Integration Testing**:
- [ ] Session persists across screen transitions
- [ ] Back button doesn't break flow
- [ ] Refresh on instructions page maintains state
- [ ] Refresh on mic check page reuses existing Daily room
- [ ] Database updates correctly (daily_room_url saved)

**Error Cases to Test**:
- [ ] Invalid session ID redirects to start
- [ ] Missing DAILY_API_KEY shows proper error
- [ ] Daily API failure shows error message
- [ ] Browser denies mic permission shows error

---

## Stage
Ready for Manual Testing

## Review Notes

### Requirements Coverage
✓ All functional requirements addressed
✓ Screen 2: Task Instructions fully specified with components and routing
✓ Screen 3: Mic Permission & Test complete with Daily.co integration
✓ Session management updates included
✓ Progress indicators implemented
✓ Navigation flow maintains session ID throughout

### Technical Validation
✓ All file paths verified - existing components found at expected locations
✓ Import statements use consistent @/ alias pattern matching existing code
✓ Tailwind classes are valid and follow semantic patterns
✓ TypeScript interfaces properly defined
✓ Component reuse patterns follow existing pre-test-survey.tsx structure
✓ Server/client component split appropriate for Next.js App Router

### Daily.co Integration Assessment
- API route implementation is sound
- Room configuration appropriate for audio-only testing
- Client-side integration follows Daily.co best practices
- Audio level monitoring provides good UX feedback
- Error handling covers main failure scenarios

### Risk Assessment
- **Low risk**: CSS-only UI components using existing patterns
- **Medium risk**: Daily.co integration requires API key setup
- **Medium risk**: Audio permission flow depends on browser support
- **Mitigation**: Comprehensive error states included

### Enhancements Added During Review
1. **Error handling refinements**: Added specific error messages for different failure modes
2. **TypeScript safety**: Proper return types for async functions
3. **Session validation**: Server-side validation before rendering pages
4. **Audio threshold clarification**: 0.1 threshold for audio detection needs testing

### Critical Validation Question
**"Is there anything you need to know to be 100% confident to execute this plan?"**

**Answer**: The plan is technically sound and comprehensive, but there are 8 clarification points that would increase confidence:
1. Daily.co API key acquisition process needs documentation
2. Audio detection threshold may need tuning
3. Room cleanup strategy for production
4. Browser compatibility warnings
5. Error recovery approaches for better UX
6. Session status tracking for debugging
7. Audio test recording expectations
8. Daily room lifecycle management

**With the default approaches recommended in the clarification section, the plan can be executed successfully.** The main critical dependency is obtaining a Daily.co API key, which requires the user to:
1. Visit https://dashboard.daily.co
2. Create a free account
3. Generate an API key
4. Add it to `.env.local`

## Questions for Clarification

[RESOLVED - User Decisions]:
1. **Daily.co API Key Setup**: ✅ COMPLETED - API key obtained and added to `.env.local`

2. **Audio Detection Threshold**: ✅ DECISION: Use 0.05 for better sensitivity
   - Update line 741 in mic-permission.tsx: `if (level > 0.05 && !canContinue)`

3. **Session Status Tracking**: ✅ DECISION: Add status enum (may remove for POC later)
   - Add to database schema: `status TEXT DEFAULT 'survey_completed'`
   - Status values: 'survey_completed', 'instructions_viewed', 'mic_checked', 'testing', 'completed'

4. **Error Recovery Approach**: ✅ DECISION: Use inline error states with retry buttons
   - Already implemented in the plan

5. **Audio Test Recording**: ✅ DECISION: Visual audio levels only (no recording test)
   - Already implemented in the plan

6. **Room Cleanup Strategy**: ✅ DECISION: Keep rooms for debugging in POC
   - No cleanup needed for POC

7. **Browser Compatibility**: ✅ DECISION: Add browser compatibility check
   - **Supported Browsers**: Chrome 74+, Firefox 78+, Safari 12.1+, Edge 79+
   - **NOT Supported**:
     - Internet Explorer (all versions)
     - Opera Mini
     - UC Browser
     - Samsung Internet < 13.0
     - Chrome < 74, Firefox < 78, Safari < 12.1, Edge < 79
   - Add browser detection in mic-permission.tsx with warning message

8. **Daily Room Lifecycle**: ✅ DECISION: Create once per session, reuse on refresh
   - Already implemented in the plan

### Browser Compatibility Implementation
Add to mic-permission.tsx before Daily initialization:
```typescript
// Simple browser compatibility check
const isSupported = () => {
  const ua = navigator.userAgent;
  // Check for IE
  if (ua.includes('MSIE') || ua.includes('Trident')) return false;
  // Check for Opera Mini
  if (ua.includes('Opera Mini')) return false;
  // Basic modern browser check
  return 'mediaDevices' in navigator && 'getUserMedia' in navigator.mediaDevices;
};

if (!isSupported()) {
  setError('Your browser is not supported. Please use Chrome, Firefox, Safari, or Edge (latest versions).');
  setIsLoading(false);
  return;
}
```

## Priority
High - Required for POC flow to proceed to Screen 4 (Main Testing Interface)

## Created
October 27, 2025 - 8:30 PM PST

## Files

### Files to Create
- `/app/zebra/[sessionId]/instructions/page.tsx` - Instructions page route
- `/components/test-flow/task-instructions.tsx` - Instructions component
- `/components/test-flow/progress-indicator.tsx` - Progress bar component
- `/app/zebra/[sessionId]/mic-check/page.tsx` - Mic check page route
- `/components/test-flow/mic-permission.tsx` - Mic check component
- `/lib/daily.ts` - Daily.co integration utilities
- `/app/api/daily/room/route.ts` - API route for Daily room creation

### Files to Modify
- `/lib/session.ts` - Add `updateTestSession()` function
- `.env.local` - Add `DAILY_API_KEY` and `NEXT_PUBLIC_APP_URL`

### Files to Reference (No Changes)
- `/components/ui/button.tsx` - Button component
- `/components/ui/card.tsx` - Card component
- `/components/ui/badge.tsx` - Badge component
- `/lib/supabase/client.ts` - Supabase utilities
- `/app/zebra/[sessionId]/layout.tsx` - Session layout
- `/components/test-flow/pre-test-survey.tsx` - Example component structure

## Technical Dependencies
- `@daily-co/daily-js` package (install via npm)
- Daily.co API key in environment variables
- Supabase database with `test_sessions` table
- Browser microphone permission

## Success Criteria
- [ ] User can navigate from survey → instructions → mic check
- [ ] Instructions clearly explain task and "think aloud" requirement
- [ ] Progress indicator shows current step accurately
- [ ] Daily room created and stored in database
- [ ] Microphone permission flow works smoothly
- [ ] Audio level visualization responds to user voice
- [ ] Continue button only enabled after audio detected
- [ ] Error states handled gracefully
- [ ] Mobile responsive on all screens
- [ ] Session ID maintained throughout flow

---

## Technical Discovery

**Discovery Agent**: Agent 3
**Discovery Date**: October 27, 2025
**Discovery Duration**: ~8 minutes

### Component Identification Verification

- **Target Pages**: 
  - Screen 2: `/zebra/[sessionId]/instructions`
  - Screen 3: `/zebra/[sessionId]/mic-check`
- **Planned Components**:
  - `progress-indicator.tsx` - Reusable progress bar
  - `task-instructions.tsx` - Instructions display component
  - `mic-permission.tsx` - Mic check interface with audio visualization
- **Verification Steps**:
  - [x] Traced from page files to component rendering flow
  - [x] Confirmed component structure follows existing pattern from `pre-test-survey.tsx`
  - [x] Verified no similar-named components exist that could cause confusion
  - [x] Validated session prop flow from URL params to components

**Rendering Path**:
- Screen 2: `/zebra/[sessionId]/instructions/page.tsx` → `TaskInstructions` component → `ProgressIndicator` component
- Screen 3: `/zebra/[sessionId]/mic-check/page.tsx` → `MicPermission` component → `ProgressIndicator` component

### MCP Research Results

#### 1. Dependencies Verification

**@daily-co/daily-js Package**:
- **Status**: ✅ **ALREADY INSTALLED**
- **Version**: 0.85.0 (confirmed in `package.json` line 12)
- **Installation**: No action needed - package already present
- **Import Path**: `import DailyIframe from '@daily-co/daily-js'`
- **Bundle Size**: ~150KB (reasonable for audio functionality)

**Key API Methods Available** (v0.85.0):
```typescript
// Call object creation
DailyIframe.createCallObject(options)

// Core methods
callObject.join(options)
callObject.leave()
callObject.destroy()

// Audio monitoring (for visualization)
callObject.getInputAudioLevel() // Returns 0-1 value
callObject.participants() // Get participant info
callObject.localAudio() // Check local audio state

// Event listeners
callObject.on('joined-meeting', handler)
callObject.on('participant-joined', handler)
callObject.on('error', handler)
```

#### 2. shadcn/ui Components Verification

**All Required Components Already Installed** ✅:

- **Button** (`components/ui/button.tsx`):
  - Verified: Lines 1-58 in codebase
  - Variants: default, destructive, outline, secondary, ghost, link
  - Sizes: default (h-9), sm (h-8), lg (h-10), icon
  - Import: `import { Button } from '@/components/ui/button'`
  - Props: className, variant, size, disabled, onClick, type, asChild

- **Card** (`components/ui/card.tsx`):
  - Verified: Lines 1-84 in codebase
  - Components: Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter
  - Import: `import { Card, CardContent, CardHeader, CardTitle, CardFooter } from '@/components/ui/card'`
  - Default styles: rounded-xl, border, bg-card, shadow
  - CardHeader padding: p-6
  - CardContent padding: p-6 pt-0
  - CardFooter: flex items-center p-6 pt-0

- **Badge** (`components/ui/badge.tsx`):
  - Verified: Lines 1-37 in codebase
  - Variants: default, secondary, destructive, outline
  - Import: `import { Badge } from '@/components/ui/badge'`
  - Default styles: inline-flex, rounded-md, border, px-2.5, py-0.5, text-xs

- **Input** (`components/ui/input.tsx`):
  - Verified: Exists in `components/ui/` directory
  - Import: `import { Input } from '@/components/ui/input'`
  - Used in existing `pre-test-survey.tsx` (confirmed working)

- **Label** (`components/ui/label.tsx`):
  - Verified: Exists in `components/ui/` directory
  - Import: `import { Label } from '@/components/ui/label'`

**No Additional shadcn Components Needed** ✅

#### 3. Existing Codebase Context

**Session Management** (`lib/session.ts`):
- ✅ `createTestSession()` exists (lines 14-34)
- ✅ `getTestSession()` exists (lines 36-52)
- ✅ TypeScript interface `TestSession` defined (lines 3-12)
- ⚠️ `updateTestSession()` **NEEDS TO BE ADDED** (specified in plan)
- Pattern confirmed: `{ data, error }` return structure
- Uses: `createClient()` from `@/lib/supabase/client`

**Database Schema** (`supabase/migrations/20251027165723_create_test_sessions_table.sql`):
- ✅ Table `test_sessions` exists
- ✅ Column `daily_room_url TEXT` exists (line 8)
- ✅ RLS policy allows anonymous access (POC requirement)
- ✅ UUID primary key with auto-generation

**Routing Structure**:
- ✅ `/app/zebra/page.tsx` exists (Screen 1 - landing/survey)
- ✅ `/app/zebra/[sessionId]/layout.tsx` exists (minimal passthrough)
- ⚠️ `/app/zebra/[sessionId]/instructions/` directory **NEEDS TO BE CREATED**
- ⚠️ `/app/zebra/[sessionId]/mic-check/` directory **NEEDS TO BE CREATED**

**API Routes**:
- ✅ Confirmed Next.js App Router API route pattern from `app/auth/confirm/route.ts`
- Pattern: `export async function POST(request: Request) { ... }`
- ⚠️ `/app/api/daily/room/` directory **NEEDS TO BE CREATED**

**Reference Component** (`components/test-flow/pre-test-survey.tsx`):
- ✅ Excellent reference for component structure (lines 1-98)
- Pattern confirmed: 'use client' directive, useState hooks, useRouter navigation
- Styling confirmed: Uses Card, Button, Input, Label with Tailwind semantic tokens
- Error handling pattern: Local state with conditional rendering

#### 4. Daily.co Integration Technical Details

**Room Creation API** (https://api.daily.co/v1/rooms):
- **Method**: POST
- **Authentication**: Bearer token in Authorization header
- **Required Header**: `Authorization: Bearer ${DAILY_API_KEY}`
- **Body Parameters**:
  ```json
  {
    "name": "test-{sessionId}",
    "privacy": "private",
    "properties": {
      "enable_chat": false,
      "enable_screenshare": false,
      "enable_recording": "cloud",
      "start_audio_off": false,
      "start_video_off": true,
      "max_participants": 1
    }
  }
  ```
- **Response**: `{ url: string, name: string, ... }`
- **Error Handling**: Check response.ok, handle 4xx/5xx responses

**Client-Side Integration**:
- **createCallObject** options:
  ```typescript
  {
    url: roomUrl,           // Daily room URL from API
    audioSource: true,      // Enable microphone
    videoSource: false      // Disable camera (audio-only)
  }
  ```
- **Audio Level Monitoring**:
  - Method: `callObject.getInputAudioLevel()`
  - Returns: Number 0-1 (audio amplitude)
  - Frequency: Poll every 100ms via setInterval
  - Threshold: 0.05-0.1 for audio detection (per review notes: 0.05 preferred)

**Browser Compatibility**:
- ✅ Chrome 74+
- ✅ Firefox 78+
- ✅ Safari 12.1+
- ✅ Edge 79+
- ❌ Internet Explorer (all versions)
- ❌ Opera Mini
- Detection: Check `'mediaDevices' in navigator && 'getUserMedia' in navigator.mediaDevices`

#### 5. Environment Variables

**Required**:
- `DAILY_API_KEY` - Daily.co API key (server-side only, not exposed to client)
- `NEXT_PUBLIC_APP_URL` - Application URL (default: http://localhost:3001)

**Existing**:
- ✅ `NEXT_PUBLIC_SUPABASE_URL` - Already configured
- ✅ `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` - Already configured

**Setup Location**: `.env.local` (git-ignored, per CONTRIBUTING.md security rules)

### Implementation Feasibility

#### Technical Blockers
**None identified** ✅

#### Required Adjustments

1. **Session Management Enhancement**:
   - Add `updateTestSession()` function to `/lib/session.ts`
   - Pattern matches existing functions
   - Low complexity: ~15 lines of code

2. **Directory Creation**:
   - Create `/app/zebra/[sessionId]/instructions/` directory
   - Create `/app/zebra/[sessionId]/mic-check/` directory
   - Create `/app/api/daily/room/` directory
   - Create `/components/test-flow/` subdirectory (already exists from Screen 1)
   - Create `/lib/daily.ts` file

3. **Audio Detection Threshold**:
   - Review notes recommend 0.05 instead of 0.1
   - Apply to line 743 in mic-permission component implementation
   - Reasoning: Better sensitivity for user feedback

4. **Browser Compatibility Check**:
   - Add detection logic before Daily initialization
   - Graceful error message for unsupported browsers
   - Simple detection via `mediaDevices` API availability

#### Resource Availability

**All resources confirmed available**:
- ✅ Daily.co package installed (v0.85.0)
- ✅ shadcn/ui components present
- ✅ Supabase client utilities ready
- ✅ Database schema supports daily_room_url
- ✅ Next.js App Router for server/client component split
- ✅ TypeScript strict mode configured
- ✅ Tailwind CSS with semantic tokens

#### Daily.co API Integration Confidence

**HIGH CONFIDENCE** ✅:
- Clear API documentation patterns
- Simple REST API for room creation
- Well-established JavaScript SDK (@daily-co/daily-js)
- Audio-only configuration reduces complexity
- Cloud recording configuration available
- Error handling patterns well-defined

**Risk Assessment**:
- **Low Risk**: UI component creation (follows established patterns)
- **Medium Risk**: Daily.co API key setup (requires external account setup)
- **Low Risk**: Audio level monitoring (straightforward SDK method)
- **Low Risk**: Browser compatibility (modern browsers well-supported)

### Component Styling Validation

#### Tailwind Semantic Tokens Usage

**All styling uses proper semantic tokens** ✅:

- **Colors**:
  - `bg-primary` / `text-primary-foreground` - Primary buttons
  - `bg-muted` / `text-muted-foreground` - Helper text, secondary info
  - `bg-secondary` - Progress bar track
  - `bg-destructive` / `text-destructive` - Error states
  - `bg-card` / `text-card-foreground` - Card backgrounds (default)
  - `border` - Border color (semantic)

- **Layout**:
  - `rounded-xl` / `rounded-md` - Border radius (matches existing components)
  - `shadow` / `shadow-sm` - Elevation (Card default)
  - `p-4` / `p-6` - Consistent padding (matches Card defaults)

- **Responsive**:
  - `max-w-md` / `max-w-2xl` - Container widths
  - `min-h-screen` - Full viewport height
  - `space-y-*` - Vertical spacing

**No Custom Colors or Hard-coded Values** ✅

#### Visual Consistency Check

**Matches existing `pre-test-survey.tsx` patterns**:
- Same Card structure and spacing
- Same Button sizes and variants
- Same error message styling (`text-destructive`)
- Same loading state patterns
- Same form validation approach

**Progress Indicator Styling**:
- Uses semantic `bg-primary` for filled portion
- Uses semantic `bg-secondary` for track
- Smooth transitions with `transition-all duration-300`
- Consistent with modern progress bar patterns

**Audio Level Visualization**:
- Uses semantic `bg-secondary` for track
- Dynamic color: `bg-green-500` when active (audio detected)
- `bg-muted-foreground` when inactive
- Smooth transitions with `transition-all duration-100`

### Next.js App Router Patterns Verification

#### Server Component Pattern
```typescript
// Server component for data fetching (page.tsx)
export default async function PageName({ params }: { params: { sessionId: string } }) {
  const session = await getTestSession(params.sessionId);
  if (!session) redirect('/zebra');
  return <ClientComponent sessionId={params.sessionId} />;
}
```

**Verified Against**:
- ✅ Uses async/await for server-side data fetching
- ✅ Uses `redirect()` from 'next/navigation' for navigation
- ✅ Passes data as props to client components

#### Client Component Pattern
```typescript
// Client component for interactivity
'use client';

export function ComponentName({ sessionId }: Props) {
  const router = useRouter();
  const [state, setState] = useState();
  // ... component logic
}
```

**Verified Against `pre-test-survey.tsx`**:
- ✅ 'use client' directive at top
- ✅ Uses useRouter from 'next/navigation' (not next/router)
- ✅ Uses router.push() for navigation
- ✅ Type-safe props with TypeScript interfaces

#### API Route Pattern
```typescript
// API route (route.ts)
import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  const body = await request.json();
  // ... API logic
  return NextResponse.json({ data }, { status: 200 });
}
```

**Verified Against `app/auth/confirm/route.ts`**:
- ✅ Named export function (GET/POST/etc)
- ✅ Uses NextResponse for responses
- ✅ Proper error handling with status codes
- ✅ Environment variable access via process.env

### Discovery Summary

**All Components Available**: ✅ Yes
- @daily-co/daily-js: Already installed (v0.85.0)
- shadcn/ui components: All present (Button, Card, Badge, Input, Label)
- Session utilities: Exist, one addition needed
- Database schema: Confirmed with required columns

**Technical Blockers**: ✅ None
- No missing dependencies
- No API incompatibilities
- No architectural conflicts
- No breaking changes needed

**Ready for Implementation**: ✅ Yes
- All technical requirements verified
- Component patterns confirmed
- Integration paths validated
- Error handling patterns established

**Special Notes**:

1. **Environment Setup Required** (User Action):
   - Obtain Daily.co API key from https://dashboard.daily.co
   - Add to `.env.local` (git-ignored per CONTRIBUTING.md)
   - Verified: .env.local not tracked in git (security requirement)

2. **Implementation Enhancements** (From Review):
   - Audio detection threshold: Use 0.05 instead of 0.1 for better UX
   - Browser compatibility check: Add before Daily initialization
   - Room cleanup: Not needed for POC (keep for debugging)

3. **Code Quality Confidence**:
   - TypeScript strict mode: All type safety enforced
   - Component patterns: Match existing codebase structure
   - Error handling: Consistent with project patterns
   - Styling: Uses only semantic Tailwind tokens

4. **Daily.co Integration Specifics**:
   - Audio-only configuration: Simpler than full video
   - Cloud recording: Enabled for transcription later
   - Single participant: Reduces complexity
   - Private rooms: Appropriate security for POC

### Required Installations

**No npm installations required** ✅

All dependencies already present:
```bash
# Already installed in package.json:
# @daily-co/daily-js: ^0.85.0
# All shadcn/ui components installed
# Supabase clients installed
```

### Files to Create - Implementation Checklist

**New Directories** (5):
- [ ] `/app/zebra/[sessionId]/instructions/`
- [ ] `/app/zebra/[sessionId]/mic-check/`
- [ ] `/app/api/daily/room/`
- [ ] (Note: `/components/test-flow/` already exists)
- [ ] (Note: `/lib/` already exists)

**New Files** (7):
- [ ] `/app/zebra/[sessionId]/instructions/page.tsx` (~45 lines)
- [ ] `/components/test-flow/task-instructions.tsx` (~98 lines)
- [ ] `/components/test-flow/progress-indicator.tsx` (~25 lines)
- [ ] `/app/zebra/[sessionId]/mic-check/page.tsx` (~37 lines)
- [ ] `/components/test-flow/mic-permission.tsx` (~170 lines)
- [ ] `/lib/daily.ts` (~30 lines)
- [ ] `/app/api/daily/room/route.ts` (~68 lines)

**Files to Modify** (2):
- [ ] `/lib/session.ts` - Add `updateTestSession()` function (~15 lines to add)
- [ ] `.env.local` - Add DAILY_API_KEY and NEXT_PUBLIC_APP_URL (user action)

**Total New Code**: ~473 lines across 7 new files + 15 lines modification
**Estimated Complexity**: Medium (primarily UI components + one API integration)

### Implementation Sequence Recommendation

**Phase 1: Foundation** (Low risk, no external dependencies):
1. Add `updateTestSession()` to `/lib/session.ts`
2. Create `ProgressIndicator` component (reusable utility)
3. Create `TaskInstructions` component (static UI)
4. Create instructions page route (simple integration)
5. **Test Screen 2** before proceeding

**Phase 2: Daily.co Integration** (Requires API key):
6. Ensure DAILY_API_KEY in `.env.local`
7. Create `/lib/daily.ts` utility functions
8. Create `/app/api/daily/room/route.ts` API endpoint
9. Create `MicPermission` component (complex, includes Daily SDK)
10. Create mic-check page route
11. **Test Screen 3** with full Daily.co flow

**Reasoning**: Sequential implementation allows testing at each major milestone, reducing debugging complexity.

### Technical Validation Checklist

- [x] **CRITICAL**: Component identification verified for target pages
- [x] Page-to-component rendering path validated
- [x] All mentioned components exist or are properly planned
- [x] Component APIs match planned usage
- [x] Import paths verified (@/ alias working)
- [x] No version conflicts detected
- [x] Design specs clear (functional POC, no Figma)
- [x] Dependencies verified (already installed)
- [x] No blocking technical issues
- [x] Environment variable strategy confirmed
- [x] Database schema supports requirements
- [x] TypeScript configuration supports strict typing
- [x] API route patterns match Next.js App Router
- [x] Browser compatibility requirements documented

### Pre-Execution Verification Complete ✅

**Agent 3 Discovery Complete**: October 27, 2025
**Status**: Ready for Execution (Agent 4)
**Next Step**: Move to "Ready to Execute" in status.md
**Confidence Level**: HIGH - All technical requirements verified and available

---

## Implementation Notes

**Implementation Date**: October 27, 2025
**Agent**: Agent 4 (Execution & Implementation)
**Status**: Implementation Complete - Ready for Manual Testing

### Files Created (7 new files)

1. **`/components/test-flow/progress-indicator.tsx`** (~28 lines)
   - Reusable progress bar component
   - Shows current step, total steps, and percentage
   - Smooth transition animations
   - Uses semantic Tailwind tokens

2. **`/components/test-flow/task-instructions.tsx`** (~80 lines)
   - Task instructions display component
   - Explains testing goals and "think aloud" requirement
   - Time estimate display (~5-10 minutes)
   - Routes to mic-check page on continue

3. **`/app/zebra/[sessionId]/instructions/page.tsx`** (~26 lines)
   - Server component for instructions page
   - Validates session exists before rendering
   - Integrates ProgressIndicator and TaskInstructions components
   - Shows Step 2 of 5 in progress indicator

4. **`/lib/daily.ts`** (~33 lines)
   - Daily.co integration utilities
   - `createDailyRoom()` - Calls API route to create room
   - `initializeDaily()` - Creates Daily call object with audio-only config
   - `getDailyAudioLevel()` - Gets audio level for visualization (0-1 range)

5. **`/app/api/daily/room/route.ts`** (~67 lines)
   - API endpoint for creating Daily.co rooms
   - Server-side Daily API integration
   - Audio-only configuration with cloud recording enabled
   - Private rooms with single participant limit
   - Comprehensive error handling

6. **`/components/test-flow/mic-permission.tsx`** (~214 lines)
   - Complex mic check interface with Daily.co integration
   - Browser compatibility check (Chrome 74+, Firefox 78+, Safari 12.1+, Edge 79+)
   - Real-time audio level visualization with color-coded feedback
   - Audio detection threshold: 0.05 (per review recommendation)
   - Loading, error, and success states
   - Automatic continue button enable when audio detected
   - Proper cleanup on unmount

7. **`/app/zebra/[sessionId]/mic-check/page.tsx`** (~55 lines)
   - Server component for mic check page
   - Creates Daily room server-side if not already created
   - Updates session with room URL in database
   - Shows Step 3 of 5 in progress indicator
   - Reuses existing room on refresh

### Files Modified (1 file)

1. **`/lib/session.ts`** (+18 lines)
   - Added `updateTestSession()` function
   - Matches existing function patterns (error handling, return types)
   - Supports updating `daily_room_url` and `completed_at` fields
   - Type-safe with TypeScript interfaces

### Technical Implementation Details

**Screen 2: Task Instructions**
- Clean, focused UI explaining test objectives
- Emphasizes "think aloud" methodology
- Clear navigation flow to mic check
- Mobile responsive layout

**Screen 3: Mic Permission & Test**
- Daily.co call object lifecycle management
- Audio level monitoring at 100ms intervals
- Browser compatibility detection before initialization
- Graceful error states with retry option
- Visual feedback when audio detected (green indicator)
- Continue button disabled until audio confirmed

**Session Management**
- Server-side Daily room creation
- Room URL persisted to database
- Reuses existing room on page refresh
- TypeScript type safety throughout

**Integration Points**
- Progress indicator shared across both screens
- Session validation on page load
- URL-based session ID routing
- Database updates for room URL storage

### Code Quality

**TypeScript**: All files type-safe, zero compilation errors
**ESLint**: No new linting errors in created files
**Component Patterns**: Follows existing shadcn/ui and project conventions
**Error Handling**: Comprehensive error states with user-friendly messages
**Browser Support**: Explicit compatibility checks for Daily.co requirements

### Dependencies

**No New Installations Required** ✅
- `@daily-co/daily-js` already installed (v0.85.0)
- All shadcn/ui components already present
- Supabase client utilities already configured

**Environment Variables Required**:
- `DAILY_API_KEY` - Daily.co API key (already added per task requirements)
- `NEXT_PUBLIC_APP_URL` - Application URL (defaults to http://localhost:3001)

---

## Manual Test Instructions

**Testing Environment**: http://localhost:3001
**Prerequisites**:
- Development server running on port 3001
- Daily.co API key configured in `.env.local`
- Microphone access available on testing device

### Test Flow Overview
1. Complete Screen 1 survey to get session ID
2. Test Screen 2 (Task Instructions)
3. Test Screen 3 (Mic Permission & Test)
4. Verify database updates

---

### Screen 2: Task Instructions Testing

**Start URL**: Navigate through Screen 1 survey, should redirect to `/zebra/[sessionId]/instructions`

#### Visual Verification
- [ ] Page loads without errors
- [ ] Progress indicator shows "Step 2 of 5" with 40% completion
- [ ] Badge shows "Step 2 of 5"
- [ ] Time estimate displays "~5-10 minutes"
- [ ] Card title is "Your Testing Task"
- [ ] All instruction sections visible:
  - "What you'll do:" section
  - "Important: Think Aloud" section
  - "Your goals:" bullet list
  - Tip box with lightbulb emoji
- [ ] "Continue to Mic Check" button is visible and enabled

#### Content Verification
- [ ] Instructions mention "zebradesign.io"
- [ ] "Think aloud" requirement is emphasized (bold text)
- [ ] Four goal items in bullet list
- [ ] Tip mentions "no wrong answers"

#### Functional Testing
- [ ] Click "Continue to Mic Check" button
- [ ] Should navigate to `/zebra/[sessionId]/mic-check`
- [ ] Session ID maintained in URL
- [ ] No console errors

#### Responsive Testing
- [ ] Desktop (1920px): Full layout with proper spacing
- [ ] Tablet (768px): Card adjusts width, text remains readable
- [ ] Mobile (375px): Card takes full width, buttons stack properly

#### Error Cases
- [ ] Invalid session ID (e.g., `/zebra/00000000-0000-0000-0000-000000000000/instructions`)
  - Expected: Redirect to `/zebra`
- [ ] Refresh page while on instructions
  - Expected: Page reloads successfully, content preserved

---

### Screen 3: Mic Permission Testing

**Start URL**: Navigate from Screen 2 or go directly to `/zebra/[sessionId]/mic-check`

#### Loading State Verification
- [ ] Loading spinner appears while connecting
- [ ] "Connecting to audio system..." message displays
- [ ] Loading state transitions to main UI within 2-3 seconds

#### Browser Compatibility Check
- [ ] Test in Chrome (should work)
- [ ] Test in Firefox (should work)
- [ ] Test in Safari (should work)
- [ ] Test in unsupported browser if available
  - Expected: Error message about browser support

#### Main UI Verification
- [ ] Progress indicator shows "Step 3 of 5" with 60% completion
- [ ] Badge shows "Step 3 of 5"
- [ ] Card title is "Microphone Check"
- [ ] Instruction text: "Please speak into your microphone to test the audio"
- [ ] Audio level visualization bar visible (gray/muted when no audio)
- [ ] Label "Audio Level" above visualization
- [ ] Tip box with lightbulb emoji visible initially

#### Audio Detection Testing
1. **Initial State**:
   - [ ] Audio level bar is gray/muted
   - [ ] Continue button shows "Waiting for audio..." and is disabled
   - [ ] Tip box visible with testing suggestion

2. **Speak into Microphone**:
   - [ ] Browser prompts for microphone permission (first time only)
   - [ ] After granting permission, audio level bar responds to voice
   - [ ] Bar turns green when audio detected (threshold: 0.05)
   - [ ] Bar width changes based on audio amplitude
   - [ ] Bar responds smoothly (no lag)

3. **Audio Confirmed State**:
   - [ ] After speaking, continue button enables
   - [ ] Button text changes to "Start Test"
   - [ ] Tip box replaced with green success message
   - [ ] Success message: "✓ Microphone is working! You can continue."

4. **Continue Flow**:
   - [ ] Click "Start Test" button
   - [ ] Should navigate to `/zebra/[sessionId]/test`
   - [ ] Expected: 404 page (Screen 4 not built yet) - THIS IS EXPECTED
   - [ ] Session ID maintained in URL

#### Error State Testing
1. **Deny Microphone Permission**:
   - [ ] Deny permission in browser prompt
   - [ ] Error card displays
   - [ ] Title: "Microphone Error" in red
   - [ ] Error message: "Failed to initialize microphone. Please check your browser permissions."
   - [ ] "Try Again" button visible
   - [ ] Click "Try Again" - page reloads

2. **Unsupported Browser** (if testable):
   - [ ] Open in Internet Explorer or Opera Mini
   - [ ] Error message about browser support displays
   - [ ] "Try Again" button visible

#### Database Verification
- [ ] Open Supabase dashboard
- [ ] Navigate to `test_sessions` table
- [ ] Find row with your session ID
- [ ] Verify `daily_room_url` column populated with Daily.co URL
  - Format should be: `https://[domain].daily.co/[room-name]`
- [ ] Room name should include session ID: `test-[sessionId]`

#### Refresh Behavior Testing
- [ ] Reach mic check screen and grant permission
- [ ] Refresh the page
- [ ] Should reconnect to existing Daily room (no new room created)
- [ ] Audio detection works after refresh
- [ ] Check database - `daily_room_url` unchanged

#### Performance Testing
- [ ] Audio level updates feel real-time (no noticeable lag)
- [ ] Page loads quickly (<2 seconds after room creation)
- [ ] No console errors or warnings
- [ ] No memory leaks (check DevTools Performance tab)

#### Responsive Testing
- [ ] Desktop: Full layout with proper card sizing
- [ ] Tablet: Card adjusts, audio bar scales properly
- [ ] Mobile: Touch-friendly button, readable text, bar responsive

---

### Integration Testing

#### Session Persistence
- [ ] Complete survey on Screen 1
- [ ] Note the session ID in URL
- [ ] Navigate to Screen 2 (instructions)
- [ ] Session ID unchanged in URL
- [ ] Navigate to Screen 3 (mic-check)
- [ ] Session ID still unchanged
- [ ] Refresh on Screen 3
- [ ] Session ID persists

#### Navigation Flow
- [ ] Survey → Instructions → Mic Check flows smoothly
- [ ] Each screen transition updates URL correctly
- [ ] Back button works (doesn't break flow)
- [ ] Can navigate directly to `/zebra/[sessionId]/instructions` with valid ID
- [ ] Can navigate directly to `/zebra/[sessionId]/mic-check` with valid ID

#### Database Updates
- [ ] Start new session from Screen 1
- [ ] Check database - new row created with `tester_name` and `tester_email`
- [ ] Complete mic check
- [ ] Check database - `daily_room_url` now populated
- [ ] Refresh mic check page
- [ ] Check database - `daily_room_url` unchanged (room reused)

---

### Known Expected Behaviors

**Screen 4 Not Built Yet**:
- Clicking "Start Test" on mic check will navigate to `/zebra/[sessionId]/test`
- This will show a 404 page - THIS IS EXPECTED
- Screen 4 will be implemented in a future task

**Daily.co Room Persistence**:
- Rooms created during testing will remain in Daily.co dashboard
- For POC, no cleanup is needed (per task requirements)
- Can view created rooms at https://dashboard.daily.co

**Development Server**:
- Testing should be done on port 3001 (active development)
- Port 3000 (stable) should remain unaffected

---

### Success Criteria

✅ **Move to Complete** if all of the following are true:
- All visual elements display correctly on all screens
- Progress indicator shows correct step numbers
- Task instructions are clear and well-formatted
- Mic permission flow completes successfully
- Audio level visualization responds to voice
- Continue button enables after audio detected
- Database updates with Daily room URL
- Session ID persists across navigation
- No console errors
- Responsive behavior works on mobile/tablet/desktop

❌ **Move to Needs Work** if any of the following occur:
- TypeScript compilation errors
- Console errors during navigation
- Microphone permission fails silently
- Audio level doesn't respond to voice
- Continue button never enables
- Database not updating with room URL
- Session ID lost during navigation
- Layout breaks on mobile devices
- Visual elements missing or misaligned

---

### Testing Checklist Summary

**Pre-Testing Setup**:
- [ ] Development server running on port 3001
- [ ] DAILY_API_KEY configured in .env.local
- [ ] Microphone available on test device
- [ ] Browser DevTools console open for error monitoring

**Screen 2 (Instructions)**:
- [ ] Visual verification complete
- [ ] Content verification complete
- [ ] Functional testing complete
- [ ] Responsive testing complete
- [ ] Error cases tested

**Screen 3 (Mic Check)**:
- [ ] Loading state verified
- [ ] Browser compatibility checked
- [ ] Main UI verified
- [ ] Audio detection tested
- [ ] Error states tested
- [ ] Database updates verified
- [ ] Refresh behavior tested
- [ ] Performance acceptable
- [ ] Responsive testing complete

**Integration Tests**:
- [ ] Session persistence verified
- [ ] Navigation flow tested
- [ ] Database updates confirmed

**Final Approval**:
- [ ] All success criteria met
- [ ] No blocking issues found
- [ ] Ready to proceed to Screen 4 implementation

