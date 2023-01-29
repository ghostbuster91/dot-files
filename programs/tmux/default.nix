{ pkgs, config, ... }: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    sensibleOnTop = true;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_action 'copy-pipe'
        '';
      }
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
      {
        plugin = pkgs.tmuxPlugins.tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-command 'echo -n {} | xsel -b'
          set -g @thumbs-regexp-1 'sha256-\S{43}=' # Match nix sha256
          set -g @thumbs-regexp-2 'addr_\w{58}' # Match cardano bech32 address
        '';
      }
      pkgs.tmuxPlugins.jump
    ];
    extraConfig = ''
      set -g mouse on

      # https://github.com/roxma/vim-tmux-clipboard/#requirements 
      set -g focus-events on
      
      # Enable 256 colors in tmux inside alacritty https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95
      # also here is nice function to verify that it works: https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/
      set-option -a terminal-overrides ",alacritty:RGB"      
      set-option -g renumber-windows on

      set-window-option -g xterm-keys on
      bind-key r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "~/.tmux.conf reloaded"

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

      # Smart pane resizing with awareness of Vim splits.
      # See: https://github.com/RyanMillerC/better-vim-tmux-resizer
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
      | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      # Edit values if you use custom resize_count variables
      bind-key -n C-Left if-shell "$is_vim" "send-keys C-Left"  "resize-pane -L 10"
      bind-key -n C-Down if-shell "$is_vim" "send-keys C-Down"  "resize-pane -D 5"
      bind-key -n C-Up if-shell "$is_vim" "send-keys C-Up"  "resize-pane -U 5"
      bind-key -n C-Right if-shell "$is_vim" "send-keys C-Right"  "resize-pane -R 10"
     
      bind-key -T copy-mode-vi C-Left resize-pane -L 10
      bind-key -T copy-mode-vi C-Down resize-pane -D 5
      bind-key -T copy-mode-vi C-Up resize-pane -U 5
      bind-key -T copy-mode-vi C-Right resize-pane -R 10

      # Rename tmux windows to the current directory
      # https://stackoverflow.com/a/45010147 {
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
      # }

      bind -n S-Enter send-keys Escape "[13;2u"
      bind -n C-Enter send-keys Escape "[13;5u"

      # set the pane border colors 
      set -g pane-border-style 'fg=colour235,bg=colour238' 
      set -g pane-active-border-style 'fg=colour39,bg=colour236'

      bind a next-layout
    '';
  };
}
