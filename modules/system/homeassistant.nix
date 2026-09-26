{...}: {
  services.home-assistant = {
    enable = true;

    # Leave configuration.yaml under Home Assistant's own control. The migrated
    # directory is mostly UI-written state, and adopting that into Nix is a
    # separate job from getting off the container.
    config = null;

    extraComponents = [
      # Set up during onboarding; cheap, and other things reference them.
      "default_config"
      "mobile_app"
      "systemmonitor"

      # Hardware actually on the network.
      "apple_tv"
      "onvif"

      # Camera streaming, paired with the ONVIF cameras above.
      "go2rtc"

      # The Apple TV acts as a Thread border router, and `homekit` is what
      # exposes entities back to Apple Home.
      "thread"
      "homekit"
      "homekit_controller"

      # The Sonoff Zigbee dongle. Listing a serial component is what makes the
      # module grant the service the `dialout` group and char-ttyUSB access, so
      # the stick needs no udev rules of its own.
      "zha"
    ];

    # `lan` is a trusted interface already, so the frontend needs nothing opened.
    openFirewallForComponents = false;
  };
}
