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
  ];

  # Temporary fix
  nixpkgs.config.permittedInsecurePackages = ["electron-40.10.5"];

  environment.pathsToLink = ["share/thumbnailers"];

  # Niri & LACT work around, suspect: libdisplay-info update 3.0 -> 4.0
  services.lact.package = nixpkgs-stable.lact;

  # Niri messing  up stuff :/
  services.displayManager.defaultSession = lib.mkForce "niri";

  # Nautilus extensions

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  environment.systemPackages = with pkgs; [
    nautilus
    nixpkgs-stable.gearlever
  ];
}
