# Stage 4: Stripe Code Implementation

## Original Request

**From `zebra-planning/user-testing-app/auth-and-payments-implementation.md` Stage 4 (PRESERVED VERBATIM):**

Stage 4: Code Implementation covers the complete implementation of Stripe checkout integration for:
1. **Stripe Utility Library** (`lib/stripe.ts`) - Stripe client initialization and price constants
2. **Checkout API Route** (`app/api/stripe/checkout/route.ts`) - Create Stripe checkout sessions
3. **Webhook Handler** (`app/api/stripe/webhook/route.ts`) - Handle Stripe webhook events
4. **Update Signup Route** (`app/api/auth/signup-with-test/route.ts`) - Handle existing users, return session
5. **Update Pricing Page** (`app/pricing/page.tsx`) - Conditional messaging, Stripe redirect

**Target Flow:**
```
Enter Email → Immediately Signed In → Dashboard with Test Link
              ↓
         Welcome Email Sent (via Resend)
              ↓
         Upgrade to Pro/Expert → Stripe Checkout → Return as Paid User
```

**Pricing Tiers:**
- **Free Beta**: €0/mo - 2 tests/month, 5 testers/test
- **Pro**: €49/mo (recurring subscription)
- **Expert Analysis**: €300/test (one-time payment)

**Prerequisites Already Completed:**
- ✅ Stripe packages installed (`stripe` and `@stripe/stripe-js` in package.json)
- ✅ Stripe CLI installed and logged in
- ✅ Stripe live keys configured in .env.local
- ✅ Webhook secret configured
- ⏳ TODO: Create Pro and Expert products in Stripe Dashboard (Price IDs needed)

---

## Design Context

This is a backend/API implementation task - no visual design required.

**User Experience Flow:**
1. User selects tier on `/pricing` page
2. Free tier → Create account → Redirect to `/dashboard?welcome=true`
3. Paid tier → Create account → Redirect to Stripe Checkout → Return to `/dashboard?checkout=success&tier=pro`
4. Webhook updates user subscription tier in Supabase

**Stripe Checkout UI:**
- Hosted by Stripe (no custom UI needed)
- Returns to app via success_url/cancel_url

---

## Codebase Context

### Existing Files to Modify

**1. `app/api/auth/signup-with-test/route.ts`** (lines 1-123)
- Currently creates user account and claims anonymous test
- Need to add: Handle "User already registered" case with magic link
- Need to add: Return session object for immediate auth
- Need to add: Support for paid tier redirect flow

**2. `app/pricing/page.tsx`** (lines 1-359)
- Currently: Single submit flow for all tiers
- Need to add: Conditional "No credit card required" (free only)
- Need to add: Different button text ("Get Started Free" vs "Continue to Payment")
- Need to add: Stripe checkout redirect for paid tiers

### New Files to Create

**1. `lib/stripe.ts`**
- Stripe client initialization with API version
- Price ID constants from environment variables
- Type-safe exports

**2. `app/api/stripe/checkout/route.ts`**
- POST handler for creating checkout sessions
- Auth check via Supabase
- Create or get Stripe customer
- Store customer ID in user metadata
- Return checkout session URL

**3. `app/api/stripe/webhook/route.ts`**
- POST handler for Stripe webhooks
- Signature verification
- Handle events:
  - `checkout.session.completed` → Update user tier
  - `customer.subscription.deleted` → Downgrade to free
  - `invoice.payment_failed` → Log/notify

### Dependencies

**Already Installed:**
- `stripe`: ^20.0.0
- `@stripe/stripe-js`: ^8.5.3

**Environment Variables (from auth-and-payments-implementation.md):**
```bash
# Already configured in .env.local
STRIPE_SECRET_KEY=sk_live_xxx
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

# TODO: Add after creating products
STRIPE_PRO_PRICE_ID=price_xxx
STRIPE_EXPERT_PRICE_ID=price_xxx
```

### Supabase Integration

**User Metadata Fields (set during signup):**
```typescript
{
  subscription_tier: 'free' | 'pro' | 'expert',
  stripe_customer_id: string | null,
  first_test_id: string,
  email_verified: boolean
}
```

