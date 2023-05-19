{ pkgs, pkgs-unstable, ... }: {
  home.packages = [ pkgs-unstable.bloop ];

  programs.sbt = {
    plugins = [{
      org = "ch.epfl.scala";
      artifact = "sbt-bloop";
      inherit (pkgs-unstable.bloop) version;
    }];
  };
}
