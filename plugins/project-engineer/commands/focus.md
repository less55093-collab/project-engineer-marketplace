---
description: "确定当前最值得做的事情 — 优先使用 .project-engineer/status.md，否则从 README / CLAUDE / feature brief 推断下一步"
---

# /focus — 当前聚焦点 | Determine Current Focus

## 命令说明

`/focus` 是新的主推进命令，用来替代强依赖 `STATUS.md` 的 `/next`。

它会优先读取执行看板；如果没有看板，就根据当前模式给出**最值得做的 1-3 件事**。

---

## 执行步骤

1. **始终读取**
   - `README.md`
   - `CLAUDE.md`

2. **按存在性读取可选文档**
   - `ARC.md`
   - `API.md`
   - `.project-engineer/FEATURE-*.md`（优先读最近相关的）
   - `PRD.md`
   - `.project-engineer/status.md`
   - `STATUS.md`（legacy compatibility only）

3. **判定当前模式**
   - 若存在 `.project-engineer/status.md` → `project mode`
   - 否则若存在相关 `.project-engineer/FEATURE-*.md` → `feature mode`
   - 否则若存在 legacy `STATUS.md` → `legacy project mode`
   - 否则 → `light mode`

4. **按模式输出当前 focus**

### project mode
- 从 `.project-engineer/status.md` 找到：
  - 当前 milestone
  - 当前 task / 当前 lane
  - blocker
- 输出：
  ```text
  🎯 Mode: project
  Current milestone: ...
  Current focus: ...
  Support tasks:
  1. ...
  2. ...
  ```

### feature mode
- 从 `.project-engineer/FEATURE-{slug}.md` 找到：
  - 目标
  - acceptance criteria
  - 下一步实现切片
- 输出：
  ```text
  🎯 Mode: feature
  Feature: ...
  Next best actions:
  1. ...
  2. ...
  3. ...
  ```

### light mode
- 从 `README.md` + `CLAUDE.md` + 当前上下文推断：
  - 现在最值得做的 1-3 件事
  - 哪些文档需要同步
- 输出：
  ```text
  🎯 Mode: light
  Next best actions:
  1. ...
  2. ...
  3. ...
  ```

### legacy project mode
- 若只有根目录 `STATUS.md`，则按兼容模式读取它
- 输出时明确提示：
  - 当前是 legacy workflow
  - 推荐后续迁移到 `/focus` + `.project-engineer/status.md`

5. **结束提示**
- 若已有明确当前任务，可直接问：`按这个 focus 开始吗？`
- 若没有明确任务，则给出推荐顺序与升级建议（例如从 light 升级到 feature mode）

---

## 何时升级模式

- light → feature：当变更跨多个模块/页面/API，需要 acceptance / out-of-scope 说明
- feature → project：当功能开始拆成多个 milestone，或需要持续执行看板
- project → light：当 `.project-engineer/status.md` 全部完成并归档后，恢复只维护 always-on 文档

---

## 示例

### 示例 1：light mode
```text
🎯 Mode: light
Next best actions:
1. 明确 README 里的运行步骤
2. 创建首个页面或接口骨架
3. 若技术决策已稳定，再补 ARC.md
```

### 示例 2：project mode
```text
🎯 Mode: project
Current milestone: Auth MVP
Current focus: 实现登录 API 并验证 token 流程
Support tasks:
1. 更新 API.md
2. 完成后同步 .project-engineer/status.md
```
