{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.gpu;

  # ---------------------------------------------------------------------------
  # GPU profiles
  #
  # These are configuration fragments only.
  # Defining them here does NOT automatically add them to the system closure.
  #
  # In normal mode, only cfg.profile is applied.
  # In specialisation mode, AMD becomes the base configuration and the NVIDIA
  # variants are exposed as boot specialisations.
  # ---------------------------------------------------------------------------

  profiles = {
    # -------------------------------------------------------------------------
    # Generic
    #
    # No vendor-specific configuration.
    #
    # Useful for:
    #   - VMs
    #   - testing
    #   - Intel graphics
    #   - systems where the kernel/Mesa defaults are sufficient
    # -------------------------------------------------------------------------

    generic = {};

    # -------------------------------------------------------------------------
    # AMD
    # -------------------------------------------------------------------------

    amd = {
      services.xserver.videoDrivers = ["amdgpu"];

      hardware.amdgpu = {
        opencl.enable = true;
        overdrive.enable = true;
      };

      nixpkgs.config.rocmSupport = true;
    };

    # -------------------------------------------------------------------------
    # NVIDIA Turing+ / RTX / GTX 16xx+
    #
    # Open NVIDIA kernel modules.
    # -------------------------------------------------------------------------

    nvidia = {
      services.xserver.videoDrivers = ["nvidia"];

      nixpkgs.config.nvidia.acceptLicense = true;

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;

        # Recommended for Turing and newer.
        open = true;

        nvidiaSettings = true;
        branch = "stable";
      };
    };

    # -------------------------------------------------------------------------
    # NVIDIA GTX 10-series / Pascal
    #
    # Proprietary 580 legacy branch.
    # -------------------------------------------------------------------------

    nvidia-10series = {
      services.xserver.videoDrivers = ["nvidia"];

      nixpkgs.config.nvidia.acceptLicense = true;

      # Keep Pascal on a conservative LTS kernel.
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;

        open = false;

        nvidiaSettings = true;
        branch = "legacy_580";
      };
    };

    # -------------------------------------------------------------------------
    # NVIDIA GTX 600 / 700-series / Kepler
    #
    # Proprietary 470 legacy branch.
    # -------------------------------------------------------------------------

    nvidia-legacy = {
      services.xserver.videoDrivers = ["nvidia"];

      nixpkgs.config.nvidia.acceptLicense = true;

      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;

        open = false;

        nvidiaSettings = true;
        branch = "legacy_470";
      };
    };

    # -------------------------------------------------------------------------
    # Nouveau
    # -------------------------------------------------------------------------

    nouveau = {
      services.xserver.videoDrivers = ["nouveau"];

      # No proprietary NVIDIA configuration is needed.
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
    };
  };
