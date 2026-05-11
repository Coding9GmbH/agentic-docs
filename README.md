# agentic-docs

> Make Claude Code maintain a structural map of your repo — for itself.

A drop-in **skill + hook** combo for [Claude Code](https://docs.claude.com/en/docs/claude-code) that keeps an agent-facing documentation tree (`.claude-docs/`) in sync with your codebase. Claude reads it before every task and updates it after every change.

## The problem

Every new Claude Code session starts cold. It re-greps to find your modules, re-reads your conventions, re-discovers your patterns. On a real codebase this burns dozens of tool calls per task and slows everything down.

Project documentation written *for humans* (README, ADRs, wiki pages) doesn't help — it's narrative, long, and easy to skip. Claude needs something different: a **map**, written for agents, that says "if you want to do X, look in Y," with tables and one-liners instead of prose.

## The solution

This repo gives you three things:

1. **A skill** (`agentic-documentation`) that tells Claude:
   - **CHECK** the map before any non-trivial task — replaces blind greping.
   - **UPDATE** the map in the same commit as the code change — prevents drift.
   - **INIT** the map from scratch on demand.
2. **A `SessionStart` hook** that injects a pointer to the map and the skill into every session, so Claude can't forget to check.
3. **Starter templates** for the `.claude-docs/` tree, so you can bootstrap it on day one.

Together they create a feedback loop: Claude reads the map → ships the change → updates the map → the next session reads a slightly better map. The map gets *better*, not staler, with every commit.

## What it looks like

A typical `.claude-docs/` tree:

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
└── <area>/                One subfolder per logical area of the repo
    └── README.md          Catalog of modules/features in that area
```

Every file is short, structural, agent-first. No "in this document we will explore…". Tables over prose. Every entry ≤ 5 lines or it links to source.

## Install

### Option 1 — installer script (recommended)

From inside the target project's root:

```bash
curl -fsSL https://raw.githubusercontent.com/Coding9GmbH/agentic-docs/main/install.sh | bash
```

Or clone this repo and run:

```bash
/path/to/agentic-docs/install.sh /path/to/your/project
```

The installer:
- Copies the skill to `.claude/skills/agentic-documentation/SKILL.md`
- Copies the hook to `.claude/hooks/session-start-claude-docs-pointer.sh` (executable)
- Merges the `SessionStart` hook entry into `.claude/settings.json` (creates it if missing)
- Copies starter templates to `.claude-docs/` **only if that directory does not already exist**

Existing files are never overwritten without a prompt.

### Option 2 — manual install

```bash
# From the root of your target project
mkdir -p .claude/skills/agentic-documentation .claude/hooks .claude-docs

# Copy the skill
cp /path/to/agentic-docs/skill/SKILL.md \
   .claude/skills/agentic-documentation/SKILL.md

# Copy the hook
cp /path/to/agentic-docs/hook/session-start-claude-docs-pointer.sh \
   .claude/hooks/
chmod +x .claude/hooks/session-start-claude-docs-pointer.sh

# Copy starter templates
cp -R /path/to/agentic-docs/templates/claude-docs/. .claude-docs/
```

Then add the hook to `.claude/settings.json`:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/session-start-claude-docs-pointer.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

## Bootstrap the map

After install, ask Claude:

> Init the .claude-docs tree for this project.

Claude will run the skill in **INIT** mode: snapshot the repo's shape, dispatch parallel `Explore` agents for heavy catalogs, and write the doc tree from scratch. Review the result, commit, and you're done.

If you'd rather hand-curate, edit the templates in `.claude-docs/` directly. The templates ship with `<placeholder>` markers — fill them in and Claude will keep them current from there.

## How the three modes work

### CHECK — before every non-trivial task

Claude reads `.claude-docs/LOOKUP.md` + the topic file for the area being touched **before** any grep. Typical cost: 1 minute of reading replaces 3–10 tool calls of exploration.

### UPDATE — after every catalog-invalidating change

If a change adds/renames/deletes a module, model, endpoint, UI primitive, hook, event, queue, security rule, or workflow, Claude updates the affected docs **in the same commit**. The map and the code change together, or the change is incomplete.

### INIT — on explicit request

> rebuild .claude-docs from scratch

Used when the tree has drifted too far to patch, or on first install.

## Customizing

The skill is intentionally project-agnostic. Adapt it to your repo:

- **Edit `templates/claude-docs/README.md`** to describe *your* topic files and read order.
- **Drop docs you don't need.** No frontend? Delete `DESIGN-SYSTEM.md` and `web/`. Pure library? Drop `WORKFLOWS.md`.
- **Add area subfolders** mirroring your repo's logical layout (`api/`, `web/`, `worker/`, `infra/`, `docs/`, …).
- **Tighten the trigger list** in the skill's UPDATE section to match the artifacts that actually exist in your project (Prisma models? gRPC services? Helm charts?).

The only hard rule: every file is short, structural, agent-first.

## Why a hook?

The hook isn't strictly required — but without it, Claude has to "remember" to consult the skill, and skills compete for attention. The `SessionStart` hook injects a one-paragraph pointer into the context on every session start, so the skill stays top-of-mind without you having to remind Claude in each prompt.

The hook is silent (`exit 0` with no output) when `.claude-docs/` doesn't exist, so it's safe to leave installed on branches that haven't initialised the map yet.

## What's in this repo

```
agentic-docs/
├── README.md                 You are here
├── LICENSE                   MIT
├── install.sh                Installer
├── skill/
│   └── SKILL.md              The skill file
├── hook/
│   └── session-start-claude-docs-pointer.sh
├── templates/
│   └── claude-docs/          Starter templates with placeholders
│       ├── README.md
│       ├── OVERVIEW.md
│       ├── LOOKUP.md
│       ├── CONVENTIONS.md
│       ├── PATTERNS.md
│       ├── SECURITY.md
│       ├── WORKFLOWS.md
│       └── TESTING.md
├── examples/
│   └── README.md             Example trees from real projects
└── docs/
    ├── installation.md
    ├── customization.md
    └── faq.md
```

## Prerequisites

- [Claude Code](https://docs.claude.com/en/docs/claude-code) installed.
- A git repo (recommended — the skill is most valuable when changes are committed alongside doc updates).
- `bash` and standard POSIX tools for the installer (`cp`, `chmod`, `mkdir`).

## License

[MIT](./LICENSE) — © 2026 [Coding 9 GmbH](https://coding9.de)

## Acknowledgements

This pattern emerged from real production use on a NestJS + Next.js + Prisma codebase at [Coding 9 GmbH](https://coding9.de) where blind greping was burning ~30% of each session. The map paid for itself within a week.
