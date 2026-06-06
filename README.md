# RetroFlow Launcher

Unofficial fork of [jimbob4000/RetroFlow-Launcher](https://github.com/jimbob4000/RetroFlow-Launcher) for Emu4Vita++ integration on PS Vita.

Original project and primary credit remain with `jimbob4000`. This fork only adds the launcher-side changes needed to route supported retro launches through Emu4Vita++ instead of the previous default path.

## What changed in this fork

- launches supported retro systems through Emu4Vita++
- adds a user-facing Emu4Vita++ core mapping screen under `Other Settings`
- saves platform-to-core mappings in `ux0:/data/RetroFlow/emu4vita_core_map.lua`
- adds safer URI/path encoding for ROM launch handoff
- adds missing-core validation and clearer launch failure messaging
- adds a test-launch action for Emu4Vita++ from game options
- adds a GitHub Actions workflow that builds `RetroFlow_emu4vita.vpk`

## Build output

This fork publishes:

- `RetroFlow_emu4vita.vpk`

The VPK is intended to be paired with the matching Emu4Vita++ fork build.

## Upstream

- upstream repo: https://github.com/jimbob4000/RetroFlow-Launcher
- upstream license: MIT

See the upstream project for the original feature set, screenshots, and full setup documentation.
