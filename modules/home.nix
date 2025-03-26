{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.toxxic = { pkgs, ... }: {
    home.stateVersion = "24.11";
    
    # Here you can put your home-manager configurations
    home.packages = with pkgs; [
      # Add your personal packages here
    ];

    programs = {
      # Example: Configure git
      git = {
        enable = true;
        userName = "toxxic";
        userEmail = "l.gundelwein@proton.me";
      };
    };

    gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark-Compact";
        package = pkgs.orchis-theme;
      };
    };

  };
} 