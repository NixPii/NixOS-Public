{pkgs, ...}: let
  bsmanager = pkgs.fetchurl {
    name = "BSManager-1.6.0-x86_64.flatpak";
    url = "https://github.com/Zagrios/bs-manager/releases/download/v1.6.0/BSManager-1.6.0-x86_64.flatpak";
    sha256 = "0mnlnin77bqzb9qb1c54rgkp1m9v6lz8slgxx6irlf6m928r638r";
  };
in {
  services.flatpak = {
    enable = true;

    remotes = {
      flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      flathub-beta = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };

    packages = [
      "flathub:app/com.github.tchx84.Flatseal//stable"
      "flathub:app/com.github.PintaProject.Pinta//stable"
      "flathub:app/org.vinegarhq.Sober//stable"
      "flathub:app/io.github.alainm23.planify//stable"
      "flathub:app/com.usebottles.bottles//stable"

      ":${bsmanager}"
    ];

    onCalendar = "weekly";
    forceRunOnActivation = true;
  };
}
# Basic configuration going for full declerative flatpak usage, this will be expanded before pushing to main
