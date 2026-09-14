{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    # enableNvidia = true;
    extraOptions = "--dns 9.9.9.9 --dns 1.1.1.1";
    daemon.settings = {
      data-root = "/home/paskalsq/docker";
    };
  };
  systemd.services.docker.after = [ "network.target" ];
  systemd.services.docker.requires = [ "network.target" ];

  virtualisation.libvirtd = {
    enable = false;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = false;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
