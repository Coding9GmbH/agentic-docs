# Patterns

Copy-paste skeletons for recurring code shapes. Each section gives the canonical structure — when in doubt, follow this exactly. Diverge only when a section explicitly says "see X for the exceptional case".

Replace every `<placeholder>` with the right name/path for the new code you're writing.

## 1. `<Pattern name — e.g. Controller>`

**When:** `<one sentence on when this applies>`.

**Skeleton:**

```ts
// <path/to/file.ts>
<paste the canonical minimal example here>
```

**Rules:**
- `<rule 1>`
- `<rule 2>`

**See also:** `<related pattern>` if `<condition>`.

---

## 2. `<Pattern name — e.g. Service>`

**When:** …

```ts
<skeleton>
```

**Rules:**
- …

---

## 3. `<Pattern name — e.g. DTO / request validation>`

**When:** …

```ts
<skeleton>
```

---

## 4. `<Pattern — e.g. Multi-tenant query>`

**When:** any query that reads or writes tenant-scoped data.

```ts
// Always filter the tenant scope and soft-delete sentinel.
<canonical query example>
```

**Rules:**
- Never `findUnique` on a tenant-scoped table without joining the tenant id.
- Never trust `req.body.organizationId` — read it from the authenticated session.

---

## 5. `<Pattern — e.g. Event emit / subscribe>`

`<Delete the section if not applicable. Otherwise: when to emit, the naming convention for event keys, where subscribers live.>`

---

## 6. `<Pattern — e.g. Background job / queue>`

`<Delete if not applicable.>`

---

## 7. `<Pattern — e.g. Error responses>`

Every API error returns the canonical shape:

```json
{ "code": "<MACHINE_READABLE>", "message": "<human-readable>", "status": <http-status> }
```

Throw via `<helper>`, never `throw new Error('…')` from a handler.

---

## 8. `<Pattern — e.g. Frontend data fetching>`

`<Delete if not a frontend. Otherwise: where the API client lives, how query keys are derived, how mutations invalidate.>`

---

## How to extend this file

- One section per pattern. Don't merge unrelated patterns.
- Keep skeletons minimal — link to the best real example in the repo for variants.
- When you add a new pattern, also add a one-line row in `LOOKUP.md`.
- When a pattern changes, update every example in this file at the same time.
