#!/bin/bash

# Define the location of your dotfiles repository
DOTFILES_DIR="$HOME/dotfiles"

# Define the exact files you want to symlink
FILES=".bashrc_extra .gitconfig .inputrc"

echo "Starting dotfiles installation..."

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

echo "Installation complete! Enjoy your setup."
