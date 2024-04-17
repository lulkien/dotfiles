import Widget from "resource:///com/github/Aylur/ags/widget.js";

import { ArchButton } from "./components/custom-button.js";
import { Workspaces } from "./components/hyprland-ws.js";
import { Clock } from "./components/date-time.js";
import { SysTray } from "./components/system-tray.js";
import { SysIndicator } from "./components/system-indicator.js";

const Left = () => {
    return Widget.Box({
        children: [ArchButton(), Workspaces()],
    });
};

const Center = () => {
    return Widget.Box({
        children: [Clock()],
    });
};

const Right = () => {
    return Widget.Box({
        hpack: "end",
        children: [SysTray(), SysIndicator()],
    });
};

export const Bar = (monitor = 0) =>
    Widget.Window({
        name: `bar-${monitor}`,
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            center_widget: Center(),
            end_widget: Right(),
        }),
    });
