{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings.user.name = "qsxDree";
    settings.user.email = "kurling.town@gmail.com";

    ignores = [
      ".direnv"
      "result"
    ];
  };
}
