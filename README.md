# MasterGo MCP for Claude Code

一键配置 MasterGo MCP，让 Claude Code 直接读取 MasterGo 设计稿并生成代码。

## 特性

- 🔌 **一键安装 MCP 服务器** - 自动注册 MasterGo MCP 服务
- 📦 **内置 Skill 工作流** - 完整的设计到代码转换流程
- 🎯 **项目级配置支持** - 可全局安装或仅安装到特定项目
- 🏢 **内部镜像支持** - 支持公司内部 MasterGo 镜像
- 🔄 **智能上下文** - 自动识别项目框架，使用现有组件库

## 快速开始

### 方式一：全局安装（推荐）

安装一次，所有项目都可以使用：

```bash
git clone https://github.com/MKP999/claude-mastergo-setup.git
cd claude-mastergo-setup
./setup.sh --token=<your_mastergo_token>
```

### 方式二：使用公司内部镜像

```bash
./setup.sh --token=<your_token> --url=https://your-internal-mastergo.com
```

### 方式三：项目级安装

如果只想在特定项目中使用：

```bash
cd /path/to/your-project
/path/to/claude-mastergo-setup/setup.sh --token=<your_token> --scope=project
```

## 获取 Token

1. 登录 [MasterGo](https://mastergo.com)
2. 进入 **个人设置** -> **API Token**
3. 创建并复制你的 Token

或联系团队管理员获取公共 Token。

## 使用方法

安装完成后，在 Claude Code 中：

### 1. 粘贴 MasterGo 链接

直接粘贴设计稿链接，Claude 会自动识别并开始工作流：

```
https://mastergo.com/design/xxxxx?layer_id=xx-xx
```

### 2. 或直接描述需求

```
帮我实现这个 MasterGo 设计
```

### 3. Skill 工作流

内置的 `mastergo-implement-design` Skill 会自动执行以下步骤：

1. **解析 URL** - 提取 fileId 和 layerId
2. **获取设计上下文** - 调用 `mcp__getDsl` 获取设计数据
3. **分析项目框架** - 自动识别当前项目技术栈
4. **选择组件库** - 优先使用项目现有组件
5. **生成代码** - 保持 1:1 视觉还原
6. **验证结果** - 确保设计与代码一致

## 支持的 MCP 工具

| 工具 | 说明 |
|------|------|
| `mcp__getDsl` | 获取设计稿 DSL 数据 |
| `mcp__getComponentLink` | 获取组件文档链接 |
| `mcp__getMeta` | 获取页面元信息 |
| `mcp__getComponentGenerator` | 启动组件开发工作流 |

## 目录结构

```
claude-mastergo-setup/
├── README.md                          # 使用说明
├── setup.sh                           # 一键安装脚本
├── uninstall.sh                       # 卸载脚本
├── skills/                            # Skill 文件
│   └── mastergo-implement-design/
│       └── .claude-plugin/
│           └── mastergo-implement-design.md
└── project-template/                  # 项目级配置模板
    └── .claude/
        └── settings.json
```

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

## 安装参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--token` | MasterGo API Token（必填） | - |
| `--url` | MasterGo 服务地址 | `https://mastergo.com` |
| `--scope` | 安装范围：`user`(全局) 或 `project`(项目级) | `user` |
| `--no-skill` | 跳过 Skill 文件安装 | - |
| `--help` | 显示帮助信息 | - |

## 常见问题

### Q: 安装后 Claude 没有反应？

A: 重启 Claude Code 或重新打开会话，确保 MCP 服务已加载。

### Q: 如何验证安装是否成功？

A: 运行 `claude mcp list`，查看是否包含 `mastergo-magic-mcp`。

### Q: 项目级安装和全局安装有什么区别？

A:
- **全局安装**: 一次配置，所有项目可用，推荐
- **项目级安装**: 仅当前项目可用，适合需要独立配置的场景

### Q: 如何在已有项目中使用？

A: 如果已全局安装，直接在项目中使用即可。如果需要项目级配置，在项目目录下运行 `./setup.sh --scope=project`。

## License

MIT
