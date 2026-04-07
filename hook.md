# Design Iteration Harness v2 — "Diamond"

Automated design improvement system using diverge-converge methodology.
Explores 5 radically different visual directions via triple-model analysis
(Claude + Gemini + Codex), selects the best 2, refines each, picks a
winner, and polishes to production quality.

Works for any page, any app. Context-driven — reads your project, brand,
and goals to generate directions automatically.

---

## Token Budget & Context Management

**Model:** Claude Opus 4.6 (1M context window)

**Estimated token cost per phase:**
| Phase | Tokens | Cost Est. | Notes |
|-------|--------|-----------|-------|
| 0. Context & Planning | ~8,000 | ~$0.50 | Read files, capture context |
| 1. Triple-model discovery | ~12,000 | ~$2.00 | 3 MCP calls + merge analysis |
| 2. Diverge (5 directions) | ~50,000 | ~$8.00 | 5 implementations + screenshots |
| 3. Select (evaluate 5) | ~8,000 | ~$1.50 | Gemini scores all 5 |
| 4. Refine (6 iterations) | ~90,000 | ~$12.00 | 3 iters × 2 finalists |
| 5. Converge (head-to-head) | ~6,000 | ~$1.00 | Triple-model comparison |
| 6. Polish (3 iterations) | ~45,000 | ~$6.00 | Final refinement |
| **Total** | **~220,000** | **~$31** | **~22% of 1M context** |

**Context reset points:**
- After Phase 2 → Phase 3 (write summary file, can compact)
- Between two refinement tracks in Phase 4
- After Phase 5 → Phase 6

**Optimisation tips:**
- MCP calls (Gemini, Codex) are "free" in Claude context — images sent via MCP
- Screenshots read via Read tool cost ~2-3k each — send to Gemini instead where possible
- Write phase summaries to files so context can be compacted safely

---

## RECOVERY PROTOCOL (read this first)

**On every new message or after any context compaction:**
1. Read the status file in `agents/doing/diamond-{slug}.md` — tells you which phase and step you're in
2. Read the current phase summary file (if mid-run) listed in the status file
3. Check your task list (`TaskList`) — tasks track each phase's state
4. Continue from where you left off

**Do NOT restart from Phase 0 if work has already been done.**

---

## How to run

Paste this into Claude Code / Conductor:

```
@agents/hook.md — iterate on [page description]. Target URL: [url].
Reference images: [paths or attachments].
```

The harness will automatically:
1. Create a status file at `agents/doing/diamond-{slug}.md`
2. Run through all 6 phases
3. Update the status file at each phase transition

### Status file creation (automatic on first run)

When the harness starts, create `agents/doing/diamond-{slug}.md` where
`{slug}` is derived from the target page (e.g. `diamond-proposal-page.md`,
`diamond-landing-page.md`, `diamond-call-page.md`):

```markdown
# Diamond: {Page Name}

## Current State
- **Phase:** 0 — Context & Planning
- **Step:** Starting
- **Target URL:** {url}
- **Target files:** {component directory}
- **Started:** {date}

## Phase Log
| Phase | Status | Summary | Date |
|-------|--------|---------|------|
| 0. Context | pending | — | — |
| 1. Directions | pending | — | — |
| 2. Diverge | pending | — | — |
| 3. Select | pending | — | — |
| 4. Refine | pending | — | — |
| 5. Converge | pending | — | — |
| 6. Polish | pending | — | — |

## Directions
(populated in Phase 1)

## Finalists
(populated in Phase 3)

## Winner
(populated in Phase 5)

## Live URLs
(populated as directions/iterations are created)
```

Also add a one-liner to `agents/status.md` under the appropriate section:
```markdown
- [ ] Diamond: {Page Name}
```

Provide context in your prompt:
- What page/component to iterate on (URL or file path)
- Reference images (attach or provide paths)
- Any specific direction or constraints
- Brand guide location (if not in standard places)

---

## Phase 0: CONTEXT & PLANNING

**Goal:** Understand what we're designing, for whom, and what "done" looks like.
This is a lighter version of full design planning — just enough context to
generate informed visual directions.

### 0a. Validate MCP connections (MANDATORY FIRST STEP)

Before anything else, verify all MCP tools are working:

```
✅ mcp__aistudio__generate_content — test with simple prompt
✅ mcp__codex-cli__codex — test with ping
✅ Playwright — test with npx playwright --version
```

**If any MCP fails:** Stop and report. Do not proceed with manual workarounds.
Discovery from 200+ agent runs: failing mid-process wastes significant time.

### 0b. Auto-detect project

Read `package.json` to determine:
- Framework (Next.js, Vite, etc.) and dev server port
- UI libraries (shadcn/ui, Tailwind, etc.)
- Key dependencies

### 0c. Read design context

