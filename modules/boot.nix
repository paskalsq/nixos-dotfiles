{ config, pkgs, ... }:

{
  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelParams = [
    "8250.nr_uarts=0"
    "nvidia.NVreg_SetPageAttributes=1"
    "intel_iommu=on"
    "iommu=pt"
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  # NFS
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
  fileSystems."/DataHDD" = {
    device = "10.10.10.10:/mnt/nfs";
    fsType = "nfs";
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "_netdev"
      "vers=4.2"
      "soft"
      "timeo=30"
      "retrans=3"
    ];
  };
}
