#!/bin/bash
# on-subagent-stop.sh  
# Triggered when a subagent finishes its work
# Updates the App Builder state file if a phase was just completed

INPUT=$(cat /dev/stdin)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/.app-builder/state.json"

# Only act if an App Builder session is active
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOG_FILE="$PROJECT_DIR/.app-builder/activity.log"

echo "[$TIMESTAMP] SUBAGENT_STOP: subagent finished" >> "$LOG_FILE"

# The subagent is responsible for updating state.json directly.
# This script just provides a hook point for future automation.
# You can extend this to: send Slack notifications, trigger CI, etc.

exit 0
