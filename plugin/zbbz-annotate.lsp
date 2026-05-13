(setq *zbbz-created-annotations* nil)
(setq *zbbz-annotation-seq* 0)

(defun zbbz-annotate-next-id ()
  (setq *zbbz-annotation-seq* (+ *zbbz-annotation-seq* 1))
)

(defun zbbz-annotate-layer-name ( / layer_name )
  (setq layer_name (zbbz-state-get 'dim_layer))
  (if (or (= layer_name "") (= layer_name "*CURRENT*"))
    (setq layer_name "ZBBZ_ANNOT")
  )
  layer_name
)

(defun zbbz-annotate-text-style-name ( / style_name )
  (setq style_name (zbbz-state-get 'text_style))
  (if (= style_name "")
    (setq style_name (getvar "TEXTSTYLE"))
  )
  style_name
)

(defun zbbz-annotate-text-height ()
  (* (zbbz-state-get 'text_height) (zbbz-state-get 'dim_scale))
)

(defun zbbz-annotate-gap ()
  (* (zbbz-annotate-text-height) 1.4)
)

(defun zbbz-annotate-arrow-size ()
  (* (zbbz-state-get 'arrow_size) (zbbz-state-get 'dim_scale))
)

(defun zbbz-annotate-point-output ( point / resolved )
  (setq resolved (zbbz-transform-point-by-mode point (zbbz-state-ensure)))
  (list (car resolved) (cadr resolved))
)

(defun zbbz-annotate-text-lines ( point_output )
  (zbbz-format-output-lines
    (car point_output)
    (cadr point_output)
    (zbbz-state-get 'prefix_mode)
    (zbbz-state-get 'swap_xy)
    (zbbz-state-get 'precision)
  )
)

(defun zbbz-annotate-horizontal-direction ( anchor_point text_point )
  (if (>= (car text_point) (car anchor_point))
    1.0
    -1.0
  )
)

(defun zbbz-annotate-text-anchor-point ( anchor_point text_point / dir gap )
  (setq dir (zbbz-annotate-horizontal-direction anchor_point text_point))
  (setq gap (zbbz-annotate-gap))
  (if (> dir 0.0)
    (list (+ (car text_point) gap) (cadr text_point) 0.0)
    (list (- (car text_point) gap) (cadr text_point) 0.0)
  )
)

(defun zbbz-annotate-elbow-point ( anchor_point text_anchor / dir gap )
  (setq dir (zbbz-annotate-horizontal-direction anchor_point text_anchor))
  (setq gap (zbbz-annotate-gap))
  (list (- (car text_anchor) (* dir gap 0.8)) (cadr text_anchor) 0.0)
)

(defun zbbz-annotate-horizontal-end-point ( anchor_point text_anchor / dir gap )
  (setq dir (zbbz-annotate-horizontal-direction anchor_point text_anchor))
  (setq gap (zbbz-annotate-gap))
  (if (> dir 0.0)
    (list (+ (car text_anchor) (* gap 3.6)) (cadr text_anchor) 0.0)
    (list (- (car text_anchor) (* gap 3.6)) (cadr text_anchor) 0.0)
  )
)

(defun zbbz-annotate-upper-text-point ( text_anchor / gap )
  (setq gap (zbbz-annotate-gap))
  (list (car text_anchor) (+ (cadr text_anchor) (* gap 0.55)) 0.0)
)

(defun zbbz-annotate-lower-text-point ( text_anchor / gap )
  (setq gap (zbbz-annotate-gap))
  (list (car text_anchor) (- (cadr text_anchor) (* gap 0.55)) 0.0)
)

(defun zbbz-annotate-horizontal-mode ( anchor_point text_anchor )
  (if (>= (car text_anchor) (car anchor_point))
    0
    2
  )
)

(defun zbbz-annotate-ensure-layer ( layer_name )
  (if (not (tblsearch "LAYER" layer_name))
    (entmake
      (list
        (cons 0 "LAYER")
        (cons 100 "AcDbSymbolTableRecord")
        (cons 100 "AcDbLayerTableRecord")
        (cons 2 layer_name)
        (cons 62 1)
        (cons 70 0)
      )
    )
  )
  layer_name
)

(defun zbbz-annotate-make-line ( start_point end_point layer_name )
  (setq result
    (entmakex
      (list
        (cons 0 "LINE")
        (cons 8 layer_name)
        (cons 10 start_point)
        (cons 11 end_point)
      )
    )
  )
  (if (null result)
    (prompt "\nZBBZ failed to create LINE.")
  )
  result
)

(defun zbbz-annotate-mtext-attachment (horizontal_mode)
  (if (= horizontal_mode 2) 6 4))

(defun zbbz-annotate-make-mtext ( insert_point text_value layer_name text_style text_height horizontal_mode )
  (setq result
    (entmakex
      (list
        (cons 0 "MTEXT")
        (cons 100 "AcDbEntity")
        (cons 8 layer_name)
        (cons 100 "AcDbMText")
        (cons 10 insert_point)
        (cons 40 text_height)
        (cons 1 text_value)
        (cons 7 text_style)
        (cons 62 1)
        (cons 71 (zbbz-annotate-mtext-attachment horizontal_mode))
        (cons 90 2)
        (cons 45 1.1)
      )
    )
  )
  (if (null result)
    (prompt (strcat "\nZBBZ failed to create MTEXT: " text_value))
  )
  result)

(defun zbbz-annotate-make-text ( insert_point text_value layer_name text_style text_height horizontal_mode / text_point )
  (if (zbbz-state-get 'background_mask)
    (zbbz-annotate-make-mtext insert_point text_value layer_name text_style text_height horizontal_mode)
    (progn
      (setq text_point insert_point)
      (setq result
        (entmakex
          (list
            (cons 0 "TEXT")
            (cons 8 layer_name)
            (cons 7 text_style)
            (cons 10 text_point)
            (cons 11 text_point)
            (cons 40 text_height)
            (cons 1 text_value)
            (cons 72 horizontal_mode)
            (cons 73 2)
          )
        )
      )
      (if (null result)
        (prompt (strcat "\nZBBZ failed to create TEXT: " text_value))
      )
      result
    )
  )
)

(defun zbbz-annotate-make-marker ( anchor_point layer_name / marker_size p1 p2 p3 )
  (setq marker_size (zbbz-annotate-arrow-size))
  (setq p1 anchor_point)
  (setq p2 (list (- (car anchor_point) marker_size) (- (cadr anchor_point) marker_size) 0.0))
  (setq p3 (list (+ (car anchor_point) marker_size) (- (cadr anchor_point) marker_size) 0.0))
  (setq result
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
  (if (null result)
    (prompt "\nZBBZ failed to create SOLID marker.")
  )
  result
)

(defun zbbz-annotate-group-dictionary (/ group_dict)
  (setq group_dict (dictsearch (namedobjdict) "ACAD_GROUP"))
  (if group_dict
    (cdr (assoc -1 group_dict))
    (dictadd
      (namedobjdict)
      "ACAD_GROUP"
      (entmakex
        (list
          (cons 0 "DICTIONARY")
          (cons 100 "AcDbDictionary")
          (cons 280 0)
          (cons 281 1))))))

(defun zbbz-annotate-make-group (group_name entities / group_dict group_data group_entity)
  (setq group_dict (zbbz-annotate-group-dictionary))
  (setq group_data
    (list
      (cons 0 "GROUP")
      (cons 100 "AcDbGroup")
      (cons 300 group_name)
      (cons 70 0)
      (cons 71 1)))
  (foreach entity entities
    (if entity
      (setq group_data (append group_data (list (cons 340 entity))))))
  (setq group_entity (entmakex group_data))
  (if group_entity
    (dictadd group_dict group_name group_entity))
  group_entity)

(defun zbbz-annotate-group-name (record_id seed_entity / handle_pair)
  (setq handle_pair (if seed_entity (assoc 5 (entget seed_entity)) nil))
  (if handle_pair
    (strcat "ZBBZ_" (itoa record_id) "_" (cdr handle_pair))
    (strcat "ZBBZ_" (itoa record_id))))

(defun zbbz-annotate-first-entity (entities / found)
  (setq found nil)
  (foreach entity entities
    (if (and (null found) entity)
      (setq found entity)))
  found)

(defun zbbz-annotate-store-record ( record )
  (setq *zbbz-created-annotations* (append *zbbz-created-annotations* (list record)))
  record
)

(defun zbbz-annotate-point-string (point)
  (strcat
    "("
    (rtos (car point) 2 3)
    ", "
    (rtos (cadr point) 2 3)
    ")"
  )
)

(defun zbbz-annotate-create ( anchor_point text_point / layer_name text_style point_output text_lines record_id text_anchor elbow_point line_end_point upper_text_point lower_text_point text_height horizontal_mode marker_entity leader_entity leader_end_entity upper_text_entity lower_text_entity entities group_entity )
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
  (prompt (strcat "\nZBBZ layer=" layer_name))
  (prompt (strcat "\nZBBZ text style=" text_style))
  (prompt (strcat "\nZBBZ text height=" (rtos text_height 2 3)))
  (prompt (strcat "\nZBBZ precision=" (itoa (zbbz-state-get 'precision))))
  (prompt (strcat "\nZBBZ swap_xy=" (if (zbbz-state-get 'swap_xy) "true" "false")))
  (prompt (strcat "\nZBBZ anchor=" (zbbz-annotate-point-string anchor_point)))
  (prompt (strcat "\nZBBZ upper text point=" (zbbz-annotate-point-string upper_text_point)))
  (prompt (strcat "\nZBBZ lower text point=" (zbbz-annotate-point-string lower_text_point)))
  (prompt (strcat "\nZBBZ text line 1=" (car text_lines)))
  (prompt (strcat "\nZBBZ text line 2=" (cadr text_lines)))
  (setq marker_entity nil)
  (if (not (equal (zbbz-state-get 'arrow_style) "none"))
    (setq marker_entity (zbbz-annotate-make-marker anchor_point layer_name)))
  (setq leader_entity (zbbz-annotate-make-line anchor_point elbow_point layer_name))
  (setq leader_end_entity (zbbz-annotate-make-line elbow_point line_end_point layer_name))
  (setq upper_text_entity (zbbz-annotate-make-text upper_text_point (car text_lines) layer_name text_style text_height horizontal_mode))
  (setq lower_text_entity (zbbz-annotate-make-text lower_text_point (cadr text_lines) layer_name text_style text_height horizontal_mode))
  (setq entities (list marker_entity leader_entity leader_end_entity upper_text_entity lower_text_entity))
  (setq group_entity nil)
  (if (zbbz-state-get 'group_on)
    (setq group_entity (zbbz-annotate-make-group (zbbz-annotate-group-name record_id (zbbz-annotate-first-entity entities)) entities)))
  (zbbz-annotate-store-record
    (list
      (cons 'id record_id)
      (cons 'point_world anchor_point)
      (cons 'point_output_1 (car point_output))
      (cons 'point_output_2 (cadr point_output))
      (cons 'prefix_mode (zbbz-state-get 'prefix_mode))
      (cons 'text_line_1 (car text_lines))
      (cons 'text_line_2 (cadr text_lines))
      (cons 'rotation (zbbz-state-get 'rotation))
      (cons 'dim_scale (zbbz-state-get 'dim_scale))
      (cons 'text_height (zbbz-state-get 'text_height))
      (cons 'layer layer_name)
      (cons 'entities entities)
      (cons 'group group_entity)
    )
  )
)

(defun zbbz-annotate-prompt-text-point ( anchor_point )
  (getpoint anchor_point "\nPick annotation text location: ")
)

(defun zbbz-annotate-run-once ( / anchor_point text_point )
  (setq anchor_point (getpoint "\nPick coordinate point: "))
  (if anchor_point
    (progn
      (setq text_point (zbbz-annotate-prompt-text-point anchor_point))
      (if text_point
        (zbbz-annotate-create anchor_point text_point)
      )
    )
  )
)

(defun zbbz-annotate-run-loop ()
  (while (zbbz-annotate-run-once)
    (princ)
  )
  (princ)
)
