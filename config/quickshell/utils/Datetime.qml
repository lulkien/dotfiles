pragma Singleton

import QtQuick
import QtQml
import Quickshell

Singleton {
    id: root

    readonly property string datetime: self.datetime

    QtObject {
        id: self
        property string datetime: root.getCurrentDateTime()
    }

    Timer {
        id: updateDatetimeTimer
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            self.datetime = root.getCurrentDateTime();
        }
    }

    function getCurrentDateTime() {
        var now = new Date();
        return now.toLocaleString(Qt.locale(), "yyyy-MM-dd hh:mm:ss");
    }
}
