{pkgs, ...}: {
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
  };
}
