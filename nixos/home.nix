{ pkgs, ... }:

let

    # Nothing

in

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    firefox
    unzip
    neovim
    gcc # for tree-sitter
    alacritty
    tmux
    rsync
    ripgrep
    bat
    fd
    exa
    sd
    jq
    tealdeer
    _1password-gui
    discord
    gh
    /* neomutt */
    himalaya # Email
    mpv  # Video viewer
    sxiv # Image viewer
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dimensions = {
          columns = 85;
          lines = 30;
        };
        padding = {
          x = 20;
          y = 20;
        };
      };
      scrolling.history = 10000;
      font = {
        size = 14.0;
        normal = {
          family = "Victor Mono";
        };
      };
      key_bindings = [
        /* { */
        /*   key = "F"; */
        /*   mods = "Super"; */
        /*   action = "ToggleFullscreen"; */
        /* } */
        {
          key = "L";
          mods = "Control|Shift";
          chars = "\\x1F";
        }
      ];
      colors = {
        primary = {
          background = "0x1d2021";
          foreground = "0xd5c4a1";
        };
        cursor = {
          text = "0x1d2021";
          cursor = "0xd5c4a1";
        };
        normal = {
          black =   "0x1d2021";
          red =     "0xfb4934";
          green =   "0xb8bb26";
          yellow =  "0xfabd2f";
          blue =    "0x83a598";
          magenta = "0xd3869b";
          cyan =    "0x8ec07c";
          white =   "0xd5c4a1";
        };
        bright = {
          black =   "0x665c54";
          red =     "0xfe8019";
          green =   "0x3c3836";
          yellow =  "0x504945";
          blue =    "0xbdae93";
          magenta = "0xebdbb2";
          cyan =    "0xd65d0e";
          white =   "0xfbf1c7";
        };
      };
      draw_bold_text_with_bright_colors = false;
    };
  };

  programs.fish = {
    enable = true;
    functions = {};
    interactiveShellInit = "";
    loginShellInit = "";
    shellAbbrs = {

      # Directory aliases
      l = "ls";
      lh = "ls -lh";
      ll = "ls -alhF";
      lf = "ls -lh | fzf";
      c = "cd";
      # -- - = "cd -";
      mkd = "mkdir -pv";

      # Tmux
      ta = "tmux attach-session";
      tan = "tmux attach-session -t noah";
      tnn = "tmux new-session -s noah";

      # Git
      g = "git";
      gs = "git status";
      gd = "git diff";
      gds = "git diff --staged";
      gdp = "git diff HEAD^";
      ga = "git add";
      gaa = "git add -A";
      gac = "git commit -am";
      gc = "git commit -m";
      gca = "git commit --amend";
      gu = "git pull";
      gp = "git push";
      gpp = "git_set_upstream";
      gl = "git log --graph --decorate --oneline -20";
      gll = "git log --graph --decorate --oneline";
      gco = "git checkout";
      gcom = "git switch master";
      gcob = "git switch -c";
      gb = "git branch";
      gbd = "git branch -d";
      gbD = "git branch -D";
      gr = "git reset";
      grh = "git reset --hard";
      gm = "git merge";
      gcp = "git cherry-pick";
      cdg = "cd (git rev-parse --show-toplevel)";

      # GitHub
      ghr = "gh repo view -w";
      gha = "gh run list | head -1 | awk \'{ print $(NF-2) }\' | xargs gh run view";
      grw = "gh run watch";
      grf = "gh run view --log-failed";
      grl = "gh run view --log";

      # Vim
      v = "nvim";
      vl = "nvim -c 'normal! `0'";
      vll = "nvim -c 'Telescope oldfiles'";
      vimrc = "nvim ~/dev/personal/dotfiles/nvim.configlink/init.lua";

      # Notes
      qn = "quicknote";
      sn = "syncnotes";
      to = "today";
      work = "vim $NOTES_PATH/work.md";

      # Improved CLI Tools
      cat = "bat";          # Swap cat with bat
      h = "http -Fh --all"; # Curl site for headers
      j = "just";

      # Fun CLI Tools
      weather = "curl wttr.in/$WEATHER_CITY";
      moon = "curl wttr.in/Moon";

      # Cheat Sheets
      ssl = "openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr";
      fingerprint = "ssh-keyscan myhost.com | ssh-keygen -lf -";
      publickey = "ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub";
      forloop = "for i in (seq 1 100)";

      # Docker
      dc = "$DOTS/bin/docker_cleanup";
      dr = "docker run --rm -it";
      db = "docker build . -t";

      # Terraform
      te = "terraform";

      # Kubernetes
      k = "kubectl";
      pods = "kubectl get pods -A";
      nodes = "kubectl get nodes";
      deploys = "kubectl get deployments -A";
      dash = "kube-dashboard";
      ks = "k9s";

      # Python
      py = "python";
      po = "poetry";
      pr = "poetry run python";

      # Rust
      ca = "cargo";

    };
    shellAliases = {};
    shellInit = "";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    fish_greeting = "";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Other configs
  xdg.configFile = {
    "starship.toml".source = ../starship/starship.toml.configlink;
    "nvim/init.lua".source = ../nvim.configlink/init.lua;
    "fish/functions".source = ../fish.configlink/functions;
    "awesome/rc.lua".source = ./rc.lua;
  };

  programs.git = {
    enable = true;
    userName = "Noah Masur";
    userEmail = "7386960+nmasur@users.noreply.github.com";
    extraConfig = {
      core = {
        editor = "nvim";
      };
      pager = {
        branch = "false";
      };
    };
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings.git_protocol = "https";
  };

  # Email
  /* programs.himalaya = { */
  /*   enable = true; */
  /*   settings = { */
  /*     name = "Noah Masur"; */
  /*     downloads-dir = "~/Downloads"; */
  /*     home = { */
  /*       default = true; */
  /*       email = "censored"; */
  /*       imap-host = "censored"; */
  /*       imap-port = 993; */
  /*       imap-login = "censored"; */
  /*       imap-passwd-cmd = "cat ~/.config/himalaya/passwd"; */
  /*       smtp-host = "censored"; */
  /*       smtp-port = 587; */
  /*       smtp-login = "censored"; */
  /*       smtp-passwd-cmd = "cat ~/.config/himalaya/passwd"; */
  /*     }; */
  /*   }; */
  /* }; */
}
