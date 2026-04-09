---
description: "深度初始化 — 默认高强度需求访谈，需求清晰后再按复杂度生成或更新项目文档"
---

# /init — 自适应项目初始化 | Adaptive Project Initialization

## 用法 | Usage

```bash
/pe:init <requirements>
```

用户原始需求 | User's raw requirements: `$ARGUMENTS`

---

## 目标 | Goal

把模糊需求变成一个可执行的项目起点。这个命令应同时做到：

- 默认进行**深度需求访谈**
- 自动选择 `light` / `feature` / `project`
- 只生成当前复杂度真正需要的文档
- 在已有仓库里**幂等执行**，优先更新已有文档而不是整份覆盖

用户不需要手动选择模式，也不需要理解模式机制。

### Light mode（低复杂度）
常驻：
- `README.md`
- `CLAUDE.md`

条件生成：
- `ARC.md`（当存在明确技术/部署/数据/鉴权决策时）
- `API.md`（当存在 HTTP API / 稳定接口契约时）

### Feature mode（中等复杂度）
在 Light mode 基础上新增：
- `.project-engineer/FEATURE-{slug}.md`

适用：单个中等功能、跨多个模块/页面/接口，但还不需要完整 PRD / 多 milestone 管理。

### Project mode（高复杂度）
在 Feature/Light 能力基础上新增：
- `PRD.md`
- `.project-engineer/status.md`

适用：多功能、多里程碑、明显跨多次会话、需要长期执行看板或多人协作。

---

## Step 0: 先看当前仓库 | Inspect Current Repo First

在提问或写文档前，先检查这些路径是否已存在：

- `README.md`
- `CLAUDE.md`
- `ARC.md`
- `API.md`
- `PRD.md`
- `.project-engineer/FEATURE-*.md`
- `.project-engineer/status.md`
- `STATUS.md`（legacy）

处理规则：

- 已存在的文档，默认**更新**而不是重写
- 保留用户手写内容、项目命令、真实路径、真实环境变量
- 如果仓库已经初始化过，把 `/pe:init` 当作 **bootstrap-or-refresh**，不是 reset
- 不要静默删除 `PRD.md`、`.project-engineer/status.md` 或 legacy `STATUS.md`

---

## Step 1: 深度访谈循环 | Deep Interview Loop

基于 `$ARGUMENTS`，默认进入与 `/pe:deep-interview` **完全相同**的需求访谈协议。这里不是轻量确认，也不是大问卷，而是标准的逐轮深挖。

### 轮次规则

- 默认按 `deep` 强度处理
- 每轮只问 **1 个最关键的问题**
- 只要 readiness gates 没满足，就继续问
- 只有用户明确要求停止，才允许带风险警告提前收束
- 如果用户明确要求“把所有问题一次性给我”，才允许暂时改成批量问题模式

每轮输出格式建议：

```text
Round {n}
Focus: {当前澄清维度}
Init readiness: {low|medium|high}

{本轮问题}
```

### 提问优先级

按以下顺序推进，但不要僵硬死板：

1. 为什么要做这个
2. 给谁用
3. 他们现在怎么解决这个问题
4. 你真正想要的结果是什么
5. 第一版必须做到什么
6. 明确不做什么
7. 哪些边界绝对不能越过
8. 有哪些技术 / 时间 / 成本 / 组织约束
9. 数据、权限、流程、外部依赖是什么
10. 如何判断这次做成了
11. 什么风险最值得提前暴露

### 重点必问维度

以下内容在生成文档之前必须明确：

- 目标用户
- 核心问题 / 痛点
- 理想使用场景
- MVP 范围
- Out of scope / Non-goals
- Must / Should / Nice to have 的优先级
- 成功标准
- 时间与资源约束
- 数据与权限边界
- 关键依赖 / 外部集成
- 风险与边界情况
- 决策边界：哪些实现细节可以由 AI / 工程侧自行决定

### 对小白友好原则（贯穿所有轮次）

