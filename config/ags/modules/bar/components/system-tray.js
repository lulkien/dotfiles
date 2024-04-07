import Widget from "resource:///com/github/Aylur/ags/widget.js";
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js";

const { Box, Icon, Button, Revealer } = Widget;
const { Gravity } = imports.gi.Gdk;

const SysTrayItem = (item) =>
    Button({
        className: "tray-icon",
        child: Icon({
            hpack: "center",
            icon: item.icon,
            setup: (self) => self.hook(item, (self) => (self.icon = item.icon)),
        }),
        setup: (self) =>
            self.hook(
                item,
                (self) => (self.tooltipMarkup = item["tooltip-markup"]),
            ),
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (btn, event) =>
            item.menu.popup_at_widget(btn, Gravity.SOUTH, Gravity.NORTH, null),
    });

export const Tray = (props = {}) => {
    const trayContent = Box({
        class_names: ["systemtray", "right-item", "bar-item", "box-item"],
        setup: (self) =>
            self.hook(SystemTray, (self) => {
                self.children = SystemTray.items.map(SysTrayItem);
                self.show_all();
            }),
    });
    const trayRevealer = Revealer({
        revealChild: true,
        transition: "slide_left",
        transitionDuration: 500,
        child: trayContent,
    });
    return Box({
        ...props,
        children: [trayRevealer],
    });
};

export const SysTray = () => {
    const items = SystemTray.bind("items").as((items) =>
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
};
