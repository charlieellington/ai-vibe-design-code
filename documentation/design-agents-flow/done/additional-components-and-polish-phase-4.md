## Additional Components and Polish - Phase 4

### Original Request

"@ai-vibe-design-code/documentation/design-agents-flow/design-1-planning.md for the additional components and polish as one complete task"

**User Context:** Implement Phase 4: Additional Components & Polish from @baby-build-plan.md as a single comprehensive task. This phase includes loading states with skeleton screens, error boundaries, and UI polish to complete the MVP before deployment.

### Verbatim Build Plan Context (Phase 4)

**From baby-build-plan.md lines 1090-1496 (PRESERVED VERBATIM):**

---

## Phase 4: Additional Components & Polish

### Step 4.1: Add Missing UI Components
```bash
# Install any additional shadcn/ui components needed
npx shadcn@latest add dialog  # For modals
npx shadcn@latest add sheet   # For mobile-friendly modals
npx shadcn@latest add textarea # For message input
npx shadcn@latest add toggle   # For category filters
npx shadcn@latest add table    # For admin tables
npx shadcn@latest add toast    # For notifications
```

### Step 4.2: Loading States with Skeleton Screens
Create `/components/ui/skeleton-card.tsx`:
```typescript
import { Skeleton } from '@/components/ui/skeleton';

// Skeleton for individual gift card
export function GiftCardSkeleton() {
  return (
    <div className="rounded-lg border p-4">
      <Skeleton className="h-48 w-full mb-3" />  {/* Image placeholder */}
      <Skeleton className="h-4 w-3/4 mb-2" />     {/* Title */}
      <Skeleton className="h-3 w-full mb-2" />     {/* Description line 1 */}
      <Skeleton className="h-3 w-4/5 mb-3" />     {/* Description line 2 */}
      <div className="flex justify-between items-center">
        <Skeleton className="h-6 w-20" />         {/* Price */}
        <Skeleton className="h-8 w-8 rounded-full" /> {/* Heart icon */}
      </div>
    </div>
  );
}

// Grid skeleton for loading state
export function GiftGridSkeleton({ count = 6 }) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {Array.from({ length: count }).map((_, i) => (
        <GiftCardSkeleton key={i} />
      ))}
    </div>
  );
}
```

Create `/app/loading.tsx` for automatic page loading states:
```typescript
import { GiftGridSkeleton } from '@/components/ui/skeleton-card';

export default function Loading() {
  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-8">
        <Skeleton className="h-8 w-48 mb-4" />  {/* Page title */}
        <Skeleton className="h-4 w-96" />        {/* Description */}
      </div>
      <GiftGridSkeleton count={6} />
    </div>
  );
}
```

**Implementation in Pages with Suspense:**
```typescript
// In app/page.tsx or any async page
import { Suspense } from 'react';
import { GiftGridSkeleton } from '@/components/ui/skeleton-card';

export default async function Page() {
  return (
    <Suspense fallback={<GiftGridSkeleton />}>
      <AsyncGiftGrid />  {/* This component fetches data */}
    </Suspense>
  );
}
```

**Why Skeleton Screens Matter:**
- Prevents layout shift (improves CLS score)
- Better perceived performance (feels faster)
- Clear loading indication without spinners
- Matches exact dimensions of real content

### Step 4.3: Error Boundaries
Create `/components/error-boundary.tsx`:
```typescript
'use client';

import { useEffect } from 'react';
import { Button } from '@/components/ui/button';

export default function ErrorBoundary({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Log error to console in development
    console.error('Error boundary caught:', error);
  }, [error]);

  return (
    <div className="flex min-h-[400px] flex-col items-center justify-center p-4">
      <div className="max-w-md text-center">
        <h2 className="mb-4 text-2xl font-bold">Oops! Something went wrong</h2>
        <p className="mb-6 text-muted-foreground">
          We're having trouble loading this page. This is usually temporary.
        </p>
        <div className="flex gap-4 justify-center">
          <Button onClick={reset} variant="default">
            Try Again
          </Button>
          <Button onClick={() => window.location.href = '/'} variant="outline">
            Go Home
          </Button>
        </div>
        {process.env.NODE_ENV === 'development' && (
          <details className="mt-6 text-left text-sm">
            <summary className="cursor-pointer text-muted-foreground">
              Error details (dev only)
            </summary>
            <pre className="mt-2 overflow-auto rounded bg-muted p-2 text-xs">
              {error.message}
            </pre>
          </details>
        )}
      </div>
    </div>
  );
}
```

Create `/app/error.tsx` for page-level error handling:
```typescript
'use client';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="container mx-auto px-4 py-16">
      <div className="mx-auto max-w-md text-center">
        <h1 className="mb-4 text-3xl font-bold">Something went wrong!</h1>
        <p className="mb-8 text-muted-foreground">
          Don't worry, this happens sometimes. Let's try again.
        </p>
        <button
          onClick={reset}
          className="rounded-lg bg-primary px-6 py-3 text-primary-foreground hover:bg-primary/90"
        >
          Try again
        </button>
      </div>
    </div>
  );
}
```

Create `/app/not-found.tsx` for 404 errors:
```typescript
import Link from 'next/link';
import { Button } from '@/components/ui/button';

export default function NotFound() {
  return (
    <div className="container mx-auto flex min-h-[60vh] items-center justify-center px-4">
      <div className="text-center">
        <h1 className="mb-4 text-6xl font-bold">404</h1>
        <h2 className="mb-4 text-2xl">Page Not Found</h2>
        <p className="mb-8 text-muted-foreground">
          The page you're looking for doesn't exist or has been moved.
        </p>
        <Link href="/">
          <Button>Return to Gift List</Button>
        </Link>
      </div>
    </div>
  );
}
```

**Error Handling Best Practices:**
- Use error.tsx files in route segments for automatic error boundaries
- Provide user-friendly messages without technical jargon
- Include retry mechanisms where appropriate
- Show error details only in development mode
- Log errors to monitoring service in production (Sentry, LogRocket)

### Step 4.4: Share Functionality
Create `/lib/share.ts`:
```typescript
// Share utilities
export async function shareList() {
  if (navigator.share) {
    // Native share
  } else {
    // Copy link fallback
  }
}
```

---

### Design Context

**Current Implementation Status:**
- Landing Page ✅ Complete - Hero section, category filters, gift grid, favorites
- Item Detail Modal ✅ Complete - Responsive modal with payment navigation
- Payment Instructions Page ✅ Complete - IBAN/PayPal details, copy buttons, contribution recording
- Thank You Page ✅ Complete - Confirmation, message form, **share functionality already implemented**
- Admin Dashboard ✅ Complete - Full CRUD operations, image management

**Phase 4 Requirements:**
This phase focuses on production-ready polish and user experience improvements:

1. **Loading States** - Prevent layout shift and improve perceived performance
2. **Error Boundaries** - Graceful error handling for better UX
3. **Share Functionality** - ✅ ALREADY IMPLEMENTED in thank you page
4. **UI Polish** - Final touches for production deployment

**Key UX Principles:**
- **Perceived Performance** - Skeleton screens make the app feel faster
- **Graceful Degradation** - Errors should never break the entire app
- **User Confidence** - Clear feedback for all states (loading, error, success)
- **Mobile-First** - All polish features must work on mobile
- **Accessibility** - Proper ARIA labels and semantic HTML

**Visual Design Consistency:**
- Skeleton screens match the exact dimensions of real content
- Error pages use consistent color palette and typography
- Loading states don't cause layout shift
- All interactive elements maintain consistent styling

### Codebase Context

**Existing Components Available:**
- ✅ `components/ui/button.tsx` - Button with variants (default, outline, ghost, etc.)
- ✅ `components/ui/card.tsx` - Card component for content sections
- ✅ `components/ui/badge.tsx` - Badge component
- ✅ `components/ui/input.tsx` - Input fields
- ✅ `components/ui/label.tsx` - Label component
- ✅ `components/ui/textarea.tsx` - Textarea component
- ✅ `components/ui/dialog.tsx` - Dialog component
- ✅ `components/ui/sheet.tsx` - Sheet component for mobile
- ✅ `components/ui/table.tsx` - Table component
- ✅ `components/ui/select.tsx` - Select component
- ✅ `components/ui/checkbox.tsx` - Checkbox component
- ✅ `components/ui/dropdown-menu.tsx` - Dropdown menu component
- ❌ `components/ui/skeleton.tsx` - **NOT YET INSTALLED** (need to add)
- ❌ `components/ui/toast.tsx` - **NOT YET INSTALLED** (optional for future)

**Gift List Components:**
- `components/gift-list/hero-section.tsx` - Welcome section
- `components/gift-list/category-filter.tsx` - Category pills
- `components/gift-list/gift-card.tsx` - Individual gift cards
- `components/gift-list/gift-grid.tsx` - Grid layout with all gift cards
- `components/gift-list/item-modal.tsx` - Item detail modal

**Current Page Structure:**
- `app/page.tsx` - Main landing page (Server Component, fetches items)
- `app/payment/page.tsx` - Payment instructions
- `app/thank-you/page.tsx` - Thank you page
- `app/protected/*` - Admin dashboard

