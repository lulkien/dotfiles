import Quickshell
import "modules/bar"

ShellRoot {
    LazyLoader {
        active: true
        Bar {}
    }
}
