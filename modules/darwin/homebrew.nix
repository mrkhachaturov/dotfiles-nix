{ config, ... }: {

  homebrew = {
    enable = true;
    autoUpdate = false; # Don't update during rebuild
    cleanup = "zap"; # Uninstall all programs not declared
    taps = [
      "homebrew/cask" # Required for casks
      "homebrew/cask-drivers" # Used for Logitech G-Hub
    ];
    brews = [
      "trash" # Delete files and folders to trash instead of rm
    ];
    casks = [
      "firefox" # Firefox packaging on Nix is broken for MacOS
      "1password" # 1Password packaging on Nix is broken for MacOS
      "scroll-reverser" # Different scroll style for mouse vs. trackpad
      "meetingbar" # Show meetings in menu bar
      "gitify" # Git notifications in menu bar
      "logitech-g-hub" # Mouse and keyboard management
      "mimestream" # Gmail client
    ];
    global.brewfile = true; # Run brew bundle from anywhere
    global.noLock = true; # Don't save lockfile (since running from anywhere)
  };

  home-manager.users.${config.user} = {

    home.activation = {

      # Always install homebrew if it doesn't exist
      installHomeBrew =
        config.home-manager.users.${config.user}.lib.dag.entryAfter
        [ "writeBoundary" ] ''
          if ! xcode-select --version 2>/dev/null; then
            xcode-select --install
          fi
          if ! /usr/local/bin/brew --version 2>/dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          fi
        '';

    };

  };

}
