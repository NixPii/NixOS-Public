{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  home.username = "nixpii";
  home.homeDirectory = "/home/nixpii";
  home.stateVersion = "26.05";

  home.language = {
    base = "en_GB.UTF-8";
    time = "en_GB.UTF-8";
    monetary = "hu_HU.UTF-8";
    paper = "hu_HU.UTF-8";
    measurement = "hu_HU.UTF-8";
  };

  imports = [
    ./home/theming.nix
    ./home/home-packages.nix
    ./home/unity.nix
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      PS1='\u@\[\e[92m\]\H\[\e[0m\] \w\n> '
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      #colors = {
      #background = "1e1e2edd";
      #text = "cdd6f4ff";
      #prompt = "bac2deff";
      #placeholder = "7f849cff";
      #input = "cdd6f4ff";
      #match = "eba0acff";
      #selection = "585b70ff";
      #selection-text = "cdd6f4ff";
      #selection-match = "eba0acff";
      #counter = "7f849cff";
      #  border = "eba0acff";
      #};
    };
  };
  fonts.fontconfig.enable = true;

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Catppuccin Macchiato";
      font-family = "0xProto Nerd Font";
      keybind = [
        "ctrl+t=new_tab"
      ];
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Macchiato";
    font = {
      name = "0xProto Nerd Font";
      size = 12;
    };
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      # Main Nix things
      rebuild = "nh os switch";
      test = "nh os test";
      nix-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixie";
      nix-test = "sudo nixos-rebuild test --flake /etc/nixos#nixie";

      # Git
      git-commit = "pushd /etc/nixos && git add . &&  git commit -m 'update' && popd";
      github-push = "pushd /etc/nixos && git add . && git commit -m 'Github push' && git push -u origin main && popd";
      gpush = "cd ~/.nixos && git add -u && git add .gitignore && echo -n 'Enter commit message: ' && read msg && git commit -m \"$msg\" && git push origin main";

      # Flake based things
      flake-update = "pushd /etc/nixos && sudo nix flake update && popd";
      update = "nh os switch --update";
      fullupdate = "flatpak update && nh os switch --update ";
      nix-update = "pushd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake .#nixie && popd";
      fullupdate-nix = "flatpak update && pushd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake .#nixie && popd";

      # Garbage collection
      garbage-collect = "nix-collect-garbage --delete-older-than 7d";
      garbage-weekly = "nix-collect-garbage --delete-older-than 7d";
      optimise = "nix-store --optimise";
      garbage-collect-all = "nix-collect-garbage -d";

      # QoL
      ls = "eza --color=always --group-directories-first --icons --hyperlink --show-symlinks";
      la = "eza -al --color=always --group-directories-first --icons --binary --group --hyperlink --show-symlinks";
      ll = "eza -l --color=always --group-directories-first --icons --hyperlink";
      "l." = "eza -ald --color=always --group-directories-first --icons --hyperlink .*";
      lt = "eza -lT --color=always --group-directories-first --icons --binary --group --hyperlink --show-symlinks";
      c = "clear";
      v = "nvim";
      vim = "nvim";

      # My BS
      togif = "/home/nixpii/Documents/scripts/to_gif.sh";
      togames = "/home/nixpii/Documents/scripts/to-games.sh";
      download-memes = "/home/nixpii/Documents/scripts/go/to-memes";
      yt-mp4 = "/home/nixpii/Documents/scripts/yt-mpx.sh 4 ";
      yt-mp3 = "/home/nixpii/Documents/scripts/yt-mpx.sh 3 ";
    };

    oh-my-zsh = {
      # Oh My ZSH fuckery
      enable = true;
      plugins = [
        "aliases"
        "alias-finder"
        "catimg"
        "colorize"
        "colored-man-pages"
        "common-aliases"
        "conda"
        "conda-env"
        "copypath"
        "docker"
        "docker-compose"
        "dotnet"
        "emoji"
        "fzf"
        "docker"
        "pyenv"
        "python"
        "sudo"
        "tailscale"
        "zsh-interactive-cd"
        "copyfile"
        "copybuffer"
        "dirhistory"
        "colorize"
        "command-not-found"
        "git"
        "git-auto-fetch"
        "git-commit"
        "git-escape-magic"
        "git-extras"
        "gitfast"
        "git-flow"
        "github"
        "gitignore"
        "git-prompt"
        "gpg-agent"
        "gradle"
        "history"
        "history-substring-search"
        "kate"
        "man"
        "nmap"
        "perms"
        "qrcode"
        "safe-paste"
        "screen"
        "ssh"
        "ssh-agent"
        "sudo"
        "themes"
        "torrent"
        "vi-mode"
        "golang"
      ];
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "catppuccin";
  };

  programs.onlyoffice = {
    enable = true;
    settings = {
      UITheme = "theme-contrast-dark";
      titlebar = "OnlyOffice";
    };
  };

  programs.librewolf = {
    enable = false;
    languagePacks = [
      "en-GB"
      "de"
      "hu"
      "ru"
      "en-US"
    ];

    settings = {
      "webgl.disabled" = false;
      "webgl.prompt" = true;
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
      "privacy.resistFingerprinting" = true;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "1e1e2e";
      bs-hl-color = "f5e0dc";
      caps-lock-bs-hl-color = "f5e0dc";
      caps-lock-key-hl-color = "a6e3a1";
      inside-color = "1e1e2e";
      inside-clear-color = "1e1e2e";
      inside-caps-lock-color = "1e1e2e";
      inside-ver-color = "1e1e2e";
      inside-wrong-color = "1e1e2e";
      key-hl-color = "a6e3a1";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cdd6f4";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "313244";
      ring-clear-color = "f5e0dc";
      ring-caps-lock-color = "fab387";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "eba0ac";
      separator-color = "00000000";
      text-color = "cdd6f4";
      text-clear-color = "f5e0dc";
      text-caps-lock-color = "fab387";
      text-ver-color = "89b4fa";
      text-wrong-color = "eba0ac";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  services.swaync.enable = true;

  programs.vesktop = {
    enable = true;
  };

  xdg.configFile."openvr/openvrpaths.vrpath".text = let
    steam = "${config.xdg.dataHome}/Steam";
  in
    builtins.toJSON {
      version = 1;
      jsonid = "vrpathreg";

      external_drivers = null;
      config = ["${steam}/config"];

      log = ["${steam}/logs"];

      runtime = [
        "${pkgs.opencomposite}/lib/opencomposite"
      ];
    };

  home.packages = with pkgs; [];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
