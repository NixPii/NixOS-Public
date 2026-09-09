{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ollama-rocm
    opencode
    opencode-desktop
  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100"; # used to be necessary, but doesn't seem to anymore
    };
    # results in environment variable "HSA_OVERRIDE_GFX_VERSION=10.3.0"
    rocmOverrideGfx = "11.0.0";
  };

  services.open-webui.enable = false;

  boot.initrd.kernelModules = ["kvm-amd" "v4l2loopback" "snd-aloop" "amdgpu"];
}
