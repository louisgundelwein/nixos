{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "de";
  console.keyMap = "de";

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll="ls -l";
      edit="sudo -e";
      update="sudo nixos-rebuild switch";
      orcas="nix --extra-experimental-features \"nix-command flakes\" run github:thiagokokada/nix-alien -- $(which orca-slicer)";
    };
  };

  # Ensure redistributable firmware is enabled for proper CPU microcode updates
  hardware.enableRedistributableFirmware = true;
}
