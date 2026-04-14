---
name: summarize-work-log
description: 将当前会话的工作内容总结到今天的 Obsidian 工作日志中。当会话中有实质性工作（代码开发、方案设计、运维部署、会议讨论等）时使用。如果是纯闲聊或探索性对话，不需要使用此命令。
---

# 工作日志总结

将本次会话的工作内容总结并追加到今天的 Obsidian 工作日志文件中。

## 步骤

### 1. 收集上下文

执行以下 Python 脚本，获取日志路径、近期日志列表和最近修改的文档：

```python
python3 -c "
import os
from datetime import datetime, timedelta
BASE = '/mnt/c/Obsidian/工作'
LOG_BASE = BASE + '/工作日志'

now = datetime.now()
weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']
log_file = f'{LOG_BASE}/{now.year}/{now.month:02d}/{now.year} 年 {now.month} 月 {now.day} 日 {weekdays[now.weekday()]}.md'
print(f'LOG_FILE={log_file}')

# 最近 10 天日志文件列表
meta = {'AGENTS.md', '任务.md', '日记.md'}
cutoff = now - timedelta(days=10)
logs = []
for root, _, files in os.walk(LOG_BASE):
    for f in files:
        if f.endswith('.md') and f not in meta:
            p = os.path.join(root, f)
            if datetime.fromtimestamp(os.path.getmtime(p)) >= cutoff:
                logs.append(p)
print('--- RECENT_LOGS ---')
for p in sorted(logs, reverse=True): print(p)

# 最近 5 个文档（排除工作日志）+ 修改时间
docs = []
for root, _, files in os.walk(BASE):
    if '工作日志' in root: continue
    for f in files:
        if f.endswith('.md'):
            p = os.path.join(root, f)
            docs.append((os.path.getmtime(p), p))
print('--- RECENT_DOCS ---')
for mt, p in sorted(docs, key=lambda x: -x[0])[:5]:
    print(f'{datetime.fromtimestamp(mt).strftime(\"%m-%d %H:%M\")} {p}')
"
```

**为什么读取近期日志**：
- 了解你正在做的项目，正确归类新工作到对应子系统
- 学习你的写作风格（简洁、只写结果）
- 若新工作延续了近期日志中的待办，标注完成

请读取 `--- RECENT_LOGS ---` 列出的日志文件，理解当前项目进展。

脚本输出说明：
- `LOG_FILE`：今天日志的完整路径
- `--- RECENT_LOGS ---` 下方：最近 10 天的日志文件路径（按修改时间倒序）
- `--- RECENT_DOCS ---` 下方：最近修改的 5 个文档 + 修改时间（MM-DD HH:MM）

### 2. 确定日志文件状态

- 若 `LOG_FILE` 已存在 → 读取现有内容，准备追加
- 若不存在 → 复制模板：
  ```bash
  cp "/mnt/c/Obsidian/工作/工作日志/日记.md" "$LOG_FILE"
  ```

### 3. 总结并写入

**格式规则：**
- `# 子系统名` → 一级标题，粒度到具体子系统（如 `# OneReason MCP` 而非 `# OneReason`）
- `## 具体任务` → 二级标题，按独立交付物拆分（两个功能 = 两条，框架搭建 ≠ 工具实现）
- 每个交付物 1-2 行

**任务状态（Emoji）：**
- ✅ 已完成 | 🔄 进行中 | 🐛 Bug修复 | 🔍 调研 | 🚀 已部署 | 🤝 会议/协作

**内容规则：**

⚠️ **禁止写入的 AI 工作流噪音：**
- 验证流程（"N 轮最终验证 APPROVE"、"XX 个测试用例全部通过"）
- 提交/推送操作（"已提交并推送到 XX 分支"）
- AI agent 产物（"沉淀 N 条规则到 AGENTS.md"）
- 开发阶段标记（Wave 1/2/3、"骨架创建"、"模块创建"）

✅ **只写：做了什么 + 核心特性 + 关键结果**

✅ **保留有价值的信息：人名、技术选型判断、关键数据（镜像大小、性能指标）**

✅ **合并同类：同一类配置项合并为一行（如多个 pre-commit 钩子归为一行）**

✅ 参考近期日志风格：简洁、只写结果

**示例：**

好的写法：
- `✅ execute_cypher：只读查询 + 权限管控 + 结果序列化，经真实数据库验证`
- `✅ 单阶段 Dockerfile（256MB），MCP 端点响应符合预期`
- `✅ 确认 taplo-pre-commit 为 tamasfe/taplo 官方镜像仓库，非 fork`

应避免的写法：
- `❌ 完成 Wave 2-4：权限管控、序列化、工具实现`
- `❌ 4 轮最终验证全部 APPROVE，18 个测试用例全部通过`
- `❌ 创建 .dockerignore：排除 .git/.venv/__pycache__/.env/tests 等 12 项`
- `❌ 已提交并推送到 dev 分支`
- `❌ 沉淀 5 条项目规则到 AGENTS.md`

**写入操作：**
- 在日志末尾空一行后追加，不得修改已有内容

### 4. 确认

写入后输出追加的内容摘要。

## 约束

- 无实质性工作 → 询问是否仍要写入
- 保持风格一致：简洁、结构化、以子系统为维度
