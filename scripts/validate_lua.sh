#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LUAC_BIN="${LUAC_BIN:-}"
LUA_BIN="${LUA_BIN:-}"

if [[ -z "$LUAC_BIN" ]]; then
  if command -v luac5.3 >/dev/null 2>&1; then
    LUAC_BIN="luac5.3"
  elif command -v luac >/dev/null 2>&1; then
    LUAC_BIN="luac"
  else
    echo "Unable to find luac. Install lua5.3 or set LUAC_BIN." >&2
    exit 1
  fi
fi

if [[ -z "$LUA_BIN" ]]; then
  if command -v lua5.3 >/dev/null 2>&1; then
    LUA_BIN="lua5.3"
  elif command -v lua >/dev/null 2>&1; then
    LUA_BIN="lua"
  else
    echo "Unable to find lua. Install lua5.3 or set LUA_BIN." >&2
    exit 1
  fi
fi

"$LUAC_BIN" -p \
  "$ROOT/src/index.lua" \
  "$ROOT"/src/translations/*.lua \
  "$ROOT"/src/addons/*.lua

"$LUA_BIN" -e '
local required_keys = {
  "Use_Emu4Vita_colon",
  "Test_Emu4Vita_launch",
  "Missing_Emu4Vita_core",
}

for i = 1, #arg do
  local path = arg[i]
  local ok, table_or_error = pcall(dofile, path)
  if not ok then
    error(path .. ": " .. tostring(table_or_error))
  end
  if type(table_or_error) ~= "table" then
    error(path .. " did not return a table")
  end
  for _, key in ipairs(required_keys) do
    if table_or_error[key] == nil then
      error(path .. " is missing required key " .. key)
    end
  end
end

print("validated translation files: " .. tostring(#arg))
' "$ROOT"/src/translations/*.lua

echo "Lua validation passed."
