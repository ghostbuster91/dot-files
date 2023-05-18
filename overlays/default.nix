{ inputs }:
self: super:
let
  nvimPlugins = import ./nvimPlugins.nix { pkgs = super; inherit inputs; };
in
{
  #alacritty = import ./alacritty.nix { inherit (inputs) nixGL; pkgs = super; };
  google-chrome = import ./chrome.nix { pkgs = super; };
  metals = import ./metalsOverlay.nix { pkgs = super; };
  nvim-treesitter-textobjects =
    import ./nvim-treesitter-textobjects.nix { pkgs = super; };
  vimPlugins = super.vimPlugins // nvimPlugins;
  tmux-onedark-theme = import ./tmux-onedark-theme.nix { pkgs = super; };
} 


