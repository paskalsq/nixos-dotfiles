{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  users.users.paskalsq = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "libvirtd"
      "kvm"
      "video"
      "render"
      "docker"
      "openrazer"
      "adbusers"
      "wireshark"
    ];
    packages = with pkgs; [
      tree
    ];
  };
}
