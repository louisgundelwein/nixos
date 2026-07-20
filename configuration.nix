# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-stable, ... }:

let
  codexLatest = pkgs.stdenvNoCC.mkDerivation {
    pname = "codex";
    version = "0.144.6";

    src = pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v0.144.6/codex-x86_64-unknown-linux-musl.tar.gz";
      sha256 = "1im1a62722hy38plkzjwpkik77y86gq3psyqhikfm35dl18yz7ba";
    };

    nativeBuildInputs = with pkgs; [
      installShellFiles
      makeWrapper
    ];

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 codex-x86_64-unknown-linux-musl $out/bin/codex
      wrapProgram $out/bin/codex \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ripgrep pkgs.bubblewrap ]}

      installShellCompletion --cmd codex \
        --bash <($out/bin/codex completion bash) \
        --fish <($out/bin/codex completion fish) \
        --zsh <($out/bin/codex completion zsh)

      runHook postInstall
    '';
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  # Enable flakes and the new nix CLI.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # "mac" variant matches Apple keyboards (printed symbols line up; @ = right Option + L).
  services.xserver.xkb = {
    layout = "de";
    variant = "mac";
  };

  # ----------------------------------------------------------------------
  # NVIDIA GeForce RTX 4070 (Ada) - proprietary driver
  # ----------------------------------------------------------------------
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    # Required for most Wayland compositors and modern setups.
    modesetting.enable = true;
    # Use the open-source kernel modules (recommended for Turing+ / Ada GPUs).
    open = true;
    # Provides the nvidia-settings GUI tool.
    nvidiaSettings = true;
    # Laptop-only dynamic power management; off on desktop.
    powerManagement.enable = false;
    # Pin to the stable production driver branch.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 3Dconnexion SpaceMouse (SpaceNavigator) support via the spacenavd daemon.
  # FreeCAD and other CAD apps talk to it through libspnav.
  # spnavcfg is the GUI to invert/swap axes and tune sensitivity.
  hardware.spacenavd.enable = true;

  # SpaceMouse tuning (captured from spnavcfg). Note: with this managed
  # declaratively, /etc/spnavrc becomes read-only — retune by editing here,
  # or temporarily comment this out to use spnavcfg again and re-capture.
  environment.etc."spnavrc".text = ''
    invert-trans = y
    invert-rot = y
    swap-yz = true
  '';

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."louis" = {
    isNormalUser = true;
    description = "louis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "louis" ];
  };
  programs.steam.enable = true;

  # Run fastfetch when an interactive terminal opens (only when stdout is a tty).
  programs.bash.interactiveShellInit = ''
    if [[ -t 1 ]]; then
      fastfetch
    fi
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    # btop with NVIDIA GPU monitoring (NVML). Driver runpath is wired up
    # automatically so it finds libnvidia-ml at runtime.
    (btop.override { cudaSupport = true; })
    claude-code
    codexLatest
    fastfetch
    # FreeCAD from the stable channel: unstable's build is currently broken
    # (VTK vs GDAL API mismatch). Same version (1.1.1) and pre-built in cache.
    pkgs-stable.freecad
    gh
    git
    ghostty
    google-chrome
    obsidian
    opencode
    orca-slicer
    pciutils
    spnavcfg
    spotify
    vscode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
