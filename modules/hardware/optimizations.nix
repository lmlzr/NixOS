{ lib, ... }:

{
  systemd.services.networkManager-wait-online.wantedBy = lib.mkForce [ ];

  nix.settings.auto-optimise-store = true;
  # alte Generationen löschen, die älter als 10 Tage sind
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # komprimierter Swap im RAM
  zramSwap.enable = true;

  boot.kernelModules = [ "sg" ];
}
