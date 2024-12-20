{
  pkgs ? import <nixpkgs> {},
  # not sure how to nicely share this between default.nix and shell.nix
  fenix ? import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") {inherit pkgs;},
}:
pkgs.mkShell {
  inputsFrom = [(pkgs.callPackage ./default.nix {inherit pkgs fenix;})];
}
