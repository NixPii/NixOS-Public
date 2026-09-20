# ~/.nixos/system/default.nix
{...}: {
  imports = [
    ./sysconfig.nix
    ./services.nix
<<<<<<< HEAD
    ./hardware.nix # TODO: Uncomment, commented for testing
=======
    ./hardware-configuration.nix
    #./hw-test.nix # TODO: Comment
>>>>>>> testing
    ./firewall.nix
    ./xdg.nix
  ];
}
