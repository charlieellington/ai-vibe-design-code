# UI Component Library Reference

Reference document for design agents. Establishes the component library hierarchy for the project.

---

## Component Library Hierarchy

**IMPORTANT**: Follow this order when choosing components:

### Tier 1: shadcn/ui (PRIMARY)
**URL**: https://ui.shadcn.com/

**Use for**: All standard UI components — buttons, cards, forms, dialogs, tables, navigation, etc.

This is the foundation. Use shadcn/ui first for everything. Only look to other libraries when shadcn doesn't cover your specific need.

### Tier 2: AI SDK Elements + React Flow
**URLs**:
- https://ai-sdk.dev/elements/examples/chatbot
- https://ai-sdk.dev/elements/examples/workflow
- https://reactflow.dev/

**Use for**: AI-specific UI patterns that shadcn doesn't provide.

### Tier 3: UI Particles (Supplementary)
**Use for**: Specialized components when Tier 1 and Tier 2 don't cover the use case.

---

## Tier 1: shadcn/ui — Primary Component Library

**Always check shadcn first.** It covers:
- Buttons, inputs, forms
- Cards, dialogs, sheets
- Tables, data display
- Navigation, tabs, menus
- Toast notifications
- And much more

**Installation**: `npx shadcn@latest add [component]`

**Documentation**: https://ui.shadcn.com/docs/components

---

## Tier 2: AI-Specific Components

### AI SDK Elements — Chatbot
**URL**: https://ai-sdk.dev/elements/examples/chatbot

**What it provides**:
- **Conversation & Messages**: Auto-scrolling message container
- **Prompt Input**: Textarea with file attachments, model selection
- **Message Display**: Text responses, reasoning visualization, citations
- **Sources Component**: View citations/sources used in responses
- **Reasoning Component**: Collapsible AI thought process display

**Key Features**:
- Multi-model support (model picker)
- Web search integration with citations
- File attachment handling
- Streaming support for real-time responses
- Reasoning transparency

**Use Cases**:
- Chat interfaces
- Any conversational AI interaction
- Citation display in chat responses

---

### AI SDK Elements — Workflow + React Flow
**URLs**:
- https://ai-sdk.dev/elements/examples/workflow
- https://reactflow.dev/

**What it provides**:
- **Canvas**: React Flow-based node interface
- **Node System**: NodeHeader, NodeTitle, NodeDescription, NodeContent, NodeFooter
- **Edge Types**: Animated flows, temporary connections
- **Connection**: Custom bezier curve styling
- **Controls**: Zoom, fit-view
- **Toolbar**: Context-specific node actions

**Key Features**:
- Structured node layouts with compound components
- Contextual toolbars for node interactions
- Configurable source/target handles
- Multiple edge visualization types
- Automatic canvas fitting with pan/zoom

**Use Cases**:
- Workflow/pipeline visualisation
- Agent visualisation
- Any node-based diagram

---

## Tier 3: UI Particles — Supplementary Components

**Only use these when shadcn/ui and AI SDK don't cover your need.**

### Quick Decision Matrix

| If shadcn doesn't have... | Consider this supplement |
|---------------------------|-------------------------|
| RAG-style citations with snippets | Tool-UI Citation |
| Step-by-step progress display | Tool-UI Plan |
| Specialized AI loading animation | KokonutUI AI Loading |
| Morphing animated popovers | Motion Primitives |
| Full-screen morphing overlays | Cult-UI Expandable Screen |
| Marketing page blocks | Tailark |

---

### Tool-UI Citation
**URL**: https://www.tool-ui.com/docs/citation

**What it does**: Citation component for RAG applications with source attribution.

**Features**:
- Source attribution: title, domain, author, date
- Snippet preview
- Three variants: default card, inline chips, stacked favicons
- Keyboard accessible

**Consider for**: Citation/source panels, inline citation chips — *but check if AI SDK Sources component covers your need first*

---

### Tool-UI Plan
**URL**: https://www.tool-ui.com/docs/plan

**What it does**: Step-by-step task/progress display.

**Features**:
- Progress bar with "X of Y complete"
- Status indicators: pending, in_progress, completed, cancelled
- Expandable details per step
- Celebration state on completion

**Consider for**: Progress displays — *but check if shadcn Progress or a simple custom component covers your need first*

---

### KokonutUI AI Loading
**URL**: https://kokonutui.com/docs/components/ai-loading

**What it does**: Visual loading indicator for AI operations.

**Features**:
- SVG-based rotating animations
- Staggered timing for layered effect

**Consider for**: AI processing states — *but a simple shadcn Skeleton or spinner might suffice*

---

### Motion Primitives Morphing Popover
**URL**: https://motion-primitives.com/docs/morphing-popover

**What it does**: Animated popover that morphs from trigger.

**Features**:
- Layout animation-based transformation
- Customizable spring physics
- Keyboard support

**Consider for**: Fancy compact interactions — *but shadcn Popover covers most cases*

---

### Cult-UI Expandable Screen
**URL**: https://www.cult-ui.com/docs/components/expandable-screen

**What it does**: Full-screen morphing overlays.

**Features**:
- Morphing animation from trigger to full-screen
- Framer Motion layoutId transitions
- Scroll locking

**Consider for**: Dramatic modal entrances — *but shadcn Dialog/Sheet covers most cases*

---

### Tailark
**URL**: https://tailark.com/

**What it does**: Marketing website blocks built on shadcn.

**Consider for**: Landing/marketing pages only — *not relevant for the main app UI*

---

## How Agents Should Use This

### Agent 1 (Planning)
When creating a task plan:
1. **Default to shadcn/ui** for all standard components
2. **Use AI SDK Elements** for chat interfaces and workflow graphs
3. **Only mention Tier 3 particles** if there's a specific gap shadcn doesn't fill

### Agent 2 (Review)
When reviewing a task plan:
1. Verify shadcn/ui is the default choice
2. Check AI SDK is used for AI-specific patterns
3. If Tier 3 particle is suggested, verify shadcn doesn't already cover it
4. Flag if plan over-relies on particles when shadcn would work

---

## Common Component Mapping

| Component Type | Recommended Approach |
|----------------|---------------------|
| Buttons, Cards, Forms | shadcn/ui (Tier 1) |
| Tables, Data Display | shadcn/ui (Tier 1) |
| Navigation, Sidebar | shadcn/ui (Tier 1) |
| Dialogs, Sheets | shadcn/ui (Tier 1) |
| Chat Interface | AI SDK Elements Chatbot (Tier 2) |
| Workflow/Node Graph | AI SDK Elements Workflow + React Flow (Tier 2) |
| Citation/Source Panel | AI SDK Sources OR Tool-UI Citation (evaluate both) |
| Inline Citation Chip | AI SDK Sources OR Tool-UI Citation (evaluate both) |
| Progress Display | shadcn Progress OR Tool-UI Plan (evaluate) |
| AI Processing indicator | shadcn Skeleton/Spinner OR KokonutUI (if fancy needed) |

Check `project-context.md` or scan the codebase for project-specific component patterns.

---

*Last updated: 2026-02-15*
