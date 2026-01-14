# Architecture

## Directory Layout

```
┌─────────────────────────────────────────────────────────────┐
│ ~/.dotfiles/  (Git Repository - Committed)                   │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  claude/                                                      │
│  ├── README.md              ← Full documentation             │
│  ├── QUICKSTART.md          ← Quick reference                │
│  ├── ARCHITECTURE.md        ← This file                      │
│  ├── build-claude-config.sh ← Build script                   │
│  │                                                            │
│  ├── personal/              ← YOUR personal config           │
│  │   └── CLAUDE.md          ← ✅ COMMITTED to git            │
│  │                                                            │
│  └── work-template/         ← Template for work config       │
│      └── CLAUDE.md          ← ✅ COMMITTED (template only)   │
│                                                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ ~/.claude/  (Runtime Directory - NOT in Git)                 │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ├── CLAUDE.md              ← ⚙️  GENERATED (do not edit)    │
│  │                                                            │
│  ├── work/                  ← Work-specific config           │
│  │   └── CLAUDE.md          ← ❌ NOT COMMITTED (gitignored)  │
│  │                                                            │
│  └── [other runtime files]  ← Claude runtime artifacts       │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                        BUILD PROCESS                             │
└──────────────────────────────────────────────────────────────────┘

Input Files:                          Output:
┌─────────────────┐                   ┌──────────────────┐
│ Personal Config │                   │                  │
│ (dotfiles)      │─────┐             │  ~/.claude/      │
│                 │     │             │  CLAUDE.md       │
│ ✅ In Git       │     │             │                  │
└─────────────────┘     │             │  ⚙️  Generated   │
                        ├────────────→│                  │
┌─────────────────┐     │             │  ❌ Not in Git   │
│ Work Config     │     │             │                  │
│ (outside git)   │─────┘             └──────────────────┘
│                 │
│ ❌ Not in Git   │           ^
└─────────────────┘           │
                              │
                    ┌─────────────────┐
                    │ build-claude-   │
                    │ config.sh       │
                    └─────────────────┘
```

## Safety Layers

```
┌──────────────────────────────────────────────────────────────────┐
│            PROTECTION AGAINST ACCIDENTAL COMMITS                 │
└──────────────────────────────────────────────────────────────────┘

Layer 1: Directory Separation
┌─────────────────────────────────────────────────────────────────┐
│ Personal: ~/.dotfiles/claude/personal/  (in git)                │
│ Work:     ~/.claude/work/               (outside git)           │
└─────────────────────────────────────────────────────────────────┘
         Physical separation = Safe

Layer 2: .gitignore Rules
┌─────────────────────────────────────────────────────────────────┐
│ claude/work/*          ← Blocks work files in dotfiles          │
│ !claude/work-template/ ← Allows template only                   │
│ .claude/               ← Blocks entire ~/.claude if linked      │
└─────────────────────────────────────────────────────────────────┘
         Git-level protection = Safe

Layer 3: .stow-local-ignore
┌─────────────────────────────────────────────────────────────────┐
│ ^/claude               ← Stow doesn't symlink claude/ dir       │
└─────────────────────────────────────────────────────────────────┘
         No accidental symlinks = Safe

Layer 4: Build Script Design
┌─────────────────────────────────────────────────────────────────┐
│ • Reads from ~/.dotfiles/claude/personal/ (safe, tracked)       │
│ • Reads from ~/.claude/work/ (safe, outside git)                │
│ • Writes to ~/.claude/CLAUDE.md (safe, outside git)             │
│ • Never writes to dotfiles repo                                 │
└─────────────────────────────────────────────────────────────────┘
         No write to git = Safe

Layer 5: Visual Warnings
┌─────────────────────────────────────────────────────────────────┐
│ Work template contains:                                          │
│ ⚠️  NEVER commit this file to your personal dotfiles!           │
│ ⚠️  This file may contain company-specific information.         │
└─────────────────────────────────────────────────────────────────┘
         Human awareness = Safe
```

## Subordinate Design Pattern

```
┌──────────────────────────────────────────────────────────────────┐
│          HOW IT COEXISTS WITH WORK TOOLING                       │
└──────────────────────────────────────────────────────────────────┘

Scenario 1: Work MDM Manages ~/.claude/
┌─────────────────────────────────────────────────────────────────┐
│ 1. Work MDM writes → ~/.claude/CLAUDE.md                        │
│ 2. Your framework reads it as input                             │
│ 3. Build script merges personal + work                          │
│ 4. Writes back to ~/.claude/CLAUDE.md                           │
└─────────────────────────────────────────────────────────────────┘
         Non-invasive = Compatible

Scenario 2: Work Provides Config File
┌─────────────────────────────────────────────────────────────────┐
│ 1. Copy: cp /work/ai-policy.md ~/.claude/work/CLAUDE.md        │
│    OR                                                            │
│ 2. Link: ln -s /work/ai-policy.md ~/.claude/work/CLAUDE.md     │
│ 3. Build merges both configs                                    │
└─────────────────────────────────────────────────────────────────┘
         Flexible integration = Compatible

Scenario 3: No Work Config
┌─────────────────────────────────────────────────────────────────┐
│ 1. Build script checks for work config                          │
│ 2. If absent, uses only personal config                         │
│ 3. No errors, graceful fallback                                 │
└─────────────────────────────────────────────────────────────────┘
         Works standalone = Compatible
```

