pragma Singleton

import QtQuick
import Quickshell
import "../themes/cattpuccin_mocha.js" as Theme

Singleton {
    id: root
    readonly property color background: Theme.Pallete.Crust
    readonly property color text: Theme.Pallete.Text

    readonly property color rosewater: Theme.Pallete.RoseWater
    readonly property color flamingo: Theme.Pallete.Flamingo
    readonly property color pink: Theme.Pallete.Pink
    readonly property color mauve: Theme.Pallete.Mauve
    readonly property color red: Theme.Pallete.Red
    readonly property color maroon: Theme.Pallete.Maroon
    readonly property color peach: Theme.Pallete.Peach
    readonly property color yellow: Theme.Pallete.Yellow
    readonly property color green: Theme.Pallete.Green
    readonly property color teal: Theme.Pallete.Teal
    readonly property color sky: Theme.Pallete.Sky
    readonly property color sapphire: Theme.Pallete.Sapphire
    readonly property color blue: Theme.Pallete.Blue
    readonly property color lavender: Theme.Pallete.Lavender
    readonly property color subtext_1: Theme.Pallete.Subtext_1
    readonly property color subtext_0: Theme.Pallete.Subtext_0
    readonly property color overlay_2: Theme.Pallete.Overlay_2
    readonly property color overlay_1: Theme.Pallete.Overlay_1
    readonly property color overlay_0: Theme.Pallete.Overlay_0
    readonly property color surface_2: Theme.Pallete.Surface_2
    readonly property color surface_1: Theme.Pallete.Surface_1
    readonly property color surface_0: Theme.Pallete.Surface_0
    readonly property color base: Theme.Pallete.Base
    readonly property color mantle: Theme.Pallete.Mantle
    readonly property color crust: Theme.Pallete.Crust
}
