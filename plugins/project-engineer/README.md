# pe Plugin v3.0

Adaptive project-engineering workflow for Claude Code. It stays light by default, then escalates to feature or project mode only when the work actually needs more structure.

## 中文说明

`pe` 是一个给 Claude Code 用的自适应工程化插件。它的目标不是一开始就强迫项目进入重流程，而是先用最小文档和最小约束跑起来，只有在复杂度真的升高时才逐步升级。

核心原则：

- 默认从 `light mode` 开始
- 需求或项目复杂度上升时，升级到 `feature mode` 或 `project mode`
- 把 `README.md` 和 `CLAUDE.md` 作为常驻入口
- 通过 hooks 做提醒，不直接替你改文档

## 安装

### 从 GitHub marketplace 安装

```bash
claude plugin marketplace add <github-owner>/<repo-name>
claude plugin install pe@project-engineer-marketplace
```

### 从当前 marketplace 本地仓库安装

```bash
claude plugin marketplace add .
claude plugin install pe@project-engineer-marketplace
```

### 本地开发调试

```bash
claude --plugin-dir ./plugins/project-engineer
```

修改插件文件后，在正在运行的 Claude Code 会话中执行 `/reload-plugins`。

## 运行前提

- 命令本身不需要构建
- hooks 依赖 `bash`
- `hooks/post-tool-use.sh` 需要 `python3` 或 `python`
- Windows 上建议使用 Git Bash + Python 3
- 如果 hook 依赖缺失，命令仍可使用，但自动提醒和变更检测会降级

## 模式说明

这个插件不会默认生成一整套重文档，而是根据工作复杂度分层：

### 轻量模式 `light`

常驻文档：

- `README.md`
- `CLAUDE.md`

按需生成：

- `ARC.md`
- `API.md`

### 功能模式 `feature`

在 light 的基础上新增：

- `.project-engineer/FEATURE-{slug}.md`

适合单个边界清晰、但会跨多个模块或接口的功能。

### 项目模式 `project`

在更复杂的情况下新增：

- `PRD.md`
- `.project-engineer/status.md`

适合多功能、多里程碑、跨多次会话推进的项目。

## 推荐入口

```bash
/pe:init 我想做一个多人协作的任务管理工具
/pe:init --mode light 做一个单页落地页
/pe:focus
/pe:req-update 新增邮件通知
```

含义：

- `/pe:init`：自动判断进入哪种模式
- `/pe:init --mode ...`：强制指定模式
- `/pe:focus`：判断当前最值得推进的事情
- `/pe:next`：兼容旧习惯，内部等价于 `/focus`

## `/init` 会生成什么

### `light mode`

- `README.md`
- `CLAUDE.md`
- 需要时生成 `ARC.md`
- 需要时生成 `API.md`

### `feature mode`

- 包含 light mode 的产物
- 增加 `.project-engineer/FEATURE-{slug}.md`

### `project mode`

- 包含 light mode 的产物
- 包含按需的架构 / API 文档
- 增加 `PRD.md`
- 增加 `.project-engineer/status.md`

自动判定的一般规则：

- `light`：小项目、小需求、先快速启动
- `feature`：单个中等复杂度功能，跨多个模块或页面
- `project`：多功能、多阶段、长期推进

也可以手动指定：

```bash
/pe:init --mode light <requirements>
/pe:init --mode feature <requirements>
/pe:init --mode project <requirements>
```

## 日常工作流

### 1. 先确定当前 focus

```bash
/pe:focus
```

- `project mode` 优先读取 `.project-engineer/status.md`
- `feature mode` 优先读取相关的 `.project-engineer/FEATURE-{slug}.md`
- `light mode` 主要根据 `README.md` 和 `CLAUDE.md` 判断下一步

### 2. 处理新需求

```bash
/pe:req-update 新增邮件通知
```

插件会先判断变更规模：

- `small`：直接更新 `README.md`、`ARC.md`、`API.md`
- `medium`：创建或更新 `FEATURE-{slug}.md`
- `large`：升级到 `PRD.md` 和 `.project-engineer/status.md`

### 3. 更新执行板

```bash
/pe:status-update 完成登录 API 和 token 校验
```

主要用于 `project mode`，或者仍保留 `STATUS.md` 的旧项目。

### 4. 更新架构或 API 文档

```bash
/pe:arc-update 新增鉴权中间件
/pe:api-gen routes/auth.ts
```

### 5. 提交

```bash
/pe:commit 初始化 adaptive workflow
```

