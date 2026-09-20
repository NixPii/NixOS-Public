# flatpak.nix  -- SYSTEM
{
  services.flatpak = {
    enable = true;

    remotes = {
      flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      flathub-beta = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };

    packages = [
      "flathub:app/com.dec05eba.gpu_screen_recorder//stable"
    ];

    onCalendar = "weekly";
    forceRunOnActivation = true;
  };
}
