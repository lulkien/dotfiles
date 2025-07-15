pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "root:/utils"
import "root:/modules/common"
import "components"

PanelWindow {
    id: bar

    implicitHeight: Config.barHeight

    anchors {
        left: true
        top: true
        right: true
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Config.colors.background
    }

    NerdWidget {
        id: widget
        anchors.centerIn: parent
    }
}
