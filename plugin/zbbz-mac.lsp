(defun zbbz-load-module (path)
  (if (findfile path)
    (load path)
    (prompt (strcat "\nMissing module: " path))))

(defun zbbz-load-all nil
  (zbbz-load-module "plugin/zbbz-state.lsp")
  (zbbz-load-module "plugin/zbbz-format.lsp"))

(defun c:ZBBZ nil
  (zbbz-load-all)
  (prompt "\nZBBZ for AutoCAD for Mac loaded. Dialog and drawing workflow are not implemented yet.")
  (princ))

(zbbz-load-all)
(princ)
