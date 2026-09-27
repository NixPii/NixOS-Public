# ~/.nixos/system/default.nix
{...}: {
  imports = [
    ./sysconfig.nix
    ./services.nix
    ./hardware.nix # TODO: Uncomment, commented for testing
    ./hardware-configuration.nix
    #./hw-test.nix # TODO: Comment
    ./firewall.nix
    ./xdg.nix
  ];
}
