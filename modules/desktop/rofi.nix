{ config, pkgs, lib, ... }:

{

  config = lib.mkIf config.services.xserver.enable {

    home-manager.users.${config.user}.programs.rofi = {
      enable = true;
      cycle = true;
      location = "center";
      pass = { };
      plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = let
        inherit (config.home-manager.users.${config.user}.lib.formats.rasi)
          mkLiteral;
      in {

        # Inspired by https://github.com/sherubthakur/dotfiles/blob/master/users/modules/desktop-environment/rofi/launcher.rasi

        "*" = {
          background-color = mkLiteral config.gui.colorscheme.base00;
          foreground-color = mkLiteral config.gui.colorscheme.base07;
          text-color = mkLiteral config.gui.colorscheme.base07;
          border-color = mkLiteral config.gui.colorscheme.base04;
          width = 512;
        };

        # Holds the entire window
        "#window" = {
          transparency = "real";
          background-color = mkLiteral config.gui.colorscheme.base00;
          text-color = mkLiteral config.gui.colorscheme.base07;
          border = mkLiteral "4px";
          border-color = mkLiteral config.gui.colorscheme.base04;
          border-radius = mkLiteral "4px";
          width = mkLiteral "600px";
          x-offset = 10;
          y-offset = 40;
          padding = mkLiteral "15px";
        };

        # Wrapper around bar and results
        "#mainbox" = {
          background-color = mkLiteral config.gui.colorscheme.base00;
          border = mkLiteral "0px";
          border-radius = mkLiteral "0px";
          border-color = mkLiteral config.gui.colorscheme.base04;
          children = map mkLiteral [ "inputbar" "listview" ];
          spacing = mkLiteral "10px";
          padding = mkLiteral "10px";
        };

        # Unknown
        "#textbox-prompt-colon" = {
          expand = false;
          str = ":";
          margin = mkLiteral "0px 0.3em 0em 0em";
          text-color = mkLiteral config.gui.colorscheme.base07;
        };

        # Command prompt left of the input
        "#prompt" = { enabled = false; };

        # Actual text box
        "#entry" = {
          placeholder-color = mkLiteral config.gui.colorscheme.base03;
          expand = true;
          horizontal-align = "0";
          placeholder = "Search Applications";
          padding = mkLiteral "0px 0px 0px 5px";
          blink = true;
        };

        # Top bar
        "#inputbar" = {
          children = map mkLiteral [ "prompt" "entry" ];
          border = mkLiteral "1px";
          border-radius = mkLiteral "4px";
          padding = mkLiteral "6px";
        };

        # Results
        "#listview" = {
          background-color = mkLiteral config.gui.colorscheme.base00;
          padding = mkLiteral "0px";
          columns = 1;
          lines = 8;
          spacing = "5px";
          cycle = true;
          dynamic = true;
          layout = "vertical";
        };

        # Each result
        "#element" = {
          orientation = "vertical";
          border-radius = mkLiteral "0px";
          padding = mkLiteral "5px 0px 5px 5px";
        };
        "#element.selected" = {
          border = mkLiteral "1px";
          border-radius = mkLiteral "4px";
          border-color = mkLiteral config.gui.colorscheme.base07;
          background-color = mkLiteral config.gui.colorscheme.base04;
          text-color = mkLiteral config.gui.colorscheme.base00;
        };

        "#element-text" = {
          expand = true;
          # horizontal-align = mkLiteral "0.5";
          vertical-align = mkLiteral "0.5";
          margin = mkLiteral "0px 2.5px 0px 2.5px";
        };
        "#element-text.selected" = {
          background-color = mkLiteral config.gui.colorscheme.base04;
          text-color = mkLiteral config.gui.colorscheme.base00;
        };

        # Not sure how to get icons
        "#element-icon" = {
          size = mkLiteral "64px";
          border = mkLiteral "0px";
          background-color = mkLiteral config.gui.colorscheme.base00;
        };
        "#element-icon.selected" = {
          background-color = mkLiteral config.gui.colorscheme.base04;
          text-color = mkLiteral config.gui.colorscheme.base00;
        };

      };
      xoffset = 0;
      yoffset = 0;
      extraConfig = { kb-cancel = "Escape,Super+space"; };
    };
    gui.launcherCommand = "${pkgs.rofi}/bin/rofi -show run";

  };

}

