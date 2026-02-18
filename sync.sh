#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
FILES=("CLAUDE.md" "settings.json")

PUSH_HOOK="push-config.sh"

usage() {
    echo "Usage: $(basename "$0") <command>"
    echo ""
    echo "Commands:"
    echo "  setup   initial setup: show diff, copy files, install push hook"
    echo "  pull    git pull + copy repo -> ~/.claude/"
    echo "  push    copy ~/.claude/ -> repo + git commit & push"
    echo "  diff    show diff between repo and ~/.claude/"
    echo "  status  show sync status"
}

check_claude_dir() {
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        echo "Error: $CLAUDE_DIR does not exist"
        exit 1
    fi
}

do_pull() {
    cd "$SCRIPT_DIR"
    echo "Pulling from remote..."
    git pull --rebase

    check_claude_dir
    for f in "${FILES[@]}"; do
        if [[ -f "$SCRIPT_DIR/$f" ]]; then
            cp "$SCRIPT_DIR/$f" "$CLAUDE_DIR/$f"
            echo "  $f -> ~/.claude/$f"
        fi
    done

    install_push_hook
    echo "Done."
}

do_push() {
    check_claude_dir
    local changed=false

    for f in "${FILES[@]}"; do
        if [[ -f "$CLAUDE_DIR/$f" ]]; then
            if ! diff -q "$CLAUDE_DIR/$f" "$SCRIPT_DIR/$f" &>/dev/null; then
                cp "$CLAUDE_DIR/$f" "$SCRIPT_DIR/$f"
                echo "  ~/.claude/$f -> $f"
                changed=true
            fi
        fi
    done

    if [[ "$changed" == false ]]; then
        echo "No changes to push."
        exit 0
    fi

    cd "$SCRIPT_DIR"
    git add "${FILES[@]}"
    git commit -m "update claude config"
    git push
    echo "Done."
}

do_diff() {
    check_claude_dir
    local has_diff=false

    for f in "${FILES[@]}"; do
        if [[ -f "$CLAUDE_DIR/$f" && -f "$SCRIPT_DIR/$f" ]]; then
            if ! diff -q "$CLAUDE_DIR/$f" "$SCRIPT_DIR/$f" &>/dev/null; then
                echo "=== $f ==="
                diff --color "$SCRIPT_DIR/$f" "$CLAUDE_DIR/$f" || true
                echo ""
                has_diff=true
            fi
        fi
    done

    if [[ "$has_diff" == false ]]; then
        echo "All files in sync."
    fi
}

do_status() {
    check_claude_dir
    for f in "${FILES[@]}"; do
        if [[ ! -f "$SCRIPT_DIR/$f" ]]; then
            echo "  $f  [missing in repo]"
        elif [[ ! -f "$CLAUDE_DIR/$f" ]]; then
            echo "  $f  [missing in ~/.claude/]"
        elif diff -q "$CLAUDE_DIR/$f" "$SCRIPT_DIR/$f" &>/dev/null; then
            echo "  $f  [in sync]"
        else
            echo "  $f  [changed]"
        fi
    done
}

install_push_hook() {
    cat > "$CLAUDE_DIR/$PUSH_HOOK" <<SCRIPT
#!/bin/bash
set -euo pipefail
REPO_DIR="$SCRIPT_DIR"
CLAUDE_DIR="\$HOME/.claude"
FILES=("CLAUDE.md" "settings.json")

changed=false
for f in "\${FILES[@]}"; do
    if [[ -f "\$CLAUDE_DIR/\$f" ]] && ! diff -q "\$CLAUDE_DIR/\$f" "\$REPO_DIR/\$f" &>/dev/null; then
        cp "\$CLAUDE_DIR/\$f" "\$REPO_DIR/\$f"
        changed=true
    fi
done

if [[ "\$changed" == true ]]; then
    cd "\$REPO_DIR"
    git add "\${FILES[@]}"
    git commit -m "update claude config"
    git push
fi
SCRIPT
    chmod +x "$CLAUDE_DIR/$PUSH_HOOK"
    echo "  Installed $PUSH_HOOK -> ~/.claude/$PUSH_HOOK"
}

do_setup() {
    check_claude_dir

    for f in "${FILES[@]}"; do
        if [[ ! -f "$SCRIPT_DIR/$f" ]]; then
            echo "  $f  [not in repo, skipping]"
            continue
        fi

        if [[ ! -f "$CLAUDE_DIR/$f" ]]; then
            cp "$SCRIPT_DIR/$f" "$CLAUDE_DIR/$f"
            echo "  $f  [installed]"
            continue
        fi

        if diff -q "$CLAUDE_DIR/$f" "$SCRIPT_DIR/$f" &>/dev/null; then
            echo "  $f  [already in sync]"
            continue
        fi

        echo "=== $f ==="
        diff --color "$CLAUDE_DIR/$f" "$SCRIPT_DIR/$f" || true
        echo ""
        read -p "  Overwrite ~/.claude/$f with repo version? [y/N] " answer
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            cp "$SCRIPT_DIR/$f" "$CLAUDE_DIR/$f"
            echo "  $f  [updated]"
        else
            echo "  $f  [skipped]"
        fi
    done

    install_push_hook
    echo "Done."
}

case "${1:-}" in
    setup)  do_setup ;;
    pull)   do_pull ;;
    push)   do_push ;;
    diff)   do_diff ;;
    status) do_status ;;
    *)      usage ;;
esac
