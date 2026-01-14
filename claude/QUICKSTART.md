# Claude Config Framework - Quick Start

## 🚀 Setup (First Time)

```bash
cd ~/.dotfiles

# Run setup (creates work config directory & builds merged config)
DOTFILES_DIR=$PWD bash ./claude/build-claude-config.sh

# Optional: Create work config
mkdir -p ~/.claude/work
cp claude/work-template/CLAUDE.md ~/.claude/work/CLAUDE.md
```

## ✏️ Daily Usage

### Edit Personal Config

```bash
# Edit your personal AI preferences
vim ~/.dotfiles/claude/personal/CLAUDE.md

# Rebuild
DOTFILES_DIR=~/.dotfiles bash ~/.dotfiles/claude/build-claude-config.sh
```

### Edit Work Config

```bash
# Edit work-specific guidelines (gitignored)
vim ~/.claude/work/CLAUDE.md

# Rebuild
DOTFILES_DIR=~/.dotfiles bash ~/.dotfiles/claude/build-claude-config.sh
```

## 📦 Commit Personal Changes

```bash
cd ~/.dotfiles
git add claude/personal/CLAUDE.md
git commit -m "Update AI preferences"
git push
```

**Note**: Work config in `~/.claude/work/` is automatically gitignored!

## 🔍 Verify What Will Be Committed

```bash
cd ~/.dotfiles
git status

# You should see:
# ✅ claude/personal/     <- Safe to commit
# ✅ claude/README.md     <- Safe to commit
# ❌ No claude/work/      <- Correctly ignored
# ❌ No .claude/          <- Correctly ignored
```

## 🎯 Common Tasks

### Check Generated Config

```bash
cat ~/.claude/CLAUDE.md | head -50
```

### Reset Everything

```bash
rm -rf ~/.claude/work
rm ~/.claude/CLAUDE.md
DOTFILES_DIR=~/.dotfiles bash ~/.dotfiles/claude/build-claude-config.sh
```

### Sync Across Machines

```bash
# Machine A (edit & commit)
cd ~/.dotfiles
vim claude/personal/CLAUDE.md
git add claude/personal/CLAUDE.md
git commit -m "Update preferences"
git push

# Machine B (pull & rebuild)
cd ~/.dotfiles
git pull
DOTFILES_DIR=$PWD bash ./claude/build-claude-config.sh
```

## 🛡️ Safety Checklist

Before committing, verify:

- [ ] Only editing files in `claude/personal/`
- [ ] NOT editing `~/.claude/work/CLAUDE.md` in dotfiles
- [ ] Run `git status` to see what will be committed
- [ ] Run `git diff --cached` to review changes

## 💡 Pro Tips

### Use Makefile (if available)

If your shell is configured:

```bash
make claude-config   # Rebuild
make claude-setup    # First-time setup
```

### Alias the Build Command

Add to your `.zshrc` or `.bashrc`:

```bash
alias claude-rebuild='DOTFILES_DIR=~/.dotfiles bash ~/.dotfiles/claude/build-claude-config.sh'
```

Then just:

```bash
claude-rebuild
```

### Auto-rebuild on Save

Use `entr` to watch for changes:

```bash
# In one terminal
echo ~/.dotfiles/claude/personal/CLAUDE.md ~/.claude/work/CLAUDE.md | \
  entr -n DOTFILES_DIR=~/.dotfiles bash ~/.dotfiles/claude/build-claude-config.sh
```

---

**See [README.md](./README.md) for full documentation.**
