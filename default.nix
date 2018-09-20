{ nixpkgs ? import <nixpkgs> {}}:

nixpkgs.callPackage ./computer-notes.nix { sphinx = nixpkgs.pkgs.python3Packages.sphinx; }
