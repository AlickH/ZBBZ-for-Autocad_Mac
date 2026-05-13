# ZBBZ for AutoCAD for Mac Manual Test Checklist

## State

- [ ] Loading `plugin/zbbz-state.lsp` initializes the default settings state.
- [ ] Default `coord_mode` is `current`.
- [ ] Default `prefix_mode` is `xy`.
- [ ] Default `coord_scale` is `1.0`.
- [ ] Applying base point and angle switches the mode to `custom`.

## Formatting

- [ ] `xy` output formats as `X=...` and `Y=...`.
- [ ] `ab` output formats as `A=...` and `B=...`.
- [ ] `ne` output formats as `N=...` and `E=...`.
- [ ] `none` output formats as bare values.
- [ ] `swap_xy` swaps both value order and labels.

## Load

- [ ] Loading `plugin/zbbz-mac.lsp` succeeds without missing module errors.
- [ ] Running `ZBBZ` opens the settings dialog.

## Transform

- [ ] Current mode returns the picked point unchanged.
- [ ] World mode resolves the point through `trans`.
- [ ] Custom mode applies base N/E and rotation to the point.
- [ ] Custom mode applies `coord_scale` before rotation and base offset.
- [ ] Two-point calibration returns `rotation`, `calc_scale`, `real_scale`, `coord_scale`, `distance_diff`, `base_n`, and `base_e`.

## Dialog

- [ ] The `SetDimZB` dialog opens from `ZBBZ`.
- [ ] Default settings populate the dialog fields.
- [ ] Switching coordinate mode enables custom inputs only in custom mode.
- [ ] Prefix radio changes update the preview text.
- [ ] Applying base point and angle switches the mode to custom.
- [ ] `Known Two-Point Pick` shows the current unimplemented message.
- [ ] `Known Two-Point Pick` closes the dialog, runs pick/input prompts, and reopens with updated custom values.
- [ ] `Draw Coordinate Grid` closes the dialog, runs corner/spacing prompts, and draws grid lines.
- [ ] `Pick` beside bearing closes the dialog, runs point prompts, and reopens with updated bearing.
- [ ] `Generate DAT File` writes the Mac DAT schema for the current session.

## Grid

- [ ] Grid drawing works for current/world modes.
- [ ] Grid drawing works for custom mode using current settings.
- [ ] Grid spacing follows entered X and Y spacing.

## DAT

- [ ] DAT export writes the schema header.
- [ ] DAT export writes one row per created annotation.
- [ ] DAT export includes point coordinates, output coordinates, scale, layer, and text.

## Help

- [ ] Help opens from the dialog.
- [ ] Help explains coordinate modes, calibration, behavior flags, and DAT export.

## Annotation

- [ ] Confirming the dialog starts point selection.
- [ ] Picking one point and one text location creates a leader line.
- [ ] Picking one point and one text location creates MTEXT with two coordinate lines.
- [ ] `swap_xy` changes both line order and labels in created text.
- [ ] `auto_orient` changes text rotation behavior.
- [ ] Multiple points can be annotated in one command until Enter exits.
