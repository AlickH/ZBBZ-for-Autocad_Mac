(defun zbbz-load-module (path)
  (if (findfile path)
    (load path)
    (prompt (strcat "\nMissing module: " path))))

(defun zbbz-load-all nil
  (zbbz-load-module "plugin/zbbz-state.lsp")
  (zbbz-load-module "plugin/zbbz-format.lsp")
  (zbbz-load-module "plugin/zbbz-transform.lsp")
  (zbbz-load-module "plugin/zbbz-dialog.lsp"))

(defun c:ZBBZ nil
  (zbbz-load-all)
  (if (zbbz-dialog-open)
    (prompt "\nZBBZ settings saved. Drawing workflow is not implemented yet.")
    (prompt "\nZBBZ dialog canceled."))
  (princ))

(zbbz-load-all)
(princ)
