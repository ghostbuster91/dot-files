{ pkgs, lib }: {
  tmux-status-variable = pkgs.callPackage ./tmux-status-variable.nix { inherit pkgs; };
  nvim-eyeliner = pkgs.callPackage ./nvim-eyeliner.nix { inherit pkgs; };
  nvim-metals = pkgs.callPackage ./nvim-metals.nix { inherit pkgs; };
  nvim-tmux-resize = pkgs.callPackage ./nvim-tmux-resize.nix { inherit pkgs; };
  nvim-leap = pkgs.callPackage ./nvim-leap.nix { inherit pkgs; };
}
