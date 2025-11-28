# Dashboard Account, Billing & Support Features

## Original Request

"I'm looking at http://localhost:3000/dashboard?demo=true - and thinking this is missing a few things like; link for support, a link for your account, a link for billing - e.g. links to stripe billing to cancel - is that all something in zebra-planning/user-testing-app/mvp-implementation-plan.md or something missed and we should consider? Anything else that might be missing based on this?

...can you please make a plan for all the missing items above - make sure you include any database changes and other things."

**Items identified as missing:**
1. Support link
2. Account settings link
3. Billing link (Stripe Customer Portal for subscription management/cancellation)
4. Upgrade prompt when tests remaining = 0

---

## Clarification Decisions

**Account Settings Approach:** Option B - Simple modal with basic info display (email, tier) and email-based change requests

**Support Link Destination:** Option A - `mailto:support@zebradesign.io` (In-app chat widget added to future-features.md for later)

---

## Design Context

### Current Dashboard State
- **URL**: http://localhost:3000/dashboard?demo=true
- **User Menu Location**: Top-right dropdown showing user email with only "Logout" option
- **Stats Bar**: Shows "Tests Remaining: 0" but no action to upgrade
- **Missing Elements**: No support, account, or billing links anywhere

### Visual Design Direction
- Extend existing user dropdown menu in `app/dashboard/page.tsx`
- Add Account Settings modal (not separate page)
- Add upgrade banner/prompt in dashboard when `testsRemaining === 0`
- Follow existing shadcn/ui patterns (DropdownMenu, Button, Card, Dialog components)
- Use lucide-react icons for consistency (Settings, CreditCard, HelpCircle, Zap)

---

## Codebase Context

### Existing Files to Modify

1. **`app/dashboard/page.tsx`** (~722 lines)
   - Location: `/Users/charlieellington1/conductor/user-testing-app-2/.conductor/vienna/app/dashboard/page.tsx`
   - Current user dropdown: in JSX near end of file
   - Subscription tier check: `user?.user_metadata?.subscription_tier`
   - Tests remaining calculation: uses `subscriptionTier` variable
   - Already imports: Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter

2. **`zebra-planning/user-testing-app/auth-and-payments-implementation.md`**
   - Contains Stripe integration plan but **missing Customer Portal setup**
   - Has checkout API route (`/api/stripe/checkout`) but no portal route

### New Files to Create

1. **`app/api/stripe/portal/route.ts`** - Create Stripe Customer Portal session

### Database Considerations

**No new database schema required.** The existing `user_metadata` in Supabase auth already stores:
- `subscription_tier`: 'free' | 'pro' | 'expert'
- `stripe_customer_id`: string | null
- `stripe_subscription_id`: string | null (for active subscriptions)

The Stripe Customer Portal will read directly from Stripe's records linked via `stripe_customer_id`.

### Stripe Customer Portal Requirements

The Stripe Customer Portal must be configured in Stripe Dashboard:
1. Go to **Settings** → **Billing** → **Customer portal**
2. Enable portal features:
   - View invoices and payment history
   - Update payment method
   - Cancel subscription
   - (Optional) Update billing information
3. Configure branding to match Zebra Design

---

## Plan

### Step 1: Create Stripe Customer Portal API Route

**File**: `app/api/stripe/portal/route.ts` (NEW - ~40 lines)

