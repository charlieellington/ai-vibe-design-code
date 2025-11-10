## Baby Gift List Updates - User Feedback Implementation

### Original Request
"Make a plan @design-1-planning.md for the follow updates from feedback on the baby list app: 

baby 

1. Add just after the photo carasoul at top a button "See the gifts" or is there something else we should implement which is better written? So people know to scroll or don't miss the gifts if on desktop. Not needed for mobile. 

2. Make the title text "Baby Charlie..." more interesting with: https://magicui.design/docs/components/aurora-text 

3. Remove the Show all button from desktop. 

4. Remove the Paypal option entirely, and replace with: Payconiq. Help me with the best way to implement this. I think we just have the option were the Paypal option was. Then they go to the instruction page. Which we keep fairly simple with the top half the instrutions and the bottom half the message once sent. The instructions should just be the image I've taken from the payconiq link Bene set up: @pay-mobile.png @pay-desktop.png  - one for mobile and one for desktop, or just use the mobile for both. We also have the payconiq logo in @pay . 

5. Update the How Does It Work instructions to payconiq. Make it smpler by removing "Let us know" and the "You'll get a unique gift code for the bank transfer that helps us track contributions and avoid duplicates!" as we're only going to hightlight this timely on the bank transfer option. 

6. Can you change all the codes on bank transfer to be ANIMALS rather than horrible number letter strings like "F34E0-D993""

### Design Context

**User-provided images** (attached to message):
- @pay-mobile.png - Mobile version of Payconiq payment instructions screenshot
- @pay-desktop.png - Desktop version of Payconiq payment instructions screenshot
- @Bancontact-Payconiq_Logo.webp - Payconiq logo asset (9.5KB)

**Design specifications**:
- Magic UI Aurora Text component for title enhancement
  - Component: AuroraText from Magic UI
  - Uses animated gradient with colors: ['#FF0080', '#7928CA', '#0070F3', '#38bdf8']
  - Background-clip: text with animated gradient
  - Installation: `pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"`

**Button placement**:
- Location: After PhotoStoryCarousel, before the description paragraph
- Desktop only (hidden on mobile with `hidden md:block` or `md:inline-flex`)
- Text options: "See the gifts" or better alternative like "View Gift List" or "Browse Gifts ↓"

**Code generation approach**:
- Animal codes should be memorable, unique animal names (e.g., "PANDA-TIGER", "EAGLE-WHALE")
- Replace the current MD5 hash generation with curated animal word list

### Codebase Context

**Current implementation files**:

1. **Hero Section Title**:
   - File: `components/gift-list/hero-section.tsx` (lines 6-8)
   - Current: `<h1 className="text-3xl md:text-4xl font-bold">Baby Charlie and Bene Gift List</h1>`
   - Modification: Wrap title text in AuroraText component

2. **Photo Carousel Structure**:
   - File: `components/gift-list/hero-section.tsx` (line 14)
   - Location: `<PhotoStoryCarousel />` is rendered between "Due 6th of December" and description
   - Insertion point: Add button after line 14 (after PhotoStoryCarousel), before the description paragraph

3. **Show All Button**:
   - File: `components/gift-list/gift-grid.tsx` (lines 83-92)
   - Current: Button appears for both mobile and desktop
   - Modification: Add `hidden md:hidden` or remove entirely from desktop

4. **Payment Method Selection**:
   - File: `app/payment/choose/payment-method-selection.tsx` (lines 98-125)
   - Current: PayPal option card exists
   - Modification: Replace with Payconiq option, update icon, text, and navigation

5. **Payment Routes**:
   - Current PayPal route: `app/payment/paypal/`
   - New route needed: `app/payment/payconiq/` (or reuse/rename paypal route)
   - Files to modify/create:
     - `app/payment/payconiq/page.tsx` (server component)
     - `app/payment/payconiq/payconiq-payment-form.tsx` (client component)

6. **How Does It Work Instructions**:
   - Files with this content:
     - `components/gift-list/item-modal.tsx` (lines 148-164)
     - `app/payment/choose/payment-method-selection.tsx` (lines 138-154)
   - Modifications needed:
     - Remove "3. Let us know:" step
     - Remove gift code mention from general instructions
     - Keep gift code mention ONLY in IBAN-specific instructions

7. **Gift Code Generation**:
   - Database function: `supabase/migrations/20241106000000_initial_schema.sql` (lines 70-93)
   - Current: `generate_gift_code()` uses MD5 hash: "HIPPO-A3B2" format
   - Modification: Replace with animal-based generation logic

### Plan

**Step 1: Install Magic UI Aurora Text Component**
- Run installation command: `pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"`
- This will create `components/ui/aurora-text.tsx`
- Verify component installation and imports

**Step 2: Update Hero Section Title with Aurora Text**
- File: `components/gift-list/hero-section.tsx`
- Import AuroraText: `import { AuroraText } from '@/components/ui/aurora-text';`
- Replace existing h1 content:
  ```tsx
  <h1 className="text-3xl md:text-4xl font-bold">
    <AuroraText>Baby Charlie and Bene Gift List</AuroraText>
  </h1>
  ```
- Optional: Customize colors if default gradient doesn't match brand

**Step 3: Add "See the Gifts" Button After Carousel (Desktop Only)**
- File: `components/gift-list/hero-section.tsx`
- Add after `<PhotoStoryCarousel />` (line 14):
  ```tsx
  {/* Scroll to gifts button - desktop only */}
  <div className="hidden md:block mt-6">
    <button
      onClick={() => {
        const giftsSection = document.querySelector('[data-gifts-section]');
        giftsSection?.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }}
      className="px-6 py-3 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors font-medium"
    >
      Browse Gifts ↓
    </button>
  </div>
  ```
- Add data attribute to GiftGrid container in `app/page.tsx`:
  ```tsx
  <div data-gifts-section>
    <GiftGrid items={items} />
  </div>
  ```
- Alternative wording options: "See the Gifts", "View Gift List", "Browse Gifts ↓"

**Step 4: Hide "Show All" Button on Desktop**
- File: `components/gift-list/gift-grid.tsx` (lines 83-92)
- Update button wrapper className:
  ```tsx
  {!showAll && filteredItems.length > 3 && (
    <div className="text-center pt-4 md:hidden"> {/* Added md:hidden */}
      <button
        onClick={() => setShowAll(true)}
        className="px-6 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors"
      >
        Show all {filteredItems.length} gifts
      </button>
    </div>
  )}
  ```
