#!/bin/bash
# hooks/post-tool-use.sh
# 触发时机：每次工具调用完成后
# 作用：
#   1. 记录代码文件变更，供 session-end hook 汇总
#   2. 检测架构级变更，触发 ARC.md 更新提醒
#   3. 检测 API 路由变更，触发 API.md 更新提醒

TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"

if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "MultiEdit" ]]; then
  exit 0
fi

if [ ! -f "CLAUDE.md" ] && [ ! -f "README.md" ]; then
  exit 0
fi

PYTHON_BIN=""
if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
fi

if [ -z "$PYTHON_BIN" ]; then
  echo "[project-engineer] post-tool-use hook skipped: requires python3 or python to parse tool input."
  exit 0
fi

MODIFIED_FILE=$(echo "$TOOL_INPUT" | "$PYTHON_BIN" -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('path', data.get('file_path', '')))
except:
    print('')
" 2>/dev/null)

[ -z "$MODIFIED_FILE" ] && exit 0

NORMALIZED_FILE="${MODIFIED_FILE//\\//}"

case "$NORMALIZED_FILE" in
  "STATUS.md"|"ARC.md"|"PRD.md"|"CLAUDE.md"|"API.md"|"README.md"|".project-engineer/status.md")
    exit 0
    ;;
  .project-engineer/FEATURE-*)
    exit 0
    ;;
  .project-engineer/archive/*)
    exit 0
    ;;
esac

mkdir -p ".claude-tmp"
echo "$MODIFIED_FILE" >> ".claude-tmp/session-changes.log"

ARC_TRIGGERS=("package.json" "go.mod" "requirements.txt" "pyproject.toml" "Cargo.toml" "pom.xml" "docker-compose" "Dockerfile" "schema" "migration" "prisma" "models/" "database/" "db/" "routes/" "api/" "middleware/")
IS_ARC_CHANGE=false
for t in "${ARC_TRIGGERS[@]}"; do
  [[ "$NORMALIZED_FILE" == *"$t"* ]] && IS_ARC_CHANGE=true && break
done

API_TRIGGERS=("routes/" "controllers/" "handlers/" "api/" "endpoints/")
IS_API_CHANGE=false
for t in "${API_TRIGGERS[@]}"; do
  [[ "$NORMALIZED_FILE" == *"$t"* ]] && IS_API_CHANGE=true && break
done

$IS_ARC_CHANGE && echo "
🏗️  [project-engineer] 架构级文件变更：$MODIFIED_FILE
→ 如当前项目已有 ARC.md，请执行 /arc-update 同步；若还没有 ARC.md 且这次决策值得保留，也可以现在创建它。
"

$IS_API_CHANGE && echo "
📡 [project-engineer] API 路由变更：$MODIFIED_FILE
→ 如当前项目存在 HTTP 接口，请执行 /api-gen 更新或生成 API.md。
"
