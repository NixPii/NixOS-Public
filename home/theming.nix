# home/catppuccin.nix
{pkgs, ...}: let
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    variant = "macchiato";
    accents = ["pink"];
    size = "standard";
  };

  catppuccinGtkBlue = pkgs.catppuccin-gtk.override {
    variant = "macchiato";
    accents = ["blue"];
    size = "standard";
  };

  catppuccinIcons = pkgs.catppuccin-papirus-folders.override {
    flavor = "macchiato";
    accent = "mauve";
  };

  colloidIcons = pkgs.colloid-icon-theme.override {
    schemeVariants = ["catppuccin"];
    colorVariants = ["purple"];
  };

  commonGtkSettings = {
    "gtk-cursor-blink" = true;
    "gtk-cursor-blink-time" = 1000;
    "gtk-decoration-layout" = "icon:minimize,maximize,close";
    "gtk-enable-animations" = true;
    "gtk-enable-event-sounds" = true;
    "gtk-enable-input-feedback-sounds" = false;
    "gtk-primary-button-warps-slider" = true;
    "gtk-sound-theme-name" = "freedesktop";
  };

  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    variant = "macchiato";
    accent = "pink";
  };

  qtctSettings = {
    Appearance = {
      custom_palette = false;
      style = "kvantum";
      standard_dialogs = "xdgdesktopportal";

      icon_theme = "Papirus-Dark";
      # ion_theme = "Colloid-Purple-Catppuccin-Dark";
    };
    Fonts = {
      # general = ''"Noto Sans,10"'';
      general = "\"Noto Sans,10\"";
    };
  };
in {
  catppuccin = {
    enable = true;
    autoEnable = false;
    flavor = "macchiato";
    accent = "pink";

    fuzzel.enable = true;

    fzf = {
      enable = true;
      flavor = "macchiato";
    };

    eza.enable = true;

    vscode.profiles."catppuccin".enable = true;
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      # Use the overridden package, not pkgs.catppuccin-gtk.
      package = catppuccinGtk;
      name = "catppuccin-macchiato-pink-standard";
    };

    iconTheme = {
      package = catppuccinIcons;
      name = "Papirus-Dark";
    };

    cursorTheme = {
      package = pkgs.catppuccin-cursors.frappeBlue;
      name = "Catppuccin-Frappe-Blue-Cursors";
      size = 24;
    };

    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
      size = 10;
    };

    gtk3.extraConfig =
      commonGtkSettings
      // {
        "gtk-xft-antialias" = 1;
        "gtk-xft-hinting" = 1;
        "gtk-xft-hintstyle" = "hintmedium";
        "gtk-xft-rgba" = "rgb";

        # 98304 / 1024 = 96 DPI
        # "gtk-xft-dpi" = 98304;
        # I have no idea where this came from :D
      };

    gtk4 = {
      # Keep Nautilus/libadwaita native instead of forcing a GTK3 theme.
      theme = null;
      extraConfig = commonGtkSettings;
    };
  };
  # ^ This took me too long
  # V This code will be just bad, because i'm tired

  qt = {
    # Qt
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";

    # Kvantum
    kvantum = {
      enable = true;
      # Defining themes
      themes = [catppuccinKvantum];
      settings = {
        General = {
          theme = "catppuccin-macchiato-pink";
        };

        Applications = {
          # Add application specific settings here
        };
      };
    };
    qt5ctSettings = qtctSettings;
    qt6ctSettings = qtctSettings;
  };
}