- Rationale: Desktop has more vertical space, mobile benefits from pagination

**Step 5: Replace PayPal with Payconiq in Payment Method Selection**
- File: `app/payment/choose/payment-method-selection.tsx` (lines 98-125)
- Replace PayPal card with Payconiq:
  ```tsx
  {/* Payconiq Option */}
  <button
    onClick={() => handleMethodSelection('payconiq')}
    className="w-full text-left"
  >
    <Card className="cursor-pointer transition-all hover:border-primary hover:shadow-md">
      <CardContent className="pt-6">
        <div className="flex items-center gap-4">
          <div className="flex-shrink-0 w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center overflow-hidden">
            <Image
              src="/pay/Bancontact-Payconiq_Logo.webp"
              alt="Payconiq by Bancontact"
              width={48}
              height={48}
              className="object-contain"
            />
          </div>
          <div className="flex-1">
            <h3 className="font-semibold text-lg">Payconiq by Bancontact</h3>
            <p className="text-sm text-muted-foreground">
              Pay quickly with the Payconiq app
            </p>
          </div>
          <div className="flex-shrink-0">
            <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
          </div>
        </div>
      </CardContent>
    </Card>
  </button>
  ```
- Update handleMethodSelection to route to 'payconiq' instead of 'paypal'
- Add Next.js Image import: `import Image from 'next/image';`

**Step 6: Create Payconiq Payment Page and Form**

**6a. Create Payconiq Server Page**
- File: `app/payment/payconiq/page.tsx` (new file)
- Based on existing IBAN page structure:
  ```tsx
  import { createClient } from '@/lib/supabase/server';
  import { notFound } from 'next/navigation';
  import { PayconiqPaymentForm } from './payconiq-payment-form';
  import type { Item } from '@/types/supabase';

  export default async function PayconiqPaymentPage({
    searchParams,
  }: {
    searchParams: Promise<{ item?: string; type?: string }>;
  }) {
    const params = await searchParams;
    const itemId = params.item;
    const paymentType = params.type;

    if (!itemId || !paymentType || !['full', 'partial'].includes(paymentType)) {
      notFound();
    }

    const supabase = await createClient();
    const { data: item, error } = await supabase
      .from('items')
      .select('*')
      .eq('id', itemId)
      .single();

    if (error || !item) {
      notFound();
    }

    return (
      <main className="min-h-screen bg-background">
        <div className="container mx-auto px-4 py-8 max-w-2xl">
          <PayconiqPaymentForm
            item={item as Item}
            paymentType={paymentType as 'full' | 'partial'}
          />
        </div>
      </main>
    );
  }
  ```

**6b. Create Payconiq Payment Form Client Component**
- File: `app/payment/payconiq/payconiq-payment-form.tsx` (new file)
- Layout: Top half instructions (image), bottom half message confirmation
- Use responsive image display:
  ```tsx
  'use client';

  import { useState } from 'react';
  import { useRouter } from 'next/navigation';
  import Image from 'next/image';
  import { Button } from '@/components/ui/button';
  import { Card, CardContent } from '@/components/ui/card';
  import { Textarea } from '@/components/ui/textarea';
  import { Input } from '@/components/ui/input';
  import { Label } from '@/components/ui/label';
  import { Checkbox } from '@/components/ui/checkbox';
  import { submitPayPalContribution } from '../paypal/actions';
  import type { Item } from '@/types/supabase';

  interface PayconiqPaymentFormProps {
    item: Item;
    paymentType: 'full' | 'partial';
  }

  export function PayconiqPaymentForm({ item, paymentType }: PayconiqPaymentFormProps) {
    const router = useRouter();
    const [contributorName, setContributorName] = useState('');
    const [amount, setAmount] = useState(
      paymentType === 'full' ? item.price - item.amount_contributed : ''
    );
    const [message, setMessage] = useState('');
    const [isPublic, setIsPublic] = useState(true);
    const [isLoading, setIsLoading] = useState(false);

    // Form submission handler
    const handleSubmit = async (e: React.FormEvent) => {
      e.preventDefault();
      // Reuse existing PayPal action or create new Payconiq-specific action
      // ...submission logic...
    };

    return (
      <div className="space-y-6">
        {/* Header */}
        <div className="text-center space-y-2">
          <h1 className="text-3xl font-bold">Pay with Payconiq</h1>
          <p className="text-muted-foreground">
            Scan the QR code to complete your contribution
          </p>
        </div>

        {/* Item Summary */}
        <Card>
          <CardContent className="pt-6">
            <div className="flex gap-4">
              {item.image_url && (
                <div className="relative w-20 h-20 rounded-lg overflow-hidden flex-shrink-0">
                  <Image src={item.image_url} alt={item.title} fill className="object-cover" />
                </div>
              )}
              <div className="flex-1">
                <h3 className="font-semibold">{item.title}</h3>
                <p className="text-sm text-muted-foreground">
                  {paymentType === 'full' ? 'Full amount' : 'Partial contribution'}
                </p>
                <p className="text-2xl font-bold mt-2">
                  €{typeof amount === 'number' ? amount.toFixed(2) : amount}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Instructions - Responsive Image */}
        <Card>
          <CardContent className="pt-6">
            <h2 className="text-xl font-semibold mb-4">Payment Instructions</h2>
            
            {/* Mobile Image - shown on small screens */}
            <div className="block md:hidden">
              <Image
                src="/pay/pay-mobile.png"
                alt="Payconiq payment instructions - mobile"
                width={360}
                height={780}
                className="w-full h-auto rounded-lg"
                priority
              />
            </div>

            {/* Desktop Image - shown on medium+ screens */}
            <div className="hidden md:block">
              <Image
                src="/pay/pay-desktop.png"
                alt="Payconiq payment instructions - desktop"
                width={800}
                height={600}
                className="w-full h-auto rounded-lg"
                priority
              />
            </div>
          </CardContent>
        </Card>

        {/* Confirmation Form */}
        <Card>
          <CardContent className="pt-6">
            <form onSubmit={handleSubmit} className="space-y-4">
              <h2 className="text-xl font-semibold mb-4">After Sending Payment</h2>
              
              <div>
                <Label htmlFor="name">Your Name</Label>
                <Input
                  id="name"
                  value={contributorName}
                  onChange={(e) => setContributorName(e.target.value)}
                  required
                  placeholder="Enter your name"
                />
              </div>

              {paymentType === 'partial' && (
                <div>
                  <Label htmlFor="amount">Amount Sent (€)</Label>
                  <Input
                    id="amount"
                    type="number"
                    step="0.01"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    required
                    placeholder="Enter amount"
                  />
                </div>
              )}

              <div>
                <Label htmlFor="message">Personal Message (Optional)</Label>
                <Textarea
                  id="message"
                  value={message}
                  onChange={(e) => setMessage(e.target.value)}
                  placeholder="Leave a message for the parents"
                  rows={3}
                />
              </div>

              <div className="flex items-center space-x-2">
                <Checkbox
                  id="public"
                  checked={isPublic}
                  onCheckedChange={(checked) => setIsPublic(checked as boolean)}
                />
                <Label htmlFor="public" className="text-sm font-normal cursor-pointer">
                  Show my contribution publicly
                </Label>
              </div>

              <Button type="submit" className="w-full" size="lg" disabled={isLoading}>
                {isLoading ? 'Confirming...' : 'Confirm Payment Sent'}
              </Button>
            </form>
          </CardContent>
        </Card>

        {/* Back Link */}
        <div className="text-center">
          <Button variant="ghost" onClick={() => router.push('/')}>
            ← Back to Gift List
          </Button>
        </div>
      </div>
    );
  }
  ```

