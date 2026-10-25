{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    gh
    neovim
    fastfetch
    wget
    gcc
    stow
    socat
    rar
  ];

  # läuft als Dienst statt per KDE-Autostart; vorhandene Config/Geräte/Ordner bleiben erhalten
  services.syncthing = {
    enable = true;
    user = "lmlzr";
    group = "users";
    dataDir = "/home/lmlzr";
    configDir = "/home/lmlzr/.local/state/syncthing";
    overrideDevices = false;
    overrideFolders = false;
  };
}
