# Design-Forward Development Documentation

## 🎯 Overview

This documentation system provides a comprehensive, design-forward development workflow for any Next.js project. Built around a 6-agent system for structured feature development, parallel development environments, and proven design patterns.

**Perfect for:** Portfolio sites, SaaS applications, marketing sites, and any Next.js project requiring systematic feature development.

**Key Benefits:**
- 🚀 **Rapid Development**: Parallel stable/active environments prevent debugging delays
- 🎨 **Design-Forward**: Built-in design system compliance and visual reference workflows
- 📋 **Systematic**: 6-agent workflow ensures quality at every stage
- 🔄 **Reusable**: Documentation system designed to import into any project

## 📁 Documentation Structure

```
documentation/
├── README.md                    # This file - complete system overview
├── CONTRIBUTING.md              # Project contribution guidelines
├── scratchpad.md               # Current project status and notes
└── design-agents-flow/         # Core workflow system
    ├── PARALLEL-DEV-SETUP.md   # Universal parallel development guide
    ├── setup-parallel-dev.sh   # 🆕 Auto-setup script for any project
    ├── 1-design-planning.md     # Agent 1: Planning & Analysis
    ├── 2-design-review.md       # Agent 2: Quality Assurance
    ├── 3-design-discovery.md         # Agent 3: Technical Research
    ├── 4-design-execution.md         # Agent 4: Implementation
    ├── 5-design-visual-verification.md # Agent 5: Visual Verification
    ├── 6-design-complete.md          # Agent 6: Finalization
    ├── status.md               # Kanban task board
    ├── status-details.md       # Deprecated (now uses individual files)
    ├── doing/                  # Active task files
    ├── done/                   # Completed task files
    └── misc/
        ├── tailwind_rules.mdc  # Tailwind CSS v4 best practices
        └── shadcn_rules.mdc    # Component composition patterns
```

## 📋 System Components

### 🚀 **Quick Setup** - [design-agents-flow/PARALLEL-DEV-SETUP.md](design-agents-flow/PARALLEL-DEV-SETUP.md)
**Universal parallel development setup for any React project.**
- **Auto-setup script**: One command setup with automatic detection
- **Multi-framework support**: Next.js, Vite, Create React App, and more
- **All package managers**: npm, pnpm, yarn, bun automatically detected
- **Environment handling**: Copies all .env files correctly
- **Framework-specific**: Handles different port configurations
- **Complete troubleshooting**: Covers all common setup issues

### 1. **status.md** - Visual Kanban Board (Obsidian)
The main task management board with these columns:
- **Planning** - Initial task conception and high-level planning
- **Review** - Detailed review and validation of plans  
- **Discovery** - Technical research and implementation strategy
- **Ready to Execute** - Validated tasks ready for implementation
- **Executing** - Tasks currently being worked on
- **Testing** - Tasks in testing/validation phase
- **Complete** - Completed tasks for current feature
- **Archived Features** - Tasks from previous completed features

**Renders as visual kanban board in Obsidian with drag-and-drop task management.**

### 2. **Individual Task Files** (`doing/` and `done/` folders)
Each task gets its own file with comprehensive documentation:
- **doing/[task-slug].md** - Tasks in progress
- **done/[task-slug].md** - Completed tasks
- Each file contains: Original Request, Design Context, Codebase Context, Plan, Stage, Priority, Questions, Review Notes
- File naming: Convert task titles to kebab-case (e.g., "Create Welcome Card" → `create-welcome-card.md`)
- Agent 6 moves files from `doing/` to `done/` when complete

### 3. **Design System Rules** (`misc/` folder)
- **tailwind_rules.mdc** - Comprehensive Tailwind CSS v4 best practices, updated for modern development
- **shadcn_rules.mdc** - Component composition patterns and accessibility guidelines
- Both files include MCP tool integration for automated component research

### 4. **Project Management**
- **CONTRIBUTING.md** - Project-specific contribution guidelines and coding standards
- **scratchpad.md** - Living document tracking current project status, recent changes, and next steps


## 🔄 The 6-Agent Workflow

### Agent 1: **Planning** (`@1-design-planning.md`)
- **Role**: Initial analysis and comprehensive planning
- **Input**: Direct user request for new feature or enhancement
- **Output**: Detailed implementation plan
- **Updates**: Creates entry in status-details.md, adds task to Planning column
- **Key**: Always end with "Plan complete. Ready for review stage."

### Agent 2: **Review** (`@2-design-review.md`) 
- **Role**: Validation and quality assurance of plans with visual alignment check
- **Input**: Planned tasks from Agent 1
- **Critical Question**: "Is there anything I need to know to be 100% confident to execute this?"
- **Output**: Validated plan ready for discovery, or clarification questions
- **Updates**: Moves task to Review column, adds review notes
- **Rule**: Never runs terminal commands unless absolutely necessary