**6c. Create Payconiq Actions File** (if not reusing PayPal actions)
- File: `app/payment/payconiq/actions.ts` (new file)
- Copy and adapt from `app/payment/paypal/actions.ts`
- Update any Payconiq-specific logic if needed

**Step 7: Update "How Does It Work" Instructions**

**7a. Update Item Modal Instructions**
- File: `components/gift-list/item-modal.tsx` (lines 148-164)
- Remove step 3 "Let us know"
- Remove gift code mention
- Simplify to 3 steps:
  ```tsx
  <div className="p-4 pt-2 space-y-2 text-sm text-muted-foreground">
    <p>
      <strong>1. Choose your contribution:</strong> Select whether you'd like to gift the full amount or contribute partially.
    </p>
    <p>
      <strong>2. Send Money:</strong> You'll receive our bank details or Payconiq QR code.
    </p>
    <p>
      <strong>3. We'll purchase the gift:</strong> We'll buy the gift new or second hand on Vinted to create a more circular and environmentally friendly economy. No need for you to receive the gift, we'll have it sent direct to us!
    </p>
  </div>
  ```

**7b. Update Payment Method Selection Instructions**
- File: `app/payment/choose/payment-method-selection.tsx` (lines 138-154)
- Apply same simplification as 7a

**7c. Keep Gift Code Info in IBAN Instructions Only**
- File: `app/payment/iban/payment-form.tsx`
- Search for gift code display and ensure it prominently mentions:
  - "You'll get a unique animal code for tracking your bank transfer"
  - Display the generated animal code clearly

**Step 8: Update Gift Code Generation to Use Animals**

**8a. Create Animal Word Lists**
- Create helper file: `lib/animal-codes.ts` (new file)
- Define curated animal lists:
  ```typescript
  /**
   * Animal Code Generation for Gift Tracking
   * 
   * Generates memorable animal-based codes instead of random strings
   * Format: "ANIMAL1-ANIMAL2" (e.g., "PANDA-TIGER")
   */

  export const ANIMALS_PART1 = [
    'PANDA', 'TIGER', 'EAGLE', 'WHALE', 'LION',
    'BEAR', 'WOLF', 'FOX', 'DEER', 'OTTER',
    'HAWK', 'OWL', 'RAVEN', 'SWAN', 'HERON',
    'KOALA', 'LEMUR', 'SLOTH', 'GECKO', 'PENGUIN'
  ] as const;

  export const ANIMALS_PART2 = [
    'CHEETAH', 'JAGUAR', 'LYNX', 'BISON', 'MOOSE',
    'RABBIT', 'BEAVER', 'BADGER', 'MARTEN', 'FERRET',
    'FALCON', 'CONDOR', 'PELICAN', 'CRANE', 'STORK',
    'WOMBAT', 'QUOKKA', 'NUMBAT', 'IGUANA', 'TURTLE'
  ] as const;

  /**
   * Generate a unique animal code
   * Returns format: "ANIMAL1-ANIMAL2"
   */
  export function generateAnimalCode(): string {
    const animal1 = ANIMALS_PART1[Math.floor(Math.random() * ANIMALS_PART1.length)];
    const animal2 = ANIMALS_PART2[Math.floor(Math.random() * ANIMALS_PART2.length)];
    return `${animal1}-${animal2}`;
  }
  ```

**8b. Update Database Function**
- File: `supabase/migrations/20241106000000_initial_schema.sql` (lines 70-93)
- Note: Since we can't easily import TypeScript into PostgreSQL, we need to rewrite the function in SQL
- Create new migration file: `supabase/migrations/[timestamp]_animal_gift_codes.sql`
- New function:
  ```sql
  -- Animal-based gift code generation
  -- Replaces MD5 hash codes with memorable animal combinations
  
  CREATE OR REPLACE FUNCTION generate_gift_code()
  RETURNS TEXT AS $$
  DECLARE
    code TEXT;
    exists BOOLEAN;
    animals_part1 TEXT[] := ARRAY[
      'PANDA', 'TIGER', 'EAGLE', 'WHALE', 'LION',
      'BEAR', 'WOLF', 'FOX', 'DEER', 'OTTER',
      'HAWK', 'OWL', 'RAVEN', 'SWAN', 'HERON',
      'KOALA', 'LEMUR', 'SLOTH', 'GECKO', 'PENGUIN'
    ];
    animals_part2 TEXT[] := ARRAY[
      'CHEETAH', 'JAGUAR', 'LYNX', 'BISON', 'MOOSE',
      'RABBIT', 'BEAVER', 'BADGER', 'MARTEN', 'FERRET',
      'FALCON', 'CONDOR', 'PELICAN', 'CRANE', 'STORK',
      'WOMBAT', 'QUOKKA', 'NUMBAT', 'IGUANA', 'TURTLE'
    ];
    animal1 TEXT;
    animal2 TEXT;
  BEGIN
    LOOP
      -- Pick random animals from each list
      animal1 := animals_part1[1 + floor(random() * array_length(animals_part1, 1))::int];
      animal2 := animals_part2[1 + floor(random() * array_length(animals_part2, 1))::int];
      code := animal1 || '-' || animal2;

      -- Check if code already exists
      SELECT EXISTS(
        SELECT 1 FROM contributions WHERE gift_code = code
      ) INTO exists;

      EXIT WHEN NOT exists;
    END LOOP;

    RETURN code;
  END;
  $$ LANGUAGE plpgsql;
  ```
