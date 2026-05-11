# Claude Docs

**This directory is for AI agents (Claude). It is not human-facing documentation.**
Keep entries short, structural, and imperative. Prefer tables and checklists over prose.

## How to use this

Open this page first whenever you start a task in this repo. It is a map — every link below points to a specific doc that tells you exactly where to find things and how to work in that area without searching the codebase blindly.

## Read order for new tasks

1. **`OVERVIEW.md`** — stack, top-level layout, key concepts.
2. **`LOOKUP.md`** — "I want to X → look here" table. Check this before greping.
3. **`CONVENTIONS.md`** — hard rules (naming, imports, formatting).
4. Open the specific doc for the area you're touching.

## Index

### Cross-cutting

| Doc | When to open |
|---|---|
| [`OVERVIEW.md`](./OVERVIEW.md) | Start here. Stack + layout + key concepts. |
| [`LOOKUP.md`](./LOOKUP.md) | Fast "where do I find X" lookup. |
| [`CONVENTIONS.md`](./CONVENTIONS.md) | Naming, imports, formatting rules. |
| [`PATTERNS.md`](./PATTERNS.md) | Copy-paste skeletons for common code shapes. |
| [`SECURITY.md`](./SECURITY.md) | Non-negotiable security rules. |
| [`WORKFLOWS.md`](./WORKFLOWS.md) | Step-by-step recipes. |
| [`TESTING.md`](./TESTING.md) | Test runners, helpers, fixtures. |

<!--
Add per-area sections below. Mirror the repo's logical layout.
Example:

### API backend

| Doc | Scope |
|---|---|
| [`api/bootstrap.md`](./api/bootstrap.md) | Entrypoints, global wiring. |
| [`api/modules/README.md`](./api/modules/README.md) | Catalog of feature modules. |

### Web frontend

| Doc | Scope |
|---|---|
| [`web/routing.md`](./web/routing.md) | Route layout, middleware. |
| [`web/features/README.md`](./web/features/README.md) | Catalog of feature modules. |
-->

## Navigation rules for agents

- **Don't** re-read source files already summarised here. Read the doc first, only dive into source when the doc says "see X" or when you're making a change.
- **Don't** duplicate information. If a rule lives in `SECURITY.md`, link to it from other docs — don't restate.
- **Do** update this tree when you add a module, feature, endpoint, model, hook, store, event, or workflow. A stale map is worse than no map.
- **Do** prefer the `LOOKUP.md` table over grepping when the question maps to a known "I want to …" entry.

## Layout mirror

```
.claude-docs/
├── README.md              (this file — master index)
├── OVERVIEW.md
├── LOOKUP.md
├── CONVENTIONS.md
├── PATTERNS.md
├── SECURITY.md
├── WORKFLOWS.md
└── TESTING.md
<!-- Add area subfolders here as the project grows. -->
```

## When this doc is wrong

- If a fact here contradicts the source: the source wins. Update the doc.
- If something isn't documented: add it. Prefer a one-line entry in `LOOKUP.md` + a section in the right topic doc over creating a new file.
- Keep entries short. If a topic grows beyond ~400 lines, split it.
