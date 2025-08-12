{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "America/New_York";

  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [xterm];

  programs.fish.enable = true;
  programs.hyprland.enable = true;

  services.displayManager.defaultSession = "hyprland";
  services.displayManager.autoLogin = {
    enable = true;
    user = "brandon";
  };

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 79;
      STOP_CHARGE_THRESH_BAT0 = 100;
    };
  };

  virtualisation.docker.enable = true;

  users.users.brandon = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "docker"];
    packages = with pkgs; [
      steam
      mangohud
      gamemode
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    bibata-cursors
    brightnessctl
    btop
    curl
    docker
    dust
    fish
    git
    gnupg
    hyprpaper
    neovim
    nodejs
    openvpn
    pass
    pinentry-qt
    python313
    qutebrowser
    ripgrep
    starship
    stow
    taskwarrior3
    tree
    twingate
    unzip
    vim
    wirelesstools
    wget
    wl-clipboard
    waybar
    wofi
    wofi-pass
    xfce.thunar
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  system.stateVersion = "24.11";
}
