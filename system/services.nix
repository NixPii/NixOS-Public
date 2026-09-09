{
  config,
  lib,
  pkgs,
  nixpkgs-stable,
  ...
}: {
  services.libinput.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;
  services.openssh.enable = true;
  services.spice-autorandr.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
  services.smartd.enable = true;
  services.flatpak.enable = true;
  services.blueman.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.lact.enable = true;

  # Disable Seahorse for some reason
  programs.seahorse.enable = false;

  # Niri
  programs.niri.enable = true;

  # Desktop Manager
  services.desktopManager = {
    plasma6.enable = true; # Plasma 6
    cosmic.enable = false; # Cosmic
    gnome.enable = true; # GNOME
  };

  services.gnome = {
    # GNOME Settings
    core-apps.enable = true; # Gnome Core Apps
    core-developer-tools.enable = true; # Gnome Dev Tools
    games.enable = false; # Gnome Games
    tinysparql.enable = true;
    localsearch.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-manuals];

  # Window Managers (X11)
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    xkb.layout = "hu";
    windowManager = {
      twm.enable = true;
    };
  };

  services.upower.enable = true;

  # Tailscale
  services.tailscale.enable = true;
  services.tailscale.extraDaemonFlags = ["--no-logs-no-support"];

  # Printing
  services.printing.enable = true;
  services.printing.drivers = [pkgs.epson-escpr2];

  services.udev.packages = [pkgs.yubikey-personalization pkgs.slimevr];

  services.pcscd.enable = true;

  # Time, is our essence
  services.chrony = {
    enable = true;
    servers = config.networking.timeServers;
  };

  # i-Device
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  # Ly (Login Manager / Display Manager)
  services.displayManager.ly = {
    enable = true;
    x11Support = true;

    settings = {
      animation = "matrix"; # "doom", "matrix", "colormix", "gameoflife" - colormix is pretty good
      animation_timeout_sec = 0; # 0 = keep running forever

      bigclock = "en"; # or "none"
      full_color = true;
      bigclock_seconds = false;

      hide_borders = true;
      blank_password = true;
      clock = "%Y-%m-%d %H:%M:%S";
      #bg = 0;
      #fg = 8;

      # Margin box margins
      margin_box_h = 6;
      margin_box_v = 3;

      input_len = 40;

      # Max input sizes
      max_desktop_len = 100;
      max_login_len = 255;
      max_password_len = 255;

      save = true;
      load = true;
      default_user = "nixpii";
    };
  };

  # Console :3
  console.keyMap = "hu";

  # VR
  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    highPriority = true;
    steam.enable = true;
    steam.importOXRRuntimes = true;
    package = nixpkgs-stable.wivrn;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = false;
    openFirewall = true;
  };

  # Matrix web  server
  services.nginx.enable = true;

  # OpenRGB
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6742;
  };

  # Automation
  programs.ydotool.enable = true;
  # END
}
