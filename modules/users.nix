{ config, pkgs, ... }:

{
  users.users.toxxic = {
    isNormalUser = true;
    description = "toxxic";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
