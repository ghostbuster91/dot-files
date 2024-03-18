{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ android-tools ];
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
}
