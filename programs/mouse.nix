# Why do this:
# The last tagged release was 0.18, in 2024, since then lots of device files have been added
# Including one for my mouse
# 0.18 does not have it, and that's the version NixOS has.
{pkgs, inputs, ...}: let
  libratbag-git = inputs.ratbag-git.packages.${pkgs.stdenv.hostPlatform.system}.libratbag-git;
  piper-git = inputs.ratbag-git.packages.${pkgs.stdenv.hostPlatform.system}.piper-git;
in {
  services.ratbagd = {
    enable = true;
    package = libratbag-git;
  };

  environment.systemPackages = [
    piper-git
  ];
}