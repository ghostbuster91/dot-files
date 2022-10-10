{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-eyeliner";
  version = "38e090adb5f56d6c06000a8bfdf3098554d7b784";
  src = pkgs.fetchFromGitHub {
    owner = "jinh0";
    repo = "eyeliner.nvim";
    rev = "38e090adb5f56d6c06000a8bfdf3098554d7b784";
    sha256 = "sha256-56fGrXcZAfell5SbMtCVfmxNoJkMM5FmXnuO110HkyM=";
  };
}
