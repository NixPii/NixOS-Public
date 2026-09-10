{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------------------------
  # Common / base configuration
  # ---------------------------------------------------------------------------

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;

    # Enable ROCm support for the normal AMD configuration.
    rocmSupport = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # ---------------------------------------------------------------------------
  # Default: AMD
  # ---------------------------------------------------------------------------

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.amdgpu = {
    opencl.enable = true;
    overdrive.enable = true;
  };

  # Use the stable/default kernel rather than linuxPackages_latest.
  #
  # On current nixpkgs, linuxPackages_latest tracks the newest kernel,
  # so it is not the right choice if the intention is NVIDIA stability.
  boot.kernelPackages = lib.mkOverride 60 pkgs.linuxPackages;

  # ---------------------------------------------------------------------------
  # GPU specialisations
  # ---------------------------------------------------------------------------

  specialisation = {
    # -------------------------------------------------------------------------
    # NVIDIA Turing+ / RTX / GTX 16xx+
    # Open NVIDIA kernel modules
    # -------------------------------------------------------------------------

    nvidia.configuration = {
      system.nixos.tags = [ "NVIDIA-Open" ];

      services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;

        # Recommended for Turing and newer.
        open = true;

        nvidiaSettings = true;
        branch = "stable";
      };

      # Disable AMD/ROCm-specific functionality inherited from the base config.
      hardware.amdgpu = {
        opencl.enable = lib.mkForce false;
        overdrive.enable = lib.mkForce false;
      };

      nixpkgs.config.rocmSupport = lib.mkForce false;
    };

    # -------------------------------------------------------------------------
    # NVIDIA GTX 10-series / Pascal
    # Proprietary 580 legacy branch
    # -------------------------------------------------------------------------

    nvidia-10series.configuration = {
      system.nixos.tags = [ "NVIDIA-10Series" ];

      services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

      # Keep Pascal on a conservative LTS kernel.
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;

        # Pascal does not use the open kernel modules here.
        open = lib.mkForce false;

        nvidiaSettings = true;
        branch = lib.mkForce "legacy_580";
      };

      hardware.amdgpu = {
        opencl.enable = lib.mkForce false;
        overdrive.enable = lib.mkForce false;
      };

      nixpkgs.config.rocmSupport = lib.mkForce false;
    };

    # -------------------------------------------------------------------------
    # NVIDIA GTX 600 / 700-series / Kepler
    # Proprietary 470 legacy branch
    # -------------------------------------------------------------------------

    nvidia-legacy.configuration = {
      system.nixos.tags = [ "NVIDIA-Legacy" ];

      services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;

        open = lib.mkForce false;

        nvidiaSettings = true;
        branch = lib.mkForce "legacy_470";
      };

      hardware.amdgpu = {
        opencl.enable = lib.mkForce false;
        overdrive.enable = lib.mkForce false;
      };

      nixpkgs.config.rocmSupport = lib.mkForce false;
    };

    # -------------------------------------------------------------------------
    # Nouveau fallback
    # -------------------------------------------------------------------------

    nvidia-nouveau.configuration = {
      system.nixos.tags = [ "NVIDIA-Fallback" ];

      services.xserver.videoDrivers = lib.mkForce [ "nouveau" ];

      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

      # No NVIDIA proprietary driver configuration is required here.
      hardware.amdgpu = {
        opencl.enable = lib.mkForce false;
        overdrive.enable = lib.mkForce false;
      };

      nixpkgs.config.rocmSupport = lib.mkForce false;
    };
  };
}