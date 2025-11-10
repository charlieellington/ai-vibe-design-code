# Screen 2: Item Detail Modal - Complete Implementation Plan

## Original Request

Build the Item Detail Modal for the baby gift list application as specified in the comprehensive build plan. This modal is a critical part of the user journey, appearing when users click on a gift item from the main grid and leading them through the payment contribution flow.

**Source:** baby-build-plan.md - Screen 2: Item Detail Modal (Phase 2)

## Design Context

### User Journey Context
This modal appears at Step 2 of the gift giver flow:
1. User browses gift grid on landing page
2. **User clicks on an item → Item Detail Modal opens** ← THIS COMPONENT
3. User selects payment option (full/partial)
4. User navigates to payment instructions page
5. User completes contribution
6. User lands on thank you page

### Visual & UX Requirements

**Modal Layout:**
- Full-screen overlay on mobile, centered modal on desktop
- Large item photo at the top (optimized, larger than grid thumbnail)
- Clean, spacious layout with good readability
- Mobile-first approach (most visitors will be on phones)

**Content Display:**
- Item photo (larger view than grid card)
- Item title (prominent, clear typography)
- Full description (may be longer than grid snippet)
- Price display in euros (€) - prominent, clear
- Payment options section with two buttons:
  - "Gift Full Amount" button (primary CTA)
  - "Contribute Partial Amount" button (secondary CTA)
- "How does this work?" expandable section (accordion/details)
  - Explains payment flow
  - Clarifies gift code system
  - Mentions duplicate prevention
- Close button (X icon, top-right)

**Interaction Behavior:**
- Opens when item clicked from grid
- Smooth entrance animation (slide up on mobile, fade + scale on desktop)
- Focus trap (keyboard navigation contained within modal)
- ESC key closes modal
- Click outside (backdrop) closes modal
- Accessible (ARIA labels, focus management)
- Smooth exit animation
- Routes to payment instructions page when payment option selected

**Accessibility:**
- Focus trap when modal open
- Focus returns to trigger element on close
- ESC key to close
- Clear focus indicators
- Screen reader announcements
- ARIA dialog role
- ARIA labelledby and describedby

## Codebase Context

### Current Implementation Status
- **Project Phase:** Phase 2 - Public-Facing Features Implementation
- **Dependencies Ready:**
  - Next.js 15 with App Router configured
  - Supabase client utilities in `lib/supabase/client.ts`
  - TypeScript types defined in `types/supabase.ts`
  - Tailwind CSS configured
  - shadcn/ui components available

### Required shadcn/ui Components
Need to install these if not already present:
```bash
npx shadcn@latest add dialog   # For modal structure
npx shadcn@latest add sheet    # Alternative for mobile-friendly modal
```

**Decision:** Use Dialog for desktop, Sheet for mobile (responsive approach)

### Existing Components to Integrate With

**From Phase 2, Step 2.1-2.4 (Screen 1):**
- `/components/gift-list/gift-grid.tsx` - This will trigger the modal
- `/components/gift-list/gift-card.tsx` - Individual cards that open modal on click
- `/app/page.tsx` - Main landing page where grid lives

**Integration Points:**
- Modal will be opened from GiftCard onClick handler
- Modal receives full item data as props (Item type from `types/supabase.ts`)
- Modal triggers navigation to `/payment` route with item context

### Data Flow

**Item Type Structure (from `types/supabase.ts`):**
```typescript
export interface Item {
  id: string;
  title: string;
  description: string | null;
  price: number;
  image_url: string | null;
  category: 'essentials' | 'experiences' | 'big-items' | 'donation';
  priority: number;
  available: boolean;
  created_at: string;
  updated_at: string;
}
```

**State Management Needs:**
- Modal open/closed state
- Selected item data
- Selected payment type (full/partial)
- Generated gift code (for payment page)

### Image Optimization Context

**From Phase 1.6 - Image Storage Foundation:**
- Images stored in Supabase storage bucket: `item-images`
- Images already compressed (max 1MB, 1200px dimension)
- Use Next.js Image component with proper sizing
- Larger image view than grid (grid was ~48h, modal should be ~300-400h on mobile)

**Image Component Configuration:**
```typescript
<Image
  src={item.image_url}
  alt={item.title}
  width={800}   // Larger than grid thumbnail
  height={600}  // Larger than grid thumbnail
  className="object-cover rounded-lg"
  priority={false}  // Modal content, not above fold
  sizes="(max-width: 768px) 100vw, 800px"
/>
```

### Navigation Integration

**Payment Route Structure:**
- Destination: `/app/payment/page.tsx`
- Need to pass item context (likely via URL params or React state)
- Payment type (full/partial) needs to persist to payment page
- Consider using URL search params: `/payment?item=<id>&type=<full|partial>`

## Prototype Scope

**Frontend Focus:**
- ✅ Complete UI implementation of modal
- ✅ State management for modal open/close
- ✅ Navigation to payment page with item context
- ✅ Accessible, responsive modal experience
- ✅ Smooth animations and transitions

**Out of Scope (Backend will handle later):**
- ❌ Gift code generation logic (will be implemented in payment page server action)
- ❌ Database queries for item data (already handled by landing page)
- ❌ Contribution recording (happens on payment page)

**Mock Data Needs:**
- None - Component receives real item data from parent
- Item data already fetched on landing page

## Plan

### Step 2.5: Item Modal Component Implementation

**File:** `/components/gift-list/item-modal.tsx`

