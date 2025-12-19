{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
  syncthing
  git
  gh
  neovim
  fastfetch
  wget
  gcc
  pulseaudio
  stow
  socat
  cron
  ];

}