{ pkgs-unstable, pkgs, ... }:
{
  imports = [ ./bloop.nix ];

  home = {
    packages = with pkgs-unstable; [
      ammonite
      scalafmt
      coursier
      (scala-cli.override { jre = jdk17; })
    ] ++ (with pkgs; [
      jdk17
      scala
      (sbt.override {
        jre = jdk17;
      })
      (maven3.override {
        jdk = jdk17;
      })
    ]);

    sessionVariables.JAVA_HOME = "${pkgs.jdk17}";
    sessionVariables.JVM_DEBUG =
      "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005";

    file.".sbt/1.0/global.sbt".text = builtins.readFile ./global.sbt;
  };
}
