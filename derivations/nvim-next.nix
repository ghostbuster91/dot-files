{ pkgs }:
pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  pname = "nvim-next";
  version = "72f29b81113e6009a9ac7a3e7bd2d931d0b427dc";
  src = pkgs.fetchFromGitHub
    {
      owner = "ghostbuster91";
      repo = "nvim-next";
      rev = version;
      hash = "sha256-Muz80hd2KRPc86bydaXuL9coWDT32aXp92F6LiI2XGc=";
    };
}
