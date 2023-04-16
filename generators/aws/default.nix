{ inputs, system, globals, overlays, ... }:

with inputs;

nixos-generators.nixosGenerate {
  inherit system;
  format = "amazon";
  modules = [
    home-manager.nixosModules.home-manager
    {
      nixpkgs.overlays = overlays;
      user = globals.user;
      fullName = globals.fullName;
      dotfilesRepo = globals.dotfilesRepo;
      gitName = globals.gitName;
      gitEmail = globals.gitEmail;
      networking.hostName = "sheep";
      gui.enable = false;
      theme.colors = (import ../../colorscheme/gruvbox).dark;
      passwordHash = null;
      publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+AbmjGEwITk5CK9y7+Rg27Fokgj9QEjgc9wST6MA3s";
      # AWS settings require this
      permitRootLogin = "prohibit-password";
    }
    ../../modules/common
    ../../modules/nixos
    ../../modules/nixos/services/sshd.nix
  ] ++ [
    # Required to fix diskSize errors during build
    ({ ... }: { amazonImage.sizeMB = 16 * 1024; })
  ];
}
