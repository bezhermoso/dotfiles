# Personal AI Assistant Guidelines

> **Note**: This is my personal configuration for AI coding assistants.
> Work-specific guidelines are managed separately and merged at build time.

## Code Style & Preferences

### General Principles
- Prefer explicit over implicit
- Favor composition over inheritance
- Keep functions small and focused
- Write self-documenting code; add comments only when the "why" isn't obvious

### Language-Specific Preferences

#### Python
- Use type hints for function signatures
- Follow PEP 8 style guide
- Prefer f-strings for string formatting
- Use dataclasses for simple data containers

#### JavaScript/TypeScript
- Use modern ES6+ syntax
- Prefer `const` over `let`, avoid `var`
- Use async/await over raw promises
- Prefer functional patterns (map, filter, reduce) over imperative loops

#### Shell Scripts
- Use `set -euo pipefail` for safety
- Quote variables to prevent word splitting
- Prefer `[[ ]]` over `[ ]` in bash

## Testing Philosophy
- Write tests for business logic and complex algorithms
- Don't over-test trivial getters/setters
- Prefer integration tests over unit tests when both provide similar value
- Test behavior, not implementation details

## Documentation
- README should cover: what, why, how to install, how to use
- Don't create unnecessary documentation files
- Code comments should explain "why", not "what"
- Keep docs close to code (prefer inline docs)

## Git Practices
- Write meaningful commit messages (imperative mood)
- Prefer atomic commits that do one thing well
- Squash fixup commits before pushing
- Don't commit commented-out code; that's what git history is for

## Tools I Use
- Editor: Neovim
- Shell: Zsh with custom keybindings
- Terminal: Various (check my dotfiles for current setup)
- Version Control: Git with custom aliases

## Work Context
<!-- Work-specific guidelines will be injected here during build -->
<!-- See ~/.claude/work/CLAUDE.md for work configuration -->
