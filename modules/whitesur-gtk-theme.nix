{ config, pkgs, ... }:

let
  whitesur-gtk-theme = pkgs.stdenv.mkDerivation {
    pname = "whitesur-gtk-theme";
    version = "2023-10-10"; # adjust to the commit/tag you want

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-gtk-theme";
      rev = "2023-10-10"; # commit or tag
      sha256 = "sha256-PLACEHOLDER"; # fix this after first build
    };

    nativeBuildInputs = [ pkgs.gnome.gnome-themes-extra ];

    installPhase = ''
      mkdir -p $out/share/themes
      ./install.sh -d $out/share/themes -l
    '';
  };
in {
  environment.systemPackages = with pkgs; [
    whitesur-gtk-theme
    whitesur-icon-theme
    gnome-themes-extra
  ];

  # Enable dconf (system-wide GSettings database)
  programs.dconf.enable = true;

  # Set GTK theme system-wide
  environment.sessionVariables = {
    GTK_THEME = "WhiteSur-Light";
  };

}
