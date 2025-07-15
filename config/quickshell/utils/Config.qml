pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property var colors: Pallete
    readonly property real barHeight: 50
}
