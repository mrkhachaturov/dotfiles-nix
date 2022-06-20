{ config, ... }: {

  home-manager.users.${config.user}.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = { whitelist = { prefix = [ config.dotfilesPath ]; }; };
  };

}
