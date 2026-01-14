SHELL = /bin/zsh
HOSTNAME := $(shell hostname -s)

npm-inventory:
	bash languages/nodejs/inventory.sh | tee languages/nodejs/install-npm-globals.sh

pip-inventory:
	bash languages/python/inventory.sh | tee languages/python/install-pip-globals.sh

gem-inventory:
	bash languages/ruby/inventory.sh | tee languages/ruby/install-gem-globals.sh

.ONESHELL:
brewfile:
	@bash -c 'mkdir homebrew/"$(HOSTNAME)"; cd homebrew/"$(HOSTNAME)"; rm Brewfile; brew bundle dump'

terminfo:
	# See https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
	# This script automates the whole process:
	brew install ncurses
	$$(brew --prefix ncurses)/bin/infocmp -x tmux-256color | \
		sed -E 's/pairs#(0x10000|65536)/pairs#32767/' | \
		tic -x -o terminfo -

.PHONY: ssh_fallback
ssh_fallback: ~/.ssh/id_rsa_fallback

# Reads fallback SSH key from 1Password vault and drop it in ~/.ssh/id_rsa_fallback
~/.ssh/id_rsa_fallback:
	op item get lgukbustpzevs7g5osdyqeyqf4 \
		--format json \
		--fields 'label=private key' \
		--reveal \
		| jq -r '.ssh_formats.openssh.value' \
		| sed 's#\r##' > ~/.ssh/id_rsa_fallback
	chmod 0700 ~/.ssh/id_rsa_fallback

image-2-ascii-converter:
	go install github.com/TheZoraiz/ascii-image-converter@latest

gh-extensions:
	gh extension install dlvhdr/gh-dash
	gh extension install yusukebe/gh-markdown-preview
	gh extension install gennaro-tedesco/gh-f

# Zsh bytecode compilation
.PHONY: compile-zsh
compile-zsh:
	@./scripts/compile-zsh.sh

# Install LaunchAgent for daily zsh recompilation (idempotent)
.PHONY: install-launchagent
install-launchagent:
	@echo "📦 Installing LaunchAgent for daily zsh recompilation..."
	@mkdir -p ~/Library/LaunchAgents
	@cp -f launchagents/com.user.zsh-recompile.plist ~/Library/LaunchAgents/
	@launchctl unload ~/Library/LaunchAgents/com.user.zsh-recompile.plist 2>/dev/null || true
	@launchctl load ~/Library/LaunchAgents/com.user.zsh-recompile.plist
	@echo "✅ LaunchAgent installed (runs daily at 9am)"

# Configure git to use custom hooks directory (idempotent)
.PHONY: install-git-hooks
install-git-hooks:
	@echo "🔧 Configuring git hooks..."
	@git config core.hooksPath .githooks
	@chmod +x .githooks/pre-commit
	@echo "✅ Git hooks configured (pre-commit will recompile changed .zsh files)"

# Setup all zsh compilation automation (idempotent)
.PHONY: setup-zsh
setup-zsh: compile-zsh install-launchagent install-git-hooks
	@echo ""
	@echo "🎉 Zsh compilation automation complete!"
	@echo ""
	@echo "  • Manual: make compile-zsh"
	@echo "  • Daily: LaunchAgent at 9am"
	@echo "  • On commit: Git pre-commit hook"
	@echo ""

# Claude AI configuration management
.PHONY: claude-config
claude-config:
	@./claude/build-claude-config.sh

.PHONY: claude-setup
claude-setup:
	@echo "🤖 Setting up Claude AI configuration..."
	@mkdir -p ~/.claude/work
	@if [ ! -f ~/.claude/work/CLAUDE.md ]; then \
		echo "📝 Creating work CLAUDE.md template..."; \
		cp claude/work-template/CLAUDE.md ~/.claude/work/CLAUDE.md; \
		echo "⚠️  Edit ~/.claude/work/CLAUDE.md with work-specific guidelines"; \
	else \
		echo "✓ Work CLAUDE.md already exists"; \
	fi
	@$(MAKE) claude-config
	@echo ""
	@echo "✅ Claude configuration complete!"
	@echo ""
	@echo "  Personal config: ./claude/personal/CLAUDE.md"
	@echo "  Work config:     ~/.claude/work/CLAUDE.md"
	@echo "  Generated:       ~/.claude/CLAUDE.md"
	@echo ""
	@echo "💡 Run 'make claude-config' to rebuild after editing"
	@echo ""

