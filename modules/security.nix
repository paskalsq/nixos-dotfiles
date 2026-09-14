{ ... }:

{
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

  # security.pam.services.i3lock.enable = true;
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
}
