{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.system;
in {
  options.nixpii.system = {
    idonothing = lib.mkEnableOption ''
      I do nothing
    '';

    ialsodonothing = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "option1"
          "option2"
        ]
      );

      default = null;

      example = "option1";

      descriptions = ''
        Yes
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.ialsodonothing == null) (
      builtins.trace "Hi!"
      {
        environment.systemPackages = [pkgs.hello];
      }
    ))
  ];
}
