{ config, pkgs, ... }:
{
    systemd.services."systemd-oomd".enable = false;
    boot.initrd.systemd.enable = true;
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    nix.settings.max-jobs = "auto";
    nix.settings.cores = 0;
    boot.kernelPackages = pkgs.linuxPackages_zen;
}