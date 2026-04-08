---
description: "project-engineer 快捷入口 — 使用 /pe <subcommand> [arguments] 调用自适应轻量/复杂工作流"
argument-hint: "<init|focus|next|req-update|status-update|arc-update|api-gen|commit|help> [arguments...]"
disable-model-invocation: true
---

# /pe — project-engineer Router

`/pe` 是这个插件的统一快捷入口。

推荐用法：

```bash
/pe init 我想做一个多人协作的任务管理工具
/pe init --mode light 做一个单页落地页
/pe focus
/pe req-update 新增邮件通知
/pe arc-update 新增鉴权中间件
/pe api-gen routes/auth.ts
/pe commit 初始化 adaptive workflow
```

## Router 规则

1. 将 `$ARGUMENTS` 的**第一个 token** 视为子命令，其余内容视为该子命令的参数。
2. 支持的子命令：
   - `init`
   - `focus`
   - `next`（兼容 alias，实际引导到 `/focus`）
   - `req-update` / `req`
   - `status-update` / `status`
   - `arc-update` / `arc`
   - `api-gen` / `api`
   - `commit`
   - `help`
3. 如果没有提供子命令，或子命令为 `help`，输出帮助表并给出示例，不执行其他流程。
4. 如果子命令无效，先提示可用子命令，再停止。

## Dispatch 行为

在真正执行前，先读取对应命令文件，再按该文件中的完整流程执行；行为要与用户直接输入原命令保持一致。

| `/pe` 子命令 | 等价原命令 | 对应文件 |
|---|---|---|
| `init` | `/init ...` | `commands/init.md` |
| `focus` | `/focus ...` | `commands/focus.md` |
| `next` | `/next ...` | `commands/next.md` |
| `req-update` / `req` | `/req-update ...` | `commands/req-update.md` |
| `status-update` / `status` | `/status-update ...` | `commands/status-update.md` |
| `arc-update` / `arc` | `/arc-update ...` | `commands/arc-update.md` |
| `api-gen` / `api` | `/api-gen ...` | `commands/api-gen.md` |
| `commit` | `/commit ...` | `commands/commit.md` |

## 参数转发

- 将子命令后的剩余文本，原样当作目标命令的 `$ARGUMENTS`
- 例如：
  - `/pe init --mode light 做一个博客系统` → 等价于 `/init --mode light 做一个博客系统`
  - `/pe req-update 新增站内通知` → 等价于 `/req-update 新增站内通知`
  - `/pe api routes/auth.ts` → 等价于 `/api-gen routes/auth.ts`

## 帮助输出格式

如果用户执行 `/pe` 或 `/pe help`，输出：

```text
project-engineer commands

/pe init [--mode light|feature|project] <requirements>
/pe focus [hint]
/pe next [hint]                  # legacy alias -> /focus
/pe req-update <change>
/pe status-update [summary]      # project mode / legacy only
/pe arc-update [reason]
/pe api-gen [path]
/pe commit [hint]
```

并补一行说明：
- `req`, `status`, `arc`, `api` 是简写别名
- 默认是 **light mode**，只有复杂度升高时才升级到 `feature` 或 `project`
- 也仍可直接使用原始命令
