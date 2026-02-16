## Add Collapsible Evidence, Case Studies & Credentials Section to TBLA Proposal

### Original Request

"I think we should bring back a case studies and evidence section. This should be the sections from the template merged into one card and we should replace animatix case study with our own app - the user testing app - see https://www.zebradesign.io/user-testing and the attached image for the image for it. We should also add the credential section to it. The way we do it is have a small section with just the title 'Evidence, Case Studies and Credentials' then a one line underneath with the info icon. Clicking it expands with the contents of the three sections. It should go at the end of the proposal before next steps."

### Reference Images

| Image | Path | Source | Description | Purpose |
|-------|------|--------|-------------|---------|
| User Testing App hero | `/Users/charlieellington1/conductor/workspaces/zebra-design-sprints/missoula-v1/.context/attachments/Screenshot 2026-02-16 at 18.30.50.png` | Attached screenshot | Hero section of Zebra User Testing App — light gradient bg, "Test Your App's UX with Real Users" heading | case-study-image |

**Primary Visual Direction**: Follows existing proposal slide-card pattern. The collapsible trigger matches the Credentials bio accordion pattern (info icon, not chevron).

### Design Context

**Interaction Pattern**: Single Radix accordion trigger — title heading + summary line with info icon. Clicking expands to reveal three stacked sections (Evidence → Case Studies → Credentials). Matches the existing Credentials bio pattern at `components/proposals/sections/credentials.tsx:53-80` which uses `AccordionPrimitive.Trigger` with an `Info` icon instead of a chevron.

**Section Contents When Expanded**:
1. **Evidence** — Research Tech stats, pull-quote, replacement cost anchor (reuses `RESEARCH_TECH_EVIDENCE` from `data.ts`)
2. **Case Studies** — Research Tech (keep) + User Testing App (replace Animatix). Two-card grid with gradient backgrounds and side-by-side screenshots
3. **Credentials** — Client logo grid + Charlie bio accordion

**Position**: After the last `after-process` custom section (After the Sprint) and before Next Steps/Closing Line. This is the penultimate card.

### Codebase Context

**Existing components to reuse**:
- `components/proposals/sections/evidence-block.tsx` — EvidenceBlock component (renders stats, quote, cost anchors)
- `components/proposals/sections/case-studies.tsx` — CaseStudies component (renders card grid with visual types)
- `components/proposals/sections/credentials.tsx` — Credentials component (logo grid + bio accordion)

**Data sources (already exported from data.ts)**:
- `RESEARCH_TECH_EVIDENCE` — evidence block data
- `DEFAULT_CASE_STUDIES` — array with Research Tech + Animatix case studies
- `DEFAULT_CLIENT_LOGOS` — 7 client logos

**Key files**:
- `lib/proposals/types.ts` — ProposalData interface (needs `mergeProofSections` flag)
- `lib/proposals/tbla.ts` — TBLA proposal data (needs evidence, case studies, logos)
- `lib/proposals/data.ts` — template defaults (import from here)
- `components/proposals/proposal-content.tsx` — rendering orchestrator (needs CollapsibleProof placement)

**Rendering flow in ProposalContent**:
Currently Evidence (section 3), Case Studies (section 4), and Credentials (section 6) render as separate cards. With `mergeProofSections: true`, these three skip their individual rendering and instead render inside a single CollapsibleProof card before the closing/next-steps section.

### Plan

**Step 1: Save User Testing screenshot to public/images**
- Copy attached screenshot to `public/images/proposals/user-testing-hero.png`
- This becomes the `screenshotUrl` for the User Testing case study

**Step 1b: Extract shared defaults to `lib/proposals/defaults.ts`**
- `data.ts` imports `TBLA_PROPOSAL` from `tbla.ts`, so `tbla.ts` cannot import from `data.ts` (circular dependency)
- Create `lib/proposals/defaults.ts` — move `RESEARCH_TECH_EVIDENCE`, `DEFAULT_CASE_STUDIES`, `DEFAULT_CLIENT_LOGOS`, `DEFAULT_WHAT_YOU_GET`, `DEFAULT_HOW_WE_WORK`, `DEFAULT_BOUNDARIES_TEXT` there
- Update `data.ts` to re-export from `./defaults` (backward compatible)
- `tbla.ts` imports from `./defaults` safely

