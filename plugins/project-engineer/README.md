# project-engineer Plugin v2.0

Adaptive project-engineering workflow for Claude Code. It stays light by default, then escalates to feature or project mode only when the work actually needs more structure.

## Install

### From a published GitHub marketplace

```bash
claude plugin marketplace add <github-owner>/<repo-name>
claude plugin install project-engineer@project-engineer-marketplace
```

### From a local checkout of this marketplace

```bash
claude plugin marketplace add .
claude plugin install project-engineer@project-engineer-marketplace
```

### Fast local development loop

```bash
claude --plugin-dir ./plugins/project-engineer
```

After editing plugin files in a running Claude Code session, use `/reload-plugins`.

## Runtime Requirements

- Commands work without a build step.
- Hooks require `bash`.
- `hooks/post-tool-use.sh` requires `python3` or `python`.
- On Windows, use Git Bash plus Python 3 for the smoothest hook behavior.
- If hook dependencies are missing, commands still work, but change detection and reminder behavior are reduced.

## Core Model

This plugin avoids generating heavyweight documents unless complexity justifies them.

### Light mode

Always-on artifacts:
- `README.md`
- `CLAUDE.md`

Conditional artifacts:
- `ARC.md`
- `API.md`

### Feature mode

Adds:
- `.project-engineer/FEATURE-{slug}.md`

### Project mode

Adds:
- `PRD.md`
- `.project-engineer/status.md`

## Preferred Entry Points

```bash
/pe init 我想做一个多人协作的任务管理工具
/pe init --mode light 做一个单页落地页
/pe focus
/pe req-update 新增邮件通知
```

- `/pe init` auto-selects light, feature, or project mode.
- `/pe init --mode ...` forces a specific mode.
- `/pe focus` is the main “what should I do next?” command.
- `/pe next` remains as a compatibility alias for `/focus`.

## What `/init` Generates

### Light mode

- `README.md`
- `CLAUDE.md`
- `ARC.md` when needed
- `API.md` when needed

### Feature mode

- Everything from light mode
- `.project-engineer/FEATURE-{slug}.md`

### Project mode

- Light mode artifacts
- Conditional architecture/API docs
- `PRD.md`
- `.project-engineer/status.md`

### Mode selection

Typical auto-selection behavior:
- `light`: small project, small task, get moving quickly
- `feature`: one bounded feature touching multiple modules or interfaces
- `project`: multi-feature, milestone-based, or multi-session work

You can override it explicitly:

```bash
/pe init --mode light <requirements>
/pe init --mode feature <requirements>
/pe init --mode project <requirements>
```

## Daily Workflow

### 1. Determine current focus

```bash
/pe focus
```

- Project mode reads `.project-engineer/status.md` first.
- Feature mode reads the relevant `.project-engineer/FEATURE-{slug}.md` first.
- Light mode infers next steps from `README.md` and `CLAUDE.md`.

### 2. Handle new requirements

```bash
/pe req-update 新增邮件通知
```

`/req-update` classifies the change first:
- `small` updates `README.md`, `ARC.md`, or `API.md` directly
- `medium` creates or updates `FEATURE-{slug}.md`
- `large` upgrades the project to `PRD.md` plus `.project-engineer/status.md`

### 3. Update the execution board

```bash
/pe status-update 完成登录 API 和 token 校验
```

Use this in project mode or for legacy repos that still use `STATUS.md`.

### 4. Update architecture or API docs

```bash
/pe arc-update 新增鉴权中间件
/pe api-gen routes/auth.ts
```

### 5. Commit

```bash
/pe commit 初始化 adaptive workflow
```

## Migration Notes

- Standard requirement-change command: `/req-update`
- Main progression command: `/focus`
- Compatibility alias: `/next`
- New execution board path: `.project-engineer/status.md`
- Legacy repos with `STATUS.md` or `PRD.md` remain supported without forced migration

## Detection and Reminders

| Trigger | Reminder |
| --- | --- |
| Changes under `models/`, `schema`, `docker-compose`, and similar architecture surfaces | Suggest running `/arc-update` |
| Changes under `routes/`, `api/`, `controllers/`, and similar API surfaces | Suggest running `/api-gen` |
| Session end hook | Summarize changes and remind you to sync README, execution board, ARC, and API docs |

Hooks only detect, summarize, and remind. They do not rewrite documentation automatically.

## Router Cheatsheet

| Command | Purpose |
| --- | --- |
| `/pe init [--mode ...] <requirements>` | Adaptive initialization |
| `/pe focus [hint]` | Determine the next highest-value task |
| `/pe next [hint]` | Compatibility alias for `/focus` |
| `/pe req-update <change>` | Adaptive requirement-change handling |
| `/pe status-update [summary]` | Update the project-mode or legacy execution board |
| `/pe arc-update [reason]` | Create or update `ARC.md` |
| `/pe api-gen [path]` | Create or update `API.md` |
| `/pe commit [hint]` | Generate and run a structured commit workflow |

## Design Philosophy

- Light by default
- Upgrade documentation only when complexity earns it
- Keep `README.md` and `CLAUDE.md` as permanent human and AI entry points
- Treat the execution board as a temporary delivery artifact, not always-on root clutter
- Preserve compatibility for older repos instead of forcing silent migrations
- Stay lightweight by using commands and hooks only, without extra MCP infrastructure
