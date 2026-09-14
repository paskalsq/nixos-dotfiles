{ pkgs, ... }:

{
  services.dbus.enable = true;
  hardware.openrazer.enable = true;
  services.lact.enable = true;
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "wlr" "gtk" ];
  };

  services.syncthing = {
    enable = true;
    user = "paskalsq";
    dataDir = "/home/paskalsq/.config/syncthing";
    configDir = "/home/paskalsq/.config/syncthing";
    openDefaultPorts = true;
  };
}
