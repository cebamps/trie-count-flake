{
  pkgs ? import <nixpkgs> {},
  # not sure how to nicely share this between default.nix and shell.nix
  fenix ? import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") {inherit pkgs;},
}: let
  toolchain = fenix.minimal.toolchain;
  rustPlatform = pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "trie-count";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "danleh";
      repo = pname;
      rev = "2bd85292387efe6c2587848264ed9778fe924c07";
      hash = "sha256-AkSEOaypQ0bRESGcYUIMWyMXYZg6FNXUlJkdYU72bbU=";
    };
    cargoHash = "sha256-0eXji+mwajDlkm917b8T4EO+y4BkC/am583BHxTRUO4=";
    cargoPatches = [
      # https://github.com/rust-lang/regex/issues/1231#issuecomment-2435424560
      ./regex-cargo.patch
    ];
    meta = {
      description = "tc - A trie count command-line utility";
      homepage = "https://github.com/danleh/trie-count";
      license = pkgs.lib.licenses.mit;
      mainProgram = "tc";
    };
  }
