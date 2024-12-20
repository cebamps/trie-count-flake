{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    systems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (
        system:
          f {
            pkgs = nixpkgs.legacyPackages.${system};
            fenix = inputs.fenix.packages.${system};
          }
      );
  in {
    packages = forAllSystems ({
      pkgs,
      fenix,
    }: {
      default = pkgs.callPackage ./default.nix {inherit pkgs fenix;};
    });

    devShells = forAllSystems ({
      pkgs,
      fenix,
    }: {
      default = pkgs.callPackage ./shell.nix {inherit pkgs fenix;};
    });
  };
}
