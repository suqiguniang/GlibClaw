# GlibClaw

一个 Magisk/KernelSU 模块，通过内置 glibc 运行时在 Android（aarch64）上安装 [OpenClaw](https://openclaw.ai)。

[English](README.en.md)

## v1.0.3 更新内容

- **国内镜像加速** — Node.js 下载和 npm registry 切换至 npmmirror（阿里巴巴）镜像，DoH 上游切换至阿里 DNS，解决国内下载失败问题
- **内嵌离线安装** — 运行 `prepare-offline.sh` 预下载所有资源，刷机时完全离线安装，无需联网
- **Action 按钮启动网关** — 在 Magisk/KSU 中点击 Action 一键启动 OpenClaw 并打开控制面板

## 截图

<table>
  <tr>
    <td width="50%">
      <img src="images/1.jpg" alt="OpenClaw 终端">
      <p align="center"><b>终端界面</b></p>
    </td>
    <td width="50%">
      <img src="images/2.jpg" alt="OpenClaw 控制面板">
      <p align="center"><b>控制面板</b></p>
    </td>
  </tr>
</table>

## 环境要求

- 已 root 的 Android 设备（Magisk 或 KernelSU）
- 架构：**仅支持 aarch64**
- 刷机时需要网络连接（内嵌离线版除外）

## 安装

1. 前往 [Releases](../../releases) 页面下载对应版本的 zip
2. 通过 Magisk / KernelSU 刷入
3. 重启

> 推送 `v*` 标签或手动触发 GitHub Actions 后，会自动构建两个版本的刷机包并发布到 Releases。

## 国内安装

国内用户有两个版本可选。`customize.sh` 会自动检测：如果模块内含 `node.tar.gz` 和 `openclaw-modules.tar.gz`，则进入离线模式；否则进入代理加速模式。

### 版本一：国内代理加速版

直接打包模块目录为 zip 刷入即可。安装时自动从国内镜像下载 Node.js 和 OpenClaw：

| 资源 | 镜像 |
|------|------|
| Node.js 下载 | `npmmirror.com/mirrors/node` |
| Node.js 版本索引 | `npmmirror.com/mirrors/node/index.json` |
| npm registry | `registry.npmmirror.com` |
| DoH 上游 | `dns.alidns.com`（阿里 DNS，223.5.5.5） |

可通过环境变量覆盖：`NODE_BASE_URL`、`NODE_VERSION`、`DOH_UPSTREAM`。

### 版本二：内嵌离线版

在 PC 上（需 Node.js + npm + curl，Git Bash 可运行）预下载所有资源：

```sh
./prepare-offline.sh              # 默认 Node.js v22.19.0
./prepare-offline.sh v22.19.0     # 指定版本
```

脚本生成 `node.tar.gz` 和 `openclaw-modules.tar.gz`，放入模块目录后打包为 zip 刷入。安装时完全离线，无需联网。

## 初始化

重启后，打开 root 终端（推荐 [Termux](https://github.com/termux/termux-app/releases/download/v0.119.0-beta.3/termux-app_v0.119.0-beta.3+apt-android-7-github-debug_arm64-v8a.apk)），执行：

### 配置 OpenClaw

```sh
su -c /data/adb/openclaw/bin/openclaw configure
```

### 查看状态

```sh
su -c /data/adb/openclaw/bin/openclaw status
```

### 查看日志

```sh
su -c tail -f /data/adb/openclaw/openclaw.log
```

## 目录结构

安装后，OpenClaw 位于：

```
/data/adb/openclaw/
├── bin/openclaw          # 主包装脚本
├── glibc-node/           # 内置 Node.js 运行时
├── lib/node_modules/     # OpenClaw 包
└── home/.openclaw/       # 用户配置与工作区
```

## 使用 Action 按钮

如果 OpenClaw 停止运行（例如崩溃后），在 Magisk 或 KernelSU 管理器中点击 **Action**：
1. 检查网关是否存活 — 若未运行则启动
2. 在浏览器中打开控制面板

## 卸载

通过 Magisk/KernelSU 应用移除模块。用户数据（`/data/adb/openclaw/home`）会被保留。

## 许可证

MIT © TDat
