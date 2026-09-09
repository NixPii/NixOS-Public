# home.nix
{
  lib,
  pkgs,
  ...
}: {
  services.flatpak = {
    update = {
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };

  # Add here the flatpaks you want to install
  services.flatpak.packages = [
    #{ appId = "com.brave.Browser"; origin = "flathub"; }
    #"com.obsproject.Studio"
    #"im.riot.Riot"
    "com.github.tchx84.Flatseal"
    "com.dec05eba.gpu_screen_recorder"
    #"io.gitlab.librewolf-community"
    "com.github.PintaProject.Pinta"
    "org.vinegarhq.Sober"
    rec {
      appId = "io.bsmanager.bsmanager";
      sha256 = "0mnlnin77bqzb9qb1c54rgkp1m9v6lz8slgxx6irlf6m928r638r";
      bundle = "${pkgs.fetchurl {
        url = "https://github.com/Zagrios/bs-manager/releases/download/v1.6.0/BSManager-1.6.0-x86_64.flatpak";
        inherit sha256;
      }}";
    }
  ];
}
