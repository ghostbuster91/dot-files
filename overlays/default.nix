{ nixGL }:
self: super:
{
  alacritty = import ./alacritty.nix { inherit nixGL; pkgs = super; };
  metals = import ./metalsOverlay.nix { pkgs = super; };
}

