{ username, ... }: {
  specialisation = {
    sway.configuration = {
      gnome.enable = false;
      sway.enable = true;
      home-manager = {
        users.${username} = {
          sway-hm.enable = true;
        };
      };
    };
  };
}
