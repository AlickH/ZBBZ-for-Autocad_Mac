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
- `plugin/zbbz-transform.lsp`
  - coordinate mode transforms, custom coordinate scale, and two-point calibration math
- `plugin/zbbz.dcl`
  - main `SetDimZB` dialog definition
- `plugin/zbbz-dialog.lsp`
  - dialog tile population and action binding
- `plugin/zbbz-annotate.lsp`
  - point selection, text assembly, leader creation, and annotation session records

## Non-Goals

- No direct Windows `VLX` compatibility
- No claimed compatibility with the original Windows DAT file format
- No guessed Windows-only behavior

## Loading

1. Load `plugin/zbbz-mac.lsp` in AutoCAD for Mac.
2. Run `ZBBZ`.

## Status

Current status includes project skeleton, settings state, output formatting, base coordinate transform math, the main settings dialog shell, and the first annotation workflow. Grid drawing, DAT export, help, and interactive pick actions are not implemented yet.
