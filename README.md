# pe — Adaptive Project Engineering for Claude Code

把vibe coding变成真正可以正向维护的项目，让 AI 像有经验的工程师一样理解你的项目。

## 它解决什么问题

每次开一个新的 Claude Code 会话，AI 都是零上下文的。它不知道你的技术栈选择、架构决策、当前进度。你不得不反复解释"我们用的是 Next.js + Supabase""鉴权用的 JWT""这个功能做到一半了"。

**pe 插件通过一套自适应文档体系解决这个问题。**

`/pe:init` 先通过提问理清你的需求，再根据复杂度自动生成对应层级的工程文档：

- **CLAUDE.md** — AI 的工作说明书。每个新会话启动时读这一个文件，就能知道项目模式、文档结构、工作规则
- **ARC.md** — 架构决策记录。技术栈、部署方案、数据模型、鉴权策略，写清楚一次，后续所有 AI 会话都能读懂
- **API.md** — 接口契约。前后端分离项目的 HTTP 接口文档，从代码自动扫描生成

结果是：**任何一个没有上下文的 AI 会话，读完 CLAUDE.md 和 ARC.md 就能直接干活。**

## 为什么不用 Cursor Rules / 手写 CLAUDE.md

你当然可以手写。但手写的问题是：

1. **没有层级感** — 小项目和大项目用同一套文档，要么不够用，要么太重
2. **容易过时** — 代码改了，文档没人更新，AI 读到的是过时信息
3. **没有标准** — 每个项目的 CLAUDE.md 格式不同，AI 每次都要重新理解

pe 的做法：

| 问题 | pe 的解决方式 |
| --- | --- |
| 小项目被迫写重文档 | 三档自适应：light 只需 README + CLAUDE.md，复杂了再升级 |
| 文档过时 | 提交时自动检查哪些文档需要同步，列出清单 |
| 格式不统一 | 模板驱动，所有项目遵循同一结构，AI 读一次就懂 |

## 核心优势

**自适应，不强制** — 默认 light mode，只有 README + CLAUDE.md。不会给一个 todo app 生成 PRD 和执行看板。复杂度真的升高时，`/pe:req-update` 会自动建议升级到 feature 或 project mode。

**提交时检查，不是写代码时打断** — hooks 在你写代码时完全静默。只有执行 `/pe:commit` 时，才一次性分析"这轮改了哪些文件，哪些文档可能需要同步"，避免编码中途被不断弹出的提醒打断心流。

**AI 原生** — CLAUDE.md 不是给人看的备忘录，而是专门为 AI 设计的工作指令。它告诉 AI：先读什么、当前模式是什么、什么时候该升级文档。每次新会话都能从这个入口快速获得完整上下文。

**纯 Markdown，零构建** — 没有 MCP server，没有编译步骤。命令是 Markdown 文件，hooks 是 shell 脚本。装上就能用。

## Install | 安装

```bash
claude plugin marketplace add less55093-collab/project-engineer-marketplace
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
