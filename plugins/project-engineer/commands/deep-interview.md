---
description: "深度需求访谈 — 单轮单问，持续追问直到需求边界清晰，最后生成或更新 PRD.md"
---

# /deep-interview — 深度需求访谈并产出 PRD | Exhaustive Requirement Interview to PRD

## 用法 | Usage

```bash
/pe:deep-interview <idea>
/pe:deep-interview --standard <idea>
/pe:deep-interview --deep <idea>
```

`$ARGUMENTS` — 用户当前的产品想法、模糊需求、方向描述，或已经写了一半但边界不清的项目说明

默认按 `--deep` 处理。只有当用户明确说想快一点时，才降到 `--standard`。

---

## 这条命令是干什么的 | What This Command Is For

这是 `pe` 里的**显式重型需求澄清命令**。

它和 `/pe:init` 的分工如下：

- `/pe:init`：默认就会做深度需求访谈，然后再生成项目入口文档
- `/pe:deep-interview`：当你只想显式进入 `PRD-first` 的长访谈，或在项目中途重新把需求问透时使用

适用场景：

- 用户明确表示"不要假设""把我问透""你多问一点"
- 用户只有一个模糊想法，但希望先把需求彻底理顺
- 项目明显偏 `project mode`，而且 PRD 比代码更应该先产出
- 之前的讨论已经开始混乱，需要重新拉直需求边界

不适用场景：

- 只是一个小功能或小修正
- 已经有清晰 PRD 或 feature brief，只差执行
- 用户明确要求直接开工，不想做长访谈

---

## 执行风格 | Interview Style

这条命令是**单轮单问**模式：

- 每轮只问 **1 个问题**
- 问题必须是当前最有信息增益的问题，不要为了覆盖面而机械轮询
- 优先追问意图、边界、非目标、取舍，再问实现细节
- 对模糊回答要继续施压：要例子、要反例、要 tradeoff、要明确"不做什么"
- 至少回头压力测试一次前面的回答，而不是只往前走

默认不要怕问得多。这个命令的目标不是"聊完"，而是"聊清楚"。

---

## Step 0: 读取当前上下文 | Inspect Existing Context

在开始提问前，先检查：

- `README.md`
- `CLAUDE.md`
- `ARC.md`
- `API.md`
- `PRD.md`
- `.project-engineer/FEATURE-*.md`
- `.project-engineer/status.md`
- `STATUS.md`（legacy）

如果是已有项目：

- 先读现有文档，再提问
- 优先问"我发现现在是 X，你是想延续还是推翻？"
- 如果已有 `PRD.md`，本命令行为应是**深度澄清 + 更新 PRD**，不是静默覆盖

---

## Step 1: 深度访谈循环 | Deep Interview Loop

### 轮次规则

- `--standard`：通常 6-10 轮
- `--deep`：通常 10-20 轮
- 只要 PRD readiness gates 没满足，就继续问
- 只有用户明确要求停止，才允许带风险警告提前收束

每轮输出格式建议：

```text
Round {n}
Focus: {当前澄清维度}
PRD readiness: {low|medium|high}

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

以下内容在生成 PRD 之前必须明确：

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

### 追问方式

对每个重要回答，优先用以下方式继续追问：

- `给我一个具体例子`
- `什么情况下这个答案不成立`
- `如果只能先做一半，你砍掉什么`
- `这个需求的真正非目标是什么`
- `你更不能接受哪种错误结果`
- `如果我完全照你现在说的做，最可能做偏在哪里`

---

## Step 2: PRD Readiness Gates | 何时可以停止提问

只有同时满足以下条件，才可以停止访谈并生成 `PRD.md`：

- 用户是谁已经明确
- 问题和目标结果已经明确
- `MVP` 范围已经明确
- `Non-goals / Out of scope` 已明确
- `Must / Should / Nice to have` 已明确
- 至少一次对前面回答做过压力测试或 tradeoff 追问
- 关键约束已经明确
- 成功标准可测试
- 没有会直接改变 PRD 结构的重大歧义

如果仍然存在重大空白，就继续问，不要为了赶快产出而硬写 PRD。

---

## Step 3: 结构化回读 | Structured Readback

在真正写 `PRD.md` 之前，先向用户回读一次结构化总结：

- 目标用户
- 核心问题
- 目标结果
- MVP 范围
- 明确不做
- 关键约束
- 成功标准
- 主要风险

如果用户前面说过"你帮我选"，在这里给出推荐方案及理由。

只要还有重大误解迹象，继续回到访谈循环。

---

## Step 4: 生成或更新 `PRD.md` | Generate or Update PRD

使用 `templates/PRD_TEMPLATE.md` 生成或更新 `PRD.md`。

要求：

- 默认**生成或更新 `PRD.md`**
- 如果 `PRD.md` 已存在，优先小范围更新，不要整份覆盖
- 不要保留模板占位符，如 `{功能1}`、`{DATE}`
- 未完全确定但又不阻塞成文的内容，写进 `Assumptions / 待验证假设`
- 把 interview 得出的 `Non-goals`、边界、成功标准和风险显式写进去
- 功能优先级必须落到 `Must / Should / Nice to have`
- 用户故事和验收标准必须足够具体，避免空话

必要时允许比模板多写小节，不要被模板限制住。

---

## Step 5: 完成汇报 | Completion Message

输出应明确包含：

```text
✅ 深度需求访谈完成
Interview depth: [standard|deep]
PRD readiness: ready

Updated artifacts:
- PRD.md
- [其他按需更新的文档]

Key clarifications:
- ...
- ...
- ...

Next step:
- 使用 /pe:focus 继续拆解当前工作
```

如果用户提前停止而信息仍不完整，改为：

```text
⚠️ 深度需求访谈已停止，但 PRD 仍有残余歧义
Residual risks:
- ...
- ...
```

---

## 原则 | Principles

- 这是 PRD-first 命令，不是快速启动命令
- 默认多问，不默认省略
- 一次只问一个最关键的问题
- 不要用一长串清单把用户砸晕
- 不要在关键边界没问清时提前写 PRD
- 不要把技术决策全甩给非技术用户
- 该命令的完成标准不是"问够轮数"，而是"需求已经足够清晰到可以写出靠谱 PRD"
