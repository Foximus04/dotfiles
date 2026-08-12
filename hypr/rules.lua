-- Workspace rules ------------------------------------------------------------:
for ws = 1, 5 do
  hl.workspace_rule({ 
    workspace = ws,
    monitor   = "eDP-1",
  }) end
for ws = 6, 10 do
  hl.workspace_rule({ 
    workspace = ws,
    monitor   = "HDMI-A-1",
  }) end

float_size = { 800, 600 }
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

hl.window_rule({ match = { class = "firefox" },   opacity = "1.0 override 0.96 override" })
hl.window_rule({ match = { class = "kitty" },     scroll_touchpad = 1.5 })
hl.window_rule({ match = { class = "^.*.py.*$" }, opacity = "1.0 override 0.8" })
