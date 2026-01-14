# Claude AI Configuration Framework

This directory contains a framework for managing personal and work Claude AI configurations, commands, and skills separately, with safeguards to prevent accidental commits of work-related content.

## 🎯 Goals

1. **Version control personal AI guidance** - Commit your personal CLAUDE.md, commands, and skills to dotfiles
2. **Incorporate work AI guidance** - Merge work-provided configs without tracking them
3. **Prevent exposure** - Multiple safeguards against accidentally committing work content
4. **Subordinate by design** - Doesn't assume ownership of `~/.claude/`, plays nice with work tooling

## ✨ Features

- **CLAUDE.md**: Personal + work AI configuration merged
- **Commands**: Personal + work slash commands installed via symlinks
- **Skills**: Personal + work skills installed via symlinks
- **Safety**: Multiple layers prevent accidental work content commits
- **Flexibility**: Works standalone or with work-provided tooling

## 📁 Directory Structure

```
dotfiles/claude/
├── README.md                         # This file
├── COMMANDS-AND-SKILLS.md            # Commands/skills guide
├── build-claude-config.sh            # Build script (merges & installs)
├── personal/                         # YOUR personal configs (COMMITTED)
│   ├── CLAUDE.md                     # AI guidelines
│   ├── commands/                     # Slash commands
│   │   └── example.md
│   └── skills/                       # Skills
│       └── example-skill/
│           └── SKILL.md
└── work-template/                    # Templates (COMMITTED)
    ├── CLAUDE.md                     # Work config template
    ├── commands/                     # Work commands template
    └── skills/                       # Work skills template

~/.claude/                            # Runtime directory (NOT in dotfiles)
├── CLAUDE.md                         # Generated (personal + work merged)
├── commands/                         # Generated (symlinks)
│   ├── example.md                    → dotfiles/claude/personal/commands/example.md
│   └── work-cmd.md                   → ~/.claude/work/commands/work-cmd.md
├── skills/                           # Generated (symlinks)
│   ├── example-skill/                → dotfiles/claude/personal/skills/example-skill/
│   └── work-skill/                   → ~/.claude/work/skills/work-skill/
└── work/                             # Work configs (NOT COMMITTED, gitignored)
    ├── CLAUDE.md                     # Work AI guidelines
    ├── commands/                     # Work commands
    └── skills/                       # Work skills
```

## 🚀 Setup

### Initial Setup

```bash
cd ~/.dotfiles
make claude-setup
```

This will:
1. Create `~/.claude/work/` directory
2. Copy the work template to `~/.claude/work/CLAUDE.md`
3. Build the merged `~/.claude/CLAUDE.md`

### Customize Your Personal Config

Edit your personal AI guidelines:

```bash
vim ~/.dotfiles/claude/personal/CLAUDE.md
make claude-config  # Rebuild
```

### Add Work-Specific Guidelines

Edit work guidelines (this file is gitignored):

```bash
vim ~/.claude/work/CLAUDE.md
make claude-config  # Rebuild
```

### Managing Commands and Skills

The framework also manages slash commands and skills:

**Personal commands** (tracked in git):
```bash
# Create a command
cat > ~/.dotfiles/claude/personal/commands/my-cmd.md <<'EOF'
---
description: What this command does
---
# My Command
Instructions for Claude...
EOF

# Install
make claude-config

# Use in Claude Code
/my-cmd
```

**Personal skills** (tracked in git):
```bash
# Create a skill
mkdir -p ~/.dotfiles/claude/personal/skills/my-skill
cat > ~/.dotfiles/claude/personal/skills/my-skill/SKILL.md <<'EOF'
---
name: my-skill
description: When to activate this skill
---
# My Skill
Knowledge for Claude...
EOF

# Install
make claude-config
```

**Work commands/skills** (gitignored):
```bash
# Add to ~/.claude/work/commands/ and ~/.claude/work/skills/
# They'll be installed alongside personal ones
make claude-config
```

📖 **See [COMMANDS-AND-SKILLS.md](./COMMANDS-AND-SKILLS.md) for complete documentation.**

## 🔒 Safety Features

This framework has **multiple layers** of protection against accidentally committing work content:

### 1. Directory Separation
- Personal config: `dotfiles/claude/personal/` (tracked)
- Work config: `~/.claude/work/` (untracked, outside dotfiles)

### 2. Git Safeguards

**.gitignore** excludes:
```gitignore
claude/work/*           # Any work files accidentally copied here
!claude/work-template/  # Except the template
dot-claude/             # Alternative naming
.claude/                # Hidden directory
```

### 3. Stow Exclusion

`.stow-local-ignore` prevents Stow from symlinking the `claude/` directory:
```
^/claude
```

### 4. Visual Warnings

Work template contains prominent warnings:
```markdown
⚠️ NEVER commit this file to your personal dotfiles!
⚠️ This file may contain company-specific information.
```

### 5. Build-Time Safety

The build script:
- Reads personal config from dotfiles (safe)
- Reads work config from `~/.claude/work/` (outside git)
- Generates output to `~/.claude/CLAUDE.md` (outside git)

## 🔄 Workflow

### Daily Usage

```bash
# Edit personal guidelines
vim ~/.dotfiles/claude/personal/CLAUDE.md

# Edit work guidelines
vim ~/.claude/work/CLAUDE.md

# Rebuild merged config
make claude-config
```

