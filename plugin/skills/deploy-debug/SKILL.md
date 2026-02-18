---
name: deploy
description: Jump to Phase 9 — Deploy & Debug. Sets up CI/CD, deploys to production, and debugs issues.
disable-model-invocation: false
---

# App Builder — Phase 9: Deploy & Debug

Invoke the `deploy-agent` subagent to deploy the application to production.

Pass any `$ARGUMENTS` as the deployment target (e.g. "Vercel", "Railway", "AWS EC2", "Docker + VPS").

If no target is specified, the agent will recommend one based on the tech stack in the spec.

After completion, update `.app-builder/state.json` to mark Phase 9 as done.
