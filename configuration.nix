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
    ./modules/gpu.nix
    ./modules/ai.nix
    ./programs/default.nix
    ./users/default.nix
    ./extra/default.nix
    ./theme/default.nix
  ];

  # Set this option. TODO: Make this more clear
  nixpii.gpu = {
    profile = "generic";
    specialisations.enable = false;
  };

  nixpii.ai = {
    enable = false;
    acceleration = "rocm";

    rocm.overrideGfx = "11.0.0";
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;

      qemu.options = ["-vga none -device virtio-gpu-pci"];
    };
  };
  system.stateVersion = "25.11"; # Did you read the comment?
}
