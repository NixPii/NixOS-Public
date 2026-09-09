{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  xdg.portal = {
    enable = true;
    # xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde 
      xdg-desktop-portal-gtk 
      xdg-desktop-portal-gnome
      ];

    config = {

      common = {
        default = [ "gtk" ];
      };

      niri = {
        # Niri XDG Config
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };

      kde = {
        default = [ "kde" ];
      };

      cosmic = {
        default = [ "cosmic" ];
      };
    };
  };
}
