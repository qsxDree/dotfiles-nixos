# multimedia.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Video/Audio players
    vlc
    mpv

    # Audio
    audacity          # audio editor
    pavucontrol       # pulseaudio/pipewire volume control GUI
    playerctl         # media player control from CLI

    # Video/Image editing & tools
    handbrake         # video transcoder
    obs-studio        # screen recording / streaming
    ffmpeg-full       # codecs + CLI conversion
    yt-dlp            # download audio/video from sites

    # Image viewing/editing
    gimp
    feh               # lightweight image viewer

    # Codecs (useful if not already pulled in system-wide)
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  # Optional: make VLC/mpv the default for common media mime types
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/flac" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
    };
  };

  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;

  # Optional: mpv config
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      volume = 70;
    };
  };
}