## Build Script Logic

```
┌──────────────────────────────────────────────────────────────────┐
│                    build-claude-config.sh                        │
└──────────────────────────────────────────────────────────────────┘

START
  ↓
Check: Personal config exists?
  ├─ No → Error & Exit
  └─ Yes → Continue
      ↓
  Write header to output
      ↓
  Append personal config
      ↓
  Check: Work config exists?
  ├─ No → Skip (print warning)
  └─ Yes → Append work config
      ↓
  Write to ~/.claude/CLAUDE.md
      ↓
  Print summary (line counts)
      ↓
END
```

## Git Integration Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                    TYPICAL WORKFLOW                              │
└──────────────────────────────────────────────────────────────────┘

1. Edit Personal Config
   vim ~/.dotfiles/claude/personal/CLAUDE.md
       ↓
2. Test Build
   make claude-config
       ↓
3. Verify Output
   cat ~/.claude/CLAUDE.md
       ↓
4. Check Git Status
   git status
       ↓
   Output: M  claude/personal/CLAUDE.md  ← Only this file
       ↓
5. Commit
   git add claude/personal/CLAUDE.md
   git commit -m "Update AI preferences"
       ↓
6. Push
   git push
       ↓
7. Sync Other Machines
   git pull && make claude-config
```

## Machine Sync Pattern

```
┌──────────────────────────────────────────────────────────────────┐
│              MULTI-MACHINE SYNCHRONIZATION                       │
└──────────────────────────────────────────────────────────────────┘

Personal Machine              Work Machine
┌──────────────────┐          ┌──────────────────┐
│ Personal Config  │          │ Personal Config  │
│ (synced via git) │ ←────────→ (synced via git) │
└──────────────────┘          └──────────────────┘
        ↓                              ↓
        ↓                              ↓
┌──────────────────┐          ┌──────────────────┐
│ No Work Config   │          │ Work Config      │
│                  │          │ (local only)     │
└──────────────────┘          └──────────────────┘
        ↓                              ↓
        ↓                              ↓
┌──────────────────┐          ┌──────────────────┐
│ Generated:       │          │ Generated:       │
│ Personal only    │          │ Personal + Work  │
└──────────────────┘          └──────────────────┘

Each machine builds its own CLAUDE.md based on:
• Personal config (synced)
• Local work config (machine-specific)
```

## Extension Points

```
┌──────────────────────────────────────────────────────────────────┐
│                    FUTURE ENHANCEMENTS                           │
└──────────────────────────────────────────────────────────────────┘

1. Hook Management
   claude/personal/hooks/ → ~/.claude/hooks/

2. Skill Templates
   claude/personal/skills/ → ~/.claude/skills/

3. Project Templates
   claude/personal/projects/ → per-project configs

4. Multiple Work Contexts
   CLAUDE_WORK_DIR=~/.claude/work-clientA make claude-config

5. Auto-rebuild on Change
   fswatch ~/.dotfiles/claude/personal/ | xargs -n1 make claude-config

6. Validation
   Lint CLAUDE.md for sensitive data before committing
```

## Comparison with Alternatives

```
┌──────────────────────────────────────────────────────────────────┐
│                      VS. OTHER APPROACHES                        │
└──────────────────────────────────────────────────────────────────┘

❌ Approach 1: Stow ~/.claude directory
   Problem: Would symlink entire directory including work config

❌ Approach 2: Single CLAUDE.md with gitignored sections
   Problem: Hard to prevent accidents, merge conflicts

❌ Approach 3: Git submodules for work config
   Problem: Work config would be in git (exposed)

✅ This Framework: Composition pattern
   Benefit: Physical separation + build-time merge
```

## Security Considerations

```
┌──────────────────────────────────────────────────────────────────┐
│                    SECURITY FEATURES                             │
└──────────────────────────────────────────────────────────────────┘

1. No Secrets in Git
   • Work config never touches git repo
   • .gitignore blocks multiple paths

2. Audit Trail
   • Generated file has header showing source
   • Easy to verify what's merged

3. Validation
   • Could add: grep for "confidential|secret|password" in personal/

4. Separation of Concerns
   • Personal = general coding preferences
   • Work = company-specific context
   • No mixing in source files

5. Reversibility
   • Can rebuild anytime
   • Source files are authoritative
   • Output is disposable
```

---

This architecture prioritizes:
- **Safety**: Multiple layers prevent accidental exposure
- **Simplicity**: Shell script, no complex dependencies
- **Flexibility**: Works with or without work config
- **Compatibility**: Subordinate to work tooling
- **Maintainability**: Clear separation of concerns
