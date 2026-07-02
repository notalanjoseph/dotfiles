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

## Import configs into a machine

```bash
git clone git@github.com:notalanjoseph/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
source ~/.bashrc
```
