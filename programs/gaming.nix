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
    package = pkgs.steam.override {
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
    steamtinkerlaunch
    steam-run
    pkgsCross.mingw32.wine-discord-ipc-bridge

    # Launchers
    heroic
    lutris
    mangohud
    vulkan-loader
    protontricks
    protonplus
    (bottles.override {removeWarningPopup = true;})

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
      # C / C++ runtime
      stdenv.cc.cc

      # Common compression
      zlib
      zstd
      bzip2
      xz

      # Networking / TLS
      openssl
      curl

      # Common runtime libraries
      glib
      libxml2
      util-linux
      systemd
    ];
  };
}
