{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ android-tools ];
  users.groups.adbusers = { }; # needed for above udev rules
}
