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
        extraEntries = ''
                  menuentry "Windows 11" --class windows11 {
                    insmod part_gpt
                    insmod fat
                    insmod chain
                    search --no-floppy --fs-uuid --set=root BA18-9388
                    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
                    }

                  menuentry "Android 17 bare-metal" {
                    set gfxpayload=keep

                    linux /android-test/bzImage \
                    console=tty0 \
                    loglevel=8 \
                    ignore_loglevel \
                    panic=0 \
                    androidboot.hardware=amdpc \
                    androidboot.boot_part_uuid=afd01174-8e07-493b-8666-442afcb5a390 \
                    androidboot.selinux=permissive \
                    androidboot.init_fatal_panic=true \
                    androidboot.first_stage_console=1 \
                    androidboot.console=tty0

                    initrd /android-test/android-ramdisk.img /android-test/amdgpu-firmware.img /android-test/firststage-debug.img
          }
        '';
      };
      #efi.canTouchEfiVariables = true;
      #efi.efiSysMountPoint = "/boot";
    }; # End of GRUB

    plymouth = {
      enable = true;
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
      "quiet"
      "amd_pstate=disable"
      "splash"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "boot.shell_on_fail"
      "video=DP-1:2560x1440@170" # Why was this 60?
      "video=DP-2:1920x1080@60"
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

      # Purely anti-malware
      "ru_RU.UTF-8/UTF-8" # Russia
      "be_BY.UTF-8/UTF-8" # Belarus
      "kk_KZ.UTF-8/UTF-8" # Kazakhstan
      "uz_UZ.UTF-8/UTF-8" # Uzbekistan
      "tg_TJ.UTF-8/UTF-8" # Tajikistan
      "ar_SY.UTF-8/UTF-8" # Syria
      "zh_CN.UTF-8/UTF-8" # China
      "pt_BR.UTF-8/UTF-8" # Brazil

      # Explicitly fixed for glibc's strict upstream layout
      "az_AZ/UTF-8" # Azerbaijan
      "en_IN/UTF-8" # India (English)
      "hi_IN/UTF-8" # India (Hindi)
      "hy_AM/UTF-8" # Armenia
      "ky_KG/UTF-8" # Kyrgyzstan
      "ro_RO.UTF-8/UTF-8" # Romania / Moldova coverage
      "vi_VN/UTF-8" # Vietnam
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

  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

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
