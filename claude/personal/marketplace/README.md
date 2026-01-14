# Personal Tools Marketplace

A local Claude Code marketplace containing personal commands, skills, and agents for daily development work.

## 📦 What's Included

### Commands

- **`/git-cleanup`** - Clean up merged git branches locally and remotely
  - Safely removes merged branches
  - Protects main/master/develop branches
  - Supports `--dry-run` for preview

### Skills

- **`cli-expert`** - Command-line interface and shell scripting expertise
  - Zsh configuration and scripting (specialty)
  - Bash scripting best practices
  - Modern CLI tools (eza, bat, fd, rg, fzf)
  - Terminal workflows and tmux
  - Performance optimization
  - Auto-activates when working with shell scripts or CLI tools

- **`neovim-expert`** - Neovim configuration and Lua scripting
  - Modern Neovim configuration with Lua
  - Plugin management (lazy.nvim)
  - LSP setup and configuration
  - Completion with nvim-cmp
  - Plugin development
  - Performance optimization
  - Auto-activates when working with Neovim configs or plugins

### Agents

- **`@docs-writer`** - Technical documentation writer
  - Creates README files
  - Documents APIs
  - Writes setup instructions
  - Generates architecture docs
  - Follows professional documentation standards

## 🚀 Installation

### Method 1: From Dotfiles (Recommended)

If this marketplace is in your dotfiles at `~/.dotfiles/claude/personal/marketplace`:

```bash
# Add the marketplace
/plugin marketplace add ~/.dotfiles/claude/personal/marketplace

# Install the plugin
/plugin install personal-tools@personal-tools
```

### Method 2: From Current Directory

```bash
cd ~/.dotfiles/claude/personal/marketplace
/plugin marketplace add .
/plugin install personal-tools@personal-tools
```

### Verify Installation

```bash
# Check installed plugins
/plugin

# List available commands
/help

# You should see:
# - /personal-tools:git-cleanup
```

## 📖 Usage

### Using Commands

Commands are invoked with `/` prefix:

```bash
# Preview what would be deleted
/personal-tools:git-cleanup --dry-run

# Actually clean up branches
/personal-tools:git-cleanup
```

**Note:** Commands are namespaced by plugin name. If you want a shorter name, you can create a wrapper command in your personal commands directory.

### Using Skills

Skills activate automatically based on context:

```
You: How should I structure my zsh configuration files?
Claude: [dotfiles-expert skill activates automatically]
        [Provides expert advice on zsh structure]
```

### Using Agents

Agents are invoked with `@` prefix:

```
@docs-writer create a README for this project
@docs-writer document the API endpoints
@docs-writer write setup instructions for this tool
```

## 🔄 Updating

### Manual Update

```bash
cd ~/.dotfiles
git pull  # Pull latest marketplace changes

# Reload in Claude Code
/plugin marketplace refresh personal-tools
```

### Future: Automatic Updates

Claude Code supports automatic marketplace updates. Enable with:

```bash
export FORCE_AUTOUPDATE_PLUGINS=true
```

## 🛠️ Customization

### Adding Your Own Items

1. **Add a command:**
   ```bash
   cd ~/.dotfiles/claude/personal/marketplace/plugins/personal-tools
   cat > commands/my-command.md <<'EOF'
   ---
   description: What my command does
   ---
   # My Command
   Instructions for Claude...
   EOF
   ```

2. **Add a skill:**
   ```bash
   mkdir -p skills/my-skill
   cat > skills/my-skill/SKILL.md <<'EOF'
   ---
   name: my-skill
   description: When to activate this skill
   ---
   # My Skill
   Expert knowledge...
   EOF
   ```

3. **Add an agent:**
   ```bash
   mkdir -p agents/my-agent
   cat > agents/my-agent/AGENT.md <<'EOF'
   ---
   name: my-agent
   description: What this agent does
   ---
   # My Agent
   Specialized behavior...
   EOF
   ```

4. **Reload the plugin:**
   ```bash
   /plugin marketplace refresh personal-tools
   ```

### Modifying Existing Items

Edit the files in `plugins/personal-tools/` and reload:

```bash
vim commands/git-cleanup.md
/plugin marketplace refresh personal-tools
```

## 📁 Structure

```
marketplace/
├── README.md                           # This file
├── .claude-plugin/
│   └── marketplace.json                # Marketplace metadata
└── plugins/
    └── personal-tools/
        ├── .claude-plugin/
        │   └── plugin.json             # Plugin metadata
        ├── commands/
        │   └── git-cleanup.md          # Slash command
        ├── skills/
        │   └── dotfiles-expert/
        │       └── SKILL.md            # Skill definition
        └── agents/
            └── docs-writer/
                └── AGENT.md            # Agent definition
```

## 🔗 Integration with Build Script

This marketplace works **alongside** the Claude configuration framework:

1. **Build script handles:**
   - CLAUDE.md merging (personal + work)
   - Simple commands/skills in `claude/personal/commands` and `claude/personal/skills`

2. **Marketplace handles:**
   - More complex plugins
   - Agents (not supported by build script)
   - Versioned, distributable tools

**You can use both!** The build script and marketplace complement each other.

## 🆘 Troubleshooting

### Commands Not Showing

1. **Verify installation:**
   ```bash
   /plugin
   # Should show "personal-tools" in installed list
   ```

2. **Check marketplace:**
   ```bash
   /plugin marketplace list
   # Should show "personal-tools"
   ```

3. **Reload:**
   ```bash
   /plugin marketplace refresh personal-tools
   ```

### Skills Not Activating

- Skills activate based on the `description` field in `SKILL.md`
- Make sure the description clearly states when to activate
- Skills are automatic - you don't invoke them directly

### Agents Not Available

- Agents use `@` prefix: `@docs-writer`
- Check the agent name matches the `name` field in `AGENT.md`
- Reload the plugin if you just added the agent

## 📚 Resources

- [Claude Code Plugin Documentation](https://code.claude.com/docs/en/plugins-reference)
- [Marketplace Documentation](https://code.claude.com/docs/en/plugin-marketplaces)
- [Main Claude Framework README](../../README.md)

## 🔐 Privacy

This marketplace is **local only**:
- Not published to any central registry
- Lives in your dotfiles
- Syncs with your dotfiles via git
- Safe to include personal preferences and workflows

---

**Part of the [Claude Configuration Framework](../../README.md)**
