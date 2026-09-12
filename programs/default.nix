# ~/.nixos/programs/default.nix
{...}: {
  imports = [
    ./gaming.nix
    ./packages.nix
    ./dev.nix
    ./mouse.nix
    ./music.nix
    ./krisp.nix
  ];
}
