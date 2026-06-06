#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${OUT_DIR:-"$ROOT/out"}"
STAGE_DIR="${STAGE_DIR:-"$ROOT/build/vpk_stage"}"
VPK_NAME="${VPK_NAME:-RetroFlow_emu4vita.vpk}"

mkdir -p "$OUT_DIR"
rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"

rsync -a \
  --exclude '.git/' \
  --exclude '.github/' \
  --exclude 'build/' \
  --exclude 'out/' \
  --exclude 'scripts/' \
  --exclude '*.DS_Store' \
  "$ROOT/" "$STAGE_DIR/"

rm -f "$OUT_DIR/$VPK_NAME"
(cd "$STAGE_DIR" && zip -qr "$OUT_DIR/$VPK_NAME" . -x '*.DS_Store')

echo "Built:"
echo "  $OUT_DIR/$VPK_NAME"
