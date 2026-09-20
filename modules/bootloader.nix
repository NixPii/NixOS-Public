{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.bootloader;
  enabledBootloadersCount = lib.count (x: x) [
    cfg.grub_minimal.enable
    cfg.grub_full.enable
    cfg.limine.enable
  ];
in {
  options.nixpii.bootloader = {
    grub_minimal.enable = lib.mkEnableOption ''
      Change the default bootloader to GRUB
    '';

    limine.enable = lib.mkEnableOption ''
      Change the default Bootloader to Limine, good for UEFI Secure Boot booting
    '';

    plymouth_config.enable = lib.mkEnableOption ''
      Enable the plymouth pre-configured bootscreen
    '';

    grub_full.enable = lib.mkEnableOption ''
      Enable the full GRUB config, this is currently not used, and it is a remenant. Please DO NOT ENABLE.
    '';

    grub_enable_os_prober.enable = lib.mkEnableOption ''
      Enable GRUB to use os-prober (default: false)
    '';
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = enabledBootloadersCount < 2;
          message = "You can only enable one bootloader option at a time (grub_minimal, limine, or grub_full).";
        }
        {
          assertion = !(cfg.grub_minimal.enable && cfg.grub_full.enable);
          message = "Grub Minimal and Grub Full cannot be both enabled at the same time, we recommend using Grub Full instead";
        }
        {
          assertion = !(cfg.grub_enable_os_prober.enable && cfg.limine.enable);
          message = "Nice try, but os-prober can't be enabled when limine is enabled, it is strictly a Grub option.";
        }
      ];
    }

    # Grub section
    (lib.mkIf cfg.grub_minimal.enable {
      boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        copyKernels = true;
        memtest86.enable = false;
      };
    })

    (lib.mkIf cfg.grub_full.enable {
      boot = {
        loader.grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          copyKernels = true;
          memtest86.enable = true;
        };
        loader.limine.enable = false;
        kernelParams = [
          "drm.panic_screen=qr_code"
          "panic=0"
          "systemd.show_status=auto"
          "boot.shell_on_fail"
        ];
        initrd.systemd.enable = true;
      };
    })

    (lib.mkIf cfg.grub_enable_os_prober.enable {
      boot.loader.grub.useOSProber = true;
    })

    # Limine section
    (lib.mkIf cfg.limine.enable {
      boot.loader.limine.enable = true;
    })

    # Plymouth
    (lib.mkIf cfg.plymouth_config.enable {
      boot.plymouth = {
        enable = true;
        theme = "blahaj";
        themePackages = [pkgs.plymouth-blahaj-theme];
      };
    })
  ];
}
