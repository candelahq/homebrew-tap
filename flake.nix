{
  description = "Candela Homebrew Tap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            gh
            lefthook
          ];

          shellHook = ''
            if [ -d .git ] && ! grep -q 'LEFTHOOK' .git/hooks/pre-commit 2>/dev/null; then
              lefthook install 2>/dev/null
            fi
            echo "🍺 homebrew-tap dev shell ready"
          '';
        };
      }
    );
}
