{ config, pkgs, ... }:
{
  # ...
  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.timeout = 5; # for boot menu to show 5 sek

  # ...

}