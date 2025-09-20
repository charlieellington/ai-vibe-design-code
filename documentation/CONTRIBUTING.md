---
title: CONTRIBUTING
---

# CONTRIBUTING

---

## 0. Core Principles  
1. **Keep it simple.** Reach for the smallest, clearest fix first.  
2. **No duplication.** Re-use existing code before writing more.  
3. **Change only what you truly understand or what the user asked for.**  
4. **One source of truth.** If you add a new approach, remove its older twin.  
5. **Stay clean and tiny.**  
   * Refactor when a file nears ~250 lines.  
   * One-off scripts belong in proper tooling or tests—not random files.  
6. **Real data only.** Mock or stub **only** inside automated tests. Never in dev or prod paths.  
7. **Env safety.** Never overwrite `.env` without explicit approval.  
8. **Human-first headers.** Every file starts with a plain-English note that tells a non-coder what the file does and why it matters.
9. **API Key & Secret Security.** Never commit API keys, secrets, or tokens to any repository.

---

## 2. Coding Etiquette

* **≤ 250 lines per file.** Break apart sooner.  
* **No stray one-off scripts.** Convert them into repeatable commands or delete.  
* **Read before you write.** Know the territory.  
* **Helpful output.** Print enough context to debug quickly.  
* **Record insights.** List every reusable lesson in the **Lessons** section.

---

## 3. API Key & Secret Security

**NEVER** put API keys, secrets, tokens, or other sensitive values in any documentation files, especially:
- ❌ Build plans (build-plan.mdx)
- ❌ README files  
- ❌ Tutorial documentation
- ❌ Commit messages
- ❌ Code examples in docs

**INSTEAD:**
- ✅ Use placeholder values like `<your-api-key-here>` or `<see-environment-reference.md>`
- ✅ Store actual values in git-ignored files (like `environment-reference.md`)
- ✅ Reference the secure file location in documentation
- ✅ Always add sensitive files to `.gitignore` immediately

**Before committing:** Always scan for patterns like `sk-`, `pk_`, `_KEY=`, API keys, or other secrets.

---

## 4. Conflict Rule

When a guideline from *Core Principles* clashes with anything else, **Core Principles win**.
