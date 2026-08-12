import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

// On-screen indicator for volume / brightness changes. One instance per
// monitor (see shell.qml). Watches a JSON state file written by
// scripts/osd.sh and pops a small pill for ~1.5s on each change.
PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    // --- state parsed from the watched file ---
    property string kind: "volume"
    property int value: 0
    property bool muted: false
    property real lastTs: -1
    property bool ready: false        // skips the initial load so we don't
    property bool showing: false      // pop the OSD at login / shell reload

    function handle(txt) {
        var d;
        try { d = JSON.parse(txt); } catch (e) { return; }
        if (!d || d.ts === undefined) return;

        root.kind = d.kind;
        root.value = d.value;
        root.muted = !!d.muted;

        // First load = current state on startup: remember it, stay hidden.
        if (!root.ready) { root.ready = true; root.lastTs = d.ts; return; }
        if (d.ts === root.lastTs) return;

        root.lastTs = d.ts;
        root.showing = true;
        hideTimer.restart();
    }

    // Layer / placement: an overlay pill floating above windows, bottom-center,
    // taking no exclusive space so it never shoves tiles around.
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusiveZone: 0

    anchors.bottom: true
    margins.bottom: 20

    color: "transparent"
    implicitWidth: 282
    implicitHeight: 24

    // Only map a surface while it's on screen (or fading out).
    visible: root.showing || pill.opacity > 0.01

    FileView {
        id: stateFile
        path: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/quickshell-osd.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.handle(text())
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.showing = false
    }

    // --- the pill ---
    Rectangle {
        id: pill
        anchors.fill: parent
        radius: Config.theme.radius
        color: Config.theme.background
        border.color: Config.theme.accent
        border.width: 1

        opacity: root.showing ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 8

            // icon
            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: Config.theme.iconSize + 8
                horizontalAlignment: Text.AlignHCenter
                font.family: Config.theme.fontIcon
                font.pixelSize: Config.theme.iconSize + 10
                color: root.muted ? Config.theme.muted : Config.theme.accent
                text: {
                    if (root.kind === "brightness") return "󰃠";
                    if (root.muted) return "󰝟";
                    if (root.value <= 0) return "󰕿";
                    if (root.value < 50) return "󰖀";
                    return "󰕾";
                }
            }

            // progress track + fill
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                // horizontalAlignment: pill.AlignHCenter
                width: parent.width - 72
                height: 3
                radius: 1
                color: Qt.rgba(1, 1, 1, 0.12)

                Rectangle {
                    height: parent.height
                    radius: parent.radius
                    width: parent.width * Math.max(0, Math.min(100, root.value)) / 100
                    color: root.muted ? Config.theme.muted : Config.theme.accent
                    Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                }
            }

            // percentage
            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                horizontalAlignment: Text.AlignRight
                font.family: Config.theme.fontText
                font.pixelSize: Config.theme.fontSize + 1
                color: Config.theme.foreground
                text: root.value + "%"
            }
        }
    }
}
