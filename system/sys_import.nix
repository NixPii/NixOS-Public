{...}: {
  imports = [
    ./sysconfig.nix
    ./services.nix
    ./hardware-configuration.nix
    #./hw-test.nix # TODO: Comment
    ./firewall.nix
    ./xdg.nix
  ];
}