**Share Functionality Analysis:**
**✅ ALREADY IMPLEMENTED** in `app/thank-you/thank-you-content.tsx` lines 62-87:
```typescript
// Handle share functionality
const handleShare = async () => {
  const shareData = {
    title: 'Baby Gift List',
    text: 'Check out this gift list for the new baby!',
    url: window.location.origin,
  };

  // Use native share API if available (mobile)
  if (navigator.share) {
    try {
      await navigator.share(shareData);
    } catch (err) {
      console.log('Share cancelled or failed:', err);
    }
  } else {
    // Fallback: Copy link to clipboard
    try {
      await navigator.clipboard.writeText(window.location.origin);
      alert('Link copied to clipboard!');
    } catch (err) {
      console.error('Failed to copy:', err);
      alert(`Share this link: ${window.location.origin}`);
    }
  }
};
```

**Missing Files (To Be Created):**
- ❌ `components/ui/skeleton.tsx` - Skeleton component from shadcn
- ❌ `components/ui/skeleton-card.tsx` - Custom skeleton for gift cards
- ❌ `app/loading.tsx` - Root level loading state
- ❌ `app/error.tsx` - Root level error boundary
- ❌ `app/not-found.tsx` - 404 page
- ❌ `lib/share.ts` - Optional utility (share already works in thank-you page)

**Existing Error Handling Patterns:**
Current error handling in `app/page.tsx` lines 17-31:
```typescript
if (error) {
  console.error('Error fetching items:', error);
  return (
    <main className="min-h-screen">
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Oops!</h1>
          <p className="text-muted-foreground">
            We're having trouble loading the gift list. Please try again later.
          </p>
        </div>
      </div>
    </main>
  );
}
```

This inline error handling works but Next.js error.tsx provides better patterns.

**Related Files:**
- `app/page.tsx` - Main page that would benefit from loading states
- All existing components for reference styling
- `next.config.ts` - Already configured for image optimization

### Prototype Scope

**Frontend Focus - Production Polish:**
- ✅ Install skeleton component from shadcn/ui
- ✅ Create skeleton screens matching exact gift card dimensions
- ✅ Add automatic loading states using Next.js loading.tsx
- ✅ Implement error boundaries at root and page levels
- ✅ Create user-friendly 404 page
- ✅ All components follow existing design system patterns
- ✅ Mobile-responsive skeleton screens
- ❌ No analytics tracking (can add later)
- ❌ No toast notifications (optional enhancement)
- ❌ No advanced monitoring (Sentry integration is future enhancement)

**Component Reuse Strategy:**
- Use existing Button component for error page CTAs
- Follow existing Card component styling for consistency
- Match skeleton dimensions to actual gift card components
- Reuse existing color palette and spacing from design system

**What NOT to Build:**
- No analytics dashboard (future enhancement)
- No real-time error monitoring service integration (future)
- No toast notification system (optional, build plan mentions but not critical for MVP)
- No separate share utility file (already implemented in thank-you page)

### Plan

#### Step 1: Install Skeleton Component from shadcn/ui
**Command:** `npx shadcn@latest add skeleton`

**Why:** Skeleton component is needed for loading states but not yet installed

**Verification:**
- Confirm `components/ui/skeleton.tsx` file is created
- Check that component exports Skeleton with proper className props
- Verify Tailwind animation classes are included

---

#### Step 2: Create Gift Card Skeleton Component
**File:** `components/ui/skeleton-card.tsx` (new file)
**Type:** React Component (no 'use client' needed - just markup)

**Implementation Details:**

```typescript
import { Skeleton } from '@/components/ui/skeleton';

/**
 * Gift Card Skeleton
 *
 * Loading placeholder matching the exact dimensions and layout
 * of the GiftCard component. Prevents layout shift during loading.
 */
export function GiftCardSkeleton() {
  return (
    <div className="rounded-lg border p-4 bg-card">
      {/* Image placeholder - matches gift-card.tsx image container */}
      <Skeleton className="h-48 w-full mb-3 rounded-md" />

      {/* Title placeholder - matches gift-card.tsx title */}
      <Skeleton className="h-4 w-3/4 mb-2" />

      {/* Description line 1 */}
      <Skeleton className="h-3 w-full mb-2" />

      {/* Description line 2 */}
      <Skeleton className="h-3 w-4/5 mb-3" />

      {/* Bottom row: Price and heart icon */}
      <div className="flex justify-between items-center">
        <Skeleton className="h-6 w-20" />  {/* Price */}
        <Skeleton className="h-8 w-8 rounded-full" />  {/* Heart icon */}
      </div>
    </div>
  );
}

/**
 * Gift Grid Skeleton
 *
 * Grid of skeleton cards matching the GiftGrid component layout.
 * Used for initial page load and category filter changes.
 *
 * @param count - Number of skeleton cards to display (default: 6)
 */
export function GiftGridSkeleton({ count = 6 }: { count?: number }) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-8">
      {Array.from({ length: count }).map((_, i) => (
        <GiftCardSkeleton key={`skeleton-${i}`} />
      ))}
    </div>
  );
}
```

**Component Features:**
- Matches exact dimensions of real GiftCard component
- Uses same grid layout as GiftGrid (1 col mobile, 2 cols tablet, 3 cols desktop)
- Configurable count for different use cases
- No layout shift when real content loads
- Follows existing design system (rounded-lg, border, bg-card)

**Design Specifications:**
- Image: h-48 (matches gift-card.tsx line 45-55)
- Title: h-4 w-3/4 (matches typical title height)
- Description: h-3 lines (matches description typography)
- Price: h-6 w-20 (matches price badge size)
- Heart: h-8 w-8 rounded-full (matches heart button)
- Grid: Same gap-4 and responsive cols as gift-grid.tsx

**Why This Approach:**
- Prevents cumulative layout shift (CLS) metric issues
- Better perceived performance than spinner
- Matches exact real content dimensions
- Reusable across all loading states

---

#### Step 3: Create Root Loading State
**File:** `app/loading.tsx` (new file)
**Type:** Server Component (Next.js automatic loading UI)

**Implementation Details:**

```typescript
import { Skeleton } from '@/components/ui/skeleton';
import { GiftGridSkeleton } from '@/components/ui/skeleton-card';

/**
 * Root Loading State
 *
 * Automatically shown by Next.js when navigating to the home page
 * or when page.tsx is loading data. Matches the layout of the
 * actual page to prevent layout shift.
 */
export default function Loading() {
  return (
    <main className="min-h-screen">
      <div className="container mx-auto px-4 py-8">
        {/* Hero Section Skeleton */}
        <div className="mb-8 space-y-4">
          <Skeleton className="h-12 w-64 mx-auto" />  {/* Hero title */}
          <Skeleton className="h-4 w-96 mx-auto" />   {/* Hero description */}
        </div>

        {/* Category Filter Skeleton */}
        <div className="mb-6 flex justify-center gap-2 flex-wrap">
          <Skeleton className="h-9 w-16" />  {/* "All" pill */}
          <Skeleton className="h-9 w-24" />  {/* Category pill */}
          <Skeleton className="h-9 w-24" />  {/* Category pill */}
          <Skeleton className="h-9 w-24" />  {/* Category pill */}
          <Skeleton className="h-9 w-24" />  {/* Category pill */}
          <Skeleton className="h-9 w-32" />  {/* "Your Favorites" pill */}
        </div>

        {/* Gift Grid Skeleton - 6 cards initially */}
        <GiftGridSkeleton count={6} />
      </div>
    </main>
  );
}
```

**Component Features:**
- Matches exact layout of app/page.tsx
- Shows skeleton for hero section, category filters, and gift grid
- Automatically displayed by Next.js during navigation or data fetching
- No client-side JavaScript needed
- Same container and spacing as actual page

**Why This Approach:**
- Next.js automatically uses loading.tsx during page transitions
- Zero configuration needed - just export default function
- Prevents blank screen during initial load
- Same layout prevents shift when content appears

**Testing:**
- Navigate to home page - should show skeleton briefly
- Slow network simulation should show skeleton longer
- No layout shift when real content loads

---

#### Step 4: Create Root Error Boundary
**File:** `app/error.tsx` (new file)
**Type:** Client Component (Next.js error boundary)

**Implementation Details:**

```typescript
'use client';

import { useEffect } from 'react';
import { Button } from '@/components/ui/button';

/**
 * Root Error Boundary
 *
 * Catches errors in the home page and provides user-friendly
 * error message with retry mechanism. Next.js automatically
 * wraps the page in this error boundary.
 */
export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Log error to console in development
    console.error('Error boundary caught:', error);

    // TODO: In production, log to monitoring service (Sentry, LogRocket, etc.)
    // if (process.env.NODE_ENV === 'production') {
    //   logErrorToService(error);
    // }
  }, [error]);

  return (
    <main className="min-h-screen">
      <div className="container mx-auto px-4 py-16">
        <div className="mx-auto max-w-md text-center space-y-6">
          {/* Error Icon/Visual */}
          <div className="mx-auto w-16 h-16 rounded-full bg-destructive/10 flex items-center justify-center">
            <svg
              className="w-8 h-8 text-destructive"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
              />
            </svg>
          </div>

          {/* Error Message */}
          <div className="space-y-2">
            <h1 className="text-3xl font-bold">Something went wrong!</h1>
            <p className="text-muted-foreground">
              Don&apos;t worry, this happens sometimes. Let&apos;s try reloading the page.
            </p>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row gap-3 justify-center">
            <Button onClick={reset} variant="default" size="lg">
              Try Again
            </Button>
            <Button
              onClick={() => (window.location.href = '/')}
              variant="outline"
              size="lg"
            >
              Go Home
            </Button>
          </div>

          {/* Development Error Details */}
          {process.env.NODE_ENV === 'development' && (
            <details className="mt-8 text-left">
              <summary className="cursor-pointer text-sm text-muted-foreground hover:text-foreground">
                Error details (development only)
              </summary>
              <pre className="mt-4 overflow-auto rounded-lg bg-muted p-4 text-xs">
                <code>{error.message}</code>
                {error.stack && (
                  <>
                    {'\n\n'}
                    <code className="text-muted-foreground">{error.stack}</code>
                  </>
                )}
              </pre>
            </details>
          )}
        </div>
      </div>
    </main>
  );
}
```

