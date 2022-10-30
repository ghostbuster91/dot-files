{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "neogit";
  version = "1acb13c07b34622fe1054695afcecff537d9a00a";
  src = pkgs.fetchFromGitHub {
    owner = "TimUntersberger";
    repo = "neogit";
    rev = "1acb13c07b34622fe1054695afcecff537d9a00a";
    sha256 = "sha256-XBFR5ancD75Ey6AGlgVjqWEEJQpNc2G/6mp3iB2fMPI=";
  };
  meta.homepage = "https://github.com/TimUntersberger/neogit/";
}
