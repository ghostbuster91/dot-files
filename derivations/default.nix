{ pkgs, lib }: {
  tmux-status-variable = pkgs.callPackage ./tmux-status-variable.nix { inherit pkgs; };
  nvim-neoclip = pkgs.callPackage ./nvim-neoclip.nix { inherit pkgs; };
  nvim-noice = pkgs.callPackage ./nvim-noice.nix { inherit pkgs; };
}