- Run migration: `supabase migration up` or push to remote

**Step 9: Remove/Archive PayPal Files** (Optional Cleanup)
- Consider archiving PayPal implementation for potential future use
- Files to archive or delete:
  - `app/payment/paypal/page.tsx`
  - `app/payment/paypal/paypal-payment-form.tsx`
  - `app/payment/paypal/actions.ts`
- Create archive folder: `app/payment/_archived/paypal/` and move files
- Rationale: Keep codebase clean but preserve work in case Payconiq needs replacement

**Step 10: Testing Checklist**
- [ ] Aurora text displays correctly with animated gradient
- [ ] "Browse Gifts" button appears on desktop only, scrolls smoothly to gifts section
- [ ] "Show all" button hidden on desktop, visible on mobile
- [ ] Payconiq option appears in payment method selection
- [ ] Payconiq payment page displays correct responsive images
- [ ] Form submission works and creates contribution record
- [ ] "How does it work" instructions are simplified (no "Let us know" step)
- [ ] Gift code mention removed from general instructions
- [ ] Animal codes generate correctly for IBAN transfers
- [ ] Animal codes are unique and memorable (e.g., "PANDA-TIGER")
- [ ] No console errors or hydration issues

### Stage
Ready for Execution

### Review Notes

**Requirements Coverage**: ✅ All 6 requirements addressed
- "See the gifts" button for desktop
- Aurora Text title enhancement
- Show All button desktop removal
- PayPal to Payconiq replacement
- Instructions simplification
- Animal-based gift codes

**Technical Validation**: ✅ All file paths and components verified
- Hero section structure confirmed
- Gift grid Show All button located
- Payment method selection validated
- Payconiq assets present in /public/pay/

**Enhancements Added**:
1. Client component approach for scroll button ('use client' needed)
2. Separate Payconiq actions file for cleaner separation
3. Pure animal names for codes (not MD5 hash format like current "F34E0-D993")
4. Responsive image handling for payment instructions

**Clarifications Resolved**: ✅ All 3 clarifications answered by user

### Questions for Clarification

**✅ ALL QUESTIONS RESOLVED**

**Q1: Magic UI Component Installation**
- **User Decision**: Option A - Try the installation first, with fallback if needed
- **Action**: Proceed with `pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"`

**Q2: Animal Code Format**
- **User Decision**: Option A - Pure animal names "PANDA-TIGER" format
- **Note**: Current format shows as "F34E0-D993" which will be replaced
- **Action**: Implement two-animal combination without numbers

**Q3: PayPal File Handling**
- **User Decision**: Option A - Archive to `app/payment/_archived/paypal/`
- **Action**: Move existing PayPal files to archive folder to preserve code

**Q4: Button Wording** (from original request)
- **Maintained**: "Browse Gifts ↓" with down arrow for clarity

**Q5: Show All Button** (from original request)
- **Maintained**: Hide on desktop with `md:hidden`, keep for mobile

### Priority
High - User-requested improvements for active gift list

### Created
2025-01-10

### Files

**Files to Create**:
- `components/ui/aurora-text.tsx` (via Magic UI installation)
- `app/payment/payconiq/page.tsx`
- `app/payment/payconiq/payconiq-payment-form.tsx`
- `app/payment/payconiq/actions.ts` (or reuse PayPal actions)
- `lib/animal-codes.ts`
- `supabase/migrations/[timestamp]_animal_gift_codes.sql`

**Files to Modify**:
- `components/gift-list/hero-section.tsx` (title with Aurora text, add button)
- `app/page.tsx` (add data attribute to gifts section)
- `components/gift-list/gift-grid.tsx` (hide show all button on desktop)
- `app/payment/choose/payment-method-selection.tsx` (replace PayPal with Payconiq)
- `components/gift-list/item-modal.tsx` (simplify instructions)
- `supabase/migrations/20241106000000_initial_schema.sql` (update gift code function)

**Files to Archive** (optional):
- `app/payment/paypal/page.tsx`
- `app/payment/paypal/paypal-payment-form.tsx`
- `app/payment/paypal/actions.ts`

### Implementation Notes

**Currency Context**:
All prices should use euros (€) format - this is already established in the codebase

**Design System Compliance**:
- Follow existing Tailwind utility patterns
- Use semantic color tokens (bg-primary, text-foreground, etc.)
- Maintain consistent spacing with existing components
- Ensure responsive design works on mobile and desktop

**Animal Code Benefits**:
- More memorable than current "F34E0-D993" format
- Easier to communicate verbally
- More friendly and engaging user experience
- Still unique with 20x20 = 400 possible combinations
- Can expand lists if collision rate becomes issue

### Execution Specification (Post-Review)

**Pre-Implementation Checklist**:
- [ ] Create archive folder for PayPal files: `mkdir -p app/payment/_archived/paypal`
- [ ] Verify pnpm is available for Magic UI installation
- [ ] Back up current gift code function before modification

**Critical Implementation Details**:

1. **Magic UI Installation**:
   - Primary: `pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"`
   - Fallback: If installation fails, manually create component from Magic UI docs
   - Verify: Import works before modifying hero section

2. **Scroll Button Client Component**:
   - Hero section needs 'use client' directive OR
   - Create separate `ScrollToGiftsButton` client component
   - Data attribute on gifts section: `data-gifts-section`

