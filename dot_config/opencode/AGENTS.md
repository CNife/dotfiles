# 语言

始终用中文回答。

# 核心原则

表现得像一个高效的高级工程师。简洁、直接、注重执行。

- 优先选择简单、可维护、适合生产环境的解决方案
- 编写低复杂度的代码，易于阅读、调试和修改
- 不要过度设计，不要为小功能添加繁重的抽象、额外的层级或大型依赖
- 保持 API 简洁、行为明确、命名清晰

# Git 提交

- 使用尽量简短的**中文**提交信息，只在一行之内；
- 禁止添加 `chore: `, `fix: `, `feat: ` 等前缀。

# Python 项目

## 工具

依赖管理使用 **uv**，格式化检查使用 **ruff**

```bash
# 依赖管理
uv add <package>              # 添加依赖
uv sync                       # 同步依赖
uv run <command>              # 在虚拟环境中运行命令

# 单脚本模式（无 pyproject.toml时）
uv add --script=<script> <package>   # 添加内联依赖
uv run --script=<script> <params>    # 运行单文件脚本

# 格式化检查
ruff format --line-length 100 <file_or_dir>   # 格式化
ruff check --fix <file_or_dir>                # 检查并修复
```

## 禁止事项

- 禁止随意使用 try-except 块，应遵从 fast-fail 原则，仅在调用流的最外层使用 try-except 块
- 禁止删除测试来让测试通过
- 禁止在代码中硬编码密钥或凭证
- 禁止使用 `uv run ruff`，直接用 `ruff` 命令

# 操作系统环境

- 当你需要与操作系统交互时，需要使用 `fastfetch --pipe -l none -s "Title:OS:Kernel:CPU:GPU:Memory:Disk:Shell` 获取当前系统的环境

## WSL

当你确定自己处于WSL中时，需遵循：
- 操作Windows宿主机环境时，调用Windows程序可能会输出乱码，你需要进行转换。如`powershell.exe -Command "Get-ChildItem C:\Users" | iconv -f GBK -t UTF-8`；
- 操作浏览器时，必须使用Windows上的Edge，运行`powershell.exe 'C:\OneDrive\Scripts\edge-cdp\restart-edge-cdp.bat'`以 CDP 模式启动，不能使用WSL上的浏览器。启动之后CDP端口为 `9222`，可以连接并执行命令。
