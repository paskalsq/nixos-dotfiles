{ pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.gamescope.enable = true;
  programs.dms-shell.enable = true;

  programs.git = {
    enable = true;
    config.safe.directory = "/home/paskalsq/nixos-dotfiles";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extest.enable = true;
  };

  programs.proxychains = {
    enable = true;
    chain.type = "strict";
    proxies.myproxy = {
      enable = true;
      type = "socks5";
      host = "127.0.0.1";
      port = 10808;
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [
        mpv
        mesa
        libGL
        libva
        libvdpau
        vulkan-loader
        libglvnd
      ];
    };
  };
}
