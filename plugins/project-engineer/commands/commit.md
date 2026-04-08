---
description: "自动分析 git 变更，生成符合 Conventional Commits 规范的提交信息并执行提交"
---

# /commit — 规范化 Git 提交

Smart git commit with Conventional Commits format | 自动生成规范 commit message 并提交

## Usage | 用法

```
/commit           # 自动分析变更，生成 commit message 并提交
/commit [hint]    # 带提示词，帮助生成更准确的 message
```

`$ARGUMENTS` — 可选，补充描述本次变更意图

---

## Execution Steps | 执行步骤

### Step 1: Check Git Status | 检查 Git 状态

Run `git status` and `git diff --staged` to understand:
- Which files are staged
- Which files are unstaged
- Whether there are untracked files

If nothing is staged, run `git add -A` first (ask user to confirm if >20 files changed).

### Step 2: Analyze Changes | 分析变更内容

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

### Step 3: Generate Commit Message | 生成 Commit Message

Format:
```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

Rules | 规则:
- Subject: ≤50 characters, imperative mood, no period at end
  主题：≤50 字符，用祈使语气（"add" not "added"），不加句号
- Body: explain *why*, not *what*. Wrap at 72 chars.
  正文：解释「为什么」而非「做了什么」，72 字换行
- Footer: reference issues if applicable (`Closes #123`, `Refs #456`)
  尾部：引用相关 issue

### Step 4: Show Preview & Confirm | 预览并确认

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

### Step 5: Execute & Report | 执行并汇报

After commit:
```
✅ Committed: feat(auth): add JWT refresh token rotation
📦 Files: 4 changed, 127 insertions(+), 23 deletions(-)
🔖 Hash: a3f9c2d
```

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
