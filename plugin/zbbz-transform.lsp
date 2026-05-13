(defun zbbz-transform-deg-to-rad (degrees)
  (* pi (/ degrees 180.0)))

(defun zbbz-transform-point-current (point)
  point)

(defun zbbz-transform-point-world (point)
  (trans point 1 0))

; Rotate and scale the drawing-space offset into the custom output axes, then add the custom base.
(defun zbbz-transform-point-custom (point base_n base_e rotation coord_scale / radians cos_r sin_r x y scaled_x scaled_y out_1 out_2)
  (setq radians (zbbz-transform-deg-to-rad rotation))
  (setq cos_r (cos radians))
  (setq sin_r (sin radians))
  (setq x (car point))
  (setq y (cadr point))
  (setq scaled_x (* x coord_scale))
  (setq scaled_y (* y coord_scale))
  (setq out_1 (+ base_n (- (* scaled_x cos_r) (* scaled_y sin_r))))
  (setq out_2 (+ base_e (+ (* scaled_x sin_r) (* scaled_y cos_r))))
  (list out_1 out_2))

(defun zbbz-transform-distance-2d (p1 p2)
  (distance (list (car p1) (cadr p1)) (list (car p2) (cadr p2))))

(defun zbbz-transform-angle-deg (p1 p2)
  (* 180.0 (/ (angle p1 p2) pi)))

(defun zbbz-transform-normalize-angle (degrees)
  (while (< degrees 0.0)
    (setq degrees (+ degrees 360.0)))
  (while (>= degrees 360.0)
    (setq degrees (- degrees 360.0)))
  degrees)

; Solve a 2D similarity transform from two source points and their target coordinates.
(defun zbbz-transform-calibrate-2pt (src_p1 src_p2 dst_p1 dst_p2 real_scale / src_angle dst_angle rotation src_dist dst_dist calc_scale scale distance_diff src_custom_p1 base_n base_e)
  (setq src_angle (zbbz-transform-angle-deg src_p1 src_p2))
  (setq dst_angle (zbbz-transform-angle-deg dst_p1 dst_p2))
  (setq rotation (zbbz-transform-normalize-angle (- dst_angle src_angle)))
  (setq src_dist (zbbz-transform-distance-2d src_p1 src_p2))
  (setq dst_dist (zbbz-transform-distance-2d dst_p1 dst_p2))
  (setq calc_scale
    (if (/= dst_dist 0.0)
      (/ src_dist dst_dist)
      0.0))
  (setq scale
    (if (and real_scale (not (= real_scale 0.0)))
      real_scale
      calc_scale))
  (setq distance_diff (- src_dist (* dst_dist scale)))
  (setq src_custom_p1 (zbbz-transform-point-custom src_p1 0.0 0.0 rotation (/ 1.0 scale)))
  (setq base_n (- (car dst_p1) (car src_custom_p1)))
  (setq base_e (- (cadr dst_p1) (cadr src_custom_p1)))
  (list
    (cons 'rotation rotation)
    (cons 'calc_scale calc_scale)
    (cons 'real_scale scale)
    (cons 'coord_scale (/ 1.0 scale))
    (cons 'distance_diff distance_diff)
    (cons 'base_n base_n)
    (cons 'base_e base_e)))

(defun zbbz-transform-point-by-mode (point settings / coord_mode)
  (setq coord_mode (cdr (assoc 'coord_mode settings)))
  (cond
    ((eq coord_mode 'world)
      (zbbz-transform-point-world point))
    ((eq coord_mode 'custom)
      (zbbz-transform-point-custom
        point
        (cdr (assoc 'base_n settings))
        (cdr (assoc 'base_e settings))
        (cdr (assoc 'rotation settings))
        (cdr (assoc 'coord_scale settings))))
    (T
      (zbbz-transform-point-current point))))
