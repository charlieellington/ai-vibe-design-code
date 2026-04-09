# DC Landing Content — Reformat Tailark Templates to Design Canvas

## Original Request

Reformat the installed Tailark Pro templates (dark-landing-one + libre-landing-one) from their demo content into the 5-section DC landing page per `web-docs/web-plan.md`. The templates are already installed and rendering with dark theme. This task swaps all demo content for DC copy, strips the Web3 glow aesthetic, and builds the custom Proof section and Smart CTA.

**Source plan:** `web-docs/web-plan.md` — contains full copy, layout wireframes, section specs, design tokens.
**Approved plan:** `.claude/plans/vivid-munching-elephant.md` — contains the phase-by-phase implementation spec.

## Design Context

### Design Direction
- **Aesthetic:** Linear visual quality, Figma interaction model — "native app" feel, NOT "Web3 glow"
- **Mode:** Dark mode only throughout
- **Canvas bg:** `#111214`
- **Surface bg:** `#191A1D`
- **Accent:** `#5E6AD2` (CTA buttons ONLY)
- **Borders:** 1px `#2C2D30` (hard borders, no shadows)
- **Foreground:** `#EEEEEE`
- **Muted text:** `#A1A1AA` (WCAG AA compliant)
- **Typography:** Geist Sans (headlines/body) + Geist Mono (labels, code, kickers)
- **Reference:** `documentation/visual-design-references.md`

### Critical: Strip Web3 Glow
The current Tailark templates use radial glows, gradient text, constellation backgrounds, blurs, and diffused shadows. ALL of these must be stripped:
- Remove `bg-gradient-to-*`, `bg-clip-text text-transparent`, gradient text
- Remove `blur-*`, `backdrop-blur-*`
- Remove `shadow-lg`, `shadow-xl`, `shadow-black/*`
- Remove constellation background images + mask effects
- Replace with flat `bg-[#111214]` / `bg-[#191A1D]` + 1px `border-[#2C2D30]`

### Design References
- Visual inspiration: Linear.app, Figma.com, Cursor.com landing pages
- Key patterns: Dark canvas, hard 1px borders, flat surfaces, high-contrast type

## Codebase Context

### Current State
Templates are installed at `web/app/(marketing)/(home)/`. The page currently shows 10 sections of Tailark demo content. We need to reduce to 5 DC sections.

### Current Page Structure (to be replaced)
```
page.tsx currently renders:
1. Dark Landing Hero (payments SaaS demo content)
2. LogoCloud (Hulu, Spotify, etc.)
3. HowItWorks (payment steps)
4. AnalyticsFeatures (Libre bento)
5. PlatformFeatures (Libre bento)
6. ProductDirectionFeaturesSection (Libre)
7. MoreFeatures (6-card grid)
8. StatsSection (map + stats)
9. TestimonialsSection
10. CallToAction
```

### Target Page Structure (5 sections)
```
1. Hero — DC copy, CSS product mockup, tool strip
2. Proof — Before/After (custom build)
3. Features — 3 bento cards (adapted from Libre PlatformFeatures)
4. Bottom CTA — Simple CTA + reassurance text
5. Footer — DC brand + links
```

### Key Existing Files
- `web/app/(marketing)/(home)/page.tsx` — Main page (rewrite)
- `web/app/(marketing)/layout.tsx` — Marketing layout (minor edit)
- `web/app/layout.tsx` — Root layout (metadata update)
- `web/app/globals.css` — CSS variables (DC token override)
- `web/components/header.tsx` — Navigation (simplify)
- `web/components/footer.tsx` — Footer (rewrite)
- `web/components/call-to-action.tsx` — CTA (simplify)
- `web/components/logo-cloud.tsx` — Logo strip (repurpose as tool strip)
- `web/app/(marketing)/(home)/sections/platform-features.tsx` — Libre bento (adapt for Features)

### Files to Create
- `web/app/(marketing)/(home)/sections/proof.tsx` — Before/After section
- `web/components/smart-cta.tsx` — Waitlist CTA component (client component)

## Plan

### Phase A: Apply DC design tokens to globals.css
Override `.dark` selector CSS variables with DC hex values.

### Phase B: Reduce page.tsx to 5 sections
Rewrite page.tsx to import only: Hero (inline), Proof, Features, BottomCTA (via CallToAction), Footer (via layout).

### Phase C: Strip Web3 glow from hero
Remove constellation images, gradient text, mask effects. Replace with flat DC backgrounds.

