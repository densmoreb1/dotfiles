{
  config,
  lib,
  username,
  pkgs,
  ...
}: let
  cfg = config.services.homeBackup;
  hostName = config.networking.hostName;
  homeDir = "/home/${username}";

  backupPaths = lib.concatMapStringsSep " " (p: "'${homeDir}/${p}'") cfg.paths;

  backup = pkgs.writeShellApplication {
    name = "home-backup";
    runtimeInputs = [pkgs.restic];
    text = ''
      export RESTIC_REPOSITORY="b2:bdenzy-homedirs:${hostName}"

      restic backup ${backupPaths} --tag home \
        --exclude '${homeDir}/media/plex'

      restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
    '';
  };
in {
  options.services.homeBackup.paths = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    example = ["Documents" "projects" ".ssh"];
    description = "Paths relative to $HOME to back up to B2. Backup is disabled if empty.";
  };

  config = lib.mkIf (cfg.paths != []) {
    environment.systemPackages = [pkgs.restic];

    sops.secrets."restic-home-env" = {
      sopsFile = ../../secrets/home-backup.yaml;
      key = "env";
      owner = username;
    };

    systemd.services.home-backup = {
      description = "Back up ${username}'s home directory to Backblaze B2";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${backup}/bin/home-backup";
        EnvironmentFile = config.sops.secrets."restic-home-env".path;
        Environment = "HOME=/root";
      };
    };

    systemd.timers.home-backup = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "04:30";
        Persistent = true;
        RandomizedDelaySec = "30m";
        Unit = "home-backup.service";
      };
    };
  };
}
