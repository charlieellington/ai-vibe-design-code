# Parallel Development Setup Guide

Quick reference for setting up stable + active development environments for any Next.js project using the design agents workflow.

**Variables for this guide:**
- `{PROJECT_NAME}` = Your project name (e.g., zebra-design, my-app)
- `{GITHUB_URL}` = Your GitHub repository URL  
- `{BRANCH_NAME}` = Your feature branch name
- `{PACKAGE_MANAGER}` = Your package manager (npm, pnpm, yarn, bun)
- `{DEV_COMMAND}` = Your dev server command (e.g., "npm run dev", "pnpm dev")

## 🔍 **Step 0: Detect Your Project Setup**

### Package Manager Detection
```bash
# Check which package manager your project uses
if [ -f "pnpm-lock.yaml" ]; then
    echo "Project uses: pnpm"
    PACKAGE_MANAGER="pnpm"
    DEV_COMMAND="pnpm dev"
elif [ -f "yarn.lock" ]; then
    echo "Project uses: yarn"
    PACKAGE_MANAGER="yarn"
    DEV_COMMAND="yarn dev"
elif [ -f "bun.lockb" ]; then
    echo "Project uses: bun"
    PACKAGE_MANAGER="bun"
    DEV_COMMAND="bun dev"
else
    echo "Project uses: npm (default)"
    PACKAGE_MANAGER="npm"
    DEV_COMMAND="npm run dev"
fi
```

### Framework Detection
```bash
# Check package.json for framework
if grep -q '"next"' package.json; then
    echo "Framework: Next.js"
    # Next.js supports PORT env var
elif grep -q '"vite"' package.json; then
    echo "Framework: Vite"
    # Vite uses --port flag
elif grep -q '"react-scripts"' package.json; then
    echo "Framework: Create React App"
    # CRA uses PORT env var
else
    echo "Framework: Unknown - check package.json scripts"
fi
```

## 🎯 Goal
- **Stable Version** (localhost:3000): Reference version for Agent 1 planning
- **Active Development** (localhost:3001): Current work for Agent 4 execution

## 📋 Quick Setup Checklist

### 1. **Branch Management**
```bash
# Ensure you're on your working branch
git branch --show-current

# Create/update the corresponding stable branch
git push -f origin {BRANCH_NAME}:{BRANCH_NAME}-stable
```

**Example:**
```bash
# If on feature/new-section branch:
git push -f origin feature/new-section:feature/new-section-stable
```

### 2. **Update Package.json Scripts**
Add these scripts to your package.json based on your package manager:

**For npm projects:**
```json
"dev:stable": "cd ../{PROJECT_NAME}-stable && PORT=3000 npm run dev",
"dev:active": "PORT=3001 npm run dev"
```

**For pnpm projects:**
```json
"dev:stable": "cd ../{PROJECT_NAME}-stable && PORT=3000 pnpm dev",
"dev:active": "PORT=3001 pnpm dev"
```

**For yarn projects:**
```json
"dev:stable": "cd ../{PROJECT_NAME}-stable && PORT=3000 yarn dev",
"dev:active": "PORT=3001 yarn dev"
```

**For bun projects:**
```json
"dev:stable": "cd ../{PROJECT_NAME}-stable && PORT=3000 bun dev",
"dev:active": "PORT=3001 bun dev"
```

**For Vite projects (any package manager):**
```json
"dev:stable": "cd ../{PROJECT_NAME}-stable && {PACKAGE_MANAGER} dev --port 3000",
"dev:active": "{PACKAGE_MANAGER} dev --port 3001"
```

### 3. **Stable Directory Setup**

**Generic setup (replace variables):**
```bash
# Clone stable worktree (one-time setup)
cd ..
git clone {GITHUB_URL} {PROJECT_NAME}-stable
cd {PROJECT_NAME}-stable

# Update the stable worktree directory
git checkout {BRANCH_NAME}-stable
git pull

# Install dependencies with your package manager
{PACKAGE_MANAGER} install
```

