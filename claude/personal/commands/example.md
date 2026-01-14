---
description: Example personal slash command
---

# Example Command

This is a personal command that you've added to your dotfiles.

When you invoke this command, Claude will follow the instructions here.

**To customize:**
1. Edit this file in `~/.dotfiles/claude/personal/commands/`
2. Run `make claude-config` to install
3. Use `/example` in Claude Code

**To create new commands:**
- Add `.md` files to `claude/personal/commands/`
- Filename becomes command name (e.g., `my-command.md` → `/my-command`)
- Include a `description` in frontmatter for better discoverability
