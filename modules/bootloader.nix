{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.bootloader;
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
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.grub_minimal.enable && cfg.limine.enable);
          message = "GRUB and Limine cannot both be enabled.";
        }
      ];
    }

    (lib.mkIf cfg.grub_minimal.enable {
      boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        copyKernels = true;
        memtest86.enable = false;
      }; ## TODO: Add grub_minimal and add grub_full to config

      boot.loader.limine.enable = false;
    })

    (lib.mkIf cfg.limine.enable {
      boot.loader.limine.enable = true;
      boot.loader.grub.enable = false;
    })

    (lib.mkIf cfg.grub_full.enable {
      boot.loader.limine.enable = true;
      boot.loader.grub.enable = false;

      # TODO: Implement
    })

    (lib.mkIf cfg.plymouth_config.enable {
      boot.plymouth = {
        enable = true;
        theme = "blahaj";
        themePackages = [pkgs.plymouth-blahaj-theme];
      };
    })
  ];
}
# This is a very Work In Progress module, please ignore, this is not even being imported right now, for obvious reasons