### Agent 3: **Discovery** (`@3-design-discovery.md`)
- **Role**: Technical research and implementation strategy with MCP tools
- **Input**: Reviewed plans from Agent 2
- **Output**: Detailed technical approach with component analysis
- **Updates**: Moves task to Discovery column, adds technical context
- **Focus**: Component research, integration patterns, technical feasibility

### Agent 4: **Execution** (`@4-design-execution.md`)
- **Role**: Implementation and development with visual reference compliance
- **Input**: Discovered tasks from Agent 3
- **Output**: Working code implementation
- **Updates**: Moves through Executing → Testing → Complete
- **Process**: Implements based on visual references, documents visual decisions, tests

### Agent 5: **Visual Verification** (`@5-design-visual-verification.md`)
- **Role**: Automated visual testing and refinement
- **Input**: Completed implementation from Agent 4
- **Output**: Visual verification report with screenshots, minor visual fixes
- **Process**: Uses Playwright MCP to capture screenshots, analyze visual quality, fix minor issues
- **Key**: Catches visual bugs before manual testing begins

### Agent 6: **Complete** (`@6-design-complete.md`)
- **Role**: Final documentation, system updates, and agent improvement
- **Input**: Tested implementations from manual testing
- **Output**: Updated documentation, rules, and system improvements
- **Updates**: Finalizes task in Complete column, updates relevant documentation
- **Key**: Analyzes entire workflow to improve all agents for future tasks

## 🚀 Starting a New Feature - Quick Start

### Usage Pattern

**Direct Agent 1 Call**
```
@1-design-planning.md Add a new portfolio section for case studies
```
- Agent reads user request directly from chat
- Creates detailed plan and adds to kanban board
- Works with any Next.js project - just adapt the request to your needs

### Starting Development

1. **Create your feature branch**:
   ```bash
   git checkout -b feature/portfolio-enhancement
   ```

2. **Set up parallel development** (see design-agents-flow/PARALLEL-DEV-SETUP.md)

3. **Start with Agent 1**:
   ```
   @1-design-planning.md [Your feature request]
   ```
   Agent 1 creates: `doing/your-feature-request.md`

4. **Follow the agent flow**:
   - Planning → Review → Discovery → Execution → Visual Verification → Testing → Complete
   - Each agent updates the same task file in `doing/` folder
   - Agent 6 moves completed file to `done/` folder

## 📝 Individual Task File Structure

Each task file in `doing/` or `done/` folder follows this structure:

```markdown
## [Task Name]

### Original Request
[User's request]

### Plan
[Implementation steps]

### Stage
[Current stage: Planning/Review/Discovery/Executing/Visual Verification/Testing/Complete]

### Priority
[High/Medium/Low]

### Created
[Timestamp]
```

## 🔧 Best Practices

### Task Management
- Always update kanban position when agents transition tasks
- Keep tasks focused and atomic (1 task = 1 specific outcome)
- Use consistent naming conventions for tasks
- Add dates to completed features for historical tracking

### Agent Workflow
- Each agent should **only work within their designated role**
- Always reference previous agent's work before proceeding
- Update the kanban board position when passing tasks forward
- End agent responses with clear next steps or completion status

### Feature Transitions
- Move completed tasks to Archived Features column
- Keep focus on current active development
- Document key learnings in agent files

### Documentation
- Keep individual task files focused and well-organized
- Use consistent markdown formatting across all documents
- Link between related tasks and components
- Archive completed tasks in the `done/` folder for easy reference

## 📚 Getting Started with Any Project

### 1. Import This Documentation
```bash
# Copy the entire documentation folder to your project
cp -r /path/to/zebra-design/documentation /path/to/your-project/
```

### 2. Set Up Parallel Development (Choose One)

**Option A: Auto-Setup (Recommended)**
```bash
# Run the auto-setup script from your project root
./documentation/design-agents-flow/setup-parallel-dev.sh
```
- Automatically detects package manager and framework
- Sets up everything with one command
- Provides exact package.json scripts to add

**Option B: Manual Setup**
1. **Follow PARALLEL-DEV-SETUP.md**:
   - Replace `{PROJECT_NAME}` with your project name
   - Replace `{GITHUB_URL}` with your repository URL
   - Update package.json scripts for your package manager

### 3. Customize Project-Specific Files
1. **Update CONTRIBUTING.md**:
   - Adapt coding standards to your project
   - Update any project-specific requirements

2. **Update scratchpad.md**:
   - Document your current project status
   - Track your feature development progress

3. **Adapt rule files** (misc/ folder):
   - Customize tailwind_rules.mdc for your design system
   - Adapt shadcn_rules.mdc if using different UI components

### 4. Set Up Visual Kanban (Recommended)

