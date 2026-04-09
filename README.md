# project-engineer-marketplace

Claude Code marketplace for the **pe** plugin — an adaptive project-engineering workflow that stays lightweight by default and adds structure only when complexity earns it.

给 Claude Code 用的自适应工程化插件。默认轻量，复杂度升高时才逐步升级到 `feature` 或 `project` 模式。

## Install | 安装

```bash
claude plugin marketplace add <github-owner>/<repo-name>
claude plugin install pe@project-engineer-marketplace
```

Or from a local checkout | 或从本地仓库安装：

```bash
claude plugin marketplace add .
claude plugin install pe@project-engineer-marketplace
```

## Usage | 用法

All commands use the `/pe:<command>` prefix:

```bash
/pe:init 我想做一个多人协作的任务管理工具
/pe:focus
/pe:req-update 新增邮件通知
/pe:arc-update 新增鉴权中间件
/pe:api-gen routes/auth.ts
/pe:status-update 完成登录 API
/pe:commit 初始化 adaptive workflow
```

| Command | Purpose |
| --- | --- |
| `/pe:init <requirements>` | Gather requirements, auto-select mode, generate docs / 提问收集需求后自动初始化 |
| `/pe:focus [hint]` | Next highest-value task / 下一步做什么 |
| `/pe:req-update <change>` | Handle new requirements / 处理需求变更 |
| `/pe:status-update [summary]` | Update execution board / 更新执行看板 |
| `/pe:arc-update [reason]` | Create or update `ARC.md` / 更新架构文档 |
| `/pe:api-gen [path]` | Create or update `API.md` / 更新接口文档 |
| `/pe:commit [hint]` | Structured commit / 规范化提交 |

## Modes | 模式

| Mode | Always-on | Conditional |
| --- | --- | --- |
| **light** (default) | `README.md`, `CLAUDE.md` | `ARC.md`, `API.md` |
| **feature** | + `.project-engineer/FEATURE-{slug}.md` | |
| **project** | + `PRD.md`, `.project-engineer/status.md` | |

`/pe:init` gathers requirements through questions first, then auto-selects the mode based on analyzed complexity.

## Runtime Requirements | 运行前提

- Commands are Markdown-based, no build step needed
- Hooks require `bash` and `python3` (or `python`)
- Windows: use Git Bash + Python 3

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

## Development | 开发

### Local dev loop | 本地开发

```bash
claude --plugin-dir ./plugins/project-engineer
```

Edit files, then run `/reload-plugins` in the session.

### Validate | 验证

```bash
claude plugin validate .
claude plugin validate ./plugins/project-engineer
```

### Publish checklist | 发布检查

1. Review owner info in `.claude-plugin/marketplace.json`
2. Bump version in `plugins/project-engineer/.claude-plugin/plugin.json`
3. Run `claude plugin validate .`
4. Push to GitHub, test the public install commands

## Notes

- `.claude-tmp/` is hook runtime scratch data, do not commit
- No `LICENSE` file yet — add one before public release