**Admin Operations (webhook):**
- Uses `supabaseAdmin` with service role key
- Updates user metadata via `auth.admin.updateUserById`

---

## Prototype Scope

This is a full-stack implementation, not a prototype. All functionality is production-ready.

**Scope Boundaries:**
- ✅ Create checkout sessions for Pro/Expert tiers
- ✅ Handle webhook events for subscription lifecycle
- ✅ Update user metadata on successful payment
- ✅ Support existing user magic link flow
- ❌ Email notifications for failed payments (marked TODO in webhook)
- ❌ Customer portal for subscription management (future)
- ❌ Invoice history/receipts (future)

---

## Plan

### Step 1: Create Stripe Utility Library

**File:** `lib/stripe.ts` (NEW)

**Implementation:**
```typescript
// lib/stripe.ts
// Stripe client configuration and price constants for checkout integration
import Stripe from 'stripe';

if (!process.env.STRIPE_SECRET_KEY) {
  throw new Error('STRIPE_SECRET_KEY is not set');
}

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
  apiVersion: '2024-11-20.acacia',
  typescript: true,
});

export const PRICES = {
  pro: process.env.STRIPE_PRO_PRICE_ID!,
  expert: process.env.STRIPE_EXPERT_PRICE_ID!,
} as const;

export type PriceTier = keyof typeof PRICES;
```

**Notes:**
- Uses latest Stripe API version
- Type-safe price constants
- Throws at startup if secret key missing

---

### Step 2: Create Checkout API Route

**File:** `app/api/stripe/checkout/route.ts` (NEW)

**Implementation:**
```typescript
// app/api/stripe/checkout/route.ts
// Creates Stripe checkout sessions for Pro and Expert tier upgrades
import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { stripe, PRICES, PriceTier } from '@/lib/stripe';

export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { tier, testId } = await request.json();

  if (!tier || !['pro', 'expert'].includes(tier)) {
    return NextResponse.json({ error: 'Invalid tier' }, { status: 400 });
  }

  const priceId = PRICES[tier as PriceTier];
  const isSubscription = tier === 'pro';

  try {
    // Create or get Stripe customer
    let customerId = user.user_metadata?.stripe_customer_id;

    if (!customerId) {
      const customer = await stripe.customers.create({
        email: user.email,
        metadata: {
          supabase_user_id: user.id,
        },
      });
      customerId = customer.id;

      // Store customer ID in user metadata
      await supabase.auth.updateUser({
        data: { stripe_customer_id: customerId },
      });
    }

    // Create checkout session
    const session = await stripe.checkout.sessions.create({
      customer: customerId,
      mode: isSubscription ? 'subscription' : 'payment',
      payment_method_types: ['card'],
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      success_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard?checkout=success&tier=${tier}`,
      cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/pricing?checkout=cancelled`,
      metadata: {
        user_id: user.id,
        tier,
        test_id: testId || '',
      },
    });

    return NextResponse.json({ url: session.url });
  } catch (error) {
    console.error('Stripe checkout error:', error);
    return NextResponse.json(
      { error: 'Failed to create checkout session' },
      { status: 500 }
    );
  }
}
```

**Notes:**
- Requires authenticated user
- Creates Stripe customer on first checkout
- Stores customer ID in Supabase user metadata
- Pro = subscription mode, Expert = payment mode

---

### Step 3: Create Webhook Handler

**File:** `app/api/stripe/webhook/route.ts` (NEW)

