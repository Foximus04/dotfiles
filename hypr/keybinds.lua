local function launch(name, opts)
    local program = name or {}
    local opts = opts or {}

    rules   = opts.rules or {}
    args    = opts.args or ""

    if opts.focus == true then
        for _, w in ipairs(hl.get_windows() or {}) do
            if w.class and string.lower(w.class) == string.lower(opts.altname or name) then
                hl.dispatch(hl.dsp.focus({ window = w }))
                return
            end
        end
    end

    if opts.tui == true then
        program = terminal .. " --app-id=" .. name .. " -e " .. name
    end

    if opts.float == true then 
        rules.float = true
        rules.size = float_size
    end

    hl.dispatch(hl.dsp.exec_cmd(program .. ' ' .. args, rules))
end

local function send_shortcut_once(mods, key)
    return function()
        hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down", window = "activewindow" }))

        hl.timer(function()
            hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up", window = "activewindow" }))
        end, { timeout = 50, type = "oneshot" })
    end
end

local function web_shortcut(url)
  if hl.get_active_window().class == "firefox" then
      launch("firefox " .. url)
    return
  end
    launch("firefox --new-window " .. url)
end

terminal 		= "kitty"
float_size 		= { 1280, 800 }

hl.config({
    binds = {
        hide_special_on_workspace_change = true,
        workspace_center_on = 0
    }
})


-- Launch ---------------------------------------------------------------------:
hl.bind("SUPER + RETURN", 			function() launch(terminal) end)
hl.bind("SUPER + SHIFT + RETURN", 	function() launch(terminal,		{ float = true }) end)
hl.bind("SUPER + E",     			function() launch("yazi",   	{ tui   = true }) end)
hl.bind("SUPER + SHIFT + E", 		function() launch("yazi",		{ tui   = true, rules = { tag = "floating" } }) end)
hl.bind("SUPER + M",     			function() launch("spotify",	{ focus = true }) end)
hl.bind("SUPER + B",     			function() launch("firefox") end)      
hl.bind("SUPER + D",     			function() launch("flatpak run dev.vencord.Vesktop",	        { altname = "vesktop",   focus = true, rules = { workspace = "special:scratchpad" } }) end)
hl.bind("SUPER + SLASH", 			function() launch("flatpak run com.bitwarden.desktop", 	        { altname = "bitwarden", focus = true, float = true }) end)
hl.bind("SUPER + L", 			    function() launch("flatpak run org.localsend.localsend_app", 	{ altname = "localsend", focus = true, float = true }) end)


-- Control:
-- 	Launch tuis
hl.bind("SUPER + CTRL + A", function() launch("wiremix",	{ tui = true, focus = true, float = true, args = " -v output" }) end)
hl.bind("SUPER + CTRL + B", function() launch("bluetui",	{ tui = true, focus = true, float = true }) end)
hl.bind("SUPER + CTRL + W", function() launch("nmtui",  	{ tui = true, focus = true, float = true }) end)
hl.bind("SUPER + CTRL + T", function() launch("btop",   	{ tui = true, focus = true, float = true }) end)

