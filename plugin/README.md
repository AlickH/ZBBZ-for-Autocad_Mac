# ZBBZ for AutoCAD for Mac

Mac-native rebuild of the evidenced coordinate annotation feature set from the Windows `ZBBZ.VLX` plugin.

## Scope

- Target: AutoCAD for Mac current versions
- Stack: AutoLISP + DCL
- Main command: `ZBBZ`

## Current Files

- `plugin/zbbz-mac.lsp`
  - top-level load entry and command registration
- `plugin/zbbz-state.lsp`
  - settings state defaults and validation helpers
- `plugin/zbbz-format.lsp`
  - coordinate text formatting helpers

## Non-Goals

- No direct Windows `VLX` compatibility
- No claimed compatibility with the original Windows DAT file format
- No guessed Windows-only behavior

## Loading

1. Load `plugin/zbbz-mac.lsp` in AutoCAD for Mac.
2. Run `ZBBZ`.

## Status

Current status is project skeleton only. Dialog, annotation workflow, coordinate transforms, grid drawing, and DAT export are not implemented yet.
