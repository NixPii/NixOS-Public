{
  description = "NixPii-s NixOS Flake";

  inputs = {
    # Core System packages
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Stable Packages
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    # User Environment & Dots
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim development & Styling
    nvf = {
      url = "github:notashelf/nvf";
    };

    # Noctalia Shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spotify Customization
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen Browser, duh
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # catppuccin
    catppuccin.url = "github:catppuccin/nix";

    # Steam Customization
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix"; # Wiki
    };

    # Temporary xwayland-satelite fix
    nixpkgs-temp = {
      url = "github:NixOS/nixpkgs/edfd59b795cd752c36d2dae60870cffcd23d3fb1";
    };

    #  Piper-Git and Libratbag-Git (Own repo)
    ratbag-git = {
      url = "git+https://codeberg.org/NixPii/piper-git-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private = {
      url = "path:./private"; # TODO, please change this, user.
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nvf,
    catppuccin,
    ratbag-git,
    nixpkgs-temp,
    private,
    ...
  }: let
    system = "x86_64-linux";
    nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
  in {
    nixosConfigurations.nixie = nixpkgs.lib.nixosSystem {
      #system = "x86_64-linux";
      inherit system;

      specialArgs = {
        inherit inputs;
        inherit nixpkgs-stable;
      };

      modules = [
        # ./programs/flatpak-sys.nix
        # Removed, check version logs
        ./configuration.nix
        ./users/noctalia.nix

        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        nvf.nixosModules.default

        {
          # Inlined home-manager config
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.nixpii = {
              imports = [
                # ./home/flatpak.nix
                # Removed, check version logs
                ./home.nix
                catppuccin.homeModules.catppuccin
              ];
            };
            extraSpecialArgs = {inherit inputs;};
            backupFileExtension = "bak";
          };
        }
      ];
    };
  };
}
