{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      #vulkan-loader
      #vulkan-validation-layers
      #vulkan-extension-layer
    ];
  };
  hardware.amdgpu.opencl.enable = true;

  hardware.amdgpu.overdrive.enable = true;

  hardware.firmware = [pkgs.linux-firmware];

  nixpkgs.config.rocmSupport = true;

  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = ["amdgpu"];

  environment.systemPackages = with pkgs; [
    ollama-rocm
    vulkan-loader
  ];
}
