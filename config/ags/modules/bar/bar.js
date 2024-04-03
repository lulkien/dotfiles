const Hyprland = await Service.import("hyprland");
const Notifications = await Service.import("notifications");
const Bluetooth = await Service.import("bluetooth");
const Network = await Service.import("network");
const Systemtray = await Service.import("systemtray");
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

const date = Variable("", {
    poll: [2000, "date '+%A, %b %d | %R'"],
});

function ArchButton() {
    return Widget.Button({
        class_names: ["arch-button", "left-item", "bar-item", "box-item"],
        cursor: "pointer",
        child: Widget.Label("󰣇"),
    });
}

function Workspaces() {
    const activeId = Hyprland.active.workspace.bind("id");

    const workspaces = Hyprland.bind("workspaces").as((ws) => {
        const ws_full = Array.from({ length: 10 }, (_, index) => {
            const id = index + 1;
            const entry = ws.find((item) => item.id === id);
            const occupied = entry ? entry.windows > 0 : false;
            return {
                id: id,
                occupied: occupied,
            };
        });

        return ws_full.map(({ id, occupied }) =>
            Widget.Button({
                class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
                child: Widget.Label(`${occupied ? "" : ""}`),
                on_clicked: () =>
                    Hyprland.messageAsync(`dispatch workspace ${id}`),
            }),
        );
    });

    return Widget.Box({
        class_names: ["workspaces", "left-item", "bar-item", "box-item"],
        children: workspaces,
    });
}

function Clock() {
    return Widget.Label({
        class_names: ["clock", "center-item", "bar-item", "box-item"],
        label: date.bind(),
    });
}

function SysTray() {
    const items = Systemtray.bind("items").as((items) =>
        items.map((item) =>
            Widget.Button({
                class_name: "tray-icon",
                child: Widget.Icon({
                    icon: item.bind("icon"),
                    css: "font-size: 20px",
                }),
                cursor: "pointer",
                on_primary_click: (_, event) => item.activate(event),
                on_secondary_click: (_, event) => item.openMenu(event),
                tooltip_markup: item.bind("tooltip_markup"),
            }),
        ),
    );

    return Widget.Box({
        class_names: ["systemtray", "right-item", "bar-item", "box-item"],
        children: items,
    });
}

function NotiIndicator() {
    const notifications = Notifications.bind("notifications");

    return Widget.Button({
        class_names: ["noti-indicator", "system-indicator-button"],
        child: Widget.Label({
            class_name: notifications.as((n) =>
                n.length > 0 ? "new-message" : "empty",
            ),
            label: notifications.as((n) => (n.length > 0 ? "󱅫" : "󰂚")),
        }),
        on_secondary_click: () => {
            Notifications.clear();
        },
    });
}

function BluetoothIndicator() {
    const connected_devices = Bluetooth.bind("connected-devices");

    return Widget.Button({
        class_names: ["bluetooth-indicator", "system-indicator-button"],
        child: Widget.Label({
            class_name: connected_devices.as((d) =>
                d.length > 0 ? "connected" : "disconnected",
            ),
            label: connected_devices.as((d) => (d.length > 0 ? "󰂱" : "󰂯")),
        }),
        on_primary_click: () => {
            Utils.execAsync(["blueman-manager"]);
        },
    });
}

const WifiIndicator = () => {
    const internet = Network.wifi.bind("internet");

    return Widget.Button({
        class_names: ["network-indicator", "system-indicator-button"],
        child: Widget.Label({
            class_name: internet.as((i) =>
                i === "connected" ? "connected" : "disconnected",
            ),
            label: internet.as((i) => (i === "connected" ? "󰖩" : "󰖪")),
        }),
    });
};

const WiredIndicator = () =>
    Widget.Icon({
        icon: Network.wired.bind("icon_name"),
    });

const NetworkIndicator = () =>
    Widget.Stack({
        children: {
            wifi: WifiIndicator(),
            wired: WiredIndicator(),
        },
        shown: Network.bind("primary").as((p) => p || "wifi"),
    });

function SysIndicator() {
    return Widget.Box({
        class_names: ["system-indicator", "right-item", "bar-item", "box-item"],
        children: [BluetoothIndicator(), NetworkIndicator(), NotiIndicator()],
    });
}

function Left() {
    return Widget.Box({
        children: [ArchButton(), Workspaces()],
    });
}

function Center() {
    return Widget.Box({
        children: [Clock()],
    });
}

function Right() {
    return Widget.Box({
        hpack: "end",
        children: [SysTray(), SysIndicator()],
    });
}

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
