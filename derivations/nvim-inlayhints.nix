{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-inlayhints";
  version = "84ca3abe8aaecbb5b30ad89e4701d4a9c821b72c";
  src = pkgs.fetchFromGitHub {
    owner = "lvimuser";
    repo = "lsp-inlayhints.nvim";
    rev = version;
    hash = "sha256-jjr9Tl2Ucg+zGJEnPMzExJBpsZt8nJ5qerbJpzTXoDs=";
  };
}
