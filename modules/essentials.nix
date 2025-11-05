{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
  syncthing
  vscode
  git
  kitty
  gh
  neovim
  neofetch
  wget
  ];

}