**Component Features:**
- User-friendly error message without technical jargon
- Visual error icon for better UX
- "Try Again" button calls reset() to re-render the page
- "Go Home" button as fallback navigation
- Development-only error details in collapsible section
- Automatic error logging (console in dev, TODO for production service)
- Responsive layout (stack buttons on mobile)

**Error Handling Best Practices:**
- Never show raw error messages to users in production
- Provide clear recovery actions (Try Again, Go Home)
- Log errors for debugging but hide details from users
- Use semantic colors (destructive/red for errors)
- Include visual indicators (icon) for quick recognition

**Why Client Component:**
- Uses React hooks (useEffect for logging)
- Needs access to reset() function from Next.js
- Interactive buttons (onClick handlers)

**Testing:**
- Trigger error in page.tsx to verify error boundary catches it
- Verify "Try Again" button resets the error state
- Verify "Go Home" navigates to root
- Check development error details show in dev mode
- Confirm error details hidden in production

---

#### Step 5: Create 404 Not Found Page
**File:** `app/not-found.tsx` (new file)
**Type:** Server Component

**Implementation Details:**

```typescript
import Link from 'next/link';
import { Button } from '@/components/ui/button';

/**
 * 404 Not Found Page
 *
 * Shown when users navigate to non-existent routes.
 * Provides clear messaging and navigation back to the gift list.
 */
export default function NotFound() {
  return (
    <main className="min-h-screen">
      <div className="container mx-auto flex min-h-[60vh] items-center justify-center px-4">
        <div className="text-center space-y-6">
          {/* 404 Visual */}
          <div className="space-y-2">
            <h1 className="text-7xl sm:text-8xl font-bold text-primary">404</h1>
            <h2 className="text-2xl sm:text-3xl font-semibold">Page Not Found</h2>
          </div>

          {/* Description */}
          <p className="text-muted-foreground max-w-md mx-auto">
            The page you&apos;re looking for doesn&apos;t exist or has been moved.
            Let&apos;s get you back to the gift list.
          </p>

          {/* Action Button */}
          <Link href="/">
            <Button size="lg" className="mt-4">
              Return to Gift List
            </Button>
          </Link>

          {/* Optional: Common links */}
          <div className="pt-8 text-sm text-muted-foreground space-y-2">
            <p>Looking for something specific?</p>
            <div className="flex justify-center gap-4">
              <Link href="/" className="hover:text-foreground transition-colors">
                Home
              </Link>
              <span>•</span>
              <Link href="/protected/upload" className="hover:text-foreground transition-colors">
                Admin
              </Link>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
```

**Component Features:**
- Large, clear 404 number for immediate recognition
- Friendly, non-technical message
- Clear call-to-action (Return to Gift List)
- Optional quick navigation links (Home, Admin)
- Responsive typography (7xl → 8xl on larger screens)
- Semantic HTML structure

**Design Specifications:**
- 404 number: text-7xl sm:text-8xl (very large, impossible to miss)
- Primary color for 404 (matches brand)
- Centered layout with max-width for readability
- Consistent spacing using space-y-6
- Button uses size="lg" for prominence

**Why This Approach:**
- Clear immediate feedback that the page doesn't exist
- Non-technical, friendly language
- Single clear action (return to list)
- Maintains site branding and styling
- No confusion about what went wrong

**Testing:**
- Navigate to `/invalid-route` - should show 404 page
- Verify "Return to Gift List" button works
- Check responsive typography on mobile
- Verify optional links work if included

---

#### Step 6: Add Suspense Boundaries (Optional Enhancement)
**File:** `app/page.tsx` (modify existing)
**Type:** Add Suspense for progressive loading

**Implementation Details:**

**Current code** (lines 1-52):
```typescript
export default async function Home() {
  // Fetch items server-side for fast initial load
  const supabase = await createClient();
  const { data: items, error } = await supabase
    .from('items')
    .select('*')
    .order('priority', { ascending: true });

  // ... error handling ...

  return (
    <main className="min-h-screen">
      <div className="container mx-auto px-4 py-8">
        <HeroSection />
        <GiftGrid items={items || []} />
        {/* ... admin link ... */}
      </div>
    </main>
  );
}
```

**Optional Enhancement** (Progressive loading):
```typescript
import { Suspense } from 'react';
import { GiftGridSkeleton } from '@/components/ui/skeleton-card';

export default async function Home() {
  return (
    <main className="min-h-screen">
      <div className="container mx-auto px-4 py-8">
        {/* Hero loads immediately - no suspense needed */}
        <HeroSection />

        {/* Gift grid in suspense boundary - shows skeleton during fetch */}
        <Suspense fallback={<GiftGridSkeleton count={6} />}>
          <AsyncGiftGrid />
        </Suspense>

        {/* Admin link */}
        <div className="mt-16 pb-8 text-center">
          <Link
            href="/protected/upload"
            className="text-xs text-muted-foreground hover:text-foreground transition-colors"
          >
            admin
          </Link>
        </div>
      </div>
    </main>
  );
}

// Separate async component for gift grid
async function AsyncGiftGrid() {
  const supabase = await createClient();
  const { data: items, error } = await supabase
    .from('items')
    .select('*')
    .order('priority', { ascending: true });

  if (error) {
    // This error will be caught by error.tsx
    throw new Error('Failed to load gift items');
  }

  return <GiftGrid items={items || []} />;
}
```

**Why This Enhancement:**
- Hero section shows immediately (above the fold content)
- Gift grid shows skeleton while data loads
- Better perceived performance
- Progressive rendering pattern

**Note:** This is OPTIONAL. Current implementation already caches page for 24 hours (line 7: `export const revalidate = 86400`), so loading is very fast. Suspense adds complexity for minimal benefit given the caching.

**Recommendation:** Skip this step for MVP. Current page-level caching is sufficient.

---

#### Step 7: Optional UI Polish Enhancements

**7.1: Add Smooth Transitions**

Optional CSS improvements for polish:

**File:** `app/globals.css` (add at the end)
```css
/* Smooth page transitions */
@layer utilities {
  .transition-page {
    @apply transition-all duration-300 ease-in-out;
  }

  /* Skeleton pulse animation (if not included in shadcn skeleton) */
  .skeleton-pulse {
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
  }

  @keyframes pulse {
    0%, 100% {
      opacity: 1;
    }
    50% {
      opacity: 0.5;
    }
  }
}
```

**7.2: Add Focus Visible States**

Ensure all interactive elements have clear focus states for keyboard navigation:

**Check these files:**
- `components/ui/button.tsx` - Should have `focus-visible:ring` classes ✓
- `components/gift-list/gift-card.tsx` - Heart button should have focus state ✓
- `components/gift-list/category-filter.tsx` - Filter pills should have focus state ✓

**Verify accessibility:**
```bash
# Use keyboard navigation (Tab key) to verify all interactive elements have visible focus
# All buttons, links, and form inputs should show focus ring
```

**7.3: Verify Mobile Touch Targets**

Ensure all touch targets are at least 44x44px per WCAG guidelines:

**Check these components:**
- Gift card heart button: Should be h-8 w-8 minimum (currently is ✓)
- Category filter pills: Should have adequate padding (verify)
- Payment page copy buttons: Should be large enough (verify)

**7.4: Add aria-labels Where Missing**

Verify all icon-only buttons have descriptive aria-labels:

**Files to check:**
- `components/gift-list/gift-card.tsx` - Heart button (favorite toggle)
- `components/gift-list/item-modal.tsx` - Close button
- Any admin components with icon-only buttons

**Example fix:**
```typescript
<button
  aria-label="Add to favorites"
  onClick={handleFavoriteToggle}
>
  <Heart className="w-5 h-5" />
</button>
```

**Note:** These enhancements are OPTIONAL for MVP. Focus on Steps 1-5 first.

---

### Stage

Review - Confirmed

### Questions for Clarification

**[TECHNICAL DECISIONS]:**

1. **Suspense Enhancement (Step 6):**
   - Option A: Skip Suspense implementation - current page-level caching is sufficient for MVP
   - Option B: Implement Suspense for progressive rendering pattern
   - **My Recommendation:** Option A - The page already has 24-hour revalidation, so loading is very fast. Suspense adds complexity for minimal perceived benefit.

