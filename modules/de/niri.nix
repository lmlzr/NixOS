{ config, pkgs, ... }:
{
    programs.niri.enable = true;
    services.displayManager.sddm = {
      wayland.enable = true;
      enable = true;
    }
  #  services.xserver.enable = true;
  # Configure keymap in X11
  /*services.xserver.xkb = {
    layout = "de";
    variant = "";
  };*/
}