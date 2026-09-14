  # --- Libvirtd & QEMU virtualisation
  # TODO: Move to Module 
  virtualisation = {
    libvirtd = {
      enable = true;
      firewallBackend = "nftables";
      qemu.package = pkgs.qemu_full.override {
        cephSupport = false;
        enableDocs = false;
      };
      qemu = {
        vhostUserPackages = with pkgs; [virtiofsd];
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection = {
      enable = true;
    };
  };

  programs.virt-manager.enable = true;

  # TODO:
  # Change from just moved code -> actually working code 
