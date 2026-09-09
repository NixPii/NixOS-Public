{
  config,
  lib,
  pkgs,
  ...
}: {
  # Global Theming
  catppuccin = {
    enable = false;
    autoEnable = "catppuccin.disable";
    flavor = "macchiato";
  };
}
