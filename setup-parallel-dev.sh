#!/bin/bash
# Auto-setup script for parallel development workflow
# Run this once from your project root to set up stable + active environments

set -e  # Exit on error

echo "🚀 Setting up parallel development workflow..."

# Auto-detect package manager
if [ -f "pnpm-lock.yaml" ]; then 
    PM="pnpm"
    DEV_CMD="pnpm dev"
    echo "📦 Detected package manager: pnpm"
elif [ -f "yarn.lock" ]; then 
    PM="yarn"
    DEV_CMD="yarn dev"
    echo "📦 Detected package manager: yarn"
elif [ -f "bun.lockb" ]; then 
    PM="bun"
    DEV_CMD="bun dev"
    echo "📦 Detected package manager: bun"
else 
    PM="npm"
    DEV_CMD="npm run dev"
    echo "📦 Detected package manager: npm (default)"
fi

# Auto-detect framework
if grep -q '"next"' package.json; then
    FRAMEWORK="Next.js"
    PORT_HANDLING="PORT env var"
elif grep -q '"vite"' package.json; then
    FRAMEWORK="Vite"  
    PORT_HANDLING="--port flag"
    DEV_CMD="${DEV_CMD} --port"
elif grep -q '"react-scripts"' package.json; then
    FRAMEWORK="Create React App"
    PORT_HANDLING="PORT env var"
else
    FRAMEWORK="Unknown"
    PORT_HANDLING="Check package.json"
    echo "⚠️ Unknown framework - please verify dev commands manually"
fi

# Get project details
PROJECT_NAME=$(basename "$PWD")
CURRENT_BRANCH=$(git branch --show-current)
GITHUB_URL=$(git remote get-url origin 2>/dev/null || echo "No remote origin found")

echo "🔍 Project configuration:"
echo "   Name: $PROJECT_NAME"
echo "   Framework: $FRAMEWORK"
echo "   Branch: $CURRENT_BRANCH"
echo "   Remote: $GITHUB_URL"
echo "   Port handling: $PORT_HANDLING"

# Verify git remote exists
if [ "$GITHUB_URL" = "No remote origin found" ]; then
    echo "❌ Error: No git remote 'origin' found. Please add your repository URL:"
    echo "   git remote add origin https://github.com/username/repo.git"
    exit 1
fi

# Create stable branch
echo "📤 Creating stable branch: $CURRENT_BRANCH-stable"
git push -f origin $CURRENT_BRANCH:$CURRENT_BRANCH-stable

# Clone stable directory  
echo "📥 Cloning stable directory..."
cd .. 
if [ -d "$PROJECT_NAME-stable" ]; then
    echo "⚠️ Stable directory exists, updating..."
    cd $PROJECT_NAME-stable
    git checkout $CURRENT_BRANCH-stable
    git pull
else
    git clone $GITHUB_URL $PROJECT_NAME-stable
    cd $PROJECT_NAME-stable
    git checkout $CURRENT_BRANCH-stable
fi

# Install dependencies
echo "📦 Installing dependencies with $PM..."
$PM install

# Copy environment files
cd ../$PROJECT_NAME
echo "🔧 Copying environment files..."
env_copied=false
for env_file in .env.local .env.development .env; do
    if [ -f "$env_file" ]; then
        cp "$env_file" "../$PROJECT_NAME-stable/"
        echo "   ✅ Copied $env_file"
        env_copied=true
    fi
done

if [ "$env_copied" = false ]; then
    echo "   ⚠️ No environment files found to copy"
fi

echo ""
echo "✅ Parallel development setup complete!"
echo ""
echo "📝 Add these scripts to your package.json:"
echo ""
if [ "$FRAMEWORK" = "Vite" ]; then
    echo "\"dev:stable\": \"cd ../$PROJECT_NAME-stable && $DEV_CMD 3000\","
    echo "\"dev:active\": \"$DEV_CMD 3001\""
else
    echo "\"dev:stable\": \"cd ../$PROJECT_NAME-stable && PORT=3000 $DEV_CMD\","
    echo "\"dev:active\": \"PORT=3001 $DEV_CMD\""
fi
echo ""
echo "🚀 Ready to start parallel development!"
echo "   Stable:  http://localhost:3000"
echo "   Active:  http://localhost:3001"