3. **Animal Code SQL Function**:
   - Replace MD5 hash generation completely
   - Format: "ANIMAL1-ANIMAL2" (e.g., "PANDA-TIGER")
   - NO numbers, NO hash characters
   - Current "F34E0-D993" format will be completely replaced

4. **Payconiq Implementation**:
   - Create new `app/payment/payconiq/` folder structure
   - Use responsive images: both mobile and desktop versions
   - Create separate `actions.ts` for Payconiq (don't reuse PayPal's)

5. **PayPal Archival**:
   - Move all 3 files to `app/payment/_archived/paypal/`
   - Update any imports that reference PayPal routes
   - Keep archived for potential future restoration

---

## Technical Discovery (Agent 3)

### Component Identification Verification

- **Target Pages**: Landing page (`app/page.tsx`), Hero section, Payment flow
- **Planned Components**: 
  - `HeroSection` for AuroraText integration
  - `GiftGrid` for Show All button modification
  - `PaymentMethodSelection` for Payconiq replacement
  - New `PayconiqPaymentForm` component
  - Database migration for animal gift codes
- **Verification Steps**:
  - ✅ Traced from page file to actual rendered components
  - ✅ Confirmed component paths match actual rendering
  - ✅ Verified components receive required props from parent
  - ✅ Confirmed no similar-named components that could cause confusion

**Component Rendering Path Validation**:
- Landing: `app/page.tsx` → `HeroSection` → `PhotoStoryCarousel` (confirmed)
- Gifts: `app/page.tsx` → `GiftGrid` → `GiftCard` + `CategoryFilter` (confirmed)
- Payment: `app/payment/choose/page.tsx` → `PaymentMethodSelection` (confirmed)
- IBAN: `app/payment/iban/page.tsx` → `PaymentForm` (confirmed, reusable pattern)

### MCP Research Results

#### Magic UI Aurora Text Component Research

**Query**: Magic UI Text Animations - AuroraText component availability and installation
**MCP Tool Used**: `mcp_magicuidesignmcp_getTextAnimations`

**Component Details**:
- ✅ **Available**: AuroraText exists in Magic UI registry
- **Installation Command**: `pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"`
- **Import Path**: `import { AuroraText } from "@/components/ui/aurora-text";`
- **Dependencies**: 
  - React (already installed: ^19.0.0)
  - No additional npm packages required (self-contained component)
- **Component Type**: Client component (`"use client"` directive)

**Component API**:
```typescript
interface AuroraTextProps {
  children: React.ReactNode
  className?: string
  colors?: string[] // Default: ["#FF0080", "#7928CA", "#0070F3", "#38bdf8"]
  speed?: number // Default: 1 (controls animation duration)
}
```

**Technical Specifications**:
- Uses `background-image: linear-gradient(135deg, ...)` with custom colors
- CSS animation via `animate-aurora` class (needs to be in tailwind.config or globals.css)
- `WebkitBackgroundClip: "text"` and `WebkitTextFillColor: "transparent"` for gradient effect
- `background-size: 200% auto` for animation movement
- Animation duration: `${10 / speed}s` (default 10 seconds for speed=1)
- Accessibility: Uses `sr-only` span for screen readers, `aria-hidden` on visual span

**Bundle Impact**: ~1-2KB (small component, no external dependencies)

**Default Colors Analysis**:
- Current plan suggests: `['#FF0080', '#7928CA', '#0070F3', '#38bdf8']`
- Project theme uses warm coral/peach palette:
  - Primary: `hsl(358.45, 70.73%, 67.84%)` = #E77376 (coral pink)
  - Secondary: `hsl(19.2, 75.76%, 61.18%)` = #EB844F (warm orange)
  - Chart colors available in theme
- **Recommendation**: Consider customizing colors to match baby gift list warm theme

**Installation Validation**:
- ✅ pnpm is available (confirmed in package.json scripts)
- ✅ No conflicts with existing dependencies
- ✅ Tailwind configured properly with animate plugin
- ⚠️ **Custom Animation Required**: Need to add `animate-aurora` keyframe to `tailwind.config.ts` or `globals.css`

**Animation Keyframe Discovery**:
```css
@keyframes aurora {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
```
Must be added to `app/globals.css` in `@layer utilities` or tailwind.config animation section.

#### Next.js Image Component Validation

**Current Configuration Verified** (`next.config.ts`):
- ✅ Remote patterns configured for Supabase storage
- ✅ Modern formats enabled (AVIF, WebP)
- ✅ Local images from `public/` folder supported by default
- ✅ No issues expected with Payconiq logo (`/pay/Bancontact-Payconiq_Logo.webp`)

**Usage Patterns Validated**:
- Payment instruction images will use Next.js Image with responsive display
- Logo will use Next.js Image with fixed dimensions (48x48 per plan)
- No compatibility issues with local public directory files (unlike previous task notes)

#### Existing UI Component Verification

**shadcn/ui Components** (already installed):
- ✅ Button - `components/ui/button.tsx` (confirmed in codebase)
- ✅ Card, CardContent, CardHeader - `components/ui/card.tsx` (confirmed in use)
- ✅ Input - `components/ui/input.tsx` (confirmed in payment forms)
- ✅ Label - `components/ui/label.tsx` (confirmed in payment forms)
- ✅ Textarea - `components/ui/textarea.tsx` (confirmed in payment forms)
- ✅ Checkbox - `components/ui/checkbox.tsx` (confirmed in IBAN form, privacy controls)

**No Additional Component Installations Required**: All UI components already in place.

### Implementation Feasibility

#### 1. Magic UI AuroraText Integration

**Feasibility**: ✅ **READY**
**Blockers**: None
**Requirements**:
1. Run installation command: `pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"`
2. Add aurora animation keyframe to `app/globals.css`:
```css
@layer utilities {
  @keyframes aurora {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
  }
  .animate-aurora {
    animation: aurora 10s ease-in-out infinite;
  }
}
```
3. Update `components/gift-list/hero-section.tsx` with import and component usage
4. Verify client component directive ('use client') is present or add it

**Integration Pattern Verified**:
- HeroSection is currently a server component (no 'use client')
- AuroraText requires client component
- **Solution A**: Add 'use client' to HeroSection (recommended - simple)
- **Solution B**: Extract title to separate client component (over-engineering)

