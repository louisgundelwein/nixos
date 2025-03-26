{ config, pkgs, ... }:

{
  imports = [
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
