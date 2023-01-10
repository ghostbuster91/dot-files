{ nixGL, ts-build }:
self: super:
{
  alacritty = import ./alacritty.nix { inherit nixGL; pkgs = super; };
  metals = import ./metalsOverlay.nix { pkgs = super; };
  tree-sitter-scala-master =
    import ./treesitter-scala.nix { pkgs = super; inherit ts-build; };
}

