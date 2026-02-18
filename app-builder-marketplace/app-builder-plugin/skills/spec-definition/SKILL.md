---
name: spec
description: Jump directly to Phase 1 — Spec Definition. Use when you want to start or redo the product specification.
disable-model-invocation: false
---

# App Builder — Phase 1: Spec Definition

Invoke the `spec-agent` subagent to write a rigorous product specification.

If `.app-builder/spec.md` already exists, ask the user: "A spec already exists. Do you want to (a) view it, (b) update it, or (c) start fresh?"

Pass `$ARGUMENTS` as additional context to the spec agent (e.g. the product idea if provided inline).

After completion, update `.app-builder/state.json` to mark Phase 1 as done.
