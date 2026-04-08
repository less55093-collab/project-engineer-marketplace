#!/bin/bash
# hooks/session-end.sh
# 触发时机：Claude Code 会话结束时（stop hook）
# 作用：汇总本次会话的工作并提醒同步 README / execution board / ARC / API

if [ ! -f "CLAUDE.md" ] && [ ! -f "README.md" ]; then
  exit 0
fi

CHANGE_LOG=".claude-tmp/session-changes.log"

if [ ! -f "$CHANGE_LOG" ] || [ ! -s "$CHANGE_LOG" ]; then
  exit 0
fi

CHANGED_FILES=$(cat "$CHANGE_LOG" | sort -u)
CHANGED_COUNT=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')

BOARD_PATH=""
BOARD_LABEL=""
if [ -f ".project-engineer/status.md" ]; then
  BOARD_PATH=".project-engineer/status.md"
  BOARD_LABEL="project mode execution board"
elif [ -f "STATUS.md" ]; then
  BOARD_PATH="STATUS.md"
  BOARD_LABEL="legacy STATUS.md"
fi

if [ -n "$BOARD_PATH" ]; then
  BOARD_NOTE=$'1. 根据以上变更，更新 '"${BOARD_PATH}"$'（'"${BOARD_LABEL}"$'）中的当前 focus / 任务状态 / blocker\n2. 如适用，更新整体进度并检查是否应归档 execution board'
else
  BOARD_NOTE=$'1. 当前没有激活 execution board\n2. 如果这轮工作已明显扩展范围，请考虑通过 /req-update 升级到 feature 或 project mode'
fi

cat << EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 [project-engineer] 会话结束 — 汇总变更并提醒同步文档
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

本次会话共修改了 ${CHANGED_COUNT} 个文件：
${CHANGED_FILES}

请在退出前执行以下操作：
${BOARD_NOTE}
3. 如涉及安装方式、启动步骤、环境变量、用户可见功能或目录结构变化，同步更新 README.md
4. 如涉及架构变更，同步更新 ARC.md（若该项目有 ARC.md，或这次值得新建）
5. 如涉及 HTTP 接口变化，同步更新 API.md（若该项目存在 HTTP API）

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

rm -f "$CHANGE_LOG"
rmdir ".claude-tmp" 2>/dev/null || true
