---
description: 从 .sisyphus/notepads 和 plans 提炼知识到 rules、AGENTS.md 和 docs
---

# 知识提炼：从 notepads 到长期知识库

## 任务

遍历 `.sisyphus/notepads/` 下已完成 plan 的笔记文件，逐条评估每条知识的重要性和用途，分拣到正确的目标位置。

## 筛选：只处理已完成的 plan

notepads 按 plan 隔离。只提炼已完成的 plan，跳过进行中的。

判断 plan 是否完成：
1. 读取 `.sisyphus/plans/{plan-name}.md`
2. 如果所有任务复选框都是 `- [x]` → 已完成，处理
3. 如果还有 `- [ ]` → 进行中，跳过
4. 如果 plan 文件不存在 → 跳过

## 知识来源优先级

| 来源 | 内容类型 | 处理策略 |
|------|---------|---------|
| `notepads/{plan}/learnings.md` | 模式、约定、成功经验 | 重点提炼 |
| `notepads/{plan}/decisions.md` | 架构决策 | 提炼到 docs/decisions/ 或 rules |
| `notepads/{plan}/issues.md` | 坑、绕过方案 | 通用坑 → rules，复杂排查 → docs |
| `notepads/{plan}/problems.md` | 未解决问题 | 跳过（留给下一个 plan） |
| `plans/{plan}.md` | 最终计划中的架构决策 | 补充提炼 |

## 目标位置与标准

### 1. `.sisyphus/rules/*.md` — Agent 长期行为规则

**适合放入的：** 影响未来所有 agent 会话的编码约定、项目决策、技术栈约束。

示例：
- "本项目用 Zod v4，schema 定义统一放在 src/config/schema/"
- "禁止 catch-all 文件（utils.ts、helpers.ts）"
- "测试风格：given/when/then，co-located *.test.ts"
- "API 响应统一用 { code, data, message } 格式"

**不适合放入的：** 一次性发现、具体 bug 的排查过程、临时环境配置、不确定的条目。

**文件格式：** 必须带 YAML frontmatter 指定匹配条件，rules-injector hook 依赖此格式：

```markdown
---
name: typescript-conventions
match: glob: **/*.ts
---

- 禁止 catch-all 文件（utils.ts、helpers.ts），按职责拆分为独立模块
- 所有类型定义放在 types.ts 中，与实现文件同级
- 使用 Zod v4 做运行时校验，schema 统一放在 src/config/schema/
```

**文件组织：** 按领域拆分，如 `typescript-conventions.md`、`api-patterns.md`、`testing-rules.md`。每条规则一条 bullet，精简到 agent 能在上下文中高效消费。

### 2. 各级 `AGENTS.md` — 目录级项目上下文

**适合放入的：** 帮助 agent 快速理解某个模块/目录的结构、职责、关键文件的描述性知识。

示例：
- "src/features/auth/ 负责认证，入口是 createAuthMiddleware()"
- "packages/cli/ 是 Commander.js CLI，子命令在 commands/ 下"
- "这个目录的测试需要 mock 外部 API，参考 test-setup.ts"

**放置规则：** 知识属于哪个目录的作用域，就放在哪个目录的 `AGENTS.md`。如果已有 `AGENTS.md`，将新知识补充到对应 section（WHERE TO LOOK / CONVENTIONS / ANTI-PATTERNS），不要重复已有内容。

**新建标准：** 参考 /init-deep 的评分标准，满足以下任一条件才创建新 AGENTS.md：
- 文件数 >20
- 子目录 >5
- 有独立模块边界（index.ts / __init__.py）
否则将知识写入最近的父目录 AGENTS.md。

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

1. **筛选已完成 plan**：遍历 `.sisyphus/plans/` 读取复选框状态，标记已完成和进行中的 plan
2. **读取对应 notepad 文件**：只读取已完成 plan 的 `.sisyphus/notepads/{plan}/` 下的 `.md` 文件
3. **按文件类型初步分拣**：
   - learnings.md → 候选 rules / AGENTS.md
   - decisions.md → 候选 docs/decisions/
   - issues.md → 候选 rules（通用坑）/ docs（复杂排查）
   - problems.md → 跳过
4. **逐条提取知识条目**：将每个文件的内容拆分为独立的、原子化的知识条目
5. **有效性验证**：对每条候选规则，检查当前代码是否仍然符合该规则（grep/ast-grep 验证）
6. **去重检查**：读取已有的 rules 文件和各级 AGENTS.md，跳过已存在的内容
7. **写入目标位置**：
   - rules 文件：带 frontmatter，追加到末尾或合并到合适的现有文件
   - AGENTS.md：补充到对应 section，保持原有格式，单次补充不超过 200 字
   - docs：使用项目已有文档风格
8. **输出提炼报告**：列出所有知识条目及其去向，简述理由

## 约束

- 不要修改 notepad 原文件（只读）
- rules 内容必须精简，每条规则一行，必须带 YAML frontmatter（name + match）
- AGENTS.md 补充内容嵌入现有结构，不要破坏格式，不要重复父目录内容
- 如果某条知识不确定分类，放入 docs/decisions/ 或丢弃，**不要放入 rules**
- 不创建空文件。如果一个目标位置没有匹配的知识，跳过
- 写入 rules 前必须验证：该规则在当前代码中仍然成立
