---
name: cleanup
description: Project hygiene — removes dead files, audits security vulnerabilities, patches exposed secrets, updates README, scans dependencies. Run at any time. Scoped or full. Examples — /cleanup | /cleanup security | /cleanup files | /cleanup readme | /cleanup deps
disable-model-invocation: false
---

# App Builder — Project Cleanup

Invoke the `cleanup-agent` subagent to clean and harden the project.

**Usage:**
```
/cleanup                    # Full suite: files + security + readme + deps
/cleanup security           # Security audit only (secrets, vulns, OWASP)
/cleanup files              # Dead file removal + .gitignore hygiene
/cleanup readme             # README accuracy check and update
/cleanup deps               # Dependency vulnerability scan and patch
```

Pass `$ARGUMENTS` directly to cleanup-agent to scope the run.

This skill can be run at **any point** in the pipeline — not just at end of project. Good times to run it:
- After MVP Phase 3, before building the frontend
- Before Phase 8 (Documentation)
- Before Phase 9 (Deploy) — security audit especially important here
- Any time the codebase feels messy

Each run writes or updates `.app-builder/cleanup.md` with a full report of what was found and fixed.
