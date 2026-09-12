{
  config,
  pkgs,
  inputs,
  ...
}: {
  #antigravity
  programs.antigravity.enable = true;

  #antigravity cli
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
  ];
}
