(defun zbbz-dialog-bool-to-tile (value)
  (if value "1" "0"))

(setq *zbbz-dialog-initializing* nil)

(defun zbbz-dialog-runtime-dcl-path ()
  (zbbz-plugin-path "zbbz-runtime.dcl"))

(defun zbbz-dialog-precision-index ()
  (cond
    ((= (zbbz-state-get 'precision) 2) "1")
    ((= (zbbz-state-get 'precision) 1) "2")
    ((= (zbbz-state-get 'precision) 0) "3")
    ((= (zbbz-state-get 'precision) 4) "4")
    (T "0")))

(defun zbbz-dialog-coord-mode-key ()
  (cond
    ((eq (zbbz-state-get 'coord_mode) 'world) "coord_world")
    ((eq (zbbz-state-get 'coord_mode) 'custom) "coord_custom")
    (T "coord_current")))

(defun zbbz-dialog-prefix-mode-key ()
  (cond
    ((eq (zbbz-state-get 'prefix_mode) 'ab) "prefix_ab")
    ((eq (zbbz-state-get 'prefix_mode) 'ne) "prefix_ne")
    ((eq (zbbz-state-get 'prefix_mode) 'none) "prefix_none")
    (T "prefix_xy")))

(defun zbbz-dialog-runtime-line (line / dim_layer text_style)
  (cond
    ((equal line "      : radio_column { key = \"coord_mode\"; value = \"coord_current\";")
      (strcat "      : radio_column { key = \"coord_mode\"; value = \"" (zbbz-dialog-coord-mode-key) "\";"))
    ((equal line "        : radio_button { key = \"coord_current\"; label = \"Current Coordinate System\"; value = \"1\"; }")
      (strcat "        : radio_button { key = \"coord_current\"; label = \"Current Coordinate System\"; value = \"" (if (eq (zbbz-state-get 'coord_mode) 'current) "1" "0") "\"; }"))
    ((equal line "        : radio_button { key = \"coord_world\"; label = \"World Coordinate System\"; value = \"0\"; }")
      (strcat "        : radio_button { key = \"coord_world\"; label = \"World Coordinate System\"; value = \"" (if (eq (zbbz-state-get 'coord_mode) 'world) "1" "0") "\"; }"))
    ((equal line "        : radio_button { key = \"coord_custom\"; label = \"Custom Coordinate System\"; value = \"0\"; }")
      (strcat "        : radio_button { key = \"coord_custom\"; label = \"Custom Coordinate System\"; value = \"" (if (eq (zbbz-state-get 'coord_mode) 'custom) "1" "0") "\"; }"))
    ((equal line "      : edit_box { key = \"base_n\"; label = \"Base N\"; edit_width = 18; value = \"0.000000\"; }")
      (strcat "      : edit_box { key = \"base_n\"; label = \"Base N\"; edit_width = 18; value = \"" (zbbz-format-number (zbbz-state-get 'base_n) 6) "\"; }"))
    ((equal line "      : edit_box { key = \"base_e\"; label = \"Base E\"; edit_width = 18; value = \"0.000000\"; }")
      (strcat "      : edit_box { key = \"base_e\"; label = \"Base E\"; edit_width = 18; value = \"" (zbbz-format-number (zbbz-state-get 'base_e) 6) "\"; }"))
    ((equal line "      : edit_box { key = \"rotation\"; label = \"Rotation\"; edit_width = 18; value = \"0.000000\"; }")
      (strcat "      : edit_box { key = \"rotation\"; label = \"Rotation\"; edit_width = 18; value = \"" (zbbz-format-number (zbbz-state-get 'rotation) 6) "\"; }"))
    ((equal line "        : toggle { key = \"swap_xy\"; label = \"Swap X/Y\"; value = \"0\"; }")
      (strcat "        : toggle { key = \"swap_xy\"; label = \"Swap X/Y\"; value = \"" (zbbz-dialog-bool-to-tile (zbbz-state-get 'swap_xy)) "\"; }"))
    ((equal line "        : toggle { key = \"group_on\"; label = \"Group On\"; value = \"0\"; }")
      (strcat "        : toggle { key = \"group_on\"; label = \"Group On\"; value = \"" (zbbz-dialog-bool-to-tile (zbbz-state-get 'group_on)) "\"; }"))
    ((equal line "        : toggle { key = \"auto_orient\"; label = \"Auto Orient\"; value = \"0\"; }")
      (strcat "        : toggle { key = \"auto_orient\"; label = \"Auto Orient\"; value = \"" (zbbz-dialog-bool-to-tile (zbbz-state-get 'auto_orient)) "\"; }"))
    ((equal line "        : radio_row { key = \"prefix_mode\"; value = \"prefix_xy\";")
      (strcat "        : radio_row { key = \"prefix_mode\"; value = \"" (zbbz-dialog-prefix-mode-key) "\";"))
    ((equal line "          : radio_button { key = \"prefix_xy\"; label = \"XY\"; value = \"1\"; }")
      (strcat "          : radio_button { key = \"prefix_xy\"; label = \"XY\"; value = \"" (if (eq (zbbz-state-get 'prefix_mode) 'xy) "1" "0") "\"; }"))
    ((equal line "          : radio_button { key = \"prefix_ab\"; label = \"AB\"; value = \"0\"; }")
      (strcat "          : radio_button { key = \"prefix_ab\"; label = \"AB\"; value = \"" (if (eq (zbbz-state-get 'prefix_mode) 'ab) "1" "0") "\"; }"))
    ((equal line "          : radio_button { key = \"prefix_ne\"; label = \"NE\"; value = \"0\"; }")
      (strcat "          : radio_button { key = \"prefix_ne\"; label = \"NE\"; value = \"" (if (eq (zbbz-state-get 'prefix_mode) 'ne) "1" "0") "\"; }"))
    ((equal line "          : radio_button { key = \"prefix_none\"; label = \"None\"; value = \"0\"; }")
      (strcat "          : radio_button { key = \"prefix_none\"; label = \"None\"; value = \"" (if (eq (zbbz-state-get 'prefix_mode) 'none) "1" "0") "\"; }"))
    ((equal line "      : popup_list { key = \"dim_layer\"; label = \"Annotation Layer\"; list = \"*CURRENT*\\n0\"; value = \"0\"; }")
      (progn
        (setq dim_layer (zbbz-state-get 'dim_layer))
        (strcat "      : popup_list { key = \"dim_layer\"; label = \"Annotation Layer\"; list = \"*CURRENT*\\n0\"; value = \"" (if (equal dim_layer "0") "1" "0") "\"; }")))
    ((equal line "      : popup_list { key = \"arrow_style\"; label = \"Arrow Style\"; list = \"triangle\\nnone\"; value = \"0\"; }")
      (strcat "      : popup_list { key = \"arrow_style\"; label = \"Arrow Style\"; list = \"triangle\\nnone\"; value = \"" (if (equal (zbbz-state-get 'arrow_style) "none") "1" "0") "\"; }"))
    ((equal line "      : edit_box { key = \"arrow_size\"; label = \"Arrow Size\"; edit_width = 12; value = \"2.500000\"; }")
      (strcat "      : edit_box { key = \"arrow_size\"; label = \"Arrow Size\"; edit_width = 12; value = \"" (zbbz-format-number (zbbz-state-get 'arrow_size) 6) "\"; }"))
    ((equal line "      : popup_list { key = \"text_style\"; label = \"Text Style\"; list = \"*CURRENT*\\nStandard\"; value = \"0\"; }")
      (progn
        (setq text_style (zbbz-state-get 'text_style))
        (strcat "      : popup_list { key = \"text_style\"; label = \"Text Style\"; list = \"*CURRENT*\\nStandard\"; value = \"" (if (equal text_style "Standard") "1" "0") "\"; }")))
    ((equal line "      : popup_list { key = \"precision\"; label = \"Precision\"; list = \"0.000\\n0.00\\n0.0\\n0\\n0.0000\"; value = \"0\"; }")
      (strcat "      : popup_list { key = \"precision\"; label = \"Precision\"; list = \"0.000\\n0.00\\n0.0\\n0\\n0.0000\"; value = \"" (zbbz-dialog-precision-index) "\"; }"))
    ((equal line "        : edit_box { key = \"bearing_angle\"; label = \"Bearing\"; edit_width = 12; value = \"0.000000\"; }")
      (strcat "        : edit_box { key = \"bearing_angle\"; label = \"Bearing\"; edit_width = 12; value = \"" (zbbz-format-number (zbbz-state-get 'bearing_angle) 6) "\"; }"))
    ((equal line "      : edit_box { key = \"dim_scale\"; label = \"Annotation Scale\"; edit_width = 12; value = \"1.000000\"; }")
      (strcat "      : edit_box { key = \"dim_scale\"; label = \"Annotation Scale\"; edit_width = 12; value = \"" (zbbz-format-number (zbbz-state-get 'dim_scale) 6) "\"; }"))
    ((equal line "      : edit_box { key = \"text_height\"; label = \"Text Height\"; edit_width = 12; value = \"2.500000\"; }")
      (strcat "      : edit_box { key = \"text_height\"; label = \"Text Height\"; edit_width = 12; value = \"" (zbbz-format-number (zbbz-state-get 'text_height) 6) "\"; }"))
    ((equal line "      : toggle { key = \"background_mask\"; label = \"Background Mask\"; value = \"0\"; }")
      (strcat "      : toggle { key = \"background_mask\"; label = \"Background Mask\"; value = \"" (zbbz-dialog-bool-to-tile (zbbz-state-get 'background_mask)) "\"; }"))
    (T line)))

(defun zbbz-dialog-write-runtime-dcl (/ source target line)
  (setq source (open (zbbz-plugin-path "zbbz.dcl") "r"))
  (setq target (open (zbbz-dialog-runtime-dcl-path) "w"))
  (if (and source target)
    (progn
      (while (setq line (read-line source))
        (write-line (zbbz-dialog-runtime-line line) target))
      (close source)
      (close target)
      (zbbz-dialog-runtime-dcl-path))
    (progn
      (if source (close source))
      (if target (close target))
      nil)))

(defun zbbz-dialog-sync-preview (/ lines)
  (setq lines
    (zbbz-format-output-lines
      0.0
      0.0
      (zbbz-state-get 'prefix_mode)
      (zbbz-state-get 'swap_xy)
      (zbbz-state-get 'precision)))
  (set_tile "preview_line_1" (car lines))
  (set_tile "preview_line_2" (cadr lines)))

(defun zbbz-dialog-update-custom-input-state (/ mode disabled_mode enabled_mode)
  (setq mode (zbbz-state-get 'coord_mode))
  (setq enabled_mode 0)
  (setq disabled_mode 1)
  (mode_tile "base_n" (if (eq mode 'custom) enabled_mode disabled_mode))
  (mode_tile "base_e" (if (eq mode 'custom) enabled_mode disabled_mode))
  (mode_tile "rotation" (if (eq mode 'custom) enabled_mode disabled_mode))
  (mode_tile "apply_base_angle" (if (eq mode 'custom) enabled_mode disabled_mode))
  (mode_tile "pick_two_points" enabled_mode))

(defun zbbz-dialog-populate ()
  (setq *zbbz-dialog-initializing* T)
  (set_tile "base_n" (zbbz-format-number (zbbz-state-get 'base_n) 6))
  (set_tile "base_e" (zbbz-format-number (zbbz-state-get 'base_e) 6))
  (set_tile "rotation" (zbbz-format-number (zbbz-state-get 'rotation) 6))
  (set_tile "arrow_size" (zbbz-format-number (zbbz-state-get 'arrow_size) 6))
  (set_tile "bearing_angle" (zbbz-format-number (zbbz-state-get 'bearing_angle) 6))
  (set_tile "dim_scale" (zbbz-format-number (zbbz-state-get 'dim_scale) 6))
  (set_tile "text_height" (zbbz-format-number (zbbz-state-get 'text_height) 6))
  (set_tile "background_mask" (zbbz-dialog-bool-to-tile (zbbz-state-get 'background_mask)))
  (zbbz-dialog-update-custom-input-state)
  (zbbz-dialog-sync-preview)
  (setq *zbbz-dialog-initializing* nil))

(defun zbbz-dialog-save-edit-number (tile key / value)
  (setq value (distof (get_tile tile) 2))
  (if value
    (zbbz-state-put key value)))

(defun zbbz-dialog-save-behavior-toggles ()
  (zbbz-state-put 'swap_xy (equal (get_tile "swap_xy") "1"))
  (zbbz-state-put 'group_on (equal (get_tile "group_on") "1"))
  (zbbz-state-put 'auto_orient (equal (get_tile "auto_orient") "1")))

(defun zbbz-dialog-save-style-popups ()
  (zbbz-state-put 'dim_layer
    (if (= (atoi (get_tile "dim_layer")) 1) "0" ""))
  (zbbz-state-put 'arrow_style
    (if (= (atoi (get_tile "arrow_style")) 1) "none" "triangle"))
  (zbbz-state-put 'text_style
    (if (= (atoi (get_tile "text_style")) 1) "Standard" "")))

(defun zbbz-dialog-save-prefix-mode ()
  (cond
    ((equal (get_tile "prefix_mode") "prefix_ab") (zbbz-state-put 'prefix_mode 'ab))
    ((equal (get_tile "prefix_mode") "prefix_ne") (zbbz-state-put 'prefix_mode 'ne))
    ((equal (get_tile "prefix_mode") "prefix_none") (zbbz-state-put 'prefix_mode 'none))
    (T (zbbz-state-put 'prefix_mode 'xy))))

(defun zbbz-dialog-save-coord-mode ()
  (cond
    ((equal (get_tile "coord_mode") "coord_world") (zbbz-state-put 'coord_mode 'world))
    ((equal (get_tile "coord_mode") "coord_custom") (zbbz-state-put 'coord_mode 'custom))
    (T (zbbz-state-put 'coord_mode 'current))))

(defun zbbz-dialog-save ()
  (if (not *zbbz-dialog-initializing*)
    (progn
      (zbbz-dialog-save-coord-mode)
      (zbbz-dialog-save-edit-number "base_n" 'base_n)
      (zbbz-dialog-save-edit-number "base_e" 'base_e)
      (zbbz-dialog-save-edit-number "rotation" 'rotation)
      (zbbz-dialog-save-edit-number "arrow_size" 'arrow_size)
      (zbbz-dialog-save-edit-number "bearing_angle" 'bearing_angle)
      (zbbz-dialog-save-edit-number "dim_scale" 'dim_scale)
      (zbbz-dialog-save-edit-number "text_height" 'text_height)
      (zbbz-dialog-save-behavior-toggles)
      (zbbz-dialog-save-style-popups)
      (zbbz-state-put 'background_mask (equal (get_tile "background_mask") "1"))
      (setq precision_index (atoi (get_tile "precision")))
      (zbbz-state-put 'precision
        (cond
          ((= precision_index 0) 3)
          ((= precision_index 1) 2)
          ((= precision_index 2) 1)
          ((= precision_index 3) 0)
          ((= precision_index 4) 4)
          (T 3)))
      (zbbz-dialog-save-prefix-mode))))

(defun zbbz-dialog-request-action (action_code)
  (zbbz-dialog-save)
  (setq *zbbz-dialog-action* action_code)
  (done_dialog 2))

(defun zbbz-dialog-handle-apply-base-angle ()
  (zbbz-dialog-save)
  (zbbz-state-apply-base-angle
    (zbbz-state-get 'base_n)
    (zbbz-state-get 'base_e)
    (zbbz-state-get 'rotation))
  (zbbz-dialog-populate))

(defun zbbz-dialog-bind-actions ()
  (action_tile "coord_mode" "(if (not *zbbz-dialog-initializing*) (progn (zbbz-dialog-save-coord-mode) (zbbz-dialog-update-custom-input-state)))")
  (action_tile "swap_xy" "(if (not *zbbz-dialog-initializing*) (progn (zbbz-dialog-save-behavior-toggles) (zbbz-dialog-sync-preview)))")
  (action_tile "group_on" "(if (not *zbbz-dialog-initializing*) (zbbz-dialog-save-behavior-toggles))")
  (action_tile "auto_orient" "(if (not *zbbz-dialog-initializing*) (zbbz-dialog-save-behavior-toggles))")
  (action_tile "background_mask" "(if (not *zbbz-dialog-initializing*) (zbbz-state-put 'background_mask (equal $value \"1\")))")
  (action_tile "prefix_mode" "(if (not *zbbz-dialog-initializing*) (progn (zbbz-dialog-save-prefix-mode) (zbbz-dialog-sync-preview)))")
  (action_tile "apply_base_angle" "(zbbz-dialog-handle-apply-base-angle)")
  (action_tile "pick_two_points" "(zbbz-dialog-request-action 'pick_two_points)")
  (action_tile "draw_grid" "(zbbz-dialog-request-action 'draw_grid)")
  (action_tile "pick_bearing" "(zbbz-dialog-request-action 'pick_bearing)")
  (action_tile "export_dat" "(zbbz-dialog-request-action 'export_dat)")
  (action_tile "help" "(zbbz-dialog-request-action 'help)")
  (action_tile "accept" "(setq *zbbz-dialog-action* 'accept) (zbbz-dialog-save) (done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)"))

(defun zbbz-dialog-run-once (/ runtime_dcl_path dialog_id result)
  (setq runtime_dcl_path (zbbz-dialog-write-runtime-dcl))
  (if (null runtime_dcl_path)
    (progn
      (prompt "\nUnable to write zbbz-runtime.dcl.")
      nil)
    (progn
      (setq dialog_id (load_dialog (zbbz-dialog-runtime-dcl-path)))
      (if (< dialog_id 0)
        (progn
          (prompt "\nUnable to load zbbz-runtime.dcl.")
          nil)
        (progn
          (if (not (new_dialog "SetDimZB" dialog_id))
            (progn
              (prompt "\nUnable to open SetDimZB dialog.")
              (setq result 0))
            (progn
              (setq *zbbz-dialog-action* 'accept)
              (zbbz-dialog-populate)
              (zbbz-dialog-bind-actions)
              (setq result (start_dialog))))
          (unload_dialog dialog_id)
          (list result *zbbz-dialog-action*))))))

(defun zbbz-dialog-open-loop (/ dialog_result dialog_code action_value bearing_angle calibration)
  (setq action_value 'accept)
  (while action_value
    (setq dialog_result (zbbz-dialog-run-once))
    (if (null dialog_result)
      (setq action_value nil)
      (progn
        (setq dialog_code (car dialog_result))
        (setq action_value (cadr dialog_result))
        (cond
          ((= dialog_code 0)
            (setq action_value nil)
            nil)
          ((= dialog_code 1)
            (setq action_value nil)
            T)
          ((eq action_value 'pick_bearing)
            (setq bearing_angle (zbbz-pick-bearing-angle))
            (if bearing_angle
              (zbbz-state-put 'bearing_angle bearing_angle)))
          ((eq action_value 'pick_two_points)
            (setq calibration (zbbz-pick-two-point-calibration))
            (if calibration
              (zbbz-pick-apply-calibration calibration)))
          ((eq action_value 'draw_grid)
            (zbbz-grid-draw))
          ((eq action_value 'export_dat)
            (zbbz-dat-export-session))
          ((eq action_value 'help)
            (zbbz-help-show))
          (T
            (setq action_value nil)
            nil))))))
(setq *zbbz-dialog-action* 'accept)
