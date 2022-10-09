{ pkgs, ... }: {
  home.packages = [ pkgs.bloop ];

  programs.sbt = {
    plugins = [{
      org = "ch.epfl.scala";
      artifact = "sbt-bloop";
      inherit (pkgs.bloop) version;
    }];
  };
}
