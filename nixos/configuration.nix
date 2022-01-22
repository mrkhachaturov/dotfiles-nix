# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 250;
    autoRepeatInterval = 40;

    # desktopManager = {
    # xterm.enable = false;
    # xfce.enable = true;
    # };
    # displayManager.defaultSession = "xfce";
    windowManager = { awesome = { enable = true; }; };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Disable mouse acceleration
    libinput.mouse.accelProfile = "flat";
    libinput.mouse.accelSpeed = "1.5";

    # Configure keymap in X11
    layout = "us";
    xkbOptions = "eurosign:e,caps:swapescape";
  };

  # Mouse config
  services.ratbagd.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;

    # Sound card drivers
    alsa = {
      enable = true;
      support32Bit = true;
    };

    # PulseAudio emulation
    pulse.enable = true;
  };

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 \
                                        --mode 1920x1200 \
                                        --pos 1920x0 \
                                        --rotate left \
                                    --output HDMI-0 \
                                        --primary \
                                        --mode 1920x1080 \
                                        --pos 0x559 \
                                        --rotate normal \
                                    --output DVI-0 --off \
                                    --output DVI-1 --off \
  '';

  # Install fonts
  fonts.fonts = with pkgs; [ victor-mono nerdfonts ];
  fonts.fontconfig.defaultFonts.monospace = [ "Victor Mono" ];

  # Gaming
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  hardware.steam-hardware.enable = true;

  # Replace sudo with doas
  security = {

    # Remove sudo
    sudo.enable = false;

    # Add doas
    doas = {
      enable = true;

      # No password required
      wheelNeedsPassword = false;

      # Pass environment variables from user to root
      # Also requires removing password here
      extraRules = [{
        groups = [ "wheel" ];
        noPass = true;
        keepEnv = true;
      }];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noah = {

    # Not sure what this means tbh
    isNormalUser = true;

    # Automatically create a password to start
    initialPassword = "changeme";

    # Enable sudo privileges
    extraGroups = [ "wheel" ];

    # Use the fish shell
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish
    vim
    wget
    curl
    home-manager
    xclip
    pamixer

    # Mouse config
    libratbag
    piper

    steam
  ];

  location = {
    latitude = 40.0;
    longitude = 74.0;
  };

  services.redshift = { enable = true; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
