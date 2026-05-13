SetDimZB : dialog {
  label = "ZBBZ Coordinate Annotation Settings";
  initial_focus = "coord_mode";
  spacer;
  : row {
    : boxed_column {
      label = "Coordinate System";
      : popup_list { key = "coord_mode"; label = "Coordinate System"; list = "Current Coordinate System\nWorld Coordinate System\nCustom Coordinate System"; value = "0"; }
      : edit_box { key = "base_n"; label = "Base N"; edit_width = 18; value = "0.000000"; }
      : edit_box { key = "base_e"; label = "Base E"; edit_width = 18; value = "0.000000"; }
      : edit_box { key = "rotation"; label = "Rotation"; edit_width = 18; value = "0.000000"; }
      : button { key = "apply_base_angle"; label = "Known Base Point && Angle"; }
      : button { key = "pick_two_points"; label = "Known Two-Point Pick"; }
      : button { key = "draw_grid"; label = "Draw Coordinate Grid"; }
    }
    : column {
      : boxed_column {
        label = "Preview";
        : text {
          key = "preview_line_1";
          label = "X=0.000";
          fixed_width = true;
        }
        : text {
          key = "preview_line_2";
          label = "Y=0.000";
          fixed_width = true;
        }
        : text {
          key = "preview_note";
          label = "Preview is descriptive only.";
          fixed_width = true;
        }
      }
      : boxed_row {
        label = "Behavior";
        : list_box { key = "behavior_list"; width = 28; height = 3; multiple_select = true; list = "Swap X/Y\nGroup On\nAuto Orient"; value = ""; }
      }
      : boxed_row {
        label = "Prefix";
        : popup_list { key = "prefix_mode"; label = "Prefix"; list = "XY\nAB\nNE\nNone"; value = "0"; }
      }
    }
    : boxed_column {
      label = "Style";
      : popup_list { key = "dim_layer"; label = "Annotation Layer"; list = "*CURRENT*\n0"; value = "0"; }
      : popup_list { key = "arrow_style"; label = "Arrow Style"; list = "none"; value = "0"; }
      : edit_box { key = "arrow_size"; label = "Arrow Size"; edit_width = 12; value = "2.500000"; }
      : popup_list { key = "text_style"; label = "Text Style"; list = "*CURRENT*\nStandard"; value = "0"; }
      : popup_list { key = "precision"; label = "Precision"; list = "0.000\n0.00\n0.0\n0\n0.0000"; value = "0"; }
      : row {
        : edit_box { key = "bearing_angle"; label = "Bearing"; edit_width = 12; value = "0.000000"; }
        : button { key = "pick_bearing"; label = "Pick"; }
      }
      : edit_box { key = "dim_scale"; label = "Annotation Scale"; edit_width = 12; value = "1.000000"; }
      : edit_box { key = "text_height"; label = "Text Height"; edit_width = 12; value = "2.500000"; }
      : toggle { key = "background_mask"; label = "Background Mask"; value = "0"; }
      : button { key = "export_dat"; label = "Generate DAT File"; }
    }
  }
  spacer;
  : row {
    : spacer { width = 1; }
    : spacer { width = 30; }
    : button { key = "accept"; label = "OK"; is_default = true; width = 8; fixed_width = true; }
    : button { key = "cancel"; label = "Cancel"; is_cancel = true; width = 8; fixed_width = true; }
    : button { key = "help"; label = "Help"; width = 8; fixed_width = true; }
  }
}
