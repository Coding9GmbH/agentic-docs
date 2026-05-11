---
name: agentic-documentation
description: Consult and maintain the agent-facing documentation tree at .claude-docs/. ALWAYS invoke — not optional. (1) BEFORE any non-trivial task — read .claude-docs/README.md + .claude-docs/LOOKUP.md + the topic file for the area you are touching. This replaces blind greping and gets you to the answer 5–10× faster. Skip ONLY for trivial one-line localised fixes (typos, renames, whitespace). (2) AFTER any change that adds, renames, or deletes a module / feature / endpoint / DB model / enum / UI primitive / shared hook / store / event / queue / pattern / security rule / workflow — update the affected catalog file IN THE SAME COMMIT as the code change. Not updating is a correctness bug, not a style preference. (3) When the user says "init / regenerate / rebuild / resync claude-docs" — do a full regeneration. Also triggered by /agentic-documentation.
---

# agentic-documentation — you must use this every task

`.claude-docs/` is the structural map of this repo. It exists so you don't waste turns re-discovering what's already written down. Using it is not optional.

**Default posture:** read the docs first, ship the change, update the docs in the same commit. If you didn't touch `.claude-docs/` on a non-trivial change, you almost certainly broke the map — go back and fix it before handing off.

## The three modes

| Mode | When | What |
|---|---|---|
| **CHECK** | Before every non-trivial task | Read `.claude-docs/README.md`, `.claude-docs/LOOKUP.md`, and the topic file for the area you're touching. Use the "I want to …" tables instead of greping. |
| **UPDATE** | After every change that invalidates a catalog entry | Edit the affected doc(s) in the same commit as the code. See the change-matrix below. |
| **INIT** | On explicit user request only | Full regeneration from scratch. See procedure at the end. |

## Why this is worth it

A single CHECK pass on `.claude-docs/LOOKUP.md` + one topic file typically answers questions that would otherwise cost:
- 3–10 `grep` / `find` rounds to locate the right file,
- 1–3 `Read`s to understand conventions already captured in `CONVENTIONS.md` / `PATTERNS.md` / `SECURITY.md`,
- an occasional wrong-module refactor because you didn't know the helper existed.

One minute of reading saves most of the turn. If you find yourself reaching for `Grep` or `Explore` early, stop and check the docs first.

---

## The tree you're maintaining

The exact files depend on the project. A typical layout:

```
.claude-docs/
├── README.md              Master index + read order
├── OVERVIEW.md            Stack, layout, top-level architecture
├── LOOKUP.md              "I want to X → look here" table
├── CONVENTIONS.md         Naming, imports, formatting rules
├── PATTERNS.md            Copy-paste skeletons for common code shapes
├── SECURITY.md            Non-negotiable security rules
├── WORKFLOWS.md           Step-by-step recipes for recurring tasks
├── TESTING.md             Test runners, helpers, fixtures
├── DESIGN-SYSTEM.md       (frontends) Tokens, typography, component rules
└── <area>/                One subfolder per logical area of the repo
    └── README.md          Catalog of modules/features in that area
```

Adapt to the repo: if there is no backend, drop `api/`; if there is no UI, drop `DESIGN-SYSTEM.md` and `web/`. The shape is a guideline, not a contract — what matters is that the tree mirrors the repo's logical layout and every catalog entry is short, structural, and current.

---

## Mode 1: CHECK — always run before coding

**Non-negotiable for non-trivial tasks.** Before you call `Grep`, `Glob`, or spawn an `Explore` agent, you must have read at least `.claude-docs/LOOKUP.md` and the topic file for the area you're touching.

### Procedure

1. **Open `.claude-docs/README.md`** — scan the Index table, identify which topic file maps to the change.
2. **Open `.claude-docs/LOOKUP.md`** — search for the "I want to …" row that matches the task. It usually names the exact file and helper.
3. **Open the topic file(s)** for the area you're touching — backend module, frontend feature, schema, routing, design system, etc.
4. **Read the relevant cross-cutting doc(s)** the task touches:
   - Architectural patterns / DTOs / error handling → `PATTERNS.md`
   - Auth / secrets / permissions / rate limits → `SECURITY.md`
   - Naming / imports / i18n → `CONVENTIONS.md`
   - Tests → `TESTING.md`
   - Recipes / migrations / new endpoint / new page → `WORKFLOWS.md`
5. **Only now** fall back to `Grep` / `Explore` — and only for questions the docs explicitly defer (`see path/to/file`) or clearly don't cover.

### Time budget

CHECK should cost ≤ 60 seconds of reading for most tasks. If you're reading more than four files, the task is bigger than you thought — pause and reconsider scope.

### Skip CHECK only when

- The task is a trivial one-line localised fix (typo, rename, whitespace).
- The user explicitly says "don't read the docs, just do X".
- You're already deep in a verified area from an earlier turn this session.

In all three cases, you still must run UPDATE afterwards if the change invalidates a catalog entry.

---

## Mode 2: UPDATE — always run after a catalog-invalidating change

**The map and the code change together, in the same commit.** A code commit that invalidates `.claude-docs/` without updating it is an incomplete change. Future sessions will waste turns on the stale map.

### Trigger check — run this before you think the task is done

Before declaring a task finished, ask yourself: did any of these change?

> module · feature folder · public endpoint · DB model · enum · UI primitive · shared hook · shared store · realtime hook · emitted event · queue / job · security rule · cross-cutting pattern · workflow recipe · global guard/decorator/middleware/exception · bootstrap entrypoint · routing config · API client.

If yes to any, UPDATE is required — no exceptions.

### How to decide which docs to update

A change affects a `.claude-docs/` file when that file contains a list, table, or rule that names the thing you changed. The general mapping:

