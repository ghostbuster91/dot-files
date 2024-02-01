{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    # steam-rom-manager
    # steamtinkerlaunch
    # proton-caller
    # protontricks
    # protonup-qt
    # steam-run
    # gamescope
    # gamemode
    # lutris
    #
    # mangohud
    # protonup
    vulkan-tools
    # winetricks
  ];

}
