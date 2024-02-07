{ pkgs, ... }: {

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.defaultSession = "gnome";

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gedit # text editor
    gnome-tour
  ]) ++ (with pkgs.gnome; [
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

  hardware.pulseaudio.enable = false;
  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    nvidiaPersistenced = true;
    # Reverse sync is not compatible with the open source kernel module
    open = false;

    prime = {
      reverseSync.enable = true;

      #enable if using an external GPU
      allowExternalGpu = false;
    };
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "pl";
}
