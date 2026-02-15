# Spooren Proposal — Refined Content Plan

What this file does: UX-refined content plan for `sprint.zebradesign.io/proposals/spooren`. Incorporates feedback from 4-perspective analysis (2 Claude + 2 Gemini). This is the implementation-ready spec.

*Refined: 15 February 2026*

---

## Key UX Refinements Applied

Based on 4-perspective analysis (Claude UX, Claude Simplicity, Gemini UX, Gemini Simplicity):

| Change | Why | Confidence |
|--------|-----|------------|
| **Show deliverables expanded, not in accordions** | All 4 perspectives agreed: hidden content = invisible to a 60-year-old | All agree |
| **Remove all technical jargon** (CMS, SEO, 301 redirects, Vercel, XML sitemap) | Luc knows diamonds, not algorithms | All agree |
| **Remove Credentials section entirely** | Crypto logos and startup sprints mean nothing to a jeweller. Trust is Bene. | All agree |
| **Merge Next Steps into homework section** | Reduces cards from 6→4, keeps actionable content together | Claude Simplicity + Gemini |
| **Remove "How Zebra Sprints work" link** | Links to startup process page irrelevant to Luc | All agree |
| **Remove empty grey avatar** | Looks broken, not like partnership | Claude UX + Simplicity |
| **Extend or remove validity date** | 2-day window on family project creates unnecessary risk | Claude UX |
| **Reduce price visual weight** | Already agreed — confirmation, not anchoring | Claude Simplicity |
| **Remove "book a call" link from sidebar** | Luc is family. He'll text Bene. | Claude UX |
| **Increase font sizes for older reader** | 14px body + 10px labels too small for 60-year-old | Claude UX + Gemini UX |
| **Replace green checkmarks with neutral style** | Checks suggest "done", these are promises | Claude Simplicity |

---

## Refined Structure: 4 Cards (down from 6)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  ┌──────────────┐  ┌──────────────────────────────────────────────────┐ │
│  │              │  │                                                  │ │
│  │  SIDEBAR     │  │  CARD 1: Personal Opening                       │ │
│  │              │  │  "Luc"                                          │ │
│  │  Website     │  │  Bedankt... this confirms what we discussed     │ │
│  │  Rebuild     │  │                                                  │ │
│  │              │  ├──────────────────────────────────────────────────┤ │
│  │  ZEBRA ×     │  │                                                  │ │
│  │  SPOOREN     │  │  CARD 2: What You Get                           │ │
│  │              │  │  7 items — ALL VISIBLE, no accordions            │ │
│  │  [charlie    │  │  — New spooren.be                               │ │
│  │   avatar     │  │  — Admin panel for Elke                         │ │
│  │   only]      │  │  — 4 service pages                              │ │
│  │              │  │  — Photography by Bene                          │ │
│  │  1 Week      │  │  — Google rankings protected                    │ │
│  │  Feb 19-25   │  │  — Google Business Profile                     │ │
│  │              │  │  — Training for Elke                            │ │
│  │  €2,500      │  │                                                  │ │
│  │              │  ├──────────────────────────────────────────────────┤ │
│  │              │  │                                                  │ │
│  │              │  │  CARD 3: The Week                                │ │
│  │              │  │  Day 1 (19 Feb): Project start                   │ │
│  │              │  │  Day 2 (20 Feb): Three design directions         │ │
│  │  [Bevestigen]│  │  Day 3 (23 Feb): Decision + photography         │ │
│  │              │  │  Day 4 (24 Feb): Full build                      │ │
│  │  Questions?  │  │  Day 5 (25 Feb): Buffer                         │ │
│  │  charlie@    │  │                                                  │ │
│  │              │  ├──────────────────────────────────────────────────┤ │
│  │              │  │                                                  │ │
│  │              │  │  CARD 4: Before We Start                         │ │
│  │              │  │  "We've put everything into a short doc —        │ │
│  │              │  │   just check it before February 19th"            │ │
│  │              │  │                                                  │ │
│  │              │  │  [Open the checklist →] (Google Doc link)        │ │
│  │              │  │  Pre-filled: brands, hours, holidays             │ │
│  │              │  │                                                  │ │
│  │              │  │  ─────────────────────────────────               │ │
│  │              │  │  Confirm you're happy — reply or tell Bene.     │ │
│  │              │  │  We start February 19th.                         │ │
│  │              │  │                                                  │ │
│  └──────────────┘  └──────────────────────────────────────────────────┘ │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Sidebar Content (Refined)

