{
  description = "nix dev environment";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.naersk.url = "github:nix-community/naersk";
  inputs.naersk.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, naersk, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem(system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      naersk' = pkgs.callPackage naersk { };

      deps = [];
    in {
      defaulPackage = naersk'.buildPackage {
        src = ./.;
      };
      devShell = pkgs.mkShell {
        buildInputs = deps;
        nativeBuildInputs = with pkgs; [
          cargo
          pkg-config
          rustc
        ];

        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    });
}
