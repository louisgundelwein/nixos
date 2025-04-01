{
  # Description of the configuration
  description = "Louis' minimal, modular NixOS config with Home Manager integrated";

  # Inputs: Using nixpkgs (NixOS channel) and Home Manager
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # Ensure Home Manager uses the same nixpkgs version as us
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs: Build a NixOS configuration named "nixos"
  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Our complete configuration is included here:
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}

