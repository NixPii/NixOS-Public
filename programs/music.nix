{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {

  imports = [
    inputs.spicetify-nix.nixosModules.spicetify
  ];

  # Music & MIDI Production / Playback
  environment.systemPackages = with pkgs; [
    linthesia
    lmms-full
    neothesia
    synthesia
    cider-2
    vlc
    mpv
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    enabledExtensions = with spicePkgs.extensions; [
      loopyLoop
      shuffle
      trashbin
      webnowplaying
      powerBar
      betterGenres
      volumePercentage
      sectionMarker
      beautifulLyrics
      aiBandBlocker
      madeForYouShortcut
      romajiConvert
      spicyLyrics
      phraseToPlaylist
      ytVideo
      copyToClipboard
      history
      adblock
      savePlaylists
      fullScreen
      copyLyrics
      bestMoment
      skipStats
      phraseToPlaylist
      copyLyrics

    ];
  };
}
