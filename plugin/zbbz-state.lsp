(setq *zbbz-settings* nil)
(setq *zbbz-settings-initialized* nil)

(defun zbbz-state-config-path ()
  (zbbz-plugin-path "zbbz-config.lsp")
)

(defun zbbz-state-debug-prompt (text)
  (prompt (strcat "\nZBBZSTATE " text))
)

(defun zbbz-state-debug-value (label value)
  (zbbz-state-debug-prompt
    (strcat label "=" (vl-prin1-to-string value)))
)

(defun zbbz-state-defaults ()
  (list
    (cons 'coord_mode 'current)
    (cons 'base_n 0.0)
    (cons 'base_e 0.0)
    (cons 'rotation 0.0)
    (cons 'dim_layer "")
    (cons 'arrow_style "none")
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
    (cons 'prefix_mode 'xy)))

(defun zbbz-state-save-config ( / file_handle )
  (zbbz-state-debug-prompt (strcat "save path=" (zbbz-state-config-path)))
  (zbbz-state-debug-value "save settings" *zbbz-settings*)
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
  (zbbz-state-debug-prompt (strcat "load path=" (zbbz-state-config-path)))
  (setq file_handle (open (zbbz-state-config-path) "r"))
  (if file_handle
    (progn
      (setq config_line (read-line file_handle))
      (close file_handle)
      (zbbz-state-debug-value "raw config line" config_line)
      (if config_line
        (progn
          (setq config_value (read config_line))
          (zbbz-state-debug-value "parsed config" config_value)
          (if config_value
            config_value
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
      (zbbz-state-debug-prompt "ensure triggered load")
      (setq loaded_config (zbbz-state-load-config))
      (if loaded_config
        (setq *zbbz-settings* loaded_config)
        (setq *zbbz-settings* (zbbz-state-defaults))
      )
      (setq *zbbz-settings-initialized* T)
      (zbbz-state-debug-value "active settings after ensure" *zbbz-settings*)
      (if (null loaded_config)
        (zbbz-state-save-config)
      )
    )
  )
  *zbbz-settings*)

(defun zbbz-state-get (key / pair)
  (setq pair (assoc key (zbbz-state-ensure)))
  (if pair
    (cdr pair)
    nil))

(defun zbbz-state-put (key value / state pair)
  (setq state (zbbz-state-ensure))
  (setq pair (assoc key state))
  (if pair
    (setq *zbbz-settings* (subst (cons key value) pair state))
    (setq *zbbz-settings* (append state (list (cons key value)))))
  (zbbz-state-save-config)
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
