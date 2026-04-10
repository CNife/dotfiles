---
name: summarize-work-log
description: 将当前会话的工作内容总结到今天的 Obsidian 工作日志中。当会话中有实质性工作（代码开发、方案设计、运维部署、会议讨论等）时使用。如果是纯闲聊或探索性对话，不需要使用此命令。
---

# 工作日志总结

将本次会话的工作内容总结并追加到今天的 Obsidian 工作日志文件中。

## 步骤

### 1. 收集上下文

执行以下 Python 脚本，一次性获取日志路径、近期日志列表和最近修改的文档：

```python
python3 -c "
import os
from datetime import datetime, timedelta

BASE = '/mnt/c/Obsidian/工作/工作日志'

# === 今天日志路径 ===
now = datetime.now()
weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']
log_dir = f'{BASE}/{now.year}/{now.month:02d}'
log_file = f'{log_dir}/{now.year} 年 {now.month} 月 {now.day} 日 {weekdays[now.weekday()]}.md'
print(f'LOG_FILE={log_file}')
print(f'LOG_DIR={log_dir}')

# === 最近 3 天日志内容（作为风格参考） ===
meta_files = {'AGENTS.md', '任务.md', '日记.md'}
cutoff = now - timedelta(days=3)
recent_logs = []
for root, dirs, files in os.walk(BASE):
    for f in files:
        if f.endswith('.md') and f not in meta_files:
            path = os.path.join(root, f)
            mtime = datetime.fromtimestamp(os.path.getmtime(path))
            if mtime >= cutoff:
                recent_logs.append((mtime, path))

print('--- STYLE_REFERENCE ---')
for _, p in sorted(recent_logs, reverse=True)[:3]:
    print(f'FILE: {p}')
    with open(p, 'r') as f:
        lines = f.readlines()
        content_start = 0
        for i, line in enumerate(lines):
            if line.startswith('#') and '待办' not in line:
                content_start = i
                break
        for line in lines[content_start:content_start+30]:
            print(line.rstrip())
    print('---')

# === 最近修改的 Obsidian 文档（排除工作日志） ===
work_base = '/mnt/c/Obsidian/工作'
all_docs = []
for root, dirs, files in os.walk(work_base):
    if '工作日志' in root.split(os.sep):
        continue
    for f in files:
        if f.endswith('.md'):
            path = os.path.join(root, f)
            all_docs.append((os.path.getmtime(path), path))
print('--- RECENT_DOCS ---')
for _, p in sorted(all_docs, key=lambda x: -x[0])[:10]:
    print(p)
"
```

脚本输出说明：
- `LOG_FILE` / `LOG_DIR`：今天日志的完整路径和所在目录。
- `--- STYLE_REFERENCE ---` 下方：最近 3 天的日志内容片段（跳过待办事项块），用于学习你的写作风格。
- `--- RECENT_DOCS ---` 下方：最近修改的 10 个非日志文档，按修改时间倒序。

### 2. 确定日志文件状态

- 若 `LOG_FILE` 已存在 → 读取现有内容，准备追加。
- 若不存在 → 确保目录存在并复制模板：
  ```bash
  mkdir -p "$LOG_DIR"
  cp "/mnt/c/Obsidian/工作/工作日志/日记.md" "$LOG_FILE"
  ```
  `日记.md` 是标准模板，包含 `# 待办事项` 和 tasks 查询块，复制后在此基础上追加即可。

### 3. 总结并写入

**格式规则（必须遵守）：**
- `# 项目名` → 一级标题，用于分组（如 `# Genos Reg Server`）
- `## 标题` → 二级标题，分隔具体工作项（如 `## Cookie 认证修复`）
- `✅` 已完成 / `🔄` 进行中 / `- [ ]` 待办 → 任务状态标记
- 每个工作项**不超过 2 行**

**内容规则（硬约束）：**
- ⚠️ **禁止写入**：排查过程、调试细节、中间步骤、技术实现细节
- ✅ **只写三要素**：问题是什么 + 做了什么 + 结果如何
- ✅ **每个工作项不超过 2 行**，超过则拆分为多个独立项
- ✅ 合并同类项，同一项目下的相关工作归为一组

**正面示例（参考风格，不模仿内容）：**
参考 `--- STYLE_REFERENCE ---` 输出的最近日志内容。
你的日志风格是：简洁、只写结果、无过程细节。

**写入操作：**
- 在日志文件末尾空一行后，追加总结内容。
- 不得删除或修改文件中已有的任何内容。

### 4. 确认

写入完成后，输出你追加的内容摘要，让我确认。

## 约束

- 如果本次会话没有实质性工作，告知我并询问是否仍要写入。
- 保持与你现有工作日志一致的写作风格：简洁、结构化、以项目为维度。
