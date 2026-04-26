{ username, pkgs, ... }:
{
  users.users.${username} = {
    extraGroups = [ "audio" ];
  };
  # Sound settings
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [ pavucontrol ];
}
