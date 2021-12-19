{ config, pkgs, ... }:

{
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

  home.packages = with pkgs; [
    # Rust CLI Tools! I love rust.
    exa
    bat
    tokei
    xsv
    fd

    tree
    _1password
    # Development
    tmux
    jq
    git-crypt

    # Files
    zstd
    restic

    # Media
    youtube-dl
    imagemagick

    # Overview
    htop
    wtf
    lazygit
    neofetch
    nixfmt
  ];

  programs.git = {
    enable = true;
    userName = "ghostbuster91";
    userEmail = "ghostbuster91@users.noreply.github.com";
    extraConfig = {
      core = { editor = "nvim"; };
      color = { ui = true; };
      push = { default = "simple"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
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
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" "at:v.1.15.0" ];
        } # Installations with additional options. For the list of options, please refer to Zplug README.
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
      ];
    };
    initExtraBeforeCompInit = ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
    '';

    localVariables = { POWERLEVEL9K_MODE = "awesome-patched"; };
    history = { extended = true; };
    shellAliases = {
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
    extraConfig = "syntax on";
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
    ];
  };

  dconf.settings = {
    "org.gnome.desktop.input-sources" = {
      show-all-sources = "false";
      xkb-options = "['numpad:shift3', 'numpad:microsoft']";
      per-window = "false";
      current = "uint32 0";
      mru-sources = "@a(ss) []";
      sources = "[('xkb', 'pl')]";
    };
  };

  services.redshift = {
    enable = true;
    latitude = "52.2370";
    longitude = "21.0175";
    temperature.night = 3000;
    temperature.day = 5000;
  };
}
