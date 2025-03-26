{ config, pkgs, ... }:

{
  imports = [
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Add these filesystem configurations
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";  # Adjust this to match your system
    fsType = "ext4";  # Adjust if you're using a different filesystem
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";  # Adjust this to match your system
    fsType = "vfat";
  };

  hardware.graphics.enable = true;
  hardware.pulseaudio.enable = false;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
  };

  boot.kernelParams = [ "initcall_blacklist=simpledrm_platform_driver_init" ];
}
