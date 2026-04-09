# pe Plugin v3.0

Adaptive project-engineering workflow for Claude Code. Interviews deeply by default, then keeps generated artifacts adaptive.

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

## Update | 升级

If you already installed an older version from the GitHub marketplace, update it with:

```bash
claude plugin marketplace update project-engineer-marketplace
claude plugin update pe@project-engineer-marketplace --scope user
```

Restart Claude Code after updating so the new plugin version is loaded.

If you are not sure which plugin name or scope is installed, check first:

```bash
claude plugin list
```

If you still have an old plugin entry such as `project-engineer@project-engineer-marketplace`, migrate to the current plugin name `pe`:

```bash
claude plugin uninstall project-engineer --scope user
claude plugin marketplace update project-engineer-marketplace
claude plugin install pe@project-engineer-marketplace --scope user
```

## Commands | 命令

```bash
/pe:init 我想做一个多人协作的任务管理工具
/pe:deep-interview 我想做一个面向销售团队的 AI 外呼管理平台，但你先把我问透
/pe:focus
/pe:req-update 新增邮件通知
/pe:arc-update 新增鉴权中间件
/pe:api-gen routes/auth.ts
/pe:status-update 完成登录 API 和 token 校验
/pe:commit 初始化 adaptive workflow
```

| Command | Purpose |
| --- | --- |
| `/pe:init <requirements>` | Deep-default requirement interview, then auto-select mode and generate docs |
| `/pe:deep-interview <idea>` | Explicit PRD-first interview or re-interview for an existing project |
| `/pe:focus [hint]` | Determine the next highest-value task |
| `/pe:req-update <change>` | Adaptive requirement-change handling |
| `/pe:status-update [summary]` | Update execution board (project mode) |
| `/pe:arc-update [reason]` | Create or update `ARC.md` |
| `/pe:api-gen [path]` | Create or update `API.md` |
| `/pe:commit [hint]` | Structured git commit |

## Modes | 模式

`/pe:init` now runs a deep interview by default, then **automatically** selects the mode based on analyzed complexity. No manual mode selection needed.

`/pe:deep-interview` remains available when you want an explicit PRD-first or mid-project re-interview path without treating it as a fresh init.

| Mode | When | Artifacts |
| --- | --- | --- |
| **light** | Small project, ≤2 core features | `README.md`, `CLAUDE.md`, optional `ARC.md`/`API.md` |
| **feature** | One bounded feature across modules | + `.project-engineer/FEATURE-{slug}.md` |
| **project** | Multi-feature, milestones, long-term | + `PRD.md`, `.project-engineer/status.md` |

## Daily Workflow | 日常工作流

1. **Check focus** — `/pe:focus` tells you the next best action based on current mode
2. **Start a new idea** — `/pe:init` now asks the hard questions first, then lands the right artifact set
3. **New requirements** — `/pe:req-update` classifies change as small/medium/large and routes accordingly
4. **Update docs** — `/pe:arc-update` and `/pe:api-gen` when architecture or API changes
5. **Commit** — `/pe:commit` checks which docs need syncing, then generates a conventional commit

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

## Versioning

When releasing a new plugin version, do not edit manifest versions by hand in multiple places.

Use:

```bash
node scripts/bump-plugin-version.mjs 4.0.0
```

This keeps:

- `plugins/project-engineer/.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json` plugin entry version
- `.claude-plugin/marketplace.json` metadata version

in sync before validation and push.

## Design Philosophy

- Deep questioning by default, adaptive artifacts after clarity
- `README.md` and `CLAUDE.md` as permanent entry points
- Execution board is a temporary delivery artifact, not always-on clutter
- Hooks remind, never auto-rewrite
