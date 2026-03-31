{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ../../modules/system/default.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "maria";

  systemd.tpm2.enable = false;

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

  ########### Hardware config
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "ehci_pci" "sd_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/47deaee9-9beb-4a16-b070-45f3cc76783f";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/57cfeea5-2c36-4ce5-9ae6-a9c90bb07fa8";

  fileSystems."/mnt/mediaroot" = {
    device = "/dev/disk/by-uuid/f6000c3d-e79f-42a4-86be-4306ab440c40";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptmediaroot".device = "/dev/disk/by-uuid/292751bb-6145-4492-9fb5-e1b3eecc751a";

  fileSystems."/mnt/media1" = {
    device = "/dev/disk/by-uuid/ee6a2939-61b3-43a1-9cd7-ced460c91f2b";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptmedia1".device = "/dev/disk/by-uuid/d8122567-0284-4989-8402-4d36a358f75d";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/55B0-F077";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/media" = {
    device = "/mnt/media1:/mnt/mediaroot";
    fsType = "fuse.mergerfs";
    options = [
      "defaults"
      "allow_other"
      "use_ino"
      "cache.files=off"
      "dropcacheonclose=true"
      "category.create=epmfs"
      "minfreespace=25G"
    ];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
