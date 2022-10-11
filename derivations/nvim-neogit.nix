{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "neogit";
  version = "74c9e29b61780345d3ad9d7a4a4437607caead4a";
  src = pkgs.fetchFromGitHub {
    owner = "TimUntersberger";
    repo = "neogit";
    rev = "74c9e29b61780345d3ad9d7a4a4437607caead4a";
    sha256 = "sha256-D08s/Nwsbyqgl2ODuSyD2uVyQdR+rwj6hciOLVWSXx8=";
  };
  meta.homepage = "https://github.com/TimUntersberger/neogit/";
}
