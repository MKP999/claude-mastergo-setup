#!/bin/bash
#
# MasterGo MCP for Claude Code - 一键安装脚本
#
# 用法:
#   ./setup.sh --token=<your_token>
#   ./setup.sh --token=<your_token> --url=https://your-internal-mirror.com
#   ./setup.sh --token=<your_token> --scope=project   # 仅安装到当前项目
#

set -e

# ======================== 默认配置 ========================
DEFAULT_URL="https://mastergo.com"
MCP_NAME="mastergo-magic-mcp"
SCOPE="user"  # 默认全局安装

# ======================== 颜色输出 ========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ======================== 解析参数 ========================
TOKEN=""
URL="$DEFAULT_URL"

for arg in "$@"; do
  case $arg in
    --token=*)
      TOKEN="${arg#*=}"
      ;;
    --url=*)
      URL="${arg#*=}"
      ;;
    --scope=project)
      SCOPE="project"
      ;;
    --scope=user)
      SCOPE="user"
      ;;
    --help|-h)
      echo ""
      echo "MasterGo MCP for Claude Code - 一键安装"
      echo ""
      echo "用法:"
      echo "  ./setup.sh --token=<your_token>                          # 全局安装(默认)"
      echo "  ./setup.sh --token=<your_token> --url=<mirror_url>       # 使用内部镜像"
      echo "  ./setup.sh --token=<your_token> --scope=project          # 仅安装到当前项目"
      echo ""
      echo "参数:"
      echo "  --token=TOKEN     MasterGo API Token (必填)"
      echo "  --url=URL         MasterGo 服务地址 (默认: $DEFAULT_URL)"
      echo "  --scope=SCOPE     安装范围: user(全局) 或 project(项目级) (默认: user)"
      echo "  --help, -h        显示帮助信息"
      echo ""
      echo "获取 Token:"
      echo "  1. 登录 MasterGo -> 个人设置 -> API Token"
      echo "  2. 或联系团队管理员获取公共 Token"
      echo ""
      exit 0
      ;;
    *)
      warn "未知参数: $arg (使用 --help 查看帮助)"
      ;;
  esac
done

# ======================== 前置检查 ========================
echo ""
echo "========================================="
echo "  MasterGo MCP for Claude Code 安装程序"
echo "========================================="
echo ""

# 检查 Token
if [ -z "$TOKEN" ]; then
  error "缺少 Token 参数。用法: ./setup.sh --token=<your_token>\n  运行 ./setup.sh --help 查看帮助"
fi

# 检查 claude 命令
if ! command -v claude &> /dev/null; then
  error "未找到 claude 命令。请先安装 Claude Code:\n  npm install -g @anthropic-ai/claude-code"
fi

# 检查 npx 命令
if ! command -v npx &> /dev/null; then
  error "未找到 npx 命令。请先安装 Node.js: https://nodejs.org/"
fi

info "安装范围: $([ "$SCOPE" = "user" ] && echo "全局(user)" || echo "项目级(project)")"
info "服务地址: $URL"
info "MCP 名称: $MCP_NAME"
echo ""

# ======================== 安装 MCP ========================
info "正在注册 MasterGo MCP 服务..."

SCOPE_FLAG=""
if [ "$SCOPE" = "project" ]; then
  SCOPE_FLAG="--scope project"
fi

claude mcp add $SCOPE_FLAG "$MCP_NAME" \
  -- npx -y @mastergo/magic-mcp \
  --token="$TOKEN" \
  --url="$URL"

success "MCP 服务注册成功!"
echo ""

# ======================== 验证连接 ========================
info "正在验证连接..."

# 列出 MCP 并检查是否包含 mastergo
if claude mcp list 2>/dev/null | grep -q "$MCP_NAME"; then
  success "MasterGo MCP 已成功安装并连接!"
else
  warn "MCP 已注册，但连接验证需要在 Claude Code 会话中确认"
fi

echo ""
echo "========================================="
echo "  安装完成!"
echo "========================================="
echo ""
echo "  现在你可以在 Claude Code 中使用 MasterGo 了。"
echo "  试试: 粘贴一个 MasterGo 设计链接，让 Claude 帮你生成代码。"
echo ""
