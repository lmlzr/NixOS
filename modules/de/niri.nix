{ config, pkgs, ... }:
{
    programs.niri.enable = true;
    services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
}