Check these files (skip any that don't exist):
- `CLAUDE.md` — project rules and conventions
- `project-context.md` or `.context/proposal-redesign-direction.md` — visual direction
- Brand guide (search for `brand.md` in `documentation/`)
- `documentation/goals.md` — what the page must achieve
- Any reference images the user attached

**Categorise reference images by purpose:**
| Category | What it tells you | Example |
|----------|-------------------|---------|
| `layout-reference` | Overall structure/grid | Tailark page screenshots |
| `component-reference` | Specific component styling | Stripe Atlas pricing |
| `interaction-reference` | Hover/animation behaviour | Badge hover states |
| `color-reference` | Palette inspiration | Brand guide swatches |
| `flow-reference` | User journey/navigation | Checkout flow screenshots |

Tag each reference image in the context file — this helps Gemini prompts be specific.

### 0d. Capture the target

- **Target URL:** The page to iterate on (e.g. `http://localhost:5173/p3/acme-2026-abc1`)
- **Target files:** The component directory (e.g. `src/components/proposal-v3/`)
- **Route file:** The page route (e.g. `src/routes/p3/$slug.tsx`)

### 0e. Catalogue existing design patterns (CRITICAL)

**Learned from 200+ agent runs:** The #1 cause of visual inconsistency is
not reading existing code before writing new code.

Scan existing components and document the actual CSS patterns:

```bash
# Find all card/grid/layout components and their styling
grep -r "className.*border" src/components/ --include="*.tsx" | head -30
```

Document what you find:

```markdown
### Codebase Design Language
| Pattern | Value | Source File |
|---------|-------|-------------|
| Corners | [e.g., rounded-none / rounded-lg] | [component] |
| Card borders | [e.g., border border-gray-200] | [component] |
| Card shadows | [e.g., none / shadow-sm] | [component] |
| Section spacing | [e.g., py-12 / py-16] | [component] |
| Heading style | [e.g., text-3xl font-bold] | [component] |
| Hover states | [e.g., hover:bg-gray-50] | [component] |
| Max width | [e.g., max-w-4xl / max-w-5xl] | [component] |
```

**This table is the source of truth** for all subsequent phases. Every direction
must match these patterns unless the user explicitly says otherwise.

### 0f. Screenshot the starting state

```bash
npx playwright screenshot \
  --viewport-size=1440,900 \
  --full-page \
  --wait-for-timeout=5000 \
  "{TARGET_URL}" \
  "design-iterations/v0-starting-state.png"
```

### 0g. Define scoring rubric

**Phase 2-3 rubric** (direction selection — values originality):

| Criterion | What it measures | Pass threshold |
|-----------|-----------------|----------------|
| **Design quality** | Coherence, mood, brand identity, visual hierarchy | ≥ 7/10 |
| **Originality** | Custom decisions vs generic templates, distinctive character | ≥ 6/10 |
| **Craft** | Typography, spacing, contrast, grid consistency, border quality | ≥ 7/10 |
| **Functionality** | Readability, scannability, CTA visibility, mobile-ready | ≥ 7/10 |

A direction **fails** if ANY criterion scores below its threshold.

**Phase 4-6 rubric** (refinement/polish — values consistency):

| Category | Weight | Auto-fail condition |
|----------|--------|---------------------|
| **Existing page match** | 40% | Visually different from existing app pages |
| **Corners & borders** | 25% | Different corner radius, shadow, or border treatment |
| **Colors** | 15% | Button/accent colors don't match design system |
| **Typography** | 10% | Wrong font family, sizes, or weights |
| **Layout & spacing** | 10% | Inconsistent gaps, padding, or max-width |

Auto-fail deductions: -2 to category score for any of the auto-fail conditions.
Pass threshold: weighted total ≥ 9.0/10.

### 0h. Search for component blocks (if available)

If Tailark Pro or shadcn registries are configured:
```bash
grep -l "tailark" components.json 2>/dev/null
```

Include available blocks in the context file.

### 0f. Write context file

Write everything to `design-iterations/phase-0-context.md`:
- Project details (framework, UI lib, brand colours, typography)
- Target page description and purpose
- Scoring rubric
- Reference image paths
- Available component blocks (if Tailark Pro configured, search available blocks)
- What content must be preserved (data rendering, accept flows, etc.)
- List of component files to modify

### 0g. Search for component blocks (if available)

If Tailark Pro or shadcn registries are configured:
```bash
# Check if Tailark Pro is configured
grep -l "tailark" components.json 2>/dev/null
# If yes, list available blocks
cd app && pnpm dlx shadcn@latest search @tailark-pro/ 2>/dev/null
```

Include available blocks in the context file — directions can use them as starting points.

**Update agents/doing/diamond-{slug}.md:**
```
- Phase: 0 — Context & Planning
- Step: Complete
```

---

## Phase 1: TRIPLE-MODEL DIRECTION DISCOVERY

**Goal:** Generate 5 distinct visual directions by asking 3 models independently,
then merging their proposals. This removes single-model bias and produces
more creative, cross-validated directions.

### 1a. Build the direction prompt

Create a single prompt that will go to ALL THREE models identically.
Include:
- The page context from `design-iterations/phase-0-context.md`
- The starting screenshot
- Any reference images the user provided
- The scoring rubric

**The prompt template:**

```
You are a senior visual designer proposing visual directions for a [PAGE TYPE]
for [COMPANY/PROJECT].

CONTEXT:
{paste from phase-0-context.md — project details, brand, goals, constraints}

CURRENT STATE:
[Starting screenshot attached]

REFERENCE IMAGES:
[User's reference images attached — describe each]

SCORING CRITERIA:
1. Design quality (coherence, mood, identity) — must score ≥7
2. Originality (custom decisions vs templates) — must score ≥6
3. Craft (typography, spacing, contrast, grids) — must score ≥7
4. Functionality (readability, scannability, CTAs) — must score ≥7

Propose exactly 3 RADICALLY DIFFERENT visual directions. Each must be a
genuinely distinct aesthetic — not variations of the same idea. Think:
- Direction 1: could be inspired by editorial/magazine design
- Direction 2: could be inspired by SaaS product pages (Stripe, Linear)
- Direction 3: could be something unexpected or genre-breaking

For each direction, provide:
1. **Name** (2-3 word label, e.g. "Swiss Grid", "Dark Editorial", "Bento Dashboard")
2. **One-sentence pitch** — the core idea in plain English
3. **Visual characteristics** — layout, typography, colour approach, spacing, photography
4. **Specific Tailwind/CSS** — key classes that define this direction (fonts, colours, spacing scale, border style)
5. **How it scores** — predict how it would score on the 4 criteria
6. **Risk** — what could go wrong with this direction
```

### 1b. Send to all three models (identical prompt)

**Claude (inline):**
Analyse the starting screenshot + context and write your 3 directions.

**Gemini:**
```
mcp__aistudio__generate_content({
  user_prompt: "{THE PROMPT FROM 1a}",
  files: [
    { path: "design-iterations/v0-starting-state.png" },
    ...referenceImages
  ],
  model: "gemini-3.1-pro-preview"
})
```

**Codex/OpenAI:**
```
mcp__codex-cli__codex({
  prompt: "{THE PROMPT FROM 1a}\n\n[Note: reference images described in text, not attached]",
  model: "gpt-5.4"
})
```

Note: Codex can't receive images, so describe the starting state and
reference images in text for that call.

### 1c. Merge and select 5 directions

You now have 9 raw directions (3 per model). Merge them:

**Triple convergence** (all 3 models proposed something similar):
→ Include. This is the highest-confidence direction. Note it as "converged."

**Double convergence** (2 models agree, 1 diverges):
→ Include the converged version. Note the dissenting model's twist — it
might be worth incorporating.

**Unique directions** (only 1 model proposed it):
→ Include the most interesting/creative one. These are the wild cards
that prevent groupthink.

**Selection rules:**
1. Must end up with exactly 5 directions
2. At least 1 must be a "converged" direction (safe bet)
3. At least 1 must be a "wild card" (only proposed by one model)
4. All 5 must be genuinely distinct from each other
5. All 5 must be plausible for the page type (no joke entries)

### 1d. Write the directions file

Write to `design-iterations/phase-1-directions.md`:

```markdown
# Visual Directions

## Direction A: [Name] — [convergence status]
**Proposed by:** Claude + Gemini (converged) / Codex suggested [variation]
**Pitch:** [one sentence]
**Visual:** [layout, type, colour, spacing, borders]
**Key Tailwind:** [specific classes]
**Predicted scores:** Design: X, Originality: X, Craft: X, Function: X

## Direction B: [Name] — [convergence status]
...

## Direction C, D, E...
```

**Update agents/doing/diamond-{slug}.md:**
```
- Phase: 1 — Direction Discovery
- Step: Complete — 5 directions selected
- Directions: A=[name], B=[name], C=[name], D=[name], E=[name]
```

---

## Phase 2: DIVERGE (implement 5 directions)

**Goal:** Build each direction as a live page. Big swings, not polish.
Each gets one iteration. Focus on the core aesthetic, not perfection.

### For each direction (A through E):

#### 2-1. Copy the component folder

```bash
cp -r {TARGET_COMPONENT_DIR} {TARGET_COMPONENT_DIR}-dirX
# e.g. cp -r src/components/proposal-v3 src/components/proposal-v3-dirA
```

#### 2-2. Create a route for this direction

```bash
mkdir -p src/routes/{ROUTE_PREFIX}-dirX
```

Write a route file that imports from the direction's component folder.
Example: `src/routes/p3-dirA/$slug.tsx` importing from `proposal-v3-dirA/`.

#### 2-3. Verify correct component (BEFORE implementing)

Add a temporary colored div to confirm you're editing the right file:

```tsx
// Add temporarily to the copied component
<div className="bg-red-500 text-white p-4">DIRECTION X TEST</div>
```

Visit the direction's URL. If you see the red div → correct file. Remove it.
If not → trace imports from the route file to find the actual component.

**This prevents the "wrong file" bug that wastes entire iterations.**

#### 2-4. Implement the direction

Read `design-iterations/phase-1-directions.md` for this direction's spec.
Edit ONLY the copied component files (`-dirX/` folder).

**CRITICAL RULES:**
- NEVER break functionality (accept flows, data rendering, etc.)
- NEVER change component prop interfaces
- NEVER change content/copy — visual changes ONLY
- You may restructure layouts, add visual elements, change typography
- Keep all changes within the copied files
- **MUST match codebase design language** from Phase 0e (corners, borders, shadows)
  unless the direction spec explicitly says otherwise

**Design Language Check:** Before writing CSS, cross-reference your planned
classes against the codebase design language table from Phase 0e. If your
classes differ (e.g., you're using `rounded-lg` but codebase uses `rounded-none`),
fix BEFORE implementing.

This is a big-swing iteration — implement the direction's core aesthetic
boldly. But respect the codebase's established patterns for corners, borders, and shadows.

#### 2-4. Screenshot

```bash
npx playwright screenshot \
  --viewport-size=1440,900 \
  --full-page \
  --wait-for-timeout=5000 \
  "{TARGET_URL_PREFIX}-dirX/{SLUG}" \
  "design-iterations/dirX-desktop.png"
```

#### 2-5. Commit

```bash
git add {COPIED_COMPONENT_DIR} {ROUTE_DIR} design-iterations/
git commit -m "$(cat <<'EOF'
design-direction-X: [direction name] — [one-line description]

Diverge phase: implementing [direction name] as a distinct visual direction.
Live URL: /{ROUTE_PREFIX}-dirX/{SLUG}

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

**Repeat for all 5 directions.**

**Update agents/doing/diamond-{slug}.md after all 5:**
```
- Phase: 2 — Diverge
- Step: Complete — 5 directions implemented
- URLs:
  - Direction A: /p3-dirA/{slug}
  - Direction B: /p3-dirB/{slug}
  - Direction C: /p3-dirC/{slug}
  - Direction D: /p3-dirD/{slug}
  - Direction E: /p3-dirE/{slug}
```

---

## Phase 3: SELECT (evaluate all 5, pick top 2)

**Goal:** Score every direction against the rubric. Use Gemini as the
independent evaluator (Claude generated them — separation of concerns).

### 3a. Take comparison screenshots

Screenshot all 5 directions at the same viewport size.

### 3b. Gemini evaluates each direction

For each direction, send its screenshot + reference images to Gemini:

```
mcp__aistudio__generate_content({
  user_prompt: `You are an independent design evaluator. Score this page
against the rubric below. Be HARSH — only scores backed by specific
evidence. Do not praise by default.

SCORING RUBRIC:
1. Design quality (coherence, mood, identity) — pass ≥ 7/10
2. Originality (custom decisions vs templates) — pass ≥ 6/10
3. Craft (typography, spacing, contrast, grids) — pass ≥ 7/10
4. Functionality (readability, scannability, CTAs) — pass ≥ 7/10

For each criterion:
- Score (1-10)
- Evidence (point to specific elements)
- PASS or FAIL against threshold

Then: OVERALL VERDICT — would you ship this to a client? Why or why not?

Reference images are attached — the page should aim for this quality level.`,
  files: [
    { path: "design-iterations/dirX-desktop.png" },
    ...referenceImages
  ],
  model: "gemini-3.1-pro-preview"
})
```

### 3c. Claude also scores (with Playwright interaction)

For each direction, use Playwright MCP to:
- Test hover states on interactive elements
- Check mobile layout (resize to 375px)
- Verify all content is visible (no overflow/clipping)
- Check CTA is prominent and accessible

Score against the same rubric.

### 3d. Select top 2

Combine Claude and Gemini scores. Pick the 2 directions with:
1. Highest combined score
2. No FAIL on any criterion
3. If tied: prefer the one with higher Originality score

Write results to `design-iterations/phase-3-selection.md`:

```markdown
# Direction Selection

| Direction | Design | Originality | Craft | Function | Total | Selected |
|-----------|--------|-------------|-------|----------|-------|----------|
| A: [name] | 8 | 7 | 8 | 9 | 32 | ✅ |
| B: [name] | 7 | 9 | 6 | 8 | 30 | |
| C: [name] | 9 | 8 | 9 | 8 | 34 | ✅ |
| D: [name] | 6 | 7 | 7 | 7 | 27 | |
| E: [name] | 7 | 6 | 5 | 8 | 26 | |

## Finalists
- **Finalist 1:** Direction A — [why it was selected]
- **Finalist 2:** Direction C — [why it was selected]

## Eliminated
- Direction B — [why: craft score below threshold]
- Direction D — [why: design quality too low]
- Direction E — [why: lowest combined score]
```

**Update agents/doing/diamond-{slug}.md:**
```
- Phase: 3 — Select
- Step: Complete — 2 finalists chosen
- Finalist 1: Direction [X] — [name]
- Finalist 2: Direction [Y] — [name]
```

---

## Phase 4: REFINE (3 iterations × 2 finalists)

**Goal:** Take each finalist through 3 focused refinement iterations.
Each iteration uses a sprint contract (hard pass/fail) and the
Gemini code review step.

### Sprint contract format

Before each iteration, define exactly what "done" looks like:

```markdown
## Sprint Contract — Iteration {N}

This iteration PASSES if ALL of these are true:
✅ [Specific measurable criterion — e.g. "Badge grid uses divide-x/divide-y, no per-cell borders"]
✅ [Specific measurable criterion — e.g. "All section headings are text-3xl font-bold"]
✅ [Specific measurable criterion — e.g. "Hero image fills grid cell edge-to-edge"]

This iteration FAILS if ANY of these are true:
❌ [Regression — e.g. "Any existing data stops rendering"]
❌ [Regression — e.g. "Accept button is no longer visible above fold"]
```

### For each iteration on each finalist:

#### 4-1. Screenshot current state

```bash
npx playwright screenshot \
  --viewport-size=1440,900 \
  --full-page \
  --wait-for-timeout=5000 \
  "{FINALIST_URL}" \
  "design-iterations/finalist{F}-iter{N}-before.png"
```

#### 4-2. Gemini critique (evaluator role)

Send screenshot + reference images to Gemini. Ask for top 3 improvements
with specific CSS/Tailwind. Gemini is the EVALUATOR — it judges, it doesn't
generate code yet.

#### 4-3. Write sprint contract

Based on Gemini's critique, write a sprint contract with 3-5 pass criteria.

#### 4-4. Gemini code review (Phase 2b from v1)

Send the sprint contract + current code snippets + reference images to
Gemini. Ask for EXACT replacement code.

```
mcp__aistudio__generate_content({
  user_prompt: `You are a senior frontend engineer.

SPRINT CONTRACT:
${sprintContract}

CURRENT CODE:
${codeSnippets}

REFERENCE IMAGES attached show the target aesthetic.

Give me EXACT replacement JSX/Tailwind for each change needed to pass
the sprint contract. Return ONLY code — no explanations.

Format:
FILE: [filename]
REPLACE THIS:
\`\`\`tsx
[old code]
\`\`\`
WITH THIS:
\`\`\`tsx
[new code]
\`\`\``,
  files: [
    { path: "design-iterations/finalist{F}-iter{N}-before.png" },
    ...referenceImages
  ],
  model: "gemini-3.1-pro-preview"
})
```

#### 4-5. Implement changes

Apply the code changes to the finalist's component folder.

#### 4-6. Screenshot and verify sprint contract

Take after screenshot. Check each sprint contract criterion:
- Use Playwright screenshots for visual checks
- Use code inspection for class/structure checks
- Mark each criterion PASS or FAIL

If ANY criterion FAILS: fix it before proceeding. Do not move to next iteration
with a failing contract.

#### 4-7. Pivot-or-refine gate

After verification, make an explicit decision:

```markdown
## Pivot-or-Refine Decision — Iteration {N}

Scores trending: [up / flat / down]
Sprint contract: [all pass / partial fail]

DECISION: [REFINE — continue this direction / PIVOT — try a different approach within this direction]

Reason: [why]
```

If PIVOT: the next iteration takes a meaningfully different approach
(not just tweaking — rethink a section's layout or typography).

If REFINE: the next iteration continues polishing the current approach.

#### Progressive fix exploration (from Agent 5's battle-tested pattern)

If a fix doesn't work on first attempt, explore WIDER on subsequent tries:

- **Attempt 1:** Fix with initial assumption (the obvious CSS change)
- **Attempt 2:** Explore wider — check parent components, global styles,
  layout wrappers, CSS specificity conflicts
- **Attempt 3:** Deep investigation — z-index stacking, inheritance,
  build compilation, framework-specific quirks

Don't repeat the same failed fix. The problem is often not where you first looked.

#### Reduce filter (apply after each iteration)

Before committing, review all changes and ask: "Did I add visual complexity?"
Cut anything that adds elements without simplifying the user experience.

#### 4-8. Freeze this iteration as a live URL

Each refine iteration gets its own URL for side-by-side comparison:

```bash
# Copy the current finalist state to a frozen snapshot
cp -r {FINALIST_COMPONENT_DIR} {FINALIST_COMPONENT_DIR}-r{N}
mkdir -p src/routes/{ROUTE_PREFIX}-{F}r{N}
# Create route file importing from the frozen copy
# e.g. /p3-Ar1/ = Finalist A, refine iteration 1
```

Write a route file at `src/routes/{ROUTE_PREFIX}-{F}r{N}/$slug.tsx` importing
from the frozen component folder.

**Result:** Every refine iteration has its own live URL:
- `/p3-Ar1/acme-2026-abc1` — Finalist A, refine 1
- `/p3-Ar2/acme-2026-abc1` — Finalist A, refine 2
- `/p3-Ar3/acme-2026-abc1` — Finalist A, refine 3
- `/p3-Cr1/acme-2026-abc1` — Finalist C, refine 1
- etc.

#### 4-9. Commit

```bash
git add {FINALIST_COMPONENT_DIR} {FINALIST_COMPONENT_DIR}-r{N} \
  src/routes/{ROUTE_PREFIX}-{F}r{N}/ design-iterations/ agents/doing/diamond-{slug}.md
git commit -m "$(cat <<'EOF'
design-refine-{F}{N}: [summary] — [REFINE or PIVOT]

Sprint contract: [all pass / X of Y pass]
Gemini score: [X]/10
Live URL: /{ROUTE_PREFIX}-{F}r{N}/{SLUG}

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

**Repeat 3 times for each finalist (6 iterations total).**

**Context reset:** Between finishing Finalist 1's 3 iterations and starting
Finalist 2's, write a summary of Finalist 1's state to file and allow
context compaction.

**Update agents/doing/diamond-{slug}.md after all 6:**
```
- Phase: 4 — Refine
- Step: Complete — both finalists refined (3 iterations each)
- Finalist 1 scores: [iter1], [iter2], [iter3]
- Finalist 2 scores: [iter1], [iter2], [iter3]
```

---

## Phase 5: CONVERGE (pick the winner)

**Goal:** Head-to-head comparison of the 2 refined finalists using
triple-model analysis (same pattern as /deeper).

### 5a. Screenshot both finalists

Take final screenshots of both refined finalists at multiple viewports:
- Desktop (1440×900)
- Mobile (375×812)

### 5b. Triple-model comparison

Send **identical prompt** to all 3 models:

**The prompt:**
```
You are judging a design competition between two versions of a [PAGE TYPE].
Both are fully functional — this is purely a visual/UX comparison.

FINALIST 1: [Direction name] — [one-line description]
FINALIST 2: [Direction name] — [one-line description]

SCORING RUBRIC:
1. Design quality (coherence, mood, identity) — /10
2. Originality (custom decisions vs templates) — /10
3. Craft (typography, spacing, contrast, grids) — /10
4. Functionality (readability, scannability, CTAs) — /10

For each finalist, score all 4 criteria with evidence.
Then declare a WINNER with clear reasoning.
If it's genuinely too close to call, say so and explain what would break the tie.
```

**Claude (inline):** Read both screenshots, score and pick.

**Gemini:**
```
mcp__aistudio__generate_content({
  user_prompt: "{THE PROMPT}",
  files: [
    { path: "design-iterations/finalist1-final-desktop.png" },
    { path: "design-iterations/finalist2-final-desktop.png" },
    ...referenceImages
  ],
  model: "gemini-3.1-pro-preview"
})
```

**Codex:**
```
mcp__codex-cli__codex({
  prompt: "{THE PROMPT}\n\n[Finalists described in text — Codex can't see images]",
  model: "gpt-5.4"
})
```

### 5c. Synthesize winner

Apply the /deeper convergence rules:

**Triple convergence (all 3 pick same winner):**
→ Highest confidence. That's the winner.

**Double convergence (2 agree, 1 dissents):**
→ Go with the majority. Note the dissent and its reasoning.

**All diverge:**
→ Flag for human decision. Present all 3 perspectives.

Write to `design-iterations/phase-5-winner.md`:

```markdown
# Winner Selection

| Model | Winner | Reasoning |
|-------|--------|-----------|
| Claude | Finalist [X] | [reason] |
| Gemini | Finalist [X] | [reason] |
| Codex | Finalist [Y] | [reason] |

**Convergence:** [Triple / Double / Diverged]
**Winner:** Finalist [X] — Direction [name]
**Dissent:** [If any — what the dissenting model valued differently]
```

### 5d. Promote the winner

Copy the winning finalist's components to the main component directory:

```bash
# Back up current main components
cp -r {TARGET_COMPONENT_DIR} {TARGET_COMPONENT_DIR}-backup

# Copy winner to main
cp -r {WINNER_COMPONENT_DIR}/* {TARGET_COMPONENT_DIR}/
```

The main URL now shows the winning design.

**Update agents/doing/diamond-{slug}.md:**
```
- Phase: 5 — Converge
- Step: Complete — winner selected
- Winner: Direction [X] — [name]
- Convergence: [Triple/Double/Diverged]
```

---

## Phase 6: POLISH (3 final iterations)

**Goal:** Pixel-perfect refinement of the winner. Small, precise changes.
Hard quality threshold — stop early if quality plateaus.

### Stopping conditions
- Stop if 2 consecutive iterations score 9+ on all 4 criteria
- Stop if an iteration REGRESSES (revert and stop)
- Maximum 3 iterations

### For each polish iteration:

Use the same loop as Phase 4 iterations (screenshot → Gemini critique →
sprint contract → Gemini code review → implement → verify → commit),
but with tighter constraints:

- Sprint contracts must be smaller (2-3 criteria, not 5)
- Changes must be CSS/Tailwind only (no layout restructuring)
- No pivots — only refine
- Hard threshold: weighted score must stay ≥ 9.0/10

### Weighted Quality Gate (from Agent 5 — battle-tested over 200+ runs)

Switch from the Phase 2-3 rubric to the weighted quality gate for polish:

```
mcp__aistudio__generate_content({
  user_prompt: `VISUAL QUALITY GATE — score this page against existing app pages.

IMAGE 1: The page being scored
IMAGE 2-3: Existing approved pages from this app (PRIMARY REFERENCE — 70% weight)

SCORING (respond in JSON):
{
  "existing_page_match": [1-10],  // Weight: 40% — Does it look like the same app?
  "corners_borders": [1-10],     // Weight: 25% — Same radius, shadows, borders?
  "colors": [1-10],              // Weight: 15% — Button/accent colors match?
  "typography": [1-10],          // Weight: 10% — Same fonts, sizes, weights?
  "layout_spacing": [1-10],     // Weight: 10% — Same gaps, padding, max-width?
  "weighted_total": [calculated],
  "verdict": "PASS or FAIL (pass ≥ 9.0)",
  "issues": [{ "category": "...", "severity": "critical|major|minor",
               "description": "...", "tailwind_fix": "..." }]
}

AUTO-FAIL (-2 to category): card radius differs, shadow treatment differs,
button colors don't match design system, visually jarring difference.

Be STRICT. Existing pages are the gold standard.`,
  files: [
    { path: "design-iterations/polish-v{N}-desktop.png" },
    { path: "agents/page-references/{relevant-page-1}.png" },
    { path: "agents/page-references/{relevant-page-2}.png" }
  ],
  model: "gemini-3.1-pro-preview"
})
```

If FAIL: fix top 3 issues (sorted by severity), re-screenshot, re-score.
Maximum 3 attempts per polish iteration before moving on.

### After each polish iteration, also freeze a live URL:

```bash
cp -r {TARGET_COMPONENT_DIR} {TARGET_COMPONENT_DIR}-final-v{N}
mkdir -p src/routes/{ROUTE_PREFIX}-final-v{N}
# Create route file importing from the frozen copy
```

This lets you compare polish iterations side by side.

### Commit each polish iteration:

```bash
git add {TARGET_COMPONENT_DIR} {FROZEN_COPIES} design-iterations/ agents/doing/diamond-{slug}.md
git commit -m "$(cat <<'EOF'
design-polish-v{N}: [summary]

Sprint contract: all pass
Scores: Design={X}, Originality={X}, Craft={X}, Function={X}
Live URL: /{ROUTE_PREFIX}-final-v{N}/{SLUG}

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## After all phases complete

### 1. Create comparison summary

Write `design-iterations/summary.md`:

```markdown
# Design Iteration Summary

## Process
- **Directions explored:** 5
- **Finalists refined:** 2
- **Winner:** Direction [X] — [name]
- **Total iterations:** [N]
- **Convergence:** [Triple/Double/Diverged]

## All directions compared
| Direction | Design | Originality | Craft | Function | Total | Status |
|-----------|--------|-------------|-------|----------|-------|--------|
| A: [name] | X | X | X | X | XX | Eliminated Phase 3 |
| B: [name] | X | X | X | X | XX | Finalist, eliminated Phase 5 |
| ...

## Live URLs (every iteration has its own — open in browser tabs to compare)

### Phase 2: Diverge (5 directions)
- Direction A: /{ROUTE}-dirA/{SLUG}
- Direction B: /{ROUTE}-dirB/{SLUG}
- Direction C: /{ROUTE}-dirC/{SLUG}
- Direction D: /{ROUTE}-dirD/{SLUG}
- Direction E: /{ROUTE}-dirE/{SLUG}

### Phase 4: Refine (3 iterations × 2 finalists)
- Finalist A refine 1: /{ROUTE}-Ar1/{SLUG}
- Finalist A refine 2: /{ROUTE}-Ar2/{SLUG}
- Finalist A refine 3: /{ROUTE}-Ar3/{SLUG}
- Finalist C refine 1: /{ROUTE}-Cr1/{SLUG}
- Finalist C refine 2: /{ROUTE}-Cr2/{SLUG}
- Finalist C refine 3: /{ROUTE}-Cr3/{SLUG}

### Phase 6: Polish (3 final iterations)
- Polish v1: /{ROUTE}-final-v1/{SLUG}
- Polish v2: /{ROUTE}-final-v2/{SLUG}
- Polish v3: /{ROUTE}-final-v3/{SLUG}

### Winner
- **Winner (latest):** /{ROUTE}/{SLUG}

## Files modified
[list of component files]

## Cleanup command
rm -rf {TARGET_COMPONENT_DIR}-dir*/ {TARGET_COMPONENT_DIR}-backup/
rm -rf {TARGET_COMPONENT_DIR}-final-*/ src/routes/{ROUTE}-dir*/
rm -rf src/routes/{ROUTE}-final-*/
```

### 2. Update agents/doing/diamond-{slug}.md to show all phases complete

### 3. Tell the user

Report:
- The winning direction and why it won
- All live URLs for comparison (open in browser tabs)
- Final scores on all 4 criteria
- The cleanup command when they're done comparing

---

## Design Reference (adapt per project)

These are discovered in Phase 0, not hardcoded. But here are the
patterns the harness looks for:

### What to extract from project context
- **Colour palette** — primary, secondary, background, text colours
- **Typography** — heading font, body font, size scale
- **Spacing** — section spacing, content max-width, padding
- **Border style** — rounded vs sharp, border colours, shadow usage
- **Photography** — available images, how they're used
- **Brand** — logo, tone, personality
- **Component patterns** — cards vs lines, grids vs lists, hover states

### Design Authority Hierarchy (CRITICAL — from 200+ agent runs)

When Gemini suggests CSS/layout and it conflicts with existing code, follow this:

| Priority | Source | Authority |
|----------|--------|-----------|
| 1 (Highest) | **User's explicit instructions** | Can intentionally break design system |
| 2 | **Project design system / brand guide** | Defines the rules |
| 3 | **Existing codebase components** (actual CSS) | Establishes implemented patterns |
| 4 (Lowest) | **Gemini's visual analysis** | Suggestions only — override when conflicting |

**Example:** Gemini suggests `rounded-lg` corners. Existing components use `rounded-none`.
→ Use `rounded-none`. Gemini is overridden.

Document overrides: `**Gemini Override**: Suggested rounded-lg but using sharp corners per codebase`

### Gemini MCP File Type Restrictions (hard-learned)

- **Images (PNG, JPG):** ✅ Send as file attachments
- **TSX/TS code files:** ❌ DO NOT send — causes errors or unpredictable behavior
- **Markdown files (.md):** ❌ DO NOT send — causes MIME type errors
- **Instead:** Read code files with Read tool, embed relevant snippets in `user_prompt`

### Reduce Filter (apply after every analysis phase)

After collecting ALL recommendations from any analysis step, explicitly filter:

For each recommendation ask: **"Am I adding UI complexity to follow this?"**
- If it ADDS visual elements → REMOVE IT
- If it SIMPLIFIES what user sees → KEEP IT
- If it's neutral → REMOVE IT

This prevents scope creep across iterations. Applied after Phase 1 merge,
Phase 4 sprint contracts, and Phase 6 polish.

### Scoring criteria (adapt per page type)

| Page type | Emphasise | De-emphasise |
|-----------|-----------|--------------|
| Landing/marketing | Design quality, originality | Functionality |
| Dashboard/tool | Functionality, craft | Originality |
| Proposal/sales | Design quality, functionality | — |
| Documentation | Craft, functionality | Originality |
| E-commerce | Functionality, craft | — |

---

## Files Reference

| File | Purpose |
|------|---------|
| `agents/design-diamond.md` | This file — the harness process definition |
| `agents/doing/diamond-{slug}.md` | **Read first** — current phase, step, and recovery state |
| `design-iterations/phase-0-context.md` | Project context, scoring rubric |
| `design-iterations/phase-1-directions.md` | 5 visual directions from triple-model |
| `design-iterations/phase-3-selection.md` | Direction scores, finalist selection |
| `design-iterations/phase-5-winner.md` | Head-to-head winner selection |
| `design-iterations/summary.md` | Final comparison of all directions |
| `design-iterations/changelog.md` | Running log of all iterations |
| `design-iterations/*.png` | Screenshots at each stage |

---

## Appendix: MCP Tool Reference

### Gemini (evaluator + code reviewer)
```
mcp__aistudio__generate_content({
  user_prompt: "...",
  files: [{ path: "..." }],
  model: "gemini-3.1-pro-preview"
})
```

### Codex/OpenAI (direction discovery + convergence)
```
mcp__codex-cli__codex({
  prompt: "...",
  model: "gpt-5.4"
})
```

### Playwright (screenshots)
```bash
npx playwright screenshot \
  --viewport-size=1440,900 \
  --full-page \
  --wait-for-timeout=5000 \
  "{URL}" \
  "{OUTPUT_PATH}"
```

### Screenshots via Playwright MCP (hover/interaction testing)
```
mcp__playwright__browser_navigate({ url: "..." })
mcp__playwright__browser_take_screenshot({})
mcp__playwright__browser_hover({ element: "..." })
mcp__playwright__browser_resize({ width: 375, height: 812 })
```
