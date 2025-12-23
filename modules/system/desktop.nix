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
    qemu
    kvmtool
    htop
    yazi
    heroic
    parsec-bin
    pavucontrol
    mpv
    fzf
    gimp
    davinci-resolve
    wgnord
    gamemode
    cava
    #clementine
    #finamp
    #spotdl
    waydroid
    universal-android-debloater
    android-tools
    scrcpy
    makemkv
  ];
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
  boot.kernelParams = [
    "mitigations=off"
    "zswap.enabled=1"
  ];

  #waydorid funktioniert nur mit systemd
  virtualisation.waydroid.enable = true;
  #activate ADB
  programs.adb.enable = true;
  users.users.lmlzr.extraGroups = ["adbusers"];

}

