{lib, ...}: {
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = false;
    keyBindings = {
      normal = {
        "po" = "config-cycle colors.webpage.darkmode.enabled";
        "st" = "open -- qute://settings/";
        "sb" = "open -- qute://bindings/";
        "gH" = "open -t 192.168.1.155:8080";
        "clh" = "history-clear";
      };
    };
    settings = {
      content = {
        cookies.accept = "no-3rdparty";
        cookies.store = true;
        geolocation = false;
        pdfjs = true;
      };
      colors.statusbar.insert.bg = lib.mkForce "#139E41";
      colors.webpage.darkmode.enabled = true;
      downloads.location.directory = "~/Downloads";
      url.start_pages = "192.168.1.155:8080";
      zoom.default = "100%";
    };
  };
}
