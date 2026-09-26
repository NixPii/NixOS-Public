{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.desktop;
in {
  options.nixpii.desktop = {
    plasma6.enable =
      lib.mkEnableOption ''
        Enable Plasma 6'';

    gnome.enable =
      lib.mkEnableOption ''
        Enable GNOME'';

    niri.enable =
      lib.mkEnableOption ''
        Enable Niri'';

    hyprland.enable =
      lib.mkEnableOption ''
        Enable hyprland'';
  };

  config = lib.mkMerge [
    # KDE Plasma
    (
      lib.mkIf cfg.plasma6.enable
      {
        services.desktopManager.plasma6.enable = true;
      }
    )

    # GNOME
    (
      lib.mkIf cfg.gnome.enable {
        services.desktopManager.gnome.enable = true;
      }
    )

    (
      lib.mkIf cfg.niri.enable {
        programs.niri.enable = true;
      }
    )

    (
      lib.mkIf cfg.hyprland.enable {
        programs.hyprland.enable = true;
      }
    )
  ];
}
