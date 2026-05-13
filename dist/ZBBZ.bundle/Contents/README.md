# ZBBZ for AutoCAD for Mac

Mac-native rebuild of the evidenced coordinate annotation feature set from the Windows `ZBBZ.VLX` plugin.

## Scope

- Target: AutoCAD for Mac current versions
- Stack: AutoLISP + DCL
- Main commands:
  - `ZBBZ` starts coordinate annotation using the current saved configuration
  - `ZBBZCONFIG` opens the settings dialog and saves configuration changes

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
- `plugin/zbbz-pick.lsp`
  - bearing pick and two-point calibration prompts
- `plugin/zbbz-grid.lsp`
  - standard orthogonal coordinate grid drawing
- `plugin/zbbz-dat.lsp`
  - DAT export for current annotation session
- `plugin/zbbz-help.lsp`
  - built-in help text
- `plugin/zbbz-annotate.lsp`
  - point selection, text assembly, leader creation, and annotation session records

## Non-Goals

- No direct Windows `VLX` compatibility
- No claimed compatibility with the original Windows DAT file format
- No guessed Windows-only behavior

## Loading

1. Load `plugin/zbbz-mac.lsp` in AutoCAD for Mac.
2. Run `ZBBZ` to annotate directly, or `ZBBZCONFIG` to edit settings.

## Status

Current status includes project skeleton, settings state, output formatting, base coordinate transform math, the main settings dialog shell, the first annotation workflow, bearing pick, two-point calibration prompts, standard grid drawing, DAT export, and built-in help.
