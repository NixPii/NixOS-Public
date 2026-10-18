{
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "nixie"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
  };
  networking.modemmanager.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    new-lg4ff.enable = true;
    i2c.enable = true;

    uinput.enable = true;
    usb-modeswitch.enable = true;
    logitech = {
      wireless.enable = true;
    };
  };

  # hardware.logitech.wireless.enableGraphical -> This
  programs.solaar.enable = true;

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "hu_HU.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "pl_PL.UTF-8/UTF-8"
    ];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 134217728;
    auto-optimise-store = true;
    max-jobs = "auto";
  };

  time.timeZone = "Europe/Budapest";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 20;
    priority = 100;
  };

  environment.etc.hosts.enable = true;
  security.pam.services.swaylock = {};
  security.sudo.wheelNeedsPassword = false;

  # Auto updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # Garbage Collection
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";
  nix.optimise.automatic = true;

  services.udev.packages = with pkgs; [
    liquidctl
  ];

  environment.variables.EDITOR = "nvim";
}
