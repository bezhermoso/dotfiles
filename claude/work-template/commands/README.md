# Work Commands Template

⚠️ **This is a template directory in your dotfiles.**

## Setup

Copy this to `~/.claude/work/commands/` and add work-specific commands there:

```bash
mkdir -p ~/.claude/work/commands
# Add your work commands to ~/.claude/work/commands/
```

## Usage

Work commands in `~/.claude/work/commands/` will be automatically installed to `~/.claude/commands/` when you run:

```bash
make claude-config
```

## Safety

- **Work commands live in `~/.claude/work/commands/`** (gitignored)
- **Personal commands live in `~/.dotfiles/claude/personal/commands/`** (tracked)
- Both get installed to `~/.claude/commands/` without conflict

⚠️ **NEVER commit work commands to your dotfiles repo!**
