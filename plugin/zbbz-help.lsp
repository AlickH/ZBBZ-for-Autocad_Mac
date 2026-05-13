(defun zbbz-help-show ()
  (alert
    (strcat
      "ZBBZ for AutoCAD for Mac\n\n"
      "Coordinate modes:\n"
      "- Current uses UCS coordinates.\n"
      "- World uses WCS coordinates.\n"
      "- Custom uses base N/E, rotation, and coordinate scale.\n\n"
      "Two-point calibration:\n"
      "- Pick two source drawing points.\n"
      "- Enter two target coordinate pairs.\n"
      "- The plugin computes rotation, scale, and base values.\n\n"
      "Behavior flags:\n"
      "- Swap X/Y swaps coordinate order and labels.\n"
      "- Group On currently records group intent in session data.\n"
      "- Auto Orient keeps text readable.\n\n"
      "DAT export:\n"
      "- Exports the current annotation session using the Mac plugin DAT schema.\n"
      "- No compatibility is claimed with the Windows plugin DAT format.")))
