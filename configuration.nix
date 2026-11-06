# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  pkgs,
  ...
}:
{
  nixpii.system = {
    # ============================================================
    # DEVELOPMENT TOOLS
    # ============================================================

    dev = {
      # Applications
      alcom.enable = false; # ALCom launcher
      unity.enable = false; # Unity development tools
      yazi.enable = true; # Terminal file manager
      lazygit.enable = true; # Terminal Git interface

      # Neovim configuration
      nvim = "full";

      # ----------------------------------------------------------
      # ARTIFICIAL INTELLIGENCE
      # ----------------------------------------------------------

      ai = {
        enable = false; # Enable AI-related configuration
        acceleration = "rocm"; # Options: "rocm", "cuda", "cpu"

        # AI applications
        opencode.enable = false;
        opencodeDesktop.enable = false;
        openWebUI.enable = false;

        # AMD ROCm configuration
        rocm.overrideGfx = "11.0.0";
      };
    };

    # ============================================================
    # DESKTOP ENVIRONMENTS & WAYLAND COMPOSITORS
    # ============================================================

    desktop = {
      # Desktop environments
      plasma6.enable = true; # KDE Plasma 6
      gnome.enable = true; # GNOME
      cosmic.enable = false; # COSMIC

      # Wayland compositors
      niri.enable = true; # Niri scrolling compositor
      hyprland.enable = false; # Hyprland compositor

      noctalia = "disabled";
    };

    # ============================================================
    # GAMING CONFIG
    # ============================================================
    gaming = {
      # Steam Related Configuration
      steam = {
        enable = false; # Enable Steam
        variant = "full"; # Options: "full", "minimal"
        millennium.enable = false; # Enable the Millennium Steam client
      };

      # Minecraft Related Configuration
      minecraft = {
        enable = false; # Enable Minecraft support via Prism Launcher
        lunar.enable = false; # Enable Lunar Client

        jdks = with pkgs; [
          jdk8
          jdk11
          jdk17
          jdk21
          jdk25
        ];
      };
    };

    # ============================================================
    # BOOTLOADER & BOOT SPLASH
    # ============================================================

    bootloader = {
      # GRUB
      grub_minimal.enable = false; # Minimal GRUB setup
      grub_full.enable = false; # GRUB with additional theming
      grub_enable_os_prober.enable = false; # Detect other operating systems
      systemd-boot.enable = true; # systemd-boot

      # Alternative bootloader
      limine.enable = false; # Limine bootloader

      # Boot splash
      plymouth_config.enable = false; # Graphical boot splash
    };

    # ============================================================
    # HARDWARE
    # ============================================================

    hardware = {
      gpu = {
        # GPU driver profile
        # Options: "generic", "amd", "nvidia", "nvidia-10series", "nvidia-legacy", "nouveau"
        profile = "generic";

        # Generate alternative GPU configurations
        # WARNING: Increased disk usage and build times
        specialisations.enable = false;
      };

      # ----------------------------------------------------------
      # VIRTUAL REALITY
      # ----------------------------------------------------------

      vr.meta.enable = false; # Meta VR headset support
    };

    # ============================================================
    # VIRTUALIZATION
    # ============================================================

    virt = {
      qemu_minimal.enable = false; # Minimal QEMU configuration
      qemu_full.enable = false; # Full QEMU configuration
    };
  };

  # The boring stuff
  imports = [
    # Include the results of the hardware scan.
    ./system/sys_import.nix
    ./programs/programs_import.nix
    ./users/users_import.nix
    ./extra/extra_import.nix
    ./theme/theme_import.nix
    "${inputs.modules}/modules.nix"
    "${inputs.private}/private.nix" # Include the users private configuration, which of course, is not included.
  ];
  system.stateVersion = "25.11"; # Did you read the comment?
}
