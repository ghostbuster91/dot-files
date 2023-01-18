{ pkgs }:
pkgs.fetchFromGitHub {
  owner = "nvim-treesitter";
  repo = "nvim-treesitter-textobjects";
  rev = "e5b65cd9192d6321f0b37c7f96cfa6cde6cf7582";
  sha256 = "sha256-Zkk8U7Tz8gT7NkFLvtmEtH4s83LL80Pe57uFns6CmU0=";
}

