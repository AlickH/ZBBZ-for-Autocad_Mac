(setq *zbbz-created-annotations* nil)
(setq *zbbz-annotation-seq* 0)

(defun zbbz-annotate-reset-session ()
  (setq *zbbz-created-annotations* nil)
  (setq *zbbz-annotation-seq* 0)
)

(defun zbbz-annotate-next-id ()
  (setq *zbbz-annotation-seq* (+ *zbbz-annotation-seq* 1))
  *zbbz-annotation-seq*
)

(defun zbbz-annotate-current-settings ()
  (zbbz-state-ensure)
)

(defun zbbz-annotate-layer-name ()
  (setq layer_name (zbbz-state-get 'dim_layer))
  (if (= layer_name "")
    (getvar "CLAYER")
    layer_name
  )
)

(defun zbbz-annotate-text-style-name ()
  (setq style_name (zbbz-state-get 'text_style))
  (if (= style_name "")
    (getvar "TEXTSTYLE")
    style_name
  )
)

(defun zbbz-annotate-text-height ()
  (* (zbbz-state-get 'text_height) (zbbz-state-get 'dim_scale))
)

(defun zbbz-annotate-gap ()
  (* (zbbz-annotate-text-height) 1.4)
)

(defun zbbz-annotate-point-output (point)
  (setq resolved (zbbz-transform-point-by-mode point (zbbz-annotate-current-settings)))
  (list (car resolved) (cadr resolved))
)

(defun zbbz-annotate-text-lines (point_output)
  (zbbz-format-output-lines
    (car point_output)
    (cadr point_output)
    (zbbz-state-get 'prefix_mode)
    (zbbz-state-get 'swap_xy)
    (zbbz-state-get 'precision)
  )
)

(defun zbbz-annotate-horizontal-direction (anchor_point text_point)
  (if (>= (car text_point) (car anchor_point))
    1.0
    -1.0
  )
)

(defun zbbz-annotate-text-anchor-point (anchor_point text_point)
  (setq dir (zbbz-annotate-horizontal-direction anchor_point text_point))
  (setq gap (zbbz-annotate-gap))
  (list
    (+ (car text_point) (* dir gap))
    (cadr text_point)
    0.0
  )
)

(defun zbbz-annotate-elbow-point (anchor_point text_anchor)
  (setq dir (zbbz-annotate-horizontal-direction anchor_point text_anchor))
  (setq gap (zbbz-annotate-gap))
  (list
    (- (car text_anchor) (* dir gap 0.8))
    (cadr text_anchor)
    0.0
  )
)

(defun zbbz-annotate-horizontal-end-point (anchor_point text_anchor)
  (setq dir (zbbz-annotate-horizontal-direction anchor_point text_anchor))
  (setq gap (zbbz-annotate-gap))
  (list
    (+ (car text_anchor) (* dir gap 3.6))
    (cadr text_anchor)
    0.0
  )
)

(defun zbbz-annotate-upper-text-point (text_anchor)
  (setq gap (zbbz-annotate-gap))
  (list
    (car text_anchor)
    (+ (cadr text_anchor) (* gap 0.55))
    0.0
  )
)

(defun zbbz-annotate-lower-text-point (text_anchor)
  (setq gap (zbbz-annotate-gap))
  (list
    (car text_anchor)
    (- (cadr text_anchor) (* gap 0.55))
    0.0
  )
)

(defun zbbz-annotate-horizontal-mode (anchor_point text_anchor)
  (if (>= (car text_anchor) (car anchor_point))
    0
    2
  )
)

(defun zbbz-annotate-ensure-layer (layer_name)
  (if (not (tblsearch "LAYER" layer_name))
    (entmakex
      (list
        (cons 0 "LAYER")
        (cons 100 "AcDbSymbolTableRecord")
        (cons 100 "AcDbLayerTableRecord")
        (cons 2 layer_name)
        (cons 70 0)
      )
    )
  )
  layer_name
)

(defun zbbz-annotate-make-line (start_point end_point layer_name)
  (entmakex
    (list
      (cons 0 "LINE")
      (cons 8 layer_name)
      (cons 10 start_point)
      (cons 11 end_point)
    )
  )
)

(defun zbbz-annotate-make-text (insert_point text_value layer_name text_style text_height horizontal_mode)
  (entmakex
    (list
      (cons 0 "TEXT")
      (cons 8 layer_name)
      (cons 7 text_style)
      (cons 10 insert_point)
      (cons 11 insert_point)
      (cons 40 text_height)
      (cons 1 text_value)
      (cons 50 0.0)
      (cons 72 horizontal_mode)
      (cons 73 2)
    )
  )
)

(defun zbbz-annotate-make-marker (anchor_point layer_name)
  (setq marker_size (* (zbbz-annotate-gap) 0.45))
  (setq p1 anchor_point)
  (setq p2 (list (- (car anchor_point) marker_size) (- (cadr anchor_point) marker_size) 0.0))
  (setq p3 (list (+ (car anchor_point) marker_size) (- (cadr anchor_point) marker_size) 0.0))
  (entmakex
    (list
      (cons 0 "SOLID")
      (cons 8 layer_name)
      (cons 10 p1)
      (cons 11 p2)
      (cons 12 p3)
      (cons 13 p3)
    )
  )
)

(defun zbbz-annotate-group-record (record_id entities)
  (if (zbbz-state-get 'group_on')
    (list
      (cons 'group_name (strcat "ZBBZ-" (itoa record_id)))
      (cons 'entities entities)
    )
    nil
  )
)

(defun zbbz-annotate-filter-entities (entities)
  (setq result nil)
  (foreach entity entities
    (if entity
      (setq result (append result (list entity)))
    )
  )
  result
)

(defun zbbz-annotate-store-record (record)
  (setq *zbbz-created-annotations* (append *zbbz-created-annotations* (list record)))
  record
)

(defun zbbz-annotate-create (anchor_point text_point)
  (setq layer_name (zbbz-annotate-ensure-layer (zbbz-annotate-layer-name)))
  (setq text_style (zbbz-annotate-text-style-name))
  (setq point_output (zbbz-annotate-point-output anchor_point))
  (setq text_lines (zbbz-annotate-text-lines point_output))
  (setq record_id (zbbz-annotate-next-id))
  (setq text_anchor (zbbz-annotate-text-anchor-point anchor_point text_point))
  (setq elbow_point (zbbz-annotate-elbow-point anchor_point text_anchor))
  (setq line_end_point (zbbz-annotate-horizontal-end-point anchor_point text_anchor))
  (setq upper_text_point (zbbz-annotate-upper-text-point text_anchor))
  (setq lower_text_point (zbbz-annotate-lower-text-point text_anchor))
  (setq text_height (zbbz-annotate-text-height))
  (setq horizontal_mode (zbbz-annotate-horizontal-mode anchor_point text_anchor))
  (setq marker_entity (zbbz-annotate-make-marker anchor_point layer_name))
  (setq leader_entity_1 (zbbz-annotate-make-line anchor_point elbow_point layer_name))
  (setq leader_entity_2 (zbbz-annotate-make-line elbow_point line_end_point layer_name))
  (setq upper_text_entity
    (zbbz-annotate-make-text
      upper_text_point
      (car text_lines)
      layer_name
      text_style
      text_height
      horizontal_mode
    )
  )
  (setq lower_text_entity
    (zbbz-annotate-make-text
      lower_text_point
      (cadr text_lines)
      layer_name
      text_style
      text_height
      horizontal_mode
    )
  )
  (setq entity_ids
    (zbbz-annotate-filter-entities
      (list
        marker_entity
        leader_entity_1
        leader_entity_2
        upper_text_entity
        lower_text_entity
      )
    )
  )
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
      (cons 'rotation 0.0)
      (cons 'dim_scale (zbbz-state-get 'dim_scale))
      (cons 'text_height (zbbz-state-get 'text_height))
      (cons 'layer layer_name)
      (cons 'entities entity_ids)
      (cons 'group group_record)
    )
  )
)

(defun zbbz-annotate-prompt-text-point (anchor_point)
  (getpoint anchor_point "\nPick annotation text location: ")
)

(defun zbbz-annotate-run-once ()
  (setq anchor_point (getpoint "\nPick coordinate point: "))
  (if anchor_point
    (progn
      (setq text_point (zbbz-annotate-prompt-text-point anchor_point))
      (if text_point
        (zbbz-annotate-create anchor_point text_point)
        nil
      )
    )
    nil
  )
)

(defun zbbz-annotate-run-loop ()
  (while (zbbz-annotate-run-once)
    (princ)
  )
  (princ)
)
