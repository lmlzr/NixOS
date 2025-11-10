{ config, pkgs, ... }:
{
  systemd.services."systemd-oomd".enable = false;
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  environment.systemPackages = with pkgs; [
    discord
    obsidian
    vscode
    kitty
    spotify
    obs-studio
    prismlauncher
    steam
    lutris
    firefox
    geekbench
    mangohud
    protonup-ng
    bottles
    preload
    virt-manager
    qemu
    kvmtool
    htop
    waydroid
    yazi
  ];
  users.groups.libvirtd.members = ["lmlzr"];


  #virtualisation.libvirt.enable = true;
  #virtualisation.spiceUSBRedirection. enable = true;


  #steam settings
  /*
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "~/.steam/root/compatibilitytools.d";
  };
  */

}

