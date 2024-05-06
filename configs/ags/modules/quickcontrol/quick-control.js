export const QuickControl = (monitor = 0) => {
    return Widget.Window({
        monitor,
        name: `quickcontrol${monitor}`,
        class_name: "quickcontrol",
        anchors: ["top"],
        exclusivity: "ignore",
        layer: "overlay",
    });
};
