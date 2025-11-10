---
kanban-plugin: board
---

# 📋 Design Agents Flow - Kanban Board

## 🔧 Obsidian Setup Instructions

**First time setup:**
1. Install [Obsidian](https://obsidian.md) 
2. Open your project's `documentation/` folder as an Obsidian vault
3. Install Kanban plugin: Settings → Community plugins → Browse → Search "Kanban" → Install & Enable
4. Open this file (status.md) - it will render as a visual kanban board

**How to use:**
- 🎯 **Visual Management**: See all tasks across pipeline stages
- 📝 **Add Tasks**: Type task titles in any column 
- 🖱️ **Drag & Drop**: Move tasks between stages visually
- 🔗 **Link to Details**: Task titles link to individual files in `doing/` folder
- ✅ **Mark Complete**: Check off completed tasks

**Agent Workflow:** Planning → Review → Discovery → Ready to Execute → Executing → Testing → Complete

---

## Planning

<!-- New tasks start here via @1-design-planning.md -->

## Review

<!-- Tasks move here via @2-design-review.md -->

## Discovery

<!-- Tasks move here via @3-design-discovery.md -->

## Ready to Execute

<!-- Tasks move here after technical discovery -->

## Executing

<!-- Tasks move here via @4-design-execution.md -->

## Testing

<!-- Tasks move here when implementation complete -->

## Complete

- [x] [Payment Flow Three-Screen Redesign](done/payment-flow-three-screen-redesign.md) ✅ Completed 2025-11-10
  **Implementation Notes:**
  - ✅ Full functionality: Three-screen payment flow (Screen 1: Form submission → Screen 2: Commitment confirmation → Screen 3: Payment instructions), payment state tracking without gift codes, item removal on commitment (full amount purchases), cancel flow with restoration, auto-release timer (30 min), admin dashboard verification workflow
  - ✅ Database: New `payment_attempts` table with 7 status states (form_submitted, commitment_shown, payment_shown, payment_confirmed, payment_cancelled, auto_released, admin_verified), timestamps for each screen transition, RLS policies for anon/authenticated roles, PostgreSQL function `check_and_release_expired_payments()` for auto-release
  - ✅ Screen 1 - Form: Mandatory name/email fields (fixed RLS policy errors), creates payment_attempt record, navigates to commitment page with attemptId parameter
  - ✅ Screen 2 - Commitment: Conditional messaging based on payment type (full amount: "take item off list", partial: "others can contribute", donation: "accepts multiple donations"), marks commitment_shown timestamp, Continue button triggers item removal (available: false for full amount non-donations), Cancel button restores item availability
  - ✅ Screen 3 - Instructions: Displays IBAN/Payconiq payment details, "I made the payment" button → thank you page, "I can't pay right now" button → cancellation message with "Continue to Gift List" button (item restored to available), both IBAN and Payconiq routes implemented
  - ✅ Item availability logic: Full amount non-donation items marked unavailable when Screen 2 Continue clicked (markPaymentShown), partial payments and donations keep items available, cancelled payments restore original availability and priority
  - ✅ Admin dashboard: PaymentAttemptsList component with 9 columns (item, contributor, email, amount, method, status badges, timestamps, actions), verify button for payment_confirmed status, auto-release check runs on dashboard page load, status color coding (blue→cyan→yellow→green/gray/orange/dark green)
  - ✅ Thank you page: Updated to accept attempt parameter instead of gift code, conditional message form (only shows if no message on Screen 1), auto-fills name/email from payment attempt
  - ⚠️ Implementation iterations: 3 user corrections needed - (1) RLS policy error fixed by allowing both anon and authenticated roles, (2) Screen 2 messaging made conditional based on payment type after user noted inaccuracy for partial/donation payments, (3) TypeScript error fixed by changing nested select to separate query
  - 📁 Files: `supabase/migrations/20251110000002_payment_state_tracking.sql` (NEW), `supabase/migrations/20251110000003_fix_payment_attempts_rls.sql` (NEW), `types/supabase.ts` (MODIFIED), `lib/payment-attempts/actions.ts` (NEW - 7 server actions), `components/payment/contributor-form.tsx` (MODIFIED - mandatory fields), `app/payment/iban/commitment/page.tsx` (NEW), `app/payment/payconiq/commitment/page.tsx` (NEW), `app/payment/iban/instructions/page.tsx` (NEW), `app/payment/iban/instructions/instructions-client.tsx` (NEW - cancel message flow), `app/payment/payconiq/instructions/page.tsx` (NEW), `app/payment/payconiq/instructions/instructions-client.tsx` (NEW - cancel message flow), `components/admin/payment-attempts-list.tsx` (NEW), `app/dashboard/page.tsx` (MODIFIED), `app/dashboard/actions.ts` (MODIFIED - getAllPaymentAttempts, runAutoReleaseCheck), `app/thank-you/thank-you-content.tsx` (MODIFIED - conditional form)
  - 🔧 Dependencies: None - all UI components already installed (Table, Badge, Button, Card from shadcn/ui)
  - 💡 Notes: Completely eliminated gift codes from user flow (still generated for old contributions table compatibility), admin verifies by matching names and amounts in bank account, Screen 2 commitment page is critical UX moment where item is reserved, cancel flow provides graceful recovery with item restoration, auto-release prevents indefinite holds (30-minute timer), payment_attempts table supplements existing contributions table (backward compatibility maintained)
  - 🧪 Testing: Database migrations applied successfully, TypeScript compilation passed, all screen transitions working, conditional messaging displays correctly for full/partial/donation types, admin dashboard shows payment attempts with proper filtering



- [x] [Add Donation-Only Items with No Visible Contribution Tallies](done/add-donation-only-items.md) ✅ Completed 2025-11-10
  **Implementation Notes:**
  - ✅ Full functionality: Donation-only item type with unlimited contributions, no visible contribution amounts anywhere in public UI, optional suggested amount (not displayed publicly), donations never marked unavailable, database trigger enforcement, admin-only statistics view
  - ✅ Database migration: Added `is_donation_only BOOLEAN DEFAULT false` and `suggested_amount DECIMAL(10,2)` to items table, PostgreSQL BEFORE UPDATE trigger prevents donation items from being marked unavailable, admin-only view for donation statistics (`admin_donation_stats`), auto-conversion of existing 'donation' category items to donation-only with suggested_amount set to price
  - ✅ Public UI - Zero amount visibility: Gift cards show only category badge (no price, no suggested amount, no badge), item modal shows only "Contribute to the [Title]" button with help text (no suggested amount, no badge), thank you page shows "Thank you for your donation!" (no amount), payment forms accept custom amounts but don't display totals
  - ✅ Business logic: Modified `markItemPurchased` in lib/items.ts to check is_donation_only flag before marking unavailable, donation items remain available indefinitely with unchanged priority, standard items behavior completely preserved
  - ✅ Admin dashboard: Add/edit forms include "Donation-only item" checkbox with conditional field switching (price vs suggested_amount), items table shows "Donation Fund" badge with suggested amount and total contributions (admin-only), full CRUD operations for donation items
  - ✅ Payment flows: Both IBAN and Payconiq forms handle donation items with custom amount input, suggested_amount used as placeholder (not displayed to user), different confirmation messages for donations (no amount shown)
  - ⚠️ Implementation iterations required: 1 user correction needed - initial plan included displaying "Suggested contribution: €X" and "Open for Contributions" badge on gift cards and modal, but user requested complete removal for cleaner, more minimal presentation (corrected in gift-card.tsx and item-modal.tsx)
  - ⚠️ User Action Required: Database migration needs to be run with `npx supabase db push` to apply donation-only schema changes (file: supabase/migrations/20251110000001_add_donation_only_items.sql)
  - 📁 Files: `supabase/migrations/20251110000001_add_donation_only_items.sql` (NEW - schema + trigger), `types/supabase.ts` (MODIFIED - is_donation_only, suggested_amount), `components/gift-list/gift-card.tsx` (MODIFIED - hide progress bar, hide price for donations), `components/gift-list/item-modal.tsx` (MODIFIED - hide price, donation-specific button/help text), `lib/items.ts` (MODIFIED - markItemPurchased donation check), `components/admin/add-item-form.tsx` (MODIFIED - donation checkbox, conditional fields), `components/admin/edit-item-form.tsx` (MODIFIED - same as add form), `components/admin/items-table.tsx` (MODIFIED - donation badge, admin stats), `app/dashboard/actions.ts` (MODIFIED - addItem, updateItem with is_donation_only), `app/payment/choose/payment-method-selection.tsx` (MODIFIED - donation display), `app/payment/iban/payment-form.tsx` (MODIFIED - custom amount for donations), `app/payment/payconiq/payconiq-payment-form.tsx` (MODIFIED - custom amount for donations), `app/thank-you/thank-you-content.tsx` (MODIFIED - hide amount for donations)
  - 🔧 Dependencies: None - all UI components already installed (Badge from shadcn/ui)
  - 💡 Notes: Database trigger provides robust enforcement even against manual admin edits, auto-conversion of existing donation category items ensures backward compatibility, TypeScript compilation successful with no errors, minimal public UI approach prevents any appearance of "money grabbing" as per user requirement
  - 🧪 Testing: TypeScript compilation passed, all 13 files modified successfully, donation items display cleanly with zero amount visibility, trigger enforcement ready for testing, admin dashboard shows private statistics
  - 📊 Self-improvement analysis: 1 user correction identified - initial design included visible suggested amount and badge on public cards/modals, but user preferred completely minimal presentation with zero hints about amounts. Planning phase should validate level of information display (minimal vs informative), Design phase should consider cultural/social sensitivities around money display, Execution phase should implement most minimal version first, then add displays only if explicitly requested.



- [x] [Baby Gift List Updates - User Feedback Implementation](done/baby-gift-list-updates.md) ✅ Completed 2025-11-10
  **Implementation Notes:**
  - ✅ Full functionality: Aurora Text animated gradient title, responsive scroll button with accessibility, desktop show-all logic with mobile pagination, Payconiq payment flow with mobile/desktop UX, simplified 2-step instructions, animal-based gift codes (PANDA-TIGER format)
  - ✅ Magic UI integration: Successfully installed AuroraText component via shadcn CLI, added custom CSS keyframes for aurora animation, customized colors to match warm baby gift list theme (#E77376, #EB844F, #F5B97F)
  - ✅ Hero section enhancements: Converted to client component for AuroraText and scroll functionality, added desktop-only "Browse Gifts" button with smooth scrolling and prefers-reduced-motion support, data attribute added to gifts section for scroll target
  - ✅ Desktop display optimization: Fixed show-all logic to display all items by default on desktop (not just hide button), implemented JavaScript-based responsive detection with window.matchMedia, mobile maintains pagination with "Show All" button
  - ✅ Payconiq payment system: Complete payment method replacement from PayPal, created full route structure (page.tsx, form component, actions), responsive UX with mobile direct link button (opens Payconiq app) vs desktop QR code images for scanning, Payconiq brand styling with #00A3E0 colors
  - ✅ Animal gift codes: PostgreSQL function migration from MD5 hash format ("F34E0-D993") to pure animal names ("PANDA-TIGER"), 20x20 animal arrays for 400 unique combinations, proper 1-based array indexing for PostgreSQL, collision detection maintained
  - ✅ Instructions simplification: Updated both item-modal.tsx and payment-method-selection.tsx, removed redundant contribution selection step (users already selected), simplified to 2 steps (Send Money + We'll purchase gift), removed gift code mention from general instructions (kept in IBAN only)
  - ⚠️ Implementation iterations required: 3 user corrections needed for: (1) desktop show-all display logic beyond just hiding button, (2) mobile Payconiq UX with direct link instead of QR code, (3) further instructions simplification to remove redundant steps
  - ⚠️ Build errors resolved: 2 TypeScript compilation errors fixed - module import error (copied actions.ts to payconiq directory instead of importing from archived PayPal), type error (updated giftCode parameter to allow null for Payconiq)
  - ⚠️ User Action Required: Database migration needs to be run with `npx supabase db push` to apply animal gift code function (file: supabase/migrations/20251110000000_animal_gift_codes.sql)
  - 📁 Files: `app/globals.css` (MODIFIED - aurora keyframes), `components/ui/aurora-text.tsx` (NEW via Magic UI), `components/gift-list/hero-section.tsx` (MODIFIED - client component, AuroraText, scroll button), `app/page.tsx` (MODIFIED - data attribute), `components/gift-list/gift-grid.tsx` (MODIFIED - desktop show-all logic), `supabase/migrations/20251110000000_animal_gift_codes.sql` (NEW), `app/payment/choose/payment-method-selection.tsx` (MODIFIED - Payconiq replacement, simplified instructions), `app/payment/payconiq/` (NEW - page.tsx, payconiq-payment-form.tsx, actions.ts), `components/gift-list/item-modal.tsx` (MODIFIED - simplified instructions), `app/payment/_archived/paypal/` (MOVED - page.tsx, paypal-payment-form.tsx, actions.ts)
  - 🔧 Dependencies: Magic UI AuroraText component (installed via `pnpm dlx shadcn@latest add "https://magicui.design/r/aurora-text.json"`, ~1-2KB, no new npm packages), all other UI components already installed
  - 💡 Notes: JavaScript-based responsive detection preferred over CSS-only for display logic changes, Payconiq mobile deep link pattern enables same-device payment flow, PayPal archived (not deleted) for potential future restoration, animal codes provide memorable user experience with sufficient uniqueness (400 combinations)
  - 🧪 Testing: Build successful with all routes compiled, TypeScript compilation passed with no errors, all 6 user requirements implemented, responsive behavior validated for mobile/desktop differences
  - 📊 Self-improvement analysis: 3 user corrections identified specific gaps in initial implementation - (1) hiding button vs changing display logic distinction, (2) mobile payment UX consideration for same-device scanning limitation, (3) context-aware instructions when users have already made selections. Planning phase should validate complete behavioral changes beyond visual hiding, Discovery phase should research platform-specific UX patterns (mobile deep links, QR code limitations), Execution phase should consider user context and workflow state when presenting instructions.

- [x] [Polaroid Photo Story Carousel Component](done/polaroid-photo-story-carousel.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: Desktop carousel with auto-scroll (30s cycle), pause on hover, drag-to-scroll, navigation buttons (Previous/Next). Mobile carousel using shadcn Carousel with swipe gestures. Polaroid styling with random rotation (-3° to +3°), global shadow system, aspect ratio preservation.
  - ✅ Responsive design: CSS-only rendering (no hydration issues), desktop shows 4-6 images, mobile shows single image with swipe
  - ✅ Performance optimizations: requestAnimationFrame for smooth 60fps animation, first 4 images prioritized with `priority` prop, lazy loading for remaining images, `prefers-reduced-motion` support
  - ✅ Image migration: Moved 30 polaroid images from `app/images/` to `public/images/` (Next.js App Router requirement)
  - ✅ Hydration safety: Random rotation generation moved to `useState` initializer (client-side only) to prevent server/client mismatch
  - ⚠️ Implementation iterations required: 9 user corrections needed for: carousel positioning, scrollbar visibility, image padding/borders, fixed-width containers, image blur, rotation clipping, shadow placement, auto-scroll start timing, hydration errors
  - ⚠️ Agent workflow gaps identified: Planning didn't specify exact carousel position, Review suggested patterns that needed revision, Discovery didn't validate implementation patterns, Execution required multiple iterations for each issue
  - 📁 Files: `components/gift-list/photo-story-carousel.tsx` (NEW wrapper), `components/gift-list/photo-story-carousel-desktop.tsx` (NEW 169 lines), `components/gift-list/photo-story-carousel-mobile.tsx` (NEW 53 lines), `components/gift-list/hero-section.tsx` (MODIFIED - carousel integration), `app/globals.css` (MODIFIED - scrollbar-hide utility), `public/images/` (30 JPG files moved from app/images/)
  - 🔧 Dependencies: `embla-carousel-react` v8.6.0 (shadcn carousel component), `components/ui/carousel.tsx` installed
  - 💡 Notes: Switched from Next.js Image to native `<img>` tags for simpler sizing and blur prevention, used pragmatic "more padding" approach for rotation clipping instead of complex overflow manipulation, full-width desktop breakout using calc technique
  - 🧪 Testing: Build successful with no TypeScript errors, hydration errors resolved, auto-scroll starts on page load, all interactive features working (hover pause, drag, buttons, swipe)
  - 📊 Self-improvement analysis: 9 user corrections identified, 4 design agents updated with specific patterns to prevent similar issues in future tasks

- [x] [Implement Privacy Controls, Recent Gifts Display, and Wall of Love](done/implement-privacy-recent-gifts-and-wall-of-love.md) ✅ Completed 2025-11-06

- [x] [Implement Privacy Controls, Recent Gifts Display, and Wall of Love](done/implement-privacy-recent-gifts-and-wall-of-love.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: Privacy opt-out checkboxes on all forms (IBAN, PayPal, thank-you message), opt-out model (default public), admin privacy badges, Recent Gifts rotating banner (5s intervals), Wall of Love masonry grid with colorful cards, relative timestamps with date-fns
  - ✅ Database migration: Added `is_public BOOLEAN DEFAULT true` to contributions and messages tables with performance indexes (⚠️ USER ACTION REQUIRED: `npx supabase db push --include-all`)
  - ✅ Privacy architecture: All Server Actions accept `isPublic` parameter, admin sees ALL entries with privacy badges (👁️ Public / 🔒 Private), public pages filter `.eq('is_public', true)`
  - ✅ Recent Gifts Display: Created `lib/recent-contributions.ts` query functions, `RecentGiftsBanner` component with auto-rotation and pagination dots, respects `prefers-reduced-motion`, integrated at top of landing page
  - ✅ Wall of Love: Route at `/wall-of-love` with Server Component (1hr revalidation), masonry grid layout (1-4 columns responsive), progressive disclosure (12 initial, show all button), 5 colorful card backgrounds, empty state with encouragement message
  - ✅ Navigation integration: Added Wall of Love link to landing page ("See messages from friends & family"), added button to thank-you page action section
  - ⚠️ Initial implementation gap: Privacy controls backend was implemented first (database, types, Server Actions) but UI checkboxes were initially forgotten - caught by user testing and immediately added
  - 📁 Files: `supabase/migrations/20241107000001_add_privacy_flags.sql` (NEW), `types/supabase.ts` (MODIFIED), `app/payment/iban/payment-form.tsx` + `actions.ts` (MODIFIED with checkbox), `app/payment/paypal/paypal-payment-form.tsx` + `actions.ts` (MODIFIED with checkbox), `app/thank-you/thank-you-content.tsx` + `actions.ts` (MODIFIED with checkbox), `lib/recent-contributions.ts` (NEW), `components/gift-list/recent-gifts-banner.tsx` (NEW), `components/admin/privacy-badge.tsx` (NEW), `components/admin/contributions-list.tsx` + `messages-list.tsx` (MODIFIED with badges), `app/wall-of-love/page.tsx` (NEW), `components/wall-of-love/wall-of-love.tsx` + `message-card.tsx` (NEW), `app/page.tsx` (MODIFIED)
  - 🔧 Dependencies: `date-fns` for relative timestamps (~5-10KB gzipped, tree-shakeable), Checkbox component from shadcn/ui (already installed)
  - 💡 Notes: Opt-out privacy model chosen for maximum engagement, admin full visibility for moderation, masonry grid uses CSS columns for performance, rotation animation with motion-safe prefix for accessibility
  - 🧪 Testing: 27 comprehensive test scenarios documented in task file covering privacy filtering, banner rotation, masonry layout, navigation, accessibility, performance, and edge cases



- [x] [Additional Components and Polish - Phase 4](done/additional-components-and-polish-phase-4.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: Loading states with skeleton screens, root error boundary, 404 page, all production-ready polish features
  - ✅ Skeleton component installed via `npx shadcn@latest add skeleton`
  - ✅ Custom gift card skeleton with CSS Masonry Columns layout (NOT grid), dynamic aspect ratios (4:3 fallback), responsive gaps (gap-4 md:gap-6)
  - ✅ Conditional grid logic: 3 items OR 6+ items use 3 columns, 4-5 items use 2 centered columns (lg:max-w-4xl lg:mx-auto) - prevents awkward spacing
  - ✅ Root loading state (`app/loading.tsx`) automatically shown by Next.js during navigation, matches exact page layout
  - ✅ Root error boundary (`app/error.tsx`) with user-friendly messages, Try Again/Go Home buttons, development-only error details
  - ✅ 404 page (`app/not-found.tsx`) with large "404" number, friendly messaging, Return to Gift List button, quick navigation links
  - ✅ Skeleton image color customized to #DCCACB per design theme (matches warm palette)
  - ✅ Zero layout shift: Skeleton dimensions match exact real content dimensions
  - 📁 Files: `components/ui/skeleton.tsx` (installed), `components/ui/skeleton-card.tsx` (new), `app/loading.tsx` (new), `app/error.tsx` (new), `app/not-found.tsx` (new)
  - 🔧 Dependencies: Skeleton component from shadcn/ui (~1KB, no new npm packages)
  - 💡 Notes: Next.js 15 file-based conventions (automatic loading/error/not-found handling), masonry skeleton prevents layout shift, share functionality already implemented in thank-you page (no additional work needed)
  - ⏭️ Deferred: Optional polish (Suspense boundaries, transitions, focus states audit) - can be added post-launch based on user feedback

- [x] [Payment Instructions and Thank You Pages Implementation](done/payment-and-thank-you-pages.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: Three-page payment flow (method selection, IBAN route, PayPal route), contribution recording with unique gift codes, thank you page with message form and share functionality
  - ✅ Payment restructure: Added `/payment/choose` selection page with two payment method cards (IBAN and PayPal), "How does this work?" dropdown from item modal
  - ✅ IBAN route (`/payment/iban`): Simplified payment form with IBAN/account name (PayPal references removed), copy-to-clipboard for all fields, contribution form with optional name/email/message
  - ✅ PayPal route (`/payment/paypal`): Big PayPal button linking to `https://www.paypal.com/paypalme/deepadventures`, same contribution form structure
  - ✅ Thank you page: Warm celebratory design with heart icon, contribution confirmation card, optional message form, share functionality (native API on mobile, clipboard fallback), return to list button
  - ✅ Database integration: Server Actions for recording contributions and messages, marks items unavailable for full contributions, revalidates home page cache
  - ✅ Item modal updated: Navigates to `/payment/choose` instead of direct payment page
  - 📁 Files: `/app/payment/choose/` (page.tsx, payment-method-selection.tsx), `/app/payment/iban/` (page.tsx, payment-form.tsx, actions.ts), `/app/payment/paypal/` (page.tsx, paypal-payment-form.tsx, actions.ts), `/app/thank-you/` (page.tsx, thank-you-content.tsx, actions.ts), `components/gift-list/item-modal.tsx` (updated navigation)
  - 🔧 Dependencies: None - all UI components already installed
  - 💡 Notes: Server Component/Client Component split pattern, copy-to-clipboard with 2s visual feedback, euro currency (€) formatting, mobile-responsive design, accessibility with aria-labels on icon buttons

- [x] [Masonry Grid Layout for Gift Cards](done/masonry-grid-layout-for-gift-cards.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: CSS columns masonry layout (1/2/3 columns responsive), dynamic aspect ratios preserve full images (no cropping), progressive enhancement with 4:3 fallback for existing items, scale-based hover prevents layout reflow
  - ✅ Database migration: Added nullable `image_width` and `image_height` columns to `items` table for aspect ratio calculations
  - ✅ Image dimension capture: New uploads automatically capture dimensions from original images before compression, stored in database for accurate aspect ratio display
  - ✅ Progressive enhancement: Existing items without dimensions gracefully fall back to 4:3 ratio, new items display in natural aspect ratios
  - ✅ All features preserved: Favorites (localStorage + cross-tab sync), category filters, item modal, progressive disclosure, Next.js Image optimization
  - 📁 Files: `supabase/migrations/20241107000000_add_image_dimensions.sql` (new), `lib/image-utils.ts` (new), `types/supabase.ts`, `app/protected/upload/actions.ts`, `components/gift-list/gift-card.tsx`, `components/gift-list/gift-grid.tsx`
  - 🔧 Dependencies: None - uses native Tailwind CSS v3.4.1 columns utilities and browser Image() API
  - 💡 Notes: CSS-only layout solution (optimal performance), hover changed from translate to scale (masonry-safe), object-contain instead of object-cover (preserves full images), manual database migration required before testing

- [x] [Admin Features - Dashboard with Add/Edit Items](done/admin-features-simplified-with-auth.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: Protected admin dashboard at `/protected/upload`, dedicated Add/Edit routes, full CRUD operations, image management (upload/replace/remove), contributions and messages display
  - ✅ Page reorganization: Main dashboard renamed, "Add Item" moved to `/protected/upload/add`, Edit functionality at `/protected/upload/edit/[id]`
  - ✅ Image scenarios: Three-way handling (keep existing, replace with new, remove entirely) with proper storage cleanup
  - ✅ Next.js 15 compatibility: Async params pattern implemented (`params: Promise<{ id: string }>`)
  - 📁 Files: `/app/protected/upload/page.tsx` (dashboard), `/app/protected/upload/add/page.tsx` (add route), `/app/protected/upload/edit/[id]/page.tsx` (edit route), `/components/admin/edit-item-form.tsx` (new), `/components/admin/add-item-form.tsx` (updated), `/components/admin/items-table.tsx` (updated with Edit button), `/app/protected/upload/actions.ts` (added getItemById, updateItem)
  - 🔧 Dependencies: shadcn/ui Dialog, Textarea, Table, Select components
  - 💡 Notes: Form pre-population with defaultValue, image management uses hidden flags (removeImage), redirect after successful add/edit, Edit button with Pencil icon, mobile-responsive tables with horizontal scroll

- [x] [Item Detail Modal Implementation](done/item-detail-modal-implementation.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: Responsive modal (Sheet for mobile, Dialog for desktop), image display with blur placeholder, payment option buttons with navigation, expandable "How does this work?" section, all close methods (X, ESC, backdrop)
  - ✅ Conditional rendering based on media query to prevent both mobile/desktop components showing simultaneously
  - ✅ Proper state management with animation delays (300ms) for smooth transitions
  - ⚠️ Next step needed: Payment page (`/app/payment/page.tsx`) - currently redirects to auth page (public route needs to be created)
  - 📁 Files: `components/gift-list/item-modal.tsx` (new), `components/gift-list/gift-grid.tsx` (updated with modal integration)
  - 🔧 Dependencies: shadcn/ui Dialog and Sheet components installed via `npx shadcn@latest add`
  - 💡 Notes: Portal-based components require conditional rendering, not CSS hiding. Used `window.matchMedia` for responsive behavior detection.

- [x] [Landing Page with Gift Grid](done/landing-page-with-gift-grid.md) ✅ Completed 2025-11-06
  **Implementation Notes:**
  - ✅ Full functionality: Hero section, category filters (6 categories including favorites), responsive gift grid, favorites with cross-tab sync, progressive disclosure
  - ✅ Server-side data fetching with 24-hour cache, Next.js Image optimization (AVIF/WebP)
  - ✅ Currency: All prices display in euros (€)
  - 📁 Files: `components/gift-list/` (hero-section, category-filter, gift-card, gift-grid), `app/page.tsx`, `next.config.ts`
  - 🔧 Dependencies: lucide-react (already installed), shadcn/ui Card and Badge components
  - 💡 Notes: Mixed Server/Client component architecture, localStorage favorites, cross-tab synchronization via storage events

<!-- Tasks move here via @5-design-complete.md -->

## Archived Features

<!-- Completed features archived here -->

%% kanban:settings
```
{"kanban-plugin":"board"}
```
%%