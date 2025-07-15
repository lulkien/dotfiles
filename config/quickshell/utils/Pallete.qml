pragma Singleton

import QtQuick
import Quickshell
import "../themes/cattpuccin_mocha.js" as Theme

Singleton {
    id: root
    readonly property color background: Theme.Pallete.Crust
    readonly property color text: Theme.Pallete.Text
}
