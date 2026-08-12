
-- Look-n-feel ----------------------------------------------------------------:
hl.env("XCURSOR_THEME", "Empty-Butterfly-White")
hl.env("XCURSOR_SIZE", 24)
hl.config({
  general = {
    gaps_in     = 1,
    gaps_out    = 1,
    border_size = 1,
    
    layout = "dwindle",
    snap = {
      enabled        = true,
      window_gap     = 12,
      border_overlap = true,
      respect_gaps   = true,
    },
  },

  decoration = {
    active_opacity   = 0.96,
    inactive_opacity = 0.80,

    blur = {
      size       = 10,
      passes     = 4,
      noise      = 0.0,
      contrast   = 0.9,
      brightness = 0.9,
    }
  },
  dwindle = {
    preserve_split = true,
  },
  misc = {
    font_family = "JetBrainsMono Nerd Font",
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    focus_on_activate = true
  },
})


-- Animations -----------------------------------------------------------------:
hl.curve("bez1", { type = "bezier", points = {{ 0.25, 0.1 },{ 0.3, 1. }} })
hl.animation({
  enabled = true,
  leaf  = "windows",
  speed = 1.5,
  bezier = "bez1",
  style = "gnomed"
})
hl.animation({
  enabled = true,
  leaf  = "workspaces",
  speed = 1.5,
  bezier = "bez1",
  style = "slide"
})
hl.animation({
  enabled = true,
  leaf  = "specialWorkspace",
  speed = 1.5,
  bezier = "bez1",
  style = "slidefadevert"
})

