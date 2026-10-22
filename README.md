# pis-dist

[pis](https://github.com/brok1n/pis) 的公开分发仓库（源码在私有仓库）。

## 安装（Windows，一行命令）

```powershell
irm https://raw.githubusercontent.com/brok1n/pis-dist/main/install.ps1 | iex
```

自动下载最新版并安装到 `%APPDATA%\npm`（pi 同目录，已在 PATH），安装后即可自动更新。

## 手动下载

| 平台 | 文件 |
|---|---|
| Windows x64 | pis-latest-x86_64-pc-windows-msvc.zip |
| Linux x64 | pis-latest-x86_64-unknown-linux-gnu.tar.gz |

从 [Releases](../../releases) 下载。zip 解压后若更新失败，右键 exe → 属性 → 勾选「解除锁定」。
