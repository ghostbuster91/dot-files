{ pkgs, ... }: {
  # To set up Sway using Home Manager, first you must enable Polkit in your nix configuration:



  # configuring kanshi
  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    environment = { XDG_CONFIG_HOME = "/home/kghost/.config"; };
    serviceConfig = {
      # kanshi doesn't have an option to specifiy config file yet, so it looks
      # at .config/kanshi/config
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      glmark2
    ];
  };
}
