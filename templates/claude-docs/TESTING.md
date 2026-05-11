# Testing

What test types exist, where to put a new test, and how to run them.

## Test types

| Type | Runner | Location | Hits real DB? | When to write |
|---|---|---|---|---|
| Unit | `<e.g. Vitest>` | `<*.test.ts next to source>` | No | Pure logic, no I/O. |
| Integration | `<e.g. Vitest>` | `<tests/integration/>` | Yes (test DB) | A handler + service + DB roundtrip. |
| E2E | `<e.g. Playwright>` | `<tests/e2e/>` | Yes (running app) | A user-visible flow. |

## Run commands

```bash
<command — all unit tests>
<command — all integration tests>
<command — a single test file>
<command — e2e tests, headed/headless>
```

## Test database

`<Delete if all tests are pure unit.>`

- Test DB is `<name>`, brought up by `<docker compose / make / script>`.
- Migrations apply automatically before the integration suite.
- Each test file gets `<a fresh schema / a transaction that rolls back / a wiped tenant>`. Pick one and document it here so contributors don't fight it.

## Fixtures & helpers

| Helper | Path | When to use |
|---|---|---|
| `<createTestUser()>` | `<tests/helpers/auth.ts>` | Default authenticated user. |
| `<seedOrg()>` | `<tests/helpers/seed.ts>` | Multi-tenant data setup. |
| `<resetDb()>` | `<tests/helpers/db.ts>` | Use in `beforeEach` for integration. |

## Frontend testing

`<Delete if not a frontend.>`

- Component tests: `<runner, location>`.
- React Testing Library queries — prefer `getByRole` / `getByText`; avoid querying by class.
- Snapshot tests are discouraged; assert on behaviour, not markup.

## CI

- `<Where CI runs tests, e.g. .github/workflows/test.yml>`
- Required to pass before merge: `<unit + integration; e2e nightly only>`.

## When a test fails locally

1. Re-run with verbose output: `<command>`.
2. If it's a flaky env issue (port in use, stale DB), reset: `<command>`.
3. If it's a real failure, fix it in the same change as the code you broke.
4. Don't `it.skip()` to make CI green — that's a separate, more expensive bug.
