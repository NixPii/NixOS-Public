throw ''
  No hardware configuration found.

  Generate one from the target NixOS machine with:

    sudo nixos-generate-config --show-hardware-config > ./system/hardware.nix

  `hardware-configuration.nix` is the conventional NixOS filename,
  but this config expects it at:

    ./system/hardware.nix
''
