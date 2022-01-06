{ pkgs, ... }: {
  programs.kitty = {
    enable = true;

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+alt+1" = "goto_tab 1";
      "ctrl+alt+2" = "goto_tab 2";
      "ctrl+alt+3" = "goto_tab 3";
      "ctrl+alt+4" = "goto_tab 4";
      "ctrl+alt+5" = "goto_tab 5";
      "ctrl+alt+6" = "goto_tab 6";
      "ctrl+alt+7" = "goto_tab 7";
      "ctrl+alt+8" = "goto_tab 8";
      "ctrl+alt+9" = "goto_tab 9";
    };

    settings = {
      scrollback_pager =
        "~/pager.sh 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'";
      font_family = "JetBrains Mono Regular";
      italic_font = "JetBrains Mono Italic";
      bold_font = "JetBrains Mono ExtraBold";
      bold_italic_font = "JetBrains Mono ExtraBold Italic";

      font_size = 12;

      shell = "${pkgs.zsh}/bin/zsh";
      shell_integration = "enabled";

      enable_audio_bell = "false";

      tab_bar_style = "powerline";
      tab_title_template = "{index}:{title}";

      # ubuntu theme
      background = "#300a24";
      foreground = "#eeeeec";
      cursor = "#bbbbbb";
      selection_background = "#b4d5ff";
      color0 = "#2e3436";
      color8 = "#555753";
      color1 = "#cc0000";
      color9 = "#ef2929";
      color2 = "#4e9a06";
      color10 = "#8ae234";
      color3 = "#c4a000";
      color11 = "#fce94f";
      color4 = "#3465a4";
      color12 = "#729fcf";
      color5 = "#75507b";
      color13 = "#ad7fa8";
      color6 = "#06989a";
      color14 = "#34e2e2";
      color7 = "#d3d7cf";
      color15 = "#eeeeec";
      selection_foreground = "#300a24";
    };
  };
}
