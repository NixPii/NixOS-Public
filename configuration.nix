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
  # Set this option. TODO: Make this more clear
  nixpii.gpu = {
    profile = "generic"; # either "generic", "amd", "nvidia", "nvidia-10series", "nvidia-legacy" or "nouveau"
    specialisations.enable = false; # Enable Specialisations, NOTE: High disk usage, longer compile times
  };

  nixpii.ai = {
    enable = false; # Enable Ai options?
    acceleration = "rocm"; # either "rocm", "cpu" or "cuda"

    # Ai Apps
    opencode.enable = false;
    opencodeDesktop.enable = false;
    openWebUI.enable = false;

    # AMD ROCm
    rocm.overrideGfx = "11.0.0";
  };

  nixpii.bootloader = {
    grub_minimal.enable = true; # Minimal GRUB configuration, only what is needed.
    limine.enable = false; # Generic Limine config.
    grub_full.enable = false; # Full Grub config, which includes a theme, etc etc.
    grub_enable_os_prober.enable = false; # Self explanatory
    plymouth_config.enable = false; # Should we enable Plymouth for the boot screen?
  };

  nixpii.virt = {
    qemu_minimal.enable = false; # Minimal QEMU config.
    qemu_full.enable = false; # Full QEMU config.
  };

  # The boring stuff
  imports = [
    # Include the results of the hardware scan.
    ./system/default.nix
    ./modules/gpu.nix
    ./modules/ai.nix
    ./modules/bootloader.nix
    ./modules/virt.nix
    ./programs/default.nix
    ./users/default.nix
    ./extra/default.nix
    ./theme/default.nix
    "${inputs.private}/private.nix" # Include the users private configuration, which of course, is not included.
  ];
  system.stateVersion = "25.11"; # Did you read the comment?
}
