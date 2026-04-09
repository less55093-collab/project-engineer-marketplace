---
description: "分析变更、检查文档同步、生成 Conventional Commits 提交"
---

# /commit — 规范化 Git 提交

Smart git commit with doc-sync check and Conventional Commits format.

## Usage | 用法

```
/pe:commit           # 自动分析变更，检查文档同步，生成 commit message 并提交
/pe:commit [hint]    # 带提示词，帮助生成更准确的 message
```

`$ARGUMENTS` — 可选，补充描述本次变更意图

---

## Step 1: Check Git Status | 检查 Git 状态

Run `git status` and `git diff --staged` to understand:
- Which files are staged
- Which files are unstaged
- Whether there are untracked files

If nothing is staged, run `git add -A` first (ask user to confirm if >20 files changed).

---

## Step 2: Doc-Sync Check | 文档同步检查

读取 `.claude-tmp/session-changes.log`（由 PostToolUse hook 自动记录），对本次会话修改的文件做去重后，按以下规则检测哪些文档可能需要同步。

### 架构级变更检测

如果修改的文件路径包含以下任一关键词，标记为**可能需要更新 ARC.md**：

`package.json`, `go.mod`, `requirements.txt`, `pyproject.toml`, `Cargo.toml`, `pom.xml`, `docker-compose`, `Dockerfile`, `schema`, `migration`, `prisma`, `models/`, `database/`, `db/`, `middleware/`

### API 变更检测

如果修改的文件路径包含以下任一关键词，标记为**可能需要更新 API.md**：

`routes/`, `controllers/`, `handlers/`, `api/`, `endpoints/`

### README 变更检测

如果修改涉及以下任一方面，标记为**可能需要更新 README.md**：

- 安装方式、启动步骤相关文件（`package.json`, `docker-compose`, `Makefile`, `setup.*`）
- 环境变量配置（`.env.example`, `config/`）
- 目录结构有显著变化（新增或删除了顶级目录）

### 执行看板检测

- 若存在 `.project-engineer/status.md` → 标记为**可能需要更新执行看板**
- 若存在 legacy `STATUS.md` → 同上

### 输出格式

如果检测到需要同步的文档，在 commit message 预览之前输出：

```text
📋 Doc-sync check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
本次会话修改了 N 个代码文件：
- file1.ts
- file2.ts
- ...

可能需要同步的文档：
- [ ] ARC.md — 检测到架构级变更（schema, models/, ...）
- [ ] API.md — 检测到路由变更（routes/, controllers/, ...）
- [ ] README.md — 检测到安装/启动相关变更
- [ ] .project-engineer/status.md — 项目有执行看板
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
先同步文档再提交，还是直接提交？
```

如果没有检测到任何需要同步的文档，跳过此步，直接进入 Step 3。

---

## Step 3: Analyze Changes | 分析变更内容

Read the diff and categorize the change type:

| Type | When to use | 使用场景 |
|------|-------------|----------|
| `feat` | New feature | 新增功能 |
| `fix` | Bug fix | 修复 bug |
| `refactor` | Restructure without behavior change | 重构，不改变行为 |
| `docs` | Documentation only | 仅文档变更 |
| `style` | Formatting, no logic change | 格式调整，无逻辑变更 |
| `test` | Add or update tests | 测试相关 |
| `chore` | Build tools, config, deps | 构建/配置/依赖 |
| `perf` | Performance improvement | 性能优化 |

Scope is optional — use the module/feature name if clear (e.g. `feat(auth):`, `fix(api):`).

---

## Step 4: Generate Commit Message | 生成 Commit Message

Format:
```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

Rules | 规则:
- Subject: ≤50 characters, imperative mood, no period at end
- Body: explain *why*, not *what*. Wrap at 72 chars.
- Footer: reference issues if applicable (`Closes #123`, `Refs #456`)

---

## Step 5: Show Preview & Confirm | 预览并确认

Display the generated message:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Commit Message Preview:

feat(auth): add JWT refresh token rotation

- Implement sliding window refresh token strategy
- Add token blacklist to prevent reuse after logout
- Update auth middleware to handle token refresh

Closes #42
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Confirm commit? [Y/n/edit]
```

- **Y** — execute `git commit`
- **n** — abort
- **edit** — let user modify the message

---

## Step 6: Execute & Cleanup | 执行并清理

After commit:
```
✅ Committed: feat(auth): add JWT refresh token rotation
📦 Files: 4 changed, 127 insertions(+), 23 deletions(-)
🔖 Hash: a3f9c2d
```

清理变更日志：
- 删除 `.claude-tmp/session-changes.log`
- 如果 `.claude-tmp/` 为空，删除该目录

Optionally ask: "Push to remote? (git push)"

---

## Commit Message Examples | 示例

```bash
feat(user): add avatar upload endpoint
fix(api): handle null response in payment webhook
refactor(db): extract query builder into separate module
docs: update API.md with new auth endpoints
chore(deps): upgrade express to 4.18.2
perf(search): add database index on user email field
```
