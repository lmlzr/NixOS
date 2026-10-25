{ pkgs, ... }:
{
  imports = [ ../common.nix ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  environment.systemPackages = with pkgs; [
    vscode
    kitty
    firefox
    geekbench
    discord
  ];
}
