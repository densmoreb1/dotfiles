config.load_autoconfig(False)

c.content.cookies.accept = 'no-3rdparty'
c.content.cookies.store = True

c.downloads.location.directory = '~/downloads'

c.zoom.default = '125%'
c.fonts.default_size = '11pt'

c.colors.webpage.darkmode.enabled = True
config.bind('po', 'config-cycle colors.webpage.darkmode.enabled')
