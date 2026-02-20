#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
HOME_DIR="$HOME/home"

PUSH_HOOK="push-config.sh"

# Sync pairs: "local_path|repo_relative_path|label"
SYNC_PAIRS=(
    "$CLAUDE_DIR/CLAUDE.md|CLAUDE.md|[global] CLAUDE.md"
    "$CLAUDE_DIR/settings.json|settings.json|[global] settings.json"
    "$HOME_DIR/CLAUDE.md|home/CLAUDE.md|[home] CLAUDE.md"
    "$HOME_DIR/.claude/settings.json|home/settings.json|[home] settings.json"
)
for md in "$HOME_DIR"/*.md; do
    [[ ! -f "$md" ]] && continue
    [[ "$(basename "$md")" == "CLAUDE.md" ]] && continue
    name="$(basename "$md")"
    SYNC_PAIRS+=("$md|home/$name|[home] $name")
done

usage() {
    echo "Usage: $(basename "$0") <command>"
    echo ""
    echo "Commands:"
    echo "  setup   initial setup: show diff, copy files, install push hook"
    echo "  pull    git pull + copy repo -> local"
    echo "  push    copy local -> repo + git commit & push"
    echo "  diff    show diff between repo and local"
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

    for pair in "${SYNC_PAIRS[@]}"; do
        IFS='|' read -r local_path repo_path label <<< "$pair"
        if [[ -f "$SCRIPT_DIR/$repo_path" ]]; then
            mkdir -p "$(dirname "$local_path")"
            cp "$SCRIPT_DIR/$repo_path" "$local_path"
            echo "  $label -> $local_path"
        fi
    done

    install_push_hook
    echo "Done."
}

do_push() {
    check_claude_dir
    local changed=false
    local git_add_files=()

    for pair in "${SYNC_PAIRS[@]}"; do
        IFS='|' read -r local_path repo_path label <<< "$pair"
        if [[ -f "$local_path" ]]; then
            mkdir -p "$(dirname "$SCRIPT_DIR/$repo_path")"
            if ! diff -q "$local_path" "$SCRIPT_DIR/$repo_path" &>/dev/null; then
                cp "$local_path" "$SCRIPT_DIR/$repo_path"
                echo "  $label -> $repo_path"
                git_add_files+=("$repo_path")
                changed=true
            fi
        fi
    done

    if [[ "$changed" == false ]]; then
        echo "No changes to push."
        exit 0
    fi

    cd "$SCRIPT_DIR"
    git pull --rebase --quiet 2>/dev/null || true
    git add "${git_add_files[@]}"
    local file_list
    file_list=$(IFS=', '; echo "${git_add_files[*]}")
    local diff_stat
    diff_stat=$(git diff --cached --stat)
    git commit -m "update claude config: ${file_list}
${diff_stat}"
    git push
    echo "Done."
}

do_diff() {
    check_claude_dir
    local has_diff=false

    for pair in "${SYNC_PAIRS[@]}"; do
        IFS='|' read -r local_path repo_path label <<< "$pair"
        if [[ -f "$local_path" && -f "$SCRIPT_DIR/$repo_path" ]]; then
            if ! diff -q "$local_path" "$SCRIPT_DIR/$repo_path" &>/dev/null; then
                echo "=== $label ==="
                diff --color "$SCRIPT_DIR/$repo_path" "$local_path" || true
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
    for pair in "${SYNC_PAIRS[@]}"; do
        IFS='|' read -r local_path repo_path label <<< "$pair"
        if [[ ! -f "$SCRIPT_DIR/$repo_path" ]]; then
            echo "  $label  [missing in repo]"
        elif [[ ! -f "$local_path" ]]; then
            echo "  $label  [missing locally]"
        elif diff -q "$local_path" "$SCRIPT_DIR/$repo_path" &>/dev/null; then
            echo "  $label  [in sync]"
        else
            echo "  $label  [changed]"
        fi
    done
}

install_push_hook() {
    cat > "$CLAUDE_DIR/$PUSH_HOOK" <<SCRIPT
#!/bin/bash
set -euo pipefail
REPO_DIR="$SCRIPT_DIR"
HOME_DIR="\$HOME/home"

SYNC_PAIRS=(
    "\$HOME/.claude/CLAUDE.md|CLAUDE.md"
    "\$HOME/.claude/settings.json|settings.json"
    "\$HOME/home/CLAUDE.md|home/CLAUDE.md"
    "\$HOME/home/.claude/settings.json|home/settings.json"
)
for md in "\$HOME_DIR"/*.md; do
    [[ ! -f "\$md" ]] && continue
    [[ "\$(basename "\$md")" == "CLAUDE.md" ]] && continue
    name="\$(basename "\$md")"
    SYNC_PAIRS+=("\$md|home/\$name")
done

changed=false
git_add_files=()
for pair in "\${SYNC_PAIRS[@]}"; do
    IFS='|' read -r local_path repo_path <<< "\$pair"
    if [[ -f "\$local_path" ]]; then
        mkdir -p "\$(dirname "\$REPO_DIR/\$repo_path")"
        if ! diff -q "\$local_path" "\$REPO_DIR/\$repo_path" &>/dev/null; then
            cp "\$local_path" "\$REPO_DIR/\$repo_path"
            git_add_files+=("\$repo_path")
            changed=true
        fi
    fi
done

if [[ "\$changed" == true ]]; then
    cd "\$REPO_DIR"
    git pull --rebase --quiet 2>/dev/null || true
    git add "\${git_add_files[@]}"
    file_list=\$(IFS=', '; echo "\${git_add_files[*]}")
    diff_stat=\$(git diff --cached --stat)
    git commit -m "update claude config: \${file_list}
\${diff_stat}"
    git push
fi
SCRIPT
    chmod +x "$CLAUDE_DIR/$PUSH_HOOK"
    echo "  Installed $PUSH_HOOK -> ~/.claude/$PUSH_HOOK"
}

do_setup() {
    check_claude_dir

    for pair in "${SYNC_PAIRS[@]}"; do
        IFS='|' read -r local_path repo_path label <<< "$pair"

        if [[ ! -f "$SCRIPT_DIR/$repo_path" ]]; then
            echo "  $label  [not in repo, skipping]"
            continue
        fi

        if [[ ! -f "$local_path" ]]; then
            mkdir -p "$(dirname "$local_path")"
            cp "$SCRIPT_DIR/$repo_path" "$local_path"
            echo "  $label  [installed]"
            continue
        fi

        if diff -q "$local_path" "$SCRIPT_DIR/$repo_path" &>/dev/null; then
            echo "  $label  [already in sync]"
            continue
        fi

        echo "=== $label ==="
        diff --color "$local_path" "$SCRIPT_DIR/$repo_path" || true
        echo ""
        echo "  [y] Overwrite (backup local as *.bak)"
        echo "  [n] Skip"
        read -p "  Apply repo version? [y/N] " answer
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            cp "$local_path" "$local_path.bak"
            cp "$SCRIPT_DIR/$repo_path" "$local_path"
            echo "  $label  [updated, backup: $local_path.bak]"
        else
            echo "  $label  [skipped]"
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
