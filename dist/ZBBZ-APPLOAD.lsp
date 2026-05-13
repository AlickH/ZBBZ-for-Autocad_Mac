(defun zbbz-appload-trailing-slash (path)
  (if (= (substr path (strlen path) 1) "/")
    path
    (strcat path "/")))

(defun zbbz-appload-run (/ loader_path base_path bundle_loader)
  (setq loader_path (findfile "ZBBZ-APPLOAD.lsp"))
  (if loader_path
    (progn
      (setq base_path (zbbz-appload-trailing-slash (vl-filename-directory loader_path)))
      (setq bundle_loader (strcat base_path "ZBBZ.bundle/Contents/zbbz-mac.lsp"))
      (if (findfile bundle_loader)
        (load bundle_loader)
        (prompt (strcat "\nMissing ZBBZ bundle loader: " bundle_loader))))
    (prompt "\nMissing ZBBZ-APPLOAD.lsp.")))

(zbbz-appload-run)
(princ)
