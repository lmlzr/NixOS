{ config, pkgs, inputs, ... }:

{
  programs.niri.enable = true;
  programs.noctalia.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    fuzzel
    kanshi
    thunar
    quickshell
  ];

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
