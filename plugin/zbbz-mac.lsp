(setq *zbbz-plugin-root*
  "/Users/alick/Documents/Codex/2026-05-13/users-alick-downloads-zbbz-vlx-windows/plugin/")

(defun zbbz-plugin-path (name)
  (strcat *zbbz-plugin-root* name))

(defun zbbz-load-module (name / path)
  (setq path (zbbz-plugin-path name))
  (if (findfile path)
    (load path)
    (prompt (strcat "\nMissing module: " path))))

(defun zbbz-load-all ()
  (zbbz-load-module "zbbz-state.lsp")
  (zbbz-load-module "zbbz-format.lsp")
  (zbbz-load-module "zbbz-transform.lsp")
  (zbbz-load-module "zbbz-pick.lsp")
  (zbbz-load-module "zbbz-grid.lsp")
  (zbbz-load-module "zbbz-dat.lsp")
  (zbbz-load-module "zbbz-help.lsp")
  (zbbz-load-module "zbbz-dialog.lsp")
  (zbbz-load-module "zbbz-annotate.lsp"))

(defun c:ZBBZ ()
  (zbbz-load-all)
  (prompt "\nZBBZ command started.")
  (if (zbbz-dialog-open-loop)
    (progn
      (prompt "\nZBBZ dialog opened successfully.")
      (zbbz-annotate-run-loop))
    (prompt "\nZBBZ dialog canceled."))
  (princ))

(zbbz-load-all)
(princ)
