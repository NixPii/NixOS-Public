{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    # GRUB
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        copyKernels = true;
        memtest86.enable = true;

        theme = pkgs.catppuccin-grub.override {
          flavor = "frappe"; # latte, frappe, macchiato, mocha
        };
      };
      #efi.canTouchEfiVariables = true;
      #efi.efiSysMountPoint = "/boot";
    }; # End of GRUB

    plymouth = {
      enable = false;
      theme = "blahaj";
      themePackages = [
        pkgs.plymouth-blahaj-theme
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;

    # Kernel
    kernelPackages = lib.mkDefault pkgs.linuxPackages_testing;

    kernelParams = [
      "splash"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "boot.shell_on_fail"
    ];
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "nixie"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    plugins = [pkgs.networkmanager-openconnect pkgs.networkmanager-openvpn pkgs.networkmanager-vpnc pkgs.networkmanager-l2tp];
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
        Policy = {AutoEnable = true;};
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
    experimental-features = ["nix-command" "flakes"];
    download-buffer-size = 134217728;
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 16;
    # trusted-users = ["root" "remotebuild"];

    #substituters = [ "https://attic.xuyh0120.win/lantian" ];
    #trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
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

  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  services.udev.packages = with pkgs; [oversteer liquidctl];
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c261", ACTION=="add", ATTR{authorized}="1"
    KERNEL=="hiddev*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c262", MODE="0660", GROUP="users"
    ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -c /etc/usb_modeswitch.d/046d:c261"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c261 -m 01 -r 01 -C 03 -M '0f00010142'"
  '';

  environment.etc."usb_modeswitch.d/046d:c261" = {
    text = ''
      # Logitech G920 Racing Wheel
      DefaultVendor=046d
      DefaultProduct=c261
      MessageEndpoint=01
      ResponseEndpoint=01
      TargetClass=0x03
      MessageContent="0f00010142"
    '';
  };

  environment.variables.EDITOR = "nvim";
}
