import Quickshell
import QtQuick

// Date + clock. Click toggles a secondary "weekday, week ww" view.
Item {
    id: root

    property bool secondary: false

    implicitWidth: lbl.implicitWidth
    implicitHeight: lbl.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        id: lbl
        anchors.centerIn: parent
        color: Config.theme.foreground
        font.family: Config.theme.fontText
        font.pixelSize: Config.theme.fontSize
        text: root.secondary
            ? Qt.formatDateTime(clock.date, "dddd") + ", week " + Funcs.weekOfYear(clock.date)
            : Qt.formatDateTime(clock.date, "dd/MM/yy │ HH:mm:ss")
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.secondary = !root.secondary
    }
}
