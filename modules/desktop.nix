{
  config,
  lib,
  ...
}:
let
  cfg = config.nixpii.system.desktop;
in
{
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
    })

    (lib.mkIf cfg.hyprland.enable {
      programs.hyprland.enable = true;
    })

    (lib.mkIf cfg.cosmic.enable {
      services.desktopManager.cosmic.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;
    })

  ];
}
