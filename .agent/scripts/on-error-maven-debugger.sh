#!/usr/bin/env bash
# on-error-maven-debugger.sh
# Claude Code PostToolUseFailure hook — fires when a Bash command fails.
# If the failed command was a Maven build (mvn/mvnw), this hook extracts
# the error output and asks Claude to invoke the alfresco-debugger-agent.
#
# Input: JSON on stdin with { tool_name, tool_input: { command }, tool_output }
# Output: context string on stdout to inject into conversation.

set -euo pipefail

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only act on Maven build commands
if ! echo "$COMMAND" | grep -qE '(mvn\s|mvnw\s|./mvnw\s|\.\\mvnw\s)'; then
  exit 0
fi

# Extract the last 80 lines of output as error context
TOOL_OUTPUT=$(echo "$INPUT" | jq -r '.tool_output // empty')
ERROR_TAIL=$(echo "$TOOL_OUTPUT" | tail -80)

cat <<EOF
Maven build failed. Invoke the alfresco-debugger-agent to diagnose this error.

Build command: $COMMAND

Error output (last 80 lines):
$ERROR_TAIL
EOF
exit 0
