{
  config,
  lib,
  pkgs,
  ...
}: let
  GPU = "AMD"; # "AMD" or "NVIDIA"
in {
  imports = [
    # Conditionally import the exact hardware file path:
    (
      if GPU == "AMD"
      then ./amd.nix
      else ./nvidia.nix
      # In testing, will fix
    )
  ];
}
