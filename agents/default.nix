{ pkgs, ... }:

{
  imports = [
    ./cursor.nix
    ./antigravity.nix
    ./claude.nix
  ];

  # Shared dependencies for the AI agents
  home.packages = with pkgs; [
    wl-clipboard
  ];
}
