{ config, pkgs, ... }:
{
    systemd.services."systemd-oomd".enable = false;
    boot.initrd.systemd.enable = true;

    nix.settings.max-jobs = "auto";
    nix.settings.cores = 0;
    boot.kernelPackages = pkgs.linuxPackages_xanmod;

  environment.systemPackages = with pkgs; [
    discord
    obsidian
    vscode
    kitty
    spotify
    obs
    prismlauncher
    steam
    lutris
    fuzzel
    firefox
  ];

}