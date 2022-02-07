{
  description = "QMK build environment";

  # The flake in the current directory.
  # inputs.currentDir.url = ".";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/21.11"; 
    utils.url = "github:numtide/flake-utils";
  };

  outputs = all@{ self, utils, nixpkgs, ... }:
  utils.lib.eachDefaultSystem( system:
  let
    pkgs = import nixpkgs {
      inherit system;
    };
  in {

    # Default overlay, for use in dependent flakes
    overlay = final: prev: { };
    # # Same idea as overlay but a list or attrset of them.
    overlays = { exampleOverlay = self.overlay; };
    # Default module, for use in dependent flakes
    nixosModule = { config, ... }: { options = {}; config = {}; };
    # Same idea as nixosModule but a list or attrset of them.
    nixosModules = { exampleModule = self.nixosModule; };

    # Utilized by `nix develop`
    devShell = pkgs.mkShell rec {
      name = "qmk-build-env";
      buildInputs = with pkgs; [
        pkgsCross.avr.buildPackages.binutils
        pkgsCross.avr.buildPackages.gcc8
        dfu-util
        dfu-programmer
        gcc-arm-embedded
        avrdude
        teensy-loader-cli
        python3Full
        libffi
      ];
    };
  });
}
