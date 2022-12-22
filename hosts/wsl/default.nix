{ inputs, globals, ... }:

with inputs;

# System configuration for WSL
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { };
  modules = [
    globals
    wsl.nixosModules.wsl
    home-manager.nixosModules.home-manager
    ../../modules
    ../../nixos
    {
      networking.hostName = "wsl";
      # Set registry to flake packages, used for nix X commands
      nix.registry.nixpkgs.flake = nixpkgs;
      identityFile = "/home/${globals.user}/.ssh/id_ed25519";
      gui.enable = false;
      theme = {
        colors = (import ../../colorscheme/gruvbox).dark;
        dark = true;
      };
      passwordHash = nixpkgs.lib.fileContents ../../private/password.sha512;
      wsl = {
        enable = true;
        automountPath = "/mnt";
        defaultUser = globals.user;
        startMenuLaunchers = true;
        wslConf.network.generateResolvConf = true; # Turn off if it breaks VPN
        interop.includePath =
          false; # Including Windows PATH will slow down Neovim command mode
      };

      mail.aerc.enable = true;
      mail.himalaya.enable = true;
      dotfiles.enable = true;
      nixlang.enable = true;
      lua.enable = true;
    }
  ];
}
