import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// Workspace indicators for one monitor. Renders a fixed id list (from config)
// so empty workspaces still show (dimmed). The monitor's active workspace is
// full opacity + accent colour.
RowLayout {
    id: root

    property string screenName: ""
    spacing: Config.theme.spacing

    readonly property var wsIds: (Config.settings.monitors && Config.settings.monitors[screenName])
        ? Config.settings.monitors[screenName] : []

    readonly property var monitor: {
        var ms = Hyprland.monitors.values;
        for (var i = 0; i < ms.length; i++)
            if (ms[i].name === screenName)
                return ms[i];
        return null;
    }
    readonly property int activeWsId: (monitor && monitor.activeWorkspace) ? monitor.activeWorkspace.id : -1

    Repeater {
        model: root.wsIds

        delegate: Item {
            id: ws

            required property var modelData
            readonly property int wsId: modelData
            readonly property var hw: {
                var list = Hyprland.workspaces.values;
                for (var i = 0; i < list.length; i++)
                    if (list[i].id === wsId)
                        return list[i];
                return null;
            }
            readonly property bool exists: hw !== null
            readonly property bool active: wsId === root.activeWsId
            readonly property var cfg: (Config.settings.workspaces && Config.settings.workspaces[String(wsId)])
                ? Config.settings.workspaces[String(wsId)] : null

            implicitWidth: Math.max(lbl.implicitWidth + Config.theme.padding, Config.theme.fontSize)
            implicitHeight: lbl.implicitHeight
            Layout.alignment: Qt.AlignVCenter
            opacity: active ? 1.0 : (exists ? 1.0 : Config.theme.inactiveOpacity)

            Text {
                id: lbl
                anchors.centerIn: parent
                text: ws.active
                    ? (ws.cfg ? ws.cfg.active : String(ws.wsId))
                    : (ws.cfg ? ws.cfg.inactive : String(ws.wsId))
                color: ws.active ? Config.theme.accent : Config.theme.foreground
                font.family: Config.theme.fontText
                font.pixelSize: Config.theme.fontSize
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Funcs.gotoWorkspace(ws.wsId)
            }
        }
    }
}
