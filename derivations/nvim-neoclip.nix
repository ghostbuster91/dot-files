{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-neoclip";
  version = "2022-04-30";
  src = pkgs.fetchFromGitHub {
    owner = "AckslD";
    repo = "nvim-neoclip.lua";
    rev = "f3ff1645de5d2fd46ac8ffe86e440b7f3ae1fd11";
    sha256 = "sha256-JO5tOk+Sv0YNjk1pHKfzXian7trFrEh/+iwH2ZxO0Ss=";
  };
}
