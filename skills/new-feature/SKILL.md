---
name: new-feature
description: Add a new feature to a live product. Handles mini-spec, build, test, and deploy for a single feature without disrupting existing functionality. Examples — /new-feature add Stripe billing | /new-feature dark mode | /new-feature export CSV
disable-model-invocation: false
---

# App Builder — New Feature

Invoke the `feature-agent` subagent to add a new feature to the existing product.

**Usage examples:**
```
/new-feature add email notifications for new orders
/new-feature Stripe subscription billing with 3 tiers
/new-feature admin dashboard for user management
/new-feature Algolia search integration
/new-feature dark mode toggle
/new-feature export analytics to CSV
/new-feature rate limiting on the API
/new-feature onboarding flow for new users
```

Pass `$ARGUMENTS` directly to feature-agent as the feature description.

Require that `.app-builder/deploy.md` exists — the app should be live before adding features. If it doesn't exist, warn the user but proceed anyway if they confirm.

Each feature gets logged to `.app-builder/features/[feature-name].md`.

To see all features built so far:
```
/app-builder features
```
