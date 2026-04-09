#!/bin/bash
# hooks/session-end.sh
# 触发时机：会话结束时
# 作用：如果有未提交的变更记录，简要提醒一次

if [ ! -f "CLAUDE.md" ] && [ ! -f "README.md" ]; then
  exit 0
fi

CHANGE_LOG=".claude-tmp/session-changes.log"

if [ ! -f "$CHANGE_LOG" ] || [ ! -s "$CHANGE_LOG" ]; then
  exit 0
fi

CHANGED_COUNT=$(sort -u "$CHANGE_LOG" | wc -l | tr -d ' ')

echo ""
echo "📋 [pe] 本次会话修改了 ${CHANGED_COUNT} 个代码文件，尚未通过 /pe:commit 提交。"
echo "   如需提交，/pe:commit 会自动检查哪些文档需要同步。"
echo ""

rm -f "$CHANGE_LOG"
rmdir ".claude-tmp" 2>/dev/null || true