| Field | Value | Notes |
|-------|-------|-------|
| **sidebarLabel** | "Website Rebuild" | New optional field, replaces hardcoded "UX Partnership" |
| **Identity** | ZEBRA × SPOOREN | Existing pattern |
| **Avatar** | Charlie only | Remove empty grey placeholder circle |
| **Sprint type** | "WEBSITE REBUILD" | |
| **Sprint count** | 1 | Displays "1 Week" |
| **Timeline** | "Feb 19–25, 2026" | |
| **Price** | €2,500 | **Reduced visual weight** — text-2xl not text-4xl |
| **Currency** | EUR | |
| **CTA text** | "Bevestigen" | |
| **CTA href** | mailto:charlie@zebradesign.io?subject=Spooren%20website%20bevestigd&body=Charlie%2C%0A%0ALooks%20good.%20Let%27s%20go.%0A%0ALuc | |
| **Questions link** | charlie@zebradesign.io | **Remove "book a call" link** — Luc is family |
| **Contact email** | charlie@zebradesign.io | |
| **Valid until** | 2026-02-28 | **Extended** — no artificial urgency for family |
| **Valid until display** | "28 February 2026" | |

---

## Card 1: Personal Opening

**Section header:** "Luc"

**Content (two paragraphs):**

Paragraph 1:
"Bedankt voor het goede gesprek in januari. After the workshop with you and Elke, the picture is clear: spooren.be needs a modern website that does justice to 67 years of family craftsmanship, that Elke can update herself in under an hour a month, and that customers in Brasschaat find easily on Google."

Paragraph 2:
"This confirms what we discussed — what you get, when it happens, and what we need from you before we start on February 19th."

**No changes from original** — all 4 perspectives praised the Dutch/English opening as "the emotional anchor of the entire page."

---

## Card 2: What You Get (Deliverables — Expanded, No Accordions)

**Section header:** "What You Get"

**Format:** Each item visible as title (bold) + description (regular text). No accordion interaction. No green checkmarks (use neutral dash or bullet).

### 1. New spooren.be — designed and built in one week
A fast, modern website replacing the current one. Three visual directions to choose from on Day 3 — you and Elke pick the winner. Professional photography throughout. Works beautifully on phones, tablets, and desktops.

### 2. Admin panel — Elke updates it herself
A simple editor at spooren.be/studio with only three things to manage: opening hours (including holiday closures that disappear automatically), the brand list (toggle brands on/off, drag-and-drop logos), and announcements (set a date range, they expire on their own). No technical knowledge needed.

### 3. Four service pages optimised for Google
Dedicated pages for Horloges, Juwelen, Optiek, and Reparatie. Each with genuine Dutch copy that mentions Brasschaat, Donk Patio, and your specific expertise — not generic text. Written so that when someone searches "juwelier Brasschaat" or "horloges Antwerpen," your pages appear.

### 4. Professional photography by Bene
New photos of you and Elke in the shop, the interior, product displays, and detail shots. Bene has a full brief covering hero shots, portraits, shop interiors, and category images. These become the centrepiece of the site.

### 5. Google rankings protected
All current links keep working — nothing breaks when the new site goes live. Google gets your correct address, hours, and services automatically. Your current search position is preserved during the migration.

### 6. Google Business Profile optimised
Updated with new photography, correct hours, and fresh description. This listing often has higher impact than the website itself — it's what appears when someone searches "juwelier Brasschaat" on their phone.

### 7. Training for Elke
A 30–60 minute session walking through: how to update opening hours, add a holiday closure, toggle a brand on or off, and add a time-limited announcement. In person or video call — whatever suits.

