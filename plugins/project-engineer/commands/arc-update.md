---
description: "更新或创建 ARC.md — 当项目出现值得保留的技术/部署/数据/鉴权决策时使用"
---

# /arc-update — 更新架构文档 | Update or Create ARC

## 命令说明

`ARC.md` 现在是 **conditional artifact**，不是每个项目都默认存在。

因此本命令既可以：
- 更新已有 `ARC.md`
- 也可以在项目从 light / feature mode 进入需要保留架构决策的阶段时，新建 `ARC.md`

PostToolUse hook 只负责提醒；真正的文档创建/更新由本命令完成。

`$ARGUMENTS` — 可选，描述本次变更原因

---

## 执行步骤

1. **读取上下文**
   - `README.md`
   - `CLAUDE.md`
   - 如存在再读：`ARC.md`、`API.md`、`.project-engineer/FEATURE-*.md`、`PRD.md`

2. **判断是“更新”还是“新建”**
   - 若 `ARC.md` 已存在：更新它
   - 若 `ARC.md` 不存在，但当前出现以下任一情况：
     - 明确技术栈决策
     - 部署 / 鉴权 / 数据 / 并发策略已成型
     - 用户要求记录架构决策
     - 项目复杂度已不适合只靠 README 说明
     则创建 `ARC.md`

3. **扫描当前代码结构**
   - 读取项目目录结构
   - 识别新增/删除/重命名的模块、服务、数据库表等

4. **更新内容**
   - 技术栈与选择原因
   - 系统结构 / 目录结构
   - 数据 / 接口 / 部署要点
   - 关键架构决策
   - 变更日志
   - 若架构变化影响安装方式、启动步骤、目录结构说明，也同步更新 `README.md`

5. **完成提示**
   ```text
   ✅ ARC.md ready
   Action: [created|updated]
   Change: [简述]
   ```

---

## 示例 | Example

```bash
/arc-update 新增鉴权中间件并确定部署到 Vercel + Postgres
```

如果这次变更让技术决策第一次变得“值得保留”，即使之前没有 `ARC.md`，也应创建它。
