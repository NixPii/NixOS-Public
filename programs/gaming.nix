{
  config,
  lib,
  pkgs,
  nixpkgs-stable,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.millennium.overlays.default];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
    gamescopeSession = {
      enable = true;
      args = ["-O" "DP-2"];
    };
    package = pkgs.millennium-steam.override {
      extraProfile = ''
        # Allows Monado/WiVRn to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # Fixes timezones on VRChat
        unset TZ
      '';
    };
    extraCompatPackages = with pkgs; [
      steamtinkerlaunch
      proton-ge-bin
    ];
  };

  # Gamemode
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  # Unstable Pkgs
  environment.systemPackages = with pkgs; [
    # Steam
    steamcmd
    steam-tui
    adwsteamgtk
    archisteamfarm
    steamtinkerlaunch
    steam-run
    pkgsCross.mingw32.wine-discord-ipc-bridge
    satisfactorymodmanager

    # Launchers
    heroic
    lutris
    mangohud
    vulkan-loader
    protontricks
    protonplus
    (bottles.override {removeWarningPopup = true;})

    # Vr
    nixpkgs-stable.wayvr
    slimevr

    # Wine
    wineWow64Packages.stagingFull
    wineWow64Packages.fonts
    winetricks

    # Roblox Stuff
    vinegar
  ];

  environment.sessionVariables = {
    WINEPREFIX = "$HOME/.wine";
    WINEARCH = "win64";

    OBS_VKCAPTURE = "1";
  };

  # Nix-LD for Non-NixOS games & such

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Default
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd

      # XORG
      libXcomposite
      libXtst
      libXrandr
      libXext
      libX11
      libXfixes
      libGL
      libva
      pipewire
      libxcb
      libXdamage
      libxshmfence
      libXxf86vm
      libelf
      libxcrypt
      libXinerama
      libXcursor
      libXrender
      libXScrnSaver
      libXi
      libSM
      libICE
      libXt
      libXmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew_1_10
      libidn
      tbb
      libXft
      libvdpau

      # Required
      glib
      gtk2
      gtk3

      # Steam
      networkmanager
      vulkan-loader
      libgbm
      libdrm
      coreutils
      pciutils
      zenity
      glibc_multi.bin

      # Extra
      dconf
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      ffmpeg
      libudev0-shim

      # needed to run unity
      gtk3
      icu
      libnotify
      gsettings-desktop-schemas

      # Wiki suggests this, and i want to be thorough
      flac
      freeglut
      libjpeg
      libpng
      libpng12
      libsamplerate
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      dbus
      alsa-lib
      expat
      libxkbcommon

      # AppImages
      fuse3
      e2fsprogs
      gmp

      # Qt6
      libpulseaudio
      krb5
      libxcb-cursor
      xcbutilwm
      xcbutil
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
    ];
  };
}
