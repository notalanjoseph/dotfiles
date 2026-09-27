# dotfiles

## Import configs into a machine

```bash
git clone git@github.com:notalanjoseph/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
source ~/.bashrc
```

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

## Config files

### `.bashrc_extra`

- Prompt: `[ddmmyy|hh:mm:ss] user@host:cwd$`, colorized; terminal tab title shows `user@host` only over SSH, just the cwd locally.
- `PATH` setup for Python, pnpm, Maven, IntelliJ, Cargo, and `~/.local/bin`, auto-deduplicated at the end.
- Aliases: `bat` → `batcat`, `fd` → `fdfind` (Debian package names).
- fzf integration with file/dir previews (`batcat`/`tree`).
- Hotkeys: `Ctrl+F` fuzzy-open a file/dir, `Ctrl+G` live grep across files, `Ctrl+R` fzf command history, `Ctrl+T` snippets from `.bash_commands_guide`.
- Custom functions: `frename` (regex rename files/dirs), `mkfile` (create a file plus any missing parent dirs).

**After editing:** `source ~/.bashrc` (or open a new terminal).

### `.gitconfig`

- Default branch `main`; global `user.name`/`user.email`.
- `core.autocrlf = input`, default editor `nano`.
- Aliases: `git s` (short status), `git lg` (colorized graph log).

**After editing:** nothing to run.

### `.inputrc`

- Enables colorized tab-completion listings for readline (`set colored-stats on`).

**After editing:** `bind -f ~/.inputrc` (or open a new terminal).

### `.bash_commands_guide`

- Personal commands cheatsheet: `command :: description` lines grouped under `# Section` headers.
- Press `Ctrl+T` to fuzzy-search it and insert the selected command on your prompt.

**After editing:** nothing to run.

