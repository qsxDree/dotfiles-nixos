{ pkgs, ... }:

let
  zen-browser-repo = pkgs.fetchFromGitHub {
    owner = "youwen5";
    repo = "zen-browser-flake";
    rev = "master";
    # Updated with the correct hash from your error message
    sha256 = "sha256-4d24Wa/CO8WsSEjKwzFwJXn+oxbI4Bm8xuMR77xJgYI=";
  };
  zen-pkg = import zen-browser-repo { inherit pkgs; };
in
{
  home.packages = [
    zen-pkg.default
  ];
}
