{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings.user.name = "qsxDree";
    settings.user.email = "qsxdreee@gmail.com";

    ignores = [
      ".direnv"
      "result"
    ];
  };
}
