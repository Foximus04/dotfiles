import Quickshell
import QtQuick
import QtQuick.Layouts

// Bottom bar for a single monitor.
PanelWindow {
    id: bar

    required property var modelData
    screen: modelData

    anchors {
        left: true
        right: true
        bottom: true
    }
    implicitHeight: Config.theme.barHeight
    color: Config.theme.background

    // --- left: workspaces ---
    Workspaces {
        anchors.left: parent.left
        anchors.leftMargin: Config.theme.padding
        anchors.verticalCenter: parent.verticalCenter
        screenName: bar.screen ? bar.screen.name : ""
    }

    // --- center: clock ---
    Clock {
        anchors.centerIn: parent
    }

    // --- right: tray, keyboard, bluetooth, wifi, sound, battery ---
    RowLayout {
        anchors.right: parent.right
        anchors.rightMargin: Config.theme.padding
        anchors.verticalCenter: parent.verticalCenter
        spacing: Config.theme.spacing

        Tray {}

        KeyboardLayout {}

        LauncherButton { icon: ""; app: Config.settings.apps.bluetooth }  // bluetooth
        LauncherButton { icon: ""; app: Config.settings.apps.wifi }       // wifi
        LauncherButton { icon: ""; app: Config.settings.apps.sound }      // volume

        Battery {}
    }
}
