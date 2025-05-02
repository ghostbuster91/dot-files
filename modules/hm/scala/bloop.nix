{ pkgs-unstable, pkgs-stable, ... }: {
  home.packages = [
    (pkgs-stable.bloop.override
      {
        jre = pkgs-stable.jdk17;
      })
  ];
}
