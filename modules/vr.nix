{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nixpii.vr;
in {
  options.nixpii.vr = {
    meta.vr.enable = lib.mkEnableOption ''
      Should we enable Meta Quest 2/3/3S VR support?
    '';
  };

  config = lib.mkMerge [
    (
      lib.mkIf cfg.meta.vr.enable
      {
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
          # Default
          zlib
          zstd
          stdenv.cc.cc
          curl
          openssl
          attr
          libssh
          bzip2
          libxml2
          acl
          libsodium
          util-linux
          xz
          systemd

          # XORG
          libXcomposite
          libXtst
          libXrandr
          libXext
          libX11
          libXfixes
          libGL
          libva
          pipewire
          libxcb
          libXdamage
          libxshmfence
          libXxf86vm
          libelf
          libxcrypt
          libXinerama
          libXcursor
          libXrender
          libXScrnSaver
          libXi
          libSM
          libICE
          libXt
          libXmu
          libogg
          libvorbis
          SDL
          SDL2_image
          glew_1_10
          libidn
          tbb
          libXft
          libvdpau
          xrizer

          # Required
          glib
          gtk2
          gtk3

          # Steam
          networkmanager
          vulkan-loader
          libgbm
          libdrm
          coreutils
          pciutils
          zenity
          glibc_multi.bin

          # Extra
          dconf
          nspr
          nss
          cups
          libcap
          SDL2
          libusb1
          dbus-glib
          ffmpeg
          libudev0-shim

          # needed to run unity
          gtk3
          icu
          libnotify
          gsettings-desktop-schemas

          # Wiki suggests this, and i want to be thorough
          flac
          freeglut
          libjpeg
          libpng
          libpng12
          libsamplerate
          libsamplerate
          libmikmod
          libtheora
          libtiff
          pixman
          speex
          SDL_image
          SDL_ttf
          SDL_mixer
          SDL2_ttf
          SDL2_mixer
          libcaca
          libcanberra
          libgcrypt
          libvpx
          librsvg
          pango
          cairo
          atk
          gdk-pixbuf
          fontconfig
          freetype
          dbus
          alsa-lib
          expat
          libxkbcommon

          # AppImages
          fuse3
          e2fsprogs
          gmp

          # Qt6
          libpulseaudio
          krb5
          libxcb-cursor
          xcbutilwm
          xcbutil
          xcbutilimage
          xcbutilkeysyms
          xcbutilrenderutil
        ];
      }
    )
  ];
}
