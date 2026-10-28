# dotfiles

Assumes a Debian/Ubuntu machine (`install.sh` uses `apt`) with GNOME Terminal (for the keybinding step).

## Import configs into a machine

```bash
git clone git@github.com:notalanjoseph/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
source ~/.bashrc
```

`install.sh` also:
- Installs `fzf`, `bat`, `fd-find`, `ripgrep`, `tree` (skipped if no sudo access).
- Hooks `.bashrc_extra` into `~/.bashrc`, and writes the `~/.claude/CLAUDE.md` import stub.
- On GNOME Terminal, rebinds paste to `Ctrl+V` and copy to `Ctrl+Shift+C`.
- Backs up anything already at a symlink target to `<name>.backup` rather than overwriting it.
  These backups are not cleaned up automatically, so check for and remove them yourself.

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
- `core.pager = delta`: `git diff`, `git show` and `git log` render through `git-delta`, with line
  numbers, syntax highlighting and OSC 8 hyperlinks; the boxed hunk header and file-navigate are off.
  `interactive.diffFilter = delta --color-only` covers `git add -p`.
- Aliases: `git s` (short status), `git lg` (colorized graph log), `git ds` (one-off side-by-side
  diff via delta).
- `credential.helper = store` caches git HTTPS remote credentials as plaintext at `~/.git-credentials`, so
  anyone with read access to this machine can read them. Use `cache` or a keyring-backed helper
  instead if that trade-off is not acceptable here.

**After editing:** nothing to run.

### `.inputrc`

- Enables colorized tab-completion listings for readline (`set colored-stats on`).

**After editing:** `bind -f ~/.inputrc` (or open a new terminal).

### `.bash_commands_guide`

- Personal commands cheatsheet: `command :: description` lines grouped under `# Section` headers.
- Press `Ctrl+T` to fuzzy-search it and insert the selected command on your prompt.

**After editing:** nothing to run.

### `AGENTS.md`

- Global agent instructions, applied in every project.
- Named `AGENTS.md` so that any agentic coding tools that follow this can read it.
- `~/.claude/CLAUDE.md` is a file (not a symlink) containing `@/home/you/path/to/dotfiles/AGENTS.md`.

**After editing:** nothing to run.

## Others

### Trivy

```bash
docker pull aquasec/trivy
```

Now you can use this to scan a project:

```bash
docker run --rm -v "$PWD:/workdir:ro" -v "$HOME/.m2/repository:/root/.m2/repository:ro" -v trivy-cache:/root/.cache \
  aquasec/trivy:latest fs \
  --scanners vuln,misconfig,secret \
  --skip-dirs /workdir/target \
  /workdir
```
