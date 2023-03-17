{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-syntax-surfer";
  version = "9dc6657d76e3f8886a0b120e6a315c511f53bae7";
  src = pkgs.fetchFromGitHub
    {
      owner = "ziontee113";
      repo = "syntax-tree-surfer";
      rev = version;
      hash = "sha256-bWgWB6f4AfFEu+X3lRqD3SSlsjNY7zTCZPzOklry1uk=";
    };
}
