{ config, pkgs, ... }:

{

    imports = [
      ./modules/gtk.nix
      ./modules/git.nix
      ./modules/zsh.nix
    ];

  home.username = "paskalsq";
  home.homeDirectory = "/home/paskalsq";
  home.stateVersion = "26.05";

  xdg.configFile."qtile" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/paskalsq/nixos-dotfiles/config/qtile";
    recursive = true;
  };
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/paskalsq/nixos-dotfiles/config/nvim";
    recursive = true;
  };
  
  xdg.configFile."alacritty" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/paskalsq/nixos-dotfiles/config/alacritty";
  };

  home.file.".local/share/v2rayN/bin/xray/xray" = {
    source = "${pkgs.xray}/bin/xray";
  };
  home.file."Music".source = config.lib.file.mkOutOfStoreSymlink "/DataHDD/Music";
  home.file."Documents".source = config.lib.file.mkOutOfStoreSymlink "/DataHDD/Documents";
  home.file."Videos".source = config.lib.file.mkOutOfStoreSymlink "/DataHDD/Videos";
  home.file."Pictures".source = config.lib.file.mkOutOfStoreSymlink "/DataHDD/Pictures";

#  services.redshift = {
#  enable = true;
#
#  provider = "manual";
#  latitude = "51.67204";
#  longitude = "39.1843";
#};

  services.wlsunset = {
    enable = true;
    latitude = "51.67204";
    longitude = "39.1843";
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
  signal-desktop
  v2rayn
  xray
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
  snixembed
  flameshot
  rofi
  dracula-theme
  papirus-icon-theme
  bibata-cursors
  libayatana-appindicator
  libappindicator-gtk3
  lmstudio
];

}