2. **UI Polish Scope (Step 7):**
   - Option A: Skip all optional polish for MVP - focus on core loading states and error boundaries
   - Option B: Include basic polish (transitions, focus states, touch targets)
   - Option C: Full polish including all accessibility enhancements
   - **My Recommendation:** Option A for MVP - Steps 1-5 are the critical production requirements. Polish can be added post-launch based on user feedback.

3. **Share Utility File:**
   - Share functionality is already implemented in thank-you page (lines 62-87)
   - Build plan mentions creating `/lib/share.ts` but it's already working
   - Should we extract it to a utility file for reusability?
   - **My Recommendation:** Leave it inline - it's only used in one place. YAGNI principle applies.

4. **Toast Notifications:**
   - Build plan mentions toast component for notifications
   - Currently using alerts for errors (payment and thank you pages)
   - Should we install and implement toast now or later?
   - **My Recommendation:** Later - Alerts work for MVP. Toast is enhancement, not requirement.

5. **Error Monitoring Service:**
   - Build plan mentions Sentry/LogRocket for production error logging
   - Should we plan integration now or add TODO comments?
   - **My Recommendation:** TODO comments for now - Integration can happen during deployment phase.

**[CLARIFICATION NEEDED]:**

None - All requirements are clear from build plan. Above questions are about scope prioritization, not missing information.

### Priority

High - This is Phase 4 in the build plan, final step before Phase 5 (Testing & Deployment)

### Created

2025-11-06 (Task planning phase)

### Files

**New Files to Create:**
- `components/ui/skeleton.tsx` - Install via `npx shadcn@latest add skeleton`
- `components/ui/skeleton-card.tsx` - Custom gift card skeleton components
- `app/loading.tsx` - Root level automatic loading state
- `app/error.tsx` - Root level error boundary
- `app/not-found.tsx` - 404 page

**Files to Optionally Modify:**
- `app/page.tsx` - Add Suspense boundaries (optional, Step 6)
- `app/globals.css` - Add smooth transitions (optional, Step 7)

**Files to Verify (No changes needed):**
- `app/thank-you/thank-you-content.tsx` - Share functionality already implemented (lines 62-87) ✓
- `components/ui/button.tsx` - Focus states already included ✓
- `components/gift-list/*` - All components for accessibility audit

**File Count:** 5 new files (skeleton, skeleton-card, loading, error, not-found)

### Dependencies

**To Install:**
```bash
npx shadcn@latest add skeleton
```

**Already Installed:**
- ✅ All other shadcn/ui components needed
- ✅ lucide-react icons
- ✅ Next.js 15 with error boundaries and loading UI
- ✅ Tailwind CSS for styling

**No New Dependencies Required** beyond skeleton component

### Technical Notes

**Next.js File-Based Conventions:**
- `app/loading.tsx` - Automatically shown during page transitions or data fetching
- `app/error.tsx` - Automatically wraps page.tsx in error boundary
- `app/not-found.tsx` - Automatically shown for 404 errors or when `notFound()` is called

**These files require NO configuration** - Next.js handles them automatically based on file location.

**Skeleton Component Pattern:**
- Skeleton component uses Tailwind `animate-pulse` by default
- Custom skeleton-card matches exact dimensions of real gift card
- No layout shift when real content loads
- Improves Core Web Vitals (CLS metric)

**Error Boundary Patterns:**
- Must be 'use client' directive (Next.js requirement)
- Receives error and reset function as props
- Can nest error boundaries for granular error handling
- Root error.tsx catches all uncaught errors in route

**Share Functionality Status:**
- Already implemented with native share API + clipboard fallback
- No need to create separate utility file
- Works on mobile (native share) and desktop (clipboard)
- No changes needed for this phase

### Success Criteria

**Core Requirements (Steps 1-5):**
- [ ] Skeleton component installed from shadcn/ui
- [ ] Gift card skeleton matches exact dimensions of real card
- [ ] Root loading.tsx shows during page load with proper layout
- [ ] Root error.tsx catches errors and shows user-friendly message
- [ ] 404 page shows for non-existent routes
- [ ] No layout shift when loading states transition to real content
- [ ] All error pages have working navigation back to home
- [ ] Mobile responsive skeleton screens and error pages
- [ ] Development error details show in dev mode only
- [ ] Production errors hide technical details from users

**Optional Enhancements (Steps 6-7):**
- [ ] Suspense boundaries for progressive loading (optional)
- [ ] Smooth transitions in CSS (optional)
- [ ] All interactive elements have focus-visible states (optional)
- [ ] All touch targets meet 44x44px minimum (optional)
- [ ] All icon-only buttons have aria-labels (optional)

**Testing:**
- [ ] Navigate to home page - skeleton shows briefly
- [ ] Trigger error in page - error boundary catches it
- [ ] Navigate to invalid URL - 404 page shows
- [ ] Keyboard navigation works on all error pages
- [ ] Mobile layout works for all new pages
- [ ] No TypeScript errors
- [ ] Build completes successfully

**Performance Metrics:**
- [ ] Cumulative Layout Shift (CLS) improved with skeleton screens
- [ ] Largest Contentful Paint (LCP) stays under 2.5s
- [ ] Time to Interactive (TTI) not negatively impacted
- [ ] No console errors in production mode

### Implementation Approach

**Recommended Implementation Order:**

1. **Install skeleton component** (Step 1) - 2 minutes
2. **Create skeleton-card.tsx** (Step 2) - 10 minutes
3. **Create loading.tsx** (Step 3) - 5 minutes
4. **Create error.tsx** (Step 4) - 10 minutes
5. **Create not-found.tsx** (Step 5) - 5 minutes
6. **Test all new pages** - 15 minutes
7. **Verify build succeeds** - 2 minutes

**Total Estimated Time:** 45-60 minutes for core implementation (Steps 1-5)

**Optional enhancements** (Steps 6-7): Additional 30-60 minutes

**Why This Order:**
- Skeleton component needed for loading.tsx
- Loading and error states are independent
- Test after core implementation before optional enhancements
- Build verification ensures no breaking changes

### Contributing.md Compliance Check

✅ **Simplicity**: Using Next.js built-in conventions (loading.tsx, error.tsx, not-found.tsx)
✅ **No duplication**: Reusing existing Button component, following existing patterns
✅ **One source of truth**: Loading states use same layout as actual pages
✅ **File size**: All new files well under 250 lines
✅ **Real data**: No mocks - skeleton just shows while real data loads
✅ **Human-first headers**: All components have clear purpose documentation
✅ **Security**: No security concerns - all frontend display logic

### Build Plan Alignment

**Phase 4 Requirements from Build Plan:**

1. ✅ **Loading States with Skeleton Screens** - Steps 1-3
   - Install skeleton component
   - Create gift card skeleton matching exact dimensions
   - Add automatic loading.tsx for root route
   - Prevent layout shift and improve perceived performance

2. ✅ **Error Boundaries** - Steps 4-5
   - Root error.tsx for application errors
   - 404 not-found.tsx for missing routes
   - User-friendly messages with retry mechanisms
   - Development error details for debugging

3. ✅ **Share Functionality** - Already Complete
   - Implemented in thank-you page (lines 62-87)
   - Native share API on mobile
   - Clipboard fallback on desktop
   - No additional work needed

4. ⚠️ **Additional UI Polish** - Optional Step 6-7
   - Suspense boundaries (optional, questionable benefit)
   - Smooth transitions (optional)
   - Focus states (verify existing)
   - Touch targets (verify existing)
   - Aria-labels (audit existing)
   - **Recommendation:** Defer to post-MVP based on user feedback

**All critical Phase 4 requirements covered in Steps 1-5.**

### Notes for Agent 2 (Review)

**Context Preservation:**
- Complete build plan Phase 4 preserved verbatim
- All design specifications documented
- Existing implementation analysis complete
- Share functionality already working (no new work needed)

**Technical Validation Needed:**
- Verify skeleton component API matches planned usage
- Confirm Next.js loading.tsx and error.tsx patterns for Next.js 15
- Validate that current page already has proper caching (line 7: revalidate = 86400)

**Decision Points:**
- Suspense implementation (Step 6) - Recommend skipping for MVP
- UI Polish (Step 7) - Recommend skipping for MVP, defer to post-launch
- Share utility extraction - Recommend leaving inline (YAGNI)
- Toast notifications - Recommend deferring to future enhancement

**Testing Considerations:**
- Need to trigger error in page.tsx to test error boundary
- Need to simulate slow network to see loading states
- Need to verify no layout shift with skeleton screens
- Need to test keyboard navigation on all error pages

### Visual Design Validation

**Layout Consistency:**
- Skeleton screens match exact dimensions of real content ✓
- Error pages use same container widths and spacing ✓
- 404 page follows existing page structure ✓

**Color Palette:**
- Skeleton uses default `bg-muted` and `animate-pulse` ✓
- Error boundary uses `text-destructive` for error icon ✓
- 404 uses `text-primary` for large 404 number ✓
- All colors from existing design system ✓

**Typography:**
- Error pages use existing heading sizes (text-2xl, text-3xl) ✓
- 404 uses large display font (text-7xl sm:text-8xl) ✓
- Body text uses `text-muted-foreground` pattern ✓

