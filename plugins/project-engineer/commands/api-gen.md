---
description: "扫描路由文件，生成或更新 API.md 接口文档骨架"
---

# /api-gen — 生成或更新 API 文档骨架

Generate or update API documentation | 生成或更新 API 文档

## 命令说明

`API.md` 现在是 **conditional artifact**。
只有项目存在 HTTP API / webhook / 稳定接口契约时，才建议维护它。

## Usage | 用法

```
/api-gen          # 扫描全部路由，生成完整 API.md
/api-gen [path]   # 只更新指定路由文件的接口
```

`$ARGUMENTS` — 可选，指定扫描路径

> ⚠️ 当前命令默认适用于 **存在 HTTP 路由的 Web/API 项目**。如果项目没有 HTTP API，请不要强行生成 REST 文档。

---

## Execution Steps | 执行步骤

### Step 1: Scan Route Files | 扫描路由文件

Scan the following locations for API definitions:
扫描以下位置的 API 定义：

- `routes/`、`api/`、`controllers/`、`handlers/`、`endpoints/`
- Framework-specific patterns | 框架特定模式：
  - Express: `router.get/post/put/delete/patch`
  - FastAPI / Flask: `@app.route`, `@router.get`
  - Go: `r.HandleFunc`, `r.GET/POST`
  - Spring: `@GetMapping`, `@PostMapping`, `@RequestMapping`

If no route files or HTTP endpoint patterns are found, stop and report that the current project may not need `API.md` in REST form.

### Step 2: Extract Endpoint Info | 提取接口信息

For each endpoint, extract | 对每个接口提取：
- HTTP method (GET/POST/PUT/DELETE/PATCH)
- Path (e.g. `/api/users/:id`)
- Request parameters / body schema
- Response shape (if inferrable from code)
- Auth required (check for middleware references)
- Description (from comments if available)

### Step 3: Generate or Update API.md | 生成/更新 API.md

If `API.md` does not exist, create it from the template.
If it exists, only update changed or new endpoints, preserve existing descriptions.

如果 `API.md` 不存在，从模板创建。
如果已存在，只更新变更或新增的接口，保留已有的手写描述。

Use the template at `templates/API_TEMPLATE.md`.
This command updates documentation after code changes; hook reminders do not execute it automatically.

### Step 4: Summary | 完成汇报

Output:
```
✅ API.md updated
📡 Endpoints: [total count]
  + [N] new endpoints added
  ~ [N] endpoints updated
  = [N] endpoints unchanged
```

If no HTTP route patterns are found, report something like:
```
ℹ️ No HTTP routes found
This project may not need REST-style API.md output right now.
```

---

## Notes | 注意事项

- **Preserve manual edits** — Do not overwrite descriptions written by the developer
  保留开发者手动填写的描述，不要覆盖
- **Mark unknowns** — If request/response schema cannot be inferred, mark as `{待补充 / TBD}`
  无法推断的 schema 标记为待补充
- **Group by resource** — Group endpoints by resource (users, products, etc.)
  按资源分组整理接口
