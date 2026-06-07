{ config, lib, pkgs, ... }:

{
  imports =
    [ 

    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "openrazer-driver" ];

  networking.hostName = "desktop";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --primary
      ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --right-of DP-1
    '';
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
  };
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
    };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };
  
  security.doas = {
  enable = true;
  extraRules = [
    {
      groups = [ "wheel" ];
      keepEnv = true;
      persist = true;
    }
  ];
};

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  users.users.paskalsq = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "libvirtd" "docker" "openrazer" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.git = {
    enable = true;
    config = {
    safe = {
      directory = "/home/paskalsq/nixos-dotfiles";
      };
    };
  };
  services.dbus.enable = true;
  hardware.openrazer.enable = true;

  virtualisation.docker = {
  enable = true;
  enableNvidia = true;
}; 

  virtualisation.docker.daemon.settings = {
  data-root = "/home/paskalsq/docker";
};
  
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim 
    git
    wget
    alacritty
    pavucontrol
    docker-compose
    librewolf
    polychromatic
    i3lock
  ];
  security.pam.services.i3lock.enable = true;
 
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

networking.nftables.enable = true;

networking.firewall = {
  enable = true;
  backend = "nftables"; 

  allowedTCPPorts = [ 8000 4533 9180 ];
  allowedUDPPorts = [ ];
};

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05"; 

}

