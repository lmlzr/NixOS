{ pkgs, ... }:
{
  imports = [ ../common.nix ];
  # WLAN läuft über NetworkManager (configuration.nix)
  boot.kernelPackages = pkgs.linuxPackages_zen;
}
