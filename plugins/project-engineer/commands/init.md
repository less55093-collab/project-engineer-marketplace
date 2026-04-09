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

## Step 1: 默认走渐进式深度访谈 | Guided Deep Interview by Default

基于 `$ARGUMENTS`，默认进入**渐进式深度需求澄清**，不是轻量确认，也不是一次性问卷。

这一步**直接继承 `/pe:deep-interview` 的核心访谈协议**，区别只在于：

- `/pe:init` 在澄清完成后继续做 mode 判定和完整初始化落盘
- `/pe:deep-interview` 在澄清完成后优先以 `PRD.md` 为主输出

核心原则：

- `init` 默认就是 deep mode，不要假设用户已经想清楚
- **默认一步步引导**，而不是第一轮把所有问题全部扔给用户
- 每一轮只问当前最有杠杆的问题，回答模糊就继续顺着那个线程追问
- 在 `Init readiness gates` 没满足之前，不要开始落文档

### 提问策略

默认采用 Socratic 式节奏：

- 第一轮：问 3-5 个最高杠杆问题
- 后续每轮：默认问 1 个最高杠杆追问，必要时最多 2-3 个
- 优先把一个线程问清，再切到下一个主题
- 只有当用户明确要求“把所有问题一次性给我”时，才允许批量列问题

目标不是“覆盖所有维度”，而是“把最容易做偏的部分先问透”。

默认优先级：

1. 给谁用
2. 解决什么问题
3. 理想结果是什么
4. 第一版必须有什么
5. 明确不做什么
6. 关键约束
7. 成功标准

如果用户的回答已经很完整，可以少问一轮；如果回答很散，就在同一主题上继续追问，不要急着开新题。

### 对小白友好原则（贯穿所有轮次）

**每个涉及技术选型的问题，都必须提供一个"你帮我选"的选项。**

示例写法：
- "技术栈你有偏好吗？比如 React / Vue / Next.js？**如果不确定，我根据你的需求帮你推荐。**"
- "数据库倾向用什么？**不了解也没关系，告诉我你要存什么数据，我来选。**"
- "部署在哪里？**不确定的话我根据项目特点帮你推荐。**"

原则：**问的是意图和效果，不是要求用户做技术决策。** 用户说"我不懂，你帮我选"时，根据已收集的需求信息给出推荐方案并解释理由。

---

### 第一轮问题池 | First-Round Question Pool

第一轮通常从下面的问题池里挑 **3-5 个**，优先选最能暴露边界和目标的问题：

- 这个东西**给谁用**？（自己、团队、客户、公众）
- 它核心要**解决什么问题**？请用一句话描述理想使用场景
- 用户现在**怎么解决**这个问题？为什么现有方式不够
- 第一版**必须有**什么？哪些可以后面再做？
- **明确不做**什么？
- 你最不能接受我做错的是什么？
- 它会以什么形式被使用？（Web / API / CLI / 移动端 / 桌面端 / 库）
- 有没有**参考产品**或截图？（"像 XX 但是..."往往最高效）
- 技术栈有**偏好或限制**吗？（比如必须用 React、必须纯前端、要部署在哪。**不确定的话我根据需求帮你选。**）
- 需要**对接哪些外部服务或数据源**？（数据库、第三方 API、OAuth 登录、支付、邮件、AI 服务…）
- 数据需要**持久化**吗？是单用户还是多用户？
- 有没有**权限/角色**区分？（**不了解技术方案没关系，告诉我谁能访问、谁不能访问就行。**）
- 是做**快速原型**还是接近**生产级别**？
- 有没有**时间、预算、免费 tier、团队规模**之类的约束？
- 如何判断这次真的做成了？

如果 `$ARGUMENTS` 已经非常详细，可以跳过已知问题，但默认仍然应补问最关键的缺口，而不是象征性问 1 句就开始生成。

### 后续追问原则 | Follow-up Pressure Rules

第二轮起，不要求覆盖更多维度，而是优先补最危险的缺口。默认沿用 `/pe:deep-interview` 的 pressure-pass 机制：至少有一次回头收紧、质疑或 tradeoff 化前面回答。

