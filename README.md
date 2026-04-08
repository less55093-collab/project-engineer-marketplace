# project-engineer-marketplace

Claude Code marketplace repository for `project-engineer`, an adaptive project-engineering plugin that stays lightweight by default and adds more structure only when the work becomes complex enough to justify it.

## Repository Layout

```text
.
├── .claude-plugin/marketplace.json
└── plugins/
    └── project-engineer/
        ├── .claude-plugin/plugin.json
        ├── commands/
        ├── hooks/
        ├── templates/
        ├── CLAUDE.md
        └── README.md
```

This matches Claude Code's current marketplace layout:
- the marketplace manifest lives at `.claude-plugin/marketplace.json`
- the plugin manifest lives at `plugins/project-engineer/.claude-plugin/plugin.json`
- commands, hooks, and templates stay at the plugin root, not inside `.claude-plugin/`

## Install From GitHub

After publishing this repository to GitHub:

```bash
claude plugin marketplace add <github-owner>/<repo-name>
claude plugin install project-engineer@project-engineer-marketplace
```

Notes:
- `<github-owner>/<repo-name>` is the GitHub repository location.
- `project-engineer-marketplace` is the marketplace name exposed to Claude Code users.
- `project-engineer` is the plugin name users install from that marketplace.

## Local Validate and Test

Validate both the marketplace and the plugin:

```bash
claude plugin validate .
claude plugin validate ./plugins/project-engineer
```

Install from the local checkout:

```bash
claude plugin marketplace add .
claude plugin install project-engineer@project-engineer-marketplace
```

Fast development loop without installing through the marketplace:

```bash
claude --plugin-dir ./plugins/project-engineer
```

After editing plugin files in a running session, use `/reload-plugins`.

## Publish Checklist

1. Review `.claude-plugin/marketplace.json` owner metadata.
2. Bump the plugin version in `plugins/project-engineer/.claude-plugin/plugin.json` when behavior changes.
3. Keep the marketplace entry version aligned with the plugin version when you want marketplace metadata to show the same release.
4. Run `claude plugin validate .` before every release.
5. Push the repository to GitHub, then test the public install commands once.

## Runtime Requirements

- Commands are Markdown-based and need no build step.
- Hooks require `bash`.
- `plugins/project-engineer/hooks/post-tool-use.sh` requires `python3` or `python`.
- On Windows, Git Bash plus Python 3 is the safest setup for hook execution.

## Notes

- `.omx/` is local orchestration state and is ignored for release hygiene.
- `.claude-tmp/` is runtime scratch data created by hooks and should not be committed.
- No license file is included yet. Choose one before a public open-source release if you want downstream users to have explicit reuse rights.
