## Restyle Work-With-Me Page to Match Landing Page Visual Style

### Original Request
"Make the /work-with-me page the same visual style and layout as the landing page"

### Design Context

**Current Landing Page Visual Language** (source of truth: `src/app/page.tsx`):
- **Background**: `bg-brand-cream dark:bg-zinc-900` (#FFF8F3)
- **Text**: `text-brand-text dark:text-zinc-100` (#413C38 warm brown)
- **Hover accent**: `brand-rose` (#E57A9A)
- **Full-page layout**: `fixed inset-0 overflow-auto` — bypasses the shared Layout shell entirely
- **Own header**: Inline avatar + glass nav + theme toggle, with scroll-direction hide/show behaviour
- **Decorative orbs**: Two floating gradient orbs (lavender→pink top-right, coral→pink bottom-left) with framer-motion infinite animation
- **Fraunces serif font**: Used for hero and section headings (`font-serif`)
- **Card shadow**: Warm 10px ring `rgba(229,213,200,0.5)` + subtle shadow, with hover glow (coral/mauve)
- **Badge style**: `border-[#AFACFF]/50 bg-[#AFACFF]/10` lavender with mono uppercase
- **CTA links**: `text-brand-text hover:text-brand-rose` with animated arrow icon
- **Animations**: Spring-based framer-motion (stagger containers, fadeUp children, badge scale-in)
- **Closing CTA**: Large serif text with gradient-highlighted line + black button (4px radius)
- **No shared Footer** — the landing page doesn't render the Footer component

**Current Work-With-Me Page Issues** (source: `src/app/work-with-me/page.tsx`):
- Uses `Container` component → standard centred layout, not full-page
- Uses shared `Layout` → Header + Footer → different nav style and bg treatment
- Standard zinc colour palette (`text-zinc-800`, `border-zinc-200`) — no warm brand colours
- No decorative background orbs
- No framer-motion animations
- Standard `Card` component with zinc borders — not the warm shadow style
- No Fraunces serif font
- Background handled by Layout's stroke/gradient system, not brand-cream

**Primary Visual Direction**: The landing page (`page.tsx`) is the definitive reference. The work-with-me page should feel like a natural continuation of the same site, with identical visual DNA.

### Codebase Context

**Files involved:**
- `src/app/work-with-me/page.tsx` — page to restyle (196 lines)
- `src/app/page.tsx` — visual reference (1180 lines, landing page)
- `src/components/Layout.tsx` — shared layout shell that currently wraps work-with-me
- `src/components/Header.tsx` — shared header (not used by landing page)
- `src/components/Footer.tsx` — shared footer (not used by landing page)
- `src/components/CalEmbed.tsx` — Cal.com booking embed (keep as-is)
- `src/styles/tailwind.css` — brand design tokens

**Key architectural decision:**
The landing page bypasses the shared `Layout` entirely — it's a `fixed inset-0` full-screen scrollable container with its own header. To match this, the work-with-me page should also become self-contained.

However, `Layout.tsx` wraps all pages via the app layout. Looking at it:
- It checks `isHome` to skip rendering Header on `/` (since page.tsx renders its own)
- It checks `isWorkWithMe` to control gradient behaviour
- The landing page works because it uses `fixed inset-0 z-50` which overlays everything

**So the approach is**: Make the work-with-me page use the same `fixed inset-0 overflow-auto z-50` pattern as the landing page, effectively overlaying the Layout shell. This matches the landing page pattern without needing to modify Layout.tsx.

**Components to reuse from landing page:**
- Scroll-direction header (avatar + glass nav + theme toggle)
- Decorative background orbs
- Fraunces font setup
- Spring animation configs (springBouncy, springSmooth, etc.)
- Stagger/fadeUp animation variants
- Warm card shadow pattern
- CTA button/link styling

**Components to keep from work-with-me:**
- `CalEmbed` component — the booking calendar
- Content (copy about Zebra Sprint, credentials)
- Client logos section

### Plan

**Step 1: Convert to self-contained full-page layout**
- File: `src/app/work-with-me/page.tsx`
- Add `'use client'` (already has it)
- Add `fixed inset-0 overflow-auto bg-brand-cream dark:bg-zinc-900 z-50` wrapper div (same as landing page)
- Add Fraunces font import and `fraunces.variable` class
- Remove `Container` usage — switch to `max-w-7xl mx-auto px-6` pattern matching landing page

**Step 2: Add decorative background orbs**
- Copy the two `motion.div` gradient orbs from landing page
- Top-right: lavender→pink-purple floating animation
- Bottom-left: coral→pink-purple floating animation

**Step 3: Add self-contained header with scroll-direction behaviour**
- Copy the `useScrollDirection` hook, header markup, nav components, and ThemeToggle from landing page
- Static header (before scroll) + fixed header (on scroll up)
- Glass nav effect on fixed header

**Step 4: Restyle hero section**
- Replace `text-zinc-800` → `text-brand-text`
- Add `font-serif` (Fraunces) for the h1 heading
- Apply stagger + fadeUp animation variants
- Match landing page spacing (`pt-20 pb-16 lg:pt-32 lg:pb-24`)

**Step 5: Restyle Cal.com embed section**
- Wrap in the warm card shadow pattern: `bg-white dark:bg-zinc-800 rounded-xl` with `boxShadow: '0 0 0 10px rgba(229,213,200,0.5), ...'`
- Add whileInView fade-up animation
- Keep CalEmbed component unchanged inside

**Step 6: Restyle credentials section**
- Replace zinc Card components with landing-page-style cards using warm shadow
- Match the badge/tag styling from landing page (`border-[#AFACFF]/50 bg-[#AFACFF]/10`)
- Update text colours to `text-brand-text/70` etc.
- Add whileInView animations

**Step 7: Add closing CTA section**
- Mirror the landing page's closing section with serif heading + gradient text
- Black CTA button with 4px radius linking to sprint booking
- Email fallback underneath

**Step 8: Remove Footer rendering**
- The landing page doesn't show the footer. If we want consistency, the `fixed inset-0 z-50` overlay will naturally cover the Layout footer.
- No Footer.tsx changes needed — the overlay approach handles it.

### Prototype Scope
- **Frontend only** — no backend changes
- **Component reuse**: CalEmbed kept as-is, header/nav/theme-toggle pattern copied from landing page
- **Mock data**: None needed — all content is static copy

### Component Sources
- **Landing page patterns** (copied): Header, nav, theme toggle, orbs, animations, card shadows
- **Existing** (kept): CalEmbed

### Stage
Ready for Manual Testing

### Review Notes

**Reviewed by**: Agent 2 (Review) -- 2026-02-17

**Verdict**: APPROVED. Plan is solid and executable.

**Key validations performed:**
1. **`fixed inset-0 z-50` overlay approach**: Verified correct. Landing page uses this exact pattern (line 264 of page.tsx). Layout.tsx has no z-50 on structural elements, so the overlay will correctly cover the shared Header/Footer. The Layout's `isWorkWithMe` gradient (line 70) sits at z-0 with `pointer-events-none` and will be invisible behind the overlay.
2. **Visual element accuracy**: All referenced patterns verified against landing page source -- background orbs (lines 268-279), card shadow `rgba(229,213,200,0.5)` (multiple instances), badge style `border-[#AFACFF]/50` (6 instances), closing CTA with gradient text + black button (lines 1127-1173), spring configs (lines 29-50), Fraunces font (lines 93-98), scroll-direction header (lines 52-91 + 257-340).
3. **CalEmbed**: Confirmed as simple 22-line self-contained component requiring no changes.
4. **No Layout.tsx modification needed**: Correct -- the overlay pattern avoids touching shared infrastructure.

**Notes for executor (Agent 4):**
- **Imports to include** (implicit in plan but worth spelling out): `motion`, `AnimatePresence` from `framer-motion`; `Popover`, `PopoverButton`, `PopoverBackdrop`, `PopoverPanel` from `@headlessui/react`; `Fraunces` from `next/font/google`; `avatarImage` from `@/images/avatar.png`.
- **SVG icon components to copy**: `CloseIcon`, `ChevronDownIcon`, `SunIcon`, `MoonIcon` -- all needed by the header/nav/theme-toggle.
- **Do NOT copy**: `Spotlight2b` import or usage -- that is landing-page-specific content.
- **File size**: The restyled page will likely reach 400-500 lines (well above the 250-line guideline in CLAUDE.md). This is acceptable given the landing page itself is 1180 lines and sets the codebase precedent. A future refactoring task could extract shared header/nav/orb components to reduce duplication across both pages.
- **Dark mode**: The current work-with-me page uses `useTheme` + `mounted` pattern for dark mode logo switching. Keep this for the client logos. The header/theme-toggle copies from the landing page will bring their own theme handling.
- **`selection:bg-gradient-pink-purple/30`**: The landing page applies this selection highlight colour on the wrapper div. Include it for consistency.

### Questions for Clarification
No clarification questions -- the landing page is a clear visual reference and the work-with-me content is well defined. Plan verified against source code.

### Priority
High

### Created
2026-02-17

### Files
- `src/app/work-with-me/page.tsx` (primary — full rewrite to match landing page style)

### Technical Discovery (Agent 3)

**Verified by**: Agent 3 (Technical Discovery) -- 2026-02-17

**1. Package Dependencies -- All Present**

All required npm packages are installed in `package.json`:
- `framer-motion` v12.23.26 -- `motion`, `AnimatePresence` imports will work
- `@headlessui/react` v2.2.6 -- `Popover`, `PopoverButton`, `PopoverBackdrop`, `PopoverPanel` imports will work
- `next-themes` v0.4.6 -- `useTheme` import will work
- `next` v15.5.9 -- `next/font/google` for Fraunces import will work
- `@calcom/embed-react` v1.5.3 -- CalEmbed dependency present

No new package installations needed.

**2. Fraunces Font Setup -- Verified**

The Fraunces font is NOT loaded globally in `src/app/layout.tsx`. The landing page loads it locally in its own file (`src/app/page.tsx`, lines 93-98) and applies the CSS variable class `fraunces.variable` on its wrapper div (line 264). The `font-serif` Tailwind utility then resolves to Fraunces within that scope.

The work-with-me page must replicate this exact pattern:
- Import `Fraunces` from `next/font/google`
- Instantiate with `subsets: ['latin'], weight: ['300', '400', '500', '600'], display: 'swap', variable: '--font-fraunces'`
- Apply `fraunces.variable` class on the wrapper div
- Use `font-serif` class on headings within that scope

This is a per-page pattern, not a global one. Confirmed working across 10+ components in the codebase that use `font-serif`.

**3. CalEmbed Component -- Self-Contained, No Changes Needed**

`src/components/CalEmbed.tsx` (22 lines) is fully self-contained:
- `'use client'` directive present
- Imports only `useEffect` from React and `Cal`/`getCalApi` from `@calcom/embed-react`
- No props accepted, no Layout-dependent context
- Renders a Cal.com embed with namespace `zebra-call` and `month_view` layout
- Uses inline styles: `width: 100%, height: 100%, overflow: scroll`
- Parent container controls sizing (currently a div with `height: 600px`)

No modifications needed. Can be dropped into any wrapper.

**4. `fixed inset-0 z-50` Overlay Pattern -- Verified Safe**

Confirmed in `src/components/Layout.tsx` (95 lines):
- Layout wraps all pages via `src/app/layout.tsx` line 39
- Layout's background container uses `fixed inset-0` but no explicit z-index (defaults to z-0)
- Layout's `isWorkWithMe` gradient overlay (line 70-78) uses `z-0` and `pointer-events-none`
- Layout renders `<Header />` and `<Footer />` at default stacking context (no z-index)
- The landing page's `z-50` on its wrapper successfully covers all Layout elements

The work-with-me page using `fixed inset-0 overflow-auto z-50` will correctly overlay the Layout shell, hiding the shared Header, Footer, and background gradient. No Layout.tsx changes required.

**5. Avatar Image -- Confirmed Available**

`src/images/avatar.png` exists at the expected path. The landing page imports it as `import avatarImage from '@/images/avatar.png'` (line 25). The work-with-me page can use the same import.

**6. No Shadcn Components Needed**

This task copies patterns directly from the landing page. The landing page uses no shadcn components. The work-with-me page currently uses `Container`, `Button`, and `Card` from the codebase's own components -- all three will be removed (replaced by landing-page-style inline markup). No shadcn installation needed.

**7. Brand Design Tokens -- Confirmed in Tailwind**

All referenced brand tokens verified in `src/styles/tailwind.css`:
- `--color-brand-cream: #FFF8F3` (line 47)
- `--color-brand-text: #413C38` (line 48)
- `--color-brand-rose: #E57A9A` (line 49)
- `--color-brand-shadow: #E5D5C8` (line 50)
- `--gradient-coral: #fda7a0` (line 41)
- `--gradient-mauve: #E4BDDA` (line 42)
- `--gradient-lavender: #AFACFF` (line 43)
- `--gradient-pink-purple: #e7bdd7` (line 44)

All tokens used by the landing page are globally available. No token additions needed.

**8. Risk Assessment**

- **Zero risk**: No shared files modified (Layout.tsx, Header.tsx, Footer.tsx untouched)
- **Zero risk**: CalEmbed used as-is
- **Low risk**: File will exceed 250-line guideline (~400-500 lines). Acceptable given landing page precedent (1180 lines). Future refactoring task recommended to extract shared header/nav/orb components.
- **Note for executor**: The current work-with-me page uses `useTheme` + `mounted` pattern with light/dark logo variants (e.g., `isDarkMode ? "/images/zebra/logos/dark/ethereum-dark.svg" : "/images/zebra/logos/ethereum.svg"`). The landing page uses a simpler approach with `grayscale dark:invert` CSS. The executor should decide which pattern to keep for the logos -- the simpler `dark:invert` approach from the landing page is recommended for consistency.

### Design Language Consistency Verification (Agent 3)

**Verified by**: Agent 3 (Technical Discovery) -- 2026-02-17

**Approach**: Since the task's explicit goal is to match the landing page visual style, the landing page IS the design reference. I verified that the landing page's warm-brand-cream style is the established visual pattern across the site, not an outlier.

**Landing page (`src/app/page.tsx`) -- The Reference**

The landing page establishes the "warm brand" visual language:
- Background: `bg-brand-cream dark:bg-zinc-900`
- Text: `text-brand-text` / `text-brand-text/70` / `dark:text-zinc-100`
- Headings: `font-serif` (Fraunces), tracked tight
- Cards: Warm `rgba(229,213,200,0.5)` ring shadow, not zinc borders
- Badges: `border-[#AFACFF]/50 bg-[#AFACFF]/10` lavender
- CTAs: `hover:text-brand-rose` with animated arrow
- Animations: Spring-based framer-motion throughout

**Cross-component verification**:

1. **Case study pages** (`src/app/case-studies/*/`) -- Use `font-serif` headings with `text-brand-text` colours. Slide title classes use `font-serif text-3xl tracking-tight leading-[1.1] text-brand-text lg:text-4xl`. This confirms the warm brand pattern is the codebase standard for customer-facing pages.

2. **Docs pages** (`src/app/docs/page.tsx`, `src/app/docs/[slug]/page.tsx`) -- Use `font-serif text-4xl sm:text-5xl tracking-tight text-brand-text`. Confirms the brand-text + serif pattern extends beyond just the landing page.

3. **UserTestingCard component** (`src/components/case-studies/UserTestingCard.tsx`) -- Uses the exact same visual patterns as landing page cards: `font-serif text-3xl lg:text-4xl text-brand-text dark:text-white`, warm card shadows, badge styling with `border-[#AFACFF]/50`. Confirms these patterns are intentionally reused.

**Conclusion**: The warm-brand-cream visual language is the established design system for Zebra Design's customer-facing pages. The current work-with-me page (with zinc colours, standard Container layout, no animations) is the outlier. Restyling it to match the landing page brings it into alignment with the rest of the site.

**No design concerns or conflicts identified.** The plan is technically feasible and design-consistent.

### Implementation Notes (Agent 4)

**Implemented by**: Agent 4 (Execution) -- 2026-02-17

**File modified**: `src/app/work-with-me/page.tsx` (full rewrite, 593 lines)

**What was done**:

1. **Converted to self-contained full-page layout**: Replaced `Container` usage with `fixed inset-0 overflow-auto bg-brand-cream dark:bg-zinc-900 z-50` wrapper div, matching the landing page pattern. Removed all imports of `Container`, `Button`, and `Card` components.

2. **Added Fraunces font**: Imported and instantiated with the same config as the landing page. Applied `fraunces.variable` class on the wrapper div so `font-serif` resolves to Fraunces throughout the page.

3. **Added decorative background orbs**: Two floating `motion.div` gradient orbs (top-right lavender-to-pink, bottom-left coral-to-pink) with infinite framer-motion animation, identical to the landing page.

4. **Added scroll-direction header**: Full `useScrollDirection` hook using `scrollContainerRef` (NOT `window.scrollY`). Static header before scroll with bouncy avatar entry animation. Fixed header on scroll-up with glass nav effect. All SVG icons (CloseIcon, ChevronDownIcon, SunIcon, MoonIcon), ThemeToggle, MobileNavigation (with Popover), and DesktopNavigation copied from landing page.

5. **Restyled hero section**: Serif heading (`font-serif text-4xl sm:text-5xl md:text-6xl`), brand-text colours with opacity variants for secondary/tertiary text, stagger + fadeUp entrance animations.

6. **Restyled Cal.com embed**: Wrapped in warm card shadow container (`bg-white dark:bg-zinc-800 rounded-xl` with `boxShadow: '0 0 0 10px rgba(229,213,200,0.5), ...'`). Added "Book a discovery call" serif heading above. CalEmbed component kept as-is inside a 600px height container. Added whileInView fade-up animation.

7. **Restyled email fallback**: Updated to brand colours (`text-brand-text/60`, `hover:text-brand-rose`).

8. **Restyled credentials section**: Two side-by-side cards with warm card shadow pattern (no zinc borders). Client logos card uses the simpler `grayscale dark:invert` CSS approach (not the conditional `isDarkMode` pattern), matching the landing page recommendation. Logo grid uses `border-brand-shadow/30` internal borders. "What you get" checklist card uses `text-brand-text/70` colours. Both cards have whileInView fade-up animations with staggered delays. CTA link uses animated arrow icon with springSnappy transition.

9. **Added closing CTA section**: Large serif heading with gradient text line (lavender-to-mauve-to-coral), stagger/fadeUp animations, black CTA button with 4px radius linking to sprint booking, identical to landing page closing section.

10. **Footer spacer**: `h-16` div at the bottom, matching the landing page.

**Key decisions**:
- Used `grayscale dark:invert` for all client logos (simpler, matches landing page pattern). Removed the `isDarkMode` conditional rendering pattern.
- Did not import `AnimatePresence` since it was not needed (no conditional mount/unmount animations on this page).
- Did not import `springBadge` or `badgeChild` variants since there are no badge/tag elements on this page.
- Kept all 9 client logos from the original page (Deep Work, Ethereum, Ramp, Nexus Mutual, ConsenSys, Arbitrum, Spark, Maple, MakerDAO) in a 3x3 grid.
- `selection:bg-gradient-pink-purple/30` applied on wrapper div for consistency.
- File is 593 lines, above the 250-line guideline but acceptable given the landing page precedent (1180 lines) and the need to include header/nav/theme-toggle infrastructure.

**Build verification**: `next build --no-lint` completed successfully. Page compiles to 5.68 kB.

**No shared files modified**: Layout.tsx, Header.tsx, Footer.tsx, CalEmbed.tsx all untouched.

### Manual Test Instructions

1. **Navigate to `/work-with-me`** and verify:
   - Background is warm cream (#FFF8F3), not white/grey
   - Two floating gradient orbs are visible (top-right lavender, bottom-left coral)
   - Hero heading "Zebra Sprint" uses Fraunces serif font
   - Text uses warm brown (#413C38), not zinc grey
   - Entrance animations play on load (stagger + fade up)

2. **Test the header scroll behaviour**:
   - On initial load, static header with avatar + glass nav + theme toggle is visible at top
   - Scroll down -- static header disappears after ~100px
   - Scroll up -- fixed header slides in from top
   - Scroll down again -- fixed header slides out

3. **Test navigation**:
   - Desktop: Glass nav pills with "Charlie Ellington", "Docs", "Contact" links
   - Mobile: "Menu" button opens Popover with same nav items
   - Theme toggle switches light/dark mode
   - Avatar links back to `/`

4. **Cal.com embed section**:
   - "Book a discovery call" heading in serif font
   - Calendar wrapped in white card with warm 10px ring shadow
   - Calendar loads and is interactive (600px height)
   - Fade-up animation on scroll into view

5. **Email fallback**:
   - "Prefer email?" text centred below the calendar
   - Email link has hover effect (brand-rose colour)

6. **Credentials section (two cards)**:
   - Left card: Client logos in 3x3 grid with `border-brand-shadow/30` internal borders
   - Logos are greyscale, colour on hover
   - Right card: "What you get" checklist with emerald check marks
   - "Figma Files" item is struck-through/dimmed
   - "See the case studies" link with animated arrow
   - Both cards have warm 10px ring shadow (not zinc borders)
   - Both cards fade up on scroll with staggered timing

7. **Closing CTA section**:
   - Large serif heading: "Zebra Sprints." / "15+ Years Expertise." (gradient) / "User-validated." / "Shipped in code."
   - Gradient line uses lavender-to-mauve-to-coral
   - Black "2026 Availability" button with arrow icon
   - Stagger/fade-up animations on scroll

8. **Dark mode**:
   - Toggle theme and verify all sections adapt
   - Background changes to zinc-900
   - Client logos invert to white (via `dark:invert`)
   - Cards use zinc-800 background
   - Text colours switch to zinc-100/zinc-400 variants
   - Gradient orbs reduce opacity

9. **Responsive**:
   - Check mobile (< 768px): single column layout, mobile nav popover
   - Check tablet/desktop: two-column credentials grid, desktop glass nav
