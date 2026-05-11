# Conventions

Hard rules. Violating one of these is a bug, not a style preference.

## Naming

- **Files:** `<e.g. kebab-case.ts>` for source; `<e.g. PascalCase.tsx>` for React components.
- **Folders:** `<e.g. lower-kebab-case>`.
- **Symbols:** `<e.g. camelCase for functions/vars, PascalCase for types/classes, UPPER_SNAKE for constants>`.
- **Tests:** `<e.g. *.test.ts next to source, *.e2e.ts under tests/e2e/>`.

## Imports

- `<Import enums and shared types from one place — name it. E.g. always import enums from @prisma/client, never re-declare.>`
- `<Path aliases — list them. E.g. @/* for src/*; never use deep relative paths like ../../../>`
- `<Side-effect imports — anything you allow / forbid.>`

## Formatting & linting

- **Formatter:** `<e.g. Prettier, defaults — config at .prettierrc>`
- **Linter:** `<e.g. ESLint, run via `pnpm lint`>`
- **Run before commit:** `<command>` (or: a pre-commit hook handles it).

## Comments

- Default: no comments. Names should carry the meaning.
- Write a comment only when WHY is non-obvious: an invariant, a workaround, a constraint a reader would otherwise miss.
- Never narrate WHAT the code does. Never reference task IDs, PRs, or callers.

## i18n / localisation

`<Delete this section if you don't have i18n. Otherwise list the rule.>`

- All user-facing strings go through `<e.g. t('namespace.key')>`. No hardcoded literals.
- Keys live in `<path/to/locales/>`. Add a key in every supported language at the same time.

## Frontend-specific

`<Delete if not a frontend.>`

- No native `<button>` / `<input>` / `<select>` — use the design system primitives.
- No inline colour values — use design tokens.
- No `useEffect` for data fetching — use the API client / TanStack Query hooks.

## Backend-specific

`<Delete if not a backend.>`

- Every query must filter `<tenant scope, e.g. organizationId>` and `<soft-delete scope, e.g. deletedAt: null>`.
- Throw domain errors via `<e.g. AppException(code, status)>`. Never `throw new Error('…')` in handlers.
- Permission codes are strings from `<path/to/system-groups.ts>` — never hardcoded.

## When you find a violation

- If it's in code you're touching: fix it in the same change.
- If it's elsewhere: leave a TODO with the file path in `WORKFLOWS.md` under "Tech debt", do not silently refactor.
