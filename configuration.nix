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
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "v4l2loopback" ];
  boot.kernelParams = [ "8250.nr_uarts=0" "nvidia.NVreg_SetPageAttributes=1" "intel_iommu=on" "iommu=pt" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # === Network and Firewall ===
  networking = {
    networkmanager.enable = true;
    nameservers = [ "10.10.10.12" ];
    hostName = "desktop";
    networkmanager.dns = "none";
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    backend = "nftables";
    allowedTCPPorts = [ 8000 4533 9180 8384 8008 1234 5900 ];
    allowedUDPPorts = [ ];
    trustedInterfaces = [ "virbr0" ];
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

  # === GUI, DM === 
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;

  services.xserver = {
    enable = true;
    # displayManager.setupCommands = '';
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    desktopManager.plasma6.enable = true;

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
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  
  NIXOS_OZONE_WL = "1";
  WLR_NO_HARDWARE_CURSORS = "1"; 
  WLR_RENDERER = "vulkan";
  XKB_DEFAULT_LAYOUT = "us,ru";
  XKB_DEFAULT_OPTIONS = "grp:alt_shift_toggle";
  DOTNET_ROOT = "${pkgs.dotnet-aspnetcore_9}/share/dotnet";
};

  # === Pipewire and Security ===
  security.rtkit.enable = true;
    services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    
    wireplumber.extraConfig."51-bluez-ldac" = {
      "monitor.bluez.properties" = {
        "bluez5.a2dp.ldac.quality" = "hq"; 
      };
    };
  };


  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" "input" "video" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };
  security.sudo.enable = true; 
  #security.pam.services.i3lock.enable = true;
  security.pam.services.swaylock.enable = true;
  security.polkit.enable = true;
  
  security.polkit.extraConfig = ''
  polkit.addRule(function(action, subject) {
    if (
      subject.user == "paskalsq" &&
      (
        action.id == "org.freedesktop.login1.power-off" ||
        action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
        action.id == "org.freedesktop.login1.reboot" ||
        action.id == "org.freedesktop.login1.reboot-multiple-sessions"
      )
    ) {
      return polkit.Result.YES;
    }
  });
'';

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
    extraGroups = [ "wheel" "libvirtd" "kvm" "video" "render" "docker" "openrazer" "adbusers" ];
    packages = with pkgs; [
      tree
    ];
  };

  # === System and Other Services ===
  services.dbus.enable = true;
  hardware.openrazer.enable = true;
  services.lact.enable = true;
  services.v2raya.enable = false;
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
    "ebe7fbd445b0ff38"
  ];
};

  

  services.openssh = {
  enable = true;
  openFirewall = true;
  settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "no";
    AllowUsers = [ "paskalsq" ];
    MaxAuthTries = 3;
    PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
  };
};

  services.syncthing = {
    enable = true;
    user = "paskalsq";
    dataDir = "/home/paskalsq/.config/syncthing";
    configDir = "/home/paskalsq/.config/syncthing";
    openDefaultPorts = true;
  };
  services.flatpak.enable = true;

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
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
  };
};

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  # === Programs and Environment Packages ===
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.gamescope.enable = true;
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
    extest.enable = true;
  };
  
  programs.proxychains = {
  enable = true;
  chain.type = "strict";
  proxies = {
    myproxy = {
      enable = true;
      type = "socks5";
      host = "127.0.0.1";
      port = 10808;
    };
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
  programs.dms-shell.enable = true;

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
