# Examples

What a real `.claude-docs/` tree looks like for different shapes of projects. Use these as starting points, not gospel — your repo's map should mirror *your* layout.

## Example 1 — NestJS + Next.js + Prisma (the original)

A multi-tenant SaaS with REST API, web frontend, and a worker. The doc tree that inspired this skill:

```
.claude-docs/
├── README.md                  Master index, read order, "I want to … → …" quick rules
├── OVERVIEW.md                Stack, multi-tenancy model, layout
├── LOOKUP.md                  ~80 rows of "I want to X → look here"
├── CONVENTIONS.md             Naming, enum imports, no-native-HTML
├── PATTERNS.md                Controller/service/DTO/events/queues/errors
├── SECURITY.md                Auth, multi-tenant filters, secrets, rate limits
├── WORKFLOWS.md               Add endpoint · DB migration · new page · permission · rotate secret
├── TESTING.md                 Vitest + Playwright + test DB lifecycle
├── DESIGN-SYSTEM.md           Tokens, typography, primitive list
├── api/
│   ├── bootstrap.md           main.ts, app.module.ts, global guards/filter, env validation
│   ├── common.md              common/ layer: decorators, guards, exceptions, BaseCrudService
│   ├── PERMISSIONS.md         Full permission matrix, system groups, how to add a code
│   └── modules/README.md      Catalogue of 52 feature modules (purpose · top files · models · emits)
├── prisma/
│   └── README.md              139 models grouped by domain · enums · indexes · migrations
├── web/
│   ├── routing.md             App Router, route groups, middleware (subdomain + i18n + auth)
│   ├── api-client.md          openapi-fetch + auth middleware + refresh + query keys
│   ├── lib.md                 stores, hooks, realtime, utils, constants, i18n, tracking
│   ├── components.md          UI primitives, where to put a component
│   └── features/README.md     Catalogue of 48 feature modules (vertical slices)
└── openapi/
    └── README.md              How openapi.yaml is generated, type flow to web
```

Key choices:
- **Two catalog files** (`api/modules/README.md` + `web/features/README.md`) are the highest-density docs — each row replaces 3–10 grep rounds.
- **`PERMISSIONS.md`** is its own file because the matrix is large and changes often. Splitting it from `SECURITY.md` keeps both readable.
- **`openapi/README.md`** is a single file because the type-generation flow is narrow. Could be a subsection of `api/`, but splitting makes it findable.

Total tree size: ~3,500 lines across ~15 files. CHECK passes typically read 2–3 files.

## Example 2 — Single Python library

A pure library with no UI, no DB, just code and tests:

```
.claude-docs/
├── README.md
├── OVERVIEW.md
├── LOOKUP.md
├── CONVENTIONS.md             PEP-8 deviations, import style, type-checking rules
├── PATTERNS.md                Public API shape · error classes · async patterns
├── WORKFLOWS.md               Add a public function · release a version · run benchmarks
└── TESTING.md                 pytest config · fixtures · property-based tests
```

No `SECURITY.md` (no auth surface). No `DESIGN-SYSTEM.md`. No subfolders — the whole package is one logical area.

Total tree size: ~600 lines across 7 files.

## Example 3 — CLI tool

A binary with subcommands:

```
.claude-docs/
├── README.md
├── OVERVIEW.md                Stack, layout, entry binary
├── LOOKUP.md
├── CONVENTIONS.md             Argument parsing, exit codes, output formatting
├── PATTERNS.md                Subcommand skeleton · error reporting · plugin hooks
├── SECURITY.md                Input validation, shell injection prevention, secrets via env
├── TESTING.md                 Snapshot testing for CLI output
└── commands/
    └── README.md              Catalogue of every subcommand: flags, output, exit codes
```

The catalog is `commands/README.md`. The single most-read file in this layout.

## How to adapt

Pick the example closest to your project. Then:

1. Delete docs you don't need.
2. Add area subfolders matching *your* repo's logical groupings.
3. Fill in placeholders from `templates/claude-docs/` — those are deliberately project-agnostic.
4. After your first INIT pass, prune anything Claude wrote that you don't recognise or won't maintain.

The map only pays off if it's current. A 2-file tree that's true beats a 20-file tree that's drifted.
