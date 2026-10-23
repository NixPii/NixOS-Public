{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.nixpii.system.desktop;
in {
  options.nixpii.system.desktop = {
    plasma6.enable = lib.mkEnableOption "Enable Plasma 6";

    gnome.enable = lib.mkEnableOption "Enable GNOME";

    niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;

      description = ''
        Enable Niri
      '';
    };

    hyprland.enable = lib.mkEnableOption "Enable hyprland";

    cosmic = {
      enable = lib.mkEnableOption "Enable COSMIC";
    };

    noctalia = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "nixpkg"
          "flake"
          "disabled"
        ]
      );
      default = "disabled";

      description = ''

        Enable the Noctalia shell for Window Managers

        The avalible options are:
        nixpkgs - Enables the version located in nixpkgs
        flake - Enable tracking main from the Noctalia repo via the flake
        disabled (default) - Disabled, does not build noctalia
      '';
    };
  };

  config = lib.mkMerge [
    # KDE Plasma
    (lib.mkIf cfg.plasma6.enable {
      services.desktopManager.plasma6.enable = true;
    })

    # GNOME
    (lib.mkIf cfg.gnome.enable {
      services.desktopManager.gnome.enable = true;
    })

    (lib.mkIf cfg.niri.enable {
      programs.niri.enable = true;

      # XDG workaround
      xdg.portal = {
        config = {
          common = {
            default = ["gtk"];
          };

          niri = {
            # Niri XDG Config
            "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          };

          kde = {
            default = ["kde"];
          };

          cosmic = {
            default = ["cosmic"];
          };
        };
      };

      services.displayManager.defaultSession = lib.mkForce "niri";
    })

    (lib.mkIf cfg.hyprland.enable {
      programs.hyprland.enable = true;
    })

    (lib.mkIf cfg.cosmic.enable {
      services.desktopManager.cosmic.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;
    })

    (lib.mkIf (cfg.noctalia == "nixpkg") {
      environment.systemPackages = with pkgs; [
        noctalia-shell
      ];
    })

    (lib.mkIf (cfg.noctalia == "flake") {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    })
  ];
}
