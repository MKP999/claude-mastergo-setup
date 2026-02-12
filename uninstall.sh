#!/bin/bash
#
# MasterGo MCP for Claude Code - 卸载脚本
#

set -e

MCP_NAME="mastergo-magic-mcp"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

echo ""
echo "========================================="
echo "  MasterGo MCP 卸载程序"
echo "========================================="
echo ""

if ! command -v claude &> /dev/null; then
  error "未找到 claude 命令"
fi

SCOPE="${1:-user}"

info "正在移除 MasterGo MCP (范围: $SCOPE)..."

if [ "$SCOPE" = "project" ]; then
  claude mcp remove --scope project "$MCP_NAME" 2>/dev/null && success "项目级 MCP 已移除" || info "未找到项目级 MCP 配置"
else
  claude mcp remove "$MCP_NAME" 2>/dev/null && success "全局 MCP 已移除" || info "未找到全局 MCP 配置"
fi

echo ""
success "卸载完成!"
echo ""
