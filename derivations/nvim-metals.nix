{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-metals";
  version = "1071ddc47e9d9629ba754ffbf3cc11fa8be4218b";
  src = pkgs.fetchFromGitHub {
    owner = "scalameta";
    repo = "nvim-metals";
    rev = "51e88e4f5eeadbd92a75cae71c5cbb75f3cb6765";
    hash = "sha256-wvpXroM9U4WPv9WaDfT99H9JlHRrIlZiothuLhJtBFM=";
  };
  meta.homepage = "https://github.com/scalameta/nvim-metals/";
}
