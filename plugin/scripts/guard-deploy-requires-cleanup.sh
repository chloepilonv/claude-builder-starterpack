#!/bin/bash
# guard-deploy-requires-cleanup.sh
# Stop hook — fires when Claude finishes a response
# Checks: if deploy-agent just ran and completed, was a security cleanup
# ever performed? If not, warn loudly.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE_FILE="$PROJECT_DIR/.app-builder/state.json"
CLEANUP_ARTIFACT="$PROJECT_DIR/.app-builder/cleanup.md"
DEPLOY_ARTIFACT="$PROJECT_DIR/.app-builder/deploy.md"

# Only relevant if there's an active App Builder session
if [ ! -f "$STATE_FILE" ]; then
  exit 0
fi

# Check if Phase 9 (deploy) just completed
PHASE_9_STATUS=$(python3 -c "
import sys, json
try:
  with open('$STATE_FILE') as f:
    d = json.load(f)
  print(d.get('phases', {}).get('9', {}).get('status', ''))
except:
  print('')
" 2>/dev/null)

# Only warn when deploy just went in_progress or just completed
if [ "$PHASE_9_STATUS" != "in_progress" ] && [ "$PHASE_9_STATUS" != "done" ]; then
  exit 0
fi

# Check if a security cleanup was ever run
if [ ! -f "$CLEANUP_ARTIFACT" ]; then
  echo "⚠️  DEPLOY WARNING: No security cleanup on record."
  echo ""
  echo "You're about to deploy without a security audit."
  echo "Run /cleanup security before deploying to check for:"
  echo "  • Hardcoded secrets or credentials"
  echo "  • Known dependency vulnerabilities (CVEs)"  
  echo "  • DEBUG mode left enabled"
  echo "  • .env files accidentally tracked by git"
  echo ""
  echo "To proceed anyway, re-run /deploy. To audit first, run /cleanup security."
  # Exit 1 = warn but don't block (user can override by re-running deploy)
  # Change to exit 2 if you want a hard block
  exit 1
fi

# Cleanup exists — check it actually covered security
if ! grep -qi "security\|secrets\|vulnerabilit" "$CLEANUP_ARTIFACT" 2>/dev/null; then
  echo "⚠️  DEPLOY WARNING: Cleanup ran but security scope not confirmed."
  echo "Run /cleanup security to complete the security audit before deploying."
  exit 1
fi

exit 0
