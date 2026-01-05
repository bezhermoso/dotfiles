# Named Directories
# Allows you to bookmark frequently used directories with short aliases for
# quick navigation or referencing in commands.
#
# Usage: cd ~alias_name  or  ls ~alias_name
#
# Example: hash -d proj=~/Projects
#          cd ~proj  →  cd ~/Projects
#
# Reference: https://www.youtube.com/watch?v=3fVAtaGhUyU (13:08-14:04)

# Home directory shortcuts (commented out - uncomment and customize as needed)
# hash -d docs=~/Documents
# hash -d dl=~/Downloads
# hash -d dt=~/Desktop
# hash -d pics=~/Pictures
# hash -d vids=~/Videos
# hash -d music=~/Music

# Development project shortcuts (commented out - uncomment and customize)
# hash -d proj=~/Projects
# hash -d dev=~/Development
# hash -d code=~/Code
# hash -d git=~/git
# hash -d repos=~/repositories

# Configuration shortcuts (commented out - uncomment and customize)
# hash -d dotfiles=~/.dotfiles
# hash -d config=~/.config
# hash -d nvim=~/.config/nvim
# hash -d zsh=~/.config/zsh

# Work-related shortcuts (commented out - uncomment and customize)
# hash -d work=~/Work
# hash -d notes=~/Notes

# Tips:
# - Named directories work with tab completion
# - They work in any command, not just cd: ls ~proj, vim ~config/file.txt
# - You can nest them: cd ~proj/myapp
# - Use descriptive but short names (2-4 characters work well)

# Add your custom named directories below:
