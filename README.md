# nixos

Louis' flake-based NixOS configuration (host `nixos`).

## Layout

- `flake.nix` — inputs (nixpkgs unstable) and the `nixosConfigurations.nixos` output
- `flake.lock` — pins nixpkgs to an exact commit for reproducible builds
- `configuration.nix` — system config (desktop, packages, NVIDIA, users, ...)
- `hardware-configuration.nix` — generated hardware scan + filesystem mounts

## Rebuild

```sh
sudo nixos-rebuild switch --flake ~/nixos#nixos
```

## Update packages (bump the nixpkgs pin)

```sh
cd ~/nixos
nix flake update
sudo nixos-rebuild switch --flake ~/nixos#nixos
```

## Notes

- Flakes and the new `nix` CLI are enabled via `nix.settings.experimental-features`.
- GPU: NVIDIA RTX 4070 on the proprietary driver (open kernel modules).
- `/mnt/data` is the second SSD (WD_BLACK SN770), ext4.
