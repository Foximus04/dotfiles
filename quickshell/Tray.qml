import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// System tray. Collapsible: the arrow on the left edge toggles the icon list.
RowLayout {
    id: root

    property bool expanded: true
    spacing: Config.theme.spacing

    // collapse/expand arrow ( "<" when collapsed, ">" when expanded )
    Text {
        id: arrow
        text: root.expanded ? "⟩" : "⟨"
        font.family: Config.theme.fontIcon
        font.pixelSize: Config.theme.iconSize
        color: Config.theme.foreground
        verticalAlignment: Text.AlignVCenter
        Layout.alignment: Qt.AlignVCenter

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }
    }

    Repeater {
        model: root.expanded ? SystemTray.items : null

        delegate: Item {
            id: trayItem
            required property var modelData

            implicitWidth: Config.theme.iconSize
            implicitHeight: Config.theme.iconSize
            Layout.alignment: Qt.AlignVCenter

            IconImage {
                anchors.fill: parent
                source: trayItem.modelData.icon
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: function (mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        if (trayItem.modelData.onlyMenu)
                            menuAnchor.open();
                        else
                            trayItem.modelData.activate();
                    } else if (mouse.button === Qt.MiddleButton) {
                        trayItem.modelData.secondaryActivate();
                    } else if (mouse.button === Qt.RightButton) {
                        menuAnchor.open();
                    }
                }
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: trayItem.modelData.menu
                anchor.window: QsWindow.window
                anchor.item: trayItem
                anchor.edges: Edges.Top
                anchor.gravity: Edges.Top
            }
        }
    }
}