**Install Obsidian and Kanban Plugin:**
1. **Download Obsidian**: [https://obsidian.md](https://obsidian.md)
2. **Open your documentation folder** as an Obsidian vault
3. **Install Kanban plugin**:
   - Settings → Community plugins → Browse
   - Search for "Kanban" by mgmeyers
   - Install and enable the plugin
4. **Open status.md** - it will automatically render as a kanban board

**Why Obsidian + Kanban?**
- 🎯 **Visual task management**: See all tasks across pipeline stages at once
- 🚀 **Drag-and-drop**: Move tasks between columns visually  
- 📱 **Cross-platform sync**: Work on desktop, mobile, anywhere
- 🔗 **Linked notes**: Click task titles to open individual task files
- 📊 **Progress tracking**: Visual indication of workflow bottlenecks
- 🤝 **Team collaboration**: Share visual progress with stakeholders

### 5. Start Developing
```bash
# Set up parallel development (auto-setup script)
./documentation/design-agents-flow/setup-parallel-dev.sh

# OR manual setup (follow PARALLEL-DEV-SETUP.md)

# Start your first feature
@1-design-planning.md [Your first feature request]
```

## 📋 Visual Workflow Management with Obsidian

### Why Obsidian + Kanban Plugin?

**The Problem:** Traditional task management tools don't integrate well with technical documentation and lose context between planning and execution.

**The Solution:** Obsidian + Kanban plugin provides:

1. **🎯 Visual Pipeline Management**
   - See all tasks across 8 stages at once
   - Instantly identify bottlenecks and blocked tasks
   - Drag-and-drop tasks between stages visually

2. **🔗 Linked Documentation** 
   - Task titles in kanban link directly to detailed task files
   - Seamless navigation between overview and details
   - No context switching between tools

3. **📱 Cross-Platform Synchronization**
   - Work on desktop during development
   - Check progress on mobile/tablet
   - Share visual progress with stakeholders

4. **🚀 Speed & Context**
   - No loading times or web interfaces
   - Markdown-native - works with your existing files
   - Search across all documentation instantly

### Obsidian Setup Steps

**One-time setup:**
```bash
# 1. Install Obsidian
# Download from: https://obsidian.md

# 2. Open documentation as vault
# File → Open folder as vault → Select your documentation/ folder

# 3. Install Kanban plugin
# Settings (⚙️) → Community plugins → Turn on community plugins
# Browse → Search "Kanban" → Install "Kanban" by mgmeyers → Enable

# 4. Open status.md
# It will automatically render as a visual kanban board
```

**Advanced Obsidian Features (Optional):**
- **Graph view**: Visualize connections between tasks and documentation
- **Templates**: Create task templates for consistent formatting
- **Daily notes**: Track daily development progress
- **Mobile app**: Check progress anywhere
- **Sync**: Keep documentation synced across devices

## 🔧 Technology Stack Integration

**Designed for:**
- ⚙️ **Next.js 15** with App Router
- 🎨 **Tailwind CSS v4** with modern best practices  
- 📋 **TypeScript** for type safety
- 🧪 **Headless UI** for accessible components
- 🔗 **MCP Tools** for automated research and component discovery
- 📱 **Obsidian** for visual workflow management

**Adaptable to:**
- Any React framework (Vite, Create React App, etc.)
- Other CSS frameworks (modify rule files)
- Different UI libraries (adapt component patterns)
- Alternative task management (if not using Obsidian)

## 🎯 Success Metrics

This system is working well when:
- ✅ Tasks move smoothly through all 5 agents without backtracking
- ✅ New features can be started without duplicating system setup
- ✅ Historical context is preserved and easily accessible
- ✅ Agents have clear, unambiguous instructions for their roles
- ✅ Implementation quality remains high across different features
- ✅ System scales to multiple concurrent features if needed

## 🤝 Contributing & Evolution

This documentation system is designed to evolve and improve:

### Contributing to Your Project
See [CONTRIBUTING.md](CONTRIBUTING.md) for project-specific guidelines including:
- Coding standards and security practices
- File organization principles
- API key security requirements

### Improving the System
The design agents flow system should evolve based on:
- **Pattern Recognition**: Common successful approaches become standardized
- **Process Improvements**: Bottlenecks or friction points get addressed  
- **Agent Specialization**: Agents become more specialized in their domains
- **Cross-Project Learning**: Improvements discovered in one project benefit others

### Sharing Improvements
When you discover improvements:
1. Update your local documentation
2. Document the change in scratchpad.md
3. Consider sharing successful patterns with other projects using this system

## 📋 Quick Reference

**Starting a new feature:**
```bash
@1-design-planning.md [Your feature request]
```

**Agent workflow:**
Planning → Review → Discovery → Execution → Visual Verification → Testing → Complete

**Parallel development:**
- Stable: `npm run dev:stable` (port 3000)
- Active: `npm run dev:active` (port 3001)

**File structure:**
- Active tasks: `design-agents-flow/doing/[task-slug].md`
- Completed: `design-agents-flow/done/[task-slug].md`
- Status: `design-agents-flow/status.md`

---

**💡 This system is designed to be living documentation that improves with each feature development cycle.**

*Originally developed for rapid portfolio development, now generalized for any Next.js project.*
