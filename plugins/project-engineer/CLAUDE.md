# CLAUDE.md

This directory contains the `pe` Claude Code plugin. It is distributed through the marketplace repo at the workspace root.

## Overview

`pe` is an adaptive project-engineering plugin for Web and API work.

- `light`: `README.md` plus `CLAUDE.md`
- `feature`: light mode plus `.project-engineer/FEATURE-{slug}.md`
- `project`: feature-level structure plus `PRD.md` and `.project-engineer/status.md`

The goal is to avoid defaulting every repo into heavyweight planning documents. Documentation expands only when complexity warrants it.

## Directory Layout

```text
project-engineer-marketplace/
├── .claude-plugin/marketplace.json
└── plugins/project-engineer/
    ├── .claude-plugin/plugin.json
    ├── commands/
    ├── hooks/
    ├── templates/
    ├── CLAUDE.md
    └── README.md
```

## How It Works

- `commands/` contains Markdown command definitions with frontmatter.
- `hooks/` detects code changes and emits reminders.
- `templates/` provides the generated artifact shapes for each workflow mode.
- The plugin relies on mode escalation instead of always-on heavy process.

## Development Notes

- There is no build step.
- Keep Markdown and JSON files UTF-8 without BOM.
- Keep shell scripts on LF line endings so `bash` runs them correctly after install.
- Do not point `plugin.json` at `./hooks/hooks.json`; Claude auto-loads the default hooks file from `hooks/`.
- Hooks require `bash`.
- `hooks/post-tool-use.sh` requires `python3` or `python`.

## Local Validation

From the marketplace root:

```bash
claude plugin validate .
claude plugin validate ./plugins/project-engineer
```

## Local Development Loop

From the marketplace root:

```bash
claude --plugin-dir ./plugins/project-engineer
```

After editing plugin files, run `/reload-plugins` inside Claude Code.

## Important Files

- `commands/init.md`: adaptive initialization and mode selection
- `commands/focus.md`: primary next-step command
- `commands/req-update.md`: small, medium, or large requirement-change routing
- `commands/status-update.md`: execution board maintenance for project or legacy repos
- `hooks/post-tool-use.sh`: per-write detection and reminder trigger
- `hooks/session-end.sh`: session summary and sync reminder
- `templates/README_TEMPLATE.md`: always-on human entry point
- `templates/CLAUDE_TEMPLATE.md`: always-on AI entry point
- `templates/FEATURE_TEMPLATE.md`: medium-complexity feature brief
- `templates/STATUS_TEMPLATE.md`: project-mode execution board template
