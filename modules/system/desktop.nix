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
  # enable rdp
  services.xrdp.enable = true;

  boot.kernelParams = [
    "scsi_mod.use_blk_mq=1"
    "dm_mod.use_blk_mq=Y"
    "mitigations=off"
    "zswap.enabled=1"
    "iommu=pt"
  ];
  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "kernel.sched_autogroup_enabled" = 0;
    "kernel.sched_min_granularity_ns" = 10000000;
    "kernel.sched_wakeup_granularity_ns" = 15000000;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_fastopen" = 3;
  };

  systemd.services.set-gpu-irq = {
    description = "Set GPU IRQ Affinity";
    wantedBy = [ "multi-user.target" ];
    after = [ "sysinit.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''/bin/sh -c "echo 10 > /proc/irq/112/smp_affinity"'';
    };
  };

}

