# ~/.nixos/programs/default.nix
{ ... }: {
  imports = [
    ./gaming.nix
    ./packages.nix
    ./mouse.nix
    ./music.nix
    ./krisp.nix
  ];
}
