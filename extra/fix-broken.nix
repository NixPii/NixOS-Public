{
  config,
  lib,
  pkgs,
  nixpkgs-stable,
  ...
}: {
  nixpkgs.overlays = [
    # 1. Vulkan Validation Layer override fix
    (final: prev: {
      vulkan-validation-layers = prev.vulkan-validation-layers.overrideAttrs (old: {
        cmakeFlags = ["-DUPDATE_DEPS=OFF"] ++ old.cmakeFlags;
      });
    })

    # 2. Nautilus gstreamer patch
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    })

    (final: prev: {
      gearlever = prev.gearlever.overrideAttrs (old: {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          (prev.lib.removePrefix
            "--prefix PATH : "
            (builtins.elemAt old.makeWrapperArgs 1))
        ];

        preFixup =
          (old.preFixup or "")
          + ''
            makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
          '';
      });
    })
  ];

  # Temporary fix
  nixpkgs.config.permittedInsecurePackages = ["electron-40.10.5"];

  environment.pathsToLink = ["share/thumbnailers"];

  # Nautilus extensions

  programs.nautilus-open-any-terminal = {
    enable = false;
    terminal = "ghostty";
  };

  environment.systemPackages = with pkgs; [
    nautilus
    gearlever
  ];
}
