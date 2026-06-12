{
  description = "Build configuration for The (Aspirational, Unofficial, Incomplete) Zcash Protocol Book";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.stdenvNoCC.mkDerivation {
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
        });
    };
}
