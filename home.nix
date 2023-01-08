{pkgs, ...}:
let
  vars = import ./vars.nix;
  baraction_sh = pkgs.writeShellScriptBin "baraction.sh" ''
    #!/bin/bash

    SLEEP_SEC=5
    COUNT=0

    while :; do
        let COUNT=$COUNT+1
        echo -e "SpectrWm"
        sleep $SLEEP_SEC
    done'';
in
{
  home.username = "th3r00t";
  home.homeDirectory = "/home/th3r00t";
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      hmb = "cd ~/.dotfiles; git add flake.nix home.nix vars.nix; nix run . switch -- --flake ~/.dotfiles/; exec $SHELL -l";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "compleat"
        "dirhistory"
        "fzf"
        "git-auto-fetch"
        "git-extras"
        "git-prompt"
        "gitignore"
        "gpg-agent"
        "history"
        "jsontools"
        "man"
        "nmap"
        "pip"
        "python"
        "ssh-agent"
        "sudo"
        "tmux"
        "vi-mode"
        "zsh-navigation-tools"
      ];
      theme = "agnoster";
    };
  };
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.tmux
    pkgs.alacritty
    pkgs.mu
    pkgs.msmtp
    pkgs.libtool
    pkgs.python3
    pkgs.rnix-lsp
    pkgs.fzf
    pkgs.cachix
    pkgs.xclip
    pkgs.nerdfonts
    pkgs.sqlite
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake
    pkgs.libtool
    pkgs.msmtp
    pkgs.emacs-all-the-icons-fonts
    pkgs.rofi
    pkgs.w3m
    pkgs.spectrwm
    baraction_sh
    pkgs.xlockmore
  ];
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "${vars.font.normal.family}";
      font.normal.size = "${vars.font.size}";
    };
  };
  programs.git = {
    enable = true;
    userName = "th3r00t";
    userEmail = "admin@mylt.dev";
  };
  programs.rofi = {
    enable = true;
    plugins = [];
    terminal = "${pkgs.alacritty}/bin/alacritty";
    font = "monospace 20";
    # font = "${vars.font.normal.family} ${vars.font.size}";
    theme = "dmenu";
    extraConfig = {
      modi = "combi,run,drun,ssh";
      show = "run";
    };
  };
  xsession.enable = true;
  xsession.windowManager.spectrwm = {
    enable = true;
    settings = {
      modkey = "Mod4";
      workspace_limit = 5;
      focus_close = "previous";
      spawn_position = "next";
      border_width = 1;
      tile_gap = 10;
      region_padding = 10;
      disable_border = 1;
      bar_enabled = 1;
      bar_border_width = 0;
      bar_font = "${vars.font.normal.family}:size=${vars.font.size}";
      bar_font_color = "rgb:ff/00/ff";
      bar_action = "${baraction_sh}";
    };
    programs = {
      term = "${pkgs.alacritty}/bin/alacritty";
      rofi = "rofi -show run";
      emacs = "emacsclient -nc -a emacs";
    };
    bindings = {
      term = "Mod+Shift+Return";
      restart = "Mod+Shift+r";
      quit = "Mod+Shift+q";
      rofi = "Mod+p";
      emacs = "Mod+Control+d";
    };
    quirks = {
      Pavucontrol = "FLOAT";
    };
  };
  home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;
}
