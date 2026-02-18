#!/bin/bash
# guard-no-secrets.sh
# PreToolUse — fires before every Write or Edit
# Scans incoming content for secret patterns before they land on disk.
# Blocks the write and explains exactly what it found.

INPUT=$(cat /dev/stdin)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('path', ti.get('file_path', '')))
" 2>/dev/null)

FILE_CONTENT=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('content', ti.get('new_string', '')))
" 2>/dev/null)

# Skip files where secrets are expected or irrelevant
if echo "$FILE_PATH" | grep -qiE "test|spec|mock|\.env\.example|SKILL\.md|README|\.app-builder|\.gitignore"; then
  exit 0
fi

if [ -z "$FILE_CONTENT" ]; then
  exit 0
fi

FINDINGS=""

# AWS keys
if echo "$FILE_CONTENT" | grep -qE "AKIA[0-9A-Z]{16}"; then
  FINDINGS="$FINDINGS\n  • AWS Access Key ID (AKIA...)"
fi

# Generic high-entropy assignments — password = "something_real"
if echo "$FILE_CONTENT" | grep -qiE "(password|passwd|secret|api_key|apikey|auth_token|private_key)\s*=\s*['\"][^'\"]{8,}['\"]"; then
  # Exclude obvious placeholders
  if ! echo "$FILE_CONTENT" | grep -qiE "(your[-_]|<|>|example|placeholder|changeme|xxxx|1234|test)"; then
    FINDINGS="$FINDINGS\n  • Hardcoded credential (password/secret/api_key assignment)"
  fi
fi

# Private key headers
if echo "$FILE_CONTENT" | grep -qE "-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----"; then
  FINDINGS="$FINDINGS\n  • Private key block (BEGIN PRIVATE KEY)"
fi

# Stripe live keys
if echo "$FILE_CONTENT" | grep -qE "sk_live_[0-9a-zA-Z]{24,}"; then
  FINDINGS="$FINDINGS\n  • Stripe live secret key (sk_live_...)"
fi

# GitHub tokens
if echo "$FILE_CONTENT" | grep -qE "ghp_[0-9a-zA-Z]{36}|github_pat_[0-9a-zA-Z]{82}"; then
  FINDINGS="$FINDINGS\n  • GitHub personal access token"
fi

# Generic long hex/base64 secrets directly assigned
if echo "$FILE_CONTENT" | grep -qiE "(secret|token)\s*=\s*['\"][0-9a-fA-F]{32,}['\"]"; then
  FINDINGS="$FINDINGS\n  • Long hex string assigned to secret/token variable"
fi

if [ -n "$FINDINGS" ]; then
  echo "Secret pattern detected in: $FILE_PATH"
  printf "Findings:$FINDINGS\n"
  echo ""
  echo "Replace with environment variable references (e.g. os.environ['API_KEY']) and add to .env.example."
  exit 2  # exit 2 = block the tool call
fi

exit 0
