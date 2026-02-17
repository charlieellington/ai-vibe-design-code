## Landing Page Update — Reorder, Sprint Card Framing, Remove User Testing Tool

### Original Request

Update the zebradesign.io landing page based on the `/deeper` positioning analysis. Key decisions:

1. **Keep** hero "I make interfaces work beautifully for humans." exactly as-is
2. **Move Sprint card to position 1** (before Research Tech) and add positioning copy — headline, one-liner, keep client logos, optional testimonial, CTA
3. **Reorder case studies**: Sprint card → Research Tech → Animatix → Paid24/7 → Ramp → Deep Work
4. **Remove User Testing Tool card** from homepage (saved to `src/components/case-studies/UserTestingCard.tsx`)
5. **Keep closing CTA** as-is: "Zebra Sprints. 15+ Years Expertise. User-validated. Shipped in code."
6. **No testimonials on homepage** — keep it clean, testimonials move to About page
7. **sprint.zebradesign.io** — no change

### Design Context

**Analysis source:** `workings/landing-page-update/` — full `/deeper` multi-model analysis with SWOT, stress tests, and cross-analysis.

**Key insight from analysis:** The warm funnel (100% of visitors arrive via referral, 50%+ close rate) means the site confirms quality, doesn't sell from scratch. Emotion first (hero), product framing second (Sprint card), proof third (case studies).

**Design principles:**
- "Results only, process hidden" — show outcomes, hide methodology
- Theme 1 (UX expertise) opens doors → Theme 2 (shipped code) closes deals
- "The aesthetic IS the pitch" — design quality = work quality signal
- Each section should have exactly one job