```typescript
// Creates a Stripe Customer Portal session for subscription management
import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { stripe } from '@/lib/stripe';

export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const customerId = user.user_metadata?.stripe_customer_id;

  if (!customerId) {
    return NextResponse.json(
      { error: 'No billing account found. Please upgrade first.' },
      { status: 400 }
    );
  }

  try {
    const session = await stripe.billingPortal.sessions.create({
      customer: customerId,
      return_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard`,
    });

    return NextResponse.json({ url: session.url });
  } catch (error) {
    console.error('Portal session error:', error);
    return NextResponse.json(
      { error: 'Failed to create billing portal session' },
      { status: 500 }
    );
  }
}
```

**Dependencies**: Uses existing `lib/stripe.ts` - no changes needed

---

### Step 2: Add Account Settings Modal State

**File**: `app/dashboard/page.tsx`
**Location**: After other useState declarations (~line 88)

```typescript
// Account settings modal state
const [showAccountModal, setShowAccountModal] = useState(false);
```

---

### Step 3: Update Dashboard User Dropdown Menu

**File**: `app/dashboard/page.tsx`
**Location**: Find the user dropdown menu (DropdownMenuContent)

**Changes**:
1. Add "Account Settings" menu item with Settings icon → opens modal
2. Add "Billing" menu item with CreditCard icon (only for users with stripe_customer_id)
3. Add "Support" menu item with HelpCircle icon
4. Add separator between items

**Updated code**:
```tsx
<DropdownMenuContent align="end">
  <DropdownMenuLabel>My Account</DropdownMenuLabel>
  <DropdownMenuSeparator />
  <DropdownMenuItem onClick={() => setShowAccountModal(true)}>
    <Settings className="mr-2 h-4 w-4" />
    Account Settings
  </DropdownMenuItem>
  {user?.user_metadata?.stripe_customer_id && (
    <DropdownMenuItem onClick={handleBillingClick}>
      <CreditCard className="mr-2 h-4 w-4" />
      Billing
    </DropdownMenuItem>
  )}
  <DropdownMenuItem onClick={handleSupportClick}>
    <HelpCircle className="mr-2 h-4 w-4" />
    Support
  </DropdownMenuItem>
  <DropdownMenuSeparator />
  <DropdownMenuItem onClick={handleLogout}>
    <LogOut className="mr-2 h-4 w-4" />
    Logout
  </DropdownMenuItem>
</DropdownMenuContent>
```

**New imports needed**:
```tsx
import { Settings, CreditCard, HelpCircle, Zap } from 'lucide-react';
```

---

### Step 4: Add Handler Functions

**File**: `app/dashboard/page.tsx`
**Location**: After other handler functions (near handleLogout)

```typescript
// Handle billing click - opens Stripe Customer Portal
const handleBillingClick = async () => {
  if (isDemo) {
    toast.info('Billing portal is not available in demo mode');
    return;
  }

  try {
    const response = await fetch('/api/stripe/portal', {
      method: 'POST',
    });
    const data = await response.json();

    if (data.url) {
      window.location.href = data.url;
    } else {
      toast.error(data.error || 'Unable to open billing portal');
    }
  } catch (error) {
    console.error('Billing portal error:', error);
    toast.error('Failed to open billing portal');
  }
};

// Handle support click - opens email client
const handleSupportClick = () => {
  window.location.href = 'mailto:support@zebradesign.io?subject=User Testing App Support';
};
```

---

### Step 5: Add Account Settings Modal

**File**: `app/dashboard/page.tsx`
**Location**: After the Success Modal Dialog (near end of JSX, before closing `</div>`)

```tsx
{/* Account Settings Modal */}
<Dialog open={showAccountModal} onOpenChange={setShowAccountModal}>
  <DialogContent className="sm:max-w-md">
    <DialogHeader>
      <DialogTitle>Account Settings</DialogTitle>
    </DialogHeader>
    <div className="space-y-4 py-4">
      {/* Email Display */}
      <div className="space-y-2">
        <label className="text-sm font-medium text-muted-foreground">Email</label>
        <div className="flex items-center gap-2 p-3 bg-muted rounded-md">
          <Mail className="h-4 w-4 text-muted-foreground" />
          <span className="text-sm">{user?.email || 'demo@example.com'}</span>
        </div>
      </div>

      {/* Subscription Tier Display */}
      <div className="space-y-2">
        <label className="text-sm font-medium text-muted-foreground">Subscription</label>
        <div className="flex items-center gap-2 p-3 bg-muted rounded-md">
          <CreditCard className="h-4 w-4 text-muted-foreground" />
          <span className="text-sm capitalize">{subscriptionTier} Plan</span>
          {subscriptionTier === 'free' && (
            <Badge variant="secondary" className="ml-auto">Free</Badge>
          )}
          {subscriptionTier === 'pro' && (
            <Badge className="ml-auto">Pro</Badge>
          )}
        </div>
      </div>

      {/* Help Text */}
      <p className="text-sm text-muted-foreground">
        Need to change your email or account details?{' '}
        <a
          href="mailto:support@zebradesign.io?subject=Account Change Request"
          className="text-primary hover:underline"
        >
          Contact support
        </a>
      </p>
    </div>
    <DialogFooter>
      <Button variant="outline" onClick={() => setShowAccountModal(false)}>
        Close
      </Button>
      {subscriptionTier === 'free' && (
        <Button onClick={() => { setShowAccountModal(false); router.push('/pricing'); }}>
          Upgrade to Pro
        </Button>
      )}
    </DialogFooter>
  </DialogContent>
