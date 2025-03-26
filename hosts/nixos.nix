{ config, pkgs, ... }:

{
  imports = [
    ../modules/hardware.nix
    ../modules/apps.nix
    ../modules/system.nix
    ../modules/users.nix
  ];

  networking.hostName = "nixos";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
