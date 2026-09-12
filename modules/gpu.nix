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
  # They are applied explicitly further below with mkIf.
  # ---------------------------------------------------------------------------

  profiles = {
    # -------------------------------------------------------------------------
    # Generic
    #
    # No vendor-specific configuration.
    #
    # Intended for:
    #   - VMs
    #   - testing
    #   - Intel graphics
    #   - systems where the normal kernel/Mesa defaults are sufficient
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
    # Current NVIDIA driver using the open kernel module.
    # -------------------------------------------------------------------------

    nvidia = {
      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;

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

      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
    };
  };
in {
  # ===========================================================================
  # Options
  # ===========================================================================

  options.nixpii.gpu = {
    # -------------------------------------------------------------------------
    # Selected GPU profile
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

      # null means:
      # "The user has not explicitly selected anything yet."
      #
      # This lets us warn instead of failing evaluation.
      default = null;

      example = "amd";

      description = ''
        GPU profile to use for this system.

        Available profiles:

          generic
            Generic graphics configuration.
            Recommended for VMs and testing.

          amd
            AMDGPU with OpenCL/ROCm and overdrive support.

          nvidia
            NVIDIA Turing and newer GPUs using the current driver
            and open NVIDIA kernel modules.

          nvidia-10series
            NVIDIA Pascal / GTX 10-series using the legacy 580 branch.

          nvidia-legacy
            NVIDIA Kepler / GTX 600 and 700-series using the
            legacy 470 branch.

          nouveau
            Open-source Nouveau NVIDIA driver.

        Normal installations should select exactly one profile.
      '';
    };

    # -------------------------------------------------------------------------
    # Universal GPU mode
    # -------------------------------------------------------------------------

    specialisations.enable = lib.mkEnableOption ''
      universal GPU boot specialisations

      When enabled, AMD is used as the default/base configuration and several
      NVIDIA configurations are provided as NixOS boot specialisations.

      This is intended for universal systems where the target GPU is not known
      in advance.

      Enabling this significantly increases closure size and disk usage.
    '';
  };

  # ===========================================================================
  # Configuration
  # ===========================================================================

  config = lib.mkMerge [
    # -------------------------------------------------------------------------
    # Common graphics configuration
    # -------------------------------------------------------------------------

    {
      nixpkgs.config = {
        allowUnfree = true;

        # Merely accepting the NVIDIA license does not install NVIDIA.
        # The driver is still only pulled in by the NVIDIA profiles.
        nvidia.acceptLicense = true;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.enableRedistributableFirmware = true;
      hardware.firmware = [pkgs.linux-firmware];

      # Normal/default kernel unless a profile overrides it.
      boot.kernelPackages = lib.mkOverride 60 pkgs.linuxPackages;
    }

    # =========================================================================
    # Warnings
    # =========================================================================

    # -------------------------------------------------------------------------
    # Nothing selected
    # -------------------------------------------------------------------------

    (lib.mkIf (
        cfg.profile
        == null
        && !cfg.specialisations.enable
      ) {
        warnings = [
          ''
            No GPU profile has been selected.

            For a normal installation, choose the profile matching your GPU:

              nixpii.gpu.profile = "generic";
              nixpii.gpu.profile = "amd";
              nixpii.gpu.profile = "nvidia";
              nixpii.gpu.profile = "nvidia-10series";
              nixpii.gpu.profile = "nvidia-legacy";
              nixpii.gpu.profile = "nouveau";

            "generic" is recommended for VMs and testing.

            If you intentionally want all GPU variants available as boot
            specialisations, use:

              nixpii.gpu.specialisations.enable = true;
          ''
        ];
      })

    # -------------------------------------------------------------------------
    # Universal mode enabled
    # -------------------------------------------------------------------------

    (lib.mkIf cfg.specialisations.enable {
      warnings = [
        ''
          Universal GPU specialisations are enabled.

          Multiple complete GPU configurations will be included in the
          resulting NixOS system. This can substantially increase closure
          size, build time, and disk usage.

          Normal installations should usually select one GPU profile instead:

            nixpii.gpu.profile = "...";
        ''
      ];
    })

    # -------------------------------------------------------------------------
    # Both profile and universal mode selected
    # -------------------------------------------------------------------------

    (lib.mkIf (
        cfg.specialisations.enable
        && cfg.profile != null
      ) {
        warnings = [
          ''
            Both nixpii.gpu.profile and nixpii.gpu.specialisations.enable
            are configured.

            The selected GPU profile is ignored while universal GPU
            specialisations are enabled.

            For a normal single-GPU installation, disable:

              nixpii.gpu.specialisations.enable = false;
          ''
        ];
      })

    # =========================================================================
    # Normal / single-profile mode
    #
    # Deliberately explicit rather than dynamically evaluating:
    #
    #   profiles.''${cfg.profile}
    #
    # Only one of these branches can become active.
    # =========================================================================

    (lib.mkIf (
        !cfg.specialisations.enable
        && cfg.profile == "generic"
      )
      profiles.generic)

    (lib.mkIf (
        !cfg.specialisations.enable
        && cfg.profile == "amd"
      )
      profiles.amd)

    (lib.mkIf (
        !cfg.specialisations.enable
        && cfg.profile == "nvidia"
      )
      profiles.nvidia)

    (lib.mkIf (
        !cfg.specialisations.enable
        && cfg.profile == "nvidia-10series"
      )
      profiles.nvidia-10series)

    (lib.mkIf (
        !cfg.specialisations.enable
        && cfg.profile == "nvidia-legacy"
      )
      profiles.nvidia-legacy)

    (lib.mkIf (
        !cfg.specialisations.enable
        && cfg.profile == "nouveau"
      )
      profiles.nouveau)

    # =========================================================================
    # Universal / specialisation mode
    #
    # AMD remains the default configuration, matching your old setup.
    #
    # NVIDIA specialisations explicitly override the AMD-specific options
    # inherited from the base configuration.
    # =========================================================================

    (lib.mkIf cfg.specialisations.enable (
      lib.mkMerge [
        # ---------------------------------------------------------------------
        # Default/base system: AMD
        # ---------------------------------------------------------------------

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

                services.xserver.videoDrivers =
                  lib.mkForce ["nvidia"];

                hardware.amdgpu = {
                  opencl.enable = lib.mkForce false;
                  overdrive.enable = lib.mkForce false;
                };

                nixpkgs.config.rocmSupport = lib.mkForce false;
              }
            ];

            # -----------------------------------------------------------------
            # NVIDIA GTX 10-series / Pascal
            # -----------------------------------------------------------------

            nvidia-10series.configuration = lib.mkMerge [
              profiles.nvidia-10series

              {
                system.nixos.tags = ["NVIDIA-10Series"];

                services.xserver.videoDrivers =
                  lib.mkForce ["nvidia"];

                hardware.amdgpu = {
                  opencl.enable = lib.mkForce false;
                  overdrive.enable = lib.mkForce false;
                };

                nixpkgs.config.rocmSupport = lib.mkForce false;
              }
            ];

            # -----------------------------------------------------------------
            # NVIDIA GTX 600 / 700-series / Kepler
            # -----------------------------------------------------------------

            nvidia-legacy.configuration = lib.mkMerge [
              profiles.nvidia-legacy

              {
                system.nixos.tags = ["NVIDIA-Legacy"];

                services.xserver.videoDrivers =
                  lib.mkForce ["nvidia"];

                hardware.amdgpu = {
                  opencl.enable = lib.mkForce false;
                  overdrive.enable = lib.mkForce false;
                };

                nixpkgs.config.rocmSupport = lib.mkForce false;
              }
            ];

            # -----------------------------------------------------------------
            # Nouveau fallback
            # -----------------------------------------------------------------

            nvidia-nouveau.configuration = lib.mkMerge [
              profiles.nouveau

              {
                system.nixos.tags = ["NVIDIA-Fallback"];

                services.xserver.videoDrivers =
                  lib.mkForce ["nouveau"];

                hardware.amdgpu = {
                  opencl.enable = lib.mkForce false;
                  overdrive.enable = lib.mkForce false;
                };

                nixpkgs.config.rocmSupport = lib.mkForce false;
              }
            ];
          };
        }
      ]
    ))
  ];
}
