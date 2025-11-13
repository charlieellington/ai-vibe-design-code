---
kanban-plugin: board
---

# 📋 Design Agents Flow - Kanban Board

## 🔧 Obsidian Setup Instructions

**First time setup:**
1. Install [Obsidian](https://obsidian.md) 
2. Open your project's `documentation/` folder as an Obsidian vault
3. Install Kanban plugin: Settings → Community plugins → Browse → Search "Kanban" → Install & Enable
4. Open this file (status.md) - it will render as a visual kanban board

**How to use:**
- 🎯 **Visual Management**: See all tasks across pipeline stages
- 📝 **Add Tasks**: Type task titles in any column 
- 🖱️ **Drag & Drop**: Move tasks between stages visually
- 🔗 **Link to Details**: Task titles link to individual markdown files in `doing/` and `done/` folders
- ✅ **Mark Complete**: Check off completed tasks with `- [x]`

**Agent Workflow:** Planning → Review → Discovery → Ready to Execute → Executing → Testing → Complete

---

## Planning

<!-- New tasks start here via @design-1-planning.md -->

## Review

<!-- Tasks move here via @design-2-review.md for validation -->

## Discovery

<!-- Tasks move here via @design-3-discovery.md for technical analysis -->

## Ready to Execute

<!-- Tasks move here after technical discovery confirms implementation approach -->

## Executing

<!-- Tasks move here via @design-4-execution.md during implementation -->

## Testing

<!-- Tasks move here for visual verification via @design-5-visual-verification.md -->

## Complete

<!-- Completed tasks move here via @design-6-complete.md with final documentation -->

%% kanban:settings
```
{"kanban-plugin":"board"}
```
%%
