(defun zbbz-dat-escape-field (value / text)
  (setq text (vl-princ-to-string value))
  (vl-string-subst "\"\"" "\"" text))

(defun zbbz-dat-record-line (record)
  (strcat
    (itoa (cdr (assoc 'id record))) ","
    (zbbz-dat-escape-field (car (cdr (assoc 'point_world record)))) ","
    (zbbz-dat-escape-field (cadr (cdr (assoc 'point_world record)))) ","
    (zbbz-dat-escape-field (cdr (assoc 'point_output_1 record))) ","
    (zbbz-dat-escape-field (cdr (assoc 'point_output_2 record))) ","
    (zbbz-dat-escape-field (cdr (assoc 'prefix_mode record))) ","
    (zbbz-dat-escape-field (cdr (assoc 'rotation record))) ","
    (zbbz-dat-escape-field (cdr (assoc 'dim_scale record))) ","
    (zbbz-dat-escape-field (cdr (assoc 'text_height record))) ","
    (zbbz-dat-escape-field (cdr (assoc 'layer record))) ","
    (zbbz-dat-escape-field (strcat (cdr (assoc 'text_line_1 record)) " | " (cdr (assoc 'text_line_2 record))))))

(defun zbbz-dat-write-file (path records / file_handle)
  (setq file_handle (open path "w"))
  (if file_handle
    (progn
      (write-line "id,point_x,point_y,out_1,out_2,prefix_mode,rotation,scale,text_height,layer,text" file_handle)
      (foreach record records
        (write-line (zbbz-dat-record-line record) file_handle))
      (close file_handle)
      T)
    nil))

(defun zbbz-dat-export-session (/ path)
  (if *zbbz-created-annotations*
    (progn
      (setq path (getfiled "Save DAT File" "zbbz-mac.dat" "dat" 1))
      (if path
        (zbbz-dat-write-file path *zbbz-created-annotations*)
        nil))
    (progn
      (alert "No annotation records are available for DAT export.")
      nil)))
