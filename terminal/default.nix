{
  pkgs,
  lib,
  config,
  ...
}: let
  shellAliases = {
    hm = "home-manager";
    v = "nvim";
    # cat = "bat";
    man = "batman";

    S = "systemctl";
    Su = "S --user";
    J = "journalctl";
    Ju = "J --user";
  };
in {
  imports = [
    ./cli-collection.nix
  ];

  programs.zsh = let
    p10kIP =
      # sh
      ''
        # Enable Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

    constants =
      # sh
      ''
      '';

    functions =
      # sh
      ''
      '';

    fzfCompletion =
      # sh
      ''
        # Use fd (https://github.com/sharkdp/fd) for listing path candidates.More actions
        _fzf_compgen_path() { fd --hidden --follow --exclude ".git" . "$1" }
        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() { fd --type d --hidden --follow --exclude ".git" . "$1" }
      '';

    zshCompletion =
      # sh
      ''
        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # ignore case autocompletion
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" # show colors in tab completion
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # disable default zsh completion menu for zsh-tab
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath' # fzf with zoxide

        # bindkey "$terminfo[kcuu1]" history-search-backward
        # bindkey "$terminfo[kcud1]" history-search-forward
        bindkey "''${key[Up]}" fzf-history-widget
      '';

    First =
      lib.mkOrder 500
      # sh
      ''
        ${p10kIP}
      '';

    BeforeCompInit =
      lib.mkOrder 550
      ''
        ${constants}
        ${functions}
        ${fzfCompletion}
      '';

    AfterCompInit =
      lib.mkOrder 1000
      # sh
      ''
        # Load personal p10k prompt config
        [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh

        ${zshCompletion}
      '';

    Last =
      lib.mkOrder 1500
      # sh
      ''
        # Load local config (overrides)
        [[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local
      '';
  in {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autocd = true;
    defaultKeymap = "viins";
    history = {
      path = "${config.xdg.dataHome}/zsh_history";
      size = 5000;
      save = 5000;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };
    enableCompletion = true;
    # completionInit = "autoload -Uz compinit && compinit";
    autosuggestion = {
      # zsh-autosuggestions
      enable = true;
      strategy = ["history" "completion"];
    };
    syntaxHighlighting.enable = true; # zsh-syntax-highlighting, to be sourced at the end
    # historySubstringSearch = {
    #   enable = true;
    #   searchUpKey = "$terminfo[kcuu1]";
    #   searchDownKey = "$terminfo[kcud1]";
    # };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab"; # needs to be loaded after compinit and before zsh-autosuggestions
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      # {
      #   name = "zsh-autosuggestions";
      #   src = pkgs.zsh-autosuggestions;
      #   file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      # }
    ];

    initContent = lib.mkMerge [First BeforeCompInit AfterCompInit Last];

    inherit shellAliases;
  };
  xdg.configFile."zsh/p10k.zsh".source = ./p10k.zsh;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batman];
    config = {
      # theme = "TwoDark";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    extraOptions = ["--octal-permissions"];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
