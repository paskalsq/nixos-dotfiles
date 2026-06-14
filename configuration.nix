{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/thunar.nix
  ];

  system.stateVersion = "26.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Moscow";
  
  # === Boot and Kernel ===
  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelModules = [ "openrazer-driver" ];
  boot.kernelParams = [ "8250.nr_uarts=0" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # === Network and Firewall ===
  networking = {
    networkmanager.enable = true;
    nameservers = [ "127.0.0.1" "::1" ];
    hostName = "desktop";
    networkmanager.dns = "none";
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    backend = "nftables";
    allowedTCPPorts = [ 8000 4533 9180 8384 25565 ];
    allowedUDPPorts = [ ];
  };

  # === dnscrypt-proxy2 ===
  services.dnscrypt-proxy = {
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

  # === GUI, DM and X11 === 
  services.displayManager.ly.enable = true;
  
  services.xserver = {
    enable = true;
   # displayManager.setupCommands = '';
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
  };

  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  environment.sessionVariables = {
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  
  NIXOS_OZONE_WL = "1";
  
  WLR_NO_HARDWARE_CURSORS = "1"; 
  WLR_RENDERER = "vulkan";
  XKB_DEFAULT_LAYOUT = "us,ru";
  XKB_DEFAULT_OPTIONS = "grp:alt_shift_toggle";
};

  # === (Pipewire) and Security ===
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
  security.sudo.enable = false; 
  security.pam.services.i3lock.enable = true;

  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
};
  # === Users and Fonts ===
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

  # === System and Other Services ===
  services.dbus.enable = true;
  hardware.openrazer.enable = true;
  services.lact.enable = true;

  xdg.portal = {
  enable = true;
  wlr.enable = true;
  
  extraPortals = [ 
    pkgs.xdg-desktop-portal-wlr 
    pkgs.xdg-desktop-portal-gtk 
  ];

  config = {
    common = {
      default = [ "wlr" "gtk" ];
    };
  };
};
  
  services.zerotierone = {
  enable = true;
  joinNetworks = [
    "e4da7455b2833e7c"
  ];
};

  services.syncthing = {
    enable = true;
    user = "paskalsq";
    dataDir = "/home/paskalsq/.config/syncthing";
    configDir = "/home/paskalsq/.config/syncthing";
    openDefaultPorts = true;
  };

  # === Virtualisation and Docker ===
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    extraOptions = "--dns 9.9.9.9 --dns 1.1.1.1";
  };

  virtualisation.docker.daemon.settings = {
    data-root = "/home/paskalsq/docker";
  };

  systemd.services.docker.after = [ "network.target" ];
  systemd.services.docker.requires = [ "network.target" ];

  # === Programs and Environment Packages ===
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  programs.git = {
    enable = true;
    config = {
      safe = {
        directory = "/home/paskalsq/nixos-dotfiles";
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    pavucontrol
    docker-compose
    librewolf
    polychromatic
    i3lock
    android-tools
    pulseaudio
    wlr-randr
    wl-clipboard
    awww
  ];
}
