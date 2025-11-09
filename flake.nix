{
  description = "Main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
	nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { #vm teil je nach name des systems ändern
		modules = [ ./configuration.nix ];
	};

  };
}
