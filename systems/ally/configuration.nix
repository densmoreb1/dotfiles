{
  pkgs,
  lib,
  jovian,
  username,
  ...
}: {
  imports = [
    jovian.nixosModules.default
  ];

  boot.loader.timeout = 0;

  networking.hostName = "ally";

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.tlp.enable = lib.mkForce false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.openssh = {
    settings = {
      PasswordAuthentication = lib.mkForce true;
      AllowUsers = ["root"];
      PermitRootLogin = lib.mkForce "yes";
    };
  };

  jovian = {
    steam.enable = true;
    devices.steamdeck.enable = true;
    steam.autoStart = true;
    steam.user = username;
    steam.desktopSession = "plasma";
  };

  environment.systemPackages = with pkgs; [
    firefox
    lzip
    mangohud
    python3
    ryzenadj
  ];

  systemd.services.set-ryzenadj-tdp = {
    description = "Set Ryzen TDP via ryzenadj";
    wantedBy = ["multi-user.target"];
    after = ["network.target"]; # or "multi-user.target"
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=15000 --fast-limit=15000 --slow-limit=15000";
    };
  };

  system.stateVersion = "25.11";
}
