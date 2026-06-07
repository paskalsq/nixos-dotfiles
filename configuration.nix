{ config, lib, pkgs, ... }:

{
  imports =
    [ 

    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    extraGroups = [ "wheel" "libvirtd" "docker" ];
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
  programs.dconf.enable = true;  
  virtualisation.docker = {
  enable = true;
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
  ];
  programs.zsh.enable = true;
  # services.v2raya.enable = true;
  # for later
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05"; 

}

