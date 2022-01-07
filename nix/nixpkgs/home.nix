{ pkgs, config, ... }: {

  nixpkgs = {
    overlays = [ (import ./overlays/alacritty.nix) ];
    config = { allowUnfree = true; };
  };

  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "kghost";
  home.homeDirectory = "/home/kghost";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    FZF_TMUX = "1";
    FZF_TMUX_HEIGHT = "30%";
  };

  imports = [ ./scala ./alacritty ];

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    diff-so-fancy # pretty diffs
    git-gone # get rid of orphan local branches
    exa # better ls
    bat # better cat
    tokei # better cloc
    xsv # csv manipulation
    fd # faster find

    tree # display tree structure of directory
    _1password # 1password cli
    jq # pretty-print json
    hexyl # pretty-print hex

    git-crypt # encrypt files in git repository

    # Files
    dua # disk usage analyzer

    # nix stuff
    nix-du
    nix-index
    nix-review
    nix-tree
    nixfmt

    # Media
    youtube-dl
    imagemagick

    # Overview
    htop
    neofetch

    noti # notifications
    xsel # for tmux-yank
  ];

  programs.git = {
    enable = true;
    userName = "ghostbuster91";
    userEmail = "ghostbuster91@users.noreply.github.com";
    extraConfig = {
      merge = { conflictStyle = "diff3"; };
      core = {
        editor = "nvim";
        pager = "diff-so-fancy | less -FXRi";
      };
      color = { ui = true; };
      push = { default = "simple"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
      alias = { gone = "!bash ~/bin/git-gone.sh"; };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    zplug = {
      enable = true;
      plugins = [
        {
          name = "chisui/zsh-nix-shell";
          tags = [ "at:v0.4.0" ];
        }
        {
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" "at:v.1.15.0" ];
        }
        {
          name = "plugins/common-aliases";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "plugins/git";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "plugins/extract";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
        {
          name = "MichaelAquilina/zsh-you-should-use";
          tags = [ "at:1.7.3" ];
        }
        {
          name = "rupa/z";
          tags = [ "use:z.sh" "at:v1.11" ];
        }
        {
          name = "changyuheng/fz";
          tags = [ "defer:1" "at:2a4c1bc73664bb938bfcc7c99f473d0065f9dbfd" ];
        }
        {
          name = "b4b4r07/enhancd";
          tags = [ "use:init.sh" "at:v2.2.4" ];
        }
        {
          name = "Aloxaf/fzf-tab";
          tags = [ "at:a677cf770cfce1e3668ba576fecfb7a14f4f39e2" ];
        }
        {
          name = "hlissner/zsh-autopair";
          tags = [ "at:9d003fc02dbaa6db06e6b12e8c271398478e0b5d" ];
        }
        {
          name = "wfxr/forgit";
          tags = [ "at:7b26cd46ac768af51b8dd4b84b6567c4e1c19642" "defer:1" ];
        }
        {
          name = "plugins/tmux";
          tags =
            [ "from:oh-my-zsh" "at:904f8685f75ff5dd3f544f8c6f2cabb8e5952e9a" ];
        }
      ];
    };
    initExtraFirst = ''
      ZSH_TMUX_AUTOSTART=true
      ZSH_TMUX_CONFIG=${config.xdg.configHome}/tmux/tmux.conf
    '';
    initExtraBeforeCompInit = ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
      # fix delete key
      bindkey "^[[3~" delete-char
      # turn off beeping
      unsetopt BEEP

      autoload -U select-word-style
      select-word-style bash

      # ctrl-d drop stash entry
      FORGIT_STASH_FZF_OPTS='--bind="ctrl-d:reload(git stash drop $(cut -d: -f1 <<<{}) 1>/dev/null && git stash list)"'
    '';

    localVariables = { POWERLEVEL9K_MODE = "awesome-patched"; };
    history = { extended = true; };
    shellAliases = {
      lsd = "exa --long --header --git --all";
      ls = "exa";
      l = "exa -l";
      la = "exa -la";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set mouse=a
      syntax on
      augroup fmt
        autocmd!
        autocmd BufWritePre * undojoin | Neoformat
      augroup END

      set relativenumber
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      rec {
        plugin = onedark-vim;
        config = ''
          packadd! ${plugin.pname}
          colorscheme onedark
        '';
      }
      neoformat
      fzf-vim
      vim-tmux-navigator
    ];
  };

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
      pkgs.tmuxPlugins.fingers
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.onedark-theme
    ];
    extraConfig = ''
      set -g mouse on
      set-option -g renumber-windows on


      # Make sure CTRL-Shift and such works
      set-window-option -g xterm-keys on

      # use | and - for splitting panes
      unbind '%'
      unbind '"'
      bind | split-window -b -h -c "#{pane_current_path}"
      bind - split-window -b -v -c "#{pane_current_path}"

      # vi style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # get a pane from an other window
      bind g choose-window "join-pane -b -s '%%'"

      # vi style pane selection
      bind -r C-h resize-pane -L 12
      bind -r C-j resize-pane -D 8
      bind -r C-k resize-pane -U 8
      bind -r C-l resize-pane -R 12
    '';
  };

  dconf = {
    enable = true;
    settings = {
      "org.gnome.desktop.input-sources" = {
        show-all-sources = "false";
        xkb-options = "['numpad:shift3', 'numpad:microsoft']";
        per-window = "false";
        current = "uint32 0";
        mru-sources = "@a(ss) []";
        sources = "[('xkb', 'pl')]";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
        {
          binding = "<Primary><Alt>f";
          command = "alacritty";
          name = "open-terminal";
        };
    };
  };

  services.redshift = {
    enable = true;
    latitude = "52.2370";
    longitude = "21.0175";
    temperature.night = 3000;
    temperature.day = 5000;
  };
  programs.noti = { enable = true; };

  systemd.user.startServices = "sd-switch";
}
