{ pkgs, lib }: {
  tmux-status-variable = pkgs.callPackage ./tmux-status-variable.nix { inherit pkgs; };
  nvim-metals = pkgs.callPackage ./nvim-metals.nix { inherit pkgs; };
  nvim-tmux-resize = pkgs.callPackage ./nvim-tmux-resize.nix { inherit pkgs; };
  nvim-leap = pkgs.callPackage ./nvim-leap.nix { inherit pkgs; };
  nvim-next = pkgs.callPackage ./nvim-next.nix { inherit pkgs; };
  nvim-syntax-surfer = pkgs.callPackage ./nvim-syntax-surfer.nix { inherit pkgs; };
  nvim-actions-preview = pkgs.callPackage ./nvim-actions-preview.nix { inherit pkgs; };
  nvim-portal = pkgs.callPackage ./nvim-portal.nix { inherit pkgs; };
  nvim-ssr = pkgs.callPackage ./nvim-ssr.nix { inherit pkgs; };
  nvim-inlayhints = pkgs.callPackage ./nvim-inlayhints.nix { inherit pkgs; };
}
