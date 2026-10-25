{ pkgs, ... }:
let
  kvmtool = pkgs.kvmtool.overrideAttrs (old: {
    env = (old.env or { }) // {
      NIX_CFLAGS_COMPILE = "${(old.env or { }).NIX_CFLAGS_COMPILE or ""} -Wno-error=attributes";
    };
  });
in
{
  imports = [ ../common.nix ];

  #boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    discord
    obsidian
    vscode
    kitty
    spotify
    prismlauncher
    firefox
    mangohud
    #bottles
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
    proton-vpn
    cava
    #clementine
    #finamp
    #spotdl
    universal-android-debloater
    android-tools
    scrcpy
    makemkv
    bat
    baobab
    webcamoid
    amarok
    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    goverlay
    virt-viewer
    azahar
    dolphin-emu
    melonds
    mgba
    remmina
    localsend
    ffmpeg
    qpwgraph
    manga-tui
    element-desktop
    speedtest-cli
    libbluray
    keepassxc
    calibre
    radeontop
    amdenc
    libva-utils
    handbrake
    monero-gui
    iperf3
    ethtool
    teamspeak6-client
    claude-code
    claude-monitor
    tmux
  ];

  #OBS
  programs.obs-studio = {
    enable = true;
    #package = pkgs.obs-studio.override {cudaSupport = true;};
  };

  #steam settings
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # Proton-GE deklarativ; manuell installierte in ~/.steam/root/compatibilitytools.d findet Steam weiterhin
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
  programs.gamemode.enable = true;

  # enable rdp
  services.xrdp.enable = true;

  boot.kernelParams = [ "iommu=pt" ];
  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "kernel.sched_autogroup_enabled" = 0;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_fastopen" = 3;
  };

  services.flatpak.enable = true;

  fileSystems."/mnt/Big_SSD" = {
    device = "/dev/disk/by-uuid/E8F8D591F8D55E7E";
    # ntfs-3g statt ntfs3: Proton-Prefixe enthalten ntfs-3g-Symlinks (IntxLNK), die ntfs3 nicht lesen kann
    fsType = "ntfs-3g";
    options = [
      "uid=1000"
      "gid=100"
      "umask=022"
      "nofail"
    ];
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  fonts = {
    enableDefaultPackages = false;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.amdgpu.initrd.enable = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
  };
}
