<div align="center">

# pis-dist

**pis 的官方分发仓库** · 源码仓库：[GitHub](https://github.com/brok1n/pis) · [Gitee](https://gitee.com/brok1n/pis)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://github.com/brok1n/pis/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-lightgrey?style=flat-square)](#安装)

</div>

---

## 这是什么

[pis](https://github.com/brok1n/pis) 是 pi coding agent 的会话恢复工具：任意目录一条命令，列出所有项目的 pi 历史会话，回车即恢复上下文。

本仓库只存放**安装脚本和发布产物**，源码在上方主仓库（私有）。

## 安装（Windows，一行命令）

打开 PowerShell，执行：

**Gitee（国内推荐）**：

```powershell
irm https://gitee.com/brok1n/pis-dist/raw/main/install.ps1 | iex
```

**GitHub**：

```powershell
irm https://raw.githubusercontent.com/brok1n/pis-dist/main/install.ps1 | iex
```

- 自动下载最新版并安装到 `%APPDATA%\npm`（pi 同目录，已在系统 PATH）
- 安装脚本自己写盘，不带 Windows 下载标记，**安装后自动更新畅通无阻**
- 脚本优先从 Gitee 下载（国内直连），失败自动切换 GitHub

## 手动下载

从 [Releases](https://gitee.com/brok1n/pis-dist/releases) 下载对应平台压缩包：

| 平台 | 文件 |
|---|---|
| Windows x64 | `pis-latest-x86_64-pc-windows-msvc.zip` |
| Linux x64 | `pis-latest-x86_64-unknown-linux-gnu.tar.gz` |

解压后把 `pis.exe` 放到 `%APPDATA%\npm\`（或任意 PATH 目录）。

> ⚠️ 浏览器下载的 zip 解压出的 exe 带 Windows 下载标记，可能导致自动更新失败。
> 解决：右键 exe → 属性 → 勾选「解除锁定」。**推荐用上面的一行命令安装，无此问题。**

## 使用

```bash
cd 你的pi项目目录
pis        # ↑/↓ 选会话，Enter 恢复上下文；M 迁移会话；Esc 退出
```

完整功能与文档见 [主仓库 README](https://gitee.com/brok1n/pis#readme)。

## License

[MIT](https://github.com/brok1n/pis/blob/main/LICENSE) © brok1n
