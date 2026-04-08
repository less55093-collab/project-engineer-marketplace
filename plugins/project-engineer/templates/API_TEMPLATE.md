# API — 接口文档 | API Documentation

> Version: 1.0 | Updated: {DATE}
> This template assumes an HTTP API / web backend. If the project has no HTTP API, adapt this file into an interface contract document or remove it.
> Base URL: `{BASE_URL}`
> Auth: `{AUTH_METHOD}` — e.g. `Authorization: Bearer <token>`

---

## 认证 | Authentication

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "string",
  "password": "string"
}
```

**Response 200**
```json
{
  "token": "string",
  "refresh_token": "string",
  "expires_in": 3600
}
```

---

## {Resource 1}

### GET /api/{resource}
> 获取列表 | List all

**Query Parameters**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| page | number | No | 页码，默认 1 |
| limit | number | No | 每页数量，默认 20 |

**Response 200**
```json
{
  "data": [],
  "total": 0,
  "page": 1,
  "limit": 20
}
```

---

### GET /api/{resource}/:id
> 获取单条 | Get by ID

**Path Parameters**: `id` — resource ID

**Response 200**
```json
{
  "id": "string",
  "{field}": "{待补充 / TBD}"
}
```

**Response 404**
```json
{ "error": "Not found" }
```

---

### POST /api/{resource}
> 创建 | Create

🔒 Auth required

**Request Body**
```json
{
  "{field}": "{type} — {待补充 / TBD}"
}
```

**Response 201**
```json
{
  "id": "string",
  "created_at": "ISO8601"
}
```

---

### PUT /api/{resource}/:id
> 更新 | Update

🔒 Auth required

**Request Body**: Fields to update (partial update supported)

**Response 200**: Updated object

---

### DELETE /api/{resource}/:id
> 删除 | Delete

🔒 Auth required

**Response 204**: No content

---

## 错误码 | Error Codes

| Code | Meaning |
|------|---------|
| 400 | Bad Request — 请求参数错误 |
| 401 | Unauthorized — 未认证 |
| 403 | Forbidden — 无权限 |
| 404 | Not Found — 资源不存在 |
| 409 | Conflict — 资源冲突（如重复创建）|
| 422 | Unprocessable Entity — 数据验证失败 |
| 429 | Too Many Requests — 限流 |
| 500 | Internal Server Error — 服务器错误 |

---

## 变更日志 | Changelog

| Date | Version | Change |
|------|---------|--------|
| {DATE} | 1.0 | Initial API scaffold |
