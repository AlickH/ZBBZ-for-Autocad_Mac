(defun zbbz-format-precision-pattern (precision / zeros)
  (setq zeros "")
  (repeat precision
    (setq zeros (strcat zeros "0")))
  (if (> precision 0)
    (strcat "0." zeros)
    "0"))

(defun zbbz-format-number (value precision)
  (rtos value 2 precision))

(defun zbbz-format-prefix-labels (prefix_mode)
  (cond
    ((eq prefix_mode 'xy) (list "X" "Y"))
    ((eq prefix_mode 'ab) (list "A" "B"))
    ((eq prefix_mode 'ne) (list "N" "E"))
    (T (list "" ""))))

(defun zbbz-format-output-lines (value1 value2 prefix_mode swap_xy precision / labels first_value second_value first_label second_label)
  (setq labels (zbbz-format-prefix-labels prefix_mode))
  ; Match the original plugin's visible convention: by default the first displayed
  ; coordinate uses the second drawing dimension, and the second displayed coordinate
  ; uses the first drawing dimension.
  (setq first_value value2)
  (setq second_value value1)
  (setq first_label (car labels))
  (setq second_label (cadr labels))
  (if swap_xy
    (progn
      (setq first_value value1)
      (setq second_value value2)
      (setq first_label (cadr labels))
      (setq second_label (car labels))))
  (list
    (zbbz-format-line first_label first_value precision)
    (zbbz-format-line second_label second_value precision)))

(defun zbbz-format-line (label value precision / number_text)
  (setq number_text (zbbz-format-number value precision))
  (if (= label "")
    number_text
    (strcat label "=" number_text)))
