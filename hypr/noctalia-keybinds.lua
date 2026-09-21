hl.unbind("XF86AudioRaiseVolume")

hl.bind("XF86AudioRaiseVolume",   	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 0.05+"), 	{ repeating = true, locked = true })

hl.unbind("XF86AudioLowerVolume")
hl.bind("XF86AudioLowerVolume",   	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 0.05-"), 	{ repeating = true, locked = true })

hl.unbind("XF86AudioMute")
hl.bind("XF86AudioMute",          	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"),  	{ repeating = true, locked = true })

hl.unbind("XF86AudioMicMute")
hl.bind("XF86AudioMicMute",       	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),	{ repeating = true, locked = true })

hl.unbind("XF86MonBrightnessUp")
hl.bind("XF86MonBrightnessUp",    	hl.dsp.exec_cmd("brightnessctl --class=backlight s 10%+"), 	 { locked = true, repeating = true })

hl.unbind("XF86MonBrightnessDown")
hl.bind("XF86MonBrightnessDown",  	hl.dsp.exec_cmd("brightnessctl --class=backlight s 10%-"), 	 { locked = true, repeating = true })

hl.unbind("SUPER + SPACE")
hl.bind("SUPER + SPACE", 			  hl.dsp.exec_cmd("noctalia msg panel-open launcher"))
hl.unbind("SUPER + CTRL + SPACE")
hl.bind("SUPER + CTRL + SPACE", hl.dsp.exec_cmd("noctalia msg panel-open control-center"))
hl.unbind("SUPER + ALT + SPACE")
hl.bind("SUPER + ALT + SPACE",  hl.dsp.exec_cmd("noctalia msg settings-open"))