**Component Structure:**
```typescript
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Image from 'next/image';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogClose } from '@/components/ui/dialog';
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription, SheetClose } from '@/components/ui/sheet';
import { Button } from '@/components/ui/button';
import { Item } from '@/types/supabase';
import { X } from 'lucide-react';

interface ItemModalProps {
  item: Item | null;
  isOpen: boolean;
  onClose: () => void;
}

export function ItemModal({ item, isOpen, onClose }: ItemModalProps) {
  const router = useRouter();
  const [isExpanded, setIsExpanded] = useState(false);

  // Handle payment option selection
  const handlePaymentOption = (type: 'full' | 'partial') => {
    if (!item) return;
    
    // Navigate to payment page with item context
    router.push(`/payment?item=${item.id}&type=${type}`);
    onClose(); // Close modal before navigation
  };

  if (!item) return null;

  // Modal content component (reused for both Dialog and Sheet)
  const ModalContent = () => (
    <>
      {/* Item Image */}
      <div className="relative w-full h-64 md:h-80 rounded-lg overflow-hidden">
        <Image
          src={item.image_url || '/images/placeholder.jpg'}
          alt={item.title}
          fill
          sizes="(max-width: 768px) 100vw, 800px"
          className="object-cover"
        />
      </div>

      {/* Item Details */}
      <div className="space-y-4">
        <div>
          <h2 className="text-2xl font-semibold mb-2">{item.title}</h2>
          <p className="text-muted-foreground">{item.description}</p>
        </div>

        {/* Price Display */}
        <div className="text-3xl font-bold">€{item.price.toFixed(2)}</div>

        {/* Payment Options */}
        <div className="space-y-3">
          <Button
            onClick={() => handlePaymentOption('full')}
            className="w-full"
            size="lg"
          >
            Gift Full Amount
          </Button>
          <Button
            onClick={() => handlePaymentOption('partial')}
            variant="outline"
            className="w-full"
            size="lg"
          >
            Contribute Partial Amount
          </Button>
        </div>

        {/* How does this work? Expandable */}
        <details className="group">
          <summary className="cursor-pointer list-none flex items-center justify-between p-4 rounded-lg border hover:bg-accent transition-colors">
            <span className="font-medium">How does this work?</span>
            <span className="transition-transform group-open:rotate-180">
              <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </span>
          </summary>
          <div className="p-4 pt-2 space-y-2 text-sm text-muted-foreground">
            <p>
              <strong>1. Choose your contribution:</strong> Select whether you'd like to gift the full amount or contribute partially.
            </p>
            <p>
              <strong>2. Payment instructions:</strong> You'll receive our payment details (IBAN/PayPal) and a unique gift code.
            </p>
            <p>
              <strong>3. Send your gift:</strong> Transfer your chosen amount with your gift code in the reference.
            </p>
            <p>
              <strong>4. Let us know:</strong> Confirm you've sent the payment so we can mark this item appropriately.
            </p>
            <p className="text-xs mt-3">
              <em>Your unique gift code helps us track contributions and avoid duplicates!</em>
            </p>
          </div>
        </details>
      </div>
    </>
  );

  // Use Sheet for mobile (< 768px), Dialog for desktop
  return (
    <>
      {/* Mobile: Sheet (slides up from bottom) */}
      <div className="md:hidden">
        <Sheet open={isOpen} onOpenChange={onClose}>
          <SheetContent side="bottom" className="h-[90vh] overflow-y-auto">
            <SheetHeader>
              <SheetTitle className="sr-only">{item.title}</SheetTitle>
              <SheetDescription className="sr-only">
                View details and gift options for {item.title}
              </SheetDescription>
            </SheetHeader>
            <div className="space-y-6 pb-6">
              <ModalContent />
            </div>
          </SheetContent>
        </Sheet>
      </div>

      {/* Desktop: Dialog (centered modal) */}
      <div className="hidden md:block">
        <Dialog open={isOpen} onOpenChange={onClose}>
          <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle className="sr-only">{item.title}</DialogTitle>
              <DialogDescription className="sr-only">
                View details and gift options for {item.title}
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-6">
              <ModalContent />
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </>
  );
}
```

**Implementation Notes:**
- Uses shadcn Dialog for desktop, Sheet for mobile
- Responsive image sizing with Next.js Image optimization
- Accessible with proper ARIA labels and focus management
- Clean separation of modal content (DRY principle)
- Smooth animations built into shadcn components
- Price formatted as euros with 2 decimal places
- Navigation uses Next.js router with query params

### Step 2.6: Create Payment Flow Hook

**File:** `/hooks/use-payment-flow.ts`

```typescript
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Item } from '@/types/supabase';

export type PaymentType = 'full' | 'partial';

interface PaymentFlowState {
  selectedItem: Item | null;
  paymentType: PaymentType | null;
  isModalOpen: boolean;
}

export function usePaymentFlow() {
  const router = useRouter();
  const [state, setState] = useState<PaymentFlowState>({
    selectedItem: null,
    paymentType: null,
    isModalOpen: false,
  });

  // Open modal with selected item
  const openModal = (item: Item) => {
    setState({
      selectedItem: item,
      paymentType: null,
      isModalOpen: true,
    });
  };

  // Close modal and reset state
  const closeModal = () => {
    setState({
      selectedItem: null,
      paymentType: null,
      isModalOpen: false,
    });
  };

  // Navigate to payment page with full context
  const navigateToPayment = (itemId: string, type: PaymentType) => {
    // Navigate with item and type in URL params
    router.push(`/payment?item=${itemId}&type=${type}`);
    
    // Close modal after navigation initiated
    closeModal();
  };

  return {
    selectedItem: state.selectedItem,
    paymentType: state.paymentType,
    isModalOpen: state.isModalOpen,
    openModal,
    closeModal,
    navigateToPayment,
  };
}
```

**Hook Usage:**
```typescript
// In parent component (e.g., gift-grid.tsx)
const { selectedItem, isModalOpen, openModal, closeModal } = usePaymentFlow();

// When gift card clicked:
<GiftCard 
  item={item} 
  onClick={() => openModal(item)} 
/>

// Render modal:
<ItemModal 
  item={selectedItem} 
  isOpen={isModalOpen} 
  onClose={closeModal} 
/>
```

### Step 2.7: Integration with Gift Grid

**Update:** `/components/gift-list/gift-card.tsx`

Add onClick handler that triggers modal:

```typescript
interface GiftCardProps {
  item: Item;
  onClick: () => void;
}

export function GiftCard({ item, onClick }: GiftCardProps) {
  return (
    <div 
      onClick={onClick}
      className="cursor-pointer rounded-lg border overflow-hidden hover:shadow-lg transition-shadow"
      role="button"
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          onClick();
        }
      }}
    >
      {/* Existing card content */}
    </div>
  );
}
```

**Update:** `/components/gift-list/gift-grid.tsx`

Add modal state and handler:

