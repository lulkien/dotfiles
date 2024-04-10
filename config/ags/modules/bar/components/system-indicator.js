import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
// import Widget from "resource:///com/github/Aylur/ags/widget.js";

const Notifications = await Service.import("notifications");
const Bluetooth = await Service.import("bluetooth");
const Network = await Service.import("network");

const NotiIndicator = () => {
    const notifications = Notifications.bind("notifications");
    const popups = Notifications.bind("popups");

    return Widget.Button({
        class_names: ["noti-indicator", "system-indicator-button"],
        child: Widget.Label({
            class_name: notifications.as((n) =>
                n.length > 0 ? "new-message" : "empty",
            ),
            label: notifications.as((n) => (n.length > 0 ? "󱅫" : "󰂚")),
        }),
        tooltip_text: notifications.as((n) =>
            n.length < 2
                ? `${n.length} notification`
                : `${n.length} notifications`,
        ),
        on_secondary_click: () => {
            Notifications.clear();
        },
    });
};

const BluetoothIndicator = () => {
    const connected_devices = Bluetooth.bind("connected-devices");

    return Widget.Button({
        class_names: ["bluetooth-indicator", "system-indicator-button"],
        child: Widget.Label({
            class_name: connected_devices.as((devices) =>
                devices.length > 0 ? "connected" : "disconnected",
            ),
            label: connected_devices.as((devices) =>
                devices.length > 0 ? "󰂱" : "󰂯",
            ),
        }),
        tooltip_text: connected_devices.as((devices) =>
            devices.length > 0 ? devices[0].name : "Unknown",
        ),
        on_primary_click: () => {
            Utils.execAsync(["blueman-manager"]);
        },
    });
};

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
        tooltip_text: Network.wifi.bind("ssid").as((ssid) => ssid || "Unknown"),
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

export const SysIndicator = () => {
    return Widget.Box({
        class_names: ["system-indicator", "right-item", "bar-item", "box-item"],
        children: [BluetoothIndicator(), NetworkIndicator(), NotiIndicator()],
    });
};
