#!/usr/bin/env bash
# pre-commit-model-validator.sh
# Claude Code PreToolUse hook — fires before Bash calls.
# If the command is a "git commit" and staged files include content-model or
# context XML files, the hook exits 2 (block) with a message asking Claude
# to run the content-model-validator skill first.
#
# Input: JSON on stdin with { tool_name, tool_input: { command } }
# Output: JSON on stdout when blocking; nothing otherwise.

set -euo pipefail

INPUT=$(cat)

# Extract the bash command from the tool input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only act on git commit commands
if ! echo "$COMMAND" | grep -qE '^\s*git\s+commit'; then
  exit 0
fi

# Check if any staged files match content-model or context XML patterns
STAGED_MODEL_FILES=$(git diff --cached --name-only 2>/dev/null | grep -E '(-model.*\.xml|model/.*\.xml|-context\.xml|context/.*-context\.xml)' || true)

if [ -z "$STAGED_MODEL_FILES" ]; then
  exit 0
fi

# Block the commit and ask Claude to validate first
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "decision": {
      "behavior": "block",
      "reason": "Staged files include Alfresco content-model or context XML files. Run the content-model-validator skill on the following files before committing:\n$(echo "$STAGED_MODEL_FILES" | sed 's/$/\\n/' | tr -d '\n')\nUse the content-model-validator skill to validate, then retry the commit."
    }
  }
}
EOF
exit 2
