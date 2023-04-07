{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-metals";
  version = "51e88e4f5eeadbd92a75cae71c5cbb75f3cb6765";
  src = pkgs.fetchFromGitHub {
    owner = "scalameta";
    repo = "nvim-metals";
    rev = version;
    hash = "sha256-wvpXroM9U4WPv9WaDfT99H9JlHRrIlZiothuLhJtBFM=";
  };
  meta.homepage = "https://github.com/scalameta/nvim-metals/";
}
