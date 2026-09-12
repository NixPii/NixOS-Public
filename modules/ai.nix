{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.ai;

  ollamaPackage =
    if cfg.acceleration == "rocm"
    then pkgs.ollama-rocm
    else if cfg.acceleration == "cuda"
    then pkgs.ollama-cuda
    else pkgs.ollama;
in {
  # ===========================================================================
  # Options
  # ===========================================================================

  options.nixpii.ai = {
    enable = lib.mkEnableOption "AI and local LLM tooling";

    acceleration = lib.mkOption {
      type = lib.types.enum [
        "cpu"
        "rocm"
        "cuda"
      ];

      default = "cpu";

      example = "rocm";

      description = ''
        Hardware acceleration backend used by Ollama.

        cpu
          Standard Ollama without GPU-specific acceleration.

        rocm
          AMD ROCm accelerated Ollama.

        cuda
          NVIDIA CUDA accelerated Ollama.
      '';
    };

    opencode.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install OpenCode.";
    };

    opencodeDesktop.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install OpenCode Desktop.";
    };

    openWebUI.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Open WebUI.";
    };

    rocm = {
      overrideGfx = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;

        example = "11.0.0";

        description = ''
          Optional value for services.ollama.rocmOverrideGfx.

          Leave this null unless your AMD GPU requires an HSA GFX override.
        '';
      };

      hccAmdgpuTarget = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;

        example = "gfx1100";

        description = ''
          Optional HCC_AMDGPU_TARGET value.

          This was historically required for some AMD GPUs but should normally
          be left unset unless it is specifically needed.
        '';
      };
    };
  };

  # ===========================================================================
  # Configuration
  # ===========================================================================

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # -----------------------------------------------------------------------
      # Packages
      # -----------------------------------------------------------------------

      {
        environment.systemPackages =
          [ollamaPackage]
          ++ lib.optional cfg.opencode.enable pkgs.opencode
          ++ lib.optional cfg.opencodeDesktop.enable pkgs.opencode-desktop;
      }

      # -----------------------------------------------------------------------
      # Ollama
      # -----------------------------------------------------------------------

      {
        services.ollama = {
          enable = true;
          package = ollamaPackage;

          environmentVariables =
            lib.optionalAttrs (
              cfg.acceleration
              == "rocm"
              && cfg.rocm.hccAmdgpuTarget != null
            ) {
              HCC_AMDGPU_TARGET = cfg.rocm.hccAmdgpuTarget;
            };
        };
      }

      # ROCm-specific GFX override
      (lib.mkIf (
          cfg.acceleration
          == "rocm"
          && cfg.rocm.overrideGfx != null
        ) {
          services.ollama.rocmOverrideGfx = cfg.rocm.overrideGfx;
        })

      # -----------------------------------------------------------------------
      # Open WebUI
      # -----------------------------------------------------------------------

      {
        services.open-webui.enable = cfg.openWebUI.enable;
      }

      # -----------------------------------------------------------------------
      # Helpful warnings
      # -----------------------------------------------------------------------

      (lib.mkIf (
          cfg.acceleration
          != "rocm"
          && (
            cfg.rocm.overrideGfx
            != null
            || cfg.rocm.hccAmdgpuTarget != null
          )
        ) {
          warnings = [
            ''
              nixpii.ai.rocm options are configured, but:

                nixpii.ai.acceleration = "${cfg.acceleration}";

              The ROCm-specific settings will therefore have no effect.
            ''
          ];
        })
    ]
  );
}