**Package manager specific commands:**
```bash
# For npm projects
npm install

# For pnpm projects  
pnpm install

# For yarn projects
yarn install

# For bun projects
bun install
```

**Complete example for zebra-design (npm):**
```bash
cd ..
git clone https://github.com/charlieellington/zebra-design.git zebra-design-stable
cd zebra-design-stable
git checkout feature/new-section-stable
git pull
npm install
```

### 4. **Environment Variables**

**Standard setup (works for most projects):**
```bash
# Copy environment file from main to stable
cp .env.local ../{PROJECT_NAME}-stable/.env.local

# Most frameworks use PORT env var automatically
```

**Framework-specific port handling:**

**Next.js projects** - PORT env var:
```bash
# No additional config needed - Next.js reads PORT automatically
```

**Vite projects** - uses --port flag:
```bash
# Update scripts to use --port instead of PORT env var
"dev:stable": "cd ../{PROJECT_NAME}-stable && {PACKAGE_MANAGER} dev --port 3000"
"dev:active": "{PACKAGE_MANAGER} dev --port 3001"
```

**Create React App** - PORT env var:
```bash
# No additional config needed - CRA reads PORT automatically
```

**Custom port configuration** (if needed):
```bash
# For projects with custom port handling, update .env.local:
cd ../{PROJECT_NAME}-stable
echo "PORT=3000" >> .env.local
echo "DEV_PORT=3000" >> .env.local  # Some projects use DEV_PORT
```

**Common environment variables to copy:**
```bash
# Essential for most projects
NEXT_PUBLIC_SITE_URL=*
DATABASE_URL=*
API_*=*
NEXT_PUBLIC_*=*

# Copy all environment files if they exist
cp .env.local ../{PROJECT_NAME}-stable/ 2>/dev/null || echo "No .env.local"
cp .env.development ../{PROJECT_NAME}-stable/ 2>/dev/null || echo "No .env.development"
cp .env ../{PROJECT_NAME}-stable/ 2>/dev/null || echo "No .env"
```

### 5. **Verify Setup**

**Check package manager and dependencies:**
```bash
# Navigate to stable directory
cd ../{PROJECT_NAME}-stable

# Verify package manager lock file exists
ls -la | grep -E "(package-lock.json|pnpm-lock.yaml|yarn.lock|bun.lockb)"

# Check dependencies are installed
ls node_modules/ | head -5  # Should show installed packages
```

**Verify environment variables:**
```bash
# Check environment files were copied
ls -la .env* 2>/dev/null || echo "No environment files found"

# Verify key variables exist (adapt based on your project)
cat .env.local 2>/dev/null | grep -E "(NEXT_PUBLIC_|DATABASE_|API_)" || echo "Check your env vars"
```

**Test development commands:**
```bash
# Test that your dev command works
{PACKAGE_MANAGER} dev --help  # Should show dev command options

# For Next.js projects specifically
npm run dev --help  # Should show Next.js dev options
```

## 🚀 Running Both Versions

### Start Development Servers

**Using package.json scripts (recommended):**
```bash
# Terminal 1: Start stable version (port 3000)
{PACKAGE_MANAGER} run dev:stable

# Terminal 2: Start active development (port 3001)  
{PACKAGE_MANAGER} run dev:active
```

**Manual startup (if scripts not set up):**
```bash
# Terminal 1: Stable version
cd ../{PROJECT_NAME}-stable && PORT=3000 {PACKAGE_MANAGER} dev

# Terminal 2: Active version  
PORT=3001 {PACKAGE_MANAGER} dev
```

**Framework-specific examples:**

**Next.js with npm:**
```bash
npm run dev:stable    # Uses package.json script
npm run dev:active    # Uses package.json script
```

**Vite with pnpm:**
```bash
pnpm run dev:stable   # Uses --port 3000 flag
pnpm run dev:active   # Uses --port 3001 flag
```

