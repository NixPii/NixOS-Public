{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

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
      thunar-volman
      thunar-archive-plugin
      thunar-vcs-plugin
      thunar-media-tags-plugin
    ];
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    ddcutil
    ddcutil-service
    pavucontrol
    ffmpeg
    telegram-desktop
    qbittorrent
    kdePackages.kcalc
    scrcpy
    signal-desktop
    networkmanager-openconnect
    openvpn
    mc
    btop
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
    zsh-autosuggestions
    grim
    slurp
    curlFull
    coreutils-full
    kdePackages.ark
    bat
    python314Packages.pygments
    mission-center
    luajit
    luajitPackages.nvim-cmp
    vimPlugins.image-nvim
    bibata-cursors
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
    freerdp
    dialog
    hw-probe
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

    # Polkit
    polkit
    polkit_gnome
    mate-polkit

    # Xwayland
    xwayland
    wayback-x11

    # NVIM
    nodejs
    python3
    gcc
    gnumake
    unzip
    git

    # Neat
    img4lib
    yt-dlp
    easyeffects
    hyfetch

    # Java Development Kit (JDK)
    jdk25

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

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

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

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = false;

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
