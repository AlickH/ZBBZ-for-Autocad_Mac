(defun zbbz-pick-bearing-angle (/ p1 p2)
  (setq p1 (getpoint "\nPick bearing start point: "))
  (if p1
    (progn
      (setq p2 (getpoint p1 "\nPick bearing end point: "))
      (if p2
        (zbbz-transform-bearing-from-points p1 p2)
        nil))
    nil))

(defun zbbz-pick-two-point-calibration (/ src_p1 src_p2 dst_p1 dst_p2 real_scale first_value second_value calibration)
  (setq src_p1 (getpoint "\nPick source point P1: "))
  (if src_p1
    (progn
      (setq src_p2 (getpoint src_p1 "\nPick source point P2: "))
      (if src_p2
        (progn
          (setq first_value (getreal "\nTarget P1 north/east first value: "))
          (setq second_value (getreal "\nTarget P1 second value: "))
          (setq dst_p1 (list first_value second_value))
          (setq first_value (getreal "\nTarget P2 north/east first value: "))
          (setq second_value (getreal "\nTarget P2 second value: "))
          (setq dst_p2 (list first_value second_value))
          (setq real_scale (getreal "\nReality scale <Enter for calculated scale>: "))
          (setq calibration
            (zbbz-transform-calibrate-2pt
              src_p1
              src_p2
              dst_p1
              dst_p2
              real_scale))
          calibration)
        nil))
    nil))

(defun zbbz-pick-apply-calibration (calibration)
  (if calibration
    (zbbz-state-put-many
      (list
        (cons 'coord_mode 'custom)
        (cons 'base_n (cdr (assoc 'base_n calibration)))
        (cons 'base_e (cdr (assoc 'base_e calibration)))
        (cons 'rotation (cdr (assoc 'rotation calibration)))
        (cons 'coord_scale (cdr (assoc 'coord_scale calibration)))))))