### Access URLs
- **Stable Reference**: http://localhost:3000
- **Active Development**: http://localhost:3001

## 🔧 Troubleshooting

### Common Issues

**❌ "Environment variable not defined"**
- Missing `.env.local` in stable directory
- Run step 4 (Environment Variables)

**❌ "Page not found / 404 errors"**
- Stable directory on wrong branch
- Run steps 1-3 (Branch + Directory setup)
- Ensure stable branch has your latest changes

**❌ "Port already in use"**
```bash
# Kill processes on ports
kill $(lsof -t -i:3000) 2>/dev/null || echo "Port 3000 free"
kill $(lsof -t -i:3001) 2>/dev/null || echo "Port 3001 free"
```

**❌ Wrong directory name**
```bash
# If stable directory has different name, update package.json:
"dev:stable": "cd ../your-actual-stable-directory && PORT=3000 npm run dev"
```

**❌ "Package manager command not found"**
```bash
# Check which package manager is installed
npm --version   # npm
pnpm --version  # pnpm  
yarn --version  # yarn
bun --version   # bun

# Install missing package manager
npm install -g pnpm    # Install pnpm globally
npm install -g yarn    # Install yarn globally
curl -fsSL https://bun.sh/install | bash  # Install bun
```

**❌ "dev command not found"**
```bash
# Check package.json scripts section
cat package.json | grep -A 10 '"scripts"'

# Common script names to look for:
"dev"           # Most common
"start"         # Some projects
"serve"         # Vite projects sometimes
"develop"       # Gatsby projects
```

**❌ "Dependencies installation failed"**
```bash
# Clear cache and retry (package manager specific)
npm cache clean --force && npm install      # npm
pnpm store prune && pnpm install           # pnpm
yarn cache clean && yarn install           # yarn  
bun pm cache rm && bun install            # bun

# Alternative: Delete node_modules and reinstall
rm -rf node_modules package-lock.json
{PACKAGE_MANAGER} install
```

## 🎯 Branch Naming Convention

For any working branch, the stable branch should add `-stable` suffix:

- `feature/new-section` → `feature/new-section-stable`
- `feature/blog-redesign` → `feature/blog-redesign-stable`  
- `main` → `main-stable`

## 🤖 Auto-Setup Script (Recommended)

**One-command setup for any project:**

We've included a complete auto-setup script: [`setup-parallel-dev.sh`](setup-parallel-dev.sh)

```bash
# From your project root, run:
./documentation/design-agents-flow/setup-parallel-dev.sh
```

**What the script does automatically:**
- ✅ Detects your package manager (npm/pnpm/yarn/bun)
- ✅ Detects your framework (Next.js/Vite/CRA/etc.)
- ✅ Creates stable branch
- ✅ Clones stable directory
- ✅ Installs dependencies with correct package manager
- ✅ Copies all environment files
- ✅ Provides exact package.json scripts to add
- ✅ Handles port configuration for your framework

**Benefits of using the script:**
- No manual variable replacement needed
- Automatic error handling and validation
- Framework-specific port configuration
- Comprehensive environment file copying

## 📝 Manual Commands Reference

**Update stable branch:**
```bash
git push -f origin $(git branch --show-current):$(git branch --show-current)-stable
```

**Copy environment (any package manager):**
```bash
cp .env* ../{PROJECT_NAME}-stable/ 2>/dev/null || echo "No env files"
```

**Health check (universal):**
```bash
curl -s http://localhost:3000 >/dev/null && echo "✅ Stable running" || echo "❌ Stable not running"  
curl -s http://localhost:3001 >/dev/null && echo "✅ Active running" || echo "❌ Active not running"
```

## 🌐 Framework & Package Manager Compatibility

### Supported Configurations

