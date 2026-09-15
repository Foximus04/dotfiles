-- Workspace rules ------------------------------------------------------------:
monitors = hl.get_monitors()

if #monitors == 2 then for ws = 1, 10 do
	hl.workspace_rule({
		workspace = ws,
		monitor = monitors[ws % 2 + 1].name,
	})
end end

float_size = { 1000, 600 }
float_list = { "mpv", "bitwarden", "localsend", "^.*ant_simulator_7.*$", "Minecraft.*" }


-- Window rules ---------------------------------------------------------------:

hl.window_rule({
  name = "floating-window",
  match = { tag = "floating" },

  float = true,
  size  = float_size
})

for _, v in ipairs(float_list) do
  hl.window_rule({ 
    match = { class = v },  
    float = true,
    -- size  = float_size

  })
end

hl.window_rule({ match = { class = "^.*.py.*$" }, opacity = "1.0 override 0.8" })
hl.window_rule({
	match = { class = "kitty" },
	scroll_touchpad = 1.5,
	-- opacity = "1 override 0.75 override"
	})
