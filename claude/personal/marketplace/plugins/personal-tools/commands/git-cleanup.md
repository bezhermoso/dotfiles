---
description: Clean up merged git branches locally and remotely
argument-hint: "[--dry-run]"
allowed-tools:
  - Bash(git:*)
---

# Git Cleanup Command

Clean up git branches that have been merged into the main branch.

## What to Do

1. **Identify the main branch**:
   - Check if it's `main`, `master`, or another name
   - Use `git remote show origin | grep "HEAD branch"`

2. **Find merged branches**:
   - Local branches: `git branch --merged <main-branch>`
   - Remote branches: `git branch -r --merged <main-branch>`

3. **Exclude protected branches**:
   - Never delete: `main`, `master`, `develop`, `staging`, `production`
   - Never delete: current branch

4. **If --dry-run argument provided**:
   - Only show what would be deleted
   - Don't actually delete anything

5. **Otherwise, delete branches**:
   - Delete local branches: `git branch -d <branch-name>`
   - Delete remote branches: `git push origin --delete <branch-name>`
   - Show summary of what was deleted

6. **Handle errors gracefully**:
   - If a branch can't be deleted, show why
   - Continue with other branches

## Output Format

Show a clear summary:
```
🧹 Git Cleanup Summary

Protected branches (skipped):
  • main
  • develop

Merged branches found:
  • feature/old-feature (local + remote)
  • bugfix/fixed-bug (local only)

[If --dry-run]
Would delete:
  ✓ feature/old-feature (local + remote)
  ✓ bugfix/fixed-bug (local)

Run without --dry-run to delete these branches.

[If actually deleting]
Deleted:
  ✓ feature/old-feature (local + remote)
  ✓ bugfix/fixed-bug (local)

Failed:
  ✗ feature/problematic-branch (not fully merged)
```
