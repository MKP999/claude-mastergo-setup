---
name: mastergo-implement-design
description: 将 MasterGo 设计稿转换为项目代码，保持 1:1 视觉还原度。当用户提到 "实现 MasterGo 设计"、"生成代码"、"实现组件"，或提供 MasterGo 链接时使用。需要连接 MasterGo MCP 服务器。
metadata:
  mcp-server: mastergo-magic-mcp
---

# MasterGo Implement Design

## 概述

此 Skill 提供将 MasterGo 设计稿转换为生产级代码的结构化工作流程。确保与 MasterGo MCP 服务器的正确集成，实现 1:1 的视觉还原。

## 前置条件

- MasterGo MCP 服务器必须已连接且可访问
- 用户需要提供 MasterGo URL，格式: `https://mastergo.com/design/:fileId?layer_id=:layerId`
  - `:fileId` 是文件 ID
  - `:layerId` 是要实现的图层或组件 ID
- 项目应有已建立的设计系统或组件库（推荐）

## 必需工作流程

**按顺序执行以下步骤，不要跳过。**

### 步骤 1: 解析 URL

当用户提供 MasterGo URL 时，提取 fileId 和 layerId 作为 MCP 工具的参数。

**URL 格式:** `https://mastergo.com/design/:fileId?layer_id=:layerId`

**提取:**
- **File ID:** `:fileId`（`/design/` 后面的部分）
- **Layer ID:** `:layerId`（`layer_id` 查询参数的值）

**示例:**
- URL: `https://mastergo.com/design/kL9xQn2VwM8pYrTb4ZcHjF?layer_id=42-15`
- File ID: `kL9xQn2VwM8pYrTb4ZcHjF`
- Layer ID: `42-15`

### 步骤 2: 获取设计上下文

使用提取的 fileId 和 layerId 调用 `mcp__getDsl`。

```
mcp__getDsl(fileId="kL9xQn2VwM8pYrTb4ZcHjF", layerId="42-15")
```

这将提供结构化数据，包括:
- 布局属性（Auto Layout、约束、尺寸）
- 排版规格
- 颜色值和设计 token
- 组件结构和变体
- 间距和内边距值

**如果响应过大或被截断:**
1. 先调用 `mcp__getMeta` 获取高级节点映射
2. 从元数据中识别所需的特定子节点
3. 使用特定子节点 ID 单独获取 DSL 数据

### 步骤 3: 获取截图参考（可选但推荐）

使用相同的 fileId 和 layerId 获取视觉参考截图。

可以使用 4.5v-mcp 的图像分析工具:
```
mcp__4_5v_mcp__analyze_image(imageSource="设计稿截图URL", prompt="详细描述布局结构、颜色样式、主要组件和交互元素")
```

### 步骤 4: 下载所需资源

从 MasterGo MCP 返回的数据中下载任何资源（图片、图标、SVG）。

**重要:** 遵循资源规则:
- 如果返回了资源 URL，直接使用该源
- 不要导入或添加新的图标包 - 所有资源应来自 MasterGo 数据
- 当提供资源源时，不要使用或创建占位符

### 步骤 5: 转换为项目约定

将 MasterGo 输出转换为当前项目的框架、样式和约定。

**关键原则:**
- 将 MasterGo MCP 输出视为设计和行为的表示，而非最终代码风格
- 用项目首选的实用程序或设计系统 token 替换默认样式
- 重用现有组件（按钮、输入框、排版、图标包装器）而非复制功能
- 一致使用项目的颜色系统、排版比例和间距 token
- 尊重现有的路由、状态管理和数据获取模式

### 步骤 6: 实现 1:1 视觉还原

努力实现与 MasterGo 设计像素级完美的视觉还原。

**指南:**
- 优先考虑 MasterGo 保真度以精确匹配设计
- 避免硬编码值 - 尽可能使用 MasterGo 中的设计 token
- 当设计系统 token 与 MasterGo 规范冲突时，优先使用设计系统 token 但最小化调整间距/尺寸以匹配视觉效果
- 遵循 WCAG 可访问性要求
- 根据需要添加组件文档

### 步骤 7: 验证设计

在标记完成之前，对照 MasterGo 设计验证最终 UI。

