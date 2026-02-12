# MasterGo MCP for Claude Code

一键配置 MasterGo MCP，让 Claude Code 直接读取 MasterGo 设计稿并生成代码。

## 快速开始

### 方式一：全局安装（推荐）

```bash
git clone https://github.com/MKP999/claude-mastergo-setup.git
cd claude-mastergo-setup
chmod +x setup.sh
./setup.sh --token=<your_mastergo_token>
```

安装一次，所有项目都可以使用。

### 方式二：使用公司内部镜像

```bash
./setup.sh --token=<your_token> --url=https://your-internal-mastergo.com
```

### 方式三：项目级安装

如果只想在特定项目中使用：

```bash
# 方法 A: 用脚本安装到当前项目
cd /path/to/your-project
/path/to/setup.sh --token=<your_token> --scope=project

# 方法 B: 手动复制配置
cp -r project-template/.claude /path/to/your-project/
# 然后编辑 .claude/settings.json，替换 YOUR_TOKEN_HERE
```

## 获取 Token

1. 登录 [MasterGo](https://mastergo.com)
2. 进入 **个人设置** -> **API Token**
3. 创建并复制你的 Token

或联系团队管理员获取公共 Token。

## 使用方法

安装完成后，在 Claude Code 中：

1. 粘贴 MasterGo 设计稿链接，Claude 会自动解析并生成代码
2. 使用 `getDsl` 获取设计稿的 DSL 数据
3. 使用 `getComponentLink` 获取组件文档
4. 使用 `getMeta` 获取页面元信息
5. 使用 `getComponentGenerator` 启动组件开发工作流

## 卸载

```bash
# 移除全局配置
./uninstall.sh

# 移除项目级配置
./uninstall.sh project
```

## 前置要求

- [Node.js](https://nodejs.org/) >= 18
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (`npm install -g @anthropic-ai/claude-code`)
- MasterGo 账号及 API Token
