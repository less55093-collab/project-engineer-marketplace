---
description: "自适应初始化 — 先向用户提问收集需求，再根据复杂度自动决定生成哪些文档"
---

# /init — 自适应项目初始化 | Adaptive Project Initialization

## 用法 | Usage

```bash
/pe:init <requirements>
```

用户原始需求 | User's raw requirements: `$ARGUMENTS`

---

## 目标 | Goal

通过提问收集完整需求，然后根据分析出的复杂度自动选择模式和生成对应文档。用户不需要手动指定模式。

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

## Step 1: 提问收集需求 | Gather Requirements

基于 `$ARGUMENTS` 的内容，向用户提出必要的问题。问题数量视需求清晰度而定，最多不超过 5 个。

需要了解的核心信息：

- 项目一句话描述
- 目标用户 / 主要使用场景
- 核心功能列表
- 运行环境 / 技术栈倾向
- 启动方式 / 交付方式
- 当前明确不做的内容

提问原则：
- 如果 `$ARGUMENTS` 已经足够清晰，可以少问甚至不问
- 如果信息严重不足，先问最关键的 2-3 个，不要一次抛出全部问题
- 收集过程中注意积累复杂度信号，为 Step 2 做准备

---

## Step 2: 分析复杂度，自动选择模式 | Analyze Complexity & Select Mode

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

如果边界不清，默认偏向更轻的模式（light > feature > project）。

---

## Step 3: 生成 always-on 文档 | Generate Always-on Docs

### 3.1 生成 `README.md`
使用 `templates/README_TEMPLATE.md`。

要求：
- 面向人类开发者 / 试用者
- 能回答"这是什么、怎么跑、看哪里"
- 不复制 PRD / ARC 全文

### 3.2 生成 `CLAUDE.md`
使用 `templates/CLAUDE_TEMPLATE.md`。

要求：
- 面向 AI 工作流
- 明确哪些文档是 always-on，哪些是 conditional / temporary
- 明确何时升级到 Feature / Project mode
- 明确何时更新 README / ARC / API / feature brief / status board

---

## Step 4: 条件生成 `ARC.md` / `API.md` | Conditional Docs

### 4.1 生成 `ARC.md` 的条件
满足任一即可：
- 有明确技术栈选择理由
- 有部署 / 数据模型 / 鉴权 / 并发策略
- 用户希望记录架构决策
- 预计多人协作，需要留存技术边界

### 4.2 生成 `API.md` 的条件
满足任一即可：
- 存在 HTTP API / REST / webhook / RPC 接口
- 前后端分离，需要接口契约
- 用户明确希望记录 API

如果条件不满足，则不要强行生成这些文档，并在汇报里说明"本次先跳过，后续需要时再补"。

---

## Step 5: 生成 Feature / Project Artifact

### 5.1 Feature mode
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

### 5.2 Project mode
若 `.project-engineer/` 目录不存在，先创建它。

生成：
- `PRD.md`
- `.project-engineer/status.md`

使用：
- `templates/PRD_TEMPLATE.md`
- `templates/STATUS_TEMPLATE.md`

Project mode 只在复杂项目时启用，避免把小需求拖进重流程。

---

## Step 6: 完成汇报 | Completion Message

输出应明确包含：

```text
✅ 初始化完成
Mode: [light|feature|project]（自动判定理由：...）

Generated files:
- README.md
- CLAUDE.md
- [ARC.md if generated]
- [API.md if generated]
- [.project-engineer/FEATURE-{slug}.md if generated]
- [PRD.md if generated]
- [.project-engineer/status.md if generated]

Next step:
- 使用 /pe:focus 开始当前工作
```

---

## 生成原则 | Principles

- 先问后决定，不要提前假设模式
- 复杂度判定由 AI 完成，用户不需要理解模式区别
- 边界不清时偏向更轻的模式
- 所有模式都必须生成 `README.md` + `CLAUDE.md`
- 只有真正复杂项目才生成 `PRD.md` + `.project-engineer/status.md`
