{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-metals";
  version = "1071ddc47e9d9629ba754ffbf3cc11fa8be4218b";
  src = pkgs.fetchFromGitHub {
    owner = "scalameta";
    repo = "nvim-metals";
    rev = "1071ddc47e9d9629ba754ffbf3cc11fa8be4218b";
    sha256 = "sha256-O9SR3xgJ2G/KXGcXRsVgvOoJLaIkPXK/RGla4sgbmZ8=";
  };
  meta.homepage = "https://github.com/scalameta/nvim-metals/";
}