**验证清单:**
- [ ] 布局匹配（间距、对齐、尺寸）
- [ ] 排版匹配（字体、大小、粗细、行高）
- [ ] 颜色完全匹配
- [ ] 交互状态按设计工作（悬停、活动、禁用）
- [ ] 响应式行为遵循 MasterGo 约束
- [ ] 资源正确渲染
- [ ] 满足可访问性标准

## 实现规则

### 组件组织

- 将 UI 组件放在项目指定的设计系统目录中
- 遵循项目的组件命名约定
- 避免内联样式，除非对动态值真正必要

### 设计系统集成

- **始终**尽可能使用项目设计系统的组件
- 将 MasterGo 设计 token 映射到项目设计 token
- 当存在匹配组件时，扩展它而非创建新组件
- 记录添加到设计系统的任何新组件

### 代码质量

- 避免硬编码值 - 提取为常量或设计 token
- 保持组件可组合和可重用
- 为组件 props 添加 TypeScript 类型
- 为导出的组件包含 JSDoc 注释

## 示例

### 示例 1: 实现按钮组件

用户说: "实现这个 MasterGo 按钮组件: https://mastergo.com/design/kL9xQn2VwM8pYrTb4ZcHjF?layer_id=42-15"

**操作:**

1. 解析 URL 提取 fileId=`kL9xQn2VwM8pYrTb4ZcHjF` 和 layerId=`42-15`
2. 运行 `mcp__getDsl(fileId="kL9xQn2VwM8pYrTb4ZcHjF", layerId="42-15")`
3. 如有需要获取视觉参考
4. 从资源端点下载任何按钮图标
5. 检查项目是否有现有按钮组件
6. 如果有，用新变体扩展它；如果没有，使用项目约定创建新组件
7. 将 MasterGo 颜色映射到项目设计 token（如 `primary-500`、`primary-hover`）
8. 对照截图验证内边距、边框半径、排版

**结果:** 匹配 MasterGo 设计的按钮组件，集成到项目设计系统中。

### 示例 2: 构建仪表板布局

用户说: "构建这个仪表板: https://mastergo.com/design/pR8mNv5KqXzGwY2JtCfL4D?layer_id=10-5"

**操作:**

1. 解析 URL 提取 fileId 和 layerId
2. 运行 `mcp__getMeta` 了解页面结构
3. 从元数据中识别主要部分（页眉、侧边栏、内容区域、卡片）及其子节点 ID
4. 对每个主要部分运行 `mcp__getDsl` 获取详细信息
5. 下载所有资源（徽标、图标、图表）
6. 使用项目的布局基元构建布局
7. 尽可能使用现有组件实现每个部分
8. 对照 MasterGo 约束验证响应式行为

**结果:** 具有响应式布局的完整仪表板，匹配 MasterGo 设计。

## 最佳实践

### 始终从上下文开始

永远不要基于假设实现。始终先获取 `mcp__getDsl`。

### 增量验证

在实现过程中频繁验证，而不仅仅在最后。这可以及早发现问题。

### 记录偏差

如果必须偏离 MasterGo 设计（如可访问性或技术约束），在代码注释中记录原因。

### 重用胜于重新创建

在创建新组件之前始终检查现有组件。代码库的一致性比精确的 MasterGo 复制更重要。

### 设计系统优先

如有疑问，优先考虑项目设计系统模式而非字面 MasterGo 翻译。

## 常见问题和解决方案

### 问题: MasterGo 输出被截断

**原因:** 设计太复杂或有太多嵌套层级无法在单个响应中返回。
**解决方案:** 使用 `mcp__getMeta` 获取节点结构，然后使用 `mcp__getDsl` 单独获取特定节点。

### 问题: 实现后设计不匹配

**原因:** 实现代码与原始 MasterGo 设计之间的视觉差异。
**解决方案:** 与步骤 3 的截图进行并排比较。检查设计上下文数据中的间距、颜色和排版值。

### 问题: 资源未加载

**原因:** 资源 URL 无法访问或被修改。
**解决方案:** 验证 MasterGo MCP 服务器的资源端点是否可访问。

### 问题: 设计 token 值与 MasterGo 不同

**原因:** 项目设计系统 token 与 MasterGo 设计中指定的值不同。
**解决方案:** 当项目 token 与 MasterGo 值不同时，优先使用项目 token 以保持一致性，但调整间距/尺寸以保持视觉保真度。

## 其他资源

- [MasterGo 官方文档](https://mastergo.com/help/)
- [MasterGo MCP 服务器](https://github.com/mastergo/magic-mcp)
