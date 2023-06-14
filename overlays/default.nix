{ inputs, system }:
self: super:
let
  nvimPlugins = import ./nvimPlugins.nix { pkgs = super; inherit inputs; };
in
{
  inherit (inputs.nix-metals.packages.${system}) metals;
  inherit (inputs.nix-smithy-ls.packages.${system}) disney-smithy-ls;
  google-chrome = import ./chrome.nix { pkgs = super; };
  tree-sitter-scala-master =
    import ./treesitter-scala.nix { pkgs = super; };
  nvim-treesitter-textobjects =
    import ./nvim-treesitter-textobjects.nix { pkgs = super; };
  vimPlugins = super.vimPlugins // nvimPlugins;
} 


