Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

# 语言

始终用中文回答。

# Python 规范

依赖管理使用 **uv**，格式化检查使用 **ruff**。
单脚本模式（无 `pyproject.toml` 时）：
- 使用 `uv add --script=<script> <package>` 添加内联依赖
- 使用 `uv run --script=<script> <params>` 运行单文件脚本


# Git 提交

使用尽量简短的**中文**提交信息，只在一行之内。禁止添加 `chore:`, `fix:`, `feat:` 等前缀。

# 系统环境

使用 `fastfetch --pipe -l none -s "Title:OS:Kernel:CPU:GPU:Memory:Disk:Shell"` 确认系统环境

## WSL

当你确定自己处于 WSL 中时，需遵循：
- 操作 Windows 宿主机环境时，调用 Windows 程序如果输出乱码，需要转换编码：如`powershell.exe -Command "Get-ChildItem C:\" | iconv -f GBK -t UTF-8`；只有在确认程序输出是乱码时才需要转换编码，否则不要转换。
- 操作浏览器时，必须使用 Windows 上的浏览器。**请提醒用户手动开启 Edge 的 CDP 调试端口**，启动后 CDP 端口为 `9222`，可以连接并执行命令。
