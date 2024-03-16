const hyprland = await Service.import("hyprland");
const notifications = await Service.import("notifications");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const systemtray = await Service.import("systemtray");
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

const date = Variable("", {
    poll: [2000, "date '+%A, %b %d | %R'"],
});

const COMPILED_STYLE_DIR = "/tmp/ags";

function ArchButton() {
    return Widget.Button({
        class_name: "arch-button",
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
        class_name: "workspaces",
        children: workspaces,
    });
}

function ClientTitle() {
    const title = hyprland.active.client
        .bind("title")
        .as((title) =>
            title.length >= 50 ? title.substring(0, 47) + "..." : title,
        );

    return Widget.Label({
        class_name: "client-title",
        label: title,
    });
}

function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    });
}

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
function Notification() {
    const popups = notifications.bind("popups");
    return Widget.Button({
        class_name: `notification${popups.as((p) => p.length > 0) ? "-new" : "-empty"}`,
        cursor: "pointer",
        child: Widget.Label({
            label: popups.as((p) => (p.length > 0 ? "󱅫" : "󰂚")),
        }),
    });
}
//
// function Media() {
//     const label = Utils.watch("", mpris, "player-changed", () => {
//         if (mpris.players[0]) {
//             const { track_artists, track_title } = mpris.players[0];
//             return `${track_artists.join(", ")} - ${track_title}`;
//         } else {
//             return "Nothing is playing";
//         }
//     });
//
//     return Widget.Button({
//         class_name: "media",
//         on_primary_click: () => mpris.getPlayer("")?.playPause(),
//         on_scroll_up: () => mpris.getPlayer("")?.next(),
//         on_scroll_down: () => mpris.getPlayer("")?.previous(),
//         child: Widget.Label({ label }),
//     });
// }

// function Volume() {
//     const icons = {
//         101: "overamplified",
//         67: "high",
//         34: "medium",
//         1: "low",
//         0: "muted",
//     };
//
//     function getIcon() {
//         const icon = audio.speaker.is_muted
//             ? 0
//             : [101, 67, 34, 1, 0].find(
//                   (threshold) => threshold <= audio.speaker.volume * 100,
//               );
//
//         return `audio-volume-${icons[icon]}-symbolic`;
//     }
//
//     const icon = Widget.Icon({
//         icon: Utils.watch(getIcon(), audio.speaker, getIcon),
//     });
//
//     const slider = Widget.Slider({
//         hexpand: true,
//         draw_value: false,
//         on_change: ({ value }) => (audio.speaker.volume = value),
//         setup: (self) =>
//             self.hook(audio.speaker, () => {
//                 self.value = audio.speaker.volume || 0;
//             }),
//     });
//
//     return Widget.Box({
//         class_name: "volume",
//         css: "min-width: 180px",
//         children: [icon, slider],
//     });
// }

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
        class_name: "systemtray",
        children: items,
    });
}

function Left() {
    return Widget.Box({
        spacing: 8,
        children: [ArchButton(), Workspaces(), ClientTitle()],
    });
}

function Center() {
    return Widget.Box({
        spacing: 8,
        // children: [Media(), Notification()],
        children: [Clock()],
    });
}

function Right() {
    return Widget.Box({
        hpack: "end",
        spacing: 8,
        children: [SysTray(), Notification()],
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
