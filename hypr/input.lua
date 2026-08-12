
-- Input ----------------------------------------------------------------------:
hl.config({
  input = {
    kb_layout  = "gb,no",
    kb_options = "grp:alt_shift_toggle",

    repeat_rate  = 80,
    repeat_delay = 250,

    sensitivity   = 0.35,
    accel_profile = "flat",
    
    touchpad = {
      natural_scroll       = true,
      clickfinger_behavior = true,
      scroll_factor        = 0.4,
      disable_while_typing = true,
    },
  },
})
hl.gesture({ 
  fingers   = 3,
  direction = "horizontal", 
  action    = "workspace",
})

