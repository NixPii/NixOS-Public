{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixpii.system;
in
{
  options.nixpii.system = {
    dev = {

      alcom.enable = lib.mkEnableOption ''
        Enable Unity & Alcom together
      '';

      unity.enable = lib.mkEnableOption ''
        Enable only Unity, without Alcom
      '';

      nvim = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "full"
            "minimal"
          ]
        );

        default = null;

        example = "full";

        description = ''
          This description is obviously not complete. Thank you for understanding
        '';
      };

    };

  };

  config = lib.mkMerge [

    {
      assertions = [

        {
          assertion = !(cfg.dev.alcom.enable && cfg.dev.unity.enable);
          message = "You cannot enable both 'nixpii.system.dev.alcom' and 'nixpii.system.dev.unity' simultaneously.";
        }

      ];
    }

    (lib.mkIf (cfg.dev.nvim == null) {
      programs.neovim.enable = false;
    })

    (lib.mkIf (cfg.dev.nvim == "minimal") {
      programs.neovim.enable = true;
    })

    (lib.mkIf (cfg.dev.alcom.enable) { })

    (lib.mkIf (cfg.dev.unity.enable) {
      environment.systemPackages = [ pkgs.unityhub ];
    })

  ];
}
