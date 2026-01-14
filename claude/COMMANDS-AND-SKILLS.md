# Commands and Skills Management

This guide explains how to safely manage personal and work Claude Code commands and skills using the same framework principles as CLAUDE.md.

## 📁 Directory Structure

```
dotfiles/claude/
├── personal/
│   ├── commands/          ← Your personal slash commands (COMMITTED)
│   │   ├── example.md
│   │   └── my-command.md
│   └── skills/            ← Your personal skills (COMMITTED)
│       ├── example-skill/
│       │   └── SKILL.md
│       └── my-skill/
│           ├── SKILL.md
│           └── templates/
│
└── work-template/
    ├── commands/          ← Template for work commands (template committed)
    │   └── README.md
    └── skills/            ← Template for work skills (template committed)
        └── README.md

~/.claude/
├── commands/              ← Generated (symlinks from personal + work)
│   ├── example.md        → ~/dotfiles/claude/personal/commands/example.md
│   └── work-cmd.md       → ~/.claude/work/commands/work-cmd.md
│
├── skills/                ← Generated (symlinks from personal + work)
│   ├── example-skill/    → ~/dotfiles/claude/personal/skills/example-skill/
│   └── work-skill/       → ~/.claude/work/skills/work-skill/
│
└── work/
    ├── commands/          ← Work commands (NOT COMMITTED, gitignored)
    │   └── work-cmd.md
    └── skills/            ← Work skills (NOT COMMITTED, gitignored)
        └── work-skill/
            └── SKILL.md
```

## 🚀 Quick Start

### Creating Personal Commands

1. Create a new Markdown file in `claude/personal/commands/`:

```bash
cd ~/.dotfiles
cat > claude/personal/commands/my-command.md <<'EOF'
---
description: Brief description of what this command does
---

# My Command

Instructions for Claude when this command is invoked.

When you run `/my-command`, Claude will follow these instructions.
EOF
```

2. Install it:

```bash
make claude-config  # or: DOTFILES_DIR=~/.dotfiles bash ./claude/build-claude-config.sh
```

3. Use it in Claude Code:

```
/my-command
```

4. Commit to dotfiles:

```bash
git add claude/personal/commands/my-command.md
git commit -m "Add my-command slash command"
```

### Creating Personal Skills

1. Create a skill directory with SKILL.md:

```bash
cd ~/.dotfiles
mkdir -p claude/personal/skills/my-skill
cat > claude/personal/skills/my-skill/SKILL.md <<'EOF'
---
name: my-skill
description: When to activate this skill (used by Claude for auto-activation)
---

# My Skill

Knowledge and instructions that Claude should use when this skill is active.

Skills are automatically activated based on the `description` field matching the user's request.
EOF
```

2. Add supporting files (optional):

```bash
# Templates, examples, etc.
echo "// Template code" > claude/personal/skills/my-skill/template.js
```

3. Install it:

```bash
make claude-config
```

4. Commit to dotfiles:

```bash
git add claude/personal/skills/my-skill/
git commit -m "Add my-skill"
```

## 🏢 Managing Work Commands/Skills

### Setup Work Directories

```bash
# Create work directories (one-time setup)
mkdir -p ~/.claude/work/commands
mkdir -p ~/.claude/work/skills
```

### Adding Work Commands

```bash
# Add work-provided commands
cp /path/to/work/command.md ~/.claude/work/commands/

# Or create your own work-specific commands
cat > ~/.claude/work/commands/deploy.md <<'EOF'
---
description: Deploy application to company infrastructure
---

# Deploy Command

[Company-specific deployment instructions]
EOF

# Install
make claude-config
```

### Adding Work Skills

```bash
# Create work skill
mkdir -p ~/.claude/work/skills/company-standards
cat > ~/.claude/work/skills/company-standards/SKILL.md <<'EOF'
---
name: company-standards
description: Company coding standards and architectural patterns
---

# Company Standards

[Company-specific guidelines]
EOF

# Install
make claude-config
```

### Safety Guarantees

Work commands/skills are **automatically protected** from being committed:

1. **Location**: `~/.claude/work/` (outside git)
2. **.gitignore**: Blocks `claude/work/*` (except template)
3. **Build script**: Only symlinks from outside git

## 📝 Command Syntax

### Basic Command

```markdown
---
description: Brief description for /help output
---

# Command Title

Instructions for Claude...
```

### Advanced Command Options

