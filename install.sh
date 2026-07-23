#!/bin/bash

# Define the location of your dotfiles repository
DOTFILES_DIR="$HOME/dotfiles"

# Define the exact files you want to symlink
FILES=".bashrc_extra .gitconfig .inputrc .bash_commands_guide"

echo "Starting dotfiles installation..."

# Install dependencies
PACKAGES="fzf bat fd-find ripgrep tree"
if sudo -n true 2>/dev/null || sudo -v 2>/dev/null; then
    echo "Installing dependencies..."
    sudo apt install -y $PACKAGES
else
    echo "Skipping dependency installation (no sudo access)."
fi

# Move into the dotfiles directory
cd "$DOTFILES_DIR" || exit

# Loop through each file in the list
for file in $FILES; do
    TARGET="$HOME/$file"
    SOURCE="$DOTFILES_DIR/$file"

    # Already correctly symlinked — skip
    if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
        echo "$file already symlinked, skipping..."
        continue
    fi

    # If a file or symlink already exists there, back it up first
    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        echo "Found existing $TARGET. Backing it up to $TARGET.backup..."
        mv "$TARGET" "$TARGET.backup"
    fi

    # Create the new symlink pointing to the dotfiles repo
    echo "Creating symlink for $file..."
    ln -s "$SOURCE" "$TARGET"
done

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
