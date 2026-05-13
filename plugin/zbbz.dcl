SetDimZB : dialog {
  label = "ZBBZ Coordinate Annotation Settings";
  spacer;
  : row {
    : boxed_column {
      label = "Coordinate System";
      : radio_button { key = "coord_mode_current"; label = "Current Coordinate System"; }
      : radio_button { key = "coord_mode_world"; label = "World Coordinate System"; }
      : radio_button { key = "coord_mode_custom"; label = "Custom Coordinate System"; }
      : edit_box { key = "base_n"; label = "Base N"; edit_width = 18; }
      : edit_box { key = "base_e"; label = "Base E"; edit_width = 18; }
      : edit_box { key = "rotation"; label = "Rotation"; edit_width = 18; }
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
        : toggle { key = "swap_xy"; label = "Swap X/Y"; }
        : toggle { key = "group_on"; label = "Group On"; }
        : toggle { key = "auto_orient"; label = "Auto Orient"; }
      }
      : boxed_row {
        label = "Prefix";
        : radio_button { key = "prefix_xy"; label = "XY"; }
        : radio_button { key = "prefix_ab"; label = "AB"; }
        : radio_button { key = "prefix_ne"; label = "NE"; }
        : radio_button { key = "prefix_none"; label = "None"; }
      }
    }
    : boxed_column {
      label = "Style";
      : popup_list { key = "dim_layer"; label = "Annotation Layer"; }
      : popup_list { key = "arrow_style"; label = "Arrow Style"; }
      : edit_box { key = "arrow_size"; label = "Arrow Size"; edit_width = 12; }
      : popup_list { key = "text_style"; label = "Text Style"; }
      : popup_list { key = "precision"; label = "Precision"; }
      : row {
        : edit_box { key = "bearing_angle"; label = "Bearing"; edit_width = 12; }
        : button { key = "pick_bearing"; label = "Pick"; }
      }
      : edit_box { key = "dim_scale"; label = "Annotation Scale"; edit_width = 12; }
      : edit_box { key = "text_height"; label = "Text Height"; edit_width = 12; }
      : toggle { key = "background_mask"; label = "Background Mask"; }
      : button { key = "export_dat"; label = "Generate DAT File"; }
    }
  }
  spacer;
  : row {
    alignment = centered;
    children_alignment = centered;
    : button { key = "accept"; label = "OK"; is_default = true; width = 10; fixed_width = true; }
    : button { key = "cancel"; label = "Cancel"; is_cancel = true; width = 10; fixed_width = true; }
    : button { key = "help"; label = "Help"; width = 10; fixed_width = true; }
  }
}
