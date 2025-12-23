{ config, pkgs, ... }: 
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5; # for faster boot time
  boot.kernelParams = [ "quiet" ];
}
