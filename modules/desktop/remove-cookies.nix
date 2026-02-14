{username, ...}: {
  # Remove cookies
  systemd.timers."remove-cookies" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
    };
  };

  systemd.services."remove-cookies" = {
    script = ''
      rm /home/${username}/.local/share/qutebrowser/webengine/Cookies
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
