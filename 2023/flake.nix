{
    description = "Advent of Code 2023";

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
      zig.url = "github:mitchellh/zig-overlay";
      unstable = {
          url = "github:NixOS/nixpkgs/nixos-unstable";
        };
    };

    outputs = { self, nixpkgs, unstable, zig, ... }@inputs: let
      system = "aarch64-darwin";
      overlays = [
      (final: prev: {
        zigpkgs = zig.package.${prev.system};
        zig_0_12 = inputs.nixpkgs-zig-0-12.legacyPackages.${prev.system}.zig_0_12;
      })];


      pkgs = import nixpkgs { inherit overlays system;
      };
      unstablePkgs = import unstable { inherit system; };
    in {

       devShells.${system}.default = pkgs.mkShell {
         buildInputs = [
             pkgs.zigpkgs.master
           ];
         };
      };
}