**Spacing:**
- All components use existing spacing scale (space-y-6, gap-4, etc.) ✓
- Container uses consistent padding (px-4 py-8) ✓
- Responsive breakpoints match existing (sm:, md:, lg:) ✓

**Ready for Review Phase.**

Plan complete. Ready for review stage.

---

## Review Notes

**Review Date:** 2025-11-06 by Agent 2

### Requirements Coverage

✅ **All Phase 4 functional requirements addressed:**
- Loading States with Skeleton Screens (Steps 1-3) ✓
- Error Boundaries (Steps 4-5) ✓
- 404 Not Found Page ✓
- Share Functionality - Already implemented ✓
- Optional polish (Steps 6-7) - Correctly marked as optional ✓

✅ **Design specifications incorporated:**
- Next.js 15 file-based conventions properly used ✓
- User-friendly error messages planned ✓
- Development-only error details ✓
- Responsive layouts for all pages ✓
- Consistent color palette (semantic tokens) ✓

### Technical Validation

✅ **All file paths verified:**
- skeleton component needs installation (npx shadcn@latest add skeleton) ✓
- Button, Card components already installed ✓
- Next.js 15 error.tsx/loading.tsx/not-found.tsx patterns validated ✓
- Gift list components verified for skeleton dimension matching ✓

⚠️ **Critical Issues Identified and Resolved:**

**Issue 1: Skeleton Layout Mismatch**
- **Problem**: Plan used CSS Grid, actual implementation uses CSS Masonry Columns
- **Impact**: Would cause significant layout shift when content loads
- **Resolution**: Updated Step 2 to use masonry columns layout with break-inside-avoid wrappers
- **User Decision**: Option A - Match actual masonry layout

**Issue 2: Skeleton Image Height**
- **Problem**: Plan used fixed h-48 height, actual cards use dynamic aspect ratios
- **Impact**: Fixed height wouldn't match variable height cards → layout shift
- **Resolution**: Updated Step 2 to use 4:3 aspect ratio fallback (matches card default)
- **User Decision**: Option A - Use aspect ratio instead of fixed height

**Issue 3: Gap Spacing Mismatch**
- **Problem**: Plan used gap-4 only, actual uses responsive gap-4 md:gap-6
- **Resolution**: Updated to use responsive gap values

**Issue 4: Missing Masonry Wrapper**
- **Problem**: Plan missing break-inside-avoid wrapper div
- **Resolution**: Added wrapper div to Step 2 implementation

### Implementation Corrections Applied

**Step 2: Gift Card Skeleton Component - CORRECTED**

**Updated Implementation** (replaces lines 398-448):

```typescript
import { Skeleton } from '@/components/ui/skeleton';

/**
 * Gift Card Skeleton
 *
 * Loading placeholder matching the exact dimensions and layout
 * of the GiftCard component using CSS Masonry Columns.
 * Prevents layout shift during loading.
 */
export function GiftCardSkeleton() {
  return (
    <div className="rounded-lg border overflow-hidden bg-card shadow-sm">
      {/* Image placeholder - matches gift-card.tsx dynamic aspect ratio */}
      {/* Using 4:3 fallback aspect ratio (matches card default) */}
      <div
        className="relative w-full bg-muted"
        style={{ aspectRatio: '4/3' }}
      >
        <Skeleton className="w-full h-full rounded-none" />
      </div>

      <div className="p-4">
        {/* Title and heart placeholder */}
        <div className="flex items-start justify-between gap-2 mb-2">
          <Skeleton className="h-5 w-3/4" />  {/* Title */}
          <Skeleton className="h-5 w-5 rounded-full flex-shrink-0" />  {/* Heart icon */}
        </div>

        {/* Description lines */}
        <Skeleton className="h-3 w-full mb-2" />
        <Skeleton className="h-3 w-4/5 mb-3" />

        {/* Price and category */}
        <div className="flex items-center justify-between">
          <Skeleton className="h-6 w-20" />  {/* Price */}
          <Skeleton className="h-5 w-24 rounded-full" />  {/* Category badge */}
        </div>
      </div>
    </div>
  );
}

/**
 * Gift Grid Skeleton
 *
 * Masonry columns grid matching the GiftGrid component layout.
 * Uses CSS columns for proper masonry behavior.
 *
 * @param count - Number of skeleton cards to display (default: 6)
 */
export function GiftGridSkeleton({ count = 6 }: { count?: number }) {
  return (
    <div className="columns-1 md:columns-2 lg:columns-3 gap-4 md:gap-6">
      {Array.from({ length: count }).map((_, i) => (
        <div key={`skeleton-${i}`} className="break-inside-avoid mb-4 md:mb-6">
          <GiftCardSkeleton />
        </div>
      ))}
    </div>
  );
}
```

**Key Changes from Original Plan:**
1. ✅ **Layout**: Changed from `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3` to `columns-1 md:columns-2 lg:columns-3`
2. ✅ **Gap**: Changed from `gap-4 mt-8` to `gap-4 md:gap-6` (matches actual responsive spacing)
3. ✅ **Wrapper**: Added `<div className="break-inside-avoid mb-4 md:mb-6">` wrapper around each skeleton
4. ✅ **Image**: Changed from `<Skeleton className="h-48 w-full mb-3 rounded-md" />` to aspect ratio approach with `style={{ aspectRatio: '4/3' }}`
5. ✅ **Structure**: Matches actual card structure with proper p-4 padding on content area

**Step 3: Root Loading State - CORRECTED**

**Updated category filter skeleton** (replaces lines 500-508):

```typescript
{/* Category Filter Skeleton */}
<div className="mb-6 flex justify-center gap-2 flex-wrap">
  <Skeleton className="h-9 w-16" />   {/* "All" pill */}
  <Skeleton className="h-9 w-28" />   {/* "Essentials" */}
  <Skeleton className="h-9 w-32" />   {/* "Experiences" */}
  <Skeleton className="h-9 w-24" />   {/* "Big Items" */}
  <Skeleton className="h-9 w-24" />   {/* "Donation" */}
  <Skeleton className="h-9 w-36" />   {/* "Your Favorites" (wider) */}
</div>
```

**Key Change:** Adjusted pill widths to better match actual category filter text lengths

### User Decisions (All Option A Selected)

1. ✅ **Skeleton Layout Pattern**: Use masonry columns to match actual layout
2. ✅ **Skeleton Image Height**: Use 4:3 aspect ratio fallback (matches card default)
3. ✅ **Loading State Complexity**: Fix skeleton properly to match masonry
4. ✅ **Optional Polish Scope**: Skip Steps 6-7 for MVP, focus on core Steps 1-5
5. ✅ **Share Utility Extraction**: Leave inline (YAGNI - only used once)

### Scope Clarifications

**IN SCOPE - Steps 1-5 (Core MVP):**
- ✅ Step 1: Install skeleton component
- ✅ Step 2: Create masonry skeleton matching actual layout (CORRECTED)
- ✅ Step 3: Create root loading state (CORRECTED)
- ✅ Step 4: Create root error boundary
- ✅ Step 5: Create 404 not found page

**OUT OF SCOPE - Steps 6-7 (Deferred to Post-MVP):**
- ⏭️ Step 6: Suspense boundaries - Page already has 24-hour cache, unnecessary complexity
- ⏭️ Step 7: Optional polish - Transitions, focus states audit, touch targets verification, aria-labels
- ⏭️ Share utility extraction - Already working inline, no need to extract

**Rationale for Deferrals:**
- Suspense adds complexity with minimal benefit given existing 24-hour page caching
- Accessibility features likely already in place (existing components from shadcn)
- Can add polish incrementally post-launch based on user feedback
- Keeps MVP focused on core production requirements

### Risk Assessment

**LOW RISK** - All issues resolved:
- ✅ Layout mismatch corrected (masonry instead of grid)
- ✅ Image height strategy corrected (aspect ratio instead of fixed)
- ✅ Responsive gap values corrected
- ✅ Masonry wrapper structure added
- ✅ CSS-only changes, no breaking modifications
- ✅ New files only, no changes to existing pages
- ✅ Next.js automatic file-based conventions (zero configuration)

### Accessibility & UX Validation

✅ **Mobile-first approach confirmed:**
- Responsive skeleton layouts match actual responsive behavior
- Error pages stack buttons on mobile
- All touch targets adequate size (Button component size="lg")
- Native share API usage on mobile devices

✅ **Error handling validated:**
- User-friendly messages without technical jargon
- Clear recovery actions (Try Again, Go Home)
- Development-only error details
- Visual error indicators (icons, colors)

### Performance Validation

✅ **Core Web Vitals considerations:**
- Skeleton screens prevent Cumulative Layout Shift (CLS)
- Loading states don't add JavaScript overhead
- Error boundaries don't impact normal page performance
- No bundle size increase (skeleton is CSS only)

✅ **Caching strategy validated:**
- Page-level 24-hour revalidation already in place (app/page.tsx line 7)
- Skeleton shown only during initial navigation or cache revalidation
- Loading states very brief with existing caching

### Contributing.md Compliance

✅ **All principles followed:**
- Simplicity: Uses Next.js built-in conventions ✓
- No duplication: Reuses Button component, follows existing patterns ✓
- One source of truth: Skeleton matches actual page layout ✓
- File size: All files under 150 lines ✓
- Real data: No mocks ✓
- Human-first headers: Clear documentation ✓
- Security: No concerns ✓

