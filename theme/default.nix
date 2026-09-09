# ~/.nixos/extra/default.nix
{...}: {
  imports = [
    ./fonts.nix
    ./theming.nix
  ];
}
