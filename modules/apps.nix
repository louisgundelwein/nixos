{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget 
    git 
    vim 
    zsh 
    btop 
    pnpm 
    nodejs_18 
    discord 
    tldr 
    ghostty 
    code-cursor
    vscode 
    freecad 
    unstable.orca-slicer 
    spacenavd 
    webkitgtk_4_1 
    gtk3 
    fnm
    neofetch 
    obsidian 
    gnomeExtensions.pop-shell 
    libreoffice-qt6-fresh 
    xclip
    lazygit
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.firefox = {
    enable = true;
    preferences = {
      "webgl.disabled" = false;
      "layers.acceleration.force-enabled" = true;
      "webgl.force-enabled" = true;
    };
  };

  programs.steam.enable = true;

  virtualisation.docker.enable = true;

  hardware.spacenavd.enable = true;
}
