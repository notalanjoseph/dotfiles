#!/bin/bash

# Define the location of your dotfiles repository
DOTFILES_DIR="$HOME/dotfiles"

# Define the exact files you want to symlink
FILES=".bashrc_extra .gitconfig .inputrc .bash_commands_guide"

echo "Starting dotfiles installation..."

# Install dependencies separately, so a package missing from this system's repos doesn't block the rest.
PACKAGES="fzf bat fd-find ripgrep tree git-delta"
if sudo -n true 2>/dev/null || sudo -v 2>/dev/null; then
    echo "Installing dependencies..."
    for package in $PACKAGES; do
        sudo apt install -y "$package" || echo "Failed to install $package, skipping..."
    done
else
    echo "Skipping dependency installation (no sudo access)."
fi

# Move into the dotfiles directory
cd "$DOTFILES_DIR" || exit

# Symlinks SOURCE to TARGET, backing up anything already at TARGET.
link_file() {
    local source="$1" target="$2"

    # Already correctly symlinked, skip.
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "$(basename "$target") already symlinked, skipping..."
        return
    fi

    # If a file or symlink already exists there, back it up first.
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Found existing $target. Backing it up to $target.backup..."
        mv "$target" "$target.backup"
    fi

    echo "Creating symlink for $(basename "$target")..."
    ln -s "$source" "$target"
}

# Loop through each file in the list
for file in $FILES; do
    link_file "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Claude Code's global instructions live in AGENTS.md. ~/.claude/CLAUDE.md just imports it.
mkdir -p "$HOME/.claude"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
IMPORT_LINE="@${DOTFILES_DIR// /\\ }/AGENTS.md"
if [ "$(cat "$CLAUDE_MD" 2>/dev/null)" != "$IMPORT_LINE" ]; then
    if [ -e "$CLAUDE_MD" ] || [ -L "$CLAUDE_MD" ]; then
        echo "Found existing $CLAUDE_MD. Backing it up to $CLAUDE_MD.backup..."
        mv "$CLAUDE_MD" "$CLAUDE_MD.backup"
    fi
    echo "$IMPORT_LINE" > "$CLAUDE_MD"
    echo "Wrote ~/.claude/CLAUDE.md import stub"
fi

# Hook .bashrc_extra into the system .bashrc if not already done
HOOK='[ -f ~/.bashrc_extra ] && source ~/.bashrc_extra'
if ! grep -qF "$HOOK" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "$HOOK" >> "$HOME/.bashrc"
    echo "Appended .bashrc_extra hook to ~/.bashrc"
fi

# GNOME Terminal: Ctrl+V to paste, Ctrl+Shift+C to copy
if command -v gsettings &>/dev/null; then
    echo "Configuring GNOME Terminal keybindings..."
    gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ copy '<Primary><Shift>c'
    gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ paste '<Primary>v'
fi

echo "Installation complete! Enjoy your setup."
