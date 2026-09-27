{lib, ...}: let
  dir = ./home;

  entries = builtins.readDir dir;

  nixFiles = lib.filter (
    name: let
      type = entries.${name};
    in
      lib.hasSuffix ".nix" name
      && (type == "regular" || type == "symlink")
  ) (builtins.attrNames entries);

  modules = map (name: dir + "/${name}") nixFiles;
in {
  imports =
    if modules == []
    then
      builtins.trace
      "Tip: No private Home Manager modules found. Add .nix files to ./private/home/ to have them imported automatically."
      []
    else modules;
}
