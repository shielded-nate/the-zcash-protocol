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
            mdbook_stderr="$(mktemp)"
            mdbook build --dest-dir "$out" 2> >(tee "$mdbook_stderr" >&2)
            if grep -q '\[WARN\]' "$mdbook_stderr"; then
              echo "mdbook emitted warnings; failing build."
              exit 1
            fi
            runHook postBuild
          '';

          installPhase = "true";
        };
      };
    };
}
