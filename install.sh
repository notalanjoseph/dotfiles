#!/bin/bash

# Define the location of your dotfiles repository
DOTFILES_DIR="$HOME/dotfiles"

# Define the exact files you want to symlink
FILES=".bashrc .gitconfig"

echo "Starting dotfiles installation..."

# Move into the dotfiles directory
cd "$DOTFILES_DIR" || exit

# Loop through each file in the list
for file in $FILES; do
    TARGET="$HOME/$file"
    
    # If a file or symlink already exists there, back it up first
    if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        echo "Found existing $TARGET. Backing it up to $TARGET.backup..."
        mv "$TARGET" "$TARGET.backup"
    fi
    
    # Create the new symlink pointing to the dotfiles repo
    echo "Creating symlink for $file..."
    ln -s "$DOTFILES_DIR/$file" "$TARGET"
done

echo "Installation complete! Enjoy your setup."
