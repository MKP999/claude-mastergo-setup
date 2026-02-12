#!/bin/bash
#
# MasterGo MCP for Claude Code - 卸载脚本
#

set -e

MCP_NAME="mastergo-magic-mcp"
SKILL_NAME="mastergo-implement-design.md"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

SCOPE="${1:-user}"

echo ""
echo "========================================="
echo "  MasterGo MCP 卸载程序"
echo "========================================="
echo ""

if ! command -v claude &> /dev/null; then
  error "未找到 claude 命令"
fi

# 卸载 MCP
info "正在移除 MasterGo MCP (范围: $SCOPE)..."

if [ "$SCOPE" = "project" ]; then
  claude mcp remove --scope project "$MCP_NAME" 2>/dev/null && success "项目级 MCP 已移除" || info "未找到项目级 MCP 配置"
else
  claude mcp remove "$MCP_NAME" 2>/dev/null && success "全局 MCP 已移除" || info "未找到全局 MCP 配置"
fi

# 卸载 Skill
info "正在移除 MasterGo Skill..."

if [ "$SCOPE" = "project" ]; then
  SKILL_PATH="$(pwd)/.claude/skills/$SKILL_NAME"
else
  SKILL_PATH="$HOME/.claude/skills/$SKILL_NAME"
fi

if [ -f "$SKILL_PATH" ]; then
  rm "$SKILL_PATH"
  success "Skill 文件已移除: $SKILL_PATH"
else
  info "未找到 Skill 文件: $SKILL_PATH"
fi

echo ""
success "卸载完成!"
echo ""
