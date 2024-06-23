{ pkgs-unstable, pkgs-stable, ... }: {
  home.packages = [
    (pkgs-unstable.bloop.override
      {
        jre = pkgs-stable.jdk17;
      })
  ];
}