## 兼容与提醒机制

- 规范的需求变更命令：`/pe:req-update`
- 主推进命令：`/pe:focus`
- 兼容别名：`/pe:next`
- 新执行板路径：`.project-engineer/status.md`
- 旧项目里的 `STATUS.md` / `PRD.md` 仍然兼容，不会强制迁移

自动提醒包括：

- 改了 `models/`、`schema`、`docker-compose` 等架构相关位置时，提醒执行 `/pe:arc-update`
- 改了 `routes/`、`api/`、`controllers/` 等 API 相关位置时，提醒执行 `/pe:api-gen`
- 会话结束时汇总本轮变更，提醒同步 README、执行板、ARC、API 文档

这些 hooks 只做检测和提醒，不会自动帮你改写文档。

## Install

### From a published GitHub marketplace

```bash
claude plugin marketplace add <github-owner>/<repo-name>
claude plugin install pe@project-engineer-marketplace
```

### From a local checkout of this marketplace

```bash
claude plugin marketplace add .
claude plugin install pe@project-engineer-marketplace
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
/pe:init 我想做一个多人协作的任务管理工具
/pe:init --mode light 做一个单页落地页
/pe:focus
/pe:req-update 新增邮件通知
```

- `/pe:init` auto-selects light, feature, or project mode.
- `/pe:init --mode ...` forces a specific mode.
- `/pe:focus` is the main "what should I do next?" command.
- `/pe:next` remains as a compatibility alias for `/focus`.

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
/pe:init --mode light <requirements>
/pe:init --mode feature <requirements>
/pe:init --mode project <requirements>
```

## Daily Workflow

### 1. Determine current focus

```bash
/pe:focus
```

- Project mode reads `.project-engineer/status.md` first.
- Feature mode reads the relevant `.project-engineer/FEATURE-{slug}.md` first.
- Light mode infers next steps from `README.md` and `CLAUDE.md`.

### 2. Handle new requirements

```bash
/pe:req-update 新增邮件通知
```

`/pe:req-update` classifies the change first:
- `small` updates `README.md`, `ARC.md`, or `API.md` directly
- `medium` creates or updates `FEATURE-{slug}.md`
- `large` upgrades the project to `PRD.md` plus `.project-engineer/status.md`

### 3. Update the execution board

```bash
/pe:status-update 完成登录 API 和 token 校验
```

Use this in project mode or for legacy repos that still use `STATUS.md`.

### 4. Update architecture or API docs

```bash
/pe:arc-update 新增鉴权中间件
/pe:api-gen routes/auth.ts
```

### 5. Commit

```bash
/pe:commit 初始化 adaptive workflow
```

## Migration Notes

- Standard requirement-change command: `/pe:req-update`
- Main progression command: `/pe:focus`
- Compatibility alias: `/pe:next`
- New execution board path: `.project-engineer/status.md`
- Legacy repos with `STATUS.md` or `PRD.md` remain supported without forced migration

## Detection and Reminders

| Trigger | Reminder |
| --- | --- |
| Changes under `models/`, `schema`, `docker-compose`, and similar architecture surfaces | Suggest running `/pe:arc-update` |
| Changes under `routes/`, `api/`, `controllers/`, and similar API surfaces | Suggest running `/pe:api-gen` |
| Session end hook | Summarize changes and remind you to sync README, execution board, ARC, and API docs |

Hooks only detect, summarize, and remind. They do not rewrite documentation automatically.

## Router Cheatsheet

| Command | Purpose |
| --- | --- |
| `/pe:init [--mode ...] <requirements>` | Adaptive initialization |
| `/pe:focus [hint]` | Determine the next highest-value task |
| `/pe:next [hint]` | Compatibility alias for `/focus` |
| `/pe:req-update <change>` | Adaptive requirement-change handling |
| `/pe:status-update [summary]` | Update the project-mode or legacy execution board |
| `/pe:arc-update [reason]` | Create or update `ARC.md` |
| `/pe:api-gen [path]` | Create or update `API.md` |
| `/pe:commit [hint]` | Generate and run a structured commit workflow |

## Design Philosophy

- Light by default
- Upgrade documentation only when complexity earns it
- Keep `README.md` and `CLAUDE.md` as permanent human and AI entry points
- Treat the execution board as a temporary delivery artifact, not always-on root clutter
- Preserve compatibility for older repos instead of forcing silent migrations
- Stay lightweight by using commands and hooks only, without extra MCP infrastructure
