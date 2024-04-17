// import Widget from "resource:///com/github/Aylur/ags/widget.js";

const SystemTray = await Service.import("systemtray");

const SysTrayItem = (item) => {
    return Widget.Button({
        class_name: "systemtray-item",
        child: Widget.Icon({
            class_name: "systemtray-icon",
            icon: item.bind("icon"),
        }),
        tooltip_markup: item.bind("tooltip_markup"),
        // setup: (self) => {
        //     const menu = item.menu;
        //     if (!menu) return;
        //
        //     const id = item.menu?.connect("popped-up", () => {
        //         self.toggleClassName("active");
        //         menu.connect("notify::visible", () => {
        //             self.toggleClassName("active", menu.visible);
        //         });
        //         menu.disconnect(id);
        //     });
        //
        //     if (id) self.connect("destroy", () => item.menu?.disconnect(id));
        // },
        on_primary_click: (_, event) => {
            item.activate(event);
        },
        on_secondary_click: (_, event) => {
            item.openMenu(event);
        },
    });
};

export const SysTray = () => {
    return Widget.Box({
        class_names: ["systemtray", "right-item", "bar-item", "box-item"],
        children: SystemTray.bind("items").as((i) => i.map(SysTrayItem)),
    });
};
