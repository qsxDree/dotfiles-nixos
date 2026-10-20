{
  config,
  lib,
  pkgs,
  ...
}: let
  # Declarative settings. Enforced on every rebuild; anything NOT listed here
  # (fonts, theme, layout, ...) stays editable from the VS Code UI.
  baseSettings = {
    # Updates are managed by Nix
    "update.mode" = "none";

    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;

    "security.workspace.trust.untrustedFiles" = "open";

    # Git
    "git.enableSmartCommit" = true;
    "git.autofetch" = true;
    "git.confirmSync" = false;
    "gitlens.hovers.annotations.changes" = false;
    "gitlens.hovers.avatars" = false;

    # Go
    "editor.semanticHighlighting.enabled" = true;
    "gopls" = {
      "ui.semanticTokens" = true;
    };

    # Editor behavior
    "editor.codeActionsOnSave" = {
      "source.organizeImports" = "explicit";
    };
    "editor.inlineSuggest.enabled" = false;
    "editor.formatOnSave" = false;
    "editor.formatOnPaste" = true;

    # Disable organize imports for C/C++ to prevent infinite loading on save
    "[cpp]" = {
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "never";
      };
    };
    "[c]" = {
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "never";
      };
    };

    # C/C++ settings
    "C_Cpp.autocompleteAddParentheses" = true;
    "C_Cpp.formatting" = "vcFormat";
    "C_Cpp.vcFormat.newLine.closeBraceSameLine.emptyFunction" = true;
    "C_Cpp.vcFormat.newLine.closeBraceSameLine.emptyType" = true;
    "C_Cpp.vcFormat.space.beforeEmptySquareBrackets" = true;
    "C_Cpp.vcFormat.newLine.beforeOpenBrace.block" = "sameLine";
    "C_Cpp.vcFormat.newLine.beforeOpenBrace.function" = "sameLine";
    "C_Cpp.vcFormat.newLine.beforeElse" = false;
    "C_Cpp.vcFormat.newLine.beforeCatch" = false;
    "C_Cpp.vcFormat.newLine.beforeOpenBrace.type" = "sameLine";
    "C_Cpp.vcFormat.space.betweenEmptyBraces" = true;
    "C_Cpp.vcFormat.space.betweenEmptyLambdaBrackets" = true;
    "C_Cpp.vcFormat.indent.caseLabels" = true;
    "C_Cpp.intelliSenseCacheSize" = 2048;
    "C_Cpp.intelliSenseMemoryLimit" = 2048;
    "C_Cpp.default.browse.path" = [
      ''''${workspaceFolder}/**''
    ];
    "C_Cpp.default.cStandard" = "gnu11";
    "C_Cpp.inlayHints.parameterNames.hideLeadingUnderscores" = false;
    "C_Cpp.intelliSenseUpdateDelay" = 500;
    "C_Cpp.workspaceParsingPriority" = "medium";
    "C_Cpp.clang_format_sortIncludes" = true;
    "C_Cpp.doxygen.generatedStyle" = "/**";
    "C_Cpp.default.intelliSenseMode" = "linux-clang-x64";
    "C_Cpp.intelliSenseEngine" = "default";
    "clangd.path" = "${pkgs.clang-tools}/bin/clangd";

    # Nix IDE settings
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    "nix.serverSettings" = {
      "nixd" = {
        "formatting" = {
          "command" = ["${pkgs.alejandra}/bin/alejandra"];
        };
      };
    };
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
    };
  };

  baseSettingsFile = pkgs.writeText "vscode-base-settings.json" (builtins.toJSON baseSettings);
  settingsPath = "${config.xdg.configHome}/Code/User/settings.json";
in {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Nix
        bbenoist.nix
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        # Git
        eamodio.gitlens
        github.vscode-github-actions
        # Markdown
        yzhang.markdown-all-in-one
        # Python
        ms-python.python
        ms-python.vscode-pylance
        # C/C++
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        # Go
        golang.go
        # Utility
        mkhl.direnv
      ];

      # NOTE: do NOT set userSettings here. That makes home-manager
      # generate a read-only settings.json symlink.

      # keybindings.json is still a read-only symlink. Edit keys here, not in the UI.
      keybindings = [
        {
          key = "ctrl+q";
          command = "editor.action.commentLine";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+s";
          command = "workbench.action.files.saveFiles";
        }
      ];
    };
  };

  # Merge the declarative settings into a normal, writable settings.json.
  # Declared keys win on every rebuild; all other keys are preserved.
  home.activation.vscodeSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
    settings="${settingsPath}"
    mkdir -p "$(dirname "$settings")"

    # Replace a leftover store symlink with a real, writable copy
    if [ -L "$settings" ]; then
      cp --remove-destination "$(readlink -f "$settings")" "$settings"
    fi
    [ -f "$settings" ] || echo '{}' > "$settings"
    chmod u+w "$settings"

    tmp="$(mktemp)"
    if ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$settings" ${baseSettingsFile} > "$tmp"; then
      mv "$tmp" "$settings"
      chmod u+w "$settings"
    else
      rm -f "$tmp"
      echo "vscode: could not merge settings.json (invalid JSON?), left unchanged" >&2
    fi
  '';

  # direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # Or enableZshIntegration if you use Zsh
    nix-direnv.enable = true;
  };
}