```typescript
'use client';

import { useState } from 'react';
import { GiftCard } from './gift-card';
import { ItemModal } from './item-modal';
import { Item } from '@/types/supabase';

interface GiftGridProps {
  items: Item[];
}

export function GiftGrid({ items }: GiftGridProps) {
  const [selectedItem, setSelectedItem] = useState<Item | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  const handleItemClick = (item: Item) => {
    setSelectedItem(item);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    // Delay clearing selectedItem until after modal close animation
    setTimeout(() => setSelectedItem(null), 300);
  };

  return (
    <>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {items.map((item) => (
          <GiftCard 
            key={item.id} 
            item={item} 
            onClick={() => handleItemClick(item)}
          />
        ))}
      </div>

      <ItemModal 
        item={selectedItem}
        isOpen={isModalOpen}
        onClose={handleCloseModal}
      />
    </>
  );
}
```

### Step 2.8: Install Required Dependencies

```bash
# Install shadcn dialog and sheet components if not already present
npx shadcn@latest add dialog
npx shadcn@latest add sheet

# Install lucide-react for icons if not already present
npm install lucide-react
```

### Step 2.9: Testing Checklist

**Functionality:**
- [ ] Modal opens when gift card clicked
- [ ] Modal displays correct item data (image, title, description, price)
- [ ] Image loads with proper optimization
- [ ] "Gift Full Amount" button navigates to `/payment?item=<id>&type=full`
- [ ] "Contribute Partial Amount" button navigates to `/payment?item=<id>&type=partial`
- [ ] "How does this work?" expands/collapses correctly
- [ ] Close button (X) closes modal
- [ ] ESC key closes modal
- [ ] Click outside (backdrop) closes modal

**Responsive Design:**
- [ ] Sheet component (slide up) used on mobile (< 768px)
- [ ] Dialog component (centered) used on desktop (>= 768px)
- [ ] Modal content readable on small screens (320px+)
- [ ] Image aspect ratio maintained across screen sizes
- [ ] Buttons properly sized for touch targets (44px minimum)
- [ ] Scrollable when content exceeds viewport height

**Accessibility:**
- [ ] Focus trapped within modal when open
- [ ] Focus returns to trigger element (gift card) when closed
- [ ] ESC key closes modal
- [ ] Screen reader announces modal opening
- [ ] ARIA labels present and descriptive
- [ ] Keyboard navigation works throughout
- [ ] Focus indicators visible

**Performance:**
- [ ] Modal opens smoothly without lag
- [ ] Animations run at 60fps
- [ ] Image loads quickly (already compressed from Phase 1.6)
- [ ] No layout shift when modal opens
- [ ] Modal closes cleanly without console errors

**Edge Cases:**
- [ ] Missing item image shows placeholder
- [ ] Long item titles don't break layout
- [ ] Long descriptions are fully scrollable
- [ ] Very long prices format correctly
- [ ] Multiple rapid clicks don't cause issues
- [ ] Browser back button doesn't break state

## Integration Points

### Upstream Dependencies
- **Screen 1: Landing Page with Gift Grid** (Phase 2, Steps 2.1-2.4)
  - GiftGrid component must be implemented first
  - GiftCard component must be clickable
  - Item data must be fetched from Supabase

### Downstream Dependencies
- **Screen 3: Payment Instructions Page** (Phase 2, Step 2.7)
  - Must accept URL params: `item` and `type`
  - Must fetch item data based on item ID
  - Must display appropriate form based on payment type

### Technical Integration Requirements

**Modal State Management:**
```typescript
// Parent component (gift-grid.tsx) manages:
- Selected item (which item modal should display)
- Modal open/closed state
- Item click handler

// Modal component (item-modal.tsx) manages:
- Internal UI state (expandable sections)
- Navigation to payment page
- Payment type selection
```

**Data Flow:**
1. User clicks GiftCard → onClick handler fires
2. GiftGrid updates state: selectedItem, isModalOpen
3. ItemModal receives item prop and isOpen prop
4. ItemModal renders with item data
5. User selects payment option → navigateToPayment called
6. URL updated: `/payment?item=<id>&type=<type>`
7. Modal closed
8. Payment page loads with context from URL params

**URL Structure for Payment Page:**
```
/payment?item=550e8400-e29b-41d4-a716-446655440000&type=full
/payment?item=550e8400-e29b-41d4-a716-446655440000&type=partial
```

Payment page will:
- Parse `item` param to fetch item data
- Parse `type` param to determine payment form display
- Generate gift code server-side
- Display payment instructions

## Stage

Ready for Manual Testing

## Review Notes

### Requirements Coverage ✅
✓ Modal layout (full-screen mobile, centered desktop)
✓ Large item photo display
✓ Item details (title, description, price)
✓ Payment options (full/partial buttons)
✓ "How does this work?" expandable section
✓ Close functionality (X button, ESC key, backdrop click)
✓ Smooth animations
✓ Accessibility (focus trap, ARIA labels, keyboard nav)
✓ Navigation to payment page with context

### Technical Validation ✅
- **Component Integration Compatibility**: 
  ✓ GiftCard already has `onSelect` prop (plan uses `onClick` - minor naming difference)
  ✓ GiftGrid has onSelect handler with TODO comment at line 60
  ✓ Item type structure matches types/supabase.ts
  
- **File Path Verification**:
  ✓ `/components/gift-list/gift-grid.tsx` exists
  ✓ `/components/gift-list/gift-card.tsx` exists 
  ✓ `/types/supabase.ts` exists
  ✓ lucide-react already installed
  
- **Missing Dependencies** (need installation):
  ⚠️ `@radix-ui/react-dialog` (for Dialog component)
  ⚠️ `@radix-ui/react-sheet` (for Sheet component)

### Visual Design Validation ✅
- **Responsive Approach**: Sheet for mobile, Dialog for desktop is excellent UX pattern
- **Image Sizing**: Fixed height (h-64 mobile, h-80 desktop) prevents layout shift
- **Touch Targets**: Button size="lg" ensures 44px+ touch targets
- **Semantic Colors**: Plan uses theme tokens (bg-background, text-foreground, etc.)
- **Sheet Height**: h-[90vh] leaves room for browser chrome, good mobile consideration

