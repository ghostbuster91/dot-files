{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "noice.nvim";
  version = "87f908da660c321439a0dd98a8e51cd85227f57b";
  src = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "noice.nvim";
    rev = "87f908da660c321439a0dd98a8e51cd85227f57b";
    sha256 = "sha256-Y/XxnNjSzYnuDVeniM+E+rXLTUtCR+zz8OteyiBf3y8=";
  };
}
