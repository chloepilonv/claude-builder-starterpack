# Claude Builder Starterpack

A structured, repeatable product development pipeline for Claude Code. Works for any product type — e-commerce, AI tools, scientific software, SaaS, CFD simulations, mobile apps.

---

## What It Does

Every time you start a new product, you go through the same process. Claude Builder Starter Pack codifies that process into a plugin with specialized subagents for each phase, hooks that enforce quality gates, and persistent state so you can pause and resume at any point.

```
Phase 1  ──  Spec Definition
Phase 2  ──  Plan Creation & Validation
Phase 3  ──  MVP Build 1  ┐
Phase 4  ──  MVP Build 2  ├─ Goals defined in Phase 2, not assumed
Phase 5  ──  MVP Build 3  ┘
Phase 6  ──  Frontend: Basic App
Phase 7  ──  Frontend: Design
Phase 8  ──  Documentation & Repo Cleanup
Phase 9  ──  Deploy & Debug
  +      ──  New Feature   (post-launch, run anytime)
  ✦      ──  Cleanup       (run anytime — files, security, README, deps)
```

---

## Installation

Requires [Claude Code](https://claude.ai/code) 1.0.33+.

**1. Clone the repo**

```bash
git clone https://github.com/chloepilonv/claude-builder-starterpack ~/claude-builder-starterpack
```

**2. Register the marketplace** — run this inside Claude Code

```
/plugin marketplace add ~/claude-builder-starterpack
```

**3. Install the plugin** — run this inside Claude Code

```
/plugin install claude-builder-starterpack@claude-builder-starterpack
```

Restart Claude Code when prompted. Then, in any project directory:

```
/cbs:app-builder
```

---

## Usage

### Start a new project (or resume one)

```
/cbs:app-builder
```

Checks for `.app-builder/state.json` in your project. If it doesn't exist, starts fresh at Phase 1. If it does, shows the pipeline status and asks where to resume.

### The workflow

Once started, the pipeline runs one phase at a time. Each phase delegates to a specialized subagent, then stops and waits for your approval before moving on:

```
╔═══════════════════════════════════════════════════════╗
║              APP BUILDER — PIPELINE STATUS            ║
╠═════╦══════════════════════════════╦══════════════════╣
║  1  ║  Spec Definition             ║  ✅ done         ║
║  2  ║  Plan Creation & Validation  ║  ⬅ just finished ║
║  3  ║  MVP Phase 1                 ║  ⏳ pending      ║
...
╚═════╩══════════════════════════════╩══════════════════╝

Ready to move to Phase 3?  → yes / review / redo / skip / stop
```

### Jump to any phase directly

```
/cbs:spec                        # Phase 1 — Write product spec
/cbs:plan                        # Phase 2 — Create execution plan
/cbs:build 1                     # MVP Phase 1 (goal from plan)
/cbs:build 2                     # MVP Phase 2 (goal from plan)
/cbs:build 3                     # MVP Phase 3 (goal from plan)
/cbs:frontend                    # Phase 6 — Basic functional UI
/cbs:design pink barbie          # Phase 7 — Apply design system
/cbs:docs                        # Phase 8 — Docs + repo cleanup
/cbs:deploy Vercel               # Phase 9 — Deploy + debug
/cbs:new-feature Stripe billing  # Post-launch feature addition
/cbs:cleanup                     # Full hygiene sweep (anytime)
/cbs:cleanup security            # Security audit only
/cbs:nebius provision A100       # Nebius GPU infrastructure
```

### Pipeline utilities

```
/cbs:app-builder status          # Show current pipeline status
/cbs:app-builder features        # List all post-launch features
/cbs:app-builder restart phase 4 # Reset phase 4 and everything after
```

---

## Agents

| Agent | Role |
|-------|------|
| `spec-agent` | Interviews you and produces a rigorous product spec |
| `plan-agent` | Feasibility check, risk matrix, defines custom MVP phases |
| `build-agent` | Executes any MVP phase per the plan — zero assumed structure |
| `frontend-agent` | Builds the functional UI (functionality first, no design yet) |
| `design-agent` | Applies a full design system from a style argument or moodboard |
| `docs-agent` | Writes README, ARCHITECTURE, API docs; cleans the repo |
| `cleanup-agent` | Removes dead files, audits secrets/vulns, patches deps, fixes README |
| `deploy-agent` | CI/CD setup, production deploy, smoke tests, debugging |
| `feature-agent` | Mini spec + build + test + deploy for any post-launch feature |
| `nebius-agent` | Nebius AI Cloud — GPU instances, jobs, storage, cost tracking |

---

## Design Agent — Style Arguments

The design agent takes a style direction. Be specific:

```
/cbs:design pink barbie
/cbs:design dark brutalist terminal
/cbs:design clean swiss fintech
/cbs:design luxury editorial magazine
/cbs:design sci-fi data dashboard
/cbs:design moodboard: early iPod UI, white plastic, chrome, soft gradients
/cbs:design moodboard: ./refs/brand1.png ./refs/brand2.png
```

It translates your direction into concrete tokens: specific hex colors, real font names, spatial character, signature interaction details.

---

## MVP Phases — Fully Custom

MVP phase goals are defined during planning, not assumed. Examples:

| Project | Phase 1 | Phase 2 | Phase 3 |
|---------|---------|---------|---------|
| AI-CFD | PhysNemo sim on Nebius → output | Sim output → video | Cosmos Reason over video |
| Catalogue Builder | Photo → AI ID | Moderatable DB | Field scan → DB match |
| Fitness→Finance | Strava connect | 1km=$1 dashboard | Stripe link |
| E-commerce | Products + cart + checkout | Payments + orders | Inventory + admin |

---

## Cleanup Agent

Run at any time. Scoped or full:

```
/cbs:cleanup                    # Full suite
/cbs:cleanup security           # Secrets, vulns, OWASP patterns
/cbs:cleanup files              # Dead files, .gitignore hygiene
/cbs:cleanup readme             # README accuracy check and update
/cbs:cleanup deps               # npm audit / pip-audit and patching
```

**Recommended checkpoints:**
- After MVP Phase 3, before building frontend
- Before deploy — `/cbs:cleanup security` is non-optional
- After any heavy feature sprint

---

## Plugin Structure

```
claude-builder-starterpack/          ← clone this repo
├── .claude-plugin/
│   └── marketplace.json             ← registers the marketplace
├── README.md
└── plugin/                          ← the installable plugin
    ├── .claude-plugin/
    │   └── plugin.json
    ├── agents/
    │   ├── spec-agent.md
    │   ├── plan-agent.md
    │   ├── build-agent.md
    │   ├── frontend-agent.md
    │   ├── design-agent.md
    │   ├── docs-agent.md
    │   ├── cleanup-agent.md
    │   ├── deploy-agent.md
    │   ├── feature-agent.md
    │   └── nebius-agent.md
    ├── skills/
    │   ├── app-builder/              # /cbs:app-builder
    │   ├── spec/                     # /cbs:spec
    │   ├── plan/                     # /cbs:plan
    │   ├── build/                    # /cbs:build [N]
    │   ├── frontend/                 # /cbs:frontend
    │   ├── design/                   # /cbs:design [style]
    │   ├── docs/                     # /cbs:docs
    │   ├── cleanup/                  # /cbs:cleanup [scope]
    │   ├── deploy/                   # /cbs:deploy [platform]
    │   ├── new-feature/              # /cbs:new-feature [desc]
    │   └── nebius/                   # /cbs:nebius [action]
    ├── hooks/
    │   └── hooks.json
    └── scripts/
        ├── snapshot-before-phase.sh
        ├── progress-reporter.sh
        ├── on-subagent-stop.sh
        ├── on-file-write.sh
        ├── guard-no-secrets.sh
        └── guard-deploy-requires-cleanup.sh
```

---

## Project Artifacts

All phase outputs live in `.app-builder/` inside your project:

| File | Written by |
|------|-----------|
| `state.json` | Orchestrator — pipeline state |
| `spec.md` | spec-agent |
| `plan.md` | plan-agent |
| `build-p[N].md` | build-agent (one per MVP phase) |
| `frontend-basic.md` | frontend-agent |
| `design.md` | design-agent |
| `documentation.md` | docs-agent |
| `cleanup.md` | cleanup-agent |
| `deploy.md` | deploy-agent |
| `features/[name].md` | feature-agent (one per feature) |
| `nebius-config.md` | nebius-agent |
| `activity.log` | Hooks |

---

## Hooks

Hooks fire automatically based on Claude Code lifecycle events — you never call them directly. They run silently in the background unless they find a problem, in which case they surface it or block the action.

### How hooks work

| Event | When it fires |
|-------|--------------|
| `PreToolUse` | Before Claude executes a tool — can **block** the action |
| `PostToolUse` | After a tool finishes — fire-and-forget, logs/warns only |
| `Stop` | When Claude finishes responding — can block session close |
| `SubagentStop` | When a subagent finishes |

`PreToolUse` hooks are the powerful ones — they can inspect what Claude is *about* to do and stop it before it happens. Post hooks can only observe.

---

### Currently active

| # | Hook | Event | Type | What it does |
|---|------|-------|------|--------------|
| 1 | **Git snapshot** | `PreToolUse(Task)` | command | Before every subagent starts: commits current state as a snapshot, creates a `phase/N-name` branch if using branch-per-phase strategy. Silent if nothing to commit. |
| 2 | **Progress reporter** | `PostToolUse(*)` | command | After every tool call: emits a timestamped one-liner so you see live progress instead of "Thinking..." — e.g. `[14:32:01] Phase 3 — ⚙️ Running: pytest tests/` |
| 3 | **Artifact gate** | `Stop` | agent | Blocks the session from closing if the active phase has no output artifact saved yet |
| 4 | **Subagent log** | `SubagentStop` | command | Logs when subagents complete to `.app-builder/activity.log` |

### Approval gate (enforced in orchestrator)

After every phase the orchestrator renders a full pipeline status table and explicitly asks for your approval before advancing. It will never auto-proceed.

```
╔═══════════════════════════════════════════════════════╗
║              APP BUILDER — PIPELINE STATUS            ║
╠═════╦══════════════════════════════╦══════════════════╣
║  #  ║  Phase                       ║  Status          ║
╠═════╬══════════════════════════════╬══════════════════╣
║  1  ║  Spec Definition             ║  ✅ done         ║
║  2  ║  Plan Creation & Validation  ║  ⬅ just finished ║
║  3  ║  MVP Phase 1                 ║  ⏳ pending      ║
...
╚═════╩══════════════════════════════╩══════════════════╝

Ready to move to Phase 3: MVP Phase 1?
  → yes / review / redo / skip / stop
```

---

### Planned (not yet implemented)

Four high-signal hooks identified for a future update. Low noise — each one prevents a specific, real mistake:

| # | Hook | Event | Type | What it does |
|---|------|-------|------|--------------|
| 4 | **Secret scanner** | `PreToolUse(Write\|Edit)` | command | Scans file content for hardcoded secrets (API keys, tokens, private keys) **before** the file lands on disk. Blocks the write and explains what it found. |
| 6 | **Deploy guard** | `Stop` | command | Blocks closing a deploy session if `.app-builder/cleanup.md` doesn't exist or has no security run logged. Forces you to run `/cleanup security` before going live. |
| 7 | **Debug statement blocker** | `PreToolUse(Write\|Edit)` | prompt | Skipped — too noisy. `console.log`, `print()` etc. appear in too many legitimate contexts. Handled better by `/cleanup` with full context. |

To implement hooks 4–6, add the corresponding scripts to `scripts/` and update `hooks/hooks.json`. Each is a self-contained shell script that receives JSON context on stdin.

---

## Team Setup

To enable the plugin for all team members on a project, add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claude-builder-starterpack": {
      "source": "github",
      "repo": "chloepilonv/claude-builder-starterpack"
    }
  },
  "enabledPlugins": {
    "claude-builder-starterpack@claude-builder-starterpack": true
  }
}
```

Anyone who opens the project will have the plugin automatically available.
