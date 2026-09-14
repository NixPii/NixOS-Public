{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.virt;
in {
  options.nixpii.virt = {
    qemu_full.enable = lib.mkEnableOption ''
      Enable the full qemu configuration, cooked up by NixPii themselves.
      WARNING: This takes significant amount of RAM and TIME to compile.
    '';
    qemu_minimal.enable = lib.mkEnableOption ''
      The recomended config is this.
      Enable the minimal QEMU configuration, cooked up by NixPii themselves.
      Warning: Might not include what you want.

    '';
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.qemu_full.enable && cfg.qemu_minimal.enable);
          message = "Full and Minimal can't be enabled at the same time.";
        }
      ];
    }

    (lib.mkIf cfg.qemu_full.enable {
      virtualisation = {
        libvirtd = {
          enable = true;
          firewallBackend = "nftables";
          qemu = {
            vhostUserPackages = [pkgs.virtiofsd];
            swtpm.enable = true;
            package = pkgs.qemu_full.override {
              cephSupport = false;
              enableDocs = false;
            };
          };
        };
        spiceUSBRedirection.enable = true;
      };
      programs.virt-manager.enable = true;
    })

    (lib.mkIf cfg.qemu_minimal.enable {
      virtualisation = {
        libvirtd = {
          enable = true;
          firewallBackend = "nftables";
          qemu.vhostUserPackages = [pkgs.virtiofsd];
        };
      };
      programs.virt-manager.enable = true;
    })
  ];
}
# This is a very Work In Progress module, please ignore, this is not even being imported right now, for obvious reasons

