{ config, pkgs, lib, inputs, ... }:

{
    #auto delete old versions welche älter als 10 tage sind
    nix.gc = {
        automatic = true;
        options = "--delete-older-than 10d";
    };

    
}