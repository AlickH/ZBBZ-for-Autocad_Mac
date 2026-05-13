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
- [ ] Running `ZBBZ` prints the current scaffold status message.

## Transform

- [ ] Current mode returns the picked point unchanged.
- [ ] World mode resolves the point through `trans`.
- [ ] Custom mode applies base N/E and rotation to the point.
- [ ] Custom mode applies `coord_scale` before rotation and base offset.
- [ ] Two-point calibration returns `rotation`, `calc_scale`, `real_scale`, `coord_scale`, `distance_diff`, `base_n`, and `base_e`.
