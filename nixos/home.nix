{ pkgs, ... }:

let

  # Import unstable channel (for Neovim 0.5)
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

in

{
  home.packages = with pkgs; [
    firefox
    unzip
    # alacritty
    # unstable.neovim
    tmux
    rsync
    ripgrep
    bat
    fd
    exa
    sd
    jq
    tealdeer
    unstable._1password-gui
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
        size = 15.0;
      };
      key_bindings = [
        {
          key = "F";
          mods = "Super";
          action = "ToggleFullscreen";
        }
        {
          key = "L";
          mods = "Super";
          chars = "\x1F";
        }
      ];
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
      v = "vim";
      vl = "vim -c 'normal! `0'";
      vll = "vim -c 'Hist'";

      # Notes
      qn = "quicknote";
      sn = "syncnotes";
      to = "today";
      work = "vim $NOTES_PATH/work.md";

      # Improved CLI Tools
      cat = "bat";          # Swap cat with bat
      h = "http -Fh --all"; # Curl site for headers

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
    #"alacritty/alacritty.yml".source = ../alacritty.configlink/alacritty.yml;
    # "nvim/init.lua".source = ../nvim.configlink/init.lua;
  };

  # nixpkgs.overlays = [(
  #   self: super: {
  #     neovim = unstable.neovim;
  #   })
  # ];
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      fzfWrapper
      vim-eunuch
      vim-vinegar
      surround
      commentary
      repeat
      gruvbox-nvim
      nvim-lspconfig
      lsp-colors-nvim
      vim-vsnip
      vim-vsnip-integ
      nvim-compe
      tabular
      vimwiki
      vim-rooter
      lualine-nvim
      nvim-web-devicons
      nvim-treesitter
      vim-fish
      nginx-vim
      vim-terraform
      vim-toml
      vim-helm
      vim-nix
      gitsigns-nvim
      plenary-nvim
      vim-hexokinase
    ];
    extraPackages = with pkgs; [
      nodePackages.pyright
      rust-analyzer
      terraform-ls
    ];
    extraConfig = ''
      lua << EOF
        ${builtins.readFile ./init.lua}
      EOF
    '';
  };

  # # Neovim config
  # home.file = {
  #   ".config/nvim/init.lua".source = ../nvim.configlink/init.lua;
  # };

  programs.git = {
    enable = true;
    userName = "Noah Masur";
    userEmail = "7386960+nmasur@users.noreply.github.com";
    extraConfig = {
      core = {
        editor = "nvim";
      };
    };
  };
}
