{
  description = "Build configuration for The (Aspirational, Unofficial, Incomplete) Zcash Protocol Book";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem = { pkgs, ... }: {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          pname = "the-zcash-protocol-book";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = [ pkgs.mdbook ];

          buildPhase = ''
            runHook preBuild
            mkdir -p "$out"
            mdbook build --dest-dir "$out"
            runHook postBuild
          '';

          installPhase = "true";
        };
      };
    };
}
