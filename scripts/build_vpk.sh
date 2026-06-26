#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${OUT_DIR:-"$ROOT/out"}"
STAGE_DIR="${STAGE_DIR:-"$ROOT/build/vpk_stage"}"
VPK_NAME="${VPK_NAME:-RetroFlow_emu4vita.vpk}"
BASE_VPK_URL="${BASE_VPK_URL:-"https://github.com/jimbob4000/RetroFlow-Launcher/releases/download/v8.1.1/RetroFlow_v8.1.1.vpk"}"
BASE_VPK="${BASE_VPK:-"$ROOT/build/RetroFlow_base.vpk"}"

mkdir -p "$OUT_DIR"
rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"
mkdir -p "$(dirname "$BASE_VPK")"

if [[ ! -f "$BASE_VPK" ]]; then
  curl -L --fail --retry 3 --output "$BASE_VPK" "$BASE_VPK_URL"
fi

unzip -q "$BASE_VPK" -d "$STAGE_DIR"

install -m 0644 "$ROOT/src/index.lua" "$STAGE_DIR/index.lua"

rm -rf "$STAGE_DIR/translations" "$STAGE_DIR/addons"
rsync -a "$ROOT/src/translations/" "$STAGE_DIR/translations/"
rsync -a "$ROOT/src/addons/" "$STAGE_DIR/addons/"

for required_path in \
  "$STAGE_DIR/eboot.bin" \
  "$STAGE_DIR/sce_sys/param.sfo" \
  "$STAGE_DIR/index.lua" \
  "$STAGE_DIR/translations/EN.lua" \
  "$STAGE_DIR/addons/threads.lua"
do
  if [[ ! -f "$required_path" ]]; then
    echo "Missing required VPK file: $required_path" >&2
    exit 1
  fi
done

rm -f "$OUT_DIR/$VPK_NAME"
(cd "$STAGE_DIR" && zip -qr "$OUT_DIR/$VPK_NAME" . -x '*.DS_Store')

echo "Built:"
echo "  $OUT_DIR/$VPK_NAME"
