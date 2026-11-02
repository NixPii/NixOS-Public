{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.nixpii.system.gaming;

  # Steam
  steam = cfg.steam;
  steamFull = steam.variant == "full";

  steamBasePackage = if steam.millennium.enable then pkgs.millennium-steam else pkgs.steam;

  steamFullPackage = steamBasePackage.override {
    extraLibraries =
      p: with p; [
        libvdpau
        libpulseaudio
        libxkbcommon
        libXcursor
        libXi
        libXinerama
        libXScrnSaver
        libXrandr
        libpng
        libvorbis
        libkrb5
        keyutils
        stdenv.cc.cc.lib
      ];
    extraProfile = ''
      # Allows Monado/WiVRn to be used
      export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
      # Fixes timezones on VRChat
      unset TZ
    '';
  };
in
{
  options.nixpii.system.gaming = {
    # Steam
    steam = {
      enable = lib.mkEnableOption "Steam";

      variant = lib.mkOption {
        type = lib.types.enum [
          "full"
          "minimal"
        ];
        default = "full";
        description = ''
          "full" adds VR/OpenXR support, extra libraries, Proton-GE,
          SteamTinkerLaunch and protontricks. "minimal" is plain Steam.
        '';
      };

      millennium.enable = lib.mkEnableOption "the Millennium Steam client";
    };

    minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft support via Prism Launcher";
      lunar.enable = lib.mkEnableOption "Enable Lunar Client";

      jdks = lib.mkOption {
        type = lib.types.listOf lib.types.pkgs;
        default = with pkgs; [
          jdk8
          jdk11
          jdk17
          jdk21
          jdk25
        ];
        defaultText = "with pkgs; [ jdk8 jdk11 jdk17 jdk21 jdk25 ]";
        description = "List of JDKs to install for Minecraft";
      };
    };

    # Gamemode
    gamemode.enable = lib.mkEnableOption "Enable or disable Feral GameMode";

  };

  config = lib.mkMerge [
    # Steam
    (lib.mkIf steam.enable (
      lib.mkMerge [
        {
          nixpkgs.overlays = lib.optional steam.millennium.enable inputs.millennium.overlays.default;

          programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
            package = if steamFull then steamFullPackage else steamBasePackage;
          };
        }

        (lib.mkIf steamFull {
          programs.steam = {
            protontricks.enable = true;
            extraPackages = [ pkgs.hidapi ];
            extraCompatPackages = with pkgs; [
              steamtinkerlaunch
              proton-ge-bin
            ];
          };
        })
      ]
    ))

    # Gamemode
    (lib.mkIf cfg.gamemode.enable {
      programs.gamemode = {
        enable = true;
      };
      environment.systemPackages = [ pkgs.gamemode ];
    })

    (lib.mkIf cfg.minecraft.enable {
      environment.systemPackages = [
        pkgs.prismlauncher
      ]
      ++ lib.optional cfg.minecraft.lunar.enable pkgs.lunarclient
      ++ lib.optional cfg.minecraft.enable cfg.minecraft.jdks;

    })

  ];
}
