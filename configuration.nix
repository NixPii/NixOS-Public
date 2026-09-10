# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./system/default.nix
    ./hardware-specific/nvidia.nix
    ./programs/default.nix
    ./users/default.nix
    ./extra/default.nix
    ./theme/default.nix
  ];
  system.stateVersion = "25.11"; # Did you read the comment?
}
