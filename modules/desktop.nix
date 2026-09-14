{ pkgs, ... }:

{
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile = {
      enable = true;
      extraPackages = pythonPackages: with pythonPackages; [
        qtile-extras
      ];
    };
  };
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  environment.sessionVariables = {
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
    XKB_DEFAULT_LAYOUT = "us,ru";
    XKB_DEFAULT_OPTIONS = "grp:alt_shift_toggle";
    DOTNET_ROOT = "${pkgs.dotnet-aspnetcore_9}/share/dotnet";
  };
}
