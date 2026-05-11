# Security

Non-negotiable rules. Check this file before any change to auth, data access, secrets, or user input handling.

If a change would violate any of these, stop and surface the conflict — do not "work around" a security rule.

## Authentication

- `<Where session/JWT/token is verified, e.g. global guard at api/src/main.ts>`
- `<What identifies a request — userId? sessionId? — and where it lands on the request object>`
- `<Token lifetime and refresh flow — link to api-client or auth doc>`

## Authorisation

- `<How permission checks are enforced (e.g. @RequirePermission('code') decorator)>`
- `<Where permission codes are defined (single source of truth)>`
- Never hardcode role/permission strings outside that source.

## Multi-tenancy

`<Delete if single-tenant.>`

- Every read and write on tenant-scoped tables must filter `<tenant column>`.
- The tenant id comes from the authenticated session — never from request body / query string.
- Lookups by primary key are not safe by themselves on multi-tenant tables — always join the tenant column.

## Soft delete

`<Delete if not used.>`

- Every read filters `<soft-delete column, e.g. deletedAt: null>` unless the caller is admin-tooling that explicitly wants tombstones.

## Input handling

- All untrusted input is validated at the boundary via `<DTO library / validator>`. Handlers must not parse raw bodies.
- File uploads: `<max size, allowed mime types, where the scanner lives>`.
- HTML rendering: `<which sink escapes, which one trusts (e.g. dangerouslySetInnerHTML rules)>`.

## Secrets

- Secrets live in `<env file path, secret manager>`. Never commit `.env`, never log a secret, never put one in an error message.
- The list of expected env vars is validated at startup via `<config schema location>`.
- Rotating a secret: see `WORKFLOWS.md` §rotate-secret.

## Rate limits & abuse

- `<Where the global rate limiter is configured, default limits>`
- `<Per-endpoint overrides — naming convention>`

## CSRF / CORS

- `<CORS allow-list location>`
- `<CSRF strategy — token? same-site cookie? none because pure-API?>`

## Logging & PII

- Never log: `<list of fields — passwords, tokens, emails (if PII), full request bodies>`.
- Structured logs only via `<logger path>`.
- Errors carrying user data are scrubbed by `<filter location>` before they leave the process.

## Dependencies

- New runtime deps require: `<approval process, e.g. justification in PR description>`.
- Audit: `<command, e.g. pnpm audit --prod>` runs in CI; failures block merge.

## When something looks wrong

- Don't quietly "fix" or refactor a suspected vulnerability. Flag it (PR comment, issue) and link to the offending line.
- Don't paste suspect tokens, dumps, or secrets into chats / tickets — redact first.
