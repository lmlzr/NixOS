{ config, pkgs, ... }:
{
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  #programs.kdeconnect.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
    konsole
    kdepim-runtime
    kwallet
    kwalletmanager
    kwallet-pam
    khelpcenter
    kinfocenter
  ];
  services.xserver.excludePackages = with pkgs; [ 
    xterm 
    ];
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "lmlzr";
  };
}