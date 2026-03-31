---
description: 从 .sisyphus/notepads 提炼知识到 rules、AGENTS.md 和 docs
---

# 知识提炼：从 notepads 到长期知识库

## 任务

遍历 `.sisyphus/notepads/` 下所有笔记文件，逐条评估每条知识的重要性和用途，分拣到正确的目标位置。

## 目标位置与标准

### 1. `.sisyphus/rules/*.md` — Agent 长期行为规则

**适合放入的：** 影响未来所有 agent 会话的编码约定、项目决策、技术栈约束。

示例：
- "本项目用 Zod v4，schema 定义统一放在 src/config/schema/"
- "禁止 catch-all 文件（utils.ts、helpers.ts）"
- "测试风格：given/when/then，co-located *.test.ts"
- "API 响应统一用 { code, data, message } 格式"

**不适合放入的：** 一次性发现、具体 bug 的排查过程、临时环境配置。

**文件组织：** 按领域拆分，如 `typescript-conventions.md`、`api-patterns.md`、`testing-rules.md`。每条规则一条 bullet，精简到 agent 能在上下文中高效消费。

### 2. 各级 `AGENTS.md` — 目录级项目上下文

**适合放入的：** 帮助 agent 快速理解某个模块/目录的结构、职责、关键文件的描述性知识。

示例：
- "src/features/auth/ 负责认证，入口是 createAuthMiddleware()"
- "packages/cli/ 是 Commander.js CLI，子命令在 commands/ 下"
- "这个目录的测试需要 mock 外部 API，参考 test-setup.ts"

**放置规则：** 知识属于哪个目录的作用域，就放在哪个目录的 `AGENTS.md`。如果已有 `AGENTS.md`，将新知识补充到合适的位置，不要重复已有内容。如果没有且值得创建，新建一个。

### 3. `docs/` — 人类文档

**适合放入的：** 面向团队成员的架构说明、决策记录、操作手册、排查指南。

示例：
- "OAuth 2.0 集成的完整流程说明"
- "生产环境部署检查清单"
- "为什么选择 X 方案而不是 Y 方案"

**不适合放入的：** 只有 agent 关心的实现细节、机器可读的规则。

**文件组织：** 遵循已有 docs/ 结构。如果没有明确分类，放进 `docs/decisions/`（决策记录）或 `docs/guides/`（操作指南）。

### 4. 不保留

**丢弃的：** 过时的发现（已被后续推翻）、特定 PR/分支的临时记录、与当前代码不符的描述。标注丢弃原因。

## 执行步骤

1. **读取所有 notepad 文件**：遍历 `.sisyphus/notepads/` 下所有 `.md` 文件
2. **逐条提取知识条目**：将每个文件的内容拆分为独立的、原子化的知识条目
3. **逐条分类**：对每条知识判断目标位置（rules / AGENTS.md / docs / 丢弃）
4. **去重检查**：读取已有的 rules 文件和各级 AGENTS.md，跳过已存在的内容
5. **写入目标位置**：
   - rules 文件追加到末尾或合并到合适的现有文件
   - AGENTS.md 补充到对应段落，保持原有格式
   - docs 使用项目已有文档风格
6. **输出提炼报告**：列出所有知识条目及其去向，简述理由

## 约束

- 不要修改 notepad 原文件（只读）
- rules 内容必须精简，每条规则一行，避免冗余叙述
- AGENTS.md 补充内容不超过 200 字，嵌入现有结构不要破坏格式
- 如果某条知识不确定分类，放入 rules 并标注待确认
- 不创建空文件。如果一个目标位置没有匹配的知识，跳过
