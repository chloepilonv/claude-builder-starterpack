#!/bin/bash
# on-file-write.sh
# Triggered after every Write/Edit tool use during an App Builder session
# Logs file changes to .app-builder/activity.log if a session is active

INPUT=$(cat /dev/stdin)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/.app-builder/state.json"

# Only act if an App Builder session is active
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

LOG_FILE="$PROJECT_DIR/.app-builder/activity.log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Extract the file path from the hook input
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('path','unknown'))" 2>/dev/null || echo "unknown")

# Log the write
echo "[$TIMESTAMP] FILE_WRITE: $FILE_PATH" >> "$LOG_FILE"

exit 0
