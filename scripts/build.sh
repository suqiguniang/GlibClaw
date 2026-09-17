#!/usr/bin/env bash
# ============================================================
# GlibClaw — Local Build Script
# Builds two flashable zips: proxy version + offline version.
#
# Usage:  ./scripts/build.sh
# Requires: zip, curl, Node.js + npm (for offline version)
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$REPO_DIR/dist"

VERSION=$(grep '^version=' "$REPO_DIR/module.prop" | cut -d= -f2)
echo "============================================"
echo " Building GlibClaw v${VERSION}"
echo "============================================"

mkdir -p "$DIST_DIR"
cd "$REPO_DIR"

# ── Proxy version (国内代理加速版) ──
echo ""
echo "[1/2] Building proxy version..."
zip -r "$DIST_DIR/GlibClaw-v${VERSION}-proxy.zip" . \
  -x ".git/*" ".github/*" ".gitignore" ".zcode/*" \
     "node.tar.gz" "openclaw-modules.tar.gz" "openclaw-modules.tar.gz.new" \
     "scripts/*" "prepare-offline.sh" "dist/*" "*.tmp" "*.log"
echo "  -> GlibClaw-v${VERSION}-proxy.zip"

# ── Offline version (内嵌离线版) ──
echo ""
echo "[2/2] Building offline version..."
bash "$REPO_DIR/prepare-offline.sh"
zip -r "$DIST_DIR/GlibClaw-v${VERSION}-offline.zip" . \
  -x ".git/*" ".github/*" ".gitignore" ".zcode/*" \
     "openclaw-modules.tar.gz.new" \
     "scripts/*" "prepare-offline.sh" "dist/*" "*.tmp" "*.log"
echo "  -> GlibClaw-v${VERSION}-offline.zip"

echo ""
echo "============================================"
echo " Done! Output in dist/"
echo "============================================"
ls -lh "$DIST_DIR/"
