import Quickshell
import QtQuick

// Generic icon button that launches a TUI app floating (bluetui/nmtui/wiremix).
Item {
    id: root

    property string icon: ""
    property string app: ""
    property color color: Config.theme.foreground

    implicitWidth: lbl.implicitWidth + Config.theme.padding
    implicitHeight: lbl.implicitHeight

    Text {
        id: lbl
        anchors.centerIn: parent
        text: root.icon
        color: root.color
        font.family: Config.theme.fontIcon
        font.pixelSize: Config.theme.iconSize + 6
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Funcs.launchOrFocus(root.app)
    }
}