### Execution-Ready Assessment

**CONFIRMED - Ready for Discovery** ✅

**All requirements addressed:**
- [x] Every requirement has corresponding corrected plan steps
- [x] All ambiguities resolved (layout pattern, image height, scope)
- [x] Technical approach validated and corrected
- [x] No unanswered questions remain
- [x] Implementation path is crystal clear

**Pre-implementation checklist ready:**
- [x] Component dimensions match actual cards
- [x] Layout structure matches masonry columns
- [x] Responsive breakpoints match existing
- [x] Color tokens use semantic values
- [x] Error pages follow existing patterns

**Next Agent: Agent 3 (Discovery)** will verify:
- Skeleton component API from shadcn
- Next.js 15 error boundary patterns
- Component installation verification
- No breaking changes to existing code

### Review Complete

**Status:** All clarifications resolved, plan corrected, ready for Discovery phase.

**Estimated Implementation Time:** 45-60 minutes for Steps 1-5 (core MVP requirements)

**Success Criteria Clear:** Zero layout shift, user-friendly error handling, production-ready loading states.

---

## Technical Discovery (Agent 3)

### Discovery Date
2025-11-06

### Component Identification Verification

**Target Pages:**
- Home page (`app/page.tsx`) - Main landing page with gift grid
- All app routes - Error boundaries and loading states

**Verification Status:**
- ✅ Gift grid component correctly identified (`components/gift-list/gift-grid.tsx`)
- ✅ Gift card component confirmed (`components/gift-list/gift-card.tsx`)
- ✅ Masonry layout pattern verified (CSS columns, not grid)
- ✅ Dynamic aspect ratio system confirmed
- ✅ No existing error.tsx, loading.tsx, or not-found.tsx files (need to create)

### MCP Research Results

#### Skeleton Component Research

**Status:** ❌ NOT CURRENTLY INSTALLED
**Installation Required:** `npx shadcn@latest add skeleton`

**MCP Query Result:**
- Query: `mcp_shadcn-ui-server_get-component-docs("skeleton")`
- Result: 404 Not Found (component not yet in project)
- **Action Required:** Install before implementation

**Expected Component API (Standard shadcn pattern):**
```typescript
// Based on shadcn standard patterns and existing components
import { cn } from "@/lib/utils"

function Skeleton({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn("animate-pulse rounded-md bg-muted", className)}
      {...props}
    />
  )
}
```

**Verification:**
- ✅ Tailwind `animate-pulse` available via `tailwindcss-animate` plugin (tailwind.config.ts line 77)
- ✅ `bg-muted` color token defined in globals.css (line 18 for light mode, line 75 for dark mode)
- ✅ Standard div-based component pattern matches existing shadcn components

#### Button Component Verification

**Status:** ✅ INSTALLED AND VERIFIED
**Location:** `components/ui/button.tsx`

**API Confirmed:**
- `variant`: default, destructive, outline, secondary, ghost, link
- `size`: default, sm, lg, icon
- `asChild`: boolean (Radix Slot support)
- Focus states: `focus-visible:ring` included
- Component uses `class-variance-authority` for variants

**Relevant for Task:**
- ✅ `size="lg"` available for error page CTAs (h-10 rounded-md px-8)
- ✅ `variant="outline"` available for secondary actions
- ✅ All accessibility features present (focus-visible states)

#### Card Component Verification

**Status:** ✅ INSTALLED AND VERIFIED
**Location:** `components/ui/card.tsx`

**API Confirmed:**
- Card: Base container with `rounded-xl bg-card text-card-foreground shadow`
- CardContent: `p-6 pt-0` default padding
- Other exports: CardHeader, CardTitle, CardDescription, CardFooter

**Relevant for Task:**
- ✅ Skeleton cards should use same `rounded-lg border` classes as GiftCard
- ✅ `bg-card` semantic token available for consistent card backgrounds

### Layout Pattern Verification

#### Gift Grid Masonry Layout

**Verified in:** `components/gift-list/gift-grid.tsx` (line 70)

**Actual Layout:**
```typescript
<div className="columns-1 md:columns-2 lg:columns-3 gap-4 md:gap-6">
  {displayedItems.map((item) => (
    <div key={item.id} className="break-inside-avoid mb-4 md:mb-6">
      <GiftCard item={item} ... />
    </div>
  ))}
</div>
```

**Critical Findings:**
- ✅ Uses CSS columns (NOT grid) for masonry effect
- ✅ Responsive gaps: `gap-4 md:gap-6`
- ✅ Wrapper div with `break-inside-avoid` prevents column breaks
- ✅ Responsive margins: `mb-4 md:mb-6`
- ⚠️ Skeleton must match this exact structure to prevent layout shift

#### Gift Card Component Structure

**Verified in:** `components/gift-list/gift-card.tsx` (lines 65-139)

**Actual Card Structure:**
```typescript
<Card className="relative overflow-hidden cursor-pointer shadow-sm hover:shadow-md hover:scale-[1.02]">
  {/* Image with dynamic aspect ratio */}
  <div className="relative w-full bg-muted" style={{ aspectRatio: aspectRatio.toString() }}>
    <Image ... />
  </div>
  
  <CardContent className="p-4">
    {/* Title and heart */}
    <div className="flex items-start justify-between gap-2 mb-2">
      <h3 className="font-semibold text-lg line-clamp-1">{item.title}</h3>
      <button><Heart className="w-5 h-5" /></button>
    </div>
    
    {/* Description */}
    <p className="text-sm text-muted-foreground line-clamp-2 mb-3">{item.description}</p>
    
    {/* Price and category */}
    <div className="flex items-center justify-between">
      <span className="font-bold text-lg">€{item.price}</span>
      <Badge variant="outline">{categoryLabels[item.category]}</Badge>
    </div>
  </CardContent>
</Card>
```

**Critical Findings:**
- ✅ Dynamic aspect ratio: `item.image_width / item.image_height` (lines 24-29)
- ✅ Fallback ratio: `4/3` for items without dimensions
- ✅ CardContent uses `p-4` (not default p-6)
- ✅ Title: `text-lg font-semibold`
- ✅ Description: `text-sm text-muted-foreground line-clamp-2`
- ✅ Price: `text-lg font-bold`
- ✅ Heart button: `w-5 h-5`
- ⚠️ Skeleton must match these exact dimensions

### Next.js File-Based Conventions Verification

**Next.js Version:** "latest" (package.json line 24)
**React Version:** 19.0.0 (package.json line 26)
**Project Config:** components.json confirms Next.js App Router with RSC enabled

**File Conventions Verified:**

1. **loading.tsx** - ✅ Automatic loading UI
   - File: `app/loading.tsx` (create new)
   - Behavior: Shown during navigation or data fetching
   - Type: Can be Server Component or Client Component
   - Activation: Automatic by Next.js when page loads

2. **error.tsx** - ✅ Error boundary
   - File: `app/error.tsx` (create new)
   - Behavior: Catches errors in route segment
   - Type: MUST be 'use client' directive
   - Props: `error` and `reset` function
   - Activation: Automatic by Next.js on error

3. **not-found.tsx** - ✅ 404 page
   - File: `app/not-found.tsx` (create new)
   - Behavior: Shown for non-existent routes
   - Type: Can be Server Component
   - Activation: Automatic by Next.js on 404 or `notFound()` call

**Existing Error Handling:**
- Current inline error handling in `app/page.tsx` (lines 17-31)
- Basic error display but no retry mechanism
- Will be replaced by proper error.tsx boundary

### Implementation Feasibility

#### ✅ All Requirements Feasible

**Component Installation:**
- [x] Skeleton component needs installation: `npx shadcn@latest add skeleton`
- [x] All other dependencies already installed
- [x] No version conflicts identified

**Layout Compatibility:**
- [x] Masonry column layout pattern confirmed
- [x] Dynamic aspect ratio system verified
- [x] Responsive gap values documented
- [x] Break-inside-avoid wrapper pattern validated

**Next.js Patterns:**
- [x] File-based conventions confirmed for Next.js 15
- [x] No breaking changes to existing code
- [x] All new files (no modifications to existing pages)

**Design System Integration:**
- [x] All color tokens defined (bg-muted, text-destructive, text-primary, etc.)
- [x] Shadow system in place
- [x] Border radius variables available
- [x] Typography scale confirmed

### CSS Component Integration Verification

#### Skeleton Component Default Styles

**Expected Skeleton Styles:**
```typescript
className="animate-pulse rounded-md bg-muted"
```

**Integration Check:**
- ✅ `animate-pulse`: Available via tailwindcss-animate plugin
- ✅ `bg-muted`: Light mode hsl(356.67 20.45% 82.75%), Dark mode hsl(24 8.77% 11.18%)
- ✅ `rounded-md`: calc(var(--radius) - 2px) where --radius = 0.8rem
- ✅ No conflicts with masonry column layout

**Override Strategy:**
- No overrides needed for skeleton base component
- Custom dimensions applied per skeleton card element
- Aspect ratio applied via inline style (matches gift card pattern)

**Visual Debugging Recommendation:**
- Not needed - skeleton is simple pulse animation
- Layout matching verified via exact dimension replication

