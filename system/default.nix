# ~/.nixos/system/default.nix
{...}: {
  imports = [
    ./sysconfig.nix
    ./services.nix
    # ./hardware.nix # TODO: Uncomment, commented for testing
    ./firewall.nix
    ./xdg.nix
  ];
}