**每个涉及技术选型的问题，都必须提供一个"你帮我选"的选项。**

示例写法：
- "技术栈你有偏好吗？比如 React / Vue / Next.js？**如果不确定，我根据你的需求帮你推荐。**"
- "数据库倾向用什么？**不了解也没关系，告诉我你要存什么数据，我来选。**"
- "部署在哪里？**不确定的话我根据项目特点帮你推荐。**"

原则：**问的是意图和效果，不是要求用户做技术决策。** 用户说"我不懂，你帮我选"时，根据已收集的需求信息给出推荐方案并解释理由。

### 追问方式

对每个重要回答，优先用以下方式继续追问：

- `给我一个具体例子`
- `什么情况下这个答案不成立`
- `如果只能先做一半，你砍掉什么`
- `这个需求的真正非目标是什么`
- `你更不能接受哪种错误结果`
- `如果我完全照你现在说的做，最可能做偏在哪里`

### 提问原则

- **默认深，不默认省**
- **每轮默认只问一个最高杠杆问题**
- **不要用术语轰炸用户**
- **追问要有理由**
- **至少做一次 pressure pass** — 回头质疑或收紧一个早先回答，而不是只线性向前推进
- **不要在关键边界没清楚前生成文档**

---

## Step 2: Init Readiness Gates | 何时可以停止提问

只有同时满足以下条件，才可以停止访谈并进入落文档。这一套 gate 与 `/pe:deep-interview` 完全一致：

- 用户是谁已经明确
- 问题和目标结果已经明确
- `MVP` 范围已经明确
- `Non-goals / Out of scope` 已明确
- `Must / Should / Nice to have` 已明确
- 至少一次对前面回答做过压力测试或 tradeoff 追问
- 关键约束已经明确
- 成功标准可测试或可明确描述
- 没有会直接改变 PRD / README / CLAUDE / ARC 结构的重大歧义
- 工程侧可自行决定的边界已经明确

如果这些条件还没满足，就继续问，不要为了快而提前落盘。

---

## Step 3: 结构化回读、推荐并补足假设 | Structured Readback Before Generation

在真正开始写文档前，先向用户回读一次结构化总结：

- 目标用户
- 核心问题
- 目标结果
- MVP 范围
- 明确不做
- 关键约束
- 成功标准
- 主要风险
- Must / Should / Nice to have

如果用户前面说过"你帮我选"，在这里给出推荐方案及理由。

如果还有少量不会阻塞初始化的空白，明确写进 `Assumptions / 假设`。

只要用户反馈这里还有重大误解，就继续回到访谈循环。

---

## Step 4: 分析复杂度，自动选择模式 | Analyze Complexity & Select Mode

在收集完用户回答后，根据以下 rubric 自动判定模式。不要让用户选择模式。

### 判定为 Light mode 的典型信号
- 核心功能 ≤ 2
- 没有明确 milestone / roadmap
- 没有长期执行看板需求
- 没有复杂外部集成
- 用户主要关心"先跑起来"

### 判定为 Feature mode 的典型信号
- 这是一个**边界清晰的功能块**
- 需要跨前后端/多个模块协同
- 可能跨多次会话，但不值得写完整 PRD
- 需要 acceptance / scope / out-of-scope 说明

### 判定为 Project mode 的典型信号
- 核心功能 ≥ 3
- 明确存在 MVP / roadmap / milestones
- 预计会跨多个会话推进
- 有外部集成、复杂架构或多人协作
- 用户明确要求"先规划""不要遗漏""分阶段做"

如果经过深度访谈后已经出现明显的产品范围、MVP、里程碑、外部依赖或多人协作信号，在 `feature` 和 `project` 之间优先偏向 `project`。

不要因为"文档轻一点更省事"就把本该进入 `project mode` 的需求压回 `light`。

---

## Step 5: 写入策略（幂等） | Writing Strategy and Idempotency

写文档时必须遵守：

