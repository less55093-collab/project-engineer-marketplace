# ARC — 系统架构文档

> 版本：1.0 | 创建时间：{DATE} | 最后更新：{DATE}
> ⚠️ 本文档是 **conditional artifact**：只在需要保留技术/部署/数据/鉴权决策时存在
> ⚠️ hooks 只会检测潜在架构变更并提醒执行 `/arc-update`，不会直接改写本文件

---

## 一、为什么需要 ARC | Why This Exists

- {为什么这份项目需要单独保存架构决策}

---

## 二、技术栈

| 层级 | 技术选型 | 选择原因 |
|------|----------|----------|
| 前端 | {框架} | {原因} |
| 后端 | {框架/语言} | {原因} |
| 数据库 | {数据库} | {原因} |
| 缓存 | {Redis / 无} | {原因} |
| 部署 | {平台} | {原因} |

---

## 三、系统结构

```text
{project-root}/
├── src/
├── .project-engineer/          # 仅 feature/project mode 存在
│   ├── FEATURE-{slug}.md       # feature mode
│   ├── status.md               # project mode
│   └── archive/                # 已完成的 execution board
├── README.md                   # always-on
├── CLAUDE.md                   # always-on
├── ARC.md                      # conditional
├── API.md                      # conditional
└── PRD.md                      # project mode only
```

---

## 四、关键架构决策

| 决策 | 选项 | 最终选择 | 原因 |
|------|------|----------|------|
| {问题} | A vs B | {选择} | {原因} |

---

## 五、数据 / 接口 / 部署要点

- 数据模型：{说明}
- 鉴权方式：{说明}
- 部署策略：{说明}
- 性能 / 并发策略：{说明}

---

## 六、变更日志

| 日期 | 版本 | 变更内容 |
|------|------|----------|
| {DATE} | 1.0 | 初始架构 |
