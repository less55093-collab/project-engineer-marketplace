# CLAUDE.md — AI 工作说明书 | AI Working Instructions

> 📌 **始终先读以下 always-on 文档：**
> **Always start with the always-on docs:**
>
> | 文档 | 内容 | 路径 |
> |------|------|------|
> | `README.md` | 给人看的项目入口、启动方式、常用命令 | ./README.md |
> | `CLAUDE.md` | AI 工作流程、升级规则、文档维护策略 | ./CLAUDE.md |
>
> 📌 **按存在性再读取以下 conditional / temporary 文档：**
>
> | 文档 | 何时读取 |
> |------|----------|
> | `ARC.md` | 需要确认技术栈、架构边界、部署/鉴权/数据决策时 |
> | `API.md` | 需要确认 HTTP / 接口契约时 |
> | `.project-engineer/FEATURE-*.md` | 当前工作处于 feature mode 时 |
> | `PRD.md` | 当前工作处于 project mode 时 |
> | `.project-engineer/status.md` | 当前 project mode 有执行看板时 |
> | `STATUS.md` | 仅 legacy compatibility |
>
> ⚠️ **不要默认假设 PRD.md / STATUS.md 一定存在。**
> ⚠️ **人类使用说明看 README.md，AI 流程说明看 CLAUDE.md。**

---

## 模式 | Modes

### Light mode（默认）
常驻文档：`README.md` + `CLAUDE.md`

可选文档：
- `ARC.md`
- `API.md`

### Feature mode
在 light mode 基础上增加：
- `.project-engineer/FEATURE-{slug}.md`

### Project mode
在 feature/light 基础上增加：
- `PRD.md`
- `.project-engineer/status.md`

---

## 会话开始 | Session Start

每次新会话，按顺序执行：

1. 阅读 `README.md`
2. 阅读 `CLAUDE.md`
3. 如果存在，再读：`ARC.md`
4. 如果存在，再读：`API.md`
5. 如果存在，再读：相关 `.project-engineer/FEATURE-*.md`
6. 如果存在，再读：`PRD.md`
7. 如果存在，再读：`.project-engineer/status.md` 或 legacy `STATUS.md`

读完后，主动汇报：

```text
🧭 Current mode: [light|feature|project|legacy]
🎯 Current focus: ...
📚 Active docs: ...
⏸️ Blockers: [有/无]

继续当前 focus，还是切换优先级？
```

---

## 会话结束 | Session End

执行 `/pe:commit`。commit 流程会自动检查哪些文档需要同步（README、ARC、API、执行看板），在提交前给出提醒。

---

## 命令速查 | Commands

| 命令 | 触发时机 |
|------|----------|
| `/pe:focus` | 确定当前最值得做的事情（主命令） |
| `/pe:init [想法]` | 新项目默认入口；现在会先深度提问，再决定生成哪些文档 |
| `/pe:deep-interview [想法]` | 想显式进入 `PRD-first` 长访谈，或中途重新问透需求时 |
| `/pe:req-update [描述]` | 用户提出新需求或需求变更时 |
| `/pe:status-update` | 仅 project mode / legacy 项目使用 |
| `/pe:arc-update [原因]` | 需要更新或生成 `ARC.md` 时 |
| `/pe:api-gen [路径]` | 需要更新或生成 `API.md` 时 |
| `/pe:commit [提示]` | 检查文档同步 + 提交代码 |

---

## 升级 / 回落规则 | Promotion / Demotion

- **light → feature**：当变更跨多个模块/页面/API，并需要明确 acceptance / out-of-scope
- **feature → project**：当工作拆成多个 milestone，或需要持续执行看板
- **project → light**：当 `.project-engineer/status.md` 完成并归档后，回到 always-on 文档为主

---

## 工作原则 | Principles

**默认深挖需求** — `/pe:init` 现在会先渐进式深度提问，再决定文档范围  
**显式长访谈** — `/pe:deep-interview` 使用与 `/pe:init` 相同的访谈协议，但更偏 PRD-first / 中途重新梳理需求  
**按复杂度升级** — 只有工作真的变复杂时，才进入 feature / project mode  
**文档分工明确** — README 给人看，CLAUDE 给 AI 看，ARC/API/feature/PRD/status 按需启用  
**遇到新需求** — 先执行 `/pe:req-update`，再决定是否升级模式  
**遇到对外行为变化** — 同步更新 `README.md`  
**遇到架构冲突** — 更新 `ARC.md` 或提出需要新建 `ARC.md`  
**遇到阻塞** — 若有 project board，记录到 `.project-engineer/status.md` 或 legacy `STATUS.md`  
**优先 /pe:focus** — 主推进命令
