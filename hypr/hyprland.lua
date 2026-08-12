package.path = os.getenv("HOME") .. "/.config/?.lua;" .. package.path

require("hypr.keybinds")
require("hypr.looknfeel")
require("hypr.input")
require("hypr.rules")

hl.env("HYPRCURSOR_THEME", "Empty-Butterfly-White")
hl.env("HYPRCURSOR_SIZE", "24")

-- Monitor --------------------------------------------------------------------:
-- hl.env("GDK_SCALE", 2)  -- removed: forced integer 2x, conflicted with fractional monitor scale 1.33 (made Firefox UI huge)
hl.monitor({
  output   = "eDP-1", 
  mode     = "2560x1600@90.00Hz", 
  position = "0x0", 
  scale    = 1.33334
})
-- hl.monitor({
--  output   = "HDMI-A-1", 
--  mode     = "1920x1080@60.00Hz", 
--  position = "auto-up", 
--  scale    = 1
--})

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --all")  -- push session env (WAYLAND_DISPLAY, HYPRLAND_INSTANCE_SIGNATURE, ...) into the dbus session bus
  hl.exec_cmd("gentoo-pipewire-launcher")  -- start pipewire + pipewire-pulse + wireplumber (OpenRC has no systemd user units); relies on the dbus session env pushed above
  hl.exec_cmd("$HOME/.config/quickshell/scripts/osd.sh init")  -- pre-create OSD state file so it doesn't pop on login
  hl.exec_cmd("quickshell kill ; quickshell")
  -- hl.exec_cmd("elephant")
  -- hl.exec_cmd("walker --gapplication-service")
  hl.exec_cmd("$HOME/.config/theme/wallpaper.sh init")  -- starts hyprpaper + restores last wallpaper
  hl.exec_cmd("hypridle")
end
)

-- require("hypr.current_theme.theme.hyprland")

