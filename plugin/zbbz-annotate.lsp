(setq *zbbz-created-annotations* nil)
(setq *zbbz-annotation-seq* 0)

(defun zbbz-annotate-reset-session nil
  (setq *zbbz-created-annotations* nil)
  (setq *zbbz-annotation-seq* 0))

(defun zbbz-annotate-next-id nil
  (setq *zbbz-annotation-seq* (+ *zbbz-annotation-seq* 1))
  *zbbz-annotation-seq*)

(defun zbbz-annotate-current-settings nil
  (zbbz-state-ensure))

(defun zbbz-annotate-layer-name (/ layer_name)
  (setq layer_name (zbbz-state-get 'dim_layer))
  (if (= layer_name "")
    (getvar "CLAYER")
    layer_name))

(defun zbbz-annotate-text-style-name (/ style_name)
  (setq style_name (zbbz-state-get 'text_style))
  (if (= style_name "")
    (getvar "TEXTSTYLE")
    style_name))

(defun zbbz-annotate-point-output (point / resolved)
  (setq resolved (zbbz-transform-point-by-mode point (zbbz-annotate-current-settings)))
  (if (= (length resolved) 2)
    resolved
    (list (car resolved) (cadr resolved))))

(defun zbbz-annotate-text-lines (point_output)
  (zbbz-format-output-lines
    (car point_output)
    (cadr point_output)
    (zbbz-state-get 'prefix_mode)
    (zbbz-state-get 'swap_xy)
    (zbbz-state-get 'precision)))

(defun zbbz-annotate-mtext-string (lines)
  (strcat (car lines) "\\P" (cadr lines)))

(defun zbbz-annotate-angle-between (from_point to_point)
  (angle from_point to_point))

(defun zbbz-annotate-readable-angle (from_point to_point / raw_angle)
  (setq raw_angle (zbbz-annotate-angle-between from_point to_point))
  (if (and (> raw_angle (/ pi 2.0)) (< raw_angle (* pi 1.5)))
    (+ raw_angle pi)
    raw_angle))

(defun zbbz-annotate-text-angle (anchor_point text_point)
  (if (zbbz-state-get 'auto_orient)
    (zbbz-annotate-readable-angle anchor_point text_point)
    (zbbz-annotate-angle-between anchor_point text_point)))

(defun zbbz-annotate-ensure-layer (layer_name)
  (if (not (tblsearch "LAYER" layer_name))
    (entmakex
      (list
        (cons 0 "LAYER")
        (cons 100 "AcDbSymbolTableRecord")
        (cons 100 "AcDbLayerTableRecord")
        (cons 2 layer_name)
        (cons 70 0))))
  layer_name)

(defun zbbz-annotate-make-line (start_point end_point layer_name)
  (entmakex
    (list
      (cons 0 "LINE")
      (cons 8 layer_name)
      (cons 10 start_point)
      (cons 11 end_point))))

(defun zbbz-annotate-make-mtext (insert_point text_value layer_name text_style text_height rotation)
  (entmakex
    (list
      (cons 0 "MTEXT")
      (cons 8 layer_name)
      (cons 7 text_style)
      (cons 10 insert_point)
      (cons 40 text_height)
      (cons 41 (* text_height 12.0))
      (cons 50 rotation)
      (cons 1 text_value))))

(defun zbbz-annotate-group-record (record_id entities)
  (if (and (zbbz-state-get 'group_on') entities)
    (list
      (cons 'group_name (strcat "ZBBZ-" (itoa record_id)))
      (cons 'entities entities))
    nil))

(defun zbbz-annotate-store-record (record)
  (setq *zbbz-created-annotations* (append *zbbz-created-annotations* (list record)))
  record)

(defun zbbz-annotate-create (anchor_point text_point / layer_name text_style point_output text_lines mtext_value text_angle leader_entity text_entity record_id entity_ids group_record)
  (setq layer_name (zbbz-annotate-ensure-layer (zbbz-annotate-layer-name)))
  (setq text_style (zbbz-annotate-text-style-name))
  (setq point_output (zbbz-annotate-point-output anchor_point))
  (setq text_lines (zbbz-annotate-text-lines point_output))
  (setq mtext_value (zbbz-annotate-mtext-string text_lines))
  (setq text_angle (zbbz-annotate-text-angle anchor_point text_point))
  (setq record_id (zbbz-annotate-next-id))
  (setq leader_entity (zbbz-annotate-make-line anchor_point text_point layer_name))
  (setq text_entity
    (zbbz-annotate-make-mtext
      text_point
      mtext_value
      layer_name
      text_style
      (* (zbbz-state-get 'text_height) (zbbz-state-get 'dim_scale))
      text_angle))
  (setq entity_ids (vl-remove nil (list leader_entity text_entity)))
  (setq group_record (zbbz-annotate-group-record record_id entity_ids))
  (zbbz-annotate-store-record
    (list
      (cons 'id record_id)
      (cons 'point_world anchor_point)
      (cons 'point_output_1 (car point_output))
      (cons 'point_output_2 (cadr point_output))
      (cons 'prefix_mode (zbbz-state-get 'prefix_mode))
      (cons 'text_line_1 (car text_lines))
      (cons 'text_line_2 (cadr text_lines))
      (cons 'rotation text_angle)
      (cons 'dim_scale (zbbz-state-get 'dim_scale))
      (cons 'text_height (zbbz-state-get 'text_height))
      (cons 'layer layer_name)
      (cons 'entities entity_ids)
      (cons 'group group_record))))

(defun zbbz-annotate-prompt-text-point (anchor_point)
  (getpoint anchor_point "\nPick annotation text location: "))

(defun zbbz-annotate-run-once (/ anchor_point text_point)
  (setq anchor_point (getpoint "\nPick coordinate point: "))
  (if anchor_point
    (progn
      (setq text_point (zbbz-annotate-prompt-text-point anchor_point))
      (if text_point
        (zbbz-annotate-create anchor_point text_point)))))

(defun zbbz-annotate-run-loop nil
  (while (zbbz-annotate-run-once)
    (princ))
  (princ))
