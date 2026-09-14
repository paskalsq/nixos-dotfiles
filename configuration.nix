{ ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/desktop.nix
    ./modules/audio.nix
    ./modules/security.nix
    ./modules/users.nix
    ./modules/services.nix
    ./modules/virtualisation.nix
    ./modules/programs.nix
    ./modules/packages.nix
    ./modules/thunar.nix
  ];

  system.stateVersion = "26.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Moscow";
}
