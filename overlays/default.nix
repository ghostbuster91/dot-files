{ nixGL }:
self: super:
{
  alacritty = import ./alacritty.nix { inherit nixGL; pkgs = super; };
  metals = import ./metalsOverlay.nix { pkgs = super; };
  tree-sitter-scala-master =
    import ./treesitter-scala.nix { pkgs = super; };
  nvim-treesitter-textobjects =
    import ./nvim-treesitter-textobjects.nix { pkgs = super; };
}