- `README.md` 和 `CLAUDE.md` 为 always-on，所有模式都要有
- `ARC.md`、`API.md`、feature brief、`PRD.md`、status board 只按条件创建
- **create when missing, update when existing**
- 优先小范围更新，不要整份覆盖已有内容
- 不要保留原始模板占位符，如 `{PROJECT_NAME}`、`{ENV_KEY}`；未知值请改成 `待补充 / TBD`
- 输出语言跟随用户当前语言；若模板已是中英双语结构，可保留双语标题
- 如果仓库中已有真实命令、真实路径、真实环境变量，以仓库事实为准，不要臆造

---

## Step 6: 生成 always-on 文档 | Generate Always-on Docs

### 6.1 `README.md`
使用 `templates/README_TEMPLATE.md`。

要求：
- 面向人类开发者 / 试用者
- 能回答"这是什么、怎么跑、看哪里"
- 不复制 PRD / ARC 全文
- 如果仓库已有启动命令、环境变量、目录结构，优先保留并补充
- 未知项写 `待补充 / TBD`，不要留空占位符

### 6.2 `CLAUDE.md`
使用 `templates/CLAUDE_TEMPLATE.md`。

要求：
- 面向 AI 工作流
- 明确哪些文档是 always-on，哪些是 conditional / temporary
- 明确何时升级到 Feature / Project mode
- 明确何时更新 README / ARC / API / feature brief / status board
- 明确当前模式和当前存在的活跃文档

---

## Step 7: 条件生成 `ARC.md` / `API.md` | Conditional Docs

### 7.1 生成 `ARC.md` 的条件
满足任一即可：
- 有明确技术栈选择理由
- 有部署 / 数据模型 / 鉴权 / 并发策略
- 用户希望记录架构决策
- 预计多人协作，需要留存技术边界

### 7.2 生成 `API.md` 的条件
满足任一即可：
- 存在 HTTP API / REST / webhook / RPC 接口
- 前后端分离，需要接口契约
- 用户明确希望记录 API

如果条件不满足，则不要强行生成这些文档，并在汇报里说明"本次先跳过，后续需要时再补"。

---

## Step 8: 生成 Feature / Project Artifact

### 8.1 Feature mode
若 `.project-engineer/` 目录不存在，先创建它。

生成：
- `.project-engineer/FEATURE-{slug}.md`

使用 `templates/FEATURE_TEMPLATE.md`。

该文档应包含：
- 功能目标
- in scope / out of scope
- acceptance criteria
- 受影响模块
- 何时升级为 project mode
- `{slug}` 使用 2-5 个词的 kebab-case，例如 `email-notifications`

### 8.2 Project mode
若 `.project-engineer/` 目录不存在，先创建它。

生成：
- `PRD.md`
- `.project-engineer/status.md`

使用：
- `templates/PRD_TEMPLATE.md`
- `templates/STATUS_TEMPLATE.md`

Project mode 只在复杂项目时启用，避免把小需求拖进重流程。

---

## Step 9: 完成汇报 | Completion Message

输出应明确包含：

```text
✅ 初始化完成
Mode: [light|feature|project]（自动判定理由：...）

Created:
- ...

Updated:
- ...

Skipped:
- ...（例如：本次未生成 `API.md`，因为还没有稳定 HTTP 接口）

Assumptions:
- ...（如果有）

Next step:
- 使用 /pe:focus 开始当前工作
```

---

## 生成原则 | Principles

- 先问后决定，不要提前假设模式
- `init` 默认就是 deep，不要再把它当成轻量命令
- 复杂度判定由 AI 完成，用户不需要理解模式区别
- 边界不清时先继续问，不要提前降级为轻模式
- 所有模式都必须生成 `README.md` + `CLAUDE.md`
- 只有真正复杂项目才生成 `PRD.md` + `.project-engineer/status.md`
- 已有仓库优先更新，不要把 `/init` 当成破坏性重置
- 不要留下模板占位符
- 需求足够清晰后直接生成，不要再额外征求一次"要不要继续"
