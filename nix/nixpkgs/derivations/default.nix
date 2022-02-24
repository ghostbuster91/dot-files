{ pkgs }: {
  tmux-status-variable = pkgs.callPackage ./tmux-status-variable.nix { };
  tmux-thumbs = pkgs.callPackage ./tmux-thumbs.nix { };
}
