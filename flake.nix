{
  description = "Main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    preload-ng.url = "github:miguel-b-p/preload-ng";
  };

  outputs = { self, nixpkgs,preload-ng, ... }: {
	nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { #vm teil je nach name des systems ändern
		modules = [ 
      ./configuration.nix 
      preload-ng.nixosModules.default
        {
        services.preload-ng.enable = true;
        }
      ];
    
	};

  };
}    