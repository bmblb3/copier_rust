{
  description = "flake for rust development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustToolchain = pkgs.rust-bin.nightly."2025-10-01".default.override {
          extensions = [
            "rust-analyzer"
            "rust-src"
          ];
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = [
              bacon
              cargo-nextest
              cargo-release
              #FIXME: curl # if publishing to artifactory
              #FIXME: gh # if publishing to github
              git-cliff
              gnutar
              jq
              just
              pre-commit
              ra-multiplex
              rustToolchain
              #FIXME: other dependencies
            ];
          };
      }
    );
}