| You changed … | Which doc(s) name it |
|---|---|
| Added/renamed/deleted a module or feature folder | The catalog `README.md` for that area + the layout mirror in the top-level `README.md` |
| Added a new permission / role / capability | The permissions doc (often `<area>/PERMISSIONS.md`) |
| Added/renamed a DB model or enum | The schema doc (often `<area>/README.md` for the DB layer) |
| Added a global guard / decorator / middleware / exception | The `common.md` (or equivalent) for that area + the bootstrap doc if registered globally |
| Added a route or page | The routing doc |
| Added a UI primitive | `DESIGN-SYSTEM.md` + the components doc |
| Added a shared store / hook / util | The frontend `lib.md` (or equivalent) |
| Added an event emitted, queue, or job | The module's catalog entry (under "emits" / "queues") + `PATTERNS.md` if a new shape |
| Changed bootstrap / entrypoint / middleware order | The bootstrap doc |
| Added a security rule | `SECURITY.md` |
| Added a new workflow / recipe | `WORKFLOWS.md` |
| Added a reusable code shape | `PATTERNS.md` + one-line entry in `LOOKUP.md` |

If unsure where a thing lives: `grep -l "<keyword>" .claude-docs/` finds the existing home. If no hit, add to the doc whose topic fits best.

### Update procedure

1. Identify which docs are affected.
2. Open each affected doc, find the existing entry / table row, update it. **Don't duplicate** — if a rule is in `SECURITY.md`, link to it from elsewhere rather than restate it.
3. Keep entries **short** (1–5 lines per module / permission / hook). Prefer tables over prose.
4. If a catalog grows past ~400 lines, split it into a dedicated file and update `README.md`.
5. Sanity check cross-refs: `grep -rn "missing-cross-ref" .claude-docs/` should return nothing — stale cross-references are worse than no cross-references.
6. Commit with message prefix `docs(.claude-docs): …`.

### Update completeness checklist

Before marking UPDATE done, verify:

- [ ] `LOOKUP.md` still points to a real location for every entry that relates to the change.
- [ ] `README.md` index table still lists every file that exists.
- [ ] Any module/feature/model count mentioned in prose still matches reality.
- [ ] New cross-reference links actually exist.
- [ ] No human-facing fluff added. Keep it tight.

---

## Mode 3: INIT (regenerate from scratch — use sparingly)

**Goal:** rebuild the tree when it has drifted too far to patch incrementally, or the user explicitly asks.

### Steps

1. **Capture the structural snapshot.** Run the commands appropriate for the repo. Typical examples (adapt to the actual layout):
   ```bash
   # Top-level shape
   ls -la
   # Source tree shape — adapt paths
   find <src-roots> -maxdepth 2 -type d
   # Entrypoints / config
   cat <bootstrap files>
   # Schema / models
   cat <schema files>
   # Public surface
   cat <route table or api index>
   # Build / scripts
   cat package.json Makefile pyproject.toml 2>/dev/null
   ```
   Goal: gather the *shape* and *entrypoints*, not the full contents.

2. **Launch parallel `Explore` subagents** for heavy catalogs (modules, features, models, patterns). Don't try to read every source file yourself — delegate breadth, then synthesize.

3. **Write files in this order** (each depends on the previous):
   1. `OVERVIEW.md` — stack + layout + top-level architecture.
   2. `CONVENTIONS.md`, `PATTERNS.md`, `SECURITY.md` — cross-cutting rules.
   3. `WORKFLOWS.md`, `TESTING.md`, `DESIGN-SYSTEM.md` (if relevant).
   4. Per-area docs (bootstrap, common utilities, schema, routing, etc.).
   5. Area catalogs (`<area>/README.md`) — these depend on everything else.
   6. `LOOKUP.md`, `README.md` — index files last so cross-refs resolve.

4. **Commit in one shot:** `docs(.claude-docs): regenerate from scratch`.

### Quality bar for generated docs

- **Agent-only tone.** No human-facing intros. No "in this document we will explore …". Direct, imperative.
- **Tables over prose** for catalogs and lookups.
- **Every entry ≤ 5 lines.** If more is needed, link to the source file with `path/to/file.ts:NN`.
- **No fluff.** Cut "it's important to note that", "please remember", emojis, rhetorical questions.
- **Every file ends with either:**
  - a "How to extend / update" section (so a future update knows what to edit), OR
  - a "find-it-fast" grep snippet section.
- **No duplicates.** A rule belongs in one doc; others link to it.

---

## Conventions for ALL modes

- This tree is **for AI agents only**. Never use emojis unless the user explicitly asks. Never add greetings, congratulations, or summary fluff.
- Match the language of the existing content. If the project is multi-language, default to English unless the user says otherwise.
- Use relative links between docs (`./PATTERNS.md`), not absolute paths.
- File paths in prose use backticks: `src/foo/bar.ts`.
- After UPDATE, `ls .claude-docs/**/*.md` and `grep -l "TODO\|FIXME\|XXX" .claude-docs/` should surface no accidental markers.
- **Commit style:** `docs(.claude-docs): <short verb phrase>`. Keep doc commits focused — don't bundle with feature code unless the change is small and the doc update is the natural part of the same diff.

---

## When `.claude-docs/` doesn't exist yet

If you're invoked in a repo that has no `.claude-docs/` tree:

1. Confirm with the user that they want one initialised.
2. Run **INIT** (Mode 3) to bootstrap the tree.
3. After init, commit it as `docs(.claude-docs): initial structural map`.

If the user only asks for a single task and not full init, do the task — but if it touches an area that would have been documented, suggest at the end that initialising `.claude-docs/` would save tokens on future tasks.
