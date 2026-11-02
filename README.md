# my dotfiles
---

### Step 1: Clone

Perform a _recursive_ clone of this repo into `~/.dotfiles`:

```sh
git clone --recursive --recurse-submodules git@github.com:bezhermoso/dotfiles.git ~/.dotfiles
```

> [!NOTE]
> If it was cloned bare, run this afterwards: `git submodule update --init --recursive`

## Step 2: Install Homebrew dependencies

### Install Homebrew

Go to [https://brew.sh](https://brew.sh) and follow the installation instructions.

As of 2024-02-17, this is how:

```sh
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install core dependencies

Dependencies installable via Homebrew are captured in `./homebrew/Brewfile`:

```sh
cd ~/.dotfiles/homebrew/_core
/opt/homebrew/bin/brew bundle install
```

## Step 3: Install a more recent version of Zsh

The version of `zsh` that comes with macOS is usually outdated. The previous step should have installed a more recent version of `zsh` via Homebrew. To use it, add it to `/etc/shells`:

```sh
sudo -e /etc/shells

# Add this line at the end of the file:
/opt/homebrew/bin/zsh
```

...or whatever the path to the new version of `zsh` is (i.e. the output of `which zsh`)

Then, change the default shell to the new version of `zsh`:

```sh
chsh -s /opt/homebrew/bin/zsh
```

## Step 4: Configure tools

I use [Stow](https://www.gnu.org/software/stow/) to put configuration directories/files where they need to be for tools to work:

```sh
cd ~/.dotfiles
/opt/homebrew/bin/stow .
```

It is recommended to close & re-open your terminal to pick up the just-installed Zsh configurations.

#### Install Zsh plugins

I use [`zinit`](https://github.com/zdharma-continuum/zinit) to manage Zsh plugins. It should auto-install the plugins when you start a new Zsh session.

#### Install `tmux` plugins

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start a **new** `tmux` session and invoke `C-s I` to install the plugins.

#### Setup Neovim

Start Neovim. It should auto-install lazy.nvim and all the plugins

#### Setup `atuin`

> [!IMPORTANT]
> Do not do this on your work machine! Only do this on computers whose command-line history you want synced.

```sh
atuin login
```

#### Configure `git`

Create a `~/.gitconfig` file & include relevant files from `~/.dotfiles/git` e.g.

```gitconfig
[include]
    path = ~/.dotfiles/git/base.gitconfig
    path = ~/.dotfiles/git/1password.gitconfig

# REQUIRED. None of the config files in dotfiles contain author information. Configure this on a per-machine basis.
[user]
	name = Bez Hermoso
	email = ...
```

Install `gh` extensions:

```sh
make gh-extensions
```

#### Setup Claude Code

Install [Claude Code](https://code.claude.com) with the native installer, which puts `claude` in `~/.local/bin` (already on `PATH` via the Zsh config):

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

**Settings.** `~/.claude/settings.json` is generated from the fragments in `dot-config/claude/fragments/` (stowed to `~/.config/claude/fragments/`) by [`claude-mergerc`](https://github.com/bezhermoso/claude-mergerc), which `zinit` loads automatically. It needs `jq` (in the core Brewfile), plus [`yq`](https://github.com/mikefarah/yq) only if a fragment is written in YAML. Run it, review the diff, and apply:

```sh
claude-mergerc
```

**Instructions (`CLAUDE.md`).** Instructions shared across machines live in `dot-config/claude/CLAUDE.md` (i.e. `~/.config/claude/CLAUDE.md`). `~/.claude/CLAUDE.md` is per-machine and untracked: it imports the shared file, then adds anything specific to that machine (e.g. work-only or host-only notes). On a new machine, add this line at the top of `~/.claude/CLAUDE.md`, creating the file if needed (work tooling may already have put content there, so don't overwrite it):

```md
@~/.config/claude/CLAUDE.md
```

**Personal skills.** My own skills live in a plugin marketplace, [`bezhermoso/skills`](https://github.com/bezhermoso/skills) (private), as the `bez` plugin; they are invoked as `bez:<skill>`. The machine needs git access to that repo, e.g. via `gh auth login` or an SSH key added to GitHub.

On a machine where I only *use* the skills (e.g. a work computer):

```sh
claude plugin marketplace add bezhermoso/skills
claude plugin install bez@bez
```

On a machine where I *edit* the skills, add the marketplace from a local checkout instead. It is read in place, so edits take effect after `/reload-plugins` without pushing:

```sh
git clone git@github.com:bezhermoso/skills.git ~/dev/skills
claude plugin marketplace add ~/dev/skills
claude plugin install bez@bez
```

See that repo's README for authoring and validation.

# TODOs

- [x] Done for now
