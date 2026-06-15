# vscode-codex-sidebar-fix

> 基于 [xytss/codex-sidebar-fix](https://github.com/xytss/codex-sidebar-fix) — 新增 macOS / Linux 支持

[中文](#中文) | [English](#english)

---

## 中文

### 这是什么？

OpenAI Codex 扩展在 VS Code、Trae 等 IDE 中，左侧活动栏的图标经常会消失，导致无法正常在 IDE 内使用 Codex 插件。每次扩展更新后都会复发。

本工具一键修复该问题。

### 支持的 IDE

VS Code · VS Code Insiders · Trae · Trae CN · Cursor · Windsurf

### 使用方法

#### Windows

1. 关闭 IDE
2. 将 `fix_codex_sidebar.ps1` 和 `双击修复Codex侧边栏.bat` 放在同一个文件夹
3. 双击 `双击修复Codex侧边栏.bat`
4. 看到 `[OK]` 后重新打开 IDE

#### macOS

1. 关闭 IDE
2. 双击 `双击修复Codex侧边栏.command`
3. 看到 `[OK]` 后重新打开 IDE

> 或者终端运行：`bash fix_codex_sidebar.sh`

#### Linux

```bash
bash fix_codex_sidebar.sh
```

Codex 更新后重新运行一次即可。

### 注意事项

- 运行前会自动备份原文件，可放心使用
- Windows：依赖 PowerShell
- macOS / Linux：依赖 perl（系统自带，无需安装）

---

## English

### What is this?

The OpenAI Codex extension's left sidebar icon frequently disappears in VS Code, Trae, and other IDEs. This happens again after every extension update.

Based on [xytss/codex-sidebar-fix](https://github.com/xytss/codex-sidebar-fix) — added macOS / Linux support

This tool fixes the issue with one click.

### Supported IDEs

VS Code · VS Code Insiders · Trae · Trae CN · Cursor · Windsurf

### Usage

#### Windows

1. Close your IDE
2. Place `fix_codex_sidebar.ps1` and `双击修复Codex侧边栏.bat` in the same folder
3. Double-click `双击修复Codex侧边栏.bat`
4. Reopen your IDE after seeing the `[OK]` message

#### macOS

1. Close your IDE
2. Double-click `双击修复Codex侧边栏.command`
3. Reopen your IDE after seeing the `[OK]` message

> Or run in Terminal: `bash fix_codex_sidebar.sh`

#### Linux

```bash
bash fix_codex_sidebar.sh
```

Re-run after each Codex extension update.

### Notes

- Original files are automatically backed up before modification
- Windows: requires PowerShell
- macOS / Linux: requires perl (pre-installed on all systems)

---

## License

MIT
