{ config, pkgs, ... }:

let
  whitesur-gtk-theme = pkgs.stdenv.mkDerivation {
    pname = "whitesur-gtk-theme";
    version = "2023-10-10";

    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-gtk-theme";
      rev = "c20f9cf7e7c09c0d2e54f7659e4cd57c88ba5ef7";
      sha256 = "sha256-SWF77YqrijjXlr3r/EccrEyVBxqCOn6tXIHuRA5ngEY=";
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
