{ pkgs, config, inputs, lib, username, pkgs-unstable, ... }: {

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "22.05";
  };
  fonts.fontconfig.enable = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "kghost";
  # home.homeDirectory = "/home/kghost";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # home.file.".config/nix/registry.json".text = builtins.toJSON {
  #   flakes =
  #     lib.mapAttrsToList
  #       (n: v: {
  #         exact = true;
  #         from = {
  #           id = n;
  #           type = "indirect";
  #         };
  #         to = {
  #           path = v.outPath;
  #           type = "path";
  #         };
  #       })
  #       inputs;
  #   version = 2;
  # };

  # nix.package = inputs.nix.packages.${pkgs.system}.nix;
  # nix.settings.nix-path = [
  #   "nixpkgs=${inputs.nixpkgs}"
  #   "home-manager=${inputs.home-manager}"
  # ];

  home.sessionVariables = {
    # DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
  };

  imports = [
    ./programs/scala
    ./programs/alacritty
    ./programs/tmux
    ./programs/zsh
    ./programs/neovim
    ./programs/git
  ];

  home.packages = with pkgs-unstable; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    bat # better cat
    tokei # better cloc
    xsv # csv manipulation
    fd # faster find
    ripgrep # better grep

    tree # display tree structure of directory
    jq # pretty-print json
    hexyl # pretty-print hex

    # Files
    dua # disk usage analyzer

    # nix stuff
    nix-du
    nix-tree
    nixfmt
    nix-prefetch
    nurl # better prefetch
    nvd # compare nix derivations
    statix # nix linter
    nix-output-monitor

    # Media
    youtube-dl
    imagemagick

    # Overview
    htop
    neofetch

    xsel # for tmux-yank
    unzip # also for vim

    sublime
    gh
    tig
    slack
    zoom-us
    openconnect-sso

    gnomeExtensions.tray-icons-reloaded
    gnome.gnome-tweaks
    jetbrains.idea-community
    pkgs.kooha # screen recorder
    clapper # video player
    asciinema # terminal recorder
    powertop
    signal-desktop
    vscode-fhs
  ];

  programs = {
    exa = {
      enable = true;
      enableAliases = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        unset LD_LIBRARY_PATH
      '';
    };
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    ssh = {
      enable = true;
    };
    google-chrome = {
      enable = true;
    };
  };
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/plain" = [ "sublime2.desktop" ];
    };
    defaultApplications = {
      "text/plain" = [ "sublime2.desktop" ];
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "trayIconsReloaded@selfmade.pl"
        ];
      };
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
  #
  #services.redshift = {
  #  enable = true;
  #  latitude = "52.2370";
  #  longitude = "21.0175";
  #  temperature.night = 3000;
  #  temperature.day = 5000;
  #};
  #
  #services.unclutter = {
  #  enable = true;
  #  extraOptions = [ "ignore-scrolling" ];
  #};
  #
  #systemd.user.startServices = "sd-switch";
}


