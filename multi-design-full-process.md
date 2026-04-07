# Multi Design-Full Process

How to run design-1-planning + /design-full across many tasks autonomously using Conductor workspaces and Claude Code tasks for progress tracking.

---

## Why This Process Exists

Running /design-full on many tasks sequentially in a single chat causes context overflow. Each subagent returns its full output into the parent context, and after a few tasks the chat compacts or errors out. This process solves that by splitting work across multiple Conductor workspaces (3-5 tasks per workspace) while using Claude Code's TaskCreate/TaskUpdate system for visible progress tracking.

---

## How It Works

1. **Split tasks across Conductor workspaces** — max 3-5 tasks per workspace to avoid context overflow
2. **Create all tasks upfront with TaskCreate** — gives visible progress tracking in the sidebar
3. **Process sequentially within each workspace** — Plan → Design-Full → next task
4. **Conductor runs workspaces in parallel** — so you still get parallelism across batches

---

## Process: Step by Step

### 1. Prepare Your Task List

Write out all the tasks you want to process. Each task needs:
- A short identifier (e.g. Q1, Q2, or a slug)
- A description of the issue
- A description of the fix

### 2. Split Into Batches of 3-5

Divide tasks into groups of 3-5. Each group becomes one Conductor workspace prompt.

**Why 3-5?** Each task runs planning (1 subagent) + design-full (1 skill invocation). With context from subagent results accumulating, 3-5 tasks per workspace stays safely within context limits. If chat compaction happens mid-workspace, the agent can recover using TaskList.

### 3. Write the Workspace Prompt

For each batch, create a prompt following this template:

```
## [Batch Name]: Plan + Design-Full (Sequential)

Process [N] tasks. For each: plan it, then run design-full. ONE AT A TIME.

---

### STEP 0: Create all [N×2] tasks upfront using TaskCreate

BEFORE doing any work, use TaskCreate to create these [N×2] tasks (do all now):

1. Subject: "[ID]: Plan — [short title]"
   Description: "Run design-1-planning for [ID]: [what the fix does]."
   ActiveForm: "Planning [ID] [short description]"

2. Subject: "[ID]: Design-Full — [short title]"
   Description: "Run /design-full for [ID] after planning completes."
   ActiveForm: "Running design-full for [ID]"

[... repeat pairs for each task ...]

After creating all tasks, use TaskUpdate to set each Design-Full task as blocked by its corresponding Plan task (task 2 blocked by task 1, task 4 blocked by task 3, etc.).

---

### STEP 1: Process each task sequentially

For each task, do Step A then Step B:

#### Step A: Run Planning

1. Use TaskUpdate to set the Plan task to "in_progress"
2. Use the Task tool (subagent_type: "general-purpose", NOT run_in_background) with this prompt:

---BEGIN SUBAGENT PROMPT---
You are running Design Agent 1 (Planning) for a task.

READ AND FOLLOW the full planning process in agents/design-1-planning.md.

YOUR SPECIFIC TASK:
[PASTE THE FULL TASK DESCRIPTION HERE]

BEFORE you write the plan, you MUST read ALL of these context files:
[LIST YOUR CONTEXT FILES — sprint plans, user testing results, design docs, etc.]

THEN explore the actual codebase — search for the specific files, components, and code that need to change. Trace from routes to components. Document exact file paths and line numbers.

THEN follow agents/design-1-planning.md to:
1. Create a task file in agents/doing/[task-slug].md
2. Update agents/status.md — add under "## 📝 Planning (Design-1)"

Task slug: kebab-case, e.g. "[example-slug]"
End with: "Plan complete. Ready for review stage."
---END SUBAGENT PROMPT---

3. When the subagent finishes, use TaskUpdate to set the Plan task to "completed"

#### Step B: Run Design-Full

1. Use TaskUpdate to set the Design-Full task to "in_progress"
2. Read the task file in agents/doing/[task-slug].md
3. Prepend this text at the very top of the task file:

> **AUTONOMOUS REVIEW INSTRUCTION:** If any review questions come up during Agent 2 (Review), make your own best assessment based on the code, project context, and user testing results — always optimising for the 3 sprint questions in documentation/main-plans/sprint-questions.md (Differentiation, Trust, Navigation). Do not ask the user. Make the call yourself and document your reasoning.

4. Use the Skill tool to invoke skill "design-full" with the task slug as args.
5. When complete, use TaskUpdate to set the Design-Full task to "completed"
6. Move to the next task.

---

### The Tasks (process in this exact order):

[LIST EACH TASK WITH FULL DETAILS — issue, fix, any notes]

### CRITICAL RULES
- STEP 0 (create all tasks) MUST happen FIRST before any work begins.
- Process tasks ONE AT A TIME: Plan T1 → Design-Full T1 → Plan T2 → Design-Full T2 → etc.
- NEVER launch multiple Task subagents in a single message.
- NEVER use run_in_background for Task subagents.
- Always update task status: in_progress when starting, completed when done.
- After each step completes, write ONE short line ("[ID] planning done") then move on.
- Do NOT summarise subagent output — just confirm done and continue.
- If chat compaction happens, use TaskList to see where you are, then continue with the next incomplete task.
```

### 4. Launch in Conductor

Open a new Conductor workspace for each batch. Paste the prompt. All workspaces run in parallel.

---

## Key Constraints and Lessons Learned

### What causes context overflow (avoid these):
- **Parallel subagents in one chat** — launching 5+ Task subagents in a single message floods context when they all return
- **Background agents with polling** — using `run_in_background: true` then calling `TaskOutput` on each one accumulates all results into context
- **Verbose status reporting** — summarising each subagent's full output wastes context tokens

### What works:
- **Sequential subagents** — one at a time, context stays manageable
- **TaskCreate/TaskUpdate for tracking** — lightweight, visible in sidebar, survives compaction
- **TaskList for recovery** — after compaction, agent can check which tasks are still pending
- **Short confirmations** — "Q1 done" not a paragraph summary
- **Split across workspaces** — Conductor parallelises at the workspace level

### Autonomous review instruction:
Adding the autonomous review instruction to the task file prevents Agent 2 (Review) from blocking the workflow by asking the user questions. The agent makes its own decisions based on project context and documents its reasoning.

### Potential conflicts:
All workspaces write to `agents/status.md`. If two workspaces update it simultaneously, one may need to re-read and re-edit. This is generally self-resolving.

---

## Quick Reference: Task Sizing

| Tasks | Workspaces | Tasks per workspace |
|-------|-----------|-------------------|
| 3-5   | 1         | 3-5               |
| 6-10  | 2         | 3-5 each          |
| 11-15 | 3-4       | 3-5 each          |
| 16-20 | 4-5       | 3-5 each          |

---

## Example: Sprint 3 UX Quick Fixes (15 tasks)

Split into 4 workspaces:
- **Workspace 1:** Q1-Q4 (4 tasks = 8 TaskCreate items)
- **Workspace 2:** Q5-Q8 (4 tasks = 8 TaskCreate items)
- **Workspace 3:** Q9-Q12 (4 tasks = 8 TaskCreate items)
- **Workspace 4:** Q13-Q15 (3 tasks = 6 TaskCreate items)

Each workspace created its tasks upfront, then processed Plan → Design-Full for each task sequentially. All 4 workspaces ran in parallel via Conductor.

See `.context/ux-quick-fix-prompts.md` for the exact prompts used.