**Implementation:**
```typescript
// app/api/stripe/webhook/route.ts
// Handles Stripe webhook events for subscription lifecycle management
import { NextResponse } from 'next/server';
import { headers } from 'next/headers';
import { stripe } from '@/lib/stripe';
import { createClient } from '@supabase/supabase-js';

// Use service role for admin operations
const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

export async function POST(request: Request) {
  const body = await request.text();
  const headersList = await headers();
  const signature = headersList.get('stripe-signature');

  if (!signature || !process.env.STRIPE_WEBHOOK_SECRET) {
    return NextResponse.json({ error: 'Missing signature' }, { status: 400 });
  }

  let event;

  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    console.error('Webhook signature verification failed:', err);
    return NextResponse.json({ error: 'Invalid signature' }, { status: 400 });
  }

  try {
    switch (event.type) {
      case 'checkout.session.completed': {
        const session = event.data.object;
        const userId = session.metadata?.user_id;
        const tier = session.metadata?.tier;

        if (userId && tier) {
          await supabaseAdmin.auth.admin.updateUserById(userId, {
            user_metadata: {
              subscription_tier: tier,
              stripe_subscription_id: session.subscription || null,
            },
          });
          console.log(`User ${userId} upgraded to ${tier}`);
        }
        break;
      }

      case 'customer.subscription.deleted': {
        const subscription = event.data.object;
        const customerId = subscription.customer as string;

        // Find user by Stripe customer ID
        const { data: { users } } = await supabaseAdmin.auth.admin.listUsers();
        const user = users.find(
          u => u.user_metadata?.stripe_customer_id === customerId
        );

        if (user) {
          await supabaseAdmin.auth.admin.updateUserById(user.id, {
            user_metadata: {
              subscription_tier: 'free',
              stripe_subscription_id: null,
            },
          });
          console.log(`User subscription cancelled, downgraded to free`);
        }
        break;
      }

      case 'invoice.payment_failed': {
        const invoice = event.data.object;
        console.log(`Payment failed for invoice ${invoice.id}`);
        // TODO: Send email notification about failed payment
        break;
      }
    }

    return NextResponse.json({ received: true });
  } catch (error) {
    console.error('Webhook processing error:', error);
    return NextResponse.json(
      { error: 'Webhook processing failed' },
      { status: 500 }
    );
  }
}
```

**Notes:**
- Verifies Stripe signature for security
- Uses Supabase admin client with service role
- Handles subscription lifecycle events
- Updates user metadata on tier changes

---

### Step 4: Update Signup API Route

**File:** `app/api/auth/signup-with-test/route.ts` (MODIFY)

**Changes:**
1. Handle "User already registered" error with magic link fallback
2. Return session object for immediate client-side auth
3. Add explicit success flag for client handling

**Modified Implementation:**
```typescript
// After line 62 (after authError check), replace error handling:

if (authError) {
  // Handle "User already registered" - send magic link instead
  if (authError.message.includes('already registered')) {
    const { error: otpError } = await supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: false,
      },
    });

    if (otpError) {
      return NextResponse.json({ error: otpError.message }, { status: 500 });
    }

    return NextResponse.json({
      existingUser: true,
      message: 'Check your email for a login link',
    });
  }

  console.error('Error creating user account:', authError);
  return NextResponse.json({ error: authError.message }, { status: 500 });
}
```

**And update the success response (around line 108):**
```typescript
return NextResponse.json({
  success: true,
  testUrl,
  shareToken: testData.share_token,
  userId: authData.user.id,
  session: authData.session, // Include session for client
});
```

---

### Step 5: Update Pricing Page

**File:** `app/pricing/page.tsx` (MODIFY)

**Changes:**
1. Conditional "No credit card required" message (free only)
2. Different button text based on tier
3. Stripe checkout redirect for paid tiers
4. Handle existing user case

**Modified Implementation:**

**5a. Update button text (around line 319-333):**
```typescript
<Button
  type="submit"
  size="lg"
  className="w-full"
  disabled={loading}
>
  {loading ? (
    'Creating Account...'
  ) : selectedTier === 'free' ? (
    <>
      Get Started Free
      <ArrowRight className="w-4 h-4 ml-2" />
    </>
  ) : (
    <>
      Continue to Payment
      <ArrowRight className="w-4 h-4 ml-2" />
    </>
  )}
</Button>
```

**5b. Update footer message (around line 337-341):**
```typescript
<CardFooter className="justify-center">
  {selectedTier === 'free' ? (
    <p className="text-sm text-muted-foreground">
      No credit card required
    </p>
  ) : (
    <p className="text-sm text-muted-foreground">
      You&apos;ll be redirected to secure checkout
    </p>
  )}
</CardFooter>
```

