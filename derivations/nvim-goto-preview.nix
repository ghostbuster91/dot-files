{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-goto-preview";
  version = "2022-12-13";
  src = pkgs.fetchFromGitHub {
    owner = "rmagatti";
    repo = "goto-preview";
    rev = "778cf600684a87eb36f9bb469346cfa8d5384a76";
    sha256 = "sha256-zxFcNDfJhs6zDjR3r+qHyxUTlKrNmxxddk8GPE7ulbg=";
  };
}
