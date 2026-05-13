(defun zbbz-path-with-trailing-slash (path)
  (if (= (substr path (strlen path) 1) "/")
    path
    (strcat path "/")))

(defun zbbz-resolve-plugin-root (/ loader_path)
  (setq loader_path (findfile "zbbz-mac.lsp"))
  (if loader_path
    (zbbz-path-with-trailing-slash (vl-filename-directory loader_path))
    "/Users/alick/Documents/Codex/2026-05-13/users-alick-downloads-zbbz-vlx-windows/plugin/"))

(setq *zbbz-plugin-root* (zbbz-resolve-plugin-root))

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
  (zbbz-state-ensure)
  (zbbz-annotate-run-loop)
  (princ))

(defun c:ZBBZCONFIG ()
  (zbbz-load-all)
  (zbbz-state-ensure)
  (if (zbbz-dialog-open-loop)
    (progn
      (prompt "\nZBBZ configuration saved."))
    (prompt "\nZBBZ configuration canceled."))
  (princ))

(princ)
