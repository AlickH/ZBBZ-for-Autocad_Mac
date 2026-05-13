(setq *zbbz-settings* nil)
(setq *zbbz-settings-initialized* nil)

(defun zbbz-state-config-path ()
  (zbbz-plugin-path "zbbz-config.lsp")
)

(defun zbbz-state-defaults ()
  (list
    (cons 'coord_mode 'current)
    (cons 'base_n 0.0)
    (cons 'base_e 0.0)
    (cons 'rotation 0.0)
    (cons 'dim_layer "")
    (cons 'arrow_style "triangle")
    (cons 'arrow_size 2.5)
    (cons 'text_style "")
    (cons 'precision 3)
    (cons 'bearing_angle 0.0)
    (cons 'dim_scale 1.0)
    (cons 'coord_scale 1.0)
    (cons 'text_height 2.5)
    (cons 'background_mask T)
    (cons 'swap_xy nil)
    (cons 'group_on nil)
    (cons 'auto_orient T)
    (cons 'prefix_mode 'xy)
    (cons 'dialog_language "cad")))

(defun zbbz-state-boolean-key-p (key)
  (member key '(background_mask swap_xy group_on auto_orient)))

(defun zbbz-state-assoc-value (key settings / pair)
  (setq pair (assoc key settings))
  (cond
    ((null pair) nil)
    ((atom (cdr pair)) (cdr pair))
    (T (cdr pair))))

(defun zbbz-state-truthy-p (value)
  (not (null value)))

(defun zbbz-state-normalize-settings (settings / normalized key default value)
  (setq normalized nil)
  (foreach item (zbbz-state-defaults)
    (setq key (car item))
    (setq default (cdr item))
    (setq value (zbbz-state-assoc-value key settings))
    (if (zbbz-state-boolean-key-p key)
      (setq value (if (zbbz-state-truthy-p value) T nil))
      (if (null value)
        (setq value default)))
    (setq normalized (append normalized (list (cons key value)))))
  normalized)

(defun zbbz-state-save-config ( / file_handle )
  (setq file_handle (open (zbbz-state-config-path) "w"))
  (if file_handle
    (progn
      (write-line (vl-prin1-to-string *zbbz-settings*) file_handle)
      (close file_handle)
      T)
    nil
  )
)

(defun zbbz-state-load-config ( / file_handle config_line config_value )
  (setq file_handle (open (zbbz-state-config-path) "r"))
  (if file_handle
    (progn
      (setq config_line (read-line file_handle))
      (close file_handle)
      (if config_line
        (progn
          (setq config_value (read config_line))
          (if config_value
            (zbbz-state-normalize-settings config_value)
            (zbbz-state-defaults)
          )
        )
        (zbbz-state-defaults)
      )
    )
    nil
  )
)

(defun zbbz-state-reset ()
  (setq *zbbz-settings* (zbbz-state-defaults))
  (setq *zbbz-settings-initialized* T)
  (zbbz-state-save-config)
)

(defun zbbz-state-ensure ()
  (if (or (null *zbbz-settings*) (null *zbbz-settings-initialized*))
    (progn
      (setq loaded_config (zbbz-state-load-config))
      (if loaded_config
        (setq *zbbz-settings* loaded_config)
        (setq *zbbz-settings* (zbbz-state-defaults))
      )
      (setq *zbbz-settings-initialized* T)
      (if (null loaded_config)
        (zbbz-state-save-config)
      )
    )
  )
  *zbbz-settings*)

(defun zbbz-state-get (key / pair)
  (zbbz-state-assoc-value key (zbbz-state-ensure)))

(defun zbbz-state-put (key value / state pair current_value)
  (setq state (zbbz-state-ensure))
  (if (zbbz-state-boolean-key-p key)
    (setq value (if (zbbz-state-truthy-p value) T nil)))
  (setq pair (assoc key state))
  (if pair
    (progn
      (setq current_value (zbbz-state-assoc-value key state))
      (if (not (equal current_value value))
        (progn
          (setq *zbbz-settings* (subst (cons key value) pair state))
          (zbbz-state-save-config))))
    (progn
      (setq *zbbz-settings* (append state (list (cons key value))))
      (zbbz-state-save-config)))
  *zbbz-settings*)

(defun zbbz-state-put-many (pairs)
  (foreach pair pairs
    (zbbz-state-put (car pair) (cdr pair)))
  *zbbz-settings*)

(defun zbbz-state-valid-coord-mode-p (value)
  (member value '(current world custom)))

(defun zbbz-state-valid-prefix-mode-p (value)
  (member value '(xy ab ne none)))

(defun zbbz-state-number-p (value)
  (or (= (type value) 'INT)
      (= (type value) 'REAL)))

(defun zbbz-state-validate-number (key value)
  (if (zbbz-state-number-p value)
    value
    (prompt (strcat "\nInvalid numeric value for " (vl-symbol-name key) "."))))

(defun zbbz-state-validate-angle (key value)
  (zbbz-state-validate-number key value))

(defun zbbz-state-apply-base-angle (base_n base_e rotation)
  (zbbz-state-put-many
    (list
      (cons 'coord_mode 'custom)
      (cons 'base_n base_n)
      (cons 'base_e base_e)
      (cons 'rotation rotation))))

(zbbz-state-ensure)
