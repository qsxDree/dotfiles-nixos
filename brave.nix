{ config, pkgs, ... }:

{
  # Allow unfree packages for this module
  nixpkgs.config.allowUnfree = true;

  # Install Brave browser
  home.packages = with pkgs; [
    brave
  ];

  # Set environment variables for Brave
  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
    BROWSER = "${pkgs.brave}/bin/brave";
  };
}
