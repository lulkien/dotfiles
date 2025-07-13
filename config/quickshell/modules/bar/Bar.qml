pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../utils"
import "../common"

PanelWindow {
    id: bar

    implicitHeight: 50

    anchors {
        left: true
        top: true
        right: true
    }

    Rectangle {
      id: bg
      anchors.fill: parent
      color: Theme.background
    }

    CssRectangle {
      anchors.centerIn: parent
    }

    Text {
      id: text
      anchors.centerIn: parent
      color: Theme.text
      text: Datetime.datetime
    }

}
