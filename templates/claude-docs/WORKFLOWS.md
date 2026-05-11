# Workflows

Step-by-step recipes for recurring tasks. Each recipe should be runnable end-to-end without further research.

If a recipe needs to deviate from the steps below, capture the deviation here — don't rely on memory.

## Add a new HTTP endpoint

1. `<Define the DTO at path/to/dto.ts>`.
2. `<Add the route handler in path/to/controller.ts>` — follow the controller skeleton in [`PATTERNS.md`](./PATTERNS.md).
3. `<Register the module if new>`.
4. Generate types: `<command, e.g. make generate>`.
5. Add an integration test: `<location>` — follow [`TESTING.md`](./TESTING.md).

## Add a new database model

1. Edit `<schema file>` — follow the field/column conventions in [`CONVENTIONS.md`](./CONVENTIONS.md).
2. Generate migration: `<command>`.
3. Review the SQL — destructive ops (`DROP`, `ALTER … DROP`, type changes) need a manual review and a rollout plan.
4. Update `<schema doc, e.g. .claude-docs/prisma/README.md>` with the new model row.
5. Apply locally: `<command>`. CI applies in staging on merge.

## Add a permission code

1. Add the code to `<system-groups.ts>` under the right category.
2. Update `<.claude-docs/permissions doc>` with the new row.
3. Use `<decorator>` to enforce it on the endpoint.
4. Migration to grant the code to existing roles: `<location>`.

## Add a feature page (frontend)

`<Delete if not a frontend.>`

1. `<Create file at web/app/...>`.
2. Wire data with `<API client + query key>` — see [`web/api-client.md`].
3. Use design system primitives only — see [`DESIGN-SYSTEM.md`].
4. Update `<.claude-docs/web/features/README.md>` and `<.claude-docs/web/routing.md>`.

## Run a destructive migration safely

1. Open a draft PR with the migration; do not merge yet.
2. Confirm the rollout plan: `<expand-and-contract steps>`.
3. Coordinate timing in `<comms channel>`.
4. Apply to staging, verify, then production.
5. Mark the PR ready and merge.

## Rotate a secret

1. Generate new value in `<secret manager>`.
2. Roll it into the runtime via `<deploy step>`.
3. Verify the application uses the new value (`<health check>`).
4. Revoke the old value.
5. Note the rotation in `<audit log location>`.

## Run the full test suite locally

1. `<command, e.g. pnpm install>`
2. `<command, e.g. docker compose up -d>`
3. `<command, e.g. pnpm test>` — see [`TESTING.md`](./TESTING.md) for filters.

## Tech debt

`<Park items here when a violation is found in code you can't refactor right now. One line each, with path + reason.>`

- `<path/to/file.ts:NN — uses deprecated helper foo(), migrate to bar()>`
