{ config, pkgs, lib, ... }:

{

  # ------------------------------------------------------------------
  # System State Version
  # ------------------------------------------------------------------
  # Specifies the NixOS release compatibility version.
  system.stateVersion = "24.11";

  # ------------------------------------------------------------------
  # Bootloader Configuration
  # ------------------------------------------------------------------
  # Enables systemd-boot as the bootloader and allows modifying EFI variables.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ------------------------------------------------------------------
  # Hostname and Package Management
  # ------------------------------------------------------------------
  # Sets the hostname and allows installation of proprietary (unfree) software.
  networking.hostName = "nixos";
  nixpkgs.config.allowUnfree = true;

  # ------------------------------------------------------------------
  # Hardware Configuration (auto-generated, see nixos-generate-config)
  # ------------------------------------------------------------------
  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0e6dc805-6913-4b4b-9d9a-eea489411d80";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F2ED-F470";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  # Default network settings: Enables DHCP
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ------------------------------------------------------------------
  # System-wide Packages and Applications
  # ------------------------------------------------------------------
  # These packages were previously defined in modules/apps.nix.
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
    orca-slicer
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
    tree
    protonmail-bridge-gui
    thunderbird
  ];

  # Program-specific settings:
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.firefox = {
    enable = true;
    preferences = {
      # Enables WebGL and hardware acceleration.
      "webgl.disabled" = false;
      "layers.acceleration.force-enabled" = true;
      "webgl.force-enabled" = true;
    };
  };

  programs.steam.enable = true;
  virtualisation.docker.enable = true;
  hardware.spacenavd.enable = true;

  # ------------------------------------------------------------------
  # System Services and Settings
  # ------------------------------------------------------------------
  # These settings were previously in modules/system.nix.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  # Localization: Default locale and additional locale settings.
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

  # Audio and Media: Pipewire configuration for audio management.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  # X Server and Desktop Environment (Gnome)
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "de";
  console.keyMap = "de";

  # ------------------------------------------------------------------
  # Shell and Terminal Configuration
  # ------------------------------------------------------------------
  # Enables Zsh as the default shell and sets up useful aliases.
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
      orcas = "nix --extra-experimental-features \"nix-command flakes\" run github:thiagokokada/nix-alien -- $(which orca-slicer)";
    };
  };

  # Enables redistributable firmware (e.g., for CPU microcode updates).
  hardware.enableRedistributableFirmware = true;

  # ------------------------------------------------------------------
  # User Configuration
  # ------------------------------------------------------------------
  # Previously defined in modules/user.nix.
  users.users.toxxic = {
    isNormalUser = true;
    description = "toxxic";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # ------------------------------------------------------------------
  # Home Manager Configuration
  # ------------------------------------------------------------------
  # Previously defined in modules/home.nix.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.toxxic = { pkgs, ... }: {
    home.stateVersion = "24.11";
    home.packages = with pkgs; [
      # Add additional personal packages here.
    ];
    programs = {
      git = {
        enable = true;
        userName = "toxxic";
        userEmail = "l.gundelwein@proton.me";
      };
      gtk = {
        enable = true;
        theme = {
          name = "Orchis-Dark-Compact";
          package = pkgs.orchis-theme;
        };
      };
    };
  };

  # ------------------------------------------------------------------
  # Notes
  # ------------------------------------------------------------------
  # - system.stateVersion: Specifies the NixOS release version compatibility.
  # - boot.loader.systemd-boot.enable: Enables the systemd-boot bootloader.
  # - nixpkgs.config.allowUnfree: Allows the use of proprietary software.
  # - environment.systemPackages: Packages available system-wide.
  # - users.users: Defines users; in this case, "toxxic".
  # - home-manager.users: Home Manager configuration for the user.
}
