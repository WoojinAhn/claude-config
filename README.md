🌐 [English](README.md) | [한국어](README.ko.md)

# claude-config

A repository for managing Claude Code global settings.

Syncs via **file copy** through a script — no symlinks into `~/.claude/`.

## Managed Files

| File | Purpose |
|---|---|
| `CLAUDE.md` | Global behavior instructions (applied to all projects) |
| `settings.json` | Model, permissions, hooks, and other runtime settings |

## Usage

```bash
# Check sync status
~/claude-config/sync.sh status

# Show diff between repo and ~/.claude/
~/claude-config/sync.sh diff

# Pull: remote -> ~/.claude/
~/claude-config/sync.sh pull

# Push: ~/.claude/ -> remote
~/claude-config/sync.sh push
```

## New Machine Setup

```bash
git clone git@github.com:WoojinAhn/claude-config.git ~/claude-config
~/claude-config/sync.sh pull
```

## Adding Files

Add filenames to the `FILES` array in `sync.sh` to include them in sync.

```bash
FILES=("CLAUDE.md" "settings.json" "keybindings.json")
```
