# Cursor/Claude IDE Setup Notes

## File Indexing Configuration

### Problem
Files in `zebra-planning/` and `reference-projects/` weren't showing up in @ tags because:
- These folders are in `.gitignore` (to keep them out of the user-testing-app git repo)
- Cursor by default respects `.gitignore` and doesn't index ignored files

### Solution
Created `.cursorignore` file that:
- ✅ Excludes standard things (node_modules, build artifacts, etc.)
- ✅ **Does NOT exclude** `zebra-planning/` and `reference-projects/`
- ✅ This tells Cursor to index these folders even though git ignores them

### Files You Can Now @ Reference

**From zebra-planning:**
- `@zebra-planning/background/user-testing-app/poc-mvp-plan.md`
- `@zebra-planning/background/business-plan/business-plan.md`
- `@zebra-planning/background/business-plan/ideal-customer-profile.md`
- `@zebra-planning/action-plan/action-plan.md`
- And all other files in zebra-planning/

**From reference-projects:**
- `@reference-projects/no-bad-parts/` (all files)
- Example: `@reference-projects/no-bad-parts/app/page.tsx`
- Example: `@reference-projects/no-bad-parts/components/session/`

### After Creating .cursorignore

**You may need to:**
1. Reload Cursor window: `Cmd+Shift+P` → "Developer: Reload Window"
2. Wait 1-2 minutes for Cursor to re-index files
3. Try @ tags again - the folders should now appear

### Verification

Test that indexing works:
```
@zebra-planning/background/user-testing-app/poc-mvp-plan.md
```

If this file shows up in autocomplete, indexing is working! ✅

### What's Still Ignored by Cursor

These remain ignored for performance (large/unnecessary for AI context):
- `node_modules/`
- `.next/` and build outputs
- Lock files (package-lock.json, etc.)
- Binary files (images, fonts, etc.)
- Environment files (.env.local)

### Git vs Cursor Behavior

| Folder | Git Status | Cursor Indexed | Reason |
|--------|-----------|----------------|---------|
| `zebra-planning/` | ❌ Ignored | ✅ Indexed | Keeps git clean, but available for AI |
| `reference-projects/` | ❌ Ignored | ✅ Indexed | Keeps git clean, but available for AI |
| `node_modules/` | ❌ Ignored | ❌ Not Indexed | Too large, not useful for context |
| `.env.local` | ❌ Ignored | ❌ Not Indexed | Sensitive data, should stay private |

---

**Last Updated**: October 27, 2025  
**Status**: ✅ External folders now indexed and available via @ tags

