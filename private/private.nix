{lib, ...}: let
  dir = ./nix;

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
      "Tip: No private NixOS modules found. Add .nix files to ./private/nix/ to have them imported automatically."
      []
    else modules;
}
