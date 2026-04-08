---
description: "更新 project mode 执行看板（.project-engineer/status.md），并兼容 legacy STATUS.md"
---

# /status-update — 更新执行看板 | Update Execution Board

## 命令说明

本命令主要服务于 **project mode**。
优先更新 `.project-engineer/status.md`；如果项目仍在使用根目录 `STATUS.md`，则以 legacy compatibility 模式更新它。

如果当前项目没有任何 status board，说明它可能处于 light / feature mode，此时不应强行维护执行看板。

`$ARGUMENTS` — 可选，本次完成内容摘要

---

## 执行步骤

1. **定位执行看板**
   - 若存在 `.project-engineer/status.md` → 更新它
   - 否则若存在 `STATUS.md` → 兼容更新 legacy board
   - 否则：
     - 汇报“当前项目没有激活 execution board”
     - 建议继续使用 `/focus`
     - 若工作已明显扩大，建议通过 `/req-update` 升级到 project mode

2. **读取上下文**
   - `README.md`
   - `CLAUDE.md`
   - `PRD.md`（若存在）
   - `.project-engineer/FEATURE-*.md`（若相关）
   - 目标 status board

3. **更新状态**
   - 更新当前 milestone / current focus / blockers / done items
   - 重新计算进度
   - 保持最多一个 `当前 focus`
   - 若是 legacy `STATUS.md`，只做兼容更新，不自动迁移

4. **完成与归档**
   - 如果 `.project-engineer/status.md` 中所有 milestone / tasks 都已完成：
     - 若 `.project-engineer/archive/` 不存在，先创建它
     - 建议归档到 `.project-engineer/archive/status-{DATE}.md`
     - 并回到 light mode，只维护 always-on 文档

5. **完成提示**
   ```text
   📊 Execution board updated
   Active board: [.project-engineer/status.md | STATUS.md]
   Progress: [X]%
   Current focus: ...
   ```

---

## 规则 | Rules

- `status-update` 不是默认常驻命令，只有 project mode / legacy 项目才重度使用它
- feature mode 优先更新 `FEATURE-{slug}.md`，而不是强行创建 status board
- light mode 一般不需要 status board
