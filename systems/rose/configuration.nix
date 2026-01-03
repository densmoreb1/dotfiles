{
  pkgs,
  jovian,
  username,
  ...
}: {
  imports = [
    jovian.nixosModules.default
  ];

  networking.hostName = "rose";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  jovian = {
    steam.enable = true;
    steam.user = username;
    steam.desktopSession = "hyprland";
    hardware.has.amd.gpu = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    bibata-cursors
    firefox
    gnupg # pass
    hyprpaper
    localsend
    pass # passwords
    pinentry-qt # pass
    python313
    qFlipper
    qutebrowser
    waybar
    wirelesstools
    wl-clipboard
    wofi # app launcher
    wofi-pass # pass
    xfce.thunar
  ];

  system.stateVersion = "25.11";
}
