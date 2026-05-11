# Overview

Top-level shape of the project. Replace every `<placeholder>` with your project's specifics.

## Stack

- **Language(s):** `<e.g. TypeScript, Python>`
- **Runtime / framework:** `<e.g. Node 22 + NestJS / Bun + Hono / Python 3.12 + FastAPI>`
- **Database:** `<e.g. PostgreSQL + Prisma>`
- **Frontend:** `<e.g. Next.js 15 App Router / none>`
- **Infrastructure:** `<e.g. Docker Compose locally, Kubernetes in prod>`
- **Auth:** `<e.g. JWT, NextAuth, Clerk>`
- **Queues / async:** `<e.g. BullMQ, Celery, none>`

## Top-level layout

```
<repo>/
├── <area1>/               <short description>
├── <area2>/               <short description>
├── <shared>/              <short description>
└── <infra>/               <short description>
```

## Key concepts

`<List the 3–6 ideas a new agent must understand to be useful in this codebase.>`

- **`<Concept 1>`:** one sentence.
- **`<Concept 2>`:** one sentence.
- **`<Concept 3>`:** one sentence.

Examples (delete these once you've added your own):
- **Multi-tenancy** — every query must filter `organizationId`.
- **Soft delete** — never `DELETE`, set `deletedAt`.
- **Permission codes** — guards take string codes from `system-groups.ts`.
- **Type contract flow** — DTOs → OpenAPI → typed fetch client; never write API types by hand.

## What reads what

`<Optional but useful — a small arrows diagram or list showing how the layers call each other.>`

```
<web/> --(typed fetch)--> <api/> --(prisma)--> <db>
                                   `-(events)-> <worker/>
```

## Out of scope

`<Things this repo deliberately does NOT own — so agents don't start refactoring into them.>`

- `<e.g. the marketing site lives in a separate repo>`
- `<e.g. anything under infra/ is managed by the platform team>`
