import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

// Battery state icon + percentage. Click opens btop (configurable) floating.
Item {
    id: root

    readonly property var dev: UPower.displayDevice
    // Quickshell reports percentage as a 0..1 fraction.
    readonly property real percent: dev ? dev.percentage * 100 : 0
    readonly property bool charging: dev && dev.state === UPowerDeviceState.Charging

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: Funcs.batteryIcon(root.percent, root.charging)
            color: Config.theme.foreground
            font.family: Config.theme.fontIcon
            font.pixelSize: Config.theme.iconSize
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: Math.round(root.percent) + "%"
            color: Config.theme.foreground
            font.family: Config.theme.fontText
            font.pixelSize: Config.theme.fontSize
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Funcs.launchOrFocus(Config.settings.apps.battery)
    }
}
