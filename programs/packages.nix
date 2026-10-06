{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  # Script Kiddie stuff
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = false;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/nixpii/NixOS-Public"; # sets NH_OS_FLAKE variable for you, this config assumes it's in your home
  };

  # File Manager
  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
      thunar-archive-plugin
      thunar-vcs-plugin
      thunar-media-tags-plugin
    ];
  };

  programs.yazi.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    ddcutil
    ddcutil-service
    pavucontrol
    mpv
    ffmpeg
    wireguard-tools
    telegram-desktop
    qbittorrent
    kdePackages.kcalc
    scrcpy
    signal-desktop
    networkmanager-openconnect
    openvpn
    mc
    btop
    vlc
    docker-compose
    file
    dnsutils
    inetutils
    lm_sensors
    smartmontools
    fwupd-efi
    wl-clipboard
    gh
    remmina
    corefonts
    calf
    networkmanagerapplet
    swaybg
    playerctl
    cliphist
    adwaita-icon-theme
    brightnessctl
    fastfetch
    pay-respects
    zsh-autosuggestions
    grim
    slurp
    curlFull
    unzip
    coreutils-full
    kdePackages.ark
    bat
    python314Packages.pygments
    mission-center
    luajit
    luajitPackages.nvim-cmp
    vimPlugins.image-nvim
    bibata-cursors
    gamemode
    swaybg
    gparted-full
    clinfo
    kdePackages.filelight
    libpcap
    libslirp
    ghostscript
    quickemu
    libnotify
    proton-vpn-cli
    libsecret
    wireguard-tools
    bluez-experimental
    libinput
    freerdp
    dialog
    hw-probe
    lm_sensors
    pciutils
    eza
    fzf
    boxbuddy
    proton-vpn
    libheif
    libheif.out
    xfce4-exo
    qt6Packages.qt6ct

    # Art programs
    krita
    gimp-with-plugins

    # Btrfs
    btrfs-assistant

    # browsers
    ungoogled-chromium
    librewolf
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Polkit
    polkit
    polkit_gnome
    mate-polkit

    # Xwayland
    xwayland
    wayback-x11
    xeyes

    # NVIM
    nodejs
    python3
    gcc
    gnumake
    unzip
    curl
    git

    # Discord
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    # Neat
    img4lib
    yt-dlp
    easyeffects
    hyfetch

    # MC
    prismlauncher
    lunar-client
    jdk8
    jdk11
    jdk17
    jdk21

    # Fun :D
    cmatrix
    sl
    lolcat
    pay-respects
    cowsay
    fortune
    cava
    jp2a
    crosspipe
    waypaper
    timg
    inkscape-with-extensions

    # Resolve
    distrobox
    distroshelf

    # LSP
    nixd
    basedpyright
    gopls

    # VR + Android
    android-tools
    usbutils

    # Extra
    tor-browser
    element-desktop

    # X-server
    xterm
    xclock
    xeyes
    xsetroot
    xmessage
    dmenu
    xrandr
    feh
    xinit
    libinput
    xorg-server

    # GST
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    ffmpegthumbnailer

    # CPU
    stress-ng
    corectrl

    # Programming
    go
    gotools
    go-tools
    conda

    # NixOS
    nvd
    nix-output-monitor

    ripgrep
    hyprpicker

    # END OF APPS
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;

    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.icu
        pkgs.libxcrypt-legacy
        pkgs.python312
      ];
    };
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  virtualisation = {
    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
