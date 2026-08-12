import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

// Active keyboard layout (e.g. "GB" / "NO"). Click cycles to the next layout.
Item {
    id: root

    property string layout: "?"

    implicitWidth: lbl.implicitWidth + Config.theme.padding
    implicitHeight: lbl.implicitHeight

    function shortName(full) {
        var map = Config.settings.layoutNames || {};
        if (map[full])
            return map[full];
        return full ? full.substring(0, 2).toUpperCase() : "?";
    }

    // Initial layout read (events keep it updated afterwards).
    Process {
        id: queryProc
        command: ["sh", "-c", "hyprctl devices -j | jq -r '[.keyboards[] | select(.main==true) | .active_keymap][0] // empty'"]
        stdout: StdioCollector {
            onStreamFinished: {
                var t = text.trim();
                if (t.length)
                    root.layout = root.shortName(t);
            }
        }
    }

    Component.onCompleted: queryProc.running = true

    // Hyprland emits "activelayout>>keyboard,LayoutName" on every switch.
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                var parts = event.data.split(",");
                root.layout = root.shortName(parts[parts.length - 1]);
            }
        }
    }

    Text {
        id: lbl
        anchors.centerIn: parent
        text: root.layout
        color: Config.theme.foreground
        font.family: Config.theme.fontText
        font.pixelSize: Config.theme.fontSize
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
    }
}
