# Customization

The skill, hook, and templates are intentionally generic. They will reach their full value only when you tailor them to *your* repo. This page lists the high-leverage knobs.

## 1. Match the doc tree to your repo's layout

The biggest win. The templates ship with cross-cutting docs (`OVERVIEW.md`, `LOOKUP.md`, `PATTERNS.md`, …) and no area subfolders. Your repo will need at least one per logical area.

Examples:

- **Monorepo with API + web** → add `.claude-docs/api/`, `.claude-docs/web/`, each with its own `README.md` cataloguing modules / features.
- **Single library** → drop `DESIGN-SYSTEM.md`, `WORKFLOWS.md` may shrink to a single recipe section, and you may not need any subfolders.
- **CLI tool** → add `.claude-docs/commands/README.md` cataloguing subcommands; `PATTERNS.md` covers argument parsing and output formatting.

The rule: **one doc per topic, one subfolder per logical area.** Add only what you'll keep current.

## 2. Tighten the UPDATE trigger list

Open `.claude/skills/agentic-documentation/SKILL.md` and edit the "Trigger check" list under *Mode 2: UPDATE*. The shipped list is broad on purpose:

> module · feature folder · public endpoint · DB model · enum · UI primitive · shared hook · shared store · realtime hook · emitted event · queue / job · security rule · cross-cutting pattern · workflow recipe · global guard/decorator/middleware/exception · bootstrap entrypoint · routing config · API client.

Replace it with the artifacts that actually exist in your repo. Specific triggers fire reliably; vague ones get ignored.

## 3. Tighten the change-to-doc matrix

Same section, the "How to decide which docs to update" table. Replace the generic rows with rows that name your actual files:

```markdown
| Change                                              | Doc(s) to update                          |
|-----------------------------------------------------|-------------------------------------------|
| Added a module under `services/`                    | `.claude-docs/services/README.md`         |
| Added a permission code in `permissions.ts`         | `.claude-docs/api/PERMISSIONS.md`         |
| Added a route under `apps/web/app/`                 | `.claude-docs/web/routing.md`             |
```

The more specific you make this table, the less Claude has to guess.

## 4. Customise the SessionStart pointer

Open `hook/session-start-claude-docs-pointer.sh` (in this repo) or `.claude/hooks/session-start-claude-docs-pointer.sh` (in your project once installed). Edit the `additionalContext` string to mention the artifacts your project cares about:

```json
"additionalContext": "Agent-facing docs at .claude-docs/. READ README.md + LOOKUP.md before greping. AFTER changes to modules/services/permissions/models/queues, run the agentic-documentation skill to update catalog entries."
```

Keep it to a paragraph. Hooks compete for context budget.

## 5. Add area catalogs

A *catalog* is a single doc that lists every module/feature in an area, one row each, with: name · purpose · top files · key models / events / queues. Example:

```markdown
| Module | Purpose | Top files | Emits | Reads |
|---|---|---|---|---|
| `orders` | Order lifecycle | `orders.controller.ts`, `orders.service.ts` | `order.created` | `Order`, `OrderItem` |
| `payments` | Payment processing | `payments.service.ts`, `webhook.controller.ts` | `payment.captured` | `Payment` |
```

Catalogs are the highest-density agent doc — one row replaces ~5 grep/read rounds.

## 6. Decide commit policy

The skill says: "update docs in the same commit as the code change". You can soften this to "same PR" if your team batches commits, but **don't** soften it to "next sprint" — the map will drift.

If you want enforcement: add a CI check that fails when source under a documented area changes without a `.claude-docs/` change in the same diff. (Not required, but a tight feedback loop.)

## 7. Language

If your codebase is non-English, write the docs in the project's language. The skill is currently English; you can translate it, but keep the structure (CHECK / UPDATE / INIT) since it's referenced by the description metadata and slash command.

## What NOT to customise

- The three-mode shape (`CHECK` / `UPDATE` / `INIT`) — that's the part Claude has been trained to invoke reliably.
- The agent-only tone in templates — adding human-facing fluff defeats the point.
- The `SessionStart` hook event — other events (PreToolUse / PostToolUse) fire too often and dilute attention.
