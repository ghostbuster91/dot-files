{ pkgs-unstable, ... }: {
  home.packages = [ pkgs-unstable.bloop ];

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
