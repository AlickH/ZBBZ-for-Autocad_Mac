(defun zbbz-grid-range-values (start_value end_value step / low high current values)
  (setq low (min start_value end_value))
  (setq high (max start_value end_value))
  (setq current low)
  (setq values nil)
  (while (<= current high)
    (setq values (append values (list current)))
    (setq current (+ current step)))
  values)

(defun zbbz-grid-prompt-spacing (label)
  (getreal (strcat "\n" label ": ")))

(defun zbbz-grid-draw-line (start_point end_point layer_name)
  (entmakex
    (list
      (cons 0 "LINE")
      (cons 8 layer_name)
      (cons 10 start_point)
      (cons 11 end_point))))

(defun zbbz-grid-draw-current-or-world (corner1 corner2 x_spacing y_spacing layer_name / xs ys x y)
  (setq xs (zbbz-grid-range-values (car corner1) (car corner2) x_spacing))
  (setq ys (zbbz-grid-range-values (cadr corner1) (cadr corner2) y_spacing))
  (foreach x xs
    (zbbz-grid-draw-line
      (list x (cadr corner1) 0.0)
      (list x (cadr corner2) 0.0)
      layer_name))
  (foreach y ys
    (zbbz-grid-draw-line
      (list (car corner1) y 0.0)
      (list (car corner2) y 0.0)
      layer_name)))

(defun zbbz-grid-draw-custom (corner1 corner2 x_spacing y_spacing layer_name / xs ys x y scale rotation base_n base_e start_point end_point)
  (setq scale (zbbz-state-get 'coord_scale))
  (setq rotation (zbbz-state-get 'rotation))
  (setq base_n (zbbz-state-get 'base_n))
  (setq base_e (zbbz-state-get 'base_e))
  (setq xs (zbbz-grid-range-values (car corner1) (car corner2) x_spacing))
  (setq ys (zbbz-grid-range-values (cadr corner1) (cadr corner2) y_spacing))
  (foreach x xs
    (setq start_point
      (zbbz-transform-point-from-custom
        (list x (cadr corner1))
        base_n
        base_e
        rotation
        scale))
    (setq end_point
      (zbbz-transform-point-from-custom
        (list x (cadr corner2))
        base_n
        base_e
        rotation
        scale))
    (zbbz-grid-draw-line
      start_point
      end_point
      layer_name))
  (foreach y ys
    (setq start_point
      (zbbz-transform-point-from-custom
        (list (car corner1) y)
        base_n
        base_e
        rotation
        scale))
    (setq end_point
      (zbbz-transform-point-from-custom
        (list (car corner2) y)
        base_n
        base_e
        rotation
        scale))
    (zbbz-grid-draw-line
      start_point
      end_point
      layer_name)))

(defun zbbz-grid-draw nil
  (setq corner1 (getpoint "\nPick first grid corner: "))
  (if corner1
    (progn
      (setq corner2 (getcorner corner1 "\nPick opposite grid corner: "))
      (if corner2
        (progn
          (setq x_spacing (zbbz-grid-prompt-spacing "Grid X spacing"))
          (setq y_spacing (zbbz-grid-prompt-spacing "Grid Y spacing"))
          (if (and x_spacing y_spacing (> x_spacing 0.0) (> y_spacing 0.0))
            (progn
              (setq layer_name (zbbz-annotate-ensure-layer (zbbz-annotate-layer-name)))
              (if (eq (zbbz-state-get 'coord_mode) 'custom)
                (zbbz-grid-draw-custom corner1 corner2 x_spacing y_spacing layer_name)
                (zbbz-grid-draw-current-or-world corner1 corner2 x_spacing y_spacing layer_name))
              T)
            nil))))))
