_:
{
  flake.nixosModules = {
    gnome = ./gnome-wayland;
    games = ./games;
    cache = ./cache.nix;
    qmk = ./qmk.nix;
    virtualisation = ./virtualisation.nix;
    nix = ./nix.nix;
    nixbuild = ./nixbuild.nix;
    hyprland = ./hyprland;
    sound = ./sound;
    bluetooth = ./bluetooth;
    sway = ./sway;
  };
}
