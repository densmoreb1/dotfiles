config.load_autoconfig(False)

c.content.cookies.accept = "no-3rdparty"
c.content.cookies.store = True

c.downloads.location.directory = "~/downloads"

c.zoom.default = "125%"
c.fonts.default_size = "11pt"

c.colors.webpage.darkmode.enabled = True
config.bind("po", "config-cycle colors.webpage.darkmode.enabled")

config.bind("gh", "open -- http://192.168.0.70:8081/")
config.bind("st", "open -- qute://settings/")
config.bind("sb", "open -- qute://bindings/")
config.bind("clh", "history-clear")

c.fonts.web.family.sans_serif = "JetbrainsMono Nerd Font"
c.fonts.web.family.standard = "JetbrainsMono Nerd Font"
c.fonts.web.family.fixed = "JetbrainsMono Nerd Font"

c.content.tls.certificate_errors = "ask-block-thirdparty"
