{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    pavucontrol
    docker-compose
    librewolf
    polychromatic
    android-tools
    pulseaudio
    wlr-randr
    wl-clipboard
    dnsmasq
    jq
    lutris
    psmisc
    virtiofsd
    mpv
    python3
    dotnet-aspnetcore_9
    dotnet-aspnetcore_10
    webkitgtk_4_1
    libnotify
  ];
}
