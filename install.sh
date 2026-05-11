#!/usr/bin/env bash
# Installer for the agentic-documentation skill + SessionStart hook.
#
# Usage:
#   ./install.sh                          # install into the current directory
#   ./install.sh /path/to/your/project    # install into a specific project
#
# What it does:
#   1. Copies the skill to .claude/skills/agentic-documentation/SKILL.md
#   2. Copies the hook to .claude/hooks/session-start-claude-docs-pointer.sh
#   3. Merges the SessionStart hook entry into .claude/settings.json
#      (creates the file if missing — never clobbers existing hooks)
#   4. Copies starter templates to .claude-docs/ ONLY if that directory
#      does not exist yet. Existing trees are left untouched.
#
# Behaviour:
#   - Existing skill / hook files are overwritten only after a confirmation
#     prompt (or unconditionally with -y).
#   - Requires bash, cp, chmod, mkdir. Uses jq if available for safe JSON
#     merging; falls back to a plain copy when settings.json doesn't exist.

set -euo pipefail

# -----------------------------------------------------------------------------
# Argument parsing
# -----------------------------------------------------------------------------

ASSUME_YES=0
TARGET=""

while [ $# -gt 0 ]; do
  case "$1" in
    -y|--yes)
      ASSUME_YES=1
      shift
      ;;
    -h|--help)
      sed -n '2,20p' "$0"
      exit 0
      ;;
    *)
      if [ -z "$TARGET" ]; then
        TARGET="$1"
      else
        echo "error: unexpected argument: $1" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

TARGET="${TARGET:-$PWD}"

if [ ! -d "$TARGET" ]; then
  echo "error: target directory does not exist: $TARGET" >&2
  exit 1
fi

# Resolve the directory this script lives in, so we can find skill/, hook/,
# templates/ regardless of where the user runs it from.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

confirm() {
  # confirm "Question" — returns 0 (yes) or 1 (no).
  if [ "$ASSUME_YES" -eq 1 ]; then
    return 0
  fi
  local prompt="$1"
  local answer
  read -r -p "$prompt [y/N] " answer
  case "$answer" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

copy_with_prompt() {
  # copy_with_prompt SRC DST — prompts before overwriting an existing DST.
  local src="$1"
  local dst="$2"
  if [ -e "$dst" ]; then
    if ! confirm "exists: $dst — overwrite?"; then
      echo "  skipped: $dst"
      return 0
    fi
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "  wrote:   $dst"
}

# -----------------------------------------------------------------------------
# 1. Skill
# -----------------------------------------------------------------------------

echo "Installing agentic-documentation skill into: $TARGET"
echo

echo "[1/4] skill"
copy_with_prompt \
  "$SCRIPT_DIR/skill/SKILL.md" \
  "$TARGET/.claude/skills/agentic-documentation/SKILL.md"

# -----------------------------------------------------------------------------
# 2. Hook
# -----------------------------------------------------------------------------

echo "[2/4] hook"
HOOK_DST="$TARGET/.claude/hooks/session-start-claude-docs-pointer.sh"
copy_with_prompt \
  "$SCRIPT_DIR/hook/session-start-claude-docs-pointer.sh" \
  "$HOOK_DST"
chmod +x "$HOOK_DST"

# -----------------------------------------------------------------------------
# 3. settings.json — merge or create
# -----------------------------------------------------------------------------

echo "[3/4] settings.json"
SETTINGS="$TARGET/.claude/settings.json"

HOOK_ENTRY='{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/session-start-claude-docs-pointer.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}'

if [ ! -f "$SETTINGS" ]; then
  mkdir -p "$(dirname "$SETTINGS")"
  printf '%s\n' "$HOOK_ENTRY" > "$SETTINGS"
  echo "  wrote:   $SETTINGS (new file)"
elif command -v jq >/dev/null 2>&1; then
  # Use jq to merge: append our hook to .hooks.SessionStart[0].hooks unless
  # the same command is already configured.
  TMP="$(mktemp)"
  jq --arg cmd ".claude/hooks/session-start-claude-docs-pointer.sh" '
    .hooks //= {} |
    .hooks.SessionStart //= [{"hooks": []}] |
    if any(.hooks.SessionStart[].hooks[]?; .command == $cmd) then .
    else
      .hooks.SessionStart[0].hooks += [{
        "type": "command",
        "command": $cmd,
        "timeout": 5
      }]
    end
  ' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"
  echo "  merged:  $SETTINGS"
else
  echo "  WARN: jq not found — leaving $SETTINGS untouched." >&2
  echo "        Add this entry manually under hooks.SessionStart:" >&2
  echo "          { \"type\": \"command\"," >&2
  echo "            \"command\": \".claude/hooks/session-start-claude-docs-pointer.sh\"," >&2
  echo "            \"timeout\": 5 }" >&2
fi

# -----------------------------------------------------------------------------
# 4. Starter templates — only if .claude-docs/ does not exist
# -----------------------------------------------------------------------------

echo "[4/4] starter templates"
DOCS_DIR="$TARGET/.claude-docs"
if [ -d "$DOCS_DIR" ]; then
  echo "  skipped: $DOCS_DIR already exists — leaving it alone."
else
  mkdir -p "$DOCS_DIR"
  # Copy contents (not the parent folder itself) so .claude-docs/ stays flat.
  cp -R "$SCRIPT_DIR/templates/claude-docs/." "$DOCS_DIR/"
  echo "  wrote:   $DOCS_DIR (from templates)"
fi

echo
echo "Done."
echo
echo "Next steps:"
echo "  1. Open Claude Code in $TARGET"
echo "  2. Ask: 'init the .claude-docs tree for this project'"
echo "     (or hand-edit the templates in .claude-docs/)"
echo "  3. Commit the result."
