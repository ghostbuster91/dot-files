{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-tmux-resize";
  version = "2022-04-30";
  src = pkgs.fetchFromGitHub {
    owner = "RyanMillerC";
    repo = "better-vim-tmux-resizer";
    rev = "a791fe5b4433ac43a4dad921e94b7b5f88751048";
    sha256 = "sha256-1uHcQQUnViktDBZt+aytlBF1ZG+/Ifv5VVoKSyM9ML0=";
  };
}
