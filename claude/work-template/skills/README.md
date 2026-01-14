# Work Skills Template

⚠️ **This is a template directory in your dotfiles.**

## Setup

Copy this to `~/.claude/work/skills/` and add work-specific skills there:

```bash
mkdir -p ~/.claude/work/skills
# Add your work skill directories to ~/.claude/work/skills/
```

## Usage

Work skills in `~/.claude/work/skills/` will be automatically installed to `~/.claude/skills/` when you run:

```bash
make claude-config
```

## Safety

- **Work skills live in `~/.claude/work/skills/`** (gitignored)
- **Personal skills live in `~/.dotfiles/claude/personal/skills/`** (tracked)
- Both get installed to `~/.claude/skills/` without conflict

⚠️ **NEVER commit work skills to your dotfiles repo!**