### Work Provides Config

If your work provides a `CLAUDE.md`:

```bash
# Option 1: Copy it
cp /path/to/work/CLAUDE.md ~/.claude/work/CLAUDE.md
make claude-config

# Option 2: Symlink it (subordinate pattern)
ln -sf /path/to/work/CLAUDE.md ~/.claude/work/CLAUDE.md
make claude-config

# Option 3: Set custom path
CLAUDE_WORK_DIR=/path/to/work make claude-config
```

### Committing Changes

Only commit changes to files in `dotfiles/claude/personal/`:

```bash
cd ~/.dotfiles
git add claude/personal/CLAUDE.md
git commit -m "Update personal AI guidelines"
```

Work config in `~/.claude/work/` is **never** tracked by git.

## 🛡️ How It Prevents Accidental Commits

**Scenario**: You accidentally copy a work file into your dotfiles

```bash
# ❌ Accident: copied work file into dotfiles
cp ~/.claude/work/CLAUDE.md ~/dotfiles/claude/work/my-work.md

# ✅ Protected: Git ignores it
git status  # Won't show claude/work/my-work.md

# ✅ Protected: Even if you force-add it...
git add -f claude/work/my-work.md  # Still won't work due to .gitignore
```

**Scenario**: Work MDM overwrites `~/.claude/CLAUDE.md`

```bash
# ❌ Work MDM drops their config
# This overwrites your generated file

# ✅ Solution: Just rebuild
make claude-config  # Regenerates your merged config
```

## 🏢 Subordinate Design

This framework is designed to be **subordinate** to work tooling:

1. **Doesn't own `~/.claude/`** - Work tools can manage this directory
2. **Doesn't require work tools to integrate** - Works independently
3. **Non-invasive rebuild** - `make claude-config` regenerates your config
4. **Flexible work config location** - Use `CLAUDE_WORK_DIR` environment variable

### Example: Work MDM Management

If your work MDM manages Claude config:

```bash
# Work MDM might do:
# cp /corporate/ai-policy.md ~/.claude/CLAUDE.md

# You can still layer your personal config on top:
# 1. Let work MDM run first
# 2. Then append your personal config
cat ~/.dotfiles/claude/personal/CLAUDE.md >> ~/.claude/CLAUDE.md

# Or incorporate their config into your build:
ln -sf ~/.claude/CLAUDE.md ~/.claude/work/corporate-policy.md
make claude-config
```

## 🔧 Advanced Usage

### Environment Variables

- `DOTFILES_DIR`: Override dotfiles location (default: `$HOME/.dotfiles`)
- `CLAUDE_WORK_DIR`: Override work config location (default: `$HOME/.claude/work`)

Example:

```bash
CLAUDE_WORK_DIR=/corporate/ai-policies make claude-config
```

### Multiple Work Contexts

If you work with multiple companies:

```bash
# Company A
CLAUDE_WORK_DIR=~/.claude/work-companyA make claude-config

# Company B
CLAUDE_WORK_DIR=~/.claude/work-companyB make claude-config
```

### CI/CD Integration

Add to your dotfiles CI:

```yaml
- name: Validate Claude config
  run: |
    ./claude/build-claude-config.sh
    # Verify no work files were committed
    ! git ls-files | grep -q "claude/work/"
```

## 📝 Maintenance

### Update Personal Config

```bash
vim ~/.dotfiles/claude/personal/CLAUDE.md
make claude-config
git add claude/personal/CLAUDE.md
git commit -m "docs: update AI coding preferences"
```

### Sync Across Machines

Personal config syncs automatically via dotfiles:

```bash
# On machine A
git push

# On machine B
git pull
make claude-config  # Rebuild with machine B's work config
```

## ❓ FAQ

**Q: Can I commit hooks or other Claude artifacts?**

A: Yes! Add them to `claude/personal/`. Update the build script to copy them:

```bash
# In build-claude-config.sh
cp "$DOTFILES_DIR/claude/personal/hooks/"* "$CLAUDE_DIR/hooks/"
```

**Q: What if work requires a specific CLAUDE.md?**

A: Use the subordinate pattern:

```bash
# Let work tooling write ~/.claude/CLAUDE.md
# Then extend it:
echo -e "\n\n# Personal Extensions\n" >> ~/.claude/CLAUDE.md
cat ~/.dotfiles/claude/personal/CLAUDE.md >> ~/.claude/CLAUDE.md
```

**Q: Can I see what's in the merged config?**

A: Yes:

```bash
cat ~/.claude/CLAUDE.md
# Or
make claude-config  # Shows line counts
```

**Q: What if I accidentally commit work content?**

A: Multiple safeguards prevent this:
1. `.gitignore` blocks work files
2. Work config lives outside dotfiles
3. Build script only reads from outside git

If it somehow happens:

```bash
git rm --cached claude/work/leaked-file.md
git commit --amend
```

## 🤝 Contributing

Improvements welcome! This framework can be enhanced with:
- [ ] Hook management
- [ ] Skill/command templates
- [ ] Auto-rebuild on file changes
- [ ] Integration with other AI tools (Cursor, GitHub Copilot)

---

**Remember**: Personal config is tracked, work config is not. When in doubt, `git status` will show you what's staged.