**Jargon removed:**
- ~~Sanity CMS~~ → "Admin panel"
- ~~SEO copy~~ → "optimised for Google"
- ~~SEO protection~~ → "Google rankings protected"
- ~~301 redirects~~ → "All current links keep working"
- ~~Structured data / LocalBusiness schema~~ → "Google gets your correct address, hours, and services automatically"
- ~~XML sitemap submitted to Search Console~~ → removed entirely
- ~~CMS training~~ → "Training for Elke"

---

## Card 3: The Week

**Section header:** "The Week"

**Section intro:** "Five days across one week. Here's what happens."

### Day-by-day bullets (5 items):

**1. Day 1 (Thu 19 Feb) — Project start**
Set up the admin panel with your brand data and opening hours. Build the basic site structure and prepare the three visual directions.

**2. Day 2 (Fri 20 Feb) — Three design directions**
Three visual directions of the homepage — Normal (safe, warm), Hot (bolder contrast), Spicy (unexpected). Each shows different typography, colours, and hero treatment.

**3. Day 3 (Mon 23 Feb) — Decision meeting + photography**
Morning: 30–60 min decision meeting with you and Elke — point at what you like, merge elements if needed ("colours from A, layout from C"). Decision is final. Then Bene's photo session while the store is closed — perfect timing.

**4. Day 4 (Tue 24 Feb) — Full build**
Homepage complete, all 4 service pages built, admin panel connected, Bene's photos integrated, Dutch copy finalised. Train Elke on the admin panel (30–60 min). Final sign-off from you.

**5. Day 5 (Wed 25 Feb) — Buffer**
For feedback and revisions if needed. If the site is clean, this time goes to Google Business deep optimisation.

**Payment:** €2,500 before build week

**Updates:** "You'll get a screenshot via WhatsApp each evening so you can see progress."

**Boundaries text:**
"Two decision points during the week: visual direction pick (Day 3) and final sign-off (Day 4). Anything beyond the agreed scope can be discussed as follow-up work."

**Removed:**
- ~~"How Zebra Sprints work" link~~ — irrelevant for Luc
- ~~"Zebra Sprints have boundaries that protect both of us"~~ — too legalistic
- ~~"Go live on spooren.be"~~ — domain switch happens later with hosting provider
- ~~French /fr route~~ — not in scope
- ~~"SEO implementation"~~ → removed from visible text

---

## Card 4: Before We Start (Homework + Next Steps merged)

**Section header:** "Before We Start"

**Intro line:** "We've gathered most of what we need from the workshop and your current website. We've put everything into a short document — just need you to check it before February 19th."

