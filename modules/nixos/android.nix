{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ android-tools ];
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
  users.groups.adbusers = { }; # needed for above udev rules
}
