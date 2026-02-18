#!/bin/bash
# snapshot-before-phase.sh
# PreToolUse(Task) hook — fires before a subagent is spawned
# Creates a git commit snapshot of current state before each phase starts,
# so you can always roll back if a phase goes wrong.
# Also creates a phase branch if branch-per-phase strategy is configured.

INPUT=$(cat /dev/stdin)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/.app-builder/state.json"

# Only act if an App Builder session is active
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

# Check if this is a git repo
if ! git -C "$PROJECT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
  echo "⚠️  No git repo found — skipping phase snapshot. Run 'git init' to enable snapshots."
  exit 0
fi

# Get current phase and repo config from state
CURRENT_PHASE=$(python3 -c "
import json, sys
try:
    with open('$STATE_FILE') as f:
        d = json.load(f)
    print(d.get('current_phase', '?'))
except:
    print('?')
" 2>/dev/null || echo "?")

BRANCH_STRATEGY=$(python3 -c "
import json, sys
try:
    with open('$STATE_FILE') as f:
        d = json.load(f)
    print(d.get('repo', {}).get('branch_strategy', 'none'))
except:
    print('none')
" 2>/dev/null || echo "none")

PHASE_NAMES=(
  ""
  "spec"
  "plan"
  "mvp-1"
  "mvp-2"
  "mvp-3"
  "frontend-basic"
  "frontend-design"
  "deploy"
  "docs"
)

PHASE_NAME="${PHASE_NAMES[$CURRENT_PHASE]:-phase-$CURRENT_PHASE}"
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")
BRANCH_NAME="phase/$CURRENT_PHASE-$PHASE_NAME"

cd "$PROJECT_DIR"

# Stage and commit everything current (snapshot of state before phase starts)
git add -A > /dev/null 2>&1

# Only commit if there's something to commit
if ! git diff --cached --quiet; then
  git commit -m "snapshot: before phase $CURRENT_PHASE ($PHASE_NAME) [$TIMESTAMP]" > /dev/null 2>&1
  echo "📸 Snapshot saved: 'snapshot: before phase $CURRENT_PHASE' — you can roll back to this anytime"
else
  echo "📸 Nothing to snapshot (working tree clean)"
fi

# Create and switch to phase branch if using branch-per-phase strategy
if [ "$BRANCH_STRATEGY" = "phase-branches" ]; then
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]; then
    # Check if branch already exists
    if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
      git checkout "$BRANCH_NAME" > /dev/null 2>&1
      echo "🌿 Switched to existing branch: $BRANCH_NAME"
    else
      git checkout -b "$BRANCH_NAME" > /dev/null 2>&1
      echo "🌿 Created and switched to branch: $BRANCH_NAME"
    fi
  fi
fi

exit 0
