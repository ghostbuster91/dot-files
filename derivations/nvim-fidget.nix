{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "fidget.nvim";
  version = "7b62ccfc236e51e78e5b2fc7d3068eacd65e4590";
  src = pkgs.fetchFromGitHub {
    owner = "j-hui";
    repo = "fidget.nvim";
    rev = "2cf9997d3bde2323a1a0934826ec553423005a26";
    sha256 = "sha256-p41t+Xd64aWSzay3JCwHhlADGQ+3pFUiBDOSykalyRM=";
  };
}
