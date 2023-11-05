# The Tempest
# System configuration for my desktop

{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    globals
    inputs.home-manager.nixosModules.home-manager
    ../../modules/common
    ../../modules/nixos
    {
      nixpkgs.overlays = overlays;

      # Hardware
      physical = true;
      networking.hostName = "tempest";

      # Not sure what's necessary but too afraid to remove anything
      boot.initrd.availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];

      # Graphics and VMs
      boot.initrd.kernelModules = [ "amdgpu" ];
      boot.kernelModules = [ "kvm-amd" ];
      services.xserver.videoDrivers = [ "amdgpu" ];

      # Required binary blobs to boot on this machine
      hardware.enableRedistributableFirmware = true;

      # Prioritize performance over efficiency
      powerManagement.cpuFreqGovernor = "performance";

      # Allow firmware updates
      hardware.cpu.amd.updateMicrocode = true;

      # Helps reduce GPU fan noise under idle loads
      hardware.fancontrol.enable = true;
      hardware.fancontrol.config = ''
        # Configuration file generated by pwmconfig, changes will be lost
        INTERVAL=10
        DEVPATH=hwmon0=devices/pci0000:00/0000:00:03.1/0000:06:00.0/0000:07:00.0/0000:08:00.0
        DEVNAME=hwmon0=amdgpu
        FCTEMPS=hwmon0/pwm1=hwmon0/temp1_input
        FCFANS= hwmon0/pwm1=hwmon0/fan1_input
        MINTEMP=hwmon0/pwm1=50
        MAXTEMP=hwmon0/pwm1=70
        MINSTART=hwmon0/pwm1=100
        MINSTOP=hwmon0/pwm1=10
        MINPWM=hwmon0/pwm1=10
        MAXPWM=hwmon0/pwm1=240
      '';

      # File systems must be declared in order to boot

      # This is the root filesystem containing NixOS
      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

      # This is the boot filesystem for Grub
      fileSystems."/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
      };

      # Secrets must be prepared ahead before deploying
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;

      # Theming

      # Turn on all features related to desktop and graphical applications
      gui.enable = true;

      # Set the system-wide theme, also used for non-graphical programs
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      wallpaper = "${inputs.wallpapers}/gruvbox/road.jpg";
      gtk.theme.name = inputs.nixpkgs.lib.mkDefault "Adwaita-dark";

      # Programs and services
      charm.enable = true;
      neovim.enable = true;
      media.enable = true;
      dotfiles.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      _1password.enable = true;
      discord.enable = true;
      nautilus.enable = true;
      obsidian.enable = true;
      mail.enable = true;
      mail.aerc.enable = true;
      mail.himalaya.enable = true;
      keybase.enable = true;
      mullvad.enable = false;
      nixlang.enable = true;
      rust.enable = true;
      yt-dlp.enable = true;
      gaming = {
        dwarf-fortress.enable = true;
        enable = true;
        steam.enable = true;
        legendary.enable = false; # Electron marked as insecure
        lutris.enable = true;
        leagueoflegends.enable = true;
        ryujinx.enable = true;
      };
      services.vmagent.enable = true; # Enables Prometheus metrics
      services.openssh.enable =
        true; # Required for Cloudflare tunnel and identity file

      # Allows private remote access over the internet
      cloudflareTunnel = {
        enable = true;
        id = "ac133a82-31fb-480c-942a-cdbcd4c58173";
        credentialsFile = ../../private/cloudflared-tempest.age;
        ca =
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPY6C0HmdFCaxYtJxFr3qV4/1X4Q8KrYQ1hlme3u1hJXK+xW+lc9Y9glWHrhiTKilB7carYTB80US0O47gI5yU4= open-ssh-ca@cloudflareaccess.org";
      };

      # Allows requests to force machine to wake up
      # This network interface might change, needs to be set specifically for each machine.
      # Or set usePredictableInterfaceNames = false
      networking.interfaces.enp5s0.wakeOnLan.enable = true;

    }
  ];
}