**5c. Update handleSubmit function (around line 99-155):**
```typescript
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  setError('');

  if (!termsAccepted) {
    setError('Please accept the terms and conditions to continue.');
    return;
  }

  if (!email.trim() || !email.includes('@')) {
    setError('Please enter a valid email address.');
    return;
  }

  if (!sessionToken) {
    setError('Session expired. Please start over.');
    router.push('/');
    return;
  }

  setLoading(true);

  try {
    // First, create account (for all tiers)
    const signupResponse = await fetch('/api/auth/signup-with-test', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: email.trim(),
        sessionToken,
        tier: selectedTier
      })
    });

    const signupData = await signupResponse.json();

    if (!signupResponse.ok) {
      throw new Error(signupData.error || 'Failed to create account');
    }

    // If existing user, show message
    if (signupData.existingUser) {
      setError('Account exists. Check your email for a login link.');
      setLoading(false);
      return;
    }

    // Store shareToken for dashboard welcome modal
    if (signupData.shareToken) {
      storage.setItem('first_test_token', signupData.shareToken);
    }

    // Cleanup anonymous session
    storage.removeItem('anonymous_session');

    // For paid tiers, redirect to Stripe checkout
    if (selectedTier !== 'free') {
      const checkoutResponse = await fetch('/api/stripe/checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ tier: selectedTier }),
      });

      const checkoutData = await checkoutResponse.json();

      if (checkoutData.url) {
        window.location.href = checkoutData.url;
        return;
      }
    }

    // Free tier - go straight to dashboard
    router.push('/dashboard?welcome=true');
  } catch (err) {
    console.error('Signup error:', err);
    setError(err instanceof Error ? err.message : 'Something went wrong. Please try again.');
    setLoading(false);
  }
};
```

---

## Stage

Complete ✅ (2025-11-27)

---

## Review Notes (Added 2025-11-27)

### Requirements Coverage Matrix
✅ All 5 sub-tasks from Stage 4 have corresponding plan steps
✅ All webhook events from original plan are handled
✅ Existing user flow with magic link is addressed
✅ Conditional messaging for free vs paid tiers planned

### Technical Validation Results
✅ File paths verified - `lib/supabase/server.ts` exists with correct export
✅ Dependencies confirmed - `stripe` and `@stripe/stripe-js` already installed
✅ Import paths validated - `@/lib/supabase/server` pattern matches codebase
✅ Stripe API version `2024-11-20.acacia` is correct for SDK v20.x
✅ TypeScript types available from Stripe package

### Risk Assessment
| Risk | Level | Mitigation |
|------|-------|------------|
| Missing Stripe Price IDs | Medium | Question #1 in clarifications |
| Webhook signature validation | Low | Using official Stripe SDK |
| Admin user lookup performance | Low | Acceptable for MVP, optimize later |

### Contributing.md Compliance
✅ Simplicity - Uses existing patterns
✅ No duplication - Reuses Supabase client pattern
✅ File size - All new files under 100 lines
✅ API Key Security - All from env variables, no hardcoded values

### Recommendations Implemented
1. Plan structure follows exact order from original auth-and-payments-implementation.md
2. Code snippets include human-readable comments
3. Error handling follows existing codebase patterns
4. Session return added for immediate client auth

---

## Questions for Clarification

### ~~1. Stripe Product/Price IDs~~ ✅ RESOLVED

**Answer:** Option A - Products already created. Price IDs are in `.env.local`.

---

### ~~2. Webhook Event Handling Scope~~ ✅ RESOLVED

**Answer:** Option A - Minimal scope for MVP. Full webhook scope added to `zebra-planning/user-testing-app/future-features.md` for future reference.

---

### ~~3. Existing User Flow~~ ✅ RESOLVED

**Answer:** Option A - Magic link approach confirmed.

---

## Priority

High - This is a critical revenue-generating feature

---

## Created

2025-11-27

---

## Files

### New Files
- `lib/stripe.ts`
- `app/api/stripe/checkout/route.ts`
- `app/api/stripe/webhook/route.ts`

### Modified Files
- `app/api/auth/signup-with-test/route.ts`
- `app/pricing/page.tsx`

### Environment Variables (to add)
- `STRIPE_PRO_PRICE_ID`
- `STRIPE_EXPERT_PRICE_ID`
