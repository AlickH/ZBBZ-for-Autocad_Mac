# ZBBZ AutoCAD for Mac Install

Copy the whole `ZBBZ.bundle` folder to one of these folders:

```text
~/Library/Application Support/Autodesk/ApplicationAddins
/Applications/Autodesk/ApplicationAddins
```

Restart AutoCAD, then run `ZBBZ` or `ZBBZCONFIG`.

Do not select `ZBBZ.bundle` itself in APPLOAD. For manual APPLOAD, select the separate `ZBBZ-APPLOAD.lsp` loader placed next to `ZBBZ.bundle`, or select:

```text
ZBBZ.bundle/Contents/zbbz-mac.lsp
```
