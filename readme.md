# dotfiles

## Save a config

```bash
cd ~/dotfiles
mv ~/path/to/configfile .
ln -s ~/dotfiles/configfile ~/path/to/configfile
```

### To verify symlinks:

```bash
find ~ -maxdepth 1 -type l -printf '%p -> %l\n'
```

## Bash commands guide

`.bash_commands_guide` is a personal commands cheatsheet. Press `Ctrl+T` to fuzzy-search it and insert the selected command on your prompt.

Add new entries anytime with the same `command :: description` format; the file is read fresh on every `Ctrl+T` press.

## Import configs into a machine

```bash
git clone git@github.com:notalanjoseph/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
source ~/.bashrc
```
