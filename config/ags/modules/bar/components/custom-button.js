import Widget from "resource:///com/github/Aylur/ags/widget.js";

export const ArchButton = () => {
    return Widget.Button({
        class_names: ["arch-button", "left-item", "bar-item", "box-item"],
        cursor: "pointer",
        child: Widget.Label("󰣇"),
    });
};
