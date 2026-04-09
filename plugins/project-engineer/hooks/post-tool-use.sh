#!/bin/bash
# hooks/post-tool-use.sh
# 触发时机：每次 Write/Edit/MultiEdit 工具调用完成后
# 作用：静默记录变更文件路径，供 commit 和 session-end 汇总

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

# Skip doc files — only track code changes
case "$NORMALIZED_FILE" in
  "STATUS.md"|"ARC.md"|"PRD.md"|"CLAUDE.md"|"API.md"|"README.md"|".project-engineer/status.md")
    exit 0
    ;;
  .project-engineer/FEATURE-*|.project-engineer/archive/*)
    exit 0
    ;;
esac

mkdir -p ".claude-tmp"
echo "$NORMALIZED_FILE" >> ".claude-tmp/session-changes.log"
