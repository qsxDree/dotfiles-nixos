{pkgs, ...}: {
  # collection of useful CLI apps
  home.packages = with pkgs; [
    tldr
    file
    killall
    libnotify
    htop
    btop
    unzip
    rsync
    trash-cli

    ripgrep
    fd
    uv
  ];
}
