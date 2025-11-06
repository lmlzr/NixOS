{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
  syncthing
  git
  gh
  neovim
  neofetch
  wget
  firefox
  tealdeer
  ];

}