### Required Installations

```bash
# Install skeleton component from shadcn/ui
npx shadcn@latest add skeleton
```

**Installation Impact:**
- Bundle size: ~1KB (minimal CSS + animate-pulse)
- Dependencies: None (uses existing Tailwind utilities)
- Side effects: None (standalone component)

### Technical Blockers

**❌ NO BLOCKING ISSUES FOUND**

All technical requirements validated:
- [x] Skeleton component installable
- [x] Layout patterns confirmed
- [x] Component APIs verified
- [x] Next.js conventions validated
- [x] Design tokens available
- [x] No version conflicts

### Discovery Summary

- **All Components Available**: ✅ Yes (after skeleton installation)
- **Technical Blockers**: None
- **Ready for Implementation**: Yes
- **Special Notes**:
  - Skeleton must use masonry columns layout (NOT grid)
  - Skeleton must use 4:3 aspect ratio for images (matches card default)
  - Skeleton must have break-inside-avoid wrapper
  - Skeleton must use responsive gap values (gap-4 md:gap-6)
  - Error boundary MUST be 'use client' component
  - All new files, no modifications to existing pages

### Pre-Implementation Checklist

- [x] Skeleton component installation command ready
- [x] Gift card exact dimensions documented
- [x] Masonry layout structure verified
- [x] Responsive breakpoints confirmed
- [x] Color semantic tokens validated
- [x] Next.js file conventions verified
- [x] Button component API confirmed
- [x] No breaking changes identified

### Files for Implementation

**New Files to Create:**
1. `components/ui/skeleton.tsx` - Install via CLI command
2. `components/ui/skeleton-card.tsx` - Custom gift card skeleton with masonry layout
3. `app/loading.tsx` - Root loading state with skeleton grid
4. `app/error.tsx` - Root error boundary (must be 'use client')
5. `app/not-found.tsx` - 404 page

**Files to Reference (No Changes):**
- `components/gift-list/gift-card.tsx` - For exact dimensions
- `components/gift-list/gift-grid.tsx` - For layout pattern
- `components/ui/button.tsx` - For error page buttons
- `app/globals.css` - For color tokens

### Stage Update

**Previous Stage:** Review - Confirmed
**Current Stage:** Technical Discovery Complete
**Next Stage:** Ready for Execution (Agent 4)

### Time Tracking

**Discovery Duration:** ~10 minutes
- MCP queries: 3 minutes
- File verification: 4 minutes
- Layout analysis: 2 minutes
- Documentation: 1 minute

**Status:** Discovery complete within target timeframe (5-10 minutes)

---

## Implementation (Agent 4)

### Implementation Date
2025-11-06

### Stage Update

**Previous Stage:** Technical Discovery Complete
**Current Stage:** Ready for Manual Testing

### Implementation Summary

All 5 core MVP components have been successfully implemented:

1. ✅ **Skeleton Component Installed** - `components/ui/skeleton.tsx`
2. ✅ **Gift Card Skeleton Created** - `components/ui/skeleton-card.tsx`
3. ✅ **Root Loading State Created** - `app/loading.tsx`
4. ✅ **Root Error Boundary Created** - `app/error.tsx`
5. ✅ **404 Not Found Page Created** - `app/not-found.tsx`

### Implementation Notes

#### Step 1: Skeleton Component Installation
- **Command**: `npx shadcn@latest add skeleton`
- **Result**: Successfully installed `components/ui/skeleton.tsx`
- **Component API**: Uses `bg-accent` (not bg-muted as expected), `animate-pulse`, standard div-based component
- **No Issues**: Installation completed cleanly

#### Step 2: Gift Card Skeleton Component
- **File**: `components/ui/skeleton-card.tsx` (60 lines)
- **Key Features Implemented**:
  - ✅ Masonry columns layout (`columns-1 md:columns-2 lg:columns-3`)
  - ✅ 4:3 aspect ratio for image placeholder using `style={{ aspectRatio: '4/3' }}`
  - ✅ Responsive gaps (`gap-4 md:gap-6`)
  - ✅ Break-inside-avoid wrapper for masonry behavior
  - ✅ Matches exact GiftCard component dimensions (p-4, h-5 title, h-3 description, etc.)
  - ✅ Configurable count parameter (default: 6 cards)
- **Layout Accuracy**: Follows corrected masonry pattern from Agent 2 review (NOT grid)
- **No Issues**: Component matches all specifications

#### Step 3: Root Loading State
- **File**: `app/loading.tsx` (35 lines)
- **Key Features Implemented**:
  - ✅ Hero section skeleton (h-12 title, h-4 description)
  - ✅ Category filter skeleton (6 pills with adjusted widths: w-16, w-28, w-32, w-24, w-24, w-36)
  - ✅ Gift grid skeleton (6 cards using GiftGridSkeleton component)
  - ✅ Matches exact layout of app/page.tsx (container, spacing, structure)
  - ✅ Server Component (no client-side JavaScript)
- **Automatic Activation**: Next.js will show this during page navigation/data fetching
- **No Issues**: Layout matches actual page structure

#### Step 4: Root Error Boundary
- **File**: `app/error.tsx` (92 lines)
- **Key Features Implemented**:
  - ✅ 'use client' directive (required for error boundaries)
  - ✅ useEffect for error logging (console in dev, TODO for production service)
  - ✅ User-friendly error message ("Something went wrong!")
  - ✅ Error icon SVG visual (warning triangle in destructive/10 background)
  - ✅ Try Again button (calls reset() to re-render)
  - ✅ Go Home button (navigates to /)
  - ✅ Development-only error details (collapsible with error.message and stack)
  - ✅ Responsive layout (flex-col on mobile, flex-row on sm+)
  - ✅ Button component integration (size="lg", variants)
- **Automatic Activation**: Next.js catches all uncaught errors in route
- **No Issues**: Error handling complete with all planned features

#### Step 5: 404 Not Found Page
- **File**: `app/not-found.tsx` (37 lines)
- **Key Features Implemented**:
  - ✅ Large 404 number (text-7xl sm:text-8xl in primary color)
  - ✅ Friendly message ("Page Not Found", "doesn't exist or has been moved")
  - ✅ Return to Gift List button (size="lg")
  - ✅ Optional quick links (Home, Admin)
  - ✅ Responsive typography
  - ✅ Server Component (no client directive needed)
- **Automatic Activation**: Next.js shows for non-existent routes
- **No Issues**: All specifications met

#### Step 6: Build Verification
- **Command**: `npm run build`
- **Result**: ✅ Build completed successfully
  - Compiled successfully in 3.4s
  - Generated 21 static pages
  - TypeScript checks passed
  - `/_not-found` route appears in build output
- **No Errors**: Clean build with all new components

### Code Changes

**New Files Created:**
1. `components/ui/skeleton.tsx` - Installed via shadcn CLI
2. `components/ui/skeleton-card.tsx` - Custom skeleton components (GiftCardSkeleton, GiftGridSkeleton)
3. `app/loading.tsx` - Root level loading state with skeleton screens
4. `app/error.tsx` - Root error boundary with user-friendly error handling
5. `app/not-found.tsx` - 404 page with brand-consistent styling

**Files Modified:**
- None - All changes are new files only, zero modifications to existing code

**Dependencies Added:**
- Skeleton component from shadcn/ui (minimal CSS, ~1KB)
- No additional npm packages required

### Functionality Preserved

✅ **No Breaking Changes:**
- All existing pages unchanged
- Gift grid and card components untouched
- Payment and thank-you flows preserved
- Admin dashboard unchanged
- Share functionality remains in thank-you page (already implemented)

✅ **Automatic Next.js Integration:**
- loading.tsx automatically shown during navigation
- error.tsx automatically catches errors
- not-found.tsx automatically shown for 404s
- Zero configuration required - file-based conventions work out of the box

### Testing Results

**Build Verification:**
- ✅ Next.js build: Compiled successfully
- ✅ TypeScript: No errors
- ✅ All routes generated correctly
- ✅ 21 pages built including new `/_not-found`

**Component Structure Validation:**
- ✅ Skeleton component exports correctly
- ✅ Gift card skeleton uses masonry layout
- ✅ Loading state matches page structure
- ✅ Error boundary is client component
- ✅ 404 page is server component

### Optional Enhancements Skipped

As per Agent 2 review recommendations, the following optional steps were **intentionally skipped** for MVP:

⏭️ **Step 6: Suspense Boundaries** - Page already has 24-hour caching, Suspense adds complexity for minimal benefit
⏭️ **Step 7: Optional Polish** - Transitions, focus states audit, touch targets, aria-labels - can be added post-launch based on feedback
⏭️ **Share Utility Extraction** - Already working inline in thank-you page, no need to extract (YAGNI principle)
⏭️ **Toast Notifications** - Alerts work for MVP, toast is enhancement not requirement

**Rationale**: MVP focus on core production requirements (loading states, error boundaries, 404 page). Polish can be added incrementally post-launch.

---

## Manual Test Instructions

### Setup for Testing

1. **Development Server**: Ensure dev server is running at http://localhost:3000
   ```bash
   npm run dev
   # OR if using parallel development:
   pnpm run dev:parallel  # Test at http://localhost:3001
   ```

