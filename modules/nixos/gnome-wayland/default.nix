{ pkgs, ... }: {
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };
    displayManager.defaultSession = "gnome";

    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    # Configure keymap in X11
    xserver.xkb.layout = "pl";
    gnome = {
      gnome-keyring.enable = true;
    };
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gedit # text editor
    gnome-tour
  ]) ++ (with pkgs; [
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "wake-dgpu" ''
      # Wake the NVIDIA dGPU from runtime-suspend and re-probe its outputs, so
      # external displays connected after boot get detected (reverse-PRIME: all
      # external connectors are wired to the dGPU, which can't see hotplug while
      # in D3cold). nvidia-smi is on PATH via videoDrivers = [ "nvidia" ].
      nvidia-smi -q >/dev/null
      cat /sys/class/drm/card0-*/status >/dev/null
      echo "dGPU woken and outputs re-probed."
    '')
  ];

  services.pulseaudio.enable = false;
  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    nvidiaPersistenced = false;
    # Reverse sync is not compatible with the open source kernel module
    open = false;

    prime = {
      reverseSync.enable = true;

      #enable if using an external GPU
      allowExternalGpu = false;
    };
  };
  security = {
    pam = {
      services = {
        login.enableGnomeKeyring = true;
      };
    };
  };
}