对模糊回答优先用这些方式继续追问：

- `给我一个具体例子`
- `什么情况下这个答案不成立`
- `如果只能先做一半，你砍掉什么`
- `这个需求真正不做的是什么`
- `你更不能接受哪种错误结果`
- `如果我完全照你现在说的做，最可能做偏在哪里`
- `这个决策应该由你拍板，还是我可以直接选`

---

### 提问节奏（如何分轮次）

**第一轮**：默认问 3-5 个高杠杆问题，帮助用户先把大方向说出来。

**第二轮起**：对回答里最危险的模糊点继续追问，尤其是：

- MVP 范围
- Non-goals / out-of-scope
- Must / Should / Nice to have
- 时间、预算、资源约束
- 数据、权限、依赖
- 成功标准
- AI 可自行决定的边界

优先级和 `/pe:deep-interview` 保持一致：

1. Intent / 为什么做
2. Outcome / 想达到什么结果
3. Scope / 第一版做到哪里
4. Non-goals / 明确不做什么
5. Constraints / 有哪些限制
6. Success criteria / 如何判断完成
7. Brownfield context / 现有仓库事实（如果是已有项目）

**收束轮（最后一轮）**：
- 把理解到的需求做一个**结构化总结**回读给用户（核心功能、技术方案、边界约束、明确不做的事）
- 如果用户之前选了"你帮我选"，在总结中给出**推荐方案及理由**
- 如果还有重大歧义，继续问，不要礼貌性结束

### 何时允许批量问题

只有以下情况才允许一次性给出较长问题列表：

- 用户明确说“把所有问题一次性给我”
- 用户更偏好自己整理后一次性回答
- 当前线程已经多轮往返，但收敛速度太慢，需要改成表单式收集

如果没有这些信号，默认仍然使用渐进式引导。

### 提问原则

- **默认深，不默认省** — 除非需求本身已经非常完整，否则不要走轻量提问
- **默认不要一上来问很多** — 深度不等于问卷，重点是引导用户逐步想清楚
- **没有问题数上限** — 问到 readiness gates 满足为止
- **每轮默认只问一个最高杠杆问题** — 除非第一轮或用户明确希望批量回答
- **主动追问限制条件** — 用户说"做一个 XX"时，最重要的追问不是"还要什么功能"，而是"什么不做"、"什么时候要"、"给谁用"
- **收集过程中注意积累复杂度信号**，为 Step 4 做准备
- **"先不考虑"和"你帮我选"都是有效答案** — 前者记录为 deferred，后者在总结阶段给出推荐
- **不要用术语轰炸用户** — 如果用户明显是非技术背景，后续轮次自动降低术语密度，用效果和场景来提问而非技术名词
- **追问要有理由** — 每个问题都应说明它影响什么
- **至少做一次 pressure pass** — 回头质疑或收紧一个早先回答，而不是只向前推进
- **不要在关键边界没清楚前生成文档**

---

## Step 2: Init Readiness Gates | 何时可以停止提问

只有同时满足以下条件，才可以停止访谈并进入落文档。这里与 `/pe:deep-interview` 使用同一套 readiness gate：

- 用户是谁已经明确
- 核心问题和理想结果已经明确
- `MVP` 范围已经明确
- `Non-goals / Out of scope` 已明确
- `Must / Should / Nice to have` 已大致明确
- 至少有一次 tradeoff / 风险 / 错误结果层面的追问
- 关键约束已经明确
- 成功标准可描述
- 工程侧可自行决定的边界已经明确
- 至少做过一次 pressure pass，而不是只线性向前提问

如果这些条件还没满足，就继续问，不要为了快而提前落盘。

---

## Step 3: 结构化回读、推荐并补足假设 | Converge, Recommend, and Fill Gaps

在开始写文档前，先做一次结构化回读：

- 用 6-12 行总结：目标用户、核心问题、交付形态、核心功能、Must / Should / Nice to have、out-of-scope、关键约束
- 如果用户把技术选择交给你，给出**推荐方案 + 简短理由**
- 如果还有少量不会阻塞初始化的空白，明确写成**假设**

只要用户反馈这里还有误解，就继续回到提问阶段。

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
