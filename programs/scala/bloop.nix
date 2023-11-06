{ pkgs, pkgs-unstable, ... }: {
  home.packages = [ pkgs-unstable.bloop ];

  programs.sbt = {
    plugins = [{
      org = "ch.epfl.scala";
      artifact = "sbt-bloop";
      inherit (pkgs-unstable.bloop) version;
    }];
  };

  home.file.".bloop/bloop.json".text =
    builtins.toJSON {
      javaHome = pkgs-unstable.jdk17;
      javaOptions = [
        "-Xmx8G"
        "-Xss10m"
        "-XX:+CrashOnOutOfMemoryError"
      ];
    };
}
