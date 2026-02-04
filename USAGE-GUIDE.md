# Usage Guide: Managing Design Agents Flow Across Projects

This guide explains how to use the design-agents-flow system across multiple projects and manage updates over time.

## Repository Purpose

This repository (`ai-vibe-design-code`) is the **source of truth** for the design agents workflow. It contains:

- The 11 agent instruction files (design-0-quick, design-0-refine, design-1 through design-9)
- Knowledge base (learnings.md, motion-patterns.md, ui-component-libraries.md)
- Reference documentation (shadcn rules, tailwind rules)
- Status tracking templates
- Setup scripts

## Using in a New Project

### Option 1: Git Submodule (Recommended)

Add this repo as a submodule in your project:

```bash
cd your-project
git submodule add https://github.com/charlieellington/ai-vibe-design-code.git .conductor/design-agents
```

**Benefits:**
- Updates can be pulled from upstream
- Your project-specific changes stay separate
- Clean separation of concerns

**Updating:**
```bash
cd .conductor/design-agents
git pull origin main
cd ../..
git add .conductor/design-agents
git commit -m "Update design agents to latest"
```

### Option 2: Copy Files

Copy the necessary files to your project:

```bash
# Copy agent files
cp ai-vibe-design-code/design-*.md your-project/documentation/design-agents/

# Copy reference docs
cp -r ai-vibe-design-code/misc your-project/documentation/design-agents/

# Copy status templates
cp ai-vibe-design-code/status.md your-project/documentation/design-agents/
mkdir -p your-project/documentation/design-agents/{doing,done}
```

**Note:** With this approach, you'll need to manually sync updates.

### Option 3: Conductor Workspace

If using Conductor, clone directly into your workspace:

```bash
# In Conductor, create workspace from this repo
# Files will be at .conductor/[workspace-name]/
```

## Project-Specific Customization

### What to Keep Project-Specific

Each project should maintain its own:

1. **`status.md`** - Task tracking for that project
2. **`doing/`** - Active tasks for that project
3. **`done/`** - Completed tasks for that project
4. **`misc/` reference docs** - If you customize styling rules

### What to Keep Synced with Upstream

Keep these synced with the main repository:

1. **`design-*.md`** - Agent instruction files
2. **`setup-parallel-dev.sh`** - Setup scripts
3. **`README.md`** - Unless you need project-specific docs

## Updating the Source Repository

When you improve the agents during a project:

### 1. Identify Improvements

During development, note improvements to agent instructions:
- Better prompts
- New patterns discovered
- Bug fixes in instructions

### 2. Contribute Back

```bash
# Clone the source repo
git clone https://github.com/charlieellington/ai-vibe-design-code.git

# Create a branch for your improvements
git checkout -b improve-agent-4-execution

# Make your changes to the agent files
# Test in a real project first!

# Commit and push
git add .
git commit -m "Improve Agent 4 execution patterns for component reuse"
git push origin improve-agent-4-execution

# Create PR on GitHub
```

### 3. Version Tagging

For major updates, tag releases:

```bash
git tag -a v1.1.0 -m "Add improved visual verification patterns"
git push origin v1.1.0
```

## Recommended Workflow for Teams

### Single Developer

1. Use git submodule approach
2. Keep project tasks in `status.md` and `done/`
3. Periodically pull upstream updates
4. Contribute improvements back

### Team of 2-5

1. Use git submodule approach
2. One person owns the agents repo updates
3. Review agent changes before merging
4. Share project-specific learnings in team docs

### Larger Teams

1. Fork the repo to your organization
2. Maintain your fork with org-specific customizations
3. Periodically merge upstream changes
4. Document your customizations in a `CUSTOMIZATIONS.md`

## Keeping Status Clean

### Before Starting a New Project

1. Clear `status.md` to empty template
2. Delete all files in `doing/` and `done/`
3. Keep `.gitkeep` files

### After Completing a Project

If you want to archive project work:

1. Create a branch: `git checkout -b archive/project-name`
2. Commit the done tasks: `git add done/ && git commit`
3. Switch back to main: `git checkout main`
4. Clean for next project

## File Organization Best Practices

### Agent Files (design-*.md)

- Keep under 250 lines each
- Document reasoning for major changes
- Include examples for complex patterns

### Task Files (done/*.md)

Use consistent naming:
```
done/feature-name-description.md
done/bugfix-issue-description.md
done/refactor-component-name.md
```

### Reference Docs (misc/*.mdc)

- Update when adopting new tools/frameworks
- Keep framework-specific (one file per major tool)
- Include version numbers for compatibility

## Troubleshooting

### Agent Not Finding Files

Check that agent files are in the correct location relative to your IDE/tool configuration.

### Status Board Not Working

Ensure Obsidian has the Kanban plugin installed and the YAML frontmatter is valid.

### Duplicate Components Being Created

Agent 3 (Discovery) should prevent this. If it's happening:
1. Check Agent 3 is being used before Agent 4
2. Ensure codebase is indexed by your MCP tools
3. Add explicit "check for existing" steps to your prompts

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01 | Initial release with 7-agent workflow |
| 2.0.0 | 2026-02 | Expanded to 11 agents, added learnings.md knowledge base, motion-patterns.md, ui-component-libraries.md |

---

*Questions? Create an issue on GitHub or reach out via the blog post comments.*