**Color Customization Recommendation**:
```tsx
<AuroraText colors={['#E77376', '#EB844F', '#F5B97F', '#E77376']}>
  Baby Charlie and Bene Gift List
</AuroraText>
```
Uses project theme colors for cohesive design.

#### 2. Scroll Button Implementation

**Feasibility**: ✅ **READY**
**Blockers**: None
**Requirements**:
1. Convert HeroSection to client component ('use client') OR create separate client component
2. Add data attribute to gifts section container in `app/page.tsx`
3. Implement smooth scroll behavior with `scrollIntoView`

**Current Structure Verified**:
- `app/page.tsx` line 107: `<GiftGrid items={items} />` (wrapping point)
- Plan correctly identifies insertion point after PhotoStoryCarousel
- Desktop-only display via `hidden md:block` pattern (confirmed in codebase usage)

**Recommendation**: Since HeroSection needs 'use client' for AuroraText anyway, implement scroll button in same component for simplicity.

#### 3. Show All Button Desktop Hide

**Feasibility**: ✅ **READY**
**Blockers**: None
**File Verified**: `components/gift-list/gift-grid.tsx` lines 83-92

**Current Implementation**:
```tsx
{!showAll && filteredItems.length > 3 && (
  <div className="text-center pt-4">
    <button>Show all {filteredItems.length} gifts</button>
  </div>
)}
```

**Required Change**: Add `md:hidden` to wrapper div className
**Impact**: Minimal - single className addition
**Testing**: Verify button appears on mobile, hidden on desktop (md breakpoint: 768px+)

#### 4. Payconiq Payment Integration

**Feasibility**: ✅ **READY**
**Blockers**: None

**Asset Verification**:
- ✅ Logo exists: `public/pay/Bancontact-Payconiq_Logo.webp` (9.5KB, confirmed in git status)
- ✅ Mobile instructions: `public/pay/pay-mobile.png` (confirmed in git status)
- ✅ Desktop instructions: `public/pay/pay-desktop.png` (confirmed in git status)

**Payment Method Selection Update**:
- File: `app/payment/choose/payment-method-selection.tsx`
- Lines 98-125: PayPal card component
- Replace with Payconiq card (logo, text, routing)
- Update `handleMethodSelection` to accept 'payconiq' method

**New Payconiq Route Structure**:
- Create: `app/payment/payconiq/page.tsx` (server component)
- Create: `app/payment/payconiq/payconiq-payment-form.tsx` (client component)
- Create: `app/payment/payconiq/actions.ts` (server actions)

**Reusable Patterns Identified**:
- IBAN form structure provides excellent template (334 lines)
- Server/Client component split pattern established
- Privacy checkbox pattern already implemented
- Form submission with Server Actions pattern validated

**Responsive Image Strategy Validated**:
```tsx
{/* Mobile Image */}
<div className="block md:hidden">
  <Image src="/pay/pay-mobile.png" alt="..." width={360} height={780} />
</div>

{/* Desktop Image */}
<div className="hidden md:block">
  <Image src="/pay/pay-desktop.png" alt="..." width={800} height={600} />
</div>
```
Pattern confirmed working in codebase (PhotoStoryCarousel uses similar approach).

#### 5. Instructions Simplification

**Feasibility**: ✅ **READY**
**Blockers**: None

**Files to Update**:
1. `components/gift-list/item-modal.tsx` (confirmed exists, not read but plan references lines 148-164)
2. `app/payment/choose/payment-method-selection.tsx` lines 138-154

**Current Content in payment-method-selection.tsx**:
```
1. Choose your contribution
2. Send Money
3. Let us know (← REMOVE THIS)
4. We'll purchase the gift
+ Gift code mention (← REMOVE FROM GENERAL, KEEP IN IBAN ONLY)
```

**Verification**: IBAN form (lines 214-217) already has gift code with proper messaging.

#### 6. Animal Gift Code Generation

**Feasibility**: ✅ **READY WITH CONSIDERATIONS**
**Blockers**: None
**Complexity**: Medium (database function modification)

**Current Implementation Verified** (`supabase/migrations/20241106000000_initial_schema.sql` lines 70-93):
```sql
CREATE OR REPLACE FUNCTION generate_gift_code()
RETURNS TEXT AS $$
DECLARE
  code TEXT;
  exists BOOLEAN;
BEGIN
  LOOP
    -- Generate code like "HIPPO-A3B2"
    code := UPPER(
      SUBSTRING(MD5(RANDOM()::TEXT), 1, 5) || '-' ||
      SUBSTRING(MD5(RANDOM()::TEXT), 1, 4)
    );
    -- Check if code already exists
    SELECT EXISTS(
      SELECT 1 FROM contributions WHERE gift_code = code
    ) INTO exists;
    EXIT WHEN NOT exists;
  END LOOP;
  RETURN code;
END;
$$ LANGUAGE plpgsql;
```

**Database Function Modification Strategy**:
- Current: MD5 hash format "HIPPO-A3B2" (mixed word + hash)
- Target: Pure animal names "PANDA-TIGER" (two animal words)
- PostgreSQL supports arrays and random selection natively
- Collision detection loop already implemented

**Animal List Sizing Analysis**:
- Plan proposes: 20 animals in part1 × 20 animals in part2 = 400 combinations
- Current database: Likely few contributions (new project based on context)
- 400 combinations sufficient for small-to-medium gift list
- Can expand lists if collision rate becomes issue in production

**Migration Approach**:
1. Create new migration file: `supabase/migrations/[timestamp]_animal_gift_codes.sql`
2. Use `CREATE OR REPLACE FUNCTION` to update existing function
3. No data migration needed (existing codes remain valid, new codes use animal format)
4. Test locally with `supabase db reset` or `supabase db push`

**Technical Note**: PostgreSQL array indexing is 1-based (not 0-based like JavaScript)
```sql
-- Correct: array[1 + floor(random() * array_length(array, 1))::int]
-- Incorrect: array[floor(random() * array_length(array, 1))::int]
```

#### 7. PayPal File Archival

**Feasibility**: ✅ **READY**
**Blockers**: None

**Files to Archive**:
- `app/payment/paypal/page.tsx` (confirmed exists in project layout)
- `app/payment/paypal/paypal-payment-form.tsx` (confirmed exists in project layout)
- `app/payment/paypal/actions.ts` (confirmed exists in project layout)

