{...}: {
  imports = [
    ./gpu.nix
    ./ai.nix
    ./bootloader.nix
    ./virt.nix
    ./vr.nix
    ./dev.nix
    ./imports/neovim.nix
    ./desktop.nix
    ./gaming.nix
  ];
}
