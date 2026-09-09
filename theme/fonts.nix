{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    dina-font
    proggyfonts
    nerd-fonts.symbols-only
    nerd-fonts._0xproto
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.adwaita-mono
    nerd-fonts.ubuntu-sans
    noto-fonts-color-emoji
    corefonts
    vista-fonts
    gyre-fonts
    inter
    dejavu_fonts
    freefont_ttf
    gentium
    terminus_font
    ubuntu-classic
  ];

  fonts.fontDir.enable = true;
  fonts.fontDir.decompressFonts = true;
}
