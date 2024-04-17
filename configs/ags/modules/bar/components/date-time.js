// import Widget from "resource:///com/github/Aylur/ags/widget.js";

const datetime = Variable("", {
    poll: [2000, "date '+%A, %b %d | %R'"],
});

export const Clock = () => {
    return Widget.Label({
        class_names: ["clock", "center-item", "bar-item", "box-item"],
        label: datetime.bind(),
    });
};
