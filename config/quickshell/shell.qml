import QtQuick
import Quickshell
import "modules/bar"

ShellRoot {
    LazyLoader {
        id: bar
        activeAsync: true
        Bar {}
    }
}
