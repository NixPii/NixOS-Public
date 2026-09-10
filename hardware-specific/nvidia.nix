{
  config,
  lib,
  pkgs,
  ...
}: {
  # Default Configuration, expects Turing or newer,
  # Some more things to say: 
  # CachyKernel configuration with the CachyOS kernel is not supported, as of yet. 
  # I am working on it. For now, it's stable NixOS kernel only, and the specialisations 
  # 
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;

    # This configuration is designed to run NVIDIA Turing or newer graphics card
    # I have provided alternative specialisations, for the 10 series, and older
    # But with those configurations, bugs won't be fixed, and they are a fallback
    # Here be dragons! If you use them
    # Feel free to fork, and work on them
    open = true;

    nvidiaSettings = true;

    # Dynamically references whichever kernel default/testing is active on the base system
    branch = "stable";
  };

  boot.kernelParams = lib.mkDefault [];

  # Pinning Kernel to be stable for base system, NVIDIA does not like unstable kernels :/
  boot.kernelPackages =
    lib.mkOverride 60 pkgs.linuxPackages_latest;

  specialisation = {
    # 1. SPECIALISATION: GTX 10-Series / Pascal GPUs (1080, 1070, 1050, etc.)
    nvidia-10series.configuration = {
      system.nixos.tags = ["NVIDIA-10Series"];

      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

      hardware.nvidia = {
        # Pascal can't use NVIDIA-Open
        open = lib.mkForce false;

        # Legacy 580 branch for Pascal (evaluated strictly under 6.12)
        branch = lib.mkForce "legacy_580";
      };

      boot.kernelParams = lib.mkForce [];
    };

    # 2. SPECIALISATION: Legacy NVIDIA GPUs (GTX 700 / 600 series / Kepler)
    nvidia-legacy.configuration = {
      system.nixos.tags = ["NVIDIA-Legacy"];

      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;

      hardware.nvidia = {
        open = lib.mkForce false;

        # Pin to legacy_470 branch drivers strictly under kernel 6.6
        branch = lib.mkForce "legacy_470";
      };

      boot.kernelParams = lib.mkForce [];
    };

    # 3. SPECIALISATION: Pure Open-Source Nouveau Driver, fallback
    # This is a fallback system only. Your getting a few fallback diag tools
    # Please do not use this as your daily driver
    nvidia-nouveau.configuration = {
      system.nixos.tags = ["NVIDIA-Fallback"];

      services.xserver.videoDrivers = lib.mkForce ["nouveau"];

      hardware.nvidia = {
        modesetting.enable = lib.mkForce false;
      };

      boot.kernelParams = lib.mkForce [];
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
    };
  };
}
