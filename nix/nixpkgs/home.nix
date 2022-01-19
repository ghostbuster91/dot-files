{ pkgs, config, ... }: {

  nixpkgs = {
    overlays = [
      (import ./overlays/alacritty.nix)
      (self: super: { derivations = import ./derivations { pkgs = super; }; })
    ];
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

  imports = [
    ./programs/scala
    ./programs/alacritty
    ./programs/tmux
    ./programs/zsh
    ./programs/neovim
  ];

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
    nix-prefetch

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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
