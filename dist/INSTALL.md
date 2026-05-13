# ZBBZ AutoCAD for Mac Install

## Recommended Bundle Install

Copy the whole folder:

```text
ZBBZ.bundle
```

to:

```text
~/Library/Application Support/Autodesk/ApplicationAddins
```

or:

```text
/Applications/Autodesk/ApplicationAddins
```

Then restart AutoCAD. Run:

```text
ZBBZ
ZBBZCONFIG
```

Do not use APPLOAD to select `ZBBZ.bundle` directly. On AutoCAD for Mac that can treat the bundle folder as a runtime extension and report `doesn't define function acrxEntryPoint`.

## Manual APPLOAD With Loader

If you want to load it manually with APPLOAD, copy both items to the same folder:

```text
ZBBZ.bundle
ZBBZ-APPLOAD.lsp
```

Then use APPLOAD to select:

```text
ZBBZ-APPLOAD.lsp
```

You can also select this file inside the bundle:

```text
ZBBZ.bundle/Contents/zbbz-mac.lsp
```
