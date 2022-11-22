{ pkgs, lib }: {
  tmux-status-variable = pkgs.callPackage ./tmux-status-variable.nix { inherit pkgs; };
  nvim-neoclip = pkgs.callPackage ./nvim-neoclip.nix { inherit pkgs; };
  nvim-noice = pkgs.callPackage ./nvim-noice.nix { inherit pkgs; };
  nvim-eyeliner = pkgs.callPackage ./nvim-eyeliner.nix { inherit pkgs; };
  nvim-neogit = pkgs.callPackage ./nvim-neogit.nix { inherit pkgs; };
  nvim-goto-preview = pkgs.callPackage ./nvim-goto-preview.nix { inherit pkgs; };
  nvim-metals = pkgs.callPackage ./nvim-metals.nix { inherit pkgs; };
  nvim-fidget = pkgs.callPackage ./nvim-fidget.nix { inherit pkgs; };
}
