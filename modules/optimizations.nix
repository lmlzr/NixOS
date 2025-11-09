{ config, pkgs, lib, inputs, ... }:

{
    #schneller builden
    nix.settings.max-jobs = "auto";
    nix.settings.cores = 0; 
    #auto delete old versions welche älter als 10 tage sind
    nix.gc = {
        automatic = true;
        options = "--delete-older-than 10d";
    };    
}
