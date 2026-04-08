---
description: "[Deprecated] 兼容旧工作流，请改用 /focus"
---

# /next — Deprecated alias

`/next` 已弃用，请改用 `/focus`。

兼容行为：
- 如果项目存在 `.project-engineer/status.md`，按 `commands/focus.md` 的 **project mode** 行为执行。
- 如果项目只存在根目录 `STATUS.md`，按 legacy compatibility 方式读取并提示迁移。
- 如果没有任何 status board，则按 `commands/focus.md` 的 **light / feature mode** 行为执行。

维护新行为时，只更新 `commands/focus.md`。