</Dialog>
```

**Additional import needed**:
```tsx
import { Mail } from 'lucide-react';
```

---

### Step 6: Add Upgrade Prompt Banner

**File**: `app/dashboard/page.tsx`
**Location**: After Quick Stats section, before Tests Table/Loading State

**Condition**: Show when `testsRemaining === 0 && subscriptionTier === 'free'`

```tsx
{/* Upgrade Prompt - shown when free tier has no tests remaining */}
{testsRemaining === 0 && subscriptionTier === 'free' && (
  <Card className="mb-8 border-primary/50 bg-primary/5">
    <CardContent className="flex items-center justify-between py-4">
      <div className="flex items-center gap-3">
        <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
          <Zap className="w-5 h-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">You've used all your free tests</p>
          <p className="text-sm text-muted-foreground">
            Upgrade to Pro for unlimited tests and premium features
          </p>
        </div>
      </div>
      <Button onClick={() => router.push('/pricing')}>
        Upgrade to Pro
        <ArrowRight className="w-4 h-4 ml-2" />
      </Button>
    </CardContent>
  </Card>
)}
```

---

### Step 7: Configure Stripe Customer Portal (Manual Step)

**Location**: Stripe Dashboard (not code)

1. Log in to Stripe Dashboard
2. Go to **Settings** → **Billing** → **Customer portal**
3. Configure portal settings:
   - **Headline**: "Manage your Zebra Design subscription"
   - **Privacy policy URL**: https://zebradesign.io/privacy
   - **Terms of service URL**: https://zebradesign.io/terms
4. Enable features:
   - ✅ Invoices and billing history
   - ✅ Update payment method
   - ✅ Cancel subscription
5. Save configuration

---

## Summary of Changes

| File | Action | Lines Changed |
|------|--------|---------------|
| `app/api/stripe/portal/route.ts` | CREATE | ~40 lines |
| `app/dashboard/page.tsx` | MODIFY | ~80 lines added |

### New Dependencies
None - uses existing packages (stripe, lucide-react, sonner)

### Database Changes
None required - uses existing `user_metadata` fields

### Environment Variables
None required - uses existing Stripe keys

### Manual Configuration
- Stripe Customer Portal configuration in Stripe Dashboard

---

## Testing Checklist

- [ ] Support link opens email client with correct address and subject
- [ ] Account Settings menu item opens modal
- [ ] Account modal displays user email correctly
- [ ] Account modal displays subscription tier correctly
- [ ] Account modal "Contact support" link works
- [ ] Account modal "Upgrade to Pro" button appears for free tier users
- [ ] Account modal "Upgrade to Pro" navigates to /pricing
- [ ] Billing menu item appears only for users with stripe_customer_id
- [ ] Billing link opens Stripe Customer Portal (for users with stripe_customer_id)
- [ ] Billing link shows error for users without stripe_customer_id
- [ ] Upgrade banner appears when tests remaining = 0 and tier = free
- [ ] Upgrade banner navigates to /pricing
- [ ] Demo mode shows appropriate toast messages for billing
- [ ] All new icons render correctly
- [ ] Dropdown menu maintains consistent styling

---

## Review Notes

**Clarifications Resolved:**
1. Account Settings: Using Option B (modal with info display) - adds ~40 lines of modal JSX
2. Support Link: Using Option A (mailto:) - simple and immediate, chat widget deferred to future-features.md

**Technical Validation:**
- ✓ All file paths verified
- ✓ Dialog component already imported in dashboard
- ✓ Badge component already imported in dashboard
- ✓ Stripe billingPortal.sessions.create is correct API method
- ✓ User metadata fields exist per auth-and-payments-implementation.md

**No outstanding issues** - plan is complete and ready for execution.

---

## Stage
Confirmed

## Priority
High

## Created
2025-11-28

## Files
- `app/api/stripe/portal/route.ts` (new)
- `app/dashboard/page.tsx` (modify)
