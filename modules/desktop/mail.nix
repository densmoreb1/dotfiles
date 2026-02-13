{
  username,
  pkgs,
  ...
}: {
  systemd.timers."refresh-mail" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };

  systemd.services."refresh-mail" = {
    script = ''
      ${pkgs.mutt-wizard}/bin/mailsync
    '';
    serviceConfig = {
      Type = "oneshot";
      User = username;
    };
  };

  environment.systemPackages = with pkgs; [
    isync
    lynx
    msmtp
    mutt-wizard
    neomutt
  ];
}
