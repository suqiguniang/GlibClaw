# GlibClaw

A Magisk/KernelSU module that installs [OpenClaw](https://openclaw.ai) on Android (aarch64) using a bundled glibc runtime.

[中文](README.md)

## What's New in v1.0.3

- **China mirror acceleration** — Node.js downloads and npm registry switched to npmmirror (Alibaba) mirrors, DoH upstream switched to Aliyun DNS, fixing download failures in China
- **Offline embedded installation** — Run `prepare-offline.sh` to pre-download all assets; flash fully offline without internet
- **Action button starts gateway** — Press Action in Magisk/KSU to start OpenClaw + open dashboard in one tap

## Screenshots

<table>
  <tr>
    <td width="50%">
      <img src="images/1.jpg" alt="OpenClaw Terminal">
      <p align="center"><b>Terminal Interface</b></p>
    </td>
    <td width="50%">
      <img src="images/2.jpg" alt="OpenClaw Dashboard">
      <p align="center"><b>Dashboard</b></p>
    </td>
  </tr>
</table>

## Requirements

- Android device with root access (Magisk or KernelSU)
- Architecture: **aarch64 only**
- Internet connection required during flash (except offline version)

## Installation

1. Go to [Releases](../../releases) and download the appropriate zip
2. Flash via Magisk / KernelSU
3. Reboot

> Pushing a `v*` tag or manually triggering GitHub Actions automatically builds both versions and publishes them to Releases.

## China Installation

Two versions are available for users in China. `customize.sh` auto-detects: if the module contains `node.tar.gz` and `openclaw-modules.tar.gz`, it enters offline mode; otherwise it enters proxy acceleration mode.

### Version 1: China Proxy Acceleration

Package the module directory as a zip and flash directly. Node.js and OpenClaw are downloaded from China mirrors during installation:

| Resource | Mirror |
|----------|--------|
| Node.js download | `npmmirror.com/mirrors/node` |
| Node.js version index | `npmmirror.com/mirrors/node/index.json` |
| npm registry | `registry.npmmirror.com` |
| DoH upstream | `dns.alidns.com` (Aliyun DNS, 223.5.5.5) |

Can be overridden via environment variables: `NODE_BASE_URL`, `NODE_VERSION`, `DOH_UPSTREAM`.

### Version 2: Offline Embedded

Pre-download all assets on a PC (requires Node.js + npm + curl; Git Bash works):

```sh
./prepare-offline.sh              # Default Node.js v22.19.0
./prepare-offline.sh v22.19.0     # Specify version
```

The script generates `node.tar.gz` and `openclaw-modules.tar.gz`. Place them in the module directory, package as a zip, and flash. Installation is fully offline — no internet required.

## Setup

After reboot, open a root terminal (via [Termux](https://github.com/termux/termux-app/releases/download/v0.119.0-beta.3/termux-app_v0.119.0-beta.3+apt-android-7-github-debug_arm64-v8a.apk)) and run:

### Configure OpenClaw

```sh
su -c /data/adb/openclaw/bin/openclaw configure
```

### Check Status

```sh
su -c /data/adb/openclaw/bin/openclaw status
```

### View Logs

```sh
su -c tail -f /data/adb/openclaw/openclaw.log
```

## Directory Layout

After install, OpenClaw lives at:

```
/data/adb/openclaw/
├── bin/openclaw          # main wrapper
├── glibc-node/           # bundled Node.js runtime
├── lib/node_modules/     # OpenClaw package
└── home/.openclaw/       # user config & workspace
```

## Using the Action Button

If OpenClaw stops running (e.g. after crash), tap **Action** in Magisk or KernelSU Manager:
1. It checks if the gateway is alive — starts it if not
2. Opens the dashboard in your browser

## Uninstall

Remove the module from Magisk/KernelSU app. User data at `/data/adb/openclaw/home` is preserved.

## License

MIT © TDat