```markdown
---
description: Advanced command with options
allowed-tools:
  - Bash(git:*)     # Allow only git commands
  - Read            # Allow reading files
argument-hint: "[branch-name] [message]"
model: claude-opus-4-5-20251101
---

# Advanced Command

Instructions...
```

**Available Options:**

- `description` - Brief description (shown in `/help`)
- `allowed-tools` - Restrict which tools Claude can use
- `argument-hint` - Hint for expected arguments
- `model` - Specific Claude model to use
- `hooks` - PreToolUse, PostToolUse, or Stop handlers
- `disable-model-invocation` - Prevent programmatic invocation

## 🎯 Skill Syntax

### Basic Skill

```markdown
---
name: skill-identifier
description: When Claude should activate this skill
---

# Skill Title

Knowledge and instructions...
```

### Skill with Supporting Files

```
my-skill/
├── SKILL.md
├── examples/
│   ├── example1.js
│   └── example2.js
├── templates/
│   └── template.md
└── docs/
    └── detailed-guide.md
```

All files in the skill directory are available when the skill is active.

## 🔄 Workflow Examples

### Daily Development

```bash
# Edit personal command
vim ~/.dotfiles/claude/personal/commands/review.md

# Install and test
make claude-config
# Use /review in Claude Code to test

# Commit when satisfied
git add claude/personal/commands/review.md
git commit -m "Update review command"
```

### Work-Specific Workflow

```bash
# Edit work command (gitignored)
vim ~/.claude/work/commands/company-deploy.md

# Install
make claude-config

# Use /company-deploy in Claude Code
# No git commit needed - stays local!
```

### Syncing Across Machines

```bash
# Machine A: Create and commit
cd ~/.dotfiles
echo "..." > claude/personal/commands/new-cmd.md
git commit -am "Add new command"
git push

# Machine B: Sync and install
cd ~/.dotfiles
git pull
make claude-config  # Installs personal commands + local work commands
```

## ⚔️ Conflict Resolution

If personal and work have commands/skills with the same name:

**Personal wins!** The build script prioritizes personal commands/skills.

```bash
# If both exist:
# ~/dotfiles/claude/personal/commands/deploy.md     ← Wins
# ~/.claude/work/commands/deploy.md                  ← Ignored (with warning)

# Output:
⚠ WARNING: Work command 'deploy.md' conflicts with personal command (keeping personal)
```

**Resolution Options:**

1. **Rename work command**: `deploy.md` → `work-deploy.md`
2. **Rename personal command**: If work command should take priority
3. **Remove duplicate**: Delete one of them

## 🔍 Inspecting Installed Commands/Skills

### List All Commands

```bash
ls -la ~/.claude/commands/
```

### List All Skills

```bash
ls -la ~/.claude/skills/
```

### Show Command/Skill Source

```bash
# Where does this command come from?
readlink ~/.claude/commands/my-command.md

# Where does this skill come from?
readlink ~/.claude/skills/my-skill
```

### View in Claude Code

```
/help  # Shows all available commands
```

## 🛠️ Advanced Techniques

### Namespacing Commands

Group related commands in subdirectories (in your personal directory):

```
claude/personal/commands/
├── docker/
│   ├── build.md
│   ├── deploy.md
│   └── logs.md
└── git/
    ├── cleanup.md
    └── sync.md
```

**Note**: Subdirectories don't affect the command name. `docker/build.md` becomes `/build`, not `/docker-build`.

### Shared Skill Resources

Create a skill with shared templates:

```
claude/personal/skills/testing/
├── SKILL.md
├── templates/
│   ├── unit-test.js
│   ├── integration-test.js
│   └── e2e-test.js
└── examples/
    └── mock-examples.md
```

Reference templates in SKILL.md:

```markdown
## Test Templates

See the templates/ directory for:
- unit-test.js: Standard unit test structure
- integration-test.js: Integration test pattern
- e2e-test.js: End-to-end test setup
```

### Dynamic Commands with Arguments

```markdown
---
description: Create a new component with boilerplate
argument-hint: "[component-name]"
---

# Component Generator

When invoked with a component name, generate:

1. Component file: `components/{name}.tsx`
2. Test file: `components/{name}.test.tsx`
3. Story file: `components/{name}.stories.tsx`

Use the component name provided by the user.
```

### Conditional Work Integration

If work provides commands via a different system, link them:

