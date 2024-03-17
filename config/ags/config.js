const hyprland = await Service.import("hyprland");
const notifications = await Service.import("notifications");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const bluetooth = await Service.import("bluetooth");
const systemtray = await Service.import("systemtray");
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

const date = Variable("", {
    poll: [2000, "date '+%A, %b %d | %R'"],
});

const COMPILED_STYLE_DIR = "/tmp/ags";

function ArchButton() {
    return Widget.Button({
        class_names: ["arch-button", "left-item", "bar-item", "box-item"],
        cursor: "pointer",
        child: Widget.Label("󰣇"),
    });
}

function Workspaces() {
    const activeId = hyprland.active.workspace.bind("id");

    const workspaces = hyprland.bind("workspaces").as((ws) => {
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
                    hyprland.messageAsync(`dispatch workspace ${id}`),
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
    const items = systemtray.bind("items").as((items) =>
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

function BluetoothIndicator() {
    return Widget.Button({
        class_names: ["bluetooth-indicator", "system-indicator-button"],
        child: Widget.Label("󰂯"),
        on_clicked: () => {
            Utils.execAsync(["blueman-manager"]);
        },
    });
}

function SysIndicator() {
    return Widget.Box({
        class_names: ["system-indicator", "right-item", "bar-item", "box-item"],
        children: [BluetoothIndicator()],
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

function Bar(monitor = 0) {
    return Widget.Window({
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
}

// Parse config
async function applyStyle() {
    Utils.exec(`mkdir -p ${COMPILED_STYLE_DIR}`);
    Utils.exec(
        `sass ${App.configDir}/style/main.scss ${COMPILED_STYLE_DIR}/style.css`,
    );
    App.resetCss();
    App.applyCss(`${COMPILED_STYLE_DIR}/style.css`);
}
applyStyle().catch(print);

App.config({
    onConfigParsed: () => {
        Utils.monitorFile(`${App.configDir}/style`, function () {
            applyStyle();
        });
    },
    windows: [Bar(0)],
    style: `${COMPILED_STYLE_DIR}/style.css`,
});

export {};
