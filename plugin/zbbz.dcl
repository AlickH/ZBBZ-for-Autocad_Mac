SetDimZB : dialog {
  label = "ZBBZ Coordinate Annotation Settings";
  initial_focus = "coord_current";
  spacer;
  : row {
    : boxed_column {
      label = "Coordinate System";
      : radio_column { key = "coord_mode"; value = "coord_current";
        : radio_button { key = "coord_current"; label = "Current Coordinate System"; value = "1"; }
        : radio_button { key = "coord_world"; label = "World Coordinate System"; value = "0"; }
        : radio_button { key = "coord_custom"; label = "Custom Coordinate System"; value = "0"; }
      }
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
      : boxed_column {
        label = "Behavior";
        : toggle { key = "swap_xy"; label = "Swap X/Y"; value = "0"; }
        : toggle { key = "group_on"; label = "Group On"; value = "0"; }
        : toggle { key = "auto_orient"; label = "Auto Orient"; value = "0"; }
      }
      : boxed_column {
        label = "Prefix";
        : radio_row { key = "prefix_mode"; value = "prefix_xy";
          : radio_button { key = "prefix_xy"; label = "XY"; value = "1"; }
          : radio_button { key = "prefix_ab"; label = "AB"; value = "0"; }
          : radio_button { key = "prefix_ne"; label = "NE"; value = "0"; }
          : radio_button { key = "prefix_none"; label = "None"; value = "0"; }
        }
      }
    }
    : boxed_column {
      label = "Style";
      : popup_list { key = "dim_layer"; label = "Annotation Layer"; list = "*CURRENT*\n0"; value = "0"; }
      : popup_list { key = "arrow_style"; label = "Arrow Style"; list = "triangle\nnone"; value = "0"; }
      : edit_box { key = "arrow_size"; label = "Arrow Size"; edit_width = 12; value = "2.500000"; }
      : popup_list { key = "text_style"; label = "Text Style"; list = "*CURRENT*\nStandard"; value = "0"; }
      : popup_list { key = "precision"; label = "Precision"; list = "0.000\n0.00\n0.0\n0\n0.0000"; value = "0"; }
      : popup_list { key = "dialog_language"; label = "Dialog Language"; list = "Follow AutoCAD\nEnglish\nChinese, Simplified\nFrench\nGerman\nItalian\nJapanese\nKorean\nSpanish"; value = "0"; }
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
    : row {
      fixed_width = true;
      : button { key = "accept"; label = "OK"; is_default = true; width = 8; fixed_width = true; }
      : button { key = "cancel"; label = "Cancel"; is_cancel = true; width = 8; fixed_width = true; }
    }
  }
}
