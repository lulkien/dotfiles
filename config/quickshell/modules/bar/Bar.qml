pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "root:/utils"
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

    RightRegion {
        id: rightRegion
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 10
        }
    }
}
