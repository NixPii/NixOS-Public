# ~/.nixos/extra/default.nix
{...}: {
  imports = [
    ./fix-broken.nix
  ];
}
