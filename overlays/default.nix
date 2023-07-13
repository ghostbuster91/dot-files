{ inputs, system }:
self: super:
let
  nvimPlugins = import ./nvimPlugins.nix { pkgs = super; inherit inputs; };
  treesitter-grammars =
    import ./treesitter-grammars.nix { pkgs = super; inherit inputs; };
in
{
  inherit (inputs.nix-metals.packages.${system}) metals;
  inherit (inputs.nix-smithy-ls.packages.${system}) disney-smithy-ls;
  google-chrome = import ./chrome.nix { pkgs = super; };
  nvim-treesitter-textobjects =
    import ./nvim-treesitter-textobjects.nix { pkgs = super; };
  vimPlugins = super.vimPlugins // nvimPlugins;
} // treesitter-grammars

