import Quickshell
import QtQml

// Root config. One Bar per connected monitor.
ShellRoot {
    // Disable hot-reload-on-save: quickshell's PopupAnchor (used by the tray's
    // QsMenuAnchor) segfaults during the reload teardown under Qt 6.11
    // (PopupAnchor::onItemWindowChanged null-derefs the window). Apply .qml
    // edits with a manual restart instead. theme.json/config.json still
    // hot-reload via Config.qml's own FileView, which is unaffected.
    QtObject {
        Component.onCompleted: Quickshell.watchFiles = false
    }

    Variants {
        model: Quickshell.screens

        Bar {}
    }

    // Volume / brightness OSD, one per monitor.
    Variants {
        model: Quickshell.screens

        Osd {}
    }
}
