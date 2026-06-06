{ config, pkgs, ... }:

{

    imports = [
      ./modules/gtk.nix
      ./modules/git.nix
      ./modules/zsh.nix
    ];

  home.username = "paskal";
  home.homeDirectory = "/home/paskal";
  home.stateVersion = "26.05";

  xdg.configFile."qtile" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/paskal/nixos-dotfiles/config/qtile";
    recursive = true;
  };
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/paskal/nixos-dotfiles/config/nvim";
    recursive = true;
  };


  home.packages = with pkgs; [
  neovim
  ripgrep
  nil
  nixpkgs-fmt
  nodejs
  gcc
  btop
  vesktop
  ayugram-desktop
  steam
  signal-desktop
  v2rayn
  obs-studio
  obsidian
  mpv
  picard
  zerotierone
  prismlauncher
  thunderbird
  qbittorrent
  feh
  libnotify
  flameshot
  rofi
  dracula-theme
  papirus-icon-theme
  bibata-cursors
];

}