### Phase D: Swap hero content
- Kicker: `DESIGN CANVAS FOR MAC` (Geist Mono, uppercase)
- H1: "Stop checking your app in 20 tabs. See every screen at once."
- Subhead: "See every route from your dev server on one canvas."
- CTA: SmartCta component
- Hero image: CSS product mockup (dark bg, white frame rectangles, Geist Mono route labels)
- Tool strip below: "Works with Cursor · Bolt · v0 · Claude Code · Lovable — or any localhost server"

### Phase E: Build Smart CTA component
`components/smart-cta.tsx` — client component:
- Default: Button "Join the Mac Beta" (accent #5E6AD2)
- On click: Inline expansion → email input + "Get Access" submit
- States: idle, expanded, loading (spinner), success ("You're in. We'll email you when the beta is ready."), error (inline red)
- Backend: `console.log` stub
- Used in Hero, Proof, Bottom CTA

### Phase F: Build Proof section
`app/(marketing)/(home)/sections/proof.tsx`:
- Background: `bg-[#191A1D]`
- H2: "AI coding tools build fast. Reviewing what they built is still a mess."
- Two side-by-side cards (Before/After):
  - Before ("Review in tabs"): CSS mockup of browser with cramped tabs
  - After ("Review on a canvas"): CSS mockup of DC canvas with spacious route frames
- Mid-page CTA: SmartCta component

### Phase G: Reformat Features section
Adapt `platform-features.tsx` → 3 cards only:
- Card 1 (primary, ~60% width): "See the whole product at once" + CSS canvas mockup
- Card 2: "Your coding tools keep it current" + CSS mockup
- Card 3: "Share a link. Get feedback pinned to the screen." + CSS mockup
- Left-aligned text, 1px borders, no shadows

### Phase H: Simplify Bottom CTA
Modify `call-to-action.tsx`:
- Remove CtaIllustration background
- Background: `bg-[#191A1D]`
- Center: SmartCta component
- Below: "Free during beta · Mac only · Apple Silicon & Intel" (muted)

### Phase I: Reformat Footer
Modify `footer.tsx`:
- Left: "Design Canvas" + "Made by Charlie Ellington" + "For apps already running in code."
- Right: Privacy · GitHub · X + "© 2026"
- Remove 5-column grid, status badge

### Phase J: Simplify Header
Modify `header.tsx`:
- Logo: "Design Canvas" text wordmark (Geist Sans)
- Remove mega-menus
- Keep CTA button + mobile hamburger

### Phase K: Update metadata
- Title: "Design Canvas — See every screen of your app side-by-side"
- Description: "Stop checking your app in 20 tabs. See every route from your dev server on one infinite canvas. Free for Mac."
- SoftwareApplication JSON-LD
- Remove `[--color-primary:var(--color-indigo-500)]` from marketing layout

### Phase M: Dead file cleanup
Delete all unused files after content swap:
- `app/(marketing)/(home)/sections/how-it-works.tsx`
- `app/(marketing)/(home)/sections/analytics-features.tsx`
- `app/(marketing)/(home)/sections/product-direction-features.tsx`
- `app/(marketing)/(home)/sections/more-features.tsx`
- `app/(marketing)/(home)/sections/stats-section.tsx`
- `app/(marketing)/(home)/sections/testimonials-section.tsx`
- `components/testimonials-section.tsx`
- `components/testimonials.tsx`
- `components/map.tsx`
- `components/code-block.tsx`
- `lib/const.ts`
- All unused `components/illustrations/*.tsx`
- All unused `components/ui/svgs/*.tsx`

## Stage

Visual Verification Complete - APPROVED

## Review Decisions (Agent 2 — 2026-04-09)

### Decision 1: Dead File Cleanup → Option A (delete in same PR)
Delete all dead files as part of this task. They are clearly unused after reducing from 10 to 5 sections.

### Decision 2: CSS Token Format → Option A (hex values)
Use hex values directly in `.dark` selector (`--background: #111214`). Simpler, matches spec, easier to verify.

### Decision 3: Source of Truth → Task file + web-plan.md
Work from this task file + `web-docs/web-plan.md` as combined source of truth.

## Visual Consistency Checklist
- [ ] Hard 1px `border-[#2C2D30]` on all elevated surfaces (no shadows)
- [ ] Accent `#5E6AD2` appears ONLY on CTA buttons
- [ ] All-caps Geist Mono kickers above section headlines
- [ ] Left-aligned text in bento cards
- [ ] Tool strip logos are monochrome/grayscale text
- [ ] Section spacing `py-24` minimum
- [ ] No gradient glows, blurs, or soft shadows anywhere
- [ ] No Tailark demo content visible anywhere

## Typography Reference
- Kickers: `font-mono text-xs uppercase tracking-widest text-[#A1A1AA]`
- H1: `text-5xl lg:text-6xl font-medium tracking-tight text-[#EEEEEE]`
- H2: `text-3xl font-medium tracking-tight text-[#EEEEEE]`
- Body: `text-base text-[#A1A1AA] leading-relaxed`

## Priority

High — Hard deadline: AdWords live by April 18

## Created

2026-04-09

## Files

- `web/app/(marketing)/(home)/page.tsx`
- `web/app/(marketing)/(home)/sections/proof.tsx` (new)
- `web/app/(marketing)/layout.tsx`
- `web/app/layout.tsx`
- `web/app/globals.css`
- `web/components/smart-cta.tsx` (new)
- `web/components/call-to-action.tsx`
- `web/components/footer.tsx`
- `web/components/header.tsx`
- `web/components/logo-cloud.tsx`
- `web/app/(marketing)/(home)/sections/platform-features.tsx`

---

## Technical Discovery (Agent 3 — 2026-04-09)

### MCP Connection Validation
- **shadcn-ui-server**: Connected — `list-components` returned full component list
- **shadcn registry**: Connected — `search_items_in_registries` found `input` component
- **AI Studio MCP**: Connected — `generate_content` returned design language analysis

### Component Identification Verification
- **Target Page**: `web/app/(marketing)/(home)/page.tsx`
- **Planned Components**: page.tsx (rewrite), proof.tsx (new), smart-cta.tsx (new), platform-features.tsx (adapt), call-to-action.tsx (simplify), footer.tsx (rewrite), header.tsx (simplify), logo-cloud.tsx (repurpose), globals.css (token override)
- **Verification Steps**:
  1. [x] Traced from page file to actual rendered component — page.tsx imports 10 sections, layout.tsx wraps with Header + Footer
  2. [x] Confirmed component paths match actual rendering — all imports verified in page.tsx
  3. [x] Checked for similar-named components — `testimonials-section.tsx` exists in BOTH `sections/` and `components/` (both dead)
  4. [x] Verified component receives required props from parent — page.tsx passes no props to sections (all self-contained)

### MCP Research Results

#### Component: Input (for Smart CTA email field)
- **Available**: Yes — `input` exists in @shadcn registry (registry:ui)
- **Currently Installed**: No — `web/components/ui/input.tsx` does NOT exist
- **Installation**: `npx shadcn@latest add input`
- **Import Path**: `@/components/ui/input`
- **Notes**: Required for Smart CTA email field. base-nova style will be installed.

#### Component: Card (already installed)
- **Available**: Yes — already at `web/components/ui/card.tsx`
- **API**: Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter
- **Default Classes**: `ring-foreground/6.5 bg-card text-card-foreground rounded-xl shadow ring-1`
- **Override Needed**: Remove `shadow` class; replace `ring-foreground/6.5` with `border border-[#2C2D30]` per DC tokens

#### Component: Button (already installed)
- **Available**: Yes — at `web/components/ui/button.tsx`
- **Pattern**: Uses `asChild` prop with `@radix-ui/react-slot` (NOT render prop)
- **Default variant**: Has `shadow-md shadow-black/15` and `border-[0.5px] border-white/10`
- **Override Needed**: Strip shadows from default variant; map `--primary` to `#5E6AD2`

#### Component: Accordion (already installed)
- **Available**: Yes — at `web/components/ui/accordion.tsx`
- **Base**: `@base-ui/react/accordion` (NOT Radix — no `type`/`collapsible` props)
- **Notes**: Used in header mobile menu. No changes needed for this task.

### Codebase Architecture Findings

#### Root Layout (`web/app/layout.tsx`)
- Already has `dark` class on `<html>` — dark mode always on
- Geist Sans + Geist Mono already loaded via `next/font/google` as CSS variables `--font-geist-sans` and `--font-geist-mono`
- globals.css @theme maps `--font-sans` to Geist and `--font-mono` to Geist Mono — **no Tailwind config change needed**

#### Marketing Layout (`web/app/(marketing)/layout.tsx`)
- Wraps children with `<Header />` + `<FooterSection />`
- Has `data-theme="dark"` on main — can be kept
- Metadata still shows "Tailark Quartz pages" — needs update per Phase K

#### globals.css Current State
- `.dark` selector uses oklch values (shadcn default)
- DC tokens require hex overrides: `--background: #111214`, `--card: #191A1D`, `--border: #2C2D30`, `--foreground: #EEEEEE`, `--muted-foreground: #A1A1AA`, `--primary: #5E6AD2`
- Decision 2 confirmed: use hex values directly

#### Header (`web/components/header.tsx`)
- 393 lines — complex mega-menu with NavigationMenu, Accordion, mobile drawer
- Uses `Stripe` SVG as logo placeholder
- Uses `useMedia` hook from `@/hooks/use-media`
- Plan: Simplify to text wordmark + CTA + hamburger. Major rewrite.
- `useMedia` hook can be kept for mobile detection

#### Footer (`web/components/footer.tsx`)
- Uses `Logo` component from `@/components/logo.tsx` (Tailark logo SVG)
- 5-column grid with "All Systems Normal" status badge
- Plan: Rewrite to 2-column (left brand, right links)
- `Logo` component will NOT be reused (replaced with text wordmark)

#### LogoCloud (`web/components/logo-cloud.tsx`)
- Imports 7 SVG logo components from `ui/svgs/`
- Plan: Repurpose as text-only tool strip ("Works with Cursor / Bolt / v0 / Claude Code / Lovable")
- All SVG logo imports will be removed

#### PlatformFeatures (`web/app/(marketing)/(home)/sections/platform-features.tsx`)
- 164 lines — 7 cards in complex grid with SVG decorative borders
- Imports illustration components + SVG logos (Linear, Openai, Cloudflare)
- Plan: Reduce to 3 cards with CSS mockups, strip decorative SVGs
- Cards use `rounded-2xl` — needs alignment to `rounded-xl` per Card component

#### CallToAction (`web/components/call-to-action.tsx`)
- Small (23 lines), uses `CtaIllustration` background
- Plan: Remove illustration, add SmartCta + reassurance text

### Dead File Inventory (Phase M)

All files confirmed to exist and will be unused after content swap:

**Sections to delete** (7 files):
- `web/app/(marketing)/(home)/sections/how-it-works.tsx`
- `web/app/(marketing)/(home)/sections/analytics-features.tsx`
- `web/app/(marketing)/(home)/sections/product-direction-features.tsx`
- `web/app/(marketing)/(home)/sections/more-features.tsx`
- `web/app/(marketing)/(home)/sections/stats-section.tsx`
- `web/app/(marketing)/(home)/sections/testimonials-section.tsx`

**Components to delete** (4 files):
- `web/components/testimonials-section.tsx`
- `web/components/testimonials.tsx`
- `web/components/map.tsx`
- `web/lib/const.ts`

**Illustrations to delete** (all 21 files in `web/components/illustrations/`):
- After rewrite, NO illustration components will be imported (replaced with CSS mockups)
- Full list: document-illustration, invoice-signing-illustration, payment-illustration, complete-payment-illustration, link-payment-illustration, kit-illustration, reply-illustration, schedule-illustration, invoice-illustration, cta-illustration, visualization-illustration, uptime-illustration, keys-illustration, currency-illustration, memory-usage-illustration, chip-illustration, hero-illustration, code-block-illustration, add-comment-illustration, message-illustration, map-illustration

**SVGs to delete** (all 16 files in `web/components/ui/svgs/`):
- After rewrite, NO SVG logo components will be imported (header uses text wordmark, tool strip uses text)
- Full list: beacon, bolt, cisco, hulu, openai, stripe, supabase, polars, vercel, spotify, paypal, leap-wallet, prime-video, tailwindcss, linear, cloudflare

**Other files to delete**:
- `web/components/logo.tsx` — Tailark logo SVG, replaced by text wordmark
- `web/components/code-block.tsx` — unused after content swap

**Files to KEEP** (referenced by surviving components):
- `web/hooks/use-media.ts` — used by header for mobile detection
- `web/components/ui/accordion.tsx` — used by header mobile menu
- `web/components/ui/navigation-menu.tsx` — may be kept if header retains desktop nav, or deleted if fully simplified
- `web/components/ui/card.tsx` — used by Features section
- `web/components/ui/button.tsx` — used throughout
- `web/components/ui/text-effect.tsx` — check if used (likely unused)

### Visual-Technical Reconciliation

| Visual Suggestion (Task Plan) | Codebase Has | shadcn Has | Decision | Why |
|-------------------------------|-------------|------------|----------|-----|
| Smart CTA with email input | Button (installed) | Input (not installed) | INSTALL Input | Email field needs Input component |
| Proof Before/After cards | Card (installed) | Card | REUSE Card | Existing Card with DC token overrides |
| Features bento (3 cards) | PlatformFeatures (7 cards) | Card | ADAPT existing | Reduce cards, strip illustrations, keep grid |
| CSS product mockups | No illustration system | N/A | CUSTOM BUILD | Pure CSS/Tailwind divs (no dependencies) |
| Text wordmark header | Stripe SVG logo | N/A | CUSTOM BUILD | Replace SVG with styled text span |
| Tool strip (text only) | LogoCloud (SVG logos) | N/A | ADAPT existing | Strip SVG imports, replace with text list |

**Components to Install**: `npx shadcn@latest add input`
**Existing Components to Reuse**: Card, Button, Accordion, useMedia hook
**Custom Work Needed**: CSS mockups (hero, proof, features), text wordmark, SmartCta client component

### Design Language Consistency Verification (Agent 3)

**Files I Actually Read:**
1. `web/components/ui/card.tsx` — Card: `rounded-xl shadow ring-1 ring-foreground/6.5 bg-card`
2. `web/components/ui/button.tsx` — Default: `rounded-md shadow-md border-[0.5px] border-white/10 shadow-black/15 bg-primary`; Outline: `shadow-sm shadow-black/15 ring-1 ring-foreground/10 bg-card`
3. `web/app/(marketing)/(home)/sections/platform-features.tsx` — Cards: `rounded-2xl shadow-lg shadow-black/5`
4. `web/components/header.tsx` — `backdrop-blur bg-background/75`
5. `web/components/footer.tsx` — Dashed line separator
6. `web/components/call-to-action.tsx` — Uses CtaIllustration background
7. `web/app/globals.css` — `.dark` uses oklch values, needs hex override

**AI Studio MCP Check Completed:** Yes
**Result:** CONFLICTS FOUND — All documented below with fixes

### shadcn Defaults Requiring Override

| Component | Default | DC Pattern | Override Needed |
|-----------|---------|------------|-----------------|
| Card | `shadow ring-1 ring-foreground/6.5` | No shadows, hard 1px border | Remove `shadow`, replace ring with `border border-[#2C2D30]` |
| Card | `rounded-xl` | Rounded corners OK | No change needed |
| Button default | `shadow-md shadow-black/15 border-[0.5px] border-white/10` | No shadows | Remove shadows and faint border |
| Button default | `bg-primary` | Accent `#5E6AD2` | Map `--primary: #5E6AD2` in globals.css |
| Button outline | `shadow-sm shadow-black/15 ring-1 ring-foreground/10` | No shadows, hard border | Remove shadows, keep ring or switch to border |
| PlatformFeatures cards | `rounded-2xl shadow-lg shadow-black/5` | Match Card rounded-xl, no shadows | Change to `rounded-xl`, remove shadows |
| Input (to install) | Default shadcn styling | DC tokens | Will inherit from globals.css `--input` and `--border` vars |

### Implementation Feasibility

**Technical Blockers**: None identified

**Required Adjustments (from AI Studio analysis)**:
1. **globals.css `.dark` override**: Replace oklch values with DC hex tokens. This is the single highest-leverage change — most semantic color usage (`bg-card`, `text-foreground`, `border-border`, `text-muted-foreground`, `bg-primary`) will automatically pick up DC values.
2. **Card component edit**: Remove `shadow` from base classes in `card.tsx`. Replace `ring-1 ring-foreground/6.5` with `border border-border` (after `--border` maps to `#2C2D30`).
3. **Button component edit**: Remove `shadow-md shadow-black/15` and `shadow-sm shadow-black/15` from variant classes. Remove `border-[0.5px] border-white/10` from default variant.
4. **Header solid bg**: After stripping `backdrop-blur`, change `bg-background/75` to `bg-background` (solid).
5. **Input install**: Run `npx shadcn@latest add input` before Smart CTA implementation.

**Resource Availability**: All dependencies installed (`@base-ui/react`, `@radix-ui/react-slot`, `class-variance-authority`, `lucide-react`, `motion`). No new npm packages needed beyond shadcn input.

### Required Installations

```bash
# Components
npx shadcn@latest add input

# No additional npm packages needed
```

### Learnings Applied
- **shadcn Component Class Override Failures** (learnings.md): Card `shadow` and Button `shadow-md` are baked into component files — must edit the source files, not just add override classes
- **CSS Opacity Cascading Issues** (learnings.md): Header `bg-background/75` + removing backdrop-blur = muddy. Use solid `bg-background` instead.
- **Background Implementation Fallback** (learnings.md): CSS mockups (hero, proof, features) should use pure CSS/Tailwind — no external image dependencies

### Discovery Summary
- **All Components Available**: Yes
- **Technical Blockers**: None
- **Install Required**: `npx shadcn@latest add input` (for Smart CTA email field)
- **Component Edits Required**: card.tsx (strip shadow, fix border), button.tsx (strip shadows)
- **Ready for Implementation**: Yes
- **Special Notes**:
  - Total dead files: ~44 files (7 sections + 4 components + 21 illustrations + 16 SVGs + logo.tsx + code-block.tsx)
  - Accordion is base-ui (NOT Radix) — no `type`/`collapsible` props
  - Button uses `asChild` pattern via `@radix-ui/react-slot` (NOT render prop)
  - `navigation-menu.tsx` may also become dead if header mega-menus are fully removed — Agent 4 should decide based on final header complexity

---

## Implementation Notes (Agent 4 — 2026-04-09)

### Phases Completed
- [x] Phase A: DC design tokens applied to globals.css `.dark` selector (hex values)
- [x] Phase B: page.tsx rewritten — 5 sections (Hero inline, Proof, Features, BottomCTA, Footer via layout)
- [x] Phase C: Web3 glow stripped — removed constellation images, gradient text, mask effects, blur, shadows
- [x] Phase D: Hero content swapped — DC kicker, H1, subhead, SmartCta, CSS product mockup, tool strip
- [x] Phase E: SmartCta built — client component with 5 states (idle, expanded, loading, success, error), console.log stub
- [x] Phase F: Proof section built — Before/After CSS mockups, mid-page CTA
- [x] Phase G: PlatformFeatures reformatted — 3 cards (primary wider), CSS mockups, no illustration imports
- [x] Phase H: CallToAction simplified — SmartCta + reassurance text, no illustration
- [x] Phase I: Footer rewritten — 2-column (brand left, links right), disambiguator line
- [x] Phase J: Header simplified — text wordmark + CTA + hamburger, removed mega-menus
- [x] Phase K: Metadata updated — title + description in both root and marketing layouts
- [x] Phase M: Dead files deleted — 7 sections, 4 components, 21 illustrations, 16 SVGs, logo.tsx, code-block.tsx, navigation-menu.tsx, text-effect.tsx, hooks/use-media.ts

### Component Changes
- `card.tsx`: Removed `shadow ring-1 ring-foreground/6.5`, replaced with `border border-border`
- `button.tsx`: Removed all `shadow-*` classes from default/destructive/outline variants
- `input.tsx`: Installed via `npx shadcn@latest add input`

### Build Result
- `next build` compiles successfully with zero errors
- Static pages generated: `/` and `/_not-found`

---

## Manual Testing Instructions

### Setup
1. Development server running: `cd web && pnpm dev`
2. Navigate to: `http://localhost:3000`

### Visual Verification
- [ ] Dark background #111214 throughout (no light mode leak)
- [ ] No gradient glows, blurs, or soft shadows anywhere
- [ ] Accent #5E6AD2 appears ONLY on CTA buttons
- [ ] No Tailark demo content visible (no "Payments infrastructure", "SaaS that scales", etc.)
- [ ] All-caps Geist Mono kickers above section headlines
- [ ] Hard 1px borders on all cards and elevated surfaces
- [ ] Geist Sans on headlines/body, Geist Mono on kickers/labels
- [ ] Header shows "Design Canvas" text wordmark + "Join the Mac Beta" button
- [ ] Footer shows brand info left, Privacy/GitHub/X links right

### Functional Testing
- [ ] SmartCta: Click "Join the Mac Beta" → email input expands inline
- [ ] SmartCta: Submit valid email → success message appears
- [ ] SmartCta: Submit invalid email → error message appears
- [ ] SmartCta: Check console.log for "[SmartCta] Waitlist signup:" on submit
- [ ] Header: Scroll down → header gets solid background
- [ ] Header: Mobile hamburger opens/closes menu
- [ ] Mid-page CTA in Proof section works (same SmartCta behaviour)
- [ ] Bottom CTA works (same SmartCta behaviour)
- [ ] No console errors

### Responsive Testing
- [ ] Mobile (375px): Sections stack vertically, CTA thumb-reachable
- [ ] Tablet (768px): 2-column layouts work
- [ ] Desktop (1440px): Full layout with hero split and feature bento grid
