{ config, pkgs, ... }:

let
  whitesur-gtk-theme = pkgs.stdenv.mkDerivation {
    pname = "whitesur-gtk-theme";
    version = "2023-10-10";

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-gtk-theme";
      rev = "2023-10-10";
      hash = "sha256-qJq0Zt2v2fVyF0vRHfYqBWxQGYXRNPtMxGbEJxjYBBs=";
    };

    nativeBuildInputs = [ pkgs.gnome-themes-extra ];

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
