{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-next";
  version = "41e0347d947ca2b5e54d730b4fd42502fc78822a";
  src = pkgs.fetchFromGitHub {
    owner = "ghostbuster91";
    repo = "nvim-next";
    rev = version;
    hash = "sha256-ztYcTim7aw/9CwUVPrvAx/2JKerNMVT0fYXvsdo7ohs=";
  };
}
