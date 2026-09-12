{...}: {
  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=ghostty
    TerminalEmulatorDismissed=true
  '';

  xdg.dataFile."xfce4/helpers/ghostty.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=X-XFCE-Helper
    Name=Ghostty
    Icon=com.mitchellh.ghostty
    NoDisplay=true
    X-XFCE-Binaries=ghostty;
    X-XFCE-Category=TerminalEmulator
    X-XFCE-Commands=%B --gtk-single-instance=false --window-inherit-working-directory=false --working-directory=inherit;
    X-XFCE-CommandsWithParameter=%B --gtk-single-instance=false --window-inherit-working-directory=false --working-directory=inherit -e %s;
  '';
}
