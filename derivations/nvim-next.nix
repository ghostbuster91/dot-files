{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-next";
  version = "aa8f75e021d49fbcba573f2c0ca457784e5a7bb0";
  src = pkgs.fetchFromGitHub {
    owner = "ghostbuster91";
    repo = "nvim-next";
    rev = version;
    hash = "sha256-yXYXGhnHvIxBDXvW6runIDj2lGRmBgzWKzl4Md1ZJag=";
  };
}
