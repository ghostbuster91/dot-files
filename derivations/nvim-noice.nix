{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "noice.nvim";
  version = "7b62ccfc236e51e78e5b2fc7d3068eacd65e4590";
  src = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "noice.nvim";
    rev = "7b62ccfc236e51e78e5b2fc7d3068eacd65e4590";
    sha256 = "sha256-YLvsu1A0pjIXA7Fq/MVwot5eykZbrdaKh85szVAEXpQ="
    ;
  };
}
