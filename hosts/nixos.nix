{ config, pkgs, ... }:

{
  imports = [
    ../modules/hardware-configuration.nix
    ../modules/apps.nix
    ../modules/system.nix
    ../modules/users.nix
    ../modules/whitesur-gtk-theme.nix
    ../modules/home.nix
  ];

  # Basic system configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  nixpkgs.config.allowUnfree = true;
  
  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "24.11"; # Did you read the comment?
}
