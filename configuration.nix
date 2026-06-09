{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./modules/thunar.nix
    ];
  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelModules = [ "openrazer-driver" ];
  boot.kernelParams = [ "8250.nr_uarts=0" ];
  
  

  networking = {
  networkmanager.enable = true;
  nameservers = [ "127.0.0.1" "::1" ];
  hostName = "desktop";
  networkmanager.dns = "none";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      require_nolog = true;
      query_log.file = "/var/log/dnscrypt-proxy/query.log";
      forwarding_rules = "/etc/nixos/services/networking/forwarding-rules.txt";
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      server_names = [ "quad9-dnscrypt-ip4-filter-pri" "anon-scaleway-fr" ];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "Europe/Moscow";
  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    displayManager.setupCommands = ''
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
    extraGroups = [ "wheel" "libvirtd" "docker" "openrazer" "adbusers" ];
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
  services.syncthing = {
  enable = true;
  user = "paskalsq";
  dataDir = "/home/paskalsq/.config/syncthing";
  configDir = "/home/paskalsq/.config/syncthing";
  openDefaultPorts = true;
  };

  virtualisation.docker = {
  enable = true;
  enableNvidia = true;
  extraOptions = "--dns 9.9.9.9 --dns 1.1.1.1";
}; 

  systemd.services.docker.after = [ "network.target" ];
  systemd.services.docker.requires = [ "network.target" ];

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
    android-tools
    pulseaudio
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

  allowedTCPPorts = [ 8000 4533 9180 8384 ];
  allowedUDPPorts = [ ];
};

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05"; 

}

