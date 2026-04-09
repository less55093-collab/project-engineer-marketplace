# pe Plugin v3.0

Adaptive project-engineering workflow for Claude Code. Stays light by default, escalates to feature or project mode only when complexity earns it.

给 Claude Code 用的自适应工程化插件。可以帮助用户理清需求，为复杂项目建立工程化架构，通过arc.md来写明架构，让没有上下文的ai也能快速读懂代码库迅速开始干活。


## Install | 安装

### From GitHub marketplace

```bash
claude plugin marketplace add <github-owner>/<repo-name>
claude plugin install pe@project-engineer-marketplace
```

### From local checkout

```bash
claude plugin marketplace add .
claude plugin install pe@project-engineer-marketplace
```

### Local dev

```bash
claude --plugin-dir ./plugins/project-engineer
```

After editing, run `/reload-plugins` in the session.

## Commands | 命令

```bash
/pe:init 我想做一个多人协作的任务管理工具
/pe:focus
/pe:req-update 新增邮件通知
/pe:arc-update 新增鉴权中间件
/pe:api-gen routes/auth.ts
/pe:status-update 完成登录 API 和 token 校验
/pe:commit 初始化 adaptive workflow
```

| Command | Purpose |
| --- | --- |
| `/pe:init <requirements>` | Gather requirements via questions, auto-select mode, generate docs |
| `/pe:focus [hint]` | Determine the next highest-value task |
| `/pe:req-update <change>` | Adaptive requirement-change handling |
| `/pe:status-update [summary]` | Update execution board (project mode) |
| `/pe:arc-update [reason]` | Create or update `ARC.md` |
| `/pe:api-gen [path]` | Create or update `API.md` |
| `/pe:commit [hint]` | Structured git commit |

## Modes | 模式

`/pe:init` collects requirements through questions, then **automatically** selects the mode based on analyzed complexity. No manual mode selection needed.

| Mode | When | Artifacts |
| --- | --- | --- |
| **light** | Small project, ≤2 core features | `README.md`, `CLAUDE.md`, optional `ARC.md`/`API.md` |
| **feature** | One bounded feature across modules | + `.project-engineer/FEATURE-{slug}.md` |
| **project** | Multi-feature, milestones, long-term | + `PRD.md`, `.project-engineer/status.md` |

## Daily Workflow | 日常工作流

1. **Check focus** — `/pe:focus` tells you the next best action based on current mode
2. **New requirements** — `/pe:req-update` classifies change as small/medium/large and routes accordingly
3. **Update docs** — `/pe:arc-update` and `/pe:api-gen` when architecture or API changes
4. **Commit** — `/pe:commit` checks which docs need syncing, then generates a conventional commit

## Hooks | 自动行为

Hooks stay silent during coding. Reminders only surface at two natural checkpoints:

| Hook | When | What |
| --- | --- | --- |
| **PostToolUse** | Every Write/Edit | Silently logs changed file paths to `.claude-tmp/session-changes.log` |
| **Stop** | Session end | If uncommitted changes exist, one-line reminder to run `/pe:commit` |

The doc-sync check (ARC, API, README, status board) happens inside `/pe:commit`, not during coding.

## Runtime Requirements

- Commands are Markdown-based, no build step
- Hooks require `bash` and `python3` (or `python`)
- Windows: Git Bash + Python 3

## Design Philosophy

- Light by default, upgrade only when complexity earns it
- `README.md` and `CLAUDE.md` as permanent entry points
- Execution board is a temporary delivery artifact, not always-on clutter
- Hooks remind, never auto-rewrite
