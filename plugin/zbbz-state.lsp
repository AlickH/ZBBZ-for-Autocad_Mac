(setq *zbbz-settings* nil)

(defun zbbz-state-defaults nil
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

(defun zbbz-state-reset nil
  (setq *zbbz-settings* (zbbz-state-defaults)))

(defun zbbz-state-ensure nil
  (if (null *zbbz-settings*)
    (zbbz-state-reset))
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
