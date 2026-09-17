#!/usr/bin/env bash
# ============================================================
# GlibClaw — Offline Bundle Preparation Script
# Run on a PC with Node.js + npm + curl installed (Git Bash OK).
# Downloads Node.js arm64 tarball and packs the openclaw npm
# package (with all dependencies) into the module directory.
#
# Usage:  ./prepare-offline.sh [node_version]
# Default: v22.19.0
#
# After running, zip the module directory and flash via
# Magisk/KSU — customize.sh will auto-detect the bundled
# assets and install fully offline.
# ============================================================
set -euo pipefail

NODE_VERSION="${1:-v22.19.0}"
MIRROR="${MIRROR:-https://npmmirror.com/mirrors/node}"
REGISTRY="${REGISTRY:-https://registry.npmmirror.com}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================"
echo " GlibClaw Offline Bundle Preparation"
echo "============================================"
echo " Node.js version : ${NODE_VERSION}"
echo " Node mirror     : ${MIRROR}"
echo " npm registry    : ${REGISTRY}"
echo " Output directory: ${SCRIPT_DIR}"
echo ""

# ── 1. Download Node.js arm64 tarball ────────────────
echo "[1/3] Downloading Node.js ${NODE_VERSION} (linux-arm64)..."
NODE_URL="${MIRROR}/${NODE_VERSION}/node-${NODE_VERSION}-linux-arm64.tar.gz"
echo "      URL: ${NODE_URL}"
curl -fL --retry 3 --retry-delay 2 "$NODE_URL" \
  -o "${SCRIPT_DIR}/node.tar.gz"
NODE_SIZE=$(stat -c%s "${SCRIPT_DIR}/node.tar.gz" 2>/dev/null || \
  stat -f%z "${SCRIPT_DIR}/node.tar.gz" 2>/dev/null || echo "?")
echo "      -> node.tar.gz (${NODE_SIZE} bytes)"
echo ""

# ── 2. Pack openclaw + all dependencies ──────────────
echo "[2/3] Installing openclaw via npm (with all dependencies)..."
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

cd "$WORK_DIR"
npm install openclaw \
  --omit=optional \
  --ignore-scripts \
  --registry="${REGISTRY}" \
  --no-audit \
  --no-fund \
  --fetch-timeout=180000 \
  --fetch-retries=5

echo "      Packing node_modules/ into tarball..."
tar czf "${SCRIPT_DIR}/openclaw-modules.tar.gz" node_modules/
OC_SIZE=$(stat -c%s "${SCRIPT_DIR}/openclaw-modules.tar.gz" 2>/dev/null || \
  stat -f%z "${SCRIPT_DIR}/openclaw-modules.tar.gz" 2>/dev/null || echo "?")
echo "      -> openclaw-modules.tar.gz (${OC_SIZE} bytes)"
echo ""

# ── 3. Verify ────────────────────────────────────────
echo "[3/3] Verifying bundle..."
if [ -f "${SCRIPT_DIR}/node.tar.gz" ] && [ -f "${SCRIPT_DIR}/openclaw-modules.tar.gz" ]; then
  echo ""
  echo "============================================"
  echo " Done! Offline bundle ready."
  echo "============================================"
  echo ""
  echo " Files created:"
  echo "   - ${SCRIPT_DIR}/node.tar.gz"
  echo "   - ${SCRIPT_DIR}/openclaw-modules.tar.gz"
  echo ""
  echo " Next steps:"
  echo "   1. Zip the module directory (must contain"
  echo "      customize.sh + these two tarballs)"
  echo "   2. Flash the zip via Magisk / KernelSU"
  echo "   3. customize.sh will auto-detect the bundle"
  echo "      and install fully offline"
  echo ""
else
  echo "ERROR: Bundle files missing!" >&2
  exit 1
fi
