{ pkgs, ... }: {
  users.groups.plugdev = { }; # needed for qmk-udev-rules
  services.udev.packages = with pkgs; [
    qmk-udev-rules
  ];
}
