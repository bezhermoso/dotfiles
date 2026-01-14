---
name: example-skill
description: Example personal skill showing how to create custom skills
---

# Example Skill

This is a personal skill that you've added to your dotfiles.

Claude will automatically use this skill when the context matches the description.

## How Skills Work

Skills are directories containing a `SKILL.md` file. Claude uses the `description` field in the frontmatter to determine when to activate this skill.

## Customization

**To customize this skill:**
1. Edit files in `~/.dotfiles/claude/personal/skills/example-skill/`
2. Run `make claude-config` to install
3. Claude will auto-activate based on context

**To create new skills:**
1. Create a directory in `claude/personal/skills/` (e.g., `my-skill/`)
2. Add a `SKILL.md` file with frontmatter
3. Include supporting files as needed
4. Run `make claude-config`

## Supporting Files

Skills can include additional files:
- Documentation (`.md` files)
- Templates (code scaffolds)
- Helper scripts (`.sh` files)

All files in the skill directory are available to Claude when the skill is active.
