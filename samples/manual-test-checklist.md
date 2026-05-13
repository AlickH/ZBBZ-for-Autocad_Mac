# ZBBZ for AutoCAD for Mac Manual Test Checklist

## State

- [ ] Loading `plugin/zbbz-state.lsp` initializes the default settings state.
- [ ] Default `coord_mode` is `current`.
- [ ] Default `prefix_mode` is `xy`.
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