**Archive Strategy**:
1. Create directory: `app/payment/_archived/paypal/`
2. Move files (not delete) to preserve code
3. Update any imports (only `payment-method-selection.tsx` references paypal route)

**Import Analysis**:
- No direct imports of PayPal components in other files
- Only routing reference in `handleMethodSelection` function
- Replacing PayPal option removes all references

### Browser Compatibility & Accessibility

#### Smooth Scrolling

**Feature**: `scrollIntoView({ behavior: 'smooth' })`
**Compatibility**: ✅ Supported in all modern browsers (Chrome 61+, Firefox 36+, Safari 15.4+)
**Fallback**: Browsers without smooth behavior support will still scroll (instant scroll)
**Accessibility**: Respects `prefers-reduced-motion` media query automatically

**Recommendation**: Add explicit motion check:
```tsx
onClick={() => {
  const giftsSection = document.querySelector('[data-gifts-section]');
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  giftsSection?.scrollIntoView({ 
    behavior: reducedMotion ? 'auto' : 'smooth',
    block: 'start' 
  });
}}
```

#### Aurora Animation

**Feature**: CSS gradient animation with `background-clip: text`
**Compatibility**: ✅ Excellent support with vendor prefixes (already in component)
**Accessibility**: Animation respects system motion preferences via Tailwind's motion-safe variants

**Fallback Strategy**: Component already uses semantic HTML with sr-only content for screen readers.

### Database Migration Validation

#### Animal Code Function

**Migration Risk Assessment**: 🟡 **MEDIUM**

**Considerations**:
1. **Timing**: Function must exist before any contribution creation
2. **Testing**: Should test locally with Supabase before production push
3. **Rollback**: Can rollback to MD5 version if issues arise (existing codes remain valid)
4. **Uniqueness**: 400 combinations sufficient for expected gift list size

**Deployment Steps**:
1. Create migration file with timestamp
2. Test locally: `supabase db reset --db-url <local>`
3. Verify function with: `SELECT generate_gift_code();` (run 10x to check variety)
4. Push to production: `supabase db push`

**No Schema Changes**: Function replacement doesn't affect table structure, only code generation logic.

### CSS Animation Requirements

#### Aurora Text Animation

**Missing Keyframe**: The AuroraText component requires `@keyframes aurora` and `.animate-aurora` class

**Implementation Location**: Add to `app/globals.css`

**Exact Code Required**:
```css
@layer utilities {
  @keyframes aurora {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
  }
  
  .animate-aurora {
    animation: aurora 10s ease-in-out infinite;
  }
}
```

**Alternative**: Could add to tailwind.config.ts animation section, but globals.css is simpler for custom keyframes.

**Verification**: 
- ✅ Tailwind configured with `tailwindcss-animate` plugin (line 77 in tailwind.config.ts)
- ✅ `@layer utilities` pattern already used in globals.css (line 112-116 for scrollbar-hide)

### Performance Considerations

#### Bundle Size Analysis

**New Dependencies**: None (all components and dependencies already installed)

**New Components**:
- AuroraText: ~1-2KB (small, self-contained)
- PayconiqPaymentForm: ~3-4KB (similar to existing payment forms)
- Animal code generation: Server-side only (no client bundle impact)

**Total Impact**: ~4-6KB additional client-side JavaScript (negligible)

#### Image Loading

**Payconiq Assets**:
- Logo: 9.5KB (already exists, webp format - optimal)
- Mobile instructions: Size unknown (use `priority` for above-fold content)
- Desktop instructions: Size unknown (use `priority` for above-fold content)

**Next.js Image Optimization**:
- ✅ Automatic format conversion (AVIF, WebP)
- ✅ Responsive sizing
- ✅ Lazy loading by default (disable with `priority` for payment instructions)

**Recommendation**: Add `priority` prop to payment instruction images as they're critical content:
```tsx
<Image src="/pay/pay-mobile.png" alt="..." width={360} height={780} priority />
```

#### Animation Performance

**AuroraText Animation**:
- Uses CSS `background-position` animation (GPU-accelerated)
- 10-second duration (smooth, not janky)
- Single element animation (low CPU usage)
- No JavaScript animation loop (pure CSS)

**Performance Impact**: ✅ Minimal (CSS animations are highly optimized)

### Security Considerations

#### Payment Information Display

**Payconiq Instructions**: Images displayed to users contain:
- QR code for payment
- Payment instructions
- No sensitive account details exposed in component code

**Security Notes**:
- Images served from public directory (appropriate for public instructions)
- No environment variables needed for Payconiq display
- Payment confirmation is server-side only (via Server Actions)

**Verified Pattern**: Existing IBAN form shows account details are stored in environment variables (server-side), not in client components.

### Type Safety Validation

#### TypeScript Interfaces

**Existing Types** (from `@/types/supabase`):
- ✅ `Item` type already defined and used throughout
- ✅ Payment form props interfaces established
- ✅ Server Action types validated

**New Types Needed**: None (all existing patterns apply to Payconiq)

**Type Safety**:
- Payment method type: `'full' | 'partial'` (established pattern)
- Router navigation uses searchParams (type-safe in Next.js 15)
- Server Actions use validated schemas (pattern established)

### Discovery Summary

#### All Components Available: ✅ **YES**

**Magic UI AuroraText**:
- ✅ Available via MCP tool verification
- ✅ Installation command confirmed
- ✅ API and props documented
- ⚠️ Requires custom CSS keyframe animation (simple addition)

**shadcn/ui Components**:
- ✅ All required components already installed (Button, Card, Input, Label, Textarea, Checkbox)
- ✅ No additional component installations needed

**Payment Assets**:
- ✅ All Payconiq assets confirmed in public directory
- ✅ Logo, mobile, and desktop instruction images present

#### Technical Blockers: ✅ **NONE**

**Zero Blocking Issues Identified**

**Minor Considerations**:
1. Aurora animation keyframe must be added to globals.css (simple, 8 lines)
2. HeroSection must be converted to client component (add 'use client' directive)
3. Database migration should be tested locally before production push (standard practice)
4. Browser accessibility check for smooth scrolling (already respects prefers-reduced-motion)

