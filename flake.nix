{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = with pkgs;
          stdenvNoCC.mkDerivation {
            pname = "year-of-bot";
            version = "0.1.0";

            src = ./.;

            runtimeInputs =
              [ python python3Packages.aiohttp python3Packages.yarl ];

            installPhase = ''
              mkdir -p $out/bin
              cp * $out/bin
              chmod +x $out/bin/year-of-bot.py
            '';

            meta = {
              description = "A Pleroma bot that makes technology predictions.";
              mainProgram = "year-of-bot.py";
            };
          };

        devShells.default = with pkgs;
          mkShell {
            buildInputs = [ python3Packages.aiohttp python3Packages.yarl ];
          };
      });
}
