# Baby Project - Setup Guide

## Current Configuration
- **Project**: baby
- **Framework**: Next.js with Turbopack
- **Package Manager**: npm
- **Repository**: https://github.com/charlieellington/baby.git
- **Current Branch**: main

## ✅ Completed
- [x] Added parallel development scripts to package.json
  - `npm run dev:stable` - runs stable version on port 3000
  - `npm run dev:active` - runs active version on port 3001

## 🚀 Setup Instructions

### 1. Install Dependencies
```bash
cd /Users/charlieellington1/coding/baby
npm install
```

### 2. Set Up Supabase Environment Variables
Create a `.env.local` file in the project root with your Supabase credentials:

```env
NEXT_PUBLIC_SUPABASE_URL=your-project-url-here
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=your-publishable-key-here
```

**Get these values from**: [Supabase Dashboard → Your Project → Settings → API](https://supabase.com/dashboard/project/_/settings/api)

> **Note**: Both legacy "anon" keys and new "publishable" keys work with `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`

### 3. Run Development Server (Simple Mode)
For normal single-instance development:

```bash
npm run dev
```

Then open: **http://localhost:3000**

### 4. Set Up Parallel Development (Optional - for Design Agents Workflow)

This is only needed if you want to use the AI Design Agents workflow with stable + active development environments.

#### Option A: Automated Setup (Recommended)
```bash
cd /Users/charlieellington1/coding/baby
./ai-vibe-design-code/documentation/design-agents-flow/setup-parallel-dev.sh
```

#### Option B: Manual Setup
```bash
# Create stable branch
git push -f origin main:main-stable

# Clone stable directory
cd /Users/charlieellington1/coding
git clone https://github.com/charlieellington/baby.git baby-stable
cd baby-stable
git checkout main-stable
npm install

# Copy environment variables
cp /Users/charlieellington1/coding/baby/.env.local .env.local
```

#### Run Both Environments
Open two terminal windows:

**Terminal 1 - Stable Reference (port 3000):**
```bash
cd /Users/charlieellington1/coding/baby
npm run dev:stable
```

**Terminal 2 - Active Development (port 3001):**
```bash
cd /Users/charlieellington1/coding/baby
npm run dev:active
```

Access:
- Stable: http://localhost:3000
- Active: http://localhost:3001

## 📋 Quick Commands Reference

| Command | Description |
|---------|-------------|
| `npm install` | Install dependencies |
| `npm run dev` | Start single dev server (port 3000) |
| `npm run dev:stable` | Start stable version (port 3000) |
| `npm run dev:active` | Start active version (port 3001) |
| `npm run build` | Build for production |
| `npm run start` | Start production server |
| `npm run lint` | Run ESLint |

## 🔧 Troubleshooting

### "Cannot find module" errors
```bash
npm install
```

### "Port already in use"
```bash
# Kill process on port 3000
kill $(lsof -t -i:3000)

# Kill process on port 3001
kill $(lsof -t -i:3001)
```

### "Supabase environment variables not found"
Make sure `.env.local` exists in your project root with valid Supabase credentials.

### Stable directory out of sync
```bash
cd /Users/charlieellington1/coding/baby
git push -f origin main:main-stable

cd /Users/charlieellington1/coding/baby-stable
git pull
npm install
```

## 📖 Related Documentation
- [PARALLEL-DEV-SETUP.md](./design-agents-flow/PARALLEL-DEV-SETUP.md) - Complete parallel development guide
- [README.md](./README.md) - Design Agents Flow overview
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Development principles




