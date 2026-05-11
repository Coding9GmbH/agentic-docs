# Lookup — "I want to X → look here"

The single most useful doc in this tree. Check here **before** greping.

Each row should be:
- short ("I want to add a route" — not "How do I add a new HTTP route to the application?"),
- specific (names a file or two and a helper),
- current (delete rows that no longer apply).

If you add a feature/module/helper, add a row here. If you delete one, delete the row.

## Routing & entrypoints

| I want to … | Look here |
|---|---|
| `<add a new HTTP route>` | `<path/to/router.ts>` |
| `<change global middleware order>` | `<path/to/bootstrap.ts>` |
| `<find what runs on app start>` | `<path/to/main.ts>` |

## Data layer

| I want to … | Look here |
|---|---|
| `<add a DB model>` | `<schema.prisma>` then `<migrations/>` |
| `<add an enum>` | `<schema.prisma>` + import from `<@prisma/client>` |
| `<query with org scoping>` | `<base-crud.service.ts>` |

## Frontend

| I want to … | Look here |
|---|---|
| `<add a page>` | `<web/app/...>` |
| `<call the API>` | `<lib/api/client.ts>` |
| `<reusable UI primitive>` | `<components/ui/>` |
| `<global state>` | `<lib/stores/>` |

## Patterns / cross-cutting

| I want to … | Look here |
|---|---|
| `<copy a controller skeleton>` | `PATTERNS.md` §controllers |
| `<emit an event>` | `PATTERNS.md` §events |
| `<background job>` | `PATTERNS.md` §queues |
| `<error response>` | `PATTERNS.md` §errors |

## Operational

| I want to … | Look here |
|---|---|
| `<run tests>` | `TESTING.md` |
| `<run a migration>` | `WORKFLOWS.md` §migrations |
| `<add a permission code>` | `WORKFLOWS.md` §permissions |

## How to extend this file

- One row per "I want to …" intent.
- Keep the right column to a single path or two and (optionally) a section reference.
- Delete obsolete rows when code moves or disappears.
- If a category grows past ~15 rows, split it into a dedicated topic doc.