### State Management Validation ✅
- **Parent/Child Separation**: Clean separation of concerns
- **Modal Animation Delay**: 300ms delay for clearing selectedItem prevents flicker
- **URL Params Approach**: Good for payment page context passing
- **Hook vs Inline State**: Both approaches provided, flexible implementation

### Accessibility Validation ✅
- **Focus Management**: Focus trap and return to trigger element
- **ARIA Labels**: Proper dialog/sheet descriptions 
- **Keyboard Support**: ESC key, Enter/Space on card
- **Screen Reader**: sr-only titles and descriptions

### Edge Cases Addressed ✅
- Missing item image → placeholder fallback
- Long descriptions → scrollable modal content
- Rapid clicks → handled by state management
- Null item check → early return prevents errors

### Minor Refinements Needed

1. **Prop Name Consistency**:
   - GiftCard uses `onSelect` prop, not `onClick`
   - Plan should update to use consistent naming

2. **Dependency Installation**:
   - Dialog and Sheet components need installation
   - Commands provided in plan are correct

3. **Image Blur Placeholder**:
   - Plan mentions `placeholder="blur"` but no blur data URL implementation
   - GiftCard already has BLUR_PLACEHOLDER constant that could be reused

4. **Close Button Implementation**:
   - X icon mentioned but not shown in Dialog/Sheet headers
   - Consider if built-in close buttons are sufficient

### Risk Assessment: LOW ✅
- Simple UI component with no backend dependencies
- Integration points are clean and well-defined
- Prerequisites are mostly ready (just missing UI components)
- No performance concerns
- No security implications

## Questions for Clarification

### Image Aspect Ratio
**Question:** Should the modal image maintain a specific aspect ratio, or should it be flexible based on uploaded images?

**Options:**
1. Fixed aspect ratio (e.g., 16:9 or 4:3) with object-cover cropping
2. Flexible height based on image natural dimensions
3. Different ratios for mobile vs desktop

**Recommendation:** Fixed 4:3 aspect ratio with object-cover. This ensures:
- Consistent modal sizing across different items
- No layout shift when images load
- Professional appearance
- Works well for product photos

### Payment Type Persistence
**Question:** Should the payment type selection persist across page refreshes on the payment page?

**Options:**
1. URL params only (lost on refresh unless bookmarked)
2. localStorage backup (survives refresh)
3. Session storage (cleared when tab closed)

**Recommendation:** URL params only (simplest). Users are unlikely to refresh mid-flow, and if they do, they can easily return to the gift list and restart. Adds no complexity.

### Expandable "How does this work?" Default State
**Question:** Should the "How does this work?" section be expanded by default on first modal open?

**Options:**
1. Collapsed by default (cleaner, less overwhelming)
2. Expanded by default (ensures users see instructions)
3. Remember user preference in localStorage

**Recommendation:** Collapsed by default. This keeps the modal clean and action-focused. Users who need clarification will naturally click to expand.

## Priority

**High** - Core user journey component. Without this modal, users cannot proceed to payment.

## Dependencies

### Must Be Completed First:
- ✅ Phase 1: Foundation & Database Setup (COMPLETE)
- ✅ Phase 1.5: Streamline Existing Boilerplate (COMPLETE)
- ✅ Phase 1.6: Image Storage Foundation (COMPLETE)
- 🚧 Phase 2, Step 2.1-2.4: Screen 1 - Landing Page with Gift Grid (IN PROGRESS or TO DO)

### Can Be Developed In Parallel:
- Screen 3: Payment Instructions Page (independent, just needs to accept URL params)
- Screen 4: Thank You Page (independent)