-- 	Trigger & toggle
hl.bind("SUPER + CTRL + I", 	        hl.dsp.exec_cmd("pkill hypridle || hypridle"))
hl.bind("SUPER + CTRL + N", 	        hl.dsp.exec_cmd("pkill hyprsunset || hyprsunset -t 4000")) 
hl.bind("SUPER + CTRL + L", 	        hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + CTRL + R", 	        hl.dsp.exec_cmd("/home/fox/.config/theme/apply.sh"))
hl.bind("SUPER + CTRL + COMMA",         hl.dsp.exec_cmd("makoctl mode -t do-not-disturb"))
hl.bind("SUPER + CTRL + SPACE",         hl.dsp.exec_cmd("/home/fox/.config/theme/wallpaper.sh next"))
hl.bind("SUPER + CTRL + SHIFT + SPACE", hl.dsp.exec_cmd("/home/fox/.config/theme/apply.sh"))


-- Web shortcuts:
hl.bind("SUPER + F1", function() web_shortcut("https://wiki.hypr.land/Configuring/Basics/Dispatchers/") end)
hl.bind("SUPER + F2", function() web_shortcut("https://wiki.gentoo.org/wiki/Handbook:AMD64") end)


-- Debug stuff:
hl.bind("SUPER + ALT + SEMICOLON", hl.dsp.exec_cmd("~/.local/bin/get-window-property.sh class"))


-- Window controls ------------------------------------------------------------:
hl.bind("SUPER + F",        	    hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }))
hl.bind("SUPER + SHIFT + F",  	    hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + W",          	    hl.dsp.window.close())

hl.bind("SUPER + J",         	    hl.dsp.layout("togglesplit"))
hl.bind("SUPER + P",                hl.dsp.window.pseudo())
hl.bind("SUPER + T",         	    hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + T", 	    hl.dsp.window.pin())

hl.bind("SUPER + LEFT",   		    hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + RIGHT",  		    hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + UP",     		    hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + DOWN",   		    hl.dsp.focus({ direction = "d" }))

hl.bind("SUPER + SHIFT + LEFT",     hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + RIGHT",    hl.dsp.window.swap({ direction = "r" }))
hl.bind("SUPER + SHIFT + UP",       hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + SHIFT + DOWN",     hl.dsp.window.swap({ direction = "d" }))

hl.bind("SUPER + mouse:272", 	    hl.dsp.window.drag(),    { mouse = true })
hl.bind("SUPER + mouse:273", 	    hl.dsp.window.resize(),  { mouse = true })

-- Workspace controls ---------------------------------------------------------:
for workspace = 1, 10 do
    local key = "code:" .. tostring(workspace + 9)
    hl.bind("SUPER + "                .. key, hl.dsp.focus(      { workspace = tostring(workspace) }))
    hl.bind("SUPER + SHIFT + "        .. key, hl.dsp.window.move({ workspace = tostring(workspace) }))
    hl.bind("SUPER + SHIFT + ALT + "  .. key, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end
-- Scractchpad:
hl.bind("SUPER + S",            hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + S",    hl.dsp.window.move({ workspace = "special:scratchpad", follow = true }))

-- Clipboard:
hl.bind("SUPER + C", function() send_shortcut_once("CTRL", "Insert")  end)
hl.bind("SUPER + V", function() send_shortcut_once("SHIFT", "Insert") end)
hl.bind("SUPER + X", function() send_shortcut_once("CTRL", "X")       end)
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd("walker -m clipboard"))

-- F-keys:
-- 	Volume
hl.bind("XF86AudioRaiseVolume",   	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 0.05+ && $HOME/.config/quickshell/scripts/osd.sh volume"), 	{ repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",   	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 0.05- && $HOME/.config/quickshell/scripts/osd.sh volume"), 	{ repeating = true, locked = true })
hl.bind("XF86AudioMute",          	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle && $HOME/.config/quickshell/scripts/osd.sh volume"),  	{ repeating = true, locked = true })
hl.bind("XF86AudioMicMute",       	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),	{ repeating = true, locked = true })
-- 	Brightness
hl.bind("XF86MonBrightnessUp",    	hl.dsp.exec_cmd("brightnessctl --class=backlight s 10%+ && $HOME/.config/quickshell/scripts/osd.sh brightness"), 	 { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",  	hl.dsp.exec_cmd("brightnessctl --class=backlight s 10%- && $HOME/.config/quickshell/scripts/osd.sh brightness"), 	 { locked = true, repeating = true })
-- 	Media
hl.bind("XF86AudioNext",  			hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", 			hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  			hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  			hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

-- Menus ----------------------------------------------------------------------:
hl.bind("SUPER + SPACE", function() launch("walker") end)

-- Other controls -------------------------------------------------------------:
-- Notifications:
hl.bind("SUPER + SHIFT + SPACE",  hl.dsp.exec_cmd("systemctl --user restart quickshell"))
hl.bind("SUPER + COMMA",          hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind("SUPER + SHIFT + COMMA",  hl.dsp.exec_cmd("makoctl dismiss --all"))
hl.bind("SUPER + ALT + COMMA",    hl.dsp.exec_cmd("makoctl invoke"))

-- Screenshot:
hl.bind("PRINT",          hl.dsp.exec_cmd("hyprshot --clipboard-only -m region"))
hl.bind("SUPER + PRINT",  hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"))
