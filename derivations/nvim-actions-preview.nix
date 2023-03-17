{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "actions-preview.nvim";
  version = "3028c9a35853bb5fb77670fb58537ce28085329c";
  src = pkgs.fetchFromGitHub {
    owner = "aznhe21";
    repo = "actions-preview.nvim";
    rev = version;
    hash = "sha256-mkLn2/klAdirbqxJ3xLz2vyjEx4Sb0NLEK/LS2w8rag=";
  };
}
