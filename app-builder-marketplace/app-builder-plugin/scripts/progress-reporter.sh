#!/bin/bash
# progress-reporter.sh
# PostToolUse hook — fires after every tool call inside a subagent
# Emits a human-readable one-liner so the user can see live progress
# instead of staring at "Thinking..." for minutes.

INPUT=$(cat /dev/stdin)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Only emit during an active App Builder session
if [ ! -f "$PROJECT_DIR/.app-builder/state.json" ]; then
  exit 0
fi

# Extract tool name and key input field
TOOL_NAME=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('tool_name', 'unknown'))
" 2>/dev/null || echo "unknown")

TOOL_INPUT=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
# Return the most descriptive field available
for key in ['path', 'command', 'query', 'pattern', 'url', 'description']:
    if key in ti:
        val = str(ti[key])
        # Truncate long values
        print(val[:80] + '...' if len(val) > 80 else val)
        sys.exit(0)
print('')
" 2>/dev/null || echo "")

# Map tool names to readable verbs
case "$TOOL_NAME" in
  Read)       VERB="📖 Reading" ;;
  Write)      VERB="✍️  Writing" ;;
  Edit)       VERB="✏️  Editing" ;;
  Bash)       VERB="⚙️  Running" ;;
  Glob)       VERB="🔍 Scanning" ;;
  Grep)       VERB="🔎 Searching" ;;
  WebFetch)   VERB="🌐 Fetching" ;;
  WebSearch)  VERB="🌐 Searching web for" ;;
  Task)       VERB="🤖 Spawning subagent for" ;;
  *)          VERB="⚡ $TOOL_NAME" ;;
esac

# Get current phase from state
CURRENT_PHASE=$(python3 -c "
import json, sys
try:
    with open('$PROJECT_DIR/.app-builder/state.json') as f:
        d = json.load(f)
    print(d.get('current_phase', '?'))
except:
    print('?')
" 2>/dev/null || echo "?")

TIMESTAMP=$(date +"%H:%M:%S")

# Print the progress line — Claude Code surfaces this to the user
if [ -n "$TOOL_INPUT" ]; then
  echo "[$TIMESTAMP] Phase $CURRENT_PHASE — $VERB: $TOOL_INPUT"
else
  echo "[$TIMESTAMP] Phase $CURRENT_PHASE — $VERB"
fi

# Also append to activity log
LOG_FILE="$PROJECT_DIR/.app-builder/activity.log"
echo "[$TIMESTAMP] TOOL:$TOOL_NAME INPUT:$TOOL_INPUT" >> "$LOG_FILE" 2>/dev/null

exit 0
