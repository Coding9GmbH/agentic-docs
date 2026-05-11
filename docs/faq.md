# FAQ

### Isn't this what `CLAUDE.md` is for?

`CLAUDE.md` is a single file, always loaded into the context. It's great for short, project-wide guidance (e.g. "use `pnpm`, not `npm`"). It's a poor fit for a structural map of a real codebase — that map will be 5–20 files, and you want Claude to load only the relevant ones per task.

This skill complements `CLAUDE.md`: put **commandments** in `CLAUDE.md`, put the **map** in `.claude-docs/`.

### How is this different from regular project documentation?

Project docs (READMEs, ADRs, wiki pages) are written for humans: narrative, longform, often background-heavy. Agents skim them, miss things, and burn tokens re-reading them.

`.claude-docs/` is written for agents: terse, tabular, imperative. Every entry answers a specific question ("where do I find X?") in 1–5 lines. It's a map, not a manual.

The two can coexist. Many teams keep a top-level `README.md` for humans and a `.claude-docs/` for agents.

### Does the doc tree go in version control?

Yes. The map should travel with the code, get reviewed in PRs, and live in the same history. Reviewers can use it as a quick check that the author actually understood what they changed.

### What if Claude forgets to update the docs?

Several layers catch this:
- The `SessionStart` hook reminds Claude on every session start.
- The skill description is loaded on demand whenever Claude considers using it.
- The skill's UPDATE checklist asks Claude to verify before declaring a task done.

If you still see drift, tighten the trigger list in your installed `SKILL.md` (see [`customization.md`](./customization.md) §2).

### Does the skill make API calls or run anything?

No. The skill is just a `SKILL.md` file — instructions to Claude. The hook prints a JSON snippet on `SessionStart`. Nothing runs against external services.

### Does it work without the hook?

Yes, but worse. Without the hook, Claude has to "remember" to consult the skill, and skills compete with everything else in context. The hook injects a one-paragraph reminder on every session — the cost is ~50 tokens and it makes the difference between "Claude usually checks the map" and "Claude always checks the map".

### What about multi-repo / monorepo?

Two options:

1. **One tree per package** — each subdir gets its own `.claude-docs/`. Hooks at the monorepo root can point Claude at whichever one is relevant.
2. **One tree at the root** — a single `.claude-docs/` mirrors the monorepo structure with one subfolder per package.

Option 2 is simpler and usually enough.

### How big should the tree get?

Each individual file should stay under ~400 lines. Past that, split. The whole tree of a real, complex codebase usually lands around 2–6k lines total — small enough that Claude can load any 2–3 files in one session, large enough to genuinely replace exploration.

### Can I version this skill alongside other skills?

Yes. The skill lives at `.claude/skills/agentic-documentation/SKILL.md` — Claude Code will load it alongside any other skills in `.claude/skills/`. No conflicts.

### Does this work outside of Claude Code (e.g. API SDK, web app)?

The skill mechanism is Claude Code–specific. The doc tree, however, is plain markdown — useful to any agent that can read files. You can copy the `SKILL.md` instructions into a system prompt for other agents and reap most of the benefit.

### What's the prior art?

The structural-map idea isn't new — projects have shipped agent-tuned docs under various names (`.cursor/`, `.aider/`, `LLM-docs/`, `AGENTS.md` …). What this repo contributes is the **skill + hook** wrapper specifically tuned to Claude Code's hooks and skill mechanics, plus an opinionated three-mode workflow that's been validated in production.