### Blocks:
- Screen 3 integration (payment page needs this modal's URL structure)
- Complete Phase 2 implementation
- End-to-end user flow testing

## Created

2024-11-06

## Files

### New Files to Create:
- `/components/gift-list/item-modal.tsx` - Main modal component
- `/hooks/use-payment-flow.ts` - Payment flow state management hook

### Files to Modify:
- `/components/gift-list/gift-card.tsx` - Add onClick handler
- `/components/gift-list/gift-grid.tsx` - Add modal state management

### Dependencies to Install:
- shadcn/ui Dialog component (if not present)
- shadcn/ui Sheet component (if not present)
- lucide-react (for icons, if not present)

## Additional Context

### Design System Compliance

**Tailwind CSS v4 Best Practices:**
- Use semantic color tokens (`bg-background`, `text-foreground`, `border-border`)
- Avoid arbitrary values like `bg-[#1F2023]`
- Use standard spacing scale (`p-4`, `gap-6`, `mb-8`)
- Follow responsive breakpoints (`md:`, `lg:`)

**shadcn/ui Patterns:**
- Compound component pattern (Dialog + DialogContent + DialogHeader, etc.)
- Consistent prop naming (open, onOpenChange, etc.)
- Built-in accessibility features
- Theme-aware styling

**Next.js Image Best Practices:**
- Use `fill` for responsive containers
- Provide `sizes` attribute for responsive images
- Set `priority` for above-fold images (false for modal content)
- Use `placeholder="blur"` with blur data URL for better UX

### Security Considerations

**Client-Side:**
- No sensitive data in modal (prices are public)
- No API keys exposed
- Payment type passed via URL (visible, but not sensitive)
- Item IDs are UUIDs (not sequential, harder to guess)

**Navigation:**
- Using Next.js router.push (client-side navigation)
- URL params are validated on payment page
- No direct database manipulation from modal

### Performance Considerations

**Image Loading:**
- Images already compressed in Phase 1.6 (max 1MB, 1200px)
- Next.js Image component handles:
  - Lazy loading (except priority images)
  - Automatic format selection (WebP/AVIF)
  - Responsive srcset generation
  - Blur placeholder for smooth loading

**Modal Rendering:**
- Conditional rendering (only renders when open)
- Component lazy loaded with dynamic import if bundle size grows
- Smooth animations via shadcn built-in transitions
- No heavy computations in render

**Bundle Size:**
- Dialog/Sheet components are small (~10KB combined)
- lucide-react icons are tree-shakeable
- No additional heavy dependencies

### Mobile-First Considerations

**Touch Interactions:**
- Card click target: entire card (easy to tap)
- Button sizing: `size="lg"` for proper touch targets (44px+)
- Sheet component: designed for mobile (swipe to dismiss)
- Backdrop dismiss: works with tap on mobile

**Viewport Constraints:**
- Sheet: `h-[90vh]` to leave room for browser chrome
- Scrollable content: `overflow-y-auto` when content exceeds viewport
- Bottom sheet: natural mobile pattern (vs center modal)

**Network Considerations:**
- Images already optimized (Phase 1.6 compression)
- Modal content is minimal (no heavy data fetching)
- Navigation is instant (client-side routing)

## Success Criteria

### User Experience:
- [ ] Modal opens instantly when item clicked
- [ ] All item information clearly visible
- [ ] Payment options obvious and accessible
- [ ] "How does this work?" provides helpful context
- [ ] Modal feels native to mobile devices
- [ ] Navigation to payment page is seamless

### Technical Quality:
- [ ] No console errors or warnings
- [ ] Animations run smoothly (60fps)
- [ ] Images load quickly and look sharp
- [ ] Code is well-organized and commented
- [ ] TypeScript types are complete and accurate
- [ ] Component is reusable and maintainable

### Accessibility:
- [ ] WCAG 2.1 Level AA compliance
- [ ] Screen reader announces modal opening
- [ ] Keyboard navigation works perfectly
- [ ] Focus management is correct
- [ ] Color contrast ratios meet standards

---

**COMPLETE CONTEXT PRESERVED FROM baby-build-plan.md**

This document contains 100% of the context from the original build plan for Screen 2: Item Detail Modal, plus comprehensive implementation details, integration guidance, and considerations for future agents. No context has been lost or summarized.

---

## Technical Discovery

### Component Identification Verification ✅
- **Target Page**: Main landing page (`/app/page.tsx`)
- **Planned Components**: 
  - `/components/gift-list/item-modal.tsx` (NEW - to be created)
  - `/components/gift-list/gift-grid.tsx` (EXISTS - verified at line 59-62 with TODO for modal integration)
  - `/components/gift-list/gift-card.tsx` (EXISTS - has `onSelect` prop ready)
- **Verification Steps**:
  - [x] Traced from page file to actual rendered components
  - [x] Confirmed GiftCard has `onSelect` handler (not `onClick`)
  - [x] Verified GiftGrid has placeholder for modal integration
  - [x] No similar-named components that could cause confusion

### MCP Research Results

#### shadcn/ui Component Availability
**Research Method**: Used `mcp_shadcn-ui-server_list-components` tool

**Dialog Component**:
- **Available**: ✅ Yes, in shadcn/ui component list
- **Status**: NOT currently installed in `/components/ui/`
- **Installation Required**: `npx shadcn@latest add dialog`
- **Dependencies**: Will add `@radix-ui/react-dialog` package
- **Import Path**: `@/components/ui/dialog`
- **Components Included**: Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogClose
- **Bundle Impact**: ~15KB (Dialog + Portal + Focus management)

**Sheet Component**:
- **Available**: ✅ Yes, in shadcn/ui component list
- **Status**: NOT currently installed in `/components/ui/`
- **Installation Required**: `npx shadcn@latest add sheet`
- **Dependencies**: Built on `@radix-ui/react-dialog` (same as Dialog)
- **Import Path**: `@/components/ui/sheet`
- **Components Included**: Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription, SheetClose
- **Bundle Impact**: ~12KB (Sheet variant of Dialog)

#### Current Package Status
**Verified in package.json**:
- ✅ `lucide-react`: "^0.511.0" (already installed - icons ready)
- ✅ `next`: "latest" (Next.js 15 App Router compatible)
- ✅ `react`: "^19.0.0" (latest React with all features)
- ✅ `@radix-ui/react-slot`: "^1.2.2" (for Button component)
- ❌ `@radix-ui/react-dialog`: NOT installed (will be added with dialog/sheet)

#### Next.js Image Configuration Verification ✅
**Verified in next.config.ts**:
```typescript
images: {
  remotePatterns: [
    {
      protocol: 'https',
      hostname: '*.supabase.co',
      pathname: '/storage/v1/object/public/**',
    },
  ],
  formats: ['image/avif', 'image/webp'],
  minimumCacheTTL: 2678400, // 31 days
}
```
- ✅ Supabase storage URLs are whitelisted
- ✅ Modern image formats enabled (AVIF, WebP)
- ✅ Long cache TTL configured
- ✅ Responsive breakpoints configured
- **No configuration changes needed** ✅

#### TypeScript Type Verification ✅
**Verified in types/supabase.ts**:
- ✅ Item interface matches plan exactly (lines 9-20)
- ✅ All required fields present: id, title, description, price, image_url, category, priority, available
- ✅ Category type union matches: 'essentials' | 'experiences' | 'big-items' | 'donation'
- ✅ Category utility type available: `export type Category = Item['category'] | 'all'`

### Implementation Feasibility Assessment

#### Integration Points Validated ✅

**GiftCard Component** (`/components/gift-list/gift-card.tsx`):
- ✅ Has `onSelect` prop (not `onClick` as in plan - **REFINEMENT NEEDED**)
- ✅ Already receives full Item object
- ✅ Implements keyboard accessibility (onKeyDown handler)
- ✅ Has stopPropagation on favorite button to prevent conflicts
- **Action Required**: Update plan to use `onSelect` instead of `onClick`

**GiftGrid Component** (`/components/gift-list/gift-grid.tsx`):
- ✅ Has TODO comment at line 60: `// TODO: Open item detail modal (Phase 2 Screen 2)`
- ✅ Already has `onSelect` handler structure: `onSelect={(item) => { console.log(...) }}`
- ✅ Perfect integration point for modal state management
- **No modifications needed to existing structure** ✅

#### State Management Approach Validation

**Planned Approach**: 
1. State in GiftGrid parent component
2. Modal receives item as prop
3. Close handler with animation delay

**Validation**:
- ✅ React 19 useState fully compatible
- ✅ 300ms delay for animation matches shadcn defaults
- ✅ Null check pattern prevents errors
- ✅ No hydration concerns (client component marked)

#### Navigation Verification

**Planned Navigation**:
- Uses `useRouter` from `next/navigation`
- URL params: `/payment?item=<id>&type=<full|partial>`

**Validation**:
- ✅ Next.js App Router supports client-side navigation
- ✅ Query params work with router.push()
- ✅ No existing useRouter conflicts in gift-list components
- ✅ Client component boundary properly defined

### CSS Component Integration Verification

#### shadcn Dialog/Sheet Default Styles
**Research Method**: Examined existing shadcn components (Card, Button) for pattern

**Expected Dialog Styles**:
- Fixed positioning with backdrop overlay
- z-index management for proper layering
- Focus trap and scroll lock built-in
- Smooth open/close animations
- Theme-aware background and border colors

**Expected Sheet Styles**:
- Slide-in animation from specified side
- Mobile-optimized with swipe-to-dismiss
- Same backdrop and focus management as Dialog
- `h-[90vh]` height leaves room for browser chrome ✅

**Conflict Risk**: ⚠️ LOW
- Modal components are isolated (don't affect grid layout)
- No wrapper conflicts expected
- Animations are CSS-only (no JS conflicts)

### Technical Blockers Assessment

#### No Blocking Issues Found ✅

**Verified**:
- ✅ All required components available in shadcn/ui
- ✅ Next.js Image configuration ready for Supabase images
- ✅ TypeScript types complete and accurate
- ✅ Integration points exist and are well-structured
- ✅ No version conflicts or compatibility issues
- ✅ Navigation approach is sound
- ✅ State management pattern is appropriate

#### Minor Refinements Required

1. **Prop Name Consistency**:
   - Plan uses `onClick` on GiftCard
   - Actual component uses `onSelect`
   - **Action**: Update implementation to use `onSelect`

2. **Blur Placeholder Optimization**:
   - GiftCard already has BLUR_PLACEHOLDER constant
   - **Recommendation**: Import and reuse in ItemModal
   - **Location**: Line 12 of gift-card.tsx

3. **Close Button Implementation**:
   - Plan mentions X icon from lucide-react
   - shadcn Dialog/Sheet include built-in close buttons
   - **Recommendation**: Use built-in close buttons (simpler)

### Required Installations

```bash
# Install shadcn Dialog component
npx shadcn@latest add dialog

# Install shadcn Sheet component  
npx shadcn@latest add sheet

# Verify lucide-react is installed (should already be present)
# npm list lucide-react
```

**Installation will add**:
- `@radix-ui/react-dialog` package (~15KB)
- `components/ui/dialog.tsx` file
- `components/ui/sheet.tsx` file

**Total bundle impact**: ~27KB combined (Dialog + Sheet)

### Discovery Summary

- **All Components Available**: ✅ YES
- **Technical Blockers**: ✅ NONE
- **Ready for Implementation**: ✅ YES
- **Prerequisites**: Install Dialog and Sheet components only
- **Integration Risk**: LOW - Clean integration points exist
- **Performance Impact**: Minimal - 27KB for modal components
- **Special Notes**: 
  - Use `onSelect` prop instead of `onClick` for consistency
  - Reuse existing BLUR_PLACEHOLDER from GiftCard
  - Next.js Image config already optimized for Supabase
  - Consider using built-in close buttons instead of custom X icon

**Estimated Implementation Time**: 2-3 hours
- 15 minutes: Install components
- 60 minutes: Build ItemModal component
- 30 minutes: Update GiftGrid integration
- 30 minutes: Testing and refinement

**Agent 4 is cleared to proceed with execution.** All technical details verified and documented.

## Implementation Notes

### Files Created:
1. **`/components/gift-list/item-modal.tsx`** - Main modal component
   - Dual rendering approach: Sheet for mobile (< 768px), Dialog for desktop
   - Reused BLUR_PLACEHOLDER from GiftCard component
   - Responsive image sizing (h-64 mobile, h-80 desktop)
   - Payment option buttons navigate to `/payment?item=<id>&type=<type>`
   - Native HTML `<details>` for "How does this work?" expandable section
   - Proper ARIA labels and screen reader support
   - Null item check prevents errors

### Files Modified:
2. **`/components/gift-list/gift-grid.tsx`** - Added modal state management
   - Added state: `selectedItem` (Item | null) and `isModalOpen` (boolean)
   - Added `handleItemClick` to set selected item and open modal
   - Added `handleCloseModal` with 300ms animation delay before clearing selectedItem
   - Updated `onSelect` callback to use `handleItemClick` instead of console.log
   - Added ItemModal component to JSX

### Components Installed:
3. **shadcn/ui Dialog** - `npx shadcn@latest add dialog`
   - Added `@radix-ui/react-dialog` package
   - Created `/components/ui/dialog.tsx`
   - Bundle impact: ~15KB

4. **shadcn/ui Sheet** - `npx shadcn@latest add sheet`
   - Uses same `@radix-ui/react-dialog` package
   - Created `/components/ui/sheet.tsx`
   - Bundle impact: ~12KB

### Implementation Decisions:
- **Did not create** `/hooks/use-payment-flow.ts` - Simpler inline state management in GiftGrid was sufficient
- **Reused** BLUR_PLACEHOLDER from GiftCard (line 12) for consistency
- **Used** native `<details>` element instead of Accordion component for expandable section (simpler, no additional dependencies)
- **Used** built-in Dialog/Sheet close buttons (no custom X icon needed)
- **Maintained** existing `onSelect` prop naming (already in GiftCard)

### Build Verification:
- ✅ TypeScript compilation: No errors
- ✅ Build process: Successful (4.2s compile time)
- ✅ No console warnings related to our changes
- ✅ All existing routes still functional

### Total Implementation Time:
Approximately 30 minutes from start to finish.

## Manual Test Instructions

### Setup for Testing
1. **Start development server**: `pnpm run dev` (or user's preferred command)
2. **Navigate to**: `http://localhost:3000` (main landing page)
3. **Open browser DevTools**: Console tab for error monitoring

### Visual Verification Checklist

#### Desktop Testing (>= 768px)
- [ ] Modal uses Dialog component (centered on screen)
- [ ] Modal has max width (doesn't span full screen)
- [ ] Modal has backdrop overlay (semi-transparent)
- [ ] Item image displays at h-80 height
- [ ] Image maintains aspect ratio with object-cover
- [ ] Title displays in 2xl font size
- [ ] Description text is readable (muted color)
- [ ] Price shows in euros with 2 decimal places (€XX.XX)
- [ ] "Gift Full Amount" button is primary style (filled)
- [ ] "Contribute Partial Amount" button is outline style
- [ ] Both buttons are full width and size="lg"
- [ ] "How does this work?" section is collapsed by default
- [ ] Close button (X) visible in top-right
- [ ] No layout shift when modal opens

#### Mobile Testing (< 768px)
- [ ] Modal uses Sheet component (slides up from bottom)
- [ ] Sheet takes 90vh height (leaves room for browser chrome)
- [ ] Item image displays at h-64 height
- [ ] Content is scrollable if it exceeds viewport
- [ ] Touch targets are 44px+ (buttons, close)
- [ ] No horizontal scrolling
- [ ] Backdrop overlay works on mobile

### Functional Testing

#### Modal Opening/Closing
1. **Click a gift card** from the grid
   - [ ] Modal opens smoothly
   - [ ] Correct item data displayed (verify title matches clicked card)
   - [ ] Image loads properly (check for placeholder if missing)
   - [ ] No console errors

2. **Close modal via close button (X)**
   - [ ] Modal closes with smooth animation
   - [ ] Returns to grid view
   - [ ] No console errors

3. **Close modal via ESC key**
   - [ ] ESC key closes modal
   - [ ] Focus returns to page

4. **Close modal via backdrop click**
   - [ ] Click outside modal (on backdrop)
   - [ ] Modal closes smoothly

5. **Test rapid clicking**
   - [ ] Click gift card multiple times quickly
   - [ ] Modal doesn't open multiple times or break

#### Payment Option Navigation
1. **Click "Gift Full Amount" button**
   - [ ] Navigates to `/payment` route
   - [ ] URL includes `?item=<id>&type=full` parameters
   - [ ] Modal closes before navigation
   - [ ] No console errors
   - **Note**: Payment page may not exist yet - check URL params are correct

2. **Click "Contribute Partial Amount" button**
   - [ ] Navigates to `/payment` route
   - [ ] URL includes `?item=<id>&type=partial` parameters
   - [ ] Modal closes before navigation
   - [ ] No console errors

#### "How does this work?" Expandable
1. **Click to expand**
   - [ ] Section expands smoothly
   - [ ] Chevron icon rotates 180 degrees
   - [ ] All 4 numbered steps visible
   - [ ] Text is readable
   - [ ] No layout issues

2. **Click to collapse**
   - [ ] Section collapses smoothly
   - [ ] Chevron returns to original position

### Responsive Testing

#### Breakpoints to Test:
- [ ] **Mobile small (375px)**: Sheet modal, full-width buttons, readable text
- [ ] **Mobile large (428px)**: Same as small mobile
- [ ] **Tablet (768px)**: Transition point - verify Dialog appears
- [ ] **Desktop (1024px)**: Dialog centered, proper spacing
- [ ] **Large desktop (1920px)**: Modal doesn't become too wide (max-w-2xl constraint)

### Accessibility Testing

#### Keyboard Navigation:
1. **Tab through page**
   - [ ] Can tab to gift cards
   - [ ] Enter/Space opens modal
   - [ ] Focus trapped within modal when open
   - [ ] Can tab through modal elements (buttons, expandable)
   - [ ] ESC closes modal
   - [ ] Focus returns to trigger card after close

2. **Screen Reader** (if available):
   - [ ] Announces modal opening
   - [ ] Reads item title and description
   - [ ] Announces button purposes
   - [ ] Properly describes "How does this work?" section

#### Visual Focus Indicators:
- [ ] Focus rings visible on all interactive elements
- [ ] Focus order is logical (image → title → buttons → expandable)

### Edge Cases Testing

1. **Missing image**
   - [ ] Find/create item without image_url
   - [ ] Modal shows "No image available" placeholder
   - [ ] Layout doesn't break

2. **Long title**
   - [ ] Find item with very long title
   - [ ] Title wraps properly
   - [ ] Doesn't overflow modal

3. **Long description**
   - [ ] Find item with long description
   - [ ] Description is scrollable within modal
   - [ ] No overflow issues

4. **Missing description**
   - [ ] Find item without description
   - [ ] Modal displays without description paragraph
   - [ ] No empty space or layout issues

5. **Very large price**
   - [ ] Find/create item with large price (e.g., €9999.99)
   - [ ] Price displays correctly formatted
   - [ ] Doesn't break layout

6. **Multiple items**
   - [ ] Open modal for item A
   - [ ] Close modal
   - [ ] Open modal for item B
   - [ ] Verify correct data shown (no stale data from item A)

### Performance Verification
- [ ] Modal opens without noticeable lag (<200ms)
- [ ] Animations run smoothly (no stuttering)
- [ ] Images load progressively with blur placeholder
- [ ] No memory leaks (open/close modal 10+ times)
- [ ] No console errors or warnings

### Cross-Browser Testing (if applicable)
- [ ] **Chrome**: All functionality works
- [ ] **Safari**: Sheet/Dialog rendering correct
- [ ] **Firefox**: No layout issues
- [ ] **Mobile Safari**: Sheet animation smooth

### Final Approval Criteria

✅ **Ready to mark Complete** if:
- All modal functionality works as expected
- Both Desktop (Dialog) and Mobile (Sheet) modes function correctly
- Payment button navigation works (even if payment page doesn't exist)
- Expandable section works smoothly
- All close methods (X, ESC, backdrop) work
- No console errors
- Responsive behavior is correct
- Accessibility features work (keyboard nav, focus trap)

❌ **Needs Work** if:
- Modal doesn't open or close properly
- Wrong item data displayed
- Navigation doesn't include correct URL params
- Layout breaks on any screen size
- Console errors present
- Accessibility issues found

---

**Implementation completed successfully on 2025-11-06**
**Ready for user manual testing and verification**
- Accessibility issues found

---

## Completion Status

**Completed**: 2025-11-06
**Agent**: Design Agent 6 (Completion & Self-Improvement)
**Branch**: main
**Stage**: Complete

### Implementation Summary

**Full Functionality**:
- ✅ Responsive modal implementation (Sheet for mobile < 768px, Dialog for desktop ≥ 768px)
- ✅ Conditional rendering using `useMediaQuery` with `window.matchMedia` to prevent both components showing simultaneously
- ✅ Image display with blur placeholder (reused from GiftCard component)
- ✅ Payment option buttons with proper navigation to `/payment?item=<id>&type=<full|partial>`
- ✅ Expandable "How does this work?" section using native HTML `<details>` element
- ✅ All close methods working (X button, ESC key, backdrop click)
- ✅ Proper state management with 300ms animation delay
- ✅ TypeScript compilation successful with no errors

**Next Step Required**:
- ⚠️ Payment page (`/app/payment/page.tsx`) needs to be built - currently redirects to auth page when buttons clicked
- Payment page should be public route (no authentication required per build plan)

**Key Files Modified**:
- 📁 `/components/gift-list/item-modal.tsx` (created) - 169 lines
- 📁 `/components/gift-list/gift-grid.tsx` (updated) - Added modal state and integration

**Dependencies Added**:
- 🔧 shadcn/ui Dialog component (`@radix-ui/react-dialog` package)
- 🔧 shadcn/ui Sheet component (uses same Radix package)

**Important Technical Note**:
- 💡 Portal-based React components (Dialog, Sheet) render outside the component tree via React portals
- 💡 CSS hiding classes (`md:hidden`, `hidden md:block`) don't work with portal components
- 💡 Solution: Conditional rendering based on `window.matchMedia` instead of CSS hiding

### User Corrections Identified: 1

**Issue**: Both mobile Sheet and desktop Dialog components rendered simultaneously
- **User Report**: "When I click an item card, the module comes up but behind it is also another view of it - I guess that's the mobile option - I'm guessing both aren't supposed to appear at the same time."
- **Root Cause**: Used CSS hiding classes on wrapper divs, which don't work with portal-based components
- **Fix**: Added `useMediaQuery` hook with `window.matchMedia('(max-width: 767px)')` to conditionally render only one component
- **Implementation**: Changed from rendering both wrapped in hidden divs to `if (isMobile) { return <Sheet /> } return <Dialog />`

### Agent Workflow Gaps Found: 1

**Gap in Agent 4 (Execution)**: No guidance on portal-based component rendering patterns
- Agent 4 correctly installed components and implemented the dual modal approach
- However, initial implementation used CSS hiding which doesn't work with portals
- This is a React-specific pattern that should be documented in execution guidelines

### Self-Improvement Analysis Results

**Chat Analysis Summary**:
- Total messages analyzed: ~15
- User corrections required: 1 (portal rendering issue)
- Iterations needed: 1 (conditional rendering fix)
- Build successful after fix: Yes (2.5s compilation)

**What Went Well** ✅:
- Agent 1 (Planning): Complete context gathering, all requirements captured
- Agent 2 (Review): Proper validation of requirements and technical approach
- Agent 3 (Discovery): Correct component identification and installation verification
- Agent 4 (Execution): Fast implementation (30 minutes), proper workflow compliance, moved task to Testing section correctly
- Agent 4 (Execution): Excellent fix response - identified issue immediately and implemented correct solution using `useMediaQuery`

**What Needs Improvement** ⚠️:
- Agent 4 missing knowledge about portal-based component behavior in React
- No existing pattern documentation for responsive modal implementations using shadcn/ui

**Prevention Measures Added**:
- Updated `design-4-execution.md` with portal-based component rendering pattern
- Added specific guidance on when to use conditional rendering vs CSS hiding
- Documented shadcn Dialog/Sheet behavior for future implementations

### Agent Files Updated with Improvements

**File: `design-4-execution.md`**
**Section Added**: "Portal-Based Component Rendering Pattern - Added 2025-11-06" (after line 46)

**Content Added**:
- **Problem Documentation**: CSS hiding classes (`md:hidden`, `hidden md:block`) don't work with portal-based components
- **Solution Pattern**: Use conditional rendering with `window.matchMedia` instead of CSS hiding
- **Code Examples**: Wrong (CSS hiding) vs Correct (JavaScript conditional rendering)
- **Technical Explanation**: Why React portals bypass CSS cascade from wrapper elements
- **When to Use**: List of shadcn/ui components that use portals (Dialog, Sheet, Popover, DropdownMenu, Tooltip, HoverCard)
- **Prevention Guidance**: Always use JavaScript-based conditional rendering for portal components

**Impact**: Future Agent 4 executions will now have documented guidance on implementing responsive modal/portal-based components, preventing the CSS hiding mistake from recurring.

### Workflow Performance Analysis

**Time to Implementation**: ~30 minutes total
**Iterations Required**: 2 (initial implementation + portal fix)
**User Satisfaction**: High - issue resolved quickly after being reported
**Agent Responsiveness**: Excellent - identified root cause immediately and implemented correct solution

**Workflow Strengths**:
- Fast initial implementation (30 minutes)
- Quick identification of portal rendering issue
- Correct fix implemented on first iteration
- Comprehensive documentation updates

**Workflow Improvements Made**:
- Added missing pattern to Agent 4 guidelines
- Documented React-specific portal behavior
- Created reusable code examples for future tasks

### Knowledge Capture Summary

**New Pattern Documented**: Portal-Based Component Rendering with Media Queries
**Affected Components**: Any shadcn/ui component using Radix UI portals
**Reusability**: High - pattern applies to Dialog, Sheet, Popover, DropdownMenu, Tooltip, HoverCard, and similar portal components
**Prevention Value**: High - common pattern in responsive implementations with modal-based components

**Documentation Locations**:
1. Task file: `/ai-vibe-design-code/documentation/design-agents-flow/done/item-detail-modal-implementation.md` (this file)
2. Agent guidelines: `/ai-vibe-design-code/documentation/design-agents-flow/design-4-execution.md` (line 47-107)
3. Status board: `/ai-vibe-design-code/documentation/design-agents-flow/status.md` (Complete section)

---

**Agent 6 Completion Workflow**: ✅ Complete
**Task Status**: Ready for Archive
**Next Steps**: Task can remain in Complete section for reference, or be moved to Archived Features when convenient