#### Ready for Implementation: ✅ **YES**

**Pre-Implementation Checklist Status**:
- ✅ All component paths verified and correct
- ✅ No component confusion or similar-named components
- ✅ All file locations confirmed to exist
- ✅ Asset availability verified
- ✅ Pattern reusability validated (IBAN form → Payconiq form)
- ✅ Database function modification strategy defined
- ✅ Type safety confirmed (no new types needed)
- ✅ Performance impact assessed (minimal)
- ✅ Security considerations reviewed (no issues)

#### Special Notes

**1. Color Customization Recommendation**:
Default AuroraText colors are vibrant tech colors (hot pink, purple, blue). Consider customizing to match warm coral/peach baby gift list theme:
```tsx
colors={['#E77376', '#EB844F', '#F5B97F', '#E77376']} // Theme-matching gradient
```

**2. Component Architecture Decision**:
HeroSection requires client component conversion for AuroraText. Recommend adding scroll button in same component rather than creating separate client component. This keeps related functionality together and reduces component complexity.

**3. Migration Testing Priority**:
Animal gift code function should be thoroughly tested locally with multiple generations to verify:
- No duplicate codes generated
- Both animal lists used correctly
- PostgreSQL 1-based array indexing handled correctly
- Codes are readable and memorable (main goal of change)

**4. PayPal Archival Strategy**:
Rather than deleting PayPal implementation, moving to `_archived` directory preserves work and allows easy restoration if Payconiq needs replacement. This is best practice for payment method changes.

**5. Responsive Image Sizing**:
Payment instruction images should be sized appropriately:
- Mobile: Likely portrait orientation (e.g., 360x780 as plan suggests)
- Desktop: Likely landscape orientation (e.g., 800x600 as plan suggests)
Verify actual image dimensions before implementation to ensure no distortion.

**6. Instructions Update Strategy**:
Two files contain "How does it work?" instructions:
- `item-modal.tsx`: User's first exposure
- `payment-method-selection.tsx`: Pre-payment reminder
Both should be updated consistently. IBAN form instructions should retain gift code mention as it's specific to that payment method.

### Required Installations

```bash
# Magic UI AuroraText Component
pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"

# No additional npm packages required
# All other dependencies already installed
```

### CSS Additions Required

Add to `app/globals.css` in the `@layer utilities` section:

```css
@layer utilities {
  /* Aurora Text Animation for Magic UI Component */
  @keyframes aurora {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
  }
  
  .animate-aurora {
    animation: aurora 10s ease-in-out infinite;
  }
}
```

### Database Migration Required

Create file: `supabase/migrations/[timestamp]_animal_gift_codes.sql`

```sql
-- Replace MD5 hash gift codes with memorable animal-based codes
-- Format: "ANIMAL1-ANIMAL2" (e.g., "PANDA-TIGER")

CREATE OR REPLACE FUNCTION generate_gift_code()
RETURNS TEXT AS $$
DECLARE
  code TEXT;
  exists BOOLEAN;
  animals_part1 TEXT[] := ARRAY[
    'PANDA', 'TIGER', 'EAGLE', 'WHALE', 'LION',
    'BEAR', 'WOLF', 'FOX', 'DEER', 'OTTER',
    'HAWK', 'OWL', 'RAVEN', 'SWAN', 'HERON',
    'KOALA', 'LEMUR', 'SLOTH', 'GECKO', 'PENGUIN'
  ];
  animals_part2 TEXT[] := ARRAY[
    'CHEETAH', 'JAGUAR', 'LYNX', 'BISON', 'MOOSE',
    'RABBIT', 'BEAVER', 'BADGER', 'MARTEN', 'FERRET',
    'FALCON', 'CONDOR', 'PELICAN', 'CRANE', 'STORK',
    'WOMBAT', 'QUOKKA', 'NUMBAT', 'IGUANA', 'TURTLE'
  ];
  animal1 TEXT;
  animal2 TEXT;
BEGIN
  LOOP
    -- Pick random animals from each list (PostgreSQL arrays are 1-indexed)
    animal1 := animals_part1[1 + floor(random() * array_length(animals_part1, 1))::int];
    animal2 := animals_part2[1 + floor(random() * array_length(animals_part2, 1))::int];
    code := animal1 || '-' || animal2;

    -- Check if code already exists
    SELECT EXISTS(
      SELECT 1 FROM contributions WHERE gift_code = code
    ) INTO exists;

    EXIT WHEN NOT exists;
  END LOOP;

  RETURN code;
END;
$$ LANGUAGE plpgsql;

-- Test the function (optional, can be removed after verification)
-- SELECT generate_gift_code();
```

### Architecture Pattern Validation

**Verified Patterns**:
- ✅ Server Component / Client Component split (Next.js 15 App Router)
- ✅ Server Actions for data mutations (`recordContribution`, etc.)
- ✅ Privacy controls with opt-out model (established in previous tasks)
- ✅ Responsive design with Tailwind breakpoints (`md:`, `hidden`, `block`)
- ✅ Copy-to-clipboard with visual feedback pattern (2-second confirmation)
- ✅ Next.js Image optimization for all images
- ✅ Form validation with React state and transition hooks

**No Architectural Changes Required**: All implementations follow established codebase patterns.

---

### Status Update

**Discovery Stage**: ✅ **COMPLETE**
**Technical Blockers**: ✅ **NONE IDENTIFIED**
**Ready for Execution**: ✅ **YES**

**Agent 4 (Execution) Can Proceed With**:
1. Magic UI AuroraText installation and integration
2. Scroll button implementation (desktop only)
3. Show All button desktop hide
4. Payconiq payment flow creation (using IBAN form as template)
5. Instructions simplification (remove steps 3 and gift code from general)
6. Animal gift code database migration
7. PayPal file archival

**Recommended Execution Order**:
1. CSS additions (aurora keyframes) - foundation for AuroraText
2. Magic UI installation - before hero section modification
3. Hero section updates (client component + AuroraText + scroll button) - visible changes
4. Show All button hide - quick win
5. Database migration - test locally before Payconiq form creation
6. Payconiq payment flow - major feature
7. Instructions simplification - affects item modal and payment selection
8. PayPal archival - cleanup

**Estimated Implementation Time**: 2-3 hours for experienced developer

