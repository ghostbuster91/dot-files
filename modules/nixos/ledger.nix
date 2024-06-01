{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ ledger-live-desktop ];
  services.udev.packages = with pkgs; [
    ledger-udev-rules
  ];
}
