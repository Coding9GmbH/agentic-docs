#!/usr/bin/env bash
# SessionStart hook — points Claude at the .claude-docs/ tree and the
# agentic-documentation skill at the start of every session.
#
# Runs from the repo root. Silent if .claude-docs/ doesn't exist (e.g. a
# freshly cloned branch without the tree). Exits cleanly so the session
# is never blocked by a missing map.

set -euo pipefail

if [ ! -f ".claude-docs/README.md" ]; then
  # Nothing to point at — exit cleanly without output.
  exit 0
fi

cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Agent-facing docs live at .claude-docs/ — a structural map of this repo. READ .claude-docs/README.md + .claude-docs/LOOKUP.md before greping the codebase for non-trivial tasks. AFTER a change that adds or modifies a module, feature, endpoint, DB model, UI primitive, hook, store, event, queue, security rule, pattern, or workflow, invoke the agentic-documentation skill to update the affected catalog entries. The skill has CHECK / UPDATE / INIT modes — see .claude/skills/agentic-documentation/SKILL.md."
  }
}
JSON