2. **Browser**: Open in modern browser (Chrome, Firefox, Safari, Edge)
3. **DevTools**: Open browser DevTools console to monitor for errors

### Test 1: Loading State (app/loading.tsx)

**Purpose**: Verify skeleton screens show during page load and prevent layout shift

**Steps:**
1. Navigate to home page (`http://localhost:3000`)
2. Observe initial load (you may need to throttle network to see skeleton longer)
3. Expected behavior:
   - ✅ Skeleton screens appear during load
   - ✅ Hero section skeleton (large title + description placeholders)
   - ✅ Category filter skeleton (6 pill-shaped placeholders)
   - ✅ Gift grid skeleton (6 card placeholders in masonry columns)
   - ✅ Skeleton animates with pulse effect
   - ✅ No layout shift when real content loads
   - ✅ Real content replaces skeleton smoothly

**Slow Network Simulation** (Optional):
1. Open DevTools → Network tab
2. Set throttling to "Slow 3G" or "Fast 3G"
3. Refresh page to see skeleton for longer duration
4. Verify skeleton layout matches real content layout

**Pass Criteria:**
- [ ] Skeleton shows during initial page load
- [ ] Skeleton layout matches real content (no shift)
- [ ] Skeleton animates with pulse effect
- [ ] Smooth transition to real content

### Test 2: Error Boundary (app/error.tsx)

**Purpose**: Verify error boundary catches errors and provides user-friendly recovery

**Testing Method** (Choose one):

**Option A: Temporarily Trigger Error in Code**
1. Open `app/page.tsx`
2. Add `throw new Error('Test error');` at the top of the Home() function
3. Save and refresh browser
4. Verify error boundary displays
5. Remove the test error line

**Option B: Navigate to Error-Prone Route** (if any exist)

**Expected Behavior:**
- ✅ Error icon displays (warning triangle in destructive red background)
- ✅ Heading reads "Something went wrong!"
- ✅ Friendly message without technical details (in production mode)
- ✅ Two action buttons visible:
  - "Try Again" button (primary, large)
  - "Go Home" button (outline, large)
- ✅ Development error details show in collapsible section (dev mode only)
  - Click "Error details (development only)" to expand
  - Should show error.message and stack trace
- ✅ Buttons stack vertically on mobile, horizontal on desktop

**Interactive Tests:**
1. Click "Try Again" button
   - Expected: Error boundary resets, page attempts to re-render
2. Click "Go Home" button
   - Expected: Navigates to home page (/)

**Pass Criteria:**
- [ ] Error boundary catches and displays error
- [ ] User-friendly message shows (no raw error in production)
- [ ] Error icon visible and styled correctly
- [ ] "Try Again" button resets error state
- [ ] "Go Home" button navigates to home
- [ ] Development error details show in dev mode only
- [ ] Responsive layout (buttons stack on mobile)
- [ ] No console errors unrelated to test

### Test 3: 404 Not Found Page (app/not-found.tsx)

**Purpose**: Verify 404 page shows for non-existent routes with clear navigation

**Steps:**
1. Navigate to non-existent route: `http://localhost:3000/this-route-does-not-exist`
2. Expected behavior:
   - ✅ Large "404" number displays (primary color, very large font)
   - ✅ Heading reads "Page Not Found"
   - ✅ Friendly message: "The page you're looking for doesn't exist or has been moved"
   - ✅ "Return to Gift List" button visible (large, primary)
   - ✅ Optional quick links section below:
     - "Home" link
     - "Admin" link (separated by bullet)
   - ✅ Page uses same layout and styling as other pages

**Interactive Tests:**
1. Click "Return to Gift List" button
   - Expected: Navigates to home page (/)
2. Click "Home" quick link
   - Expected: Navigates to home page (/)
3. Click "Admin" quick link
   - Expected: Navigates to admin dashboard (/protected/upload)

**Responsive Testing:**
- Desktop (1920px): Large 404 number, all elements centered
- Tablet (768px): 404 number slightly smaller, layout maintained
- Mobile (375px): 404 number scales appropriately, text remains readable

**Pass Criteria:**
- [ ] 404 page displays for invalid routes
- [ ] Large "404" number visible in primary color
- [ ] Friendly, non-technical message
- [ ] "Return to Gift List" button works
- [ ] Quick links work (Home, Admin)
- [ ] Responsive typography (7xl → 8xl)
- [ ] No console errors

### Test 4: Skeleton Layout Accuracy

**Purpose**: Verify skeleton screens match exact dimensions of real content (zero layout shift)

**Steps:**
1. Open home page with Network throttling (Slow 3G)
2. Take screenshot of skeleton state
3. Wait for real content to load
4. Take screenshot of real content
5. Compare screenshots:
   - ✅ Card positions should match exactly
   - ✅ No vertical or horizontal shifting
   - ✅ Container widths identical
   - ✅ Spacing and gaps preserved

**Visual Comparison Checklist:**
- [ ] Skeleton cards use same masonry columns layout (1/2/3 cols responsive)
- [ ] Skeleton card images use 4:3 aspect ratio (matches fallback)
- [ ] Skeleton category pills match approximate text widths
- [ ] Skeleton hero title/description match real dimensions
- [ ] No layout "jump" when content loads

### Test 5: Cross-Browser Compatibility (Optional)

**Purpose**: Verify all new pages work across major browsers

**Browsers to Test:**
- [ ] Chrome/Edge (Chromium)
- [ ] Firefox
- [ ] Safari (macOS/iOS)

**Quick Check for Each Browser:**
1. Navigate to home page - verify skeleton shows
2. Navigate to invalid route - verify 404 page shows
3. All elements render correctly
4. No console errors specific to browser

### Test 6: Keyboard Navigation & Accessibility

**Purpose**: Verify error pages and 404 page are keyboard accessible

**Steps:**
1. Navigate to 404 page (`/invalid-route`)
2. Use Tab key to navigate through interactive elements:
   - [ ] "Return to Gift List" button receives focus
   - [ ] "Home" link receives focus
   - [ ] "Admin" link receives focus
   - [ ] Focus indicators visible for all elements
3. Press Enter on focused "Return to Gift List" button
   - Expected: Navigates to home

**Error Boundary Keyboard Test:**
1. Trigger error boundary (see Test 2)
2. Tab through buttons:
   - [ ] "Try Again" button receives focus
   - [ ] "Go Home" button receives focus
   - [ ] Error details summary (development only) receives focus
   - [ ] Focus rings visible
3. Press Enter on "Try Again"
   - Expected: Resets error state

**Pass Criteria:**
- [ ] All interactive elements keyboard accessible
- [ ] Focus indicators clearly visible
- [ ] Enter key activates buttons/links
- [ ] Logical tab order (top to bottom)

### Test 7: Mobile Responsive Behavior

**Purpose**: Verify all new pages work correctly on mobile devices

**Test on Mobile Viewport** (375px width in DevTools):

**Loading State:**
- [ ] Skeleton shows in single column (masonry columns-1)
- [ ] Hero skeleton centered and readable
- [ ] Category pills wrap correctly

**Error Boundary:**
- [ ] Error icon sized appropriately
- [ ] Message text readable and properly sized
- [ ] Buttons stack vertically (flex-col)
- [ ] Both buttons visible and tappable
- [ ] No horizontal scrolling

**404 Page:**
- [ ] "404" number sized appropriately (text-7xl)
- [ ] Message text wraps and remains readable
- [ ] Button sized correctly (size="lg")
- [ ] Quick links stack/wrap properly
- [ ] No horizontal scrolling

**Pass Criteria:**
- [ ] All pages readable on mobile
- [ ] No horizontal scrolling
- [ ] Touch targets adequate size (44x44px minimum)
- [ ] Text remains legible

### Final Approval Criteria

✅ **Move to Complete** if:
- All loading states show during page navigation
- Error boundary catches errors with friendly messages
- 404 page displays for invalid routes
- No layout shift when skeleton transitions to real content
- All buttons and links functional
- No console errors in production mode
- Keyboard navigation works
- Mobile responsive behavior correct

❌ **Move to Needs Work** if:
- Layout shift occurs when content loads
- Error messages show raw technical details in production
- Broken navigation (buttons/links don't work)
- Console errors present
- Poor mobile experience

### Performance Validation (Optional)

**Core Web Vitals Check:**

Using Chrome DevTools Lighthouse:
1. Run Lighthouse audit on home page
2. Check metrics:
   - [ ] CLS (Cumulative Layout Shift) < 0.1 (should improve with skeleton)
   - [ ] LCP (Largest Contentful Paint) < 2.5s
   - [ ] FID/INP (Interactivity) acceptable

**Expected Impact:**
- CLS should improve (skeleton prevents layout shift)
- No negative impact on LCP or interactivity
- No additional JavaScript bundle increase

---

### Implementation Complete

**Status**: ✅ All core MVP requirements (Steps 1-5) implemented successfully

**Ready for Manual Testing**: Yes

**Next Steps**:
1. User performs manual testing following instructions above
2. Any issues found → return to Agent 4 for fixes
3. All tests pass → Agent 5 marks task as complete
4. Optional enhancements (Steps 6-7) can be addressed in future iteration based on feedback

**Estimated Testing Time**: 20-30 minutes for comprehensive testing

