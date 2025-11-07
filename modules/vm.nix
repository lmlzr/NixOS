{ config, pkgs, ... }:
{
    systemd.services."systemd-oomd".enable = false;
    boot.initrd.systemd.enable = true;

    nix.settings.max-jobs = "auto";
    nix.settings.cores = 0;
    boot.kernelPackages = pkgs.linuxPackages_zen;
    
    
    environment.systemPackages = with pkgs; [
    vscode
    kitty
    firefox
    geekbench
  ];
}