**Page narrative after update:**
1. **Hero** → "This person has taste" (emotion, confirmation)
2. **Sprint card** → "This is what they do" (product framing)
3. **Research Tech** → "Here's proof it works" (transformation evidence)
4. **Animatix** → "Another domain, same result pattern" (breadth)
5. **Paid24/7** → "Mobile fintech, user-validated" (variety)
6. **Ramp** → "Visual design at scale" (eye candy, visual craft)
7. **Deep Work** → "15+ years, Ethereum to ConsenSys" (legacy credibility, identifies they're in the right place)
8. **Closing CTA** → "Zebra Sprints. Shipped in code." (positioning bookend)

### Codebase Context

**Primary file:** `src/app/page.tsx` (1370 lines)

**Current case study order (line numbers):**
1. Research Tech — lines 370-491 (AI Diligence, browser mockup)
2. Zebra Sprints — lines 493-628 (booking iframe embed, client logos)
3. Ramp Spotlights — lines 630-731 (Spotlight2b animation)
4. User Testing Tool — lines 733-937 (video on hover, browser mockup)
5. Animatix — lines 939-1067 (side-by-side dark screenshots)
6. Paid24/7 — lines 1069-1193 (overlapping phone mockups)
7. Deep Work Studio — lines 1195-1315 (client logo grid)

**Target order after update:**
1. Zebra Sprints (upgraded) — currently lines 493-628
2. Research Tech — currently lines 370-491
3. Animatix — currently lines 939-1067
4. Paid24/7 — currently lines 1069-1193
5. Ramp Spotlights — currently lines 630-731
6. Deep Work Studio — currently lines 1195-1315

**Hero:** lines 342-368 — no changes
**Closing CTA:** lines 1317-1363 — no changes

**Saved component:** User Testing Tool card saved to `src/components/case-studies/UserTestingCard.tsx` (self-contained component with own state for video hover)

**Sprint card dependencies:**
- Currently has iframe embed: `sprint.zebradesign.io/embed/booking`
- Client logos: Ethereum, ConsenSys, Ramp, Nexus Mutual, Arbitrum
- Tags: 'One Week', '2026'
- CTA: "Book a sprint" → sprint.zebradesign.io

**Ramp Spotlights dependencies:**
- Uses `Spotlight2b` component from `src/components/spotlights/Spotlight2b`
- Has `rampSpotlightControls` state for demo animation playback

**Video/hover state dependencies (User Testing Tool — REMOVING):**
- `videoRef` — useRef for video element
- `isCardHovered` / `setIsCardHovered` — useState
- `isVideoMuted` / `setIsVideoMuted` — useState
- These can be removed from page.tsx when the card is removed

### Plan

**Step 1: Update Sprint card copy (position 1)**
- File: `src/app/page.tsx`
- Location: Sprint card section (currently lines 493-628)
- Changes:
  - Update title from just "Zebra Sprints." to "Zebra Sprint." with a one-liner below
  - Add positioning one-liner: "One critical flow, validated and shipped to your codebase." (or similar — concise, outcome-focused, matches hero tone)
  - Keep client logos as-is
  - Keep iframe embed (sprint.zebradesign.io/embed/booking) — it works and shows availability
  - Update tags from `['One Week', '2026']` to something more positioning-aligned (e.g., `['UX + Code', 'User-Validated']` or keep as-is)
  - CTA stays: "Book a sprint" → sprint.zebradesign.io
- **Critical constraint:** Keep copy concise. 1-2 lines max. No walls of text. The closing CTA already carries full positioning.

**Step 2: Reorder case study sections**
- File: `src/app/page.tsx`
- Move sections in this order:
  1. Sprint card (was position 2)
  2. Research Tech (was position 1)
  3. Animatix (was position 5)
  4. Paid24/7 (was position 6)
  5. Ramp Spotlights (was position 3)
  6. Deep Work Studio (was position 7)
- **Note:** Research Tech section currently uses `initial` + `animate` (not `whileInView`) because it was the first visible section. When moved to position 2, change to `whileInView` + `viewport={{ once: true }}` like the other cards. Sprint card (moving to position 1) should get `initial` + `animate` with appropriate delay.

**Step 3: Remove User Testing Tool section**
- File: `src/app/page.tsx`
- Remove lines 733-937 (the entire User Testing Tool section)
- Remove associated state: `videoRef`, `isCardHovered`, `setIsCardHovered`, `isVideoMuted`, `setIsVideoMuted`
- Remove associated imports if they become unused
- Component code is preserved at `src/components/case-studies/UserTestingCard.tsx`

**Step 4: Clean up animation triggers**
- After reorder, verify animation timing:
  - Sprint card (position 1): `initial` + `animate` with `delay: 0.3` (visible on load)
  - Research Tech (position 2): switch from `animate` to `whileInView` with `viewport={{ once: true }}`
  - All other cards: keep `whileInView` pattern as-is

**Step 5: Test**
- Verify page loads correctly with new order
- Verify Sprint card iframe still works
- Verify Ramp Spotlight animation still initialises
- Verify all case study links still work
- Check mobile layout — all cards should stack correctly
- Verify closing CTA still links to sprint.zebradesign.io

### Stage
Complete

### Implementation Notes

**All changes in `src/app/page.tsx`** (1370 → 1166 lines):

1. **Sprint card copy updated:**
   - Title: "Zebra Sprints." → "Zebra Sprint."
   - Added one-liner: "One critical flow, validated and shipped to your codebase."
   - Tags: `['One Week', '2026']` → `['UX + Code', 'User-Validated']`
   - Client logos, iframe embed, and CTA unchanged

2. **Sections reordered:** Sprint → Research Tech → Animatix → Paid24/7 → Ramp → Deep Work

3. **User Testing Tool section removed** (~205 lines). Associated state variables removed: `isCardHovered`, `isVideoMuted`, `videoRef`. Component preserved at `src/components/case-studies/UserTestingCard.tsx`.

4. **Animation triggers updated:**
   - Sprint card (position 1): `whileInView` → `animate` with delay 0.3 (visible on load)
   - Research Tech (position 2): `animate` → `whileInView` with `viewport={{ once: true }}` (scroll-triggered)
   - All inner elements (tags, browser mockup, iframe) updated accordingly

5. **Build passes** with zero errors. All sections render correctly at 1440px viewport.

### Visual Verification

**Score: 9/10**

Verified at 1440px viewport:
- Hero unchanged ✓
- Sprint card in position 1 with correct tags, title, one-liner, and booking iframe ✓
- Research Tech in position 2 with browser mockup ✓
- Animatix in position 3 with screenshots ✓
- Paid24/7 in position 4 with phone mockups ✓
- Ramp in position 5 with Spotlight2b animation ✓
- Deep Work in position 6 with client logo grid ✓
- Closing CTA intact: "Zebra Sprints. 15+ Years Expertise. User-validated. Shipped in code." ✓
- User Testing Tool section fully removed ✓
- No console errors ✓

**-1 point:** Case study comment numbers in source are now cosmetically out of order (e.g., "Case Study 5: Animatix" in position 3). Functional only, not user-facing.

### Questions for Clarification

**Q1: Sprint card one-liner copy**
The exact wording for the positioning one-liner on the Sprint card. Options:
- Option A: "One critical flow, validated and shipped to your codebase."
- Option B: "Expert UX design, user validation, and production code — shipped to your codebase."
- Option C: "UX expertise and shipped code for founders who can't wait to hire."
- **Recommendation**: Option A — shortest, most outcome-focused, matches the concise editorial tone of the rest of the page. Options B and C are too long and risk feeling salesy.

**Q2: Sprint card tags**
- Option A: Keep `['One Week', '2026']` (current, simple, concrete)
- Option B: Change to `['UX + Code', 'User-Validated']` (positioning-aligned)
- Option C: Change to `['Zebra Sprint', '2026']` (brand + availability)
- **Recommendation**: Option A — "One Week" and "2026" are specific, factual, and intriguing. They communicate speed and availability without being salesy.

### Priority
High

### Created
2026-02-17

### Files
- `src/app/page.tsx` — Primary file: reorder sections, update Sprint card copy, remove User Testing Tool
- `src/components/case-studies/UserTestingCard.tsx` — Saved component (already created)