```bash
# Link work-provided commands
ln -s /company/claude/commands/* ~/.claude/work/commands/

# Rebuild to install
make claude-config
```

## 📊 Verification

### Test Command Installation

```bash
# Build with verbose output
DOTFILES_DIR=~/.dotfiles bash ./claude/build-claude-config.sh

# Check output:
# ✓ Installed 3 personal command(s)
# ✓ Installed 2 work command(s)
# Total: 5
```

### Test in Claude Code

```
/help

# Should show:
# Available commands:
#   /example - Example personal slash command
#   /my-command - My custom command
#   /work-deploy - Work deployment command
```

### Verify Git Safety

```bash
cd ~/.dotfiles
git status

# Should show:
# Changes to be committed:
#   modified:   claude/personal/commands/example.md  ← Safe
#
# Should NOT show:
#   ~/.claude/work/commands/                          ← Correctly ignored
```

## 🆘 Troubleshooting

### Commands Not Showing in `/help`

1. **Verify installation:**
   ```bash
   ls -la ~/.claude/commands/
   # Should show symlinks to your commands
   ```

2. **Check file format:**
   - Must be `.md` files
   - Must have valid frontmatter (optional but recommended)

3. **Reload Claude Code:**
   - Restart Claude Code session
   - Commands are loaded at startup

### Skills Not Activating

1. **Check `description` field:**
   - Must be present in SKILL.md frontmatter
   - Should clearly describe when to activate
   - Claude uses this for auto-activation

2. **Verify SKILL.md exists:**
   ```bash
   ls ~/.claude/skills/my-skill/SKILL.md
   ```

3. **Check symlink:**
   ```bash
   readlink ~/.claude/skills/my-skill
   # Should point to your personal or work skill directory
   ```

### Conflicts Between Personal and Work

```bash
# List all commands with sources
for cmd in ~/.claude/commands/*; do
    echo "$cmd -> $(readlink "$cmd")"
done

# List all skills with sources
for skill in ~/.claude/skills/*; do
    echo "$skill -> $(readlink "$skill")"
done
```

### Work Commands Accidentally Committed

If you somehow committed work content:

```bash
cd ~/.dotfiles
git rm --cached claude/work/leaked-file.md
git commit --amend -m "Remove accidentally committed work file"
git push --force  # Only if you haven't shared this commit
```

**Prevention**: Multiple gitignore rules prevent this.

## 💡 Best Practices

### For Personal Commands/Skills

1. **Keep them general** - Don't include company-specific info
2. **Document well** - You'll forget what they do
3. **Test before committing** - Make sure they work
4. **Use meaningful names** - `/deploy` is clearer than `/d`

### For Work Commands/Skills

1. **Keep work stuff in `~/.claude/work/`** - Never in dotfiles
2. **Link don't copy** - If work provides files, symlink them
3. **Document locally** - Add README in `~/.claude/work/`
4. **Namespace if needed** - Prefix with `work-` to avoid conflicts

### For Both

1. **Run `make claude-config` after changes** - Don't forget to install
2. **Use `description` field** - Makes commands discoverable
3. **Keep it simple** - Commands should do one thing well
4. **Version control personal only** - Never commit work stuff

## 📚 Examples

### Example: Project Scaffolding Command

```markdown
---
description: Create a new React component with tests and stories
argument-hint: "[ComponentName]"
allowed-tools:
  - Write
  - Read
---

# Create Component

Create a new React component with:
1. Component file in `src/components/`
2. Test file with basic tests
3. Storybook story
4. Export from index

Use TypeScript and functional components.
Follow project conventions for testing.
```

### Example: Documentation Skill

```
docs-skill/
├── SKILL.md
├── templates/
│   ├── api-doc.md
│   ├── readme-template.md
│   └── architecture.md
└── style-guide.md
```

**SKILL.md:**
```markdown
---
name: documentation
description: Writing and maintaining project documentation
---

# Documentation Skill

When writing documentation, follow these principles:

## Structure
- README: What, why, how to install, how to use
- API docs: Endpoints, parameters, examples
- Architecture: System design, data flow, decisions

## Style
- Write in present tense
- Use code examples
- Keep it up to date with code changes

## Templates
See templates/ directory for standard formats.
```

---

**Related Documentation:**
- [README.md](./README.md) - Main framework documentation
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Technical design
- [QUICKSTART.md](./QUICKSTART.md) - Quick reference
