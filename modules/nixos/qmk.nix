{ pkgs, ... }: {
  users.groups.plugdev = { }; # needed for qmk-udev-rules
  services.udev.packages = with pkgs; [
    qmk-udev-rules
  ];
  environment.systemPackages = [
    (pkgs.qmk.overrideAttrs (old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ [ pkgs.python3Packages.appdirs ];
    }))
  ];
}
