---

kanban-plugin: board

---

## 🎁 Backlog: Features

- [ ] Screen Recording Integration - [Details](../../../zebra-planning/background/user-testing-app/future-features.md#screen-recording-integration)


## 🎒 Backlog (Must Have)



## 📝 Planning (Design-1)



## 🔍 Review (Design-2)



## 🔬 Discovery (Design-3)

- [ ] Screen 6: Dashboard - `/dashboard`


## 🚀 Ready to Execute (Design-4 Queue)




## 🛠️ Execution (Design-4)






## 🧪 Testing (Manual)

- [ ] Screen 5: Pricing & Signup - `/pricing`


## 👁️ Visual Verification (Design-5)




## ✅ Complete (Design-6)

- [x] [Screen 2 & 3: Create Test Flow](done/screen-2-and-3-create-test-flow.md) ✅ Completed 2025-11-26
  **Implementation Notes:**
  - ✅ Full functionality: Complete "Preview as Tester" flow allowing test creators to experience full tester journey
  - ✅ Full functionality: All POC screens (welcome, mic-check, instructions, test, complete) support preview mode via `?preview=true` and `sessionId=preview`
  - ✅ Full functionality: Preview mode skips DB operations, Daily.co room creation, and API calls (simulates success)
  - ✅ Full functionality: Amber preview banners with "Exit Preview" link on all screens (normal document flow to avoid overlap)
  - ✅ Full functionality: Inline progress indicators in preview mode components, test config loaded from sessionStorage/localStorage
  - ✅ Full functionality: "Preview as Tester" button on `/customize` saves config and navigates to `/zebra?preview=true`
  - 📁 Files Modified: `app/zebra/page.tsx` (Suspense boundary), `app/zebra/[sessionId]/mic-check/page.tsx`, `app/zebra/[sessionId]/instructions/page.tsx`, `app/zebra/[sessionId]/complete/page.tsx`
  - 📁 Files Modified: `components/test-flow/mic-permission.tsx`, `components/test-flow/task-instructions.tsx`, `components/test-flow/thank-you.tsx`, `components/test-flow/testing-interface.tsx`, `components/test-flow/welcome-screen.tsx`
  - 🔧 Dependencies: No new dependencies - used existing patterns
  - 💡 Notes: Storage pattern: `sessionStorage.getItem('test_config')` → `localStorage.getItem('_backup_test_config')` → `localStorage.getItem('test_config')`; Fixed banner overlap by using normal document flow instead of fixed positioning
  - 🧪 Testing: Manual testing verified full preview flow from /customize → /zebra → mic-check → instructions → test → complete

- [x] [Screen 4: Customize Test - `/customize`](done/screen-4-customize-test.md) ✅ Completed 2025-11-26
  **Implementation Notes:**
  - ✅ Full functionality: Complete test customization form with title, welcome message, dynamic tasks, and collapsible advanced options
  - ✅ Full functionality: Task management (add/remove/edit) with object structure `{ description: string; is_optional?: boolean }`
  - ✅ Full functionality: Redirect URL field in Advanced Options for post-test auto-redirect with 5-second countdown (UI ready, Screen 12 will implement countdown)
  - ✅ Full functionality: Real-time storage sync via `updateConfig` helper, validation (at least 1 task required)
  - ✅ Full functionality: Progress indicator (3 filled dots), tooltips on all fields, responsive design
  - 📁 Files Created: `app/customize/page.tsx` (320 lines)
  - 📁 Files Created: `components/ui/tooltip.tsx` (via shadcn CLI)
  - 🔧 Dependencies: `@radix-ui/react-tooltip` (installed via shadcn)
  - 💡 Notes: Redirect URL feature added mid-implementation per user request; MVP plan updated with Screen 12 countdown implementation notes
  - 🧪 Testing: TypeScript 0 errors, Next.js build successful, route verified as static page

- [x] [Screen 1: Landing Page - MVP Implementation](done/landing-page-mvp-implementation.md) ✅ Completed 2025-01-20
  **Implementation Notes:**
  - ✅ Full functionality: Complete 8-section landing page with jobs-to-be-done copy, auth-based conditional CTAs, real testimonial from Peter
  - ✅ Full functionality: Server component pattern with Supabase auth check, responsive grids (md:grid-cols-2, md:grid-cols-3), semantic color tokens
  - ✅ Full functionality: 5 placeholder boxes (1 demo video + 4 screenshots) with dashed borders, icons, and clear descriptions for future content
  - ⚠️ Known limitation: Navigation routes `/create` and `/dashboard` not implemented yet (planned for Screen 2 & 3 task)
  - 📁 Files Modified: `app/page.tsx` (complete replacement: 131 lines → 365 lines, client component → server component)
  - 🔧 Dependencies: All existing - no new installations (Button, createClient, Link, lucide-react icons all verified available)
  - 💡 Notes: Complete POC replacement with MVP marketing content; pricing €49/month vs competitors $99-699; bring-your-own-testers differentiator highlighted
  - 🧪 Testing: TypeScript 0 errors, Next.js build successful, ESLint issues resolved (HTML entities properly escaped)

- [x] Stage 1: Foundation Setup - Database, Environment, and Core Utilities ✅ Completed 2025-01-18
  **Implementation Notes:**
  - ✅ Full functionality: Complete database schema with 3 tables (tests, test_sessions, anonymous_tests), indexes, RLS policies, triggers
  - ✅ Full functionality: Environment configuration template (.env.example) with all required variables
  - ✅ Full functionality: Test management utilities (lib/tests.ts) with smart URL parsing and default generation
  - ✅ Full functionality: Anonymous test API route for pre-signup test creation
  - ✅ Full functionality: Signup-with-test API route for claiming anonymous tests
  - ✅ Full functionality: Backward compatibility for POC field name changes (daily_room_url→daily_room_name, audio_url→recording_url)
  - ⚠️ Known issue: Trigger function needs SECURITY DEFINER fix (migration created: 20250118000001_fix_trigger_permissions.sql)
  - 📁 Files Created: `supabase/migrations/20250118000000_mvp_complete_setup.sql`, `.env.example`, `lib/tests.ts`, `app/api/tests/anonymous/route.ts`, `app/api/auth/signup-with-test/route.ts`
  - 📁 Files Modified: `lib/session.ts` (updated interface + backward compatibility), `app/api/webhooks/daily-recording/route.ts`, 8 POC files for null handling and field renames
  - 🔧 Dependencies: `nanoid` (verified already installed), no new dependencies added
  - 💡 Notes: DROP CASCADE approach for clean database migration; TypeScript strict null checking enforced throughout; automated tests created (4/6 passing, trigger fix needed)
  - 🧪 Testing: Automated test suite created, database schema verified, API routes tested, build passes with 0 errors


- [x] Smart Speaking Reminders

- [x] Text-Only Feedback Mode (Priority 3) ✅ Completed 2025-01-05
  **Implementation Notes:**
  - ✅ Full functionality: Text-only alternative to audio recording with auto-save, localStorage backup, and retry logic
  - ✅ Full functionality: Accessibility link on mic permission screen, text mode variants for all screens, white background textarea for clear affordance
  - ✅ Full functionality: Database schema updated with `is_text_mode` boolean field to track mode for dashboard display logic
  - ✅ Full functionality: Button text changes to "Save & Continue" in text mode, no character minimums for better UX
  - 📁 Files: `lib/hooks/useAutoSave.ts` (new), `lib/utils.ts`, `components/test-flow/mic-permission.tsx`, `components/test-flow/task-instructions.tsx`, `components/test-flow/testing-interface.tsx`, `components/test-flow/thank-you.tsx`, `app/api/feedback/route.ts` (GET endpoint), `lib/session.ts`, `supabase/migrations/20251105172050_add_is_text_mode_column.sql`
  - 🔧 Dependencies: No new dependencies - used existing patterns
  - 💡 Notes: De-emphasized accessibility link to encourage audio use; removed arbitrary 50-char minimum after user feedback; database tracks mode with boolean for future dashboard logic (transcript for audio, feedback for text)
  - 🧪 Testing: Verified with test script - is_text_mode field working correctly with proper defaults and updates

- [x] Simplify Onboarding Flow - User Feedback Implementation ✅ Completed 2025-01-05
  **Implementation Notes:**
  - ✅ Full functionality: 5-screen onboarding flow with forced pacing (3-second delay + checkboxes)
  - ✅ Full functionality: Name-only welcome screen, simplified task instructions (3 checkboxes), email collection at end
  - ✅ Full functionality: All existing Daily.co audio recording and session management preserved
  - 📁 Files: `welcome-screen.tsx` (new), `task-instructions.tsx`, `thank-you.tsx`, `lib/session.ts`, `mic-permission.tsx`
  - 🔧 Dependencies: All shadcn/ui components already available - no installation required
  - 💡 Notes: Used empty string workaround for email NOT NULL constraint; TypeScript interfaces updated to support optional email
  - ⚠️ Known limitation: Email validation is basic (checks for '@' only)
  - 📋 Testing: Manual testing required at http://localhost:3001/zebra to verify complete flow

- [ ] **Launch Checklist**
	  - [ ] Pre-Launch: Test with 5 internal testers
	  - [ ] Pre-Launch: Verify all data flows to Supabase
	  - [ ] Pre-Launch: Check transcription quality
	  - [ ] Pre-Launch: Test edge cases
	  - [ ] Pre-Launch: Mobile experience validation
	  - [ ] Launch: Deploy to Vercel
	  - [ ] Launch: Configure Daily.co webhook
	  - [ ] Launch: Setup error monitoring
	  - [ ] Launch: Share /zebra link with testers
	  - [ ] Launch: Monitor completions
	  - [ ] Launch: Gather feedback and validate POC
- [ ] **Phase 4: Testing & Polish**
	  - [ ] End-to-End Testing Checklist
	  - [ ] Error Handling Implementation
	  - [ ] UX Polish (loading states, transitions)
- [ ] **Phase 3: Webhook Configuration & Testing** 🎯 CRITICAL
	  - [ ] Option A: Manual Testing (Quick Start)
	  - [ ] Option B: ngrok Testing (Full Integration)
	  - [ ] Production Webhook Setup on Vercel
- [ ] Screen 5: Thank You & Transcription
- [ ] Screen 5: Thank You & Transcription
	  - [x] Step 5.1: Transcription Service
	  - [x] Step 5.2: Session Completion Functions
	  - [x] Step 5.3: Build Thank You Screen
- [ ] **Phase 1: Foundation Setup**
- [ ] Build Screen 1: Landing & Pre-Test Survey
- [ ] Step 1.1: Install Dependencies
- [ ] Step 1.2: Update Environment Variables
- [ ] Step 1.3: Create Database Schema
- [ ] **Screen 2: Task Instructions**
- [ ] **Screen 3: Mic Permission & Test**
- [ ] Screen 2 & 3: Task Instructions and Mic Permission with Daily.co
- [ ] Screen 4: Main Testing Interface with Daily.co Recording and Iframe
- [ ] Screen 4: Main Testing Interface 
	  - [ ] Step 4.1: Recording Management Functions
	  - [ ] Step 4.2: Recording API Route & Webhook Endpoint
	  - [ ] Step 4.3: Build Testing Interface


## 📦 Archived

- [ ] **Phase 2: Screen Implementation (Continued)**
- [ ] Step 1.1: Initial Route Setup
- [ ] Step 1.2: Session Management Setup
- [ ] Step 1.3: Build Pre-Test Survey
- [ ] Step 2.1: Dynamic Routing Setup
- [ ] Step 2.2: Build Instructions Screen
- [ ] Step 2.3: Progress Indicator Component
- [ ] Step 3.1: Daily.co Integration Setup
- [ ] Step 3.2: Daily API Route
- [ ] Step 3.3: Build Mic Permission Screen




%% kanban:settings
```
{"kanban-plugin":"board","list-collapse":[null,null]}
```
%%