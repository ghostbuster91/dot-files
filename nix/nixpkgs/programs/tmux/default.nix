{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    sensibleOnTop = true;
    plugins = [
      pkgs.tmuxPlugins.yank
      pkgs.tmuxPlugins.better-mouse-mode
      {
        plugin = pkgs.tmuxPlugins.onedark-theme;
        extraConfig = ''
          set -g @onedark_widgets "#{prefix_highlight} #{free_mem}"
        '';
      }
      pkgs.derivations.tmux-status-variable
      {
        plugin = pkgs.tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_show_copy_mode 'on'
        '';
      }
      pkgs.derivations.tmux-thumbs
    ];
    extraConfig = ''
      set -g mouse on
      set-option -g renumber-windows on

      set-window-option -g xterm-keys on

      # use \ and - for splitting panes
      unbind '%'
      unbind '"'
      bind \\ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind g choose-window "join-pane -b -s '%%'"

      # Switch windows alt+number
      bind-key -n M-1 if-shell 'tmux select-window -t 1' ''' 'new-window -t 1'
      bind-key -n M-2 if-shell 'tmux select-window -t 2' ''' 'new-window -t 2'
      bind-key -n M-3 if-shell 'tmux select-window -t 3' ''' 'new-window -t 3'
      bind-key -n M-4 if-shell 'tmux select-window -t 4' ''' 'new-window -t 4'
      bind-key -n M-5 if-shell 'tmux select-window -t 5' ''' 'new-window -t 5'
      bind-key -n M-6 if-shell 'tmux select-window -t 6' ''' 'new-window -t 6'
      bind-key -n M-7 if-shell 'tmux select-window -t 7' ''' 'new-window -t 7'
      bind-key -n M-8 if-shell 'tmux select-window -t 8' ''' 'new-window -t 8'
      bind-key -n M-9 if-shell 'tmux select-window -t 9' ''' 'new-window -t 9'
      bind-key -n M-0 if-shell 'tmux select-window -t 10' ''' 'new-window -t 10'


      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind-key -n M-Up if-shell "$is_vim" "send-keys M-Up"  "select-pane -U"
      bind-key -n M-Down if-shell "$is_vim" "send-keys M-Down"  "select-pane -D"
      bind-key -n M-Left if-shell "$is_vim" "send-keys M-Left"  "select-pane -L"
      bind-key -n M-Right if-shell "$is_vim" "send-keys M-Right"  "select-pane -R"

      bind-key -n C-Up resize-pane -U
      bind-key -n C-Down resize-pane -D
      bind-key -n C-Left resize-pane -L
      bind-key -n C-Right resize-pane -R

      # Rename tmux windows to the current directory
      # https://stackoverflow.com/a/45010147 {
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
      # }

      bind -n S-Enter send-keys Escape "[13;2u"
      bind -n C-Enter send-keys Escape "[13;5u"
    '';
  };
}
