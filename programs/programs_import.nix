# ~/.nixos/programs/default.nix
{ ... }: {
  imports = [
    ./packages.nix
    ./mouse.nix
    ./music.nix
    ./krisp.nix
  ];
}
