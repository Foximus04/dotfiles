package.path = os.getenv("HOME") .. "/.config/?.lua;" .. package.path

require("hypr.keybinds")
require("hypr.looknfeel")
require("hypr.input")
require("hypr.rules")
require("hypr.style")

-- hl.env("HYPRCURSOR_THEME", "Empty-Butterfly-White")
-- hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Empty-Butterfly-White")
hl.env("XCURSOR_SIZE", "24")
-- GTK_THEME overrides settings.ini AND gtk-application-prefer-dark-theme,
-- and hides typos as "no theme at all". Use ~/.config/gtk-3.0/settings.ini instead.
-- hl.env("GTK_THEME", "my-gtk-theme")


-- hl.unbind("SUPER + RETURN") hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))

for _,m in ipairs(hl.get_monitors()) do
	hl.monitor({
		output = m.name,
		mode = "highres",
		position = "auto",
		scale = 1,
	})
end

-- laptop screen:
hl.monitor({
  output   = "eDP-1", 
  mode     = "2560x1600@90.00Hz", 
  position = "0x0", 
  scale    = 1.33334
})


hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --all")
  hl.exec_cmd("gentoo-pipewire-launcher")
	hl.exec_cmd("waybar")
	hl.exec_cmd("mako")
	hl.exec_cmd("hyprpaper")


  -- hl.exec_cmd("$HOME/.config/theme/wallpaper.sh init")
  -- hl.exec_cmd("hypridle")
end
)
