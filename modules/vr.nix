{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixpii.vr;
in
{
  options.nixpii.vr = {
    meta.enable = lib.mkEnableOption ''
      Should we enable Meta Quest 2/3/3S VR support?
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.meta.enable {
      services.wivrn = {
        enable = true;
        openFirewall = true;
        autoStart = true;
        highPriority = true;
        steam.enable = true;
        steam.importOXRRuntimes = true;
      };

      environment.systemPackages = [
        pkgs.wayvr
        pkgs.slimevr
      ];

      programs.nix-ld.libraries = with pkgs; [
        # General runtime / common foreign binary deps
        stdenv.cc.cc
        zlib
        zstd
        xz
        bzip2
        openssl
        curl
        glib
        expat

        # Vulkan / OpenGL / DRM
        vulkan-loader
        libGL
        libdrm
        libgbm
        libva

        # Wayland / input
        wayland
        libxkbcommon

        # X11 / XWayland
        libX11
        libXext
        libXrandr
        libXfixes
        libXcursor
        libXi
        libXrender
        libXcomposite
        libXdamage
        libXinerama
        libXxf86vm
        libxcb
        libxshmfence

        # GUI — useful for launchers, Unity programs, VR utilities, etc.
        gtk3
        cairo
        pango
        gdk-pixbuf
        fontconfig
        freetype

        # Audio
        alsa-lib
        libpulseaudio
        pipewire

        # USB / device access — relevant for VR hardware
        libusb1
        systemd # provides libudev

        # IPC
        dbus

        # Common multimedia deps
        ffmpeg

        # SDL is common in games / VR utilities
        SDL2

        # AppImages
        fuse3

        # Often needed by Electron/Chromium-ish foreign apps
        nspr
        nss
      ];
    })
  ];
}
