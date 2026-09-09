# ~/.nixos/system/default.nix
{...}: {
  imports = [
    ./sysconfig.nix
    ./services.nix
    ./hardware.nix
    ./firewall.nix
    #./filesystem.nix
    ./xdg.nix
  ];
}
