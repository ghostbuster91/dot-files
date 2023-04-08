{ inputs }:
self: super:
let
  nvimPlugins = import ./nvimPlugins.nix { pkgs = super; inherit inputs; };
in
{
  alacritty = import ./alacritty.nix { inherit (inputs) nixGL; pkgs = super; };
  metals = import ./metalsOverlay.nix { pkgs = super; };
  tree-sitter-scala-master =
    import ./treesitter-scala.nix { pkgs = super; };
  nvim-treesitter-textobjects =
    import ./nvim-treesitter-textobjects.nix { pkgs = super; };
  vimPlugins = super.vimPlugins // nvimPlugins;
} 
