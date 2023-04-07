{ pkgs, ... }:
{
  imports = [ ./bloop.nix ];

  home.packages = with pkgs; [
    jdk11
    scala
    ammonite
    scalafmt
    coursier
    scala-cli
    sbt
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk}";
    JVM_DEBUG =
      "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005";
  };

  programs.sbt = {
    enable = false;
    plugins =
      let
        projectGraph = {
          org = "com.dwijnand";
          artifact = "sbt-project-graph";
          version = "0.4.0";
        };
      in
      [ projectGraph ];
  };
}
