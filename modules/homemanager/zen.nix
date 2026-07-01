{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  stylix.targets.zen-browser.enable = false;

  programs.zen-browser = {
    profiles.default = {
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Quick Links";
            toolbar = true;
            bookmarks = [
              {
                name = "Home";
                url = "http://192.168.0.70:8080";
              }
            ];
          }
        ];
      };
      search = {
        force = true;
        default = "ddg";
      };
      settings = {
        "browser.contentblocking.category" = "strict";
        "zen.urlbar.behavior" = "float";
        "zen.view.compact.hide-tabbar" = true;
        "zen.workspaces.continue-where-left-off" = true;
      };
    };

    policies = let
      mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        installation_mode = "force_installed";
      });
    in {
      ExtensionSettings = mkExtensionSettings {
        "jid1-MnnxcxisBPnSXQ@jetpack" = "privacy-badger17";
      };

      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        SocialTracking = true;
      };
    };
  };
}
