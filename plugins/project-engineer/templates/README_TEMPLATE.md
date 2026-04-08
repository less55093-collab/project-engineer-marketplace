# {PROJECT_NAME}

> 一句话描述项目解决的问题与目标用户
> One-line summary of what this project does and who it serves

---

## 项目概览 | Overview

- **目标用户 | Audience**：{主要用户}
- **核心问题 | Problem**：{要解决的核心问题}
- **当前模式 | Workflow Mode**：{light / feature / project}
- **项目状态 | Status**：{规划中 / 开发中 / 已上线}

## 核心能力 | Core Features

- {核心功能 1}
- {核心功能 2}
- {核心功能 3}

## 快速开始 | Quick Start

### 1. 环境要求 | Prerequisites

- {运行环境，例如 Node.js 20 / Python 3.11 / Docker}
- {数据库 / 缓存 / 第三方服务要求}

### 2. 安装依赖 | Install

```bash
{安装命令，例如 npm install}
```

### 3. 配置环境变量 | Configure Environment

复制并填写环境变量：

```bash
cp .env.example .env
```

最少需要：

```env
{ENV_KEY}={VALUE}
```

### 4. 启动项目 | Run

```bash
{启动命令，例如 npm run dev}
```

启动后访问：

- Web: `{APP_URL}`
- API: `{API_BASE_URL}`

## 常用命令 | Common Commands

```bash
{开发命令}
{测试命令}
{构建命令}
```

## 项目结构 | Project Structure

```text
{project-root}/
├── src/
├── .project-engineer/          # feature / project mode 才需要
│   ├── FEATURE-{slug}.md       # optional
│   ├── status.md               # optional
│   └── archive/                # optional
├── README.md                   # always-on
├── CLAUDE.md                   # always-on
├── ARC.md                      # optional
├── API.md                      # optional
└── PRD.md                      # project mode only
```

## 文档导航 | Project Docs

- `README.md` — 给人看的项目入口、启动方式、常用命令
- `CLAUDE.md` — AI 工作说明与升级规则
- `ARC.md` — 技术栈、架构设计、关键决策（可选）
- `API.md` — HTTP 接口说明（可选）
- `.project-engineer/FEATURE-{slug}.md` — 中等复杂度 feature brief（可选）
- `PRD.md` — 大项目需求文档（project mode）
- `.project-engineer/status.md` — 临时执行看板（project mode）

## 当前限制 | Current Limitations

- {当前明确不支持的内容}

## 路线图 | Roadmap

- {下一阶段目标}

## 维护说明 | Maintenance Notes

当以下内容变化时，应同步更新 `README.md`：

- 安装步骤
- 启动命令
- 环境变量
- 对外功能说明
- 项目结构
- API / 鉴权接入方式
- 当前工作模式（如果对协作者有帮助）
