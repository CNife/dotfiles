---
name: summarize-to-personal
description: 将当前会话的工作内容总结到 Obsidian「个人」库的今天日记中。注意：公司/工作相关的开发、部署、运维、正式会议请使用 summarize-work-log 命令；个人方向的技术探索、学习心得、生活记录请使用本命令。
---

# 个人日记总结

将本次会话的内容总结并追加到今天的 Obsidian 个人日记中。

## 步骤

### 1. 收集上下文

执行以下 Python 脚本，获取今日日记路径和近期日记：

```python
python3 -c "
import os
from datetime import datetime, timedelta
BASE = '/mnt/c/Obsidian/个人'
DIARY_BASE = BASE + '/个人日记'

now = datetime.now()
weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']
month_dir = f'{DIARY_BASE}/{now.year}/{now.month:02d}'
diary_file = f'{month_dir}/{now.year} 年 {now.month} 月 {now.day} 日 {weekdays[now.weekday()]}.md'
print(f'DIARY_FILE={diary_file}')
print(f'MONTH_DIR={month_dir}')

cutoff = now - timedelta(days=10)
diaries = []
for root, _, files in os.walk(DIARY_BASE):
    for f in files:
        if f.endswith('.md') and not f.endswith('模板.md'):
            p = os.path.join(root, f)
            if datetime.fromtimestamp(os.path.getmtime(p)) >= cutoff:
                diaries.append(p)
print('--- RECENT_DIARIES ---')
for p in sorted(diaries, reverse=True): print(p)
"
```

读取 `--- RECENT_DIARIES ---` 列出的日记文件（选最近 2-3 篇即可），了解：
- 最近在关注的个人话题（学习、投资、生活）
- 写作风格：个人日记比工作日志更轻松，有个人观点和情绪，这是刻意保持的特色
- 避免重复记录已有内容

### 2. 准备日记文件

- 若 `DIARY_FILE` 已存在 → 读取现有内容
- 若不存在 → 创建目录并复制模板：
  ```bash
  mkdir -p "$MONTH_DIR" && cp "/mnt/c/Obsidian/个人/个人日记/日记模板.md" "$DIARY_FILE"
  ```

### 3. 总结并写入

个人日记是你未来会回看的记录。比工作日志更轻松，可以保留个人观点和感受。

**格式：**
- `# 主题标题` → 按主题分组（如 `# Textual 框架学习`、`# WSL2 浏览器配置`）
- 每个主题 1-2 行，同一件事合并为一行
- 技术类：关键决策和结论，不需要实现细节
- 学习类：学到了什么、下一步
- 生活类：操作、观点、趣事

⚠️ **禁止写入的 AI 工作流噪音：**
- AGENTS.md 规则沉淀（"添加了 XX 规则到 AGENTS.md"）
- 开发阶段标记（Wave、骨架创建、模块创建）
- 验证流程（"N 轮最终验证 APPROVE"）
- 提交/推送操作
- 配置文件路径、代码片段——这些在代码库里能找到

✅ **只写：做了什么 + 关键决策/结论 + 个人感受（可选）**

**区分工作与个人**：
- 公司项目开发、部署、运维、正式会议 → `summarize-work-log`
- 个人技术探索、学习笔记、投资复盘、生活记录 → 本命令
- 混合内容 → 只记录个人部分，末尾提示用户是否也需要工作日志

**写入操作**：
- 在文件末尾空一行后追加
- 不要修改已有内容

### 4. 确认

输出追加内容的简要摘要。如果本次没有实质性内容，询问用户是否仍要写入。