**Google Doc link:** [Open the checklist](https://docs.google.com/document/d/1-sIPrINpLK1mmNA56iFvy9il6PxnL34nBz1hPeRPkew/edit?usp=sharing)

**Description below link:** "Opening hours, brand lists, holiday closures — everything pre-filled from spooren.be. You just confirm or correct."

### Closing line (replaces separate Next Steps card):

"Confirm you're happy with this approach — reply or tell Bene. She'll coordinate the photography session for Day 3. We start February 19th."

**Approach change from original:**
- ~~In-proposal checkbox list~~ → Google Doc Luc can edit directly
- Pre-filled with scraped data (brands, opening hours) so Luc only needs to confirm/correct
- Dutch-friendly, simple formatting
- Google Doc content spec: `workings/spooren-proposal/spooren-homework-google-doc.md`

---

## Sections REMOVED (from standard template)

| Section | Why Removed |
|---------|-------------|
| **Evidence Block** | Luc doesn't need proof of Charlie's work |
| **Case Studies** | Research Tech and Animatix irrelevant to a jeweller |
| **Credentials** | Crypto logos and "50+ sprints" meaningless. Trust is Bene. |
| **Next Steps** (as separate card) | Merged into "Before We Start" for fewer cards |

---

## Implementation Plan (Code Changes)

### Step 1: Add Spooren data to `lib/proposals/data.ts`

Add `SPOOREN_WHAT_YOU_GET`, `SPOOREN_HOW_WE_WORK`, and `SPOOREN_PROPOSAL` constants. Add to `ALL_PROPOSALS` array. All existing defaults and example proposal untouched.

**Key data differences from template:**
- `evidenceBlock`: undefined (skip)
- `caseStudies`: undefined (skip)
- `clientLogos`: [] (empty — Credentials section hidden)
- `whatYouGet`: Spooren-specific items (jargon-free)
- `howWeWork`: Day-by-day timeline (not sprint process bullets)
- `paymentSchedule`: Single payment [{ label: "Full payment", amount: 2500, when: "Before build week" }]
- `boundariesText`: Spooren-specific (2 decision points, not legalistic)

**New optional fields needed on ProposalData type:**
- `sidebarLabel?: string` — "Website Rebuild" (default: "UX Partnership")
- `homeworkLink?: { url: string; label: string; description: string }` — External link to homework doc (Google Doc)
- `closingLine?: string` — Replaces separate Next Steps card
- `processDocsLink?: string` — When absent, hide "How Zebra Sprints work" link
- `hideBookCallLink?: boolean` — Remove "book a call" from sidebar
- `hideSecondAvatar?: boolean` — Show only Charlie's avatar
- `expandDeliverables?: boolean` — Render deliverables as flat list, not accordion

### Step 2: Update components (non-breaking changes)

| File | Change |
|------|--------|
| `proposal-sidebar.tsx` | Optional sidebarLabel, optional second avatar, optional "book a call" link |
| `proposal-content.tsx` | Render homework section when `homeworkLink` present. Skip Credentials when `clientLogos` empty. Skip Next Steps when `closingLine` present. |
| `sections/what-you-get.tsx` | When `expandDeliverables` is true, render flat list instead of accordion |
| `sections/how-we-work.tsx` | Conditional `processDocsLink` — hide "How Zebra Sprints work" when absent |
| `sections/credentials.tsx` | Skip entire section when `clientLogos` is empty |
| `sections/before-we-start.tsx` | NEW: Short intro + Google Doc link + closing line |

### Step 4: Font size adjustments (Spooren-specific or global improvement)

Consider increasing:
- Section headers: `text-xs` → `text-sm`
- Body text: `text-sm` → `text-base` (16px)
- Sidebar label: `text-[10px]` → `text-xs`
- Body colour: `text-stone-500` → `text-stone-600` or `text-stone-700` for better contrast

These could be global improvements (benefit all proposals) or Spooren-specific via a CSS class.

### Files to Create/Modify

1. `lib/proposals/types.ts` — Add optional fields (homeworkLink, closingLine, sidebarLabel, etc.)
2. `lib/proposals/data.ts` — Add Spooren constants + proposal data
3. `components/proposals/proposal-sidebar.tsx` — Optional label, avatar, call link
4. `components/proposals/proposal-content.tsx` — Conditional homework, credentials, next steps
5. `components/proposals/sections/what-you-get.tsx` — Flat list mode
6. `components/proposals/sections/how-we-work.tsx` — Conditional docs link
7. `components/proposals/sections/credentials.tsx` — Hide when empty
8. `components/proposals/sections/before-we-start.tsx` — NEW: intro + Google Doc link + closing line

---

## Content Tone Guide (Refined)

- **Warm but professional** — A letter from someone who did the homework, not a contract
- **Concrete** — Dates, specific deliverables, exact items
- **Zero jargon** — Every sentence passes the test: "Would Luc understand if Bene read it aloud in Dutch?"
- **Mixed language** — Dutch greeting, English body. Matches real communication.
- **Short** — 4 cards, not 6. Every sentence answers "what, when, or what do I need to do"
- **Reassuring** — "We've gathered most of what we need" not "complete these 7 tasks"

---

## What to Preserve (Do Not Touch)

These elements were praised by all perspectives:

1. **The "Bedankt" opening** — Emotional anchor of the page
2. **The day-by-day timeline** — Strongest section, answers "what happens when"
3. **The homework checklist with real details** — Proves Charlie did the research
4. **"Bevestigen" as CTA** — One Dutch word, always visible
5. **The split-panel layout** — Price and CTA always accessible
6. **The deliverable titles** — Clear, concrete, personal (mentions Bene, Elke, Brasschaat)
7. **The mobile sticky CTA bar** — Proper touch targets for phone reading

---

*Refined: 15 February 2026*
*Based on: 4-perspective UX analysis (Claude UX + Claude Simplicity + Gemini UX + Gemini Simplicity)*
*Ready for implementation.*
