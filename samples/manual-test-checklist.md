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
- [ ] `Draw Coordinate Grid` shows the current unimplemented message.
- [ ] `Pick` beside bearing shows the current unimplemented message.
- [ ] `Generate DAT File` shows the current unimplemented message.
