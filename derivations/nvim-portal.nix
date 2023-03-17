{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-portal";
  version = "41e0347d947ca2b5e54d730b4fd42502fc78822a";
  src = pkgs.fetchFromGitHub {
    owner = "cbochs";
    repo = "portal.nvim";
    rev = "cd662fb97fe00fadaf0d001dbfb9bb73e2ceed41";
    hash = "sha256-NdAXDyEloWtdS+EdryYaFBr50uBiNUxp1If5OrFhWE0=";
  };
}
