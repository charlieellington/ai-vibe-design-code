# Design Agents Flow

A structured 7-agent workflow for transforming AI-assisted UI development from chaotic and error-prone into predictable and reliable. This system preserves context across development sessions and produces pixel-perfect code implementations directly from design specifications.

## The Problem This Solves

AI-assisted development suffers from "AI amnesia" - research shows each handoff loses 15-30% of contextual understanding. This compounds into significant productivity loss:

- Simple changes that should take minutes end up taking hours
- Context gets lost during handoffs between sessions
- No way to monitor AI code changes in real-time
- Duplicate components get created because agents don't know what exists

## The 7-Agent Workflow

| Agent | Name | Purpose |
|-------|------|---------|
| **0** | Quick Change | Evaluates if changes are truly simple (padding, colors, text). Implements immediately or escalates. Handles ~90% of routine tasks. |
| **1** | Planning | Gathers requirements, integrates with Figma MCP for exact specs, creates detailed implementation plans. |
| **2** | Review | Quality checkpoint - validates plans for completeness, catches ambiguities before coding begins. |
| **3** | Discovery | Identifies exact files and components to modify, maps dependencies, prevents duplicate creation. |
| **4** | Execution | Implements changes with surgical precision, preserves all existing functionality. |
| **5** | Visual Verification | Captures screenshots across breakpoints, compares against specs, detects visual regressions. |
| **6** | Completion | Documents what was built, updates knowledge base, captures reusable patterns. |
| **7** | Fix | Emergency bug fix agent for post-completion issues. |

## Directory Structure

```
design-agents-flow/
├── design-0-quick.md          # Quick change assessment agent
├── design-1-planning.md       # Planning & context capture agent
├── design-2-review.md         # Review & validation agent
├── design-3-discovery.md      # Discovery & analysis agent
├── design-4-execution.md      # Code execution agent
├── design-5-visual-verification.md  # Visual testing agent
├── design-6-complete.md       # Completion & documentation agent
├── design-7-fix.md            # Bug fix agent
├── status.md                  # Kanban board (Obsidian plugin compatible)
├── status-details.md          # Deprecated - see task files
├── doing/                     # Active tasks in progress
├── done/                      # Completed task documentation
├── misc/
│   ├── shadcn_rules.mdc      # shadcn/ui component best practices
│   └── tailwind_rules.mdc    # Tailwind CSS v4 style guide
└── setup-parallel-dev.sh      # Parallel development setup script
```

## Getting Started

### Prerequisites

- **Cursor IDE** with MCP support, OR
- **Conductor** (Mac app for parallel AI agents)
- **Figma API access** (optional, for design-to-code workflow)
- **Obsidian** with Kanban plugin (optional, for status tracking)

### Setup with Cursor

1. **Clone the repository:**
   ```bash
   git clone https://github.com/charlieellington/ai-vibe-design-code.git
   ```

2. **Copy agent files to your project:**
   Copy the `design-*.md` files to your project's documentation folder (e.g., `documentation/design-agents-flow/`).

3. **Configure MCP servers** (optional):
   - Figma MCP for design spec extraction
   - Filesystem MCP for code access

4. **Set up parallel development environments:**
   ```bash
   ./setup-parallel-dev.sh
   ```
   This creates:
   - `localhost:3000` - Stable reference version
   - `localhost:3001` - Active development version

5. **Start using agents:**
   Tag the appropriate agent in Cursor with your requirements:
   ```
   @design-0-quick Change the button color from blue to green
   ```

### Setup with Conductor

1. **Clone the repository** into your Conductor workspace:
   ```bash
   git clone https://github.com/charlieellington/ai-vibe-design-code.git .conductor/design-agents
   ```

2. **Configure your workspace:**
   The agent files are automatically available to all workspaces.

3. **Create parallel workspaces:**
   - One workspace for planning/review (Agents 0-3)
   - One workspace for execution (Agent 4)
   - One workspace for verification (Agents 5-6)

4. **Use the kanban board:**
   Open `status.md` in Obsidian to track task progress across the workflow stages.

## How to Use the Workflow

### For Simple Changes (Agent 0)

Most routine tasks (button color, padding, text updates) go through Agent 0:

```
@design-0-quick Update the header padding from 16px to 24px
```

Agent 0 either implements immediately or escalates to the full workflow.

### For Complex Features (Agents 1-6)

1. **Planning (Agent 1):** Provide design specs, Figma links, or screenshots
2. **Review (Agent 2):** Validates the plan, asks clarifying questions
3. **Discovery (Agent 3):** Maps existing code and dependencies
4. **Execution (Agent 4):** Implements with full context
5. **Verification (Agent 5):** Screenshots and visual comparison
6. **Completion (Agent 6):** Documents and archives

### Tracking Progress

Use `status.md` as a kanban board:

- **Backlog** - Features waiting to be planned
- **Planning (Design-1)** - Currently being planned
- **Review (Design-2)** - Under review
- **Discovery (Design-3)** - Technical discovery
- **Ready to Execute** - Approved and ready
- **Execution (Design-4)** - Being implemented
- **Testing** - Manual testing
- **Visual Verification (Design-5)** - Visual QA
- **Complete (Design-6)** - Done

## Task File Format

When a task completes, create a file in `done/` with:

```markdown
# Task Title

## Original Request
[What was requested]

## Design Context
[Visual consistency rules, color tokens, etc.]

## Implementation Notes
- Files created/modified
- Dependencies added
- Testing notes

## Completion Date
YYYY-MM-DD
```

## Performance Benefits

| Metric | Before | After |
|--------|--------|-------|
| Simple button moves | 2-3 hours | 5-10 minutes |
| Component integration | 5-6 attempts | Single pass |
| Design compliance | Variable | 95%+ accuracy |
| Context preservation | Degrades | 100% maintained |

## Cost Optimization

The workflow uses model selection cascading:

- **Agent 0 (Quick):** Lightweight model (70-80% cost reduction)
- **Agents 1-3 (Planning):** Medium model
- **Agent 4 (Execution):** Claude 3.5 Sonnet for complex work
- **Agents 5-6 (Verification):** Medium model

Prompt caching reduces token costs by 75-90% for repeated patterns.

## Reference Documentation

- `misc/shadcn_rules.mdc` - Component composition best practices for shadcn/ui
- `misc/tailwind_rules.mdc` - Tailwind CSS v4 style guide and conventions

## Contributing

When updating the agents:

1. Test changes in a real project first
2. Document new patterns in the appropriate agent file
3. Update this README if the workflow changes
4. Keep agent files under 250 lines each

## License

MIT
