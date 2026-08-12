pragma Singleton

import Quickshell
import QtQuick

// Shared helper functions.
Singleton {
    id: root

    // Week-of-year, Monday-first, matching `date +%W`
    // (days before the first Monday are week 00).
    function weekOfYear(date) {
        var d = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        var start = new Date(date.getFullYear(), 0, 1);
        var yday = Math.round((d - start) / 86400000);   // 0-based day of year
        var wdayMon0 = (d.getDay() + 6) % 7;             // Mon=0 .. Sun=6
        var w = Math.floor((yday + 7 - wdayMon0) / 7);
        return (w < 10 ? "0" : "") + w;
    }

    // Focus an existing window for `app`, or launch it floating
    // (float = true, size = {W, H}). Mirrors the launch(focus=true) helper in
    // ~/.config/hypr/keybinds.lua. This Hyprland evaluates dispatch input as
    // Lua, so we send a closure that returns the right dispatcher.
    function launchOrFocus(app) {
        if (!app)
            return;
        var sz = (Config.settings.floatSize && Config.settings.floatSize.length === 2)
            ? Config.settings.floatSize : [1000, 600];
        var program = "kitty --app-id=" + app + " -e " + app;
        var lua =
            '(function() for _, w in ipairs(hl.get_windows() or {}) do '
            + 'if w.class and string.lower(w.class) == "' + app + '" then '
            + 'return hl.dsp.focus({ window = w }) end end '
            + 'return hl.dsp.exec_cmd("' + program + '", { float = true, size = { ' + sz[0] + ', ' + sz[1] + ' } }) end)()';
        Quickshell.execDetached(["hyprctl", "dispatch", lua]);
    }

    // Switch to a workspace via the Lua dispatcher.
    function gotoWorkspace(id) {
        Quickshell.execDetached(["hyprctl", "dispatch", 'hl.dsp.focus({ workspace = "' + id + '" })']);
    }

    // Nerd Font (Material Design icons) battery glyph for a 0..100 percentage.
    function batteryIcon(percent, charging) {
        if (charging)
            return String.fromCodePoint(0xF0084);     // md-battery-charging
        if (percent >= 95)
            return String.fromCodePoint(0xF0079);     // md-battery (full)
        if (percent < 10)
            return String.fromCodePoint(0xF0083);     // md-battery-alert
        var tens = Math.floor(percent / 10);          // 1..9
        return String.fromCodePoint(0xF0079 + tens);  // md-battery-10 .. md-battery-90
    }
}
