pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Central config + theme. Backed by config/theme.json and config/config.json,
// both watched for changes so edits hot-reload into the running bar.
Singleton {
    id: root

    property var theme: defaultTheme
    property var settings: defaultSettings

    readonly property var defaultTheme: ({
        "background": "#1e1e2e",
        "foreground": "#cdd6f4",
        "accent": "#89b4fa",
        "muted": "#6c7086",
        "urgent": "#f38ba8",
        "fontText": "JetBrainsMono Nerd Font",
        "fontIcon": "JetBrainsMono Nerd Font Mono",
        "fontSize": 13,
        "iconSize": 15,
        "barHeight": 30,
        "padding": 8,
        "spacing": 10,
        "radius": 6,
        "inactiveOpacity": 0.45
    })

    readonly property var defaultSettings: ({
        "monitors": { "eDP-1": [1, 2, 3, 4, 5], "HDMI-A-1": [6, 7, 8, 9, 10] },
        "workspaces": {},
        "layoutNames": { "English (UK)": "GB", "Norwegian": "NO" },
        "apps": { "bluetooth": "bluetui", "wifi": "nmtui", "sound": "wiremix", "battery": "btop" },
        "floatSize": [1000, 600]
    })

    function merge(base, overrides) {
        var out = {};
        for (var k in base) out[k] = base[k];
        for (var j in overrides) out[j] = overrides[j];
        return out;
    }

    function loadTheme() {
        try {
            root.theme = merge(defaultTheme, JSON.parse(themeFile.text()));
        } catch (e) {
            console.warn("[Config] theme.json parse error:", e);
        }
    }

    function loadSettings() {
        try {
            root.settings = merge(defaultSettings, JSON.parse(cfgFile.text()));
        } catch (e) {
            console.warn("[Config] config.json parse error:", e);
        }
    }

    FileView {
        id: themeFile
        path: Qt.resolvedUrl("config/theme.json")
        blockLoading: true
        watchChanges: true
        onLoaded: root.loadTheme()
        onFileChanged: reload()
    }

    FileView {
        id: cfgFile
        path: Qt.resolvedUrl("config/config.json")
        blockLoading: true
        watchChanges: true
        onLoaded: root.loadSettings()
        onFileChanged: reload()
    }
}
