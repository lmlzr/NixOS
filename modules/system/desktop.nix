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
    prismlauncher
    steam
    firefox
    mangohud
    protonup-ng
    bottles
    virt-manager
    qemu
    kvmtool
    htop
    yazi
    logiops_0_2_3
    heroic
    parsec-bin
    wgnord
    pavucontrol
    spotdl
    mpv
    fzf
    #clementine
    #finamp
    gimp
    davinci-resolve
  ];
  users.groups.libvirtd.members = ["lmlzr"];
  boot.kernelParams = ["zswap.enabled=1"];
  #virtualisation.libvirt.enable = true;
  #virtualisation.spiceUSBRedirection. enable = true;
  #OBS
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {cudaSupport = true;};
  };
  #steam settings
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "~/.steam/root/compatibilitytools.d";
  };
}

