{
  config,
  lib,
  pkgs,
  ...
}: {
  users.groups.nixpii = {
    gid = 1000;
  };

  users.users.nixpii = {
    isNormalUser = true;
    group = "nixpii";
    extraGroups = ["wheel" "wireshark" "kvm" "libvirt" "docker" "dialout" "libvirtd" "ydotool" "video" "render"];
    uid = 1000;
    createHome = true;
    home = "/home/nixpii";
    description = "nixpii";
    shell = pkgs.zsh;
  };
}
