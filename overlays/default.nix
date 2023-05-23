{ inputs, system }:
self: super:
let
  nvimPlugins = import ./nvimPlugins.nix { pkgs = super; inherit inputs; };
in
{
  #alacritty = import ./alacritty.nix { inherit (inputs) nixGL; pkgs = super; };
  inherit (inputs.nix-metals.packages.${system}) metals;
  google-chrome = import ./chrome.nix { pkgs = super; };
  tree-sitter-scala-master =
    import ./treesitter-scala.nix { pkgs = super; };
  nvim-treesitter-textobjects =
    import ./nvim-treesitter-textobjects.nix { pkgs = super; };
  vimPlugins = super.vimPlugins // nvimPlugins;
  tmux-onedark-theme = import ./tmux-onedark-theme.nix { pkgs = super; };
} 


