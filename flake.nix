{
  description = "rapidshell - an opinionated quickshell config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = { self, nixpkgs, systems, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);

    in {
      # TODO: add homeManagerModule

      packages = eachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.writeShellApplication {
          name = "rapidshell";
          text = ''
            ${nixpkgs.legacyPackages.${system}.quickshell}/bin/quickshell --path ${./src} "$@"
          '';
        };
      });

      devShells = eachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          name = "rapidshell dev shell";
          packages = with nixpkgs.legacyPackages.${system}; [ quickshell ];
        };
      });
  };
}

