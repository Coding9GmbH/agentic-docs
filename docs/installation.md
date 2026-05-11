# Installation

Three paths, depending on how much control you want.

## Path A — installer script

From inside your target project:

```bash
/path/to/agentic-docs/install.sh
```

Or from anywhere with an explicit target:

```bash
/path/to/agentic-docs/install.sh /path/to/your/project
```

Flags:

- `-y` / `--yes` — skip the overwrite confirmation prompts (use only when you've already inspected what's there).
- `-h` / `--help` — print usage.

What it does, in order:

1. **Skill** → `.claude/skills/agentic-documentation/SKILL.md`
2. **Hook** → `.claude/hooks/session-start-claude-docs-pointer.sh` (made executable)
3. **`settings.json`** — creates the file if missing, otherwise merges the `SessionStart` entry with `jq`. If `jq` is not installed, it prints the entry you need to add manually and leaves the file untouched.
4. **Templates** → copies `templates/claude-docs/` into `.claude-docs/` **only if `.claude-docs/` does not already exist**. Existing trees are never touched.

## Path B — manual

```bash
cd /path/to/your/project

mkdir -p .claude/skills/agentic-documentation .claude/hooks .claude-docs

cp /path/to/agentic-docs/skill/SKILL.md \
   .claude/skills/agentic-documentation/SKILL.md

cp /path/to/agentic-docs/hook/session-start-claude-docs-pointer.sh \
   .claude/hooks/
chmod +x .claude/hooks/session-start-claude-docs-pointer.sh

cp -R /path/to/agentic-docs/templates/claude-docs/. .claude-docs/
```

Then add to `.claude/settings.json` (create if missing):

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

## Path C — git submodule

If you want to track upstream changes to the skill, you can vendor it as a submodule:

```bash
git submodule add https://github.com/Coding9GmbH/agentic-docs .vendor/agentic-docs
./.vendor/agentic-docs/install.sh
```

This makes upstream pulls a one-command `git submodule update --remote` + re-run of `install.sh`.

## Verification

After installing, restart Claude Code in the project. On `SessionStart` you should see (in the session's hidden context) a pointer to `.claude-docs/` and the skill. Quickest way to test:

> What did the SessionStart hook tell you?

Claude should be able to summarise the pointer text. If not, check:

- `.claude/hooks/session-start-claude-docs-pointer.sh` exists and is executable.
- `.claude/settings.json` references it correctly.
- `.claude-docs/README.md` exists (the hook is silent when the docs tree is missing).

## Uninstall

```bash
rm -rf \
  .claude/skills/agentic-documentation \
  .claude/hooks/session-start-claude-docs-pointer.sh
```

Remove the `SessionStart` entry from `.claude/settings.json` (if you only added this one, the file can go entirely).

You can leave `.claude-docs/` in place — once written, it has independent value as project documentation.