in {
  # ===========================================================================
  # Options
  # ===========================================================================

  options.nixpii.gpu = {
    # -------------------------------------------------------------------------
    # GPU profile
    # -------------------------------------------------------------------------

    profile = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "generic"
          "amd"
          "nvidia"
          "nvidia-10series"
          "nvidia-legacy"
          "nouveau"
        ]
      );

      # null intentionally means:
      # "The user has not selected a GPU profile yet."
      #
      # This lets us warn them without making evaluation fail.
      default = null;

      example = "amd";

      description = ''
        GPU profile to use for this system.

        Available profiles:

          generic
            Generic kernel/Mesa graphics configuration.
            Recommended for VMs and testing.

          amd
            AMDGPU with OpenCL/ROCm and overdrive enabled.

          nvidia
            NVIDIA Turing and newer GPUs using the current driver and
            open NVIDIA kernel modules.

          nvidia-10series
            NVIDIA Pascal / GTX 10-series GPUs using the legacy 580 branch.

          nvidia-legacy
            Older NVIDIA / Kepler GPUs using the legacy 470 branch.

          nouveau
            Open-source Nouveau NVIDIA driver.

        Normal installations should select exactly one profile.
      '';
    };

    # -------------------------------------------------------------------------
    # Universal GPU specialisations
    # -------------------------------------------------------------------------

    specialisations.enable = lib.mkEnableOption ''
      universal GPU boot specialisations

      When enabled, AMD is used as the base configuration and multiple NVIDIA
      configurations are added as NixOS specialisations.

      This is intended for universal installations, recovery/testing systems,
      or machines whose GPU configuration is not known in advance.

      It substantially increases the system closure and disk usage.
    '';
  };

  # ===========================================================================
  # Configuration
  # ===========================================================================

  config = lib.mkMerge [
    # -------------------------------------------------------------------------
    # Common configuration
    # -------------------------------------------------------------------------

    {
      nixpkgs.config.allowUnfree = true;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.enableRedistributableFirmware = true;
      hardware.firmware = [pkgs.linux-firmware];

      # Use the normal/default kernel unless a GPU profile overrides it.
      boot.kernelPackages = lib.mkOverride 60 pkgs.linuxPackages;

      # -----------------------------------------------------------------------
      # Warnings
      # -----------------------------------------------------------------------

      warnings =
        # No GPU selected.
        lib.optional (
          cfg.profile
          == null
          && !cfg.specialisations.enable
        ) ''
          No GPU profile has been selected.

          For a normal installation, set one of:

            nixpii.gpu.profile = "generic";
            nixpii.gpu.profile = "amd";
            nixpii.gpu.profile = "nvidia";
            nixpii.gpu.profile = "nvidia-10series";
            nixpii.gpu.profile = "nvidia-legacy";
            nixpii.gpu.profile = "nouveau";

          "generic" is recommended for VMs and testing.

          For a universal system containing multiple GPU configurations,
          enable:

            nixpii.gpu.specialisations.enable = true;
        ''
        # Universal/specialisation mode warning.
        ++ lib.optional cfg.specialisations.enable ''
          nixpii.gpu.specialisations.enable is enabled.

          This builds multiple complete GPU configurations and can
          substantially increase the system closure and disk usage.

          For a normal installation, prefer selecting one GPU profile with:

            nixpii.gpu.profile = "...";
        ''
        # A profile was specified, but universal mode overrides it.
        ++ lib.optional (
          cfg.specialisations.enable
          && cfg.profile != null
        ) ''
          Both nixpii.gpu.profile and nixpii.gpu.specialisations.enable are set.

          nixpii.gpu.profile is ignored while GPU specialisations are enabled.

          Disable:

            nixpii.gpu.specialisations.enable = false;

          if you want to use only the selected GPU profile.
        '';
    }

    # -------------------------------------------------------------------------
    # Normal mode
    #
    # Apply ONLY the selected GPU profile.
    # -------------------------------------------------------------------------

    (lib.mkIf (
        !cfg.specialisations.enable
        && cfg.profile != null
      )
      profiles.${cfg.profile})

    # -------------------------------------------------------------------------
    # Universal mode
    #
    # Preserve the behavior of your old configuration:
    #
    #   base system       -> AMD
    #   specialisation    -> modern NVIDIA
    #   specialisation    -> NVIDIA GTX 10-series
    #   specialisation    -> NVIDIA legacy
    #   specialisation    -> Nouveau
    #
    # This is deliberately expensive and should normally remain disabled.
    # -------------------------------------------------------------------------

    (lib.mkIf cfg.specialisations.enable (
      lib.mkMerge [
        # AMD is the base/default system in universal mode.
        profiles.amd

        {
          specialisation = {
            # -----------------------------------------------------------------
            # NVIDIA Turing+ / RTX / GTX 16xx+
            # -----------------------------------------------------------------

            nvidia.configuration = lib.mkMerge [
              profiles.nvidia
              {
                system.nixos.tags = ["NVIDIA-Open"];
              }
            ];

            # -----------------------------------------------------------------
            # NVIDIA GTX 10-series / Pascal
            # -----------------------------------------------------------------

            nvidia-10series.configuration = lib.mkMerge [
              profiles.nvidia-10series
              {
                system.nixos.tags = ["NVIDIA-10Series"];
              }
            ];

            # -----------------------------------------------------------------
            # NVIDIA GTX 600 / 700-series / Kepler
            # -----------------------------------------------------------------

            nvidia-legacy.configuration = lib.mkMerge [
              profiles.nvidia-legacy
              {
                system.nixos.tags = ["NVIDIA-Legacy"];
              }
            ];

            # -----------------------------------------------------------------
            # Nouveau fallback
            # -----------------------------------------------------------------

            nvidia-nouveau.configuration = lib.mkMerge [
              profiles.nouveau
              {
                system.nixos.tags = ["NVIDIA-Fallback"];
              }
            ];
          };
        }
      ]
    ))
  ];
}
