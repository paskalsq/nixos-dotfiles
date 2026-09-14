{ ... }:

{
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "none";
    nameservers = [ "10.10.10.12" "127.0.0.1" ];
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

  # dnscrypt-proxy2
  environment.etc."dnscrypt-proxy/cloaking-rules.txt".text = ''
    *.lan 10.10.10.13
  '';
  
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      require_nolog = true;
      query_log.file = "/var/log/dnscrypt-proxy/query.log";
      forwarding_rules = "/etc/nixos/services/networking/forwarding-rules.txt";
      cloaking_rules = "/etc/dnscrypt-proxy/cloaking-rules.txt";
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


  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "e4da7455b2833e7c"
      "ebe7fbd445b0ff38"
    ];
  };

  services.openssh = {
    enable = false;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "paskalsq" ];
      MaxAuthTries = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };
}
