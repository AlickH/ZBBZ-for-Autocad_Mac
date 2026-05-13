(setq *zbbz-plugin-root*
  "/Users/alick/Documents/Codex/2026-05-13/users-alick-downloads-zbbz-vlx-windows/plugin/")

(defun zbbz-plugin-path (name)
  (strcat *zbbz-plugin-root* name))

(defun zbbz-debug-log-path ()
  (zbbz-plugin-path "zbbz-debug.log"))

(defun zbbz-debug-log (message / file_handle)
  (setq file_handle (open (zbbz-debug-log-path) "a"))
  (if file_handle
    (progn
      (write-line message file_handle)
      (close file_handle)
      T)
    nil))

(defun zbbz-debug-clear ()
  (setq file_handle (open (zbbz-debug-log-path) "w"))
  (if file_handle
    (close file_handle))
  (zbbz-debug-log "=== ZBBZ DEBUG START ==="))

(defun zbbz-load-module (name / path)
  (setq path (zbbz-plugin-path name))
  (if (findfile path)
    (progn
      (prompt (strcat "\nLoading module: " path))
      (load path))
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
  (zbbz-debug-clear)
  (zbbz-debug-log "COMMAND ZBBZ")
  (zbbz-state-ensure)
  (prompt "\nZBBZ command started.")
  (zbbz-annotate-run-loop)
  (princ))

(defun c:ZBBZCONFIG ()
  (zbbz-load-all)
  (zbbz-debug-clear)
  (zbbz-debug-log "COMMAND ZBBZCONFIG")
  (zbbz-state-ensure)
  (prompt "\nZBBZCONFIG command started.")
  (if (zbbz-dialog-open-loop)
    (progn
      (prompt "\nZBBZ configuration saved."))
    (prompt "\nZBBZ configuration canceled."))
  (princ))

(princ)
