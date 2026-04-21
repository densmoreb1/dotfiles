{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system/default.nix
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

  # Hardware
  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/55B0-F077";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/57cfeea5-2c36-4ce5-9ae6-a9c90bb07fa8";
  boot.initrd.luks.devices."cryptmediaroot".device = "/dev/disk/by-uuid/292751bb-6145-4492-9fb5-e1b3eecc751a";
  boot.initrd.luks.devices."cryptmedia1".device = "/dev/disk/by-uuid/d8122567-0284-4989-8402-4d36a358f75d";
  boot.initrd.luks.devices."cryptmedia2".device = "/dev/disk/by-uuid/429508c1-d8a1-4385-b77b-6db7781add70";
  boot.initrd.luks.devices."cryptmedia3".device = "/dev/disk/by-uuid/548def7c-1f1a-47d5-8548-d9530a305f16";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/47deaee9-9beb-4a16-b070-45f3cc76783f";
    fsType = "ext4";
  };

  fileSystems."/mnt/mediaroot" = {
    device = "/dev/disk/by-uuid/f6000c3d-e79f-42a4-86be-4306ab440c40";
    fsType = "ext4";
  };

  fileSystems."/mnt/media1" = {
    device = "/dev/disk/by-uuid/ee6a2939-61b3-43a1-9cd7-ced460c91f2b";
    fsType = "ext4";
  };

  fileSystems."/mnt/media2" = {
    device = "/dev/disk/by-uuid/b4a1e533-812f-4c54-8f53-590811536442";
    fsType = "ext4";
  };

  fileSystems."/mnt/media3" = {
    device = "/dev/disk/by-uuid/ac1168df-4e9c-4cf7-8d83-dcee9f73910f";
    fsType = "ext4";
  };

  fileSystems."/media" = {
    device = "/mnt/media1:/mnt/media2:/mnt/media3:/mnt/mediaroot";
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

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
