---
description: "评估需求变更并按 small / medium / large 选择 light / feature / project 路径"
---

# /req-update — 自适应需求变更处理 | Adaptive Requirement Change Flow

## 命令说明

用户在项目进行中提出新需求或变更已有需求时使用。
本命令不再默认假设必须修改 `PRD.md` / `STATUS.md`，而是根据复杂度升级工作流。

`$ARGUMENTS` — 用户描述的新需求或变更内容

---

## Step 1: 读取上下文 | Read Current Context

始终读取：
- `README.md`
- `CLAUDE.md`

按存在性读取：
- `ARC.md`
- `API.md`
- `.project-engineer/FEATURE-*.md`
- `.project-engineer/status.md`
- `PRD.md`
- `STATUS.md`（legacy compatibility）

---

## Step 2: 理解变更 | Clarify the Change

如果 `$ARGUMENTS` 不够清晰，**最多提 2 个问题**：
- 这是小调整、一个独立功能，还是会影响整体 roadmap？
- 这个变更是否会跨多次会话 / 多个模块 / 多个接口？

---

## Step 3: 判定变更级别 | Classify the Change

### small change
适用：
- 小改动 / 小补充 / 小修正
- 不需要长期看板
- 不需要完整 feature brief 或 PRD

通常只更新：
- `README.md`
- `ARC.md`（若有）
- `API.md`（若有）

### medium change
适用：
- 一个边界清晰的功能块
- 跨多个模块/页面/API
- 需要 acceptance / out-of-scope
- 但还不需要多 milestone 看板

通常生成或更新：
- `.project-engineer/FEATURE-{slug}.md`
- `README.md`
- `ARC.md` / `API.md`（按需）

### large change
适用：
- 影响整体需求边界 / roadmap / 多个功能域
- 需要多 milestone / 多次会话推进
- 需要执行看板或多人协作

通常生成或更新：
- `PRD.md`
- `.project-engineer/status.md`
- `README.md`
- `ARC.md` / `API.md`（按需）

---

## Step 4: 输出影响评估 | Impact Report

输出格式：

```text
📋 需求变更影响评估
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
变更描述：[一句话概括]
变更级别：small / medium / large

📘 README.md：
  - [有/无影响]

🏗️ ARC.md：
  - [有/无影响]

📡 API.md：
  - [有/无影响]

🧩 Feature Brief：
  - [新建 / 更新 / 不需要]

📄 PRD.md：
  - [新建 / 更新 / 不需要]

📊 Status Board：
  - [.project-engineer/status.md / legacy STATUS.md / 不需要]

⚠️ 风险：
  - [...]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
确认后我将更新对应文档。继续？ [Y/n]
```

---

## Step 5: 确认后执行 | Apply the Right Path

### 如果是 small change
- 直接更新 `README.md`
- 如有架构影响，更新 `ARC.md`
- 如有接口影响，更新 `API.md`
- 不创建 PRD / status board

### 如果是 medium change
- 若 `.project-engineer/` 目录不存在，先创建它
- 生成或更新 `.project-engineer/FEATURE-{slug}.md`
- 更新 `README.md`
- 如需要，再更新 `ARC.md` / `API.md`
- 若该 feature 后续扩展为多 milestone，则提示升级到 project mode

### 如果是 large change
- 若 `.project-engineer/` 目录不存在，先创建它
- 生成或更新 `PRD.md`
- 生成或更新 `.project-engineer/status.md`
- 更新 `README.md`
- 如需要，再更新 `ARC.md` / `API.md`

### legacy compatibility
- 如果项目已有根目录 `STATUS.md`，不要静默删除
- 先兼容更新，并提示未来迁移到 `.project-engineer/status.md`

---

## Step 6: 完成汇报 | Summary

```text
✅ 需求变更处理完成
Mode after change: [light|feature|project|legacy]
Updated artifacts:
- ...

Next step:
- 运行 /focus 继续当前工作
```

---

## Promotion / Demotion Rules

- feature → project：当任务开始拆成多个 milestone，或需要持续执行看板
- project → light：当 `.project-engineer/status.md` 完成并归档后，仅保留 always-on 文档

## 示例

```bash
/req-update 新增邮件通知功能，但先不做完整消息中心
```

这类请求通常应先判定为 `medium change`，优先进入 `FEATURE-{slug}.md`，而不是立即拉起 PRD + status board。
