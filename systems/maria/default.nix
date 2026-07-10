{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "maria";

  virtualisation.docker.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      PLATFORM_PROFILE_ON_AC = "balanced";
      WIFI_PWR_ON_AC = "on";
    };
  };

  environment.systemPackages = with pkgs; [
    mergerfs
  ];

  system.stateVersion = "24.11";
}
