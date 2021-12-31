{ pkgs, ... }: {
  home.packages = [ pkgs.bloop ];

  programs.sbt = {
    plugins = [{
      org = "ch.epfl.scala";
      artifact = "sbt-bloop";
      version = pkgs.bloop.version;
    }];
  };
}