| Framework | Package Manager | Dev Command | Port Handling | Status |
|-----------|----------------|-------------|---------------|--------|
| Next.js   | npm/pnpm/yarn/bun | `{PM} run dev` | PORT env var | ✅ Fully Supported |
| Vite      | npm/pnpm/yarn/bun | `{PM} dev` | --port flag | ✅ Fully Supported |
| CRA       | npm/yarn      | `{PM} start` | PORT env var | ✅ Supported |
| Remix     | npm/pnpm/yarn | `{PM} dev` | --port flag | ⚠️ Needs Testing |
| SvelteKit | npm/pnpm/yarn | `{PM} dev` | --port flag | ⚠️ Needs Testing |
| Nuxt      | npm/pnpm/yarn | `{PM} dev` | --port flag | ⚠️ Needs Testing |

### Quick Detection Script
```bash
# Run this to auto-detect your project configuration
echo "Project: $(basename $PWD)"
echo "Framework: $(grep -o '\"next\"\\|\"vite\"\\|\"react-scripts\"' package.json | head -1 | tr -d '\"')"
echo "Package Manager: $([ -f pnpm-lock.yaml ] && echo pnpm || [ -f yarn.lock ] && echo yarn || [ -f bun.lockb ] && echo bun || echo npm)"
echo "Dev Script: $(grep -o '\"dev\":\\s*\"[^\"]*\"' package.json | cut -d'\"' -f4)"
```

---

## 📋 Project-Specific Quick Reference

**For zebra-design (current project):**
```bash
# Auto-detected: Next.js + npm
# Update stable branch
git push -f origin $(git branch --show-current):$(git branch --show-current)-stable

# Clone stable (one-time setup)
cd .. && git clone https://github.com/charlieellington/zebra-design.git zebra-design-stable
cd zebra-design-stable && npm install

# Copy environment
cp .env.local ../zebra-design-stable/.env.local

# Run both servers (using package.json scripts)
npm run dev:stable  # Terminal 1 (port 3000)
npm run dev:active  # Terminal 2 (port 3001)
```

**For any new project (template):**
```bash
# Replace these variables with your values:
# {PROJECT_NAME} = your-project-name
# {GITHUB_URL} = https://github.com/username/repo.git  
# {PACKAGE_MANAGER} = npm|pnpm|yarn|bun

git push -f origin $(git branch --show-current):$(git branch --show-current)-stable
cd .. && git clone {GITHUB_URL} {PROJECT_NAME}-stable
cd {PROJECT_NAME}-stable && {PACKAGE_MANAGER} install
cp .env* ../{PROJECT_NAME}-stable/ 2>/dev/null
```

---

## 📋 Visual Workflow Integration (Obsidian)

**Recommended:** Use Obsidian for visual task management alongside parallel development.

### Why Visual Kanban + Parallel Dev = Speed

1. **Problem**: Traditional development loses time to:
   - Context switching between broken and working versions
   - Debugging issues that block forward progress  
   - Losing track of multiple features in development

2. **Solution**: Parallel Development + Visual Kanban:
   - **Stable reference** (port 3000): Always working version for planning/reference
   - **Active development** (port 3001): Current work that might break temporarily
   - **Visual kanban**: See all tasks and stages at once, move visually

3. **Workflow Benefits**:
   - Agent 1 plans against stable version (never broken)
   - Agent 4 implements on active version (can break without blocking)
   - Visual kanban shows bottlenecks and progress instantly
   - Switch between features without losing context

### Quick Obsidian Setup
```bash
# 1. Install Obsidian (https://obsidian.md)
# 2. Open documentation/ folder as vault
# 3. Install Kanban plugin (Community plugins → "Kanban" by mgmeyers)
# 4. Open design-agents-flow/status.md → visual kanban appears
```

**Result**: Visual task pipeline + parallel stable/active development = rapid, organized feature development

---

**💡 Pro Tip**: Use the auto-setup script above for one-command configuration! For complete system overview and Obsidian details, see [../README.md](../README.md).