**Step 2: Add `mergeProofSections` flag to ProposalData type**
- File: `lib/proposals/types.ts`
- Add `mergeProofSections?: boolean;` to ProposalData interface (after `clientLogos`)
- This tells ProposalContent to combine evidence + case studies + credentials into one collapsible card instead of rendering them separately

**Step 3: Add evidence, case studies, and logos to TBLA proposal data**
- File: `lib/proposals/tbla.ts`
- Import `RESEARCH_TECH_EVIDENCE`, `DEFAULT_CASE_STUDIES`, `DEFAULT_CLIENT_LOGOS` from `./defaults`
- Create `TBLA_CASE_STUDIES` array:
  - Keep Research Tech case study (from `DEFAULT_CASE_STUDIES[0]`)
  - Replace Animatix with new User Testing App case study:
    - title: "Async user testing for founders"
    - slug: "user-testing"
    - tags: ["PRODUCT", "AI", "SHIPPED"]
    - description: "10 hours of user interviews in 10 minutes. Screen + voice recordings with AI transcripts."
    - screenshotUrl: "/images/proposals/user-testing-hero.png"
    - images: ["/images/proposals/user-testing-hero.png"] (single image, browser visual type)
    - visualType: undefined (falls back to browser chrome)
    - gradientBg: "linear-gradient(135deg, #F5F3FF 0%, #EDE9FE 40%, #FDF2F8 70%, #FFF1F2 100%)" (light purple-pink matching the app's gradient)
    - linkUrl: "https://www.zebradesign.io/user-testing"
    - linkText: "Try the app"
    - variant: "light"
- Add to TBLA_PROPOSAL:
  - `evidenceBlock: RESEARCH_TECH_EVIDENCE`
  - `caseStudies: TBLA_CASE_STUDIES`
  - `clientLogos: DEFAULT_CLIENT_LOGOS`
  - `mergeProofSections: true`

**Step 4: Create CollapsibleProof component**
- File: `components/proposals/sections/collapsible-proof.tsx`
- New "use client" component (~80 lines)
- Props: `{ evidence, caseStudies, clientLogos, slug }`
- Structure:
  ```
  <section>
    <h2> Evidence, Case Studies and Credentials </h2>    ← mono heading (matches all other sections)
    <Accordion type="single" collapsible>
      <AccordionItem>
        <AccordionPrimitive.Trigger>
          "Sprint track record, case studies, and client logos"   [Info icon]
        </AccordionPrimitive.Trigger>
        <AccordionContent>
          <div className="space-y-10 pt-4">
            <EvidenceBlock />
            <CaseStudies />
            <Credentials />
          </div>
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  </section>
  ```
- Uses same accordion + info icon pattern as Credentials bio trigger
- Reuses existing EvidenceBlock, CaseStudies, and Credentials components inside

**Step 5: Wire CollapsibleProof into ProposalContent**
- File: `components/proposals/proposal-content.tsx`
- Import CollapsibleProof
- When `proposal.mergeProofSections` is true:
  - Skip rendering sections 3 (Evidence), 4 (Case Studies), and 6 (Credentials) individually
  - Render CollapsibleProof in a new slide card between section 5.5 (after-process custom sections) and section 7 (closing/next steps)
- When false/undefined: render normally (backward compatible, no regression)

### Review Notes (Agent 2)
- **Circular dependency resolved**: Added Step 1b to extract shared defaults to `lib/proposals/defaults.ts`. Both `data.ts` and `tbla.ts` import from `defaults.ts` safely.
- **BrowserChrome URL cosmetic**: The browser chrome component hardcodes `zebradesign.io/articles/${slug}` in the mock URL bar. For user-testing slug this shows `zebradesign.io/articles/user-testing` rather than `zebradesign.io/user-testing`. Minor cosmetic — the actual link works correctly.
- **All component APIs verified** against source files. Accordion pattern matches credentials.tsx.

### Stage
Confirmed

### Questions for Clarification
No clarification questions — plan complete.

### Priority
High

### Created
2026-02-16

### Files
- `lib/proposals/types.ts` — add mergeProofSections flag
- `lib/proposals/tbla.ts` — add evidence, case studies, logos, flag
- `components/proposals/sections/collapsible-proof.tsx` — NEW component
- `components/proposals/proposal-content.tsx` — conditional rendering logic
- `public/images/proposals/user-testing-hero.png` — NEW image asset
