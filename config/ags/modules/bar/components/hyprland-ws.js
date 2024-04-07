import Widget from "resource:///com/github/Aylur/ags/widget.js";

const Hyprland = await Service.import("hyprland");

export const Workspaces = () => {
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
};
