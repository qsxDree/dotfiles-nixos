{
  config,
  lib,
  pkgs,
  ...
}: {
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
        # Theme
        github.github-vscode-theme
        # Python
        ms-python.python
        ms-python.vscode-pylance
        # C/C++
        ms-vscode.cpptools
        # Go
        golang.go
        # Utility
        mkhl.direnv
      ];

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

      userSettings = {
        "update.mode" = lib.mkForce "none";
        "window.titleBarStyle" = lib.mkForce "custom";
        "window.menuBarVisibility" = lib.mkForce "classic";
        "editor.fontSize" = lib.mkForce 14;
        #         "editor.fontFamily" = lib.mkForce "'MonaspiceKr Nerd Font', monospace";
        #         "workbench.colorTheme" = "Catppuccin Mocha";
        #         "workbench.iconTheme" = "catppuccin-mocha";
        #         "catppuccin.accentColor" = "mauve";
        "vsicons.dontShowNewVersionMessage" = true;
        "explorer.confirmDragAndDrop" = false;
        "editor.fontLigatures" = true;
        "workbench.startupEditor" = "none";
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;

        "security.workspace.trust.untrustedFiles" = "open";

        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "gitlens.hovers.annotations.changes" = false;
        "gitlens.hovers.avatars" = false;

        "editor.semanticHighlighting.enabled" = true;
        "gopls" = {
          "ui.semanticTokens" = true;
        };

        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "explicit";
        };
        "editor.inlineSuggest.enabled" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;

        "editor.minimap.enabled" = false;
        "workbench.sideBar.location" = "left";
        "workbench.layoutControl.type" = "menu";
        "workbench.editor.limit.enabled" = true;
        "workbench.editor.limit.value" = 10;
        "workbench.editor.limit.perEditorGroup" = true;
        "explorer.openEditors.visible" = 0;
        "breadcrumbs.enabled" = true;
        "editor.renderControlCharacters" = false;
        "editor.stickyScroll.enabled" = false;
        "editor.scrollbar.verticalScrollbarSize" = 2;
        "editor.scrollbar.horizontalScrollbarSize" = 2;
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollbar.horizontal" = "hidden";
        "workbench.layoutControl.enabled" = false;

        "editor.mouseWheelZoom" = true;

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
    };
  };